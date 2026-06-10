#!/usr/bin/env python3
"""PreToolUse hook: block Bash commands that walk outside the workspace.

Walking the macOS filesystem (find /, find ~, mdfind, locate) triggers
iCloud to download every offloaded file under synced directories
(Desktop, Documents, ...).  The user has forbidden this three times
across separate incidents (2026-04-21, 2026-05-09, 2026-06-10) — see
tasks/memory/feedback_no_home_search.md.

Memory rules I can ignore under task focus.  This hook fires before
the Bash call reaches the simulator, so it stops the violation before
the cost is incurred.

Protocol: PreToolUse hooks receive the tool invocation as JSON on
stdin.  Exit 0 to allow.  Exit non-zero to block; stderr is shown
back to the agent so it knows which rule fired and where to read the
full context.
"""
from __future__ import annotations
import json
import re
import shlex
import sys

WORKSPACE_MAC = "/Users/ravn/z80"
WORKSPACE_LINUX = "/home/ravn/z80"

# Paths that are OK as filesystem roots for walking commands.
ALLOWED_PREFIXES = (
    WORKSPACE_MAC,
    WORKSPACE_LINUX,
    "/tmp/",
    "/tmp",
    "/private/tmp",
    "/dev/",
    "/dev",
    "./",
    ".",
)


FORBIDDEN_ROOTS = ("Users", "home", "Volumes", "private", "opt", "usr")


def is_forbidden_path(arg: str) -> bool:
    """A bare `/`, `~`, `/Users/...` outside the workspace, etc."""
    if not arg or arg.startswith("-"):
        return False
    p = arg
    if p == "/" or p == "~" or p.startswith("~/"):
        return True
    if p.startswith(ALLOWED_PREFIXES):
        return False
    # Strip trailing slash so /Volumes and /Volumes/ both check.
    p_norm = p.rstrip("/")
    parts = p_norm.split("/")
    # parts[0] is empty for absolute paths.  parts[1] is the first level.
    if len(parts) >= 2 and parts[0] == "" and parts[1] in FORBIDDEN_ROOTS:
        return True
    return False


def check(cmd: str) -> tuple[bool, str]:
    """Return (blocked, reason)."""
    # 1. mdfind / locate are categorically banned (whole-disk by design).
    if re.search(r"\bmdfind\b", cmd):
        return True, "mdfind — Spotlight indexes the whole disk"
    if re.search(r"\blocate\b(?!\.)", cmd):  # not 'locateXXX'
        return True, "locate — walks the whole disk via the locate database"

    # 2. Tokenize command pipeline.  Walk pipe segments; check each one.
    # shlex doesn't handle '&&'/'||'/'|' as separators but our patterns work
    # per word anyway — just split by whitespace + |/&/; for command starts.
    try:
        tokens = shlex.split(cmd, posix=True)
    except ValueError:
        return False, ""  # malformed quoting; let it through

    # Find segments starting with find/ls/grep and check their path args.
    i = 0
    while i < len(tokens):
        tok = tokens[i]
        # Reset on shell delimiters that start a new command word.
        if tok in (";", "&&", "||", "|", "&"):
            i += 1
            continue

        if tok in ("find", "/bin/find", "/usr/bin/find"):
            # find PATH... [args]
            j = i + 1
            while j < len(tokens) and not tokens[j].startswith("-") and tokens[j] not in (";","&&","||","|","&"):
                if is_forbidden_path(tokens[j]):
                    return True, f"find with forbidden root: {tokens[j]}"
                j += 1
            i = j
            continue

        if tok in ("ls", "/bin/ls"):
            # ls [args] PATH...
            j = i + 1
            while j < len(tokens) and tokens[j] not in (";","&&","||","|","&"):
                if not tokens[j].startswith("-") and is_forbidden_path(tokens[j]):
                    return True, f"ls with forbidden path: {tokens[j]}"
                j += 1
            i = j
            continue

        if tok in ("grep", "/usr/bin/grep", "/bin/grep", "egrep", "fgrep", "rgrep"):
            # Only block recursive grep at forbidden roots.
            recursive = False
            j = i + 1
            paths_after_pattern: list[str] = []
            seen_pattern = False
            while j < len(tokens) and tokens[j] not in (";","&&","||","|","&"):
                a = tokens[j]
                if a.startswith("-") and (("r" in a[1:]) or "R" in a[1:] or a == "--recursive" or a == "-r" or a == "-R"):
                    if a.startswith("--"):
                        if a == "--recursive":
                            recursive = True
                    else:
                        if "r" in a or "R" in a:
                            recursive = True
                if not a.startswith("-"):
                    if not seen_pattern:
                        seen_pattern = True  # first non-flag = pattern
                    else:
                        paths_after_pattern.append(a)
                j += 1
            if recursive:
                for p in paths_after_pattern:
                    if is_forbidden_path(p):
                        return True, f"grep -r with forbidden root: {p}"
            i = j
            continue

        i += 1

    return False, ""


def main() -> int:
    try:
        data = json.load(sys.stdin)
    except Exception:
        return 0  # malformed input — let the simulator handle it

    if data.get("tool_name") != "Bash":
        return 0

    cmd = data.get("tool_input", {}).get("command", "")
    if not cmd:
        return 0

    blocked, reason = check(cmd)
    if blocked:
        sys.stderr.write(
            f"BLOCKED by tasks/hooks/block-icloud-walk.py\n"
            f"Reason: {reason}\n"
            f"Rule:   tasks/memory/feedback_no_home_search.md\n"
            f"\n"
            f"Walking outside the workspace ({WORKSPACE_MAC} on macOS,\n"
            f"{WORKSPACE_LINUX} on Linux) triggers iCloud downloads on\n"
            f"synced directories and has been forbidden by the user\n"
            f"three times in separate incidents.\n"
            f"\n"
            f"Fix:    ask the user where the target file/tool lives,\n"
            f"        or scope the search to a known sub-path inside\n"
            f"        the workspace.  Widening the search is NEVER\n"
            f"        the right move when a narrow lookup fails.\n"
            f"\n"
            f"Rejected command:\n"
            f"  {cmd}\n"
        )
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())

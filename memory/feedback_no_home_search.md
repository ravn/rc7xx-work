---
name: Workspace-only search — NEVER TRAVERSE HOME
description: HARD RULE. /Users/ravn/z80/ traversal OK; everything else under /Users/ravn/ (home dir) is STRICTLY OFF-LIMITS including for ls, find, glob, grep
type: feedback
originSessionId: 5b9c19fb-ae78-45c7-b86e-c8b8135e5b92
---
**HARD RULE, repeated: never ever traverse /Users/ravn/ (the home directory).**

`/Users/ravn/z80/` is the workspace — traversal inside it is fine. Anything outside it — including `/Users/ravn/` itself, `~/Documents`, `~/.local`, `/Users/ravn/git/*`, any `~/foo` path — is OFF LIMITS for `find`, `ls`, `Glob`, `Grep`, agent searches. This applies even to narrow queries like `find /Users/ravn -name diskdefs` or `ls ~/.local/share/cpmtools`. Do not look.

**Why:** Privacy. The user has clarified this forcefully (most recently 2026-04-21: "NEVER EVER TRAVERSE MY HOME DIRECTORY! PLEASE REMEMBER THAT!" — because I ran `find /Users/ravn -name diskdefs -maxdepth 6`).

**How to apply:**
- Inside-workspace is fine: `ls /Users/ravn/z80/...`, `Grep path=/Users/ravn/z80/...`, `find /Users/ravn/z80/...`.
- Outside-workspace is never: no `find ~`, no `find /Users/ravn`, no `ls /Users/ravn/Downloads`, no `ls ~/.local`, no `grep -r /Users/ravn/git`, no wildcards anywhere above `/Users/ravn/z80/`.
- Specific files outside the workspace may be read directly **only** when the user has handed you the exact path — `Read /Users/ravn/Downloads/mpm-net-1.2.tgz` is OK if the user referred to it, but `ls /Users/ravn/Downloads/` to go discover siblings is not.
- Instead of searching for external tools/configs: ask the user where they live, or invoke the tool with `--help` / `man` / env var inspection (`echo $PATH`) to get info without walking the filesystem.
- Spawned agents must inherit this rule — forbid home-dir traversal in the prompt.

**Paths the user has explicitly handed over (past):** `/Users/ravn/git/z80pack` (now superseded — submodule at `z80pack/` in the repo); `/Users/ravn/Downloads/mpm-net-1.2.tgz` and unpacked dir; `/Users/ravn/git/mame/src/mame/regnecentralen/`. Others require fresh permission.

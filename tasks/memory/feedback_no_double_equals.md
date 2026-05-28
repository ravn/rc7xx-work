---
name: escape-or-quote-in-zsh
description: User's zsh treats unquoted === as a command and silently truncates the rest of the line; use --- as section separator instead
metadata:
  type: feedback
---

**HARD**: `===` must be escaped or quoted in the user's zsh.  Bare `echo ===` (or any unquoted `===` token in a Bash invocation) emits `(eval):N: == not found` and TRUNCATES THE COMMAND OUTPUT — the rest of the command line silently does not run.

**Why:** Restated as a fact 2026-05-03 — stable behavior in the user's shell.  **REPEATEDLY VIOLATED across multiple sessions** despite this rule being in MEMORY.md §1 (always-on).  User has reminded "several times already" as of 2026-05-22.  Each violation costs an entire command (e.g. `git status && echo === workspace === && cd ...` runs only the first arm; everything after the unquoted `===` silently does not execute, and the failure mode `(eval):N: == not found` is easy to miss in long output).  Treat any unquoted `===` as a HARD ERROR equivalent to `rm -rf /` — scan and reject before sending.

**How to apply:**

  - **Default**: use `---` (single dashes, any length) as the section separator in Bash commands.  No escaping needed.
  - **If `===` is required** (e.g. echoing a literal banner): quote it (`echo "==="`) or escape (`echo \=\=\=`).
  - Applies to all Bash tool uses, heredocs, and any script content fed into the user's shell.
  - **Self-check before sending any Bash command**: scan for any unquoted `===` token, including inside multi-command chains joined by `&&` / `;` / `|`.  If found, replace with `---` or quote.

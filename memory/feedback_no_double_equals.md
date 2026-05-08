---
name: Escape or quote === in zsh
description: User's zsh treats === specially and breaks command execution unless escaped or quoted; use originSessionId: aa58bcb4-fdc2-421f-b7db-ca853ec8ccee
---
or quoted "===" instead
type: feedback
---

`===` needs to be escaped or quoted in the user's zsh.  Bare `echo ===` (or any unquoted `===` token in a Bash invocation) emits `(eval):N: == not found` and truncates the command output.

**Why:** Restated as a fact 2026-05-03 — stable behavior in the user's shell.  Observed repeatedly across prior sessions.

**How to apply:**

  - **Default**: use `---` (single dashes, any length) as the section separator in Bash commands.  No escaping needed.
  - **If `===` is required** (e.g. echoing a literal banner): quote it (`echo "==="`) or escape (`echo \=\=\=`).
  - Applies to all Bash tool uses, heredocs, and any script content fed into the user's shell.

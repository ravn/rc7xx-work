---
name: Never use sed to view file slices
description: HARD rule — NEVER run sed in shell to view slices or ranges of files. Always use the built-in view_file tool with StartLine and EndLine instead.
type: feedback
---

**HARD: NEVER run `sed` (or `git show ... | sed ...`) in shell to view line ranges or sections of files.**

**Why:**
Piping `git show` or file contents to `sed` executes an unsandboxed shell pipeline that requires interactive user permission confirmation every time, creating unnecessary friction.
The agent already has the dedicated `view_file` tool which takes `AbsolutePath`, `StartLine`, and `EndLine` parameters to read exact slices of files directly, without spawning a shell and without prompting the user.

**How to apply:**
- To view specific line ranges of a file on disk: ALWAYS use `view_file(AbsolutePath=..., StartLine=N, EndLine=M)`.
- To inspect git history or diffs: run `git diff` or `git show` directly without piping to `sed`.
- If an exact line slice of a file is needed, use `view_file`, NEVER `sed -n 'X,Yp'`.

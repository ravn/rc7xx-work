---
name: Never file issues in upstream repos
description: Only file GitHub issues in ravn/* forks, never in upstream repos like llvm-z80/llvm-z80
type: feedback
---

NEVER create GitHub issues in upstream repositories (e.g., llvm-z80/llvm-z80). Only file issues in the user's own fork (ravn/llvm-z80).

**Why:** The user's fork is where development happens. Filing in upstream creates noise for maintainers and is embarrassing. This happened on 2026-03-27 when issues #8, #10, #11, #14 were accidentally filed upstream.

**How to apply:** Before any `gh issue create`, always verify `--repo ravn/<reponame>`, never `--repo llvm-z80/<reponame>` or any other upstream org. This extends to the existing rule of never creating pull requests against other repos.

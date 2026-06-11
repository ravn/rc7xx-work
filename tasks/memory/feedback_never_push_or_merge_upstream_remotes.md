---
name: never-push-or-merge-upstream-remotes
description: Never push AND never merge in submodules whose origin points at an upstream-owned repo (e.g. cpnet-z80's origin = durgadas311/cpnet-z80). Push and merge only in repos the user owns (ravn/*). Local commits in upstream-tracking submodules stay flat — no milestone merges — until a fork remote is configured or a PR is opened.
metadata:
  type: feedback
---

Some of the project's submodules have `origin` pointing at an upstream
repo the user doesn't own, not a personal fork. Two rules:

1. **Don't push** to those origins. Push fails with 403 anyway, and
   even if it succeeded (PAT auth) it would be wrong intent — the
   user's pattern is "track upstream + carry local patches", not
   "upstream the patches".
2. **Don't merge either** — including milestone / no-ff merges that
   group local commits. Merge commits restructure history in ways
   that matter for upstream tracking (fast-forward to the next
   upstream tag stops being trivial). Keep local commits **flat** on
   top of upstream-HEAD instead.

Concrete examples (2026-06-11):
- `cpnet-z80` → origin `git@github.com:ravn/cpnet-z80.git` (fork)
  + upstream `https://github.com/durgadas311/cpnet-z80.git`. Fork
  created 2026-06-11 mid-session, remotes renamed accordingly.
  **OK to push/merge to origin (ravn fork); never push/merge to
  upstream.**
- `z80pack` → `https://github.com/ravn/z80pack` — user-owned fork,
  **OK to push, OK to merge.**
- `rc700-gensmedet` → `git@github.com:ravn/rc700-gensmedet.git` —
  user-owned, **OK to push, OK to merge.**
- Workspace `/Users/ravn/z80` → `git@github.com:ravn/z80-compiler-suite-workspace.git`
  — user-owned, **OK to push, OK to merge** (per the cross-machine
  wrap-up rule).

**Why:** session 2026-06-11 attempted a milestone `--no-ff` merge +
push on cpnet-z80. Push hit 403; the merge succeeded locally but
restructured local history on an upstream-tracking branch. User
clarified: "never push upstream, only locally" followed by "never
merge upstream, only in my own repos."

**How to apply:** before either `git push` or `git merge --no-ff`,
check `git remote -v`. If `origin` isn't under `ravn/*` (or another
user-owned namespace), **leave the local commits as a flat chain
on top of upstream-HEAD**. Cross-machine sync of those commits
happens via the workspace submodule pointer, not via remote
push/merge.

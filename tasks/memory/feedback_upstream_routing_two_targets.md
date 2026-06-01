---
name: feedback_upstream_routing_two_targets
description: Upstream submission target — "z80 upstream only" = llvm-z80/llvm-z80 (@zlfn); do NOT run a parallel llvm/llvm-project campaign
metadata:
  type: feedback
---

**Session-77 directive (2026-06-01, user-confirmed) — supersedes the earlier two-target
routing:** "**This is z80 upstream only.**" The curated upstream submission target is the
z80 fork-of-record **`llvm-z80/llvm-z80`** (@zlfn) — the `upstream` git remote, parent of
`ravn/llvm-z80`. Do **not** open a separate campaign at official `llvm/llvm-project`, even
for generic-LLVM bugs.

How it works in practice (session 77): generic-LLVM bugs found via the Z80 backend are
filed as **issues at `llvm-z80/llvm-z80`** (with a failing test case + proposed fix), plus
one tests-only PR carrying the demonstrations. The bug *fixes* live in `ravn/llvm-z80`;
@zlfn's periodic `upstream/main` syncs still flow accepted generic fixes downward over
time, so keep each local generic commit in upstream-ready shape. If a generic bug is
**already** open at official LLVM (e.g. LiveVariables = `llvm/llvm-project#156428`),
**reference it, don't duplicate.**

**Completeness-audit method (reusable):** to find which generic-LLVM bugs are
upstream-candidates, diff the **generic code** (everything under `llvm/lib`/`clang/lib`
*outside* `Target/Z80` and the Z80-clang files) between `ravn/main` and `upstream/main` —
that is the ground truth, not the issue tracker. Each such change is either a fixed bug
(file/reference it) or a workaround for an unfixed one (file it as "real bug, no fix
found"). Session-77 audit found exactly 5 generic transform/codegen files changed +
InstCombineCalls (the missed one). See [[project_z80_upstream_goal]],
[[feedback_no_upstream_issues]], [[feedback_no_pull_requests]].

---
name: feedback_upstream_routing_two_targets
description: Upstream routing — generic-LLVM bugs go to llvm/llvm-project; only Z80-specific bugs/fixes belong at llvm-z80/llvm-z80. Session-77's "z80 upstream only" was a velocity directive (don't fan out), NOT a routing override.
metadata:
  type: feedback
---

**Corrected policy (2026-06-05) — session 77's reading was wrong.** PR #17 at
`llvm-z80/llvm-z80` was rejected by @zlfn precisely because 5 of its 6 XFAIL
demonstrations were target-agnostic generic-LLVM bugs (`#18` deleteDeadLoop,
`#19`/`#21` TruncInstCombine, `#20` SimplifyCFG cost gate, `#22` InstCombine
memcpy-fold) that don't belong in the Z80 fork.

**Routing rule (corrected):**

* **Generic-LLVM bug** (the bug and the fix both live in code that's not
  `llvm/lib/Target/Z80/` or `clang/...z80...`, and the bug reproduces on
  other targets): file at **`llvm/llvm-project`** OR keep as a local XFAIL
  test in `ravn/llvm-z80` (no upstream filing required). Do NOT file at
  `llvm-z80/llvm-z80`.
* **Z80-specific bug** (the bug or the fix is in Z80 backend code, or the
  Z80 backend is the only meaningful exhibitor): file at
  **`ravn/llvm-z80`** for local tracking; consider `llvm-z80/llvm-z80`
  only if @zlfn would actually take it (= it's a real Z80-backend issue
  in the fork-of-record's tree, not just our private fork's).
* **Already open upstream** (e.g. LiveVariables = `llvm/llvm-project#156428`):
  reference, don't duplicate — neither at `llvm-z80/llvm-z80` nor anywhere.

**What session-77's directive actually meant.** The user said "z80 upstream
only" as a **velocity directive** ("don't fan out to multiple campaigns at
once") — I misread it as a **routing override** ("file everything at the Z80
fork, never at llvm/llvm-project"). That misreading produced the PR #17
misroute. When the user says "X only" in upstreaming context, ask whether
that's velocity or routing before committing.

**Completeness-audit method still works**, but now to TRIAGE not aggregate:
diff generic code (everything under `llvm/lib`/`clang/lib` *outside*
`Target/Z80` and the Z80-clang files) between `ravn/main` and `upstream/main`,
then for each diff decide: generic (-> llvm/llvm-project candidate or local
XFAIL only) vs Z80-coupled (-> ravn/llvm-z80 issue).

**Hard gate before any upstream filing** (the new rule, see
[[feedback_explain_before_filing]]): regardless of where it's filed, no
upstream issue / PR / commit goes out until I've explained the root cause
in plain English in chat AND the user has explicitly said "go ahead, file
it" — for THIS specific filing, not blanket authorization.

Related: [[project_z80_upstream_goal]], [[feedback_no_upstream_issues]],
[[feedback_no_pull_requests]], [[feedback_explain_before_filing]].

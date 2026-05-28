---
name: Re-verify experiment matrix endpoints before building theory — HARD RULE
description: When a multi-axis bisect produces a contradictory pattern (e.g., A+A works but A+B and B+A both broken), suspect stale build state and re-verify each cell with `make clean` BEFORE drawing cross-cutting conclusions. Stated by user 2026-05-04.
type: feedback
originSessionId: ea4ecd69-4e79-45f7-91f6-8a5e666d9c2f
---
**HARD RULE: re-verify experiment matrix endpoints before building theory.**

When investigating a regression across multiple axes (compiler version × source version, optimization level × target, etc.), and the result matrix shows contradictory or surprising patterns — for example, a 2×2 where the diagonal works but BOTH off-diagonals are broken — that pattern is a red flag for **stale build state**, not for "two independent regressions on two axes."

The rule:

  1. **Do a `make clean` (or equivalent) between every matrix cell.**  Build artifacts from a previous cell can poison the next cell silently — particularly for chained-command sequences that don't fully re-build dependencies.
  2. **Re-verify the GOOD endpoint and BAD endpoint** (the diagonal anchors) on freshly-rebuilt artifacts before testing any off-diagonal cell.  If the anchors don't reproduce, the matrix is unreliable.
  3. **Treat contradictory off-diagonal patterns as evidence of state-leak**, not as evidence of multiple regressions, until proven otherwise.
  4. **Don't build theory on top of one test result.**  If a single test produces a surprising answer, repeat it before extending the analysis.

**Why:** Session 42 (2026-05-04) autoload-in-c bisect.  Initial 2×2 said: "old llvm + old src" works; "new llvm + new src" broken; AND I claimed both off-diagonals (old+new, new+old) were broken — concluding "the regression is on BOTH axes."  Spent ~30 minutes investigating source-side changes from that conclusion before realizing the off-diagonal results were stale-state artifacts.  Once cells were re-tested with proper rebuilds, the actual matrix was: only "old llvm + old src" works, "new llvm + ANY src" broken — single-axis regression in the compiler.

**How to apply:**

  - Before reporting a multi-cell test result, run a quick "anchor reproduction": rebuild the GOOD endpoint twice and verify it's still GOOD.  If it's not, the test infrastructure is unstable and any cross-cutting conclusion is suspect.
  - When committing investigation findings to memory or docs, prefer "I tested cell X with clean rebuild and got result Y" over "I concluded that axis Z is the cause" — the former is data, the latter is interpretation.
  - When user states a strong hypothesis as a directive ("test compiler first; rule out compiler before touching source"), treat it as a constraint, not a parallel option to explore.  Strong hypotheses from the user often encode invariants the user knows that I don't (e.g., "source is dormant").

**Sub-rule: symptom-where ≠ bug-where.**  When a binary works in environment A but not in environment B, the bug is more often in B's environmental setup than in the binary itself.  And when the bug IS in the binary, A/B asm diff between two compiler states pins down WHICH binary changed — not just WHICH commit changed.

Bisect identifies the commit; A/B asm diff identifies the binary.  Both together pin the right fix scope.  Skipping the A/B diff leads to fixes scoped to the wrong component.  Example: session 42 (2026-05-04) — bisect identified llvm-z80 commit `96dde0c` as the cause of an autoload-in-c boot hang.  Initial fix-scope assumption: "autoload-in-c is being miscompiled."  After-fix A/B comparison: autoload-in-c is byte-identical between broken/fixed states.  The actual miscompiled binary is rcbios (which autoload-in-c LOADS from disk).  rcbios works under one autoload's register-state hand-off but not the other's — composition bug.  See `llvm-z80/tasks/issue-74-cross-pair-rca-2026-05-04.md`.

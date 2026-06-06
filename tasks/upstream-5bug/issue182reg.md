## Summary

The original #182 repro **crashes again at HEAD `2c3d594c`** (assert builds, `-O1`/`-Oz`):

```
clang: llvm/lib/Transforms/Utils/LoopUtils.cpp:560: void llvm::deleteDeadLoop(...):
Assertion `L->hasDedicatedExits() && "Loop should have dedicated exits!"' failed.
...
4. Running pass "Z80LoopIdiomFill" on function "g"
```

```c
unsigned char a[100];
void g(void) {
   unsigned short i;
   for (i = 0; i < 100; ++i) a[i] = 0;
   for (i = 0; i < 100; ++i) ++a[i];
}
// clang --target=z80 -nostdlib -ffreestanding -O1 -c repro.c
```

This is a layering consequence of how #182 was fixed, exposed by the 4940-commit upstream merge (`2b971123e3bd`).

## Root cause

Upstream `deleteDeadLoop` has an explicit caller contract: the loop must have **dedicated exits** (every exit-block predecessor inside the loop). Upstream both documents it ("Given the loop has dedicated exits, all other incoming values must be from the exiting blocks") and asserts it (`assert(L->hasDedicatedExits())`).

`Z80LoopIdiomFill` violates that contract: for two sequential loops over the same array, L1's unique exit block IS L2's header, whose phis carry L2's backedge entries — i.e. the exit block has a predecessor outside L1, so `hasDedicatedExits()` is false. IR reaching the pass at HEAD:

```llvm
for.body:                                  ; L1 (the fill loop being deleted)
  ...
  br i1 %exitcond.not, label %for.body3, label %for.body

for.body3:                                 ; L1's UNIQUE EXIT == L2's header
  %z80-indexiv.iv17 = phi i8 [ %z80-indexiv.iv.next18, %for.body3 ], [ 0, %for.body ]
  %i.115           = phi i16 [ %inc7, %for.body3 ], [ 0, %for.body ]
  ...
  br i1 %exitcond16.not, label %for.end8, label %for.body3
```

The #182 fix (`6dc359f0c63c`) changed **generic** `deleteDeadLoop` to tolerate the violated precondition (loop-aware phi rewrite) instead of fixing the caller. That held only because the pre-merge fork predated upstream's assert. The merge re-imported the assert directly above our rewrite; the rewrite is now dead code behind an abort.

This also retro-confirms the PR #17 / upstream-routing postmortem: the "generic LLVM bug" framing of #182 was wrong — by upstream's contract this is a **caller bug in our target pass**, and it has been dropped from the upstream 5-bug filing queue.

## Why CI missed it

`llvm/test/CodeGen/Z80/issue-182-deletedeadloop-phi.ll` still PASSES at HEAD: its hand-written IR (via `llc -O1`) no longer reproduces the CFG shape clang HEAD's `-O1` pipeline feeds `Z80LoopIdiomFill`. Stale oracle — the regression needs a clang-pipeline-shaped lit test (IR above, captured with `-mllvm -print-before-all`).

## Proposed fix

1. In `Z80LoopIdiomFill` (`Z80LoopIdiomFill.cpp:290`), before calling `deleteDeadLoop`: call `formDedicatedExitBlocks(L, &DT, &LI, nullptr, /*PreserveLCSSA=*/true)` — or conservatively bail when `!L->hasDedicatedExits()`.
2. **Revert the generic `LoopUtils.cpp` divergence** (restore upstream `deleteDeadLoop`) — the loop-aware rewrite is unreachable behind the assert and only widens our generic diff against upstream.
3. Add a lit test pinning the clang-HEAD IR shape; keep the existing test.
4. Value oracle before commit per project rules (test-runner + production byte-compare): touching dedicated-exit formation changes the CFG the fill idiom sees.

Found while verifying the 5-bug upstream queue on sonnyboy (upstream HEAD `de59f9ed` reference build). Rules-checked: feedback_explain_before_filing (root cause explained + per-filing user go-ahead 2026-06-06), feedback_upstream_routing_two_targets, feedback_audit_oracle_not_just_fix.

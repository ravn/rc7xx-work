(For llvm/llvm-project. AWAITING per-filing go-ahead. User may prepend own framing.)

Title: SimplifyCFG: foldTwoEntryPHINode never consults getPredictableBranchThreshold on non-PGO code — targets with no branch predictor get non-free arms speculated unconditionally

`foldTwoEntryPHINode` converts an if/else diamond into a `select`, hoisting the arm computation so it executes unconditionally. The profitability check that consults the target's branch-predictability model is reachable only when branch weights exist (SimplifyCFG.cpp, current main):

    if (!IsUnpredictable) {
      uint64_t TWeight, FWeight;
      if (extractBranchWeights(*DomBI, TWeight, FWeight) &&
          (TWeight + FWeight) != 0) {
        ...
        BranchProbability Likely = TTI.getPredictableBranchThreshold();
        ...
      }
    }

Without profile metadata the fold falls through to a flat budget (`TwoEntryPHINodeFoldingThreshold * TCC_Basic`, default 4) that has no input from the branch-cost model at all. A target that declares every branch predictable — `getPredictableBranchThreshold().isZero()`, the natural setting for in-order microcontrollers with no branch predictor, where a conditional branch costs a few cycles and never mispredicts — therefore still gets non-free arms speculated on all its non-PGO code, which in practice is all of its code.

On such a target the transform is a strict expected loss whenever the arm is not free: the branch version pays a cheap fixed-cost jump and skips the arm half the time; the select version pays the arm always, plus the select materialization.

Repro — two functions identical except for `!prof` metadata, demonstrating the threshold override is dead on the unweighted one (`opt -passes=simplifycfg -predictable-branch-threshold=0 -S`, current main):

    define i8 @cond_xor_noweights(i8 %x, i16 %c) {
    entry:
      %tobool = icmp eq i16 %c, 0
      br i1 %tobool, label %merge, label %then
    then:
      %xor = xor i8 %x, 27
      br label %merge
    merge:
      %r = phi i8 [ %xor, %then ], [ %x, %entry ]
      ret i8 %r
    }
    ; + an identical @cond_xor_weights with !prof !{!"branch_weights", i32 1, i32 1}

Result: `@cond_xor_noweights` is folded to an unconditional `xor` + `select` despite the threshold saying every branch is predictable; `@cond_xor_weights` keeps its branch (the same threshold, once actually consulted, suppresses the fold even at 50/50 weights).

The source shape is the C ternary `c ? (x ^ 27) : x` — ubiquitous in non-PGO embedded code (this exact one is GF(2^8) xtime in AES).

Suggested direction: when `TTI.getPredictableBranchThreshold().isZero()`, gate speculation on arm cost regardless of weights (e.g. only fold when the speculated instructions are `TCC_Free`). We carry a ~12-line local patch of that shape on an out-of-tree Z80 backend; it produced a measurable size AND speed win on an AES-256 workload (−16 B, −1.1% cycles) with no regressions across our corpus. The symmetric facility already exists for the opposite extreme: `SpeculateUnpredictables` extends the budget by `getBranchMispredictPenalty()` for `!unpredictable` branches; the "branches are never costly" signal has no consumer without PGO.

Found while developing an out-of-tree Z80 backend; the repro is target-independent.

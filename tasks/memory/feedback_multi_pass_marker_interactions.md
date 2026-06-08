---
name: multi-pass-marker-interactions
description: When diagnosing why an optimization didn't fire, check whether an earlier pass stripped its trigger pattern — single-pass IR analysis can miss multi-pass interactions; the trigger may have been present once and lost
metadata:
  type: feedback
---

**User directive 2026-06-08 (implicit), session investigating AES K&R speed gap:**

> When clang failed to narrow AES K&R `gf_log` on Z80 despite working on
> AVR with the same middle-end code, the FIRST diagnosis was "my icmp
> gate's KnownBits is conservative" — true but only partial.  Per-pass
> IR dump revealed the actual root cause: `CorrelatedValuePropagationPass`
> on Z80 stripped the `(and i16 %atb, 255)` mask that
> `AggressiveInstCombine` Phase 2 needs as its trigger.  By the time
> AggressiveInstCombine ran, the marker was gone.

**Why this exists.**  Single-snapshot IR analysis ("look at what the IR
contains when AggressiveInstCombine runs") missed that the relevant
marker had EXISTED at the start of the pipeline and been REMOVED
mid-pipeline.  Cost: ~one session of LVI integration work that turned
out to be inert because LVI couldn't recover what CVP had already
discarded.

**The lesson, generalized.**  When an optimization "should fire" on
shape X but doesn't:

1. Don't just inspect the IR at the optimization's entry point.
2. Dump the IR after EVERY pass (`clang -mllvm -print-after-all -S -emit-llvm`).
3. Trace the trigger pattern's appearance / disappearance across passes.
4. If the trigger was once present and is now gone, the question shifts:
   "what fold removed it, and is that fold correct on this target?"

**Smell checks for downstream-affecting pass interactions:**

- An "obvious narrowness signal" (`(and X, MASK)`, `range` metadata,
  `nuw`/`nsw` flags) that's present at one pipeline point but missing
  at another.
- A target whose TTI hooks (`getPredictableBranchThreshold`,
  `isLegalAddImmediate`, etc.) bias an early pass's choices in a way
  that propagates downstream.
- A pass that takes "redundant" things away (`InstCombine`, `CVP`,
  `InstSimplify`) running BEFORE a pass that uses those things as
  triggers (`AggressiveInstCombine`, target-specific lowering).

**Why removed markers can't always be recovered.**  `LazyValueInfo`
proved the cyclic phi narrow at CVP's point BECAUSE the `(and ..., 255)`
mask gave it a starting constraint.  Once CVP stripped the mask, LVI
ALONE could not recompute the bound — it needs a constraint to
propagate from.  The proof depended on a transient marker, and removing
the marker destroyed the proof.

**Cross-listed with:**

- [[feedback_ab_before_blaming_test_runner]] — A/B compare against the
  baseline before blaming a downstream tool.
- [[feedback_verdict_after_real_pass_output]] — show what the pass
  actually does before stating a verdict.
- [[feedback_avr_density_oracle]] — AVR is the cross-target oracle that
  surfaced the divergence in the first place.

**Scope.**  Applies to LLVM middle-end and any other multi-pass
optimizing compiler.  Not specific to AggressiveInstCombine.

**When this rule does NOT apply.**  Single-pass diagnostics (a fold
inside one InstCombine call, a pattern in one isel run).  No pass
interaction → no risk of missed-by-earlier-pass markers.

---
name: feedback-no-op-control-measurement
description: HARD discipline — when evaluating a code change that introduces a new heuristic, cost-model query, or pass override, ALWAYS take a no-op-control measurement.  Build the change with the new code present but configured to be a logical no-op (default OFF / threshold infinite / condition always-false), and compare codegen to the state WITHOUT the new code.  If they differ, the new code has a side effect beyond its stated logic — the measurements that depend on it are unreliable until the side effect is understood.  Cascaded from feedback_revalidate_historical_compiler_claims.
metadata:
  type: feedback
---

**HARD: when evaluating a code change that introduces a new heuristic,
cost-model query, or pass override, ALWAYS take a no-op-control
measurement alongside the "feature on" measurement.  The control
state has the new code PRESENT but configured to be a logical no-op
(default OFF, threshold infinite, condition always-false, etc.).
Compare its codegen against the state WITHOUT the new code at all.
If they differ, the new code has a side effect beyond its stated
logic — the measurements that depend on it are UNRELIABLE until the
side effect is understood.**

**Why.**  A change that adds a new query into a pass (e.g. a custom
`shouldHoist`, `getRegPressureSetLimit` override, or a new TTI hook)
can perturb behavior even when its logic is supposed to be a no-op.
Possible mechanisms observed:

  - lazy analysis triggered by query (`MachineLoop::getLoopPreheader`
    can force preheader splitting in some passes)
  - the act of overriding a virtual function changes vtable layout
    and inhibits certain devirtualization-driven optimizations
  - the new code's `#include`s pull in template instantiations that
    differ between TUs
  - the new code calls a query that has its own caching that primes
    differently from the no-override path

The mechanisms are subtle; the symptom is consistent: ON and OFF
cells produce different codegen, but ON-with-noop-config also differs
from no-override-at-all.  That's the signature of a presence-cost
side effect, not the intended cost-model effect.

**How to apply.**  Three cells, not two, for any cost-model change:

  1. **Baseline**: tree without the new code at all (git checkout
     the modified files, rebuild clang, measure).
  2. **No-op control**: tree with the new code IN PLACE, configured
     to a no-op (default OFF, threshold infinite, etc.) — should
     measure byte-identically to (1) if there's no side effect.
  3. **Feature ON**: tree with the new code IN PLACE, configured
     active (default ON, threshold low, etc.) — the measurement
     of interest.

If cell (2) ≠ cell (1): STOP.  The change has a presence-cost.
Either understand and document why, or simplify the change until
cell (2) == cell (1).  Otherwise, every measurement that uses cell
(3) is suspect.

If cell (2) == cell (1): the change's logic is the only thing
affecting cell (3); measurements are trustworthy.

**Concrete witness (2026-06-08):**  The session that landed #23
(retire `disablePass(LICM/CSE)`) also tried two heuristics on top.
Both were buggy:

  - `Z80InstrInfo::shouldHoist` count-based heuristic: at threshold=99
    (effectively unbounded; "always allow") it produced +25 B autoload
    growth vs no-override.  I only caught this on round THREE of
    revalidation, after committing the heuristic.  The "shouldn't have
    landed" branch.
  - `Z80RegisterInfo::getRegPressureSetLimit` override: at all-
    pressure-sets-capped-to-1 it produced identical codegen, indicating
    the pressure model wasn't gating the autoload hoists at all — but
    I had to probe all 12 sets individually to confirm, after first
    misreading a stale-file `wc -c`.  The "should-have-tested-control-
    cells-first" branch.

Both incidents would have been one-cell-investigation away from the
real answer had I run no-op-control cells alongside.

**How this is operationalized:**  the Phase 0 measurement harness
(`llvm-z80/tasks/tools/measure-all.sh`) records the cl::opt state in
its TSV header (clang_extra).  For every change, take three TSVs:
baseline, no-op-control (with the change but disabled), feature-ON
(with the change enabled).  Diff (1) vs (2) FIRST.  If they differ,
debug before proceeding.

Related:
  - [[feedback_revalidate_historical_compiler_claims]] — parent rule;
    this is the cascading section's discipline made concrete.
  - [[feedback_check_memory_before_coding]] — scan at task start;
    if the task involves a cost-model change, this rule applies.
  - [[feedback_baseline_before_implementing]] — capture control
    on UNMODIFIED system; this rule extends it: ALSO capture control
    on modified-but-no-op system.

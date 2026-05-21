---
name: project-issue177-work-clock
description: Phase 2 of session 73p — #177 Z80 TargetTransformInfo implementation is an active multi-session work clock starting 2026-05-21, target completion 2026-06-18 to 2026-07-02
metadata:
  type: project
---

**Active multi-session work clock: ravn/llvm-z80#177 Z80 TargetTransformInfo.**

- **Started**: 2026-05-21 (session 73p Phase 2).
- **Phase A complete**: 2026-05-21 (~30 min, retired Phase E, revised plan).
- **Aggressive completion target**: 2026-06-04 (~2 weeks, was 2026-06-18).
- **Conservative completion target**: 2026-06-18 (~4 weeks, was 2026-07-02).
- **Branch**: `session-73p-phase2-issue177` in `ravn/llvm-z80`.
- **Plan doc**: `llvm-z80/tasks/issue177-implementation-plan.md`.
- **Phase A findings**: `llvm-z80/tasks/issue177-phase-a-investigation.md`.

## What's in scope (revised post-Phase-A)

Four phases of work landing the missing Z80-specific TTI hooks:

- ~~Phase A~~ — investigation **DONE** (2026-05-21)
- Phase B — Tier 1 hooks: **getInstructionCost** (first),
  getUnrollingPreferences, isProfitableToHoist (1-2 wk)
- Phase C — Tier 2 hooks: getArithmeticInstrCost, getCmpSelInstrCost,
  getCastInstrCost, isLegalAddImmediate (3-5 d)
- Phase D — Tier 3 + 4 cleanup: enableMemCmpExpansion=false,
  hasBranchDivergence=false, no-vectorization cluster (1-2 d)
- ~~Phase E~~ — **RETIRED** (MachineLICM/CSE don't use TTI; can't
  TTI-gate them per-function)
- ~~Phase F~~ — merged into Phase B

## Critical relationships

- **#128 is currently closed via global `disablePass(MachineLICMID +
  MachineCSE)` workaround.**  ~~Phase E may revert~~ — **Phase A
  found MachineLICM/CSE don't use TTI; can't TTI-gate them.
  Phase E retired.  #128's workaround stays indefinitely** unless
  separately addressed via upstream-LLVM modifications to those
  passes (out of scope for #177).  DO NOT delete the #128
  workaround as part of #177 work.
- **#27, #115, #95 (closed), #38, #100** all benefit from TTI cost
  hooks.  See the plan doc's "Connection to other open issues"
  section.

## How to resume

If a fresh session encounters this memory: the active work is on the
named branch.  Check the plan doc's "Status tracking" section for
which phases have landed.  Each phase commits independently with
TDD lit test + Decision E full oracle gating per `feedback_no_commit_
first_version`.

## When to retire this memory

Delete this memory when #177 closes (all phases landed and
validated, plan doc's "Status tracking" filled in).

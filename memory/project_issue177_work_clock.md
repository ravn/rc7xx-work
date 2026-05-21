---
name: project-issue177-work-clock
description: Phase 2 of session 73p — #177 Z80 TargetTransformInfo implementation is an active multi-session work clock starting 2026-05-21, target completion 2026-06-18 to 2026-07-02
metadata:
  type: project
---

**Active multi-session work clock: ravn/llvm-z80#177 Z80 TargetTransformInfo.**

- **Started**: 2026-05-21 (session 73p Phase 2).
- **Aggressive completion target**: 2026-06-18 (~4 weeks).
- **Conservative completion target**: 2026-07-02 (~6 weeks).
- **Branch**: `session-73p-phase2-issue177` in `ravn/llvm-z80`.
- **Plan doc**: `llvm-z80/tasks/issue177-implementation-plan.md`.

## What's in scope

Six phases of work landing the missing Z80-specific TTI hooks:

- Phase A — investigation (4-6 h)
- Phase B — Tier 1 hooks: getInstructionCost, getMemoryOpCost,
  getCFInstrCost (1-2 wk)
- Phase C — Tier 2 hooks (3-5 d)
- Phase D — Tier 3 no-vectorization cluster (1-2 d)
- Phase E — per-function optsize/minsize gating + #128 revert (1 wk)
- Phase F — Tier 4 exploratory (1 wk)

## Critical relationships

- **#128 is currently closed via global `disablePass(MachineLICMID +
  MachineCSE)` workaround.**  Phase E may revert that disablePass()
  call once TTI cost hooks provide proper per-function gating.
  When picking up the project at any point, DO NOT delete #128's
  workaround until Phase E validates the replacement.
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

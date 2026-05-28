---
name: project-issue177-work-clock
description: Phase 2 of session 73p — #177 Z80 TargetTransformInfo implementation is an active multi-session work clock starting 2026-05-21, target completion 2026-06-18 to 2026-07-02
metadata:
  type: project
---

**Active multi-session work clock: ravn/llvm-z80#177 Z80 TargetTransformInfo.**

- **Started**: 2026-05-21 (session 73p Phase 2).
- **Phase A complete**: 2026-05-21 (~30 min, retired Phase E).
- **Phase B0 complete**: 2026-05-22 (~1 h, re-scoped Phase B; PREDICTION WRONG).
- **Phase B1 complete**: 2026-05-22 (~30 min, ran oracle, falsified B0).
  Bundle introduced AES miscompile.  I parked #177 -- WRONG REFLEX.
- **User redirect**: "fine introducing bugs, fix them correctly".
- **Phase B2 complete**: 2026-05-22 (~1 h, bisected bundle).
  Isolated to ONE line: `getArithmeticInstrCost(i16) -> 2`.
  Sibling clean cases shipped on `541b687bbecc` (merge to main):
  `prefersVectorizedAddressing=false`, `Mul -> TCC_Expensive`,
  `getCastInstrCost` (trunc/zext free, sext=2).
  Production delta: cpnos PROM1 2030 -> **2029 B (-1 B)**.
- **Bad case filed as ravn/llvm-z80#184** with reproducer + asm diff.
- **#177 STAYS OPEN** with much clearer scope; Phase C/D deferred,
  Phase E retired.  Re-investigation of #184 needed before further
  TTI work.
- **Branch**: `session-73p-phase2-issue177` in `ravn/llvm-z80`.
- **Plan doc**: `llvm-z80/tasks/issue177-implementation-plan.md`.
- **Phase A findings**: `llvm-z80/tasks/issue177-phase-a-investigation.md`.
- **Phase B0 findings**: `llvm-z80/tasks/issue177-phase-b0-investigation.md`.

## What's in scope (revised post-Phase-A)

Post-Phase-B0 scope (heavily re-scoped from original plan):

- ~~Phase A~~ — investigation **DONE** (2026-05-21)
- ~~Phase B0~~ — re-scope investigation **DONE** (2026-05-22)
- **Phase B (re-scoped)** — best-effort target-truthful overrides
  for getArithmeticInstrCost / getCastInstrCost / getCmpSelInstrCost
  / getCFInstrCost / getMemoryOpCost.  Low expected production
  impact; documents target reality for future passes (2-3 d)
- ~~Phase C~~ — **DEFERRED** (Phase B0: low yield without future
  Z80-specific IR pass consuming the hooks)
- ~~Phase D~~ — **DEFERRED** (same)
- ~~Phase E~~ — **RETIRED** (Phase A: MachineLICM/CSE don't use TTI)
- ~~Phase F~~ — merged into Phase B

**Phase 2 effort pivot**: remaining session-73p Phase 2 effort
shifts to **#173** (8-bit BSS spill peephole, MIR-level, estimated
100-200 B AES production yield).

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

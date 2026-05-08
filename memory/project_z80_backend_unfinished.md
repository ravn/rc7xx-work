---
name: Z80 LLVM backend is preliminary, not finished
description: The ravn/llvm-z80 Z80 backend is unfinished work, not a finished backend that needs optimization — the goal is to FINISH it correctly
type: project
originSessionId: 986bb359-738f-4014-bfb2-add9f26e34f5
---
The Z80 LLVM backend in `/Users/ravn/z80/llvm-z80/` is **preliminary
and incomplete**.  The user's goal is to **finish it correctly**, not
to optimize an already-finished backend.

**Why this framing matters:**

Code-density gaps vs SDCC are not "optimization opportunities" in the
ordinary sense — they are **gaps in the backend's completeness**.
Examples:

  - DJNZ is post-RA peephole, not primary instruction selection — the
    backend was never wired up to model B as dead on fall-through.
  - Some `LD_*_nn` instructions have `isReMaterializable` set, but
    the regalloc cost-model for cheap Z80 remat is incomplete.
  - There is no Z80-specific `TargetTransformInfo`, so generic LSR /
    IndVarSimplify cost decisions never see Z80's countdown bias.
  - Peepholes in `Z80LateOptimization.cpp` accumulate as stand-ins
    for instruction-selection / regalloc / legalization that wasn't
    finished.

**How to apply:**

  - When tempted to "add a peephole" or "tweak a cost", first ask:
    "is this missing backend infrastructure that should be
    completed?"  Usually yes.
  - Treat each open issue not as a defect to patch but as a gap in
    the backend to fill.  The BIOS / cpnos-rom / PROM size numbers
    are *measurements* of completeness, not the goal in themselves.
  - Plan structure should reflect "backend completion" rather than
    "optimization sprint" — audit what's missing first, then fill
    the gaps in order of leverage.
  - Reinforces the existing `feedback_root_cause_over_peephole.md`:
    no new post-RA peepholes when the gap is upstream missing work.

**Counter-example where peephole IS the right answer:**
  - Z80-ISA-specific patterns with no IR-level representation
    (`EX DE,HL`, `BIT n,A`, `SBC A,A`).  These are legitimately
    late-opt and don't represent unfinished backend infrastructure.

This memory exists because the framing affects EVERY plan decision
and EVERY individual fix.  It should be loaded before any code
density / regalloc / instruction-selection work in this project.

---
name: Prefer root-cause fixes over peephole optimizations
description: When fixing codegen issues, favor upstream/structural fixes (MIR-level DCE, regalloc cost model, GISel combiner) over post-RA peephole patches
type: feedback
originSessionId: 986bb359-738f-4014-bfb2-add9f26e34f5
---
When the same shape can be fixed either by adding a post-RA peephole
or by addressing the upstream cause (regalloc cost model,
rematerialization, MIR-level DCE, GlobalISel combiner pattern,
LegalizerInfo, IR pass), prefer the upstream fix.

Specifically forbidden as a default reflex:
  - "Add a post-RA peephole that recognises `LD (nn),HL ; LD HL,(nn)`
    and drops the redundant load."

Specifically preferred:
  - "Why does the dead-load survive to post-RA?  Add MachineDCE step
    or extend the GISel combiner to fold static-stack store/reload
    pairs at IR level."

**Why:** peepholes accumulate as a brittle layer of pattern-matchers.
Each one fires only on its exact shape, doesn't compose, and rots when
upstream codegen evolves.  Root-cause fixes shrink **multiple** shapes
at once and keep the late-opt pass small enough to audit.  Sessions
32-35 already show this trend: the BSS-spill peephole family is
N peepholes deep and growing.

**How to apply:**
  - When proposing a fix, FIRST sketch where the pattern came from in
    the pipeline.  Was it IR-level pessimism? regalloc decision?
    legalization?  Only fall back to a peephole if the upstream fix is
    genuinely intractable AND the peephole is the cheapest option.
  - In plans, treat "extend Z80LateOptimization.cpp" as the last
    resort, not the first.
  - Existing peepholes are fine to retain; this rule is about *new*
    work.
  - Counter-example where peephole is right: the pattern is unique to
    Z80 ISA quirks (e.g. `EX DE,HL` register swap, `BIT n,A` for bit
    test, `SBC A,A` carry materialization) and has no IR-level
    representation.  Then late-opt is the only place it can live.

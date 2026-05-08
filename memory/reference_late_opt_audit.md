---
name: Late-opt peephole audit (session 37)
description: Pre-existing audit classifies all 46 Z80LateOptimization.cpp patterns as Keep/Migrate/Delete; the migrate list is the canonical "hides bad modelling" inventory
type: reference
originSessionId: aa58bcb4-fdc2-421f-b7db-ca853ec8ccee
---
`llvm-z80/tasks/late-opt-audit-2026-05-02.md` (session 37, 2026-05-02)
classifies every peephole in `llvm/lib/Target/Z80/Z80LateOptimization.cpp`
(46 patterns, 5272 LOC) by upstream home:

  - **Keep** (18, ~1200 LOC) — Z80-ISA-specific, no IR/MIR home.
  - **Migrate** (16, ~2300 LOC) — patches higher-pass deficiencies;
    proper home is GISel combiner / ISel patterns / regalloc cost
    model / MIR-CSE / MIR-DCE / TTI / IR-level idiom recognition.
    **This is the canonical "peepholes that hide bad modelling"
    list.**
  - **Delete** (3, ~150 LOC) — obsolete or subsumed by in-flight
    combiner work.

The audit was the Phase 1 Foundation deliverable per
`roadmap-to-maturity.md` section 12.1.  It is the starting
checklist for Phase 8 (late-opt cleanup) and the cross-reference
for any "should this be a peephole or a structural fix?"
discussion.

**How to apply:** when the user asks "is X a peephole that hides
bad modelling?", read this audit first.  When proposing to add a
new peephole, check whether its proposed shape is already covered
by an existing Migrate entry — if so, do the structural fix
instead.  When proposing to harden an existing peephole, check
whether the audit classifies it as Migrate; if yes, the
structural fix subsumes the hardening.

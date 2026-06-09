---
name: feedback_fork_local_pass_naming
description: When adding a pass under llvm/lib/Target/Z80/, audit whether its body is target-agnostic; name and upstream-track accordingly
type: feedback
---

When adding (or reviewing) a pass under `llvm/lib/Target/Z80/`, ask: **is
the body actually Z80-specific?**  The `Z80` prefix is a directory
convention, not a semantic claim.

If the body is **target-agnostic** — operates on `Loop`, `BasicBlock`,
`Instruction`, `SCEV`, etc., without consulting `Z80Subtarget` or
`Z80TargetMachine` — then:

1. **Name with the operation, not the target.**  `Z80LoopIdiomFill` was
   wrong: the body is generic SCEV-based pattern-fill recognition;
   `Z80PatternFillRecognize` mirrors LLVM's `LoopIdiomRecognize::recognize*`
   naming and signals "this is a recogniser that happens to live in the
   Z80 tree."  The `Z80` prefix stays (for directory consistency); the
   suffix carries the actual semantics.
2. **Record upstream candidacy in `tasks/upstream-coherence-map-*.md`.**
   A target-agnostic fork-local pass is by definition a U-LLVM Tier I
   candidate — its eventual home is upstream, even if we can't ship it
   there now (cyclic dep on Z80 mainlining, no in-tree consumer, etc.).
   The coherence-map row makes the upstream debt visible and traceable.
3. **Carry a one-line "rename history" note** in the `.h` / `.cpp`
   header if you rename — so the original name remains greppable for
   anyone landing on an old commit, comment, or debug log.

**Why:** naming dishonesty hides upstream debt.  A "Z80-prefixed"
recogniser reads as fork-territory work; a `Recognize`/`Combine`/etc.
suffix reads as "this is a candidate to land upstream when the moment is
right."  The team has been bitten by this once already
(`Z80LoopIdiomFill` lived for sessions before its target-agnostic body
was named honestly); the rename was free in code, expensive in lost time
to upstream packaging.

**How to apply:**
- When you propose a new pass, check the include list and any
  `Z80Subtarget` queries before naming.  No target consults => locative
  prefix only.
- When you find a pass whose name overclaims target-specificity, propose
  the rename + the coherence-map row in the same commit.  Rename costs
  are linear in callsites; debt costs compound.
- Sister `Z80*` passes to audit for the same naming question: the body
  is the test, not the file path.  Candidates include any pass whose
  `.cpp` doesn't dereference a `Z80Subtarget` / `Z80TargetMachine` /
  `Z80InstrInfo`.

**See also:**
- `tasks/design-upstream-memset-pattern-target-hook-2026-06-09.md`
  sections 7.2 (rename rationale) and 7.3 (why we don't bid for
  `LoopIdiomRecognize` extensibility).
- llvm-z80 commit `65cb811` (`Z80LoopIdiomFill` → `Z80PatternFillRecognize`).
- [[project_z80_upstream_goal]] — the staged collaboration model that
  this naming discipline serves.
- [[feedback_explain_before_filing]] — upstream-direction work is
  per-filing gated, so naming honesty in advance makes the filing
  defensible.

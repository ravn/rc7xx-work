---
name: Peephole lit tests must exercise -g
description: Every peephole that pattern-matches adjacent MachineInstrs must have lit-test coverage at both -O2 and -O2 -g, asserting the two outputs produce the same instructions (modulo .loc / .cfi / .debug_* directives).
metadata:
  type: feedback
---

When adding (or modifying) a peephole in `Z80LateOptimization.cpp` (or any
other backend file) that pattern-matches adjacent `MachineInstr`s, the
accompanying lit test MUST exercise both:

- `RUN: llc -mtriple=z80 -O2 ... < %s | FileCheck %s`
- `RUN: llc -mtriple=z80 -O2 ... < %s -debug-entry-values=true ...` or
  equivalent that exercises the `-g` / debug-info pipeline

…and assert that the two outputs produce the same real instructions
(diff allowed only on `.loc`, `.cfi`, `.debug_*` directives).

**Why:** under `-g`, `DBG_VALUE` / `DBG_LABEL` / `DBG_INSTR_REF` pseudo
MIs interleave between real MIs.  Peepholes that use `std::next(I)` to
match an adjacent pattern will land on the debug pseudo, fail the opcode
check, and silently bail.  Production binaries built with `-g` (every
finishing-firmware component does, for `.debug_loc` records in the
source-annotated `.lis` listing) will then miss the optimization.  This
is silent: the asm still works, but is larger and slower than the
without-`-g` codegen.  No lit test catches it unless the test compares
with-`-g` vs without-`-g` output.

**Historical instance:** ravn/llvm-z80#221 — the DJNZ peephole at
`Z80LateOptimization.cpp:884` (`DEC A; LD B,A; OR A; JR NZ → DJNZ`)
silently broke under `-g`, losing 4 bytes per innermost nested-countdown
loop in production autoload's `delay()`.  Discovered while refreshing the
issue-#7 DJNZ umbrella status.  Would have been caught on the day the
peephole was first authored if this rule had existed.

**How to apply:**

1. When writing a new peephole that uses `std::next` (or equivalent
   adjacency walk) on the MI stream, **first** check whether the rule
   [[feedback_peephole_next_nodbg]] applies (use `next_nodbg`).
2. **Always** add a lit test with two RUN lines: one at `-O2`, one at
   `-O2 -g`.  Use `FileCheck` with the SAME check pattern for both
   (the asm should be identical modulo debug-only directives).  A
   single-check-prefix lit test using two RUN lines is sufficient; no
   need for `--check-prefix` unless the outputs legitimately differ.
3. For an existing peephole that lacks `-g` coverage, treat adding the
   coverage as part of any nearby modification (boy-scout the test
   alongside other work).
4. Production-density regression: when fixing a peephole that was
   silently broken under `-g`, rebuild the four finishing-firmware
   components (autoload, cpnos PROM1, BIOS, rcbios) and confirm the
   expected byte improvement.

**Related:**

- [[feedback_peephole_next_nodbg]] — the code-convention companion;
  what the peephole code MUST do internally.
- [[feedback_compiler_bug_test]] — every compiler bug ships with a
  lit test.  This rule is the test-shape variant for peephole work.
- [[feedback_self_caused_bug_reflect_on_instructions]] — the
  meta-rule that prompted saving this one.

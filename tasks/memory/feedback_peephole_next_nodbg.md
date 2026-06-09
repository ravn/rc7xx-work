---
name: Peephole adjacency uses next_nodbg, not std::next
description: Any peephole that pattern-matches adjacent MachineInstrs must use MachineBasicBlock::next_nodbg() / skipDebugInstructionsForward() to skip DBG_VALUE / DBG_LABEL / DBG_INSTR_REF pseudos, not raw std::next.
metadata:
  type: feedback
---

When writing a peephole in `Z80LateOptimization.cpp` (or any other
backend file) that walks the `MachineInstr` stream to match an adjacency
pattern (e.g. "DEC A immediately followed by LD B,A immediately followed
by OR A immediately followed by JR NZ"), use one of:

- `MachineBasicBlock::next_nodbg(I, MBB.end())` — replacement for
  `std::next(I)` that skips debug pseudos.
- `llvm::skipDebugInstructionsForward(It, End)` — free function in
  `llvm/CodeGen/MachineBasicBlock.h` that skips debug pseudos in place.
- `MachineBasicBlock::SkipPHIsLabelsAndDebug(I)` — when also skipping
  PHIs and labels (e.g. when finding the first "real" instruction at the
  top of an MBB).

…instead of raw `std::next(I)`.  `MachineInstr::isDebugInstr()` returns
true for `DBG_VALUE`, `DBG_LABEL`, `DBG_INSTR_REF`, `DBG_PHI`.

**Why:** under `-g`, debug pseudo-MIs interleave between real MIs.  Raw
`std::next(I)` returns the literal next iterator, which lands on a debug
pseudo, the opcode check (`!= Z80::SomeOpcode`) fails, the peephole
bails, and the rewrite never happens.  Pseudos emit zero machine bytes
so the final asm doesn't show them — only the missing rewrite shows up
as a size regression.

The LLVM convention is well-known among experienced backend developers
but rarely surfaces in tutorials.  The AI default (and most introductory
LLVM peephole examples) uses raw `std::next` — which silently breaks
under `-g`.

**Historical instance:** ravn/llvm-z80#221 — the DJNZ peephole at
`Z80LateOptimization.cpp:884` (`DEC A; LD B,A; OR A; JR NZ → DJNZ`)
used raw `std::next`; production builds with `-g` lost 4 bytes per
innermost nested-countdown loop in autoload's `delay()`.

**How to apply:**

1. When writing or reviewing a peephole that walks adjacent MIs, scan
   for `std::next(I)` where `I` is a `MachineBasicBlock::iterator`.
   Each such use is a candidate for `next_nodbg`.
2. **Exception:** uses like `isRegDeadAfter(std::next(I), MBB, TRI, R)`
   are usually OK because liveness analysis already accounts for
   debug pseudos (they don't define / use real registers).  Audit the
   helper before assuming, though.
3. When erasing matched MIs, decide whether intervening `DBG_VALUE`s
   should also be erased.  Conservative choice: leave them; the
   debugger may show stale tracking but won't crash.  Aggressive choice
   (cleaner): erase them too, since they track values that no longer
   exist after the rewrite.
4. Pair this rule with [[feedback_peephole_test_with_g]] — without the
   `-g` test, future peepholes will quietly regress to `std::next`.

**Related:**

- [[feedback_peephole_test_with_g]] — the test-coverage companion;
  catches the bug even if the code-shape rule slips.
- [[feedback_self_caused_bug_reflect_on_instructions]] — the
  meta-rule that prompted saving this one.

**LLVM source pointers:**

- `llvm/include/llvm/CodeGen/MachineBasicBlock.h` lines 1485-1518:
  `skipDebugInstructionsForward`, `skipDebugInstructionsBackward`,
  `next_nodbg`, `prev_nodbg`.
- `llvm/include/llvm/CodeGen/MachineInstr.h`: `isDebugInstr()` predicate.

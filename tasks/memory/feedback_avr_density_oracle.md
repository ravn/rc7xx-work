---
name: avr-density-oracle
description: Use upstream AVR (in-tree 8-bit target) as a code-density oracle — compile the same C for AVR and Z80; large per-shape deltas point at Z80 backend gaps, not mid-end limits
type: feedback
---
**User directive 2026-06-07: use AVR as an oracle for code density on 8-bit machines.**

**Why:** AVR is the only in-tree 8-bit LLVM target (8-bit registers, 16-bit int — same C-promotion profile as Z80) with a mature backend. When AVR absorbs a shape cheaply and Z80 doesn't, the gap is OUR backend's expansion/lowering, not a generic mid-end limitation — and AVR's mechanism shows the fix. Discovered 2026-06-07: AVR triage exposed the i64 copy at Z80 65 instr vs AVR 37 (mechanism: ldd/std Z+q displacement addressing vs our per-limb address re-derivation) → Fix A (wide-copy block move) + Fix B (#27 IDX16 extension).

**How to apply:**
- Toolchain: upstream `~/llvm-upstream/llvm-project/build` built with `LLVM_TARGETS_TO_BUILD="X86;AArch64;AVR;MSP430"` (sonnyboy). `clang --target=avr -mmcu=atmega328p` / `llc -mtriple=avr`.
- Before blaming a generic pass or filing upstream: compile the repro for AVR too. AVR-free + Z80-expensive = fix the Z80 backend; both-expensive = candidate mid-end issue (then triage per [[thorough-tests-for-upstream-bugs]]).
- Instruction-count compare: `clang --target=<t> -Os -S -o - f.c | grep -cE '^\s+[a-z]'` (crude but effective for shape-level comparisons; byte counts need avr-size/z80 map for precision).
- Caveat: AVR has 32 registers vs Z80's 3 pairs — pressure-driven deltas are partly architectural, not all fixable. Idiom/addressing deltas are the actionable ones.

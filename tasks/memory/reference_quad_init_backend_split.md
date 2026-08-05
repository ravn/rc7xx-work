# 64-bit `.quad` global initializers: split in the llvm-z80 backend (ravn/z88dk#27)

**Resolution date:** 2026-08-05. **Supersedes** the external `splitquad.pl` pre-pass (deleted).

## The mechanism (verified, LLVM source + empirical)

`MCAsmStreamer::emitValueImpl` (`llvm/lib/MC/MCAsmStreamer.cpp`) picks a data
directive by size: 1→`Data8bitsDirective`, 2→16, 4→32, 8→`Data64bitsDirective`.
**When the chosen directive is `nullptr`, it splits the value** into the largest
power-of-two pieces `< Size` and emits each via the smaller directive (endianness
honoured). For an 8-byte value with `Data64bitsDirective == nullptr` but
`Data32bitsDirective` set, that is **two little-endian `.long`**.

Caveat: the split path first calls `Value->evaluateAsAbsolute`; a **non-absolute
(symbolic/relocatable)** 8-byte value hits `report_fatal_error("Don't know how to
emit this value.")`. Not reachable on Z80 — casting a 16-bit address to a 64-bit
initializer is rejected by the front-end as non-constant, so every `.quad` clang
emits is an absolute integer constant.

## The Z80 fix

`Z80MCAsmInfo` (the ELF/GNU class, `: MCAsmInfoELF`, used by
`clang --target=z80 -S` — the textual path the z88dk `-compiler=llvmz80` bridge
consumes) now sets **`Data64bitsDirective = nullptr`**
(`llvm/lib/Target/Z80/MCTargetDesc/Z80MCAsmInfo.cpp`). So clang emits e.g.
`0x4008000000000000` as `.long 0` / `.long 1074266112` — **no `.quad`**.

Key scope facts:
- Affects **textual `-S` only**. The integrated-assembler **ELF object** path
  (MCObjectStreamer/ELF writer) does **not** consult `Data*bitsDirective`; object
  emission still writes a correct 8 bytes. Two `.long` == one `.quad` byte-for-byte.
- The sdasz80 variant `Z80MCAsmInfoSDCC` already nulled both `Data32/64bits`
  (emits `.db`/`.dw`); this change is only the ELF/GNU class.
- Lit test: `llvm/test/CodeGen/Z80/quad-init-split-27.ll` (`CHECK-NOT: .quad`).
- E2e: `z88dk/test/clang/runtime_quadinit.{c,sh}` passes with `splitquad.pl` gone.

## Consequence for z88dk

`lib/llvmz80/splitquad.pl` deleted; removed from `bridge_postproc.sh`. copt's
existing `.long -> DEFQ` (4-byte) rule lowers each half. Requires a clang built
with this MCAsmInfo change (developed/shipped together in the fork).

---
name: feedback_use_math32_flag
description: For llvmz80 float/double builds use the literal `--math32` flag; do not substitute your own interpretation. Bridge currently incomplete.
metadata:
  type: feedback
---

When building float/double programs under `zcc +cpm -compiler=llvmz80`, use the
literal **`--math32`** flag verbatim. User directive (2026-08-06): "brug den i
sig selv" — do NOT reinterpret it as `-lmath32` / `-lm` / hand-rolled `-L…`
link lines. `--math32` is the z88dk alias that selects the math32 (IEEE-754
binary32) float runtime, which is the chosen FP path now that `double` is 32-bit
(see [[project_double_is_float32_retire_softfloat]]).

**Why:** since #277 clang emits 32-bit `sf` libcalls (`__addsf3` etc.); the
z88dk math32 runtime is the reuse target (it has a full libm). `--math32` is the
user-facing selector, so use it as the interface rather than its internals.

**How to apply:** put `--math32` on the zcc line for any FP build. Path B also
needs `-mllvm -z80-float-sdcccall0` (the sdcccall0 float ABI gate) and, in this
tree, the fmath bridge `-L<z88dk>/libsrc/l/llvmz80 -lllvmz80_fmath` until
`--math32` auto-injects it.

**Known gap (verified 2026-08-06):** the fmath bridge
`libsrc/l/llvmz80/llvmz80_fmath.lib` is INCOMPLETE — it bridges only
`__addsf3`, `__cmpsf2`, `__floatsisf`. Float programs still fail to link on
`__fixsfsi` (float→int), `__gtsf2`/`__ltsf2` (compares), `__mulsf3`, etc.
Relevant to ravn/z88dk#44: math32 is the intended replacement for the retired
64-bit `llvmz80-softfloat/`, but it is not yet a complete runtime — do not
retire softfloat's role until the math32 bridge covers the common `sf` libcalls.
Bridge coverage doc: `z88dk/libsrc/l/llvmz80/MATH32_BRIDGE.md`.

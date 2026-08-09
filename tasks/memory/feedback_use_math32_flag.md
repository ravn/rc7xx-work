---
name: feedback_use_math32_flag
description: For llvmz80 float/double builds use the literal `--math32` flag; do not substitute your own interpretation. Bridge complete + auto-linked (#44, 2026-08-09).
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

**How to apply:** put `--math32` on the zcc line for any FP build. As of
ravn/z88dk#44 (2026-08-09) `zcc` **auto-links the fmath bridge** for every
`-compiler=llvmz80` program (config var `LLVMZ80FMATH`) and auto-injects the
sdcccall0 float ABI gate (`-mllvm -z80-float-sdcccall0`), so a plain `--math32`
is now enough — no manual `-L<z88dk>/libsrc/l/llvmz80 -lllvmz80_fmath` needed.

**Bridge now COMPLETE (2026-08-09, ravn/z88dk#44):** `llvmz80_fmath.lib` was
rebuilt from all three sources (via `build_fmath_lib.sh`) and now exports the
full family — arith `__addsf3`/`__subsf3`/`__mulsf3`/`__divsf3`, compares
`__cmpsf2`/`__gtsf2`/`__gesf2`/`__unordsf2` (+ `__cmpsf2_fast`), conversions
`__fixsfsi`/`__fixunssfsi`/`__floatsisf`/`__floatunsisf`. A comprehensive
arith+compare+conv program links with plain `--math32` and runs correctly on
z88dk-ticks. This CLEARS the #44 blocker: `--math32` is a complete FP runtime,
so softfloat's role can now be retired (the tree deletion itself is the
remaining #44 work). Bridge coverage doc:
`z88dk/libsrc/l/llvmz80/MATH32_BRIDGE.md` §4/§4a.

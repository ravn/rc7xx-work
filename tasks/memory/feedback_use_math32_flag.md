---
name: feedback_use_math32_flag
description: For llvmz80 float/double builds use the literal `--math32` flag; do not substitute your own interpretation.
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

**Current triple integration:** pass `--math32` to select the z88dk runtime.
For `z80-unknown-none-z88dk`, llvm-z80 calls existing `cm32_sdcc_*` entries
directly with `Z80_SDCCCall0`; do not add the historical `llvmz80_fmath.lib`
aliases or `-z80-float-sdcccall0` gate. See
`[[project_z88dk_math32_direct]]`.

**Version note:** this advice predates z88dk's math32 lift from 2.4 to 2.5.
In v2.4, math32 lived under `_DEVELOPMENT/` and `-lm` defaulted to genmath.
The current v2.5 development line makes math32 the default `-lm`; use the
explicit `--math32` selector when the build must state its runtime choice.

The 2026-08-09 `llvmz80_fmath.lib` / `LLVMZ80FMATH` description is historical:
it records the earlier generic `-compiler=llvmz80` path, not the current
triple-native integration. Do not use it as evidence for the active ABI or
link recipe.

---
name: project_double_is_float32_retire_softfloat
description: On z80, double is 32-bit binary32 (float32-math32, #277). The 64-bit llvmz80-softfloat/ closure is superseded — retire it.
metadata:
  type: project
---

Since the `float32-math32` merge (`4d3a32eff207` into llvm-z80 main, 2026-08-05;
tracking ravn/llvm-z80 #277), on the z80/sm83 target **`double` == `long double`
== 32-bit IEEE-754 binary32** (same width/format as `float`). Confirmed on
`build-macos` clang: `__DBL_MANT_DIG__ 24`, `sizeof(double)==4`, `double add()`
lowers to `___addsf3` (the `sf` libcall), never `___adddf3`. Pinned by
`clang/test/CodeGen/z80-double-is-float32.c`; design in
`llvm-z80/tasks/design-2026-07-31-float32-math32-strategy.md`. The chosen FP
runtime is z88dk **math32** (the only one that ships a full libm).

Consequence — user directive (2026-08-06), tracked in **ravn/z88dk#44**: **clean up / retire `llvmz80-softfloat/`.**
It is a *64-bit* Berkeley-SoftFloat closure (`__floatsidf`/`f64`/`i2d`, IEEE
`printf` work for #273/#31/#35). A 64-bit double implemented *outside* the
standard runtime does not make sense on z80 now that `double` is 32-bit — clang
no longer emits `df` libcalls to bridge to. In scope when doing the cleanup:
the `llvmz80-softfloat/` tree + its built `softfloat_cpm_z80.lib`
(`LLVMZ80RTLIB`), its `tests/ft_*.c` (ft_rocst / ft_i2d / ft_dbl all assume
64-bit), and the 64-bit-double / IEEE-printf paragraphs in CLAUDE.md.

**Why:** the ABI moved under these artifacts; leaving a superseded 64-bit
soft-float closure around invites re-linking dead code and mis-scoped bug
reports (e.g. ft_rocst now reads 0 not because of a bug but because it checks
`>>48` of a 32-bit value).

**How to apply:** treat 64-bit double on z80 as not-a-goal. Before touching
anything under `llvmz80-softfloat/`, assume it is being retired, not extended.
Any surviving `.rodata.cstN` regression guard (ravn/z88dk#30) should be rebuilt
ABI-independently (e.g. `const long long[]` → `.rodata.cst32`, or `const int[]`
→ `.rodata.cst8`), not on a 64-bit-double construct. See
[[reference_quad_init_backend_split]] (#27, the sibling 64-bit-init issue that
is about i64 globals, still live) and [[reference_z88dk_calling_conventions]].

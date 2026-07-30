---
name: newlib IEEE-754 %f printf fix (#35) — split __mulsi3 + per-clib shim + __ZXNEXT trap
description: How transparent %f printf was wired onto the newlib CP/M clang route; three non-obvious gotchas
type: reference
---

**Fixed 2026-07-25.** Stock `printf("%f")` on `-clib=newlib_iy`/`newlib_ix` with
`-D__LLVMZ80_IEEE_PRINTF` now formats clang IEEE-754 `double` correctly, mirroring
the classic route. newlib_iy 24 PASS / 0 FAIL, classic 25/0. z88dk commit
cbbcc50031 (+ workspace intrt/softfloat split). Three gotchas, each cost time:

## 1. `__mulsi3` collision (softfloat vs newlib imath) — split into its own TU
The shared `softfloat_cpm_z80.lib` bundles a compiler-rt integer runtime whose
`intrt` module defined `___mulsi3` alongside 64-bit `__muldi3`/di helpers. On the
newlib route `llvmz80_imath.lib` ALSO defines `___mulsi3` → `duplicate definition`
when a double program links both. classic can't drop softfloat's copy (no imath);
newlib can't drop imath's (integer-only long*long needs it). Fix: moved `__mulsi3`
to its OWN TU `llvmz80-intrt/src/intrt_mulsi3.c` (+ build64.sh compiles it
separately, + intrt self-tests link both). Now it is pulled ON DEMAND: classic
gets it from the standalone module; newlib already has imath's so softfloat's
standalone is not pulled. z80asm only pulls a lib module to satisfy an
unresolved symbol — isolating a symbol lets two libs "share" it collision-free.

## 2. The shim is clib-COUPLED — needs a per-clib copy
`llvmz80-softfloat/src/npf_printf.c` (the nanoprintf `__llvmz80_printf` family)
compiles the classic clib's `stdout`/`putchar` MACROS, which bake in `_sgoioblk`
(classic `#define stdout &_sgoioblk[1]`, `#define putchar(c) fputc_callee(c,stdout)`).
Those symbols don't exist on newlib → `undefined symbol: __sgoioblk`. The f64 math
cores have NO stdout dep (pure math), only the printf shim does. Fix: compile the
SAME shim source against the NEWLIB headers into
`z88dk/libsrc/l/llvmz80/newlib/llvmz80_printf_newlib.lib`
(`build_printf_newlib_lib.sh`, force-committed like imath). The newlib_iy/_ix CLIB
lists it BEFORE the softfloat archive so z80asm resolves `__llvmz80_*` there and
never pulls the archive's classic shim. f64 cores still come from the shared
archive via LLVMZ80RTLIB (zcc appends it for ANY `-compiler=llvmz80` link, not
gated on clib — zcc.c ~line 1256).

## 3. The `#ifdef __ZXNEXT` placement trap (the big time sink)
The `_DEVELOPMENT/common/stdio.h` (and its m4 source `proto/stdio.h`) end with a
big `#ifdef __ZXNEXT ... #endif` region right before the include-guard `#endif`.
Inserting the `__LLVMZ80_IEEE_PRINTF` block "at the end of the file" landed it
INSIDE `__ZXNEXT` → skipped on the CP/M target → `#define printf __llvmz80_printf`
silently never took effect (asm still `call _printf`). Diagnosis method that
finally worked: an UNCONDITIONAL `#error` fired (file IS included) but the
conditional one didn't → trace `#if`/`#endif` NESTING DEPTH to the block; found
it at depth 3 under `#ifdef __ZXNEXT`. Fix: move it AFTER the `__ZXNEXT` `#endif`,
at guard depth 1. LESSON: when a header macro "doesn't apply", verify the
insertion is in an ACTIVE preprocessor region before suspecting the -D flags.

Related: [[reference_newlib_remaining_gaps_file_printf]],
[[reference_newlib_integer_helper_gap]], [[reference_llvmz80_qsort_strerror_classic_fix]].
Remaining newlib gap: #34 disk FILE* (no CP/M open driver).

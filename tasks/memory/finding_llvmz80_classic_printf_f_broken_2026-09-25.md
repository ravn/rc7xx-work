---
name: finding-llvmz80-classic-printf-f-broken
description: "zcc +cpm -compiler=llvmz80 --math32 (classic clib, no newlib): double arithmetic is correct but printf(\"%f\") prints 0.000000 for all values"
metadata:
  type: reference
---

**Fact (found 2026-09-25, session testing fresh llvm-z80 main build against z88dk):**
`zcc +cpm -compiler=llvmz80 --math32 -O2` (classic clib, the default -- no
`-clib=newlib_iy`) compiles and links cleanly, and IEEE-754 `double`
arithmetic is verifiably correct: `int i = (int)(a * 1000)` with `a=3.5`
printed the correct `3500` under `ntvcm`. But `printf("%f", sum)` /
`printf("%f", prod)` / `printf("%f", quot)` all print `0.000000` regardless
of the actual value.

**Root-cause hypothesis (not verified):** printf's `%f` dtoa path under
classic clib still expects the old sccz80 48-bit float format, not the
IEEE-754 binary32 `double` clang/llvmz80 actually produces. The known fix
for this class of bug (`[[reference_llvmz80_newlib_ieee_printf_fix]]`,
`-D__LLVMZ80_IEEE_PRINTF`) was implemented ONLY for `-clib=newlib_iy`/
`newlib_ix` (2026-07-25, #35) -- classic clib was apparently never covered.

**Repro:**
```c
double a = 3.5, b = 2.0;
printf("sum=%f\n", a + b);        // prints "sum=0.000000", should be 5.5
printf("int=%d\n", (int)(a*1000)); // prints "int=3500" -- correct
```
Build: `zcc +cpm -compiler=llvmz80 --math32 -O2 test.c -o test.com`, run under
`ntvcm` (not `emu2` -- that's the CP/M-86/x86 emulator in `emu2-cpm86`, wrong
architecture for classic Z80 CP/M `.com`; `[[reference_z88dk_runtime_verify_ntvcm]]`
covers the ntvcm-vs-ticks distinction but not this emu2-vs-ntvcm one).

**Status: noted, not investigated further** (user: "fund" -- just record it,
2026-09-25). No fix proposed. Next step if picked up: find classic clib's
`%f` dtoa call path (likely `stdlib/z80/__dtoa__.asm` family, same files
that gave undefined-symbol link errors when `--math32` was OMITTED) and
check whether it needs the same `__LLVMZ80_IEEE_PRINTF`-style redirect as
newlib got, or a distinct classic-side fix.

**Related:** [[reference_llvmz80_newlib_ieee_printf_fix]] (the newlib-only
fix this gap parallels), [[project_double_is_float32_retire_softfloat]]
(math32 background), [[feedback_use_math32_flag]] (why `--math32` is
required at all for llvmz80 double libcalls).

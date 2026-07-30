---
name: llvmz80 classic qsort/strerror/bsearch fix — reversed-arg-alias-via-asm-label pattern
description: How #33 qsort + #32 strerror + bsearch were fixed on classic clang; reusable stdlib.h bridging technique for callback+multi-arg __smallc funcs
type: reference
---

**Fixed 2026-07-24, ravn/z88dk commit 9e13c271c2.** The two classic clang
regressions from the 2026-07-23 upstream merge, plus a bonus bsearch win.
Classic clang suite 24 PASS / 0 FAIL, newlib_iy 23 PASS / 0 FAIL.

## #33 qsort — reversed-arg alias via `__asm()` label (the reusable trick)

Upstream redesigned qsort: one shared sort core + per-compiler comparator thunks
reached through entries `_qsort`/`_bsearch`; the clang thunk `l_cmp_sdcc`
marshals the two comparator operands **on the stack**. Two coupled ABI facts,
both fixed **purely in `include/stdlib.h`** under `#if defined(__LLVMZ80)` — no
new asm module, no library rebuild:

1. **Comparator must be `__smallc`** (== `sdcccall(0)` for clang): the thunk
   passes operands on the stack, so a default `sdcccall(1)` comparator (arg0 in
   HL) is miscalled. Type the `compar` parameter as pointer-to-`__smallc`
   -function so clang's `-Wincompatible-function-pointer-types` passes:
   `int (*compar)(const void*, const void*) __smallc`.

2. **Argument order is REVERSED.** clang's `__smallc`/`sdcccall(0)` pushes a
   call's args **right-to-left** (arg0/base ends up on TOP, nearest the ret);
   the `_qsort` asm entry expects z88dk `__smallc` **left-to-right** (base
   deepest, compar on top). Bridge with a reversed-arg alias bound to the
   existing library symbol + a swapping macro:
   ```c
   extern void __qsort_llvmz80(int (*compar)(...) __smallc,
                               unsigned size, unsigned nmemb, void *base)
       __smallc __asm("qsort");            // clang re-prepends '_' -> _qsort
   #define qsort(base,nmemb,size,compar) \
           __qsort_llvmz80((compar),(size),(nmemb),(base))
   ```
   Verified emits `call _qsort` with compar pushed last (on top), base first.

**`__asm()` label gotcha:** the z80 target prepends `_` to asm labels too, so
`__asm("qsort")` → symbol `_qsort` (and `__asm("_qsort")` → `__qsort`, wrong).
Use a **macro**, not an inline wrapper named `qsort` — an inline `qsort` would
collide with the `_qsort`-labelled extern and clang folds it to infinite
recursion. (This is why the `__ZPROTO` family in `include/sys/proto.h` uses a
distinct `__##n` symbol + a bridge asm; the asm-label variant avoids the bridge
when you can bind straight to the real entry.) Same treatment applied to
`bsearch` (`__bsearch_llvmz80` → `_bsearch`, 5 args, key deepest).

## #32 strerror — module was simply missing from the lib

`asm_strerror` (cpm_clib) leaves `__rodata_error_strings_head` undefined;
ravn's `__strerror_table.asm` defines it. `z88dk-z80nm -a lib/clibs/z80_crt0.lib`
proved the module was **not in the lib at all** (symbol only ever `U`, never
`G`). A stale comment in the .asm claimed a "buildcrt obj-glob" pulled it and it
must NOT be in `llvmz80.lst` — false. Fix: add
`${NEWLIB_ROOT}l/llvmz80/__strerror_table.asm` to `libsrc/l/llvmz80.lst`
(sibling of `__divhi3`/`__itoa`, which `classic/z80_crt0s/newlib-z80.lst` pulls
into z80_crt0.lib), rebuild `TARGETS=z80` + install. No double-inclusion: no
classic module declares `section rodata_error_strings`, and the clang newlib
route (`-nostdlib`) never links z80_crt0.lib. See
[[reference_z88dk_lib_toolchain_native]] for the rebuild recipe (and the newlib
`.lib` re-build caveat after a `TARGETS=z80 clean`).

## bsearch bonus

Upstream now ships a standard 5-arg `_bsearch`; the reversed-alias treatment
makes it work on classic. `xfail_bsearch` ("classic-design gap, only 4-arg
l_bsearch") is obsolete → retired to `runtime_bsearch` (PASS classic + newlib),
newlib skip removed from `run_all.sh`.

Related: [[reference_newlib_integer_helper_gap]],
[[reference_newlib_signed_mod_z88dk_bug]],
[[reference_clang_double_duty_ez80_llvmz80]].

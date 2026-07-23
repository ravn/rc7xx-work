---
name: newlib clang route needs gcc-style integer helper libcalls
description: The clean -clib=newlib_iy clang route lacks __mulhi3/__divsi3/__divmodsi4 etc.; the ABI bridge disappears but the integer-helper bridge does not
type: reference
---

**Fact (found 2026-07-23, Phase C of the newlib-llvmz80 plan):**

The sanctioned clang newlib route (`-clib=newlib_iy` / `newlib_ix`,
`-compiler=llvmz80`) removes the ABI-adapter `ex de,hl` bridge, BUT clang still
lowers runtime 16/32-bit mul/div/mod to **gcc-style helper libcalls** that newlib
does NOT provide:

    __mulhi3  __umulhi3  __umodhi3   (16-bit, e.g. an LCG's * and %)
    __divsi3  __modsi3  __udivsi3  __umodsi3
    __divmodsi4  __udivmodsi4        (32-bit long div/mod)

On the CLASSIC clib path these come from `libsrc/l/llvmz80/__divhi3.asm` and
`__divsi3.asm`, but those objects `INCLUDE "config_private.inc"` and call classic
clib cores (`l_mulu_16_16x16`, `l_divs_32_32x32`, …) — they are tied to the
classic-clib build context and are NOT linkable into a `-nostdlib` newlib build.

**Symptom:** link fails `undefined symbol: ___divsi3` (etc.) — the z80asm `___`
== C `__`.  Blocks any newlib_iy program doing runtime integer mul/div/mod
(tests: runtime_qsort, runtime_intdiv, runtime_long — all SKIP with reason
"integer-helper gap"; the ABI itself is fine, proven by a mul-free __smallc
qsort comparator that sorts correctly).

**Why sdcc_iy hid it:** the UNSUPPORTED `-clib=sdcc_iy` override forces
`-compiler=sdcc`, so a `z88dk-ucpp -D__SDCC` pass preprocesses first and routes
`long` arithmetic to symbols that DO exist in the newlib sdcc archive.  The clean
clang path emits the gcc names instead.

**Corrects the plan's optimism:** "the ex-de-hl bridge layer disappears entirely
on newlib" is true only for the *ABI adapter*; the *integer-helper* part of the
bridge does not disappear.  Next blocker for the newlib route = provide
self-contained `__mulhi3`/`__divsi3`/`__divmodsi4`/… for newlib (or a
newlib-context build of the llvmz80 integer bridge).  See
[[plan-newlib-llvmz80-support-2026-07-22]] and
[[reference_newlib_sdcc_iy_uses_ix_archive]].

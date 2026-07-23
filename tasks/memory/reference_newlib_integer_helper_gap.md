---
name: newlib clang integer helper libcalls — CLOSED via llvmz80_imath.lib
description: The -clib=newlib_iy clang route lacked __mulhi3/__divsi3/... ; now provided by llvmz80_imath.lib. Signed 8/16-bit mod is a separate z88dk newlib bug.
type: reference
---

**RESOLVED 2026-07-23.** Provided the clang integer-helper libcalls on the
newlib route via `z88dk/libsrc/l/llvmz80/newlib/llvmz80_imath.lib` (built by
`build_imath_lib.sh` from thin adapters `__divhi3/__divsi3/__udivqi3/__mulsi3`
that call the l_* cores already bundled in the newlib archive; wired into the
newlib_ix/newlib_iy CLIB lines; force-committed past `**/*.lib` ignore).
runtime_qsort/intdiv/long now PASS on newlib. `__mulsi3` (32-bit multiply) was a
NEW gap — `long*long` failed to link on classic too (classic still lacks it).
**Separate z88dk newlib bug found:** 8/16-bit signed `%` returns `|a%b|` (sign
dropped) on newlib — stock sccz80/sdcc reproduce it, stale prebuilt libs predate
upstream fix af5630797c. Bridge matches z88dk (parity accepted); tracked by
`test/clang/xfail_signed_mod.*` + `BUG_newlib_signed_mod.md`. See
[[reference_newlib_signed_mod_z88dk_bug]]. Original gap description below.

---
name: newlib clang route needs gcc-style integer helper libcalls (historical)
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

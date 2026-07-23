---
name: z88dk newlib 8/16-bit signed modulo returns |a%b| — RESOLVED by lib rebuild
description: Was a stale-prebuilt-lib bug (not clang); FIXED 2026-07-24 by merging upstream + rebuilding the newlib libs (fix af5630797c)
type: reference
---

**RESOLVED 2026-07-24.** Merged upstream/master into ravn/z88dk and rebuilt the
newlib libs (`make -C libsrc/newlib cpm-clean && make -C libsrc/newlib cpm`) —
signed 8/16-bit `%` is now C-correct on newlib for BOTH llvmz80 and stock sccz80
(`-30000%7 == -5`). The rebuild is native (no Docker — see
[[reference_z88dk_lib_toolchain_native]]). `xfail_signed_mod` now PASSES
(regression guard). Upstream z88dk should regenerate its committed prebuilt
newlib archives. Merge also left 2 classic clang regressions (ravn/z88dk #33
qsort, #32 strerror) — see
`z88dk/test/clang/FOLLOWUP_classic_qsort_strerror_after_upstream_merge.md`.
Original diagnosis below.

---

**Found 2026-07-23.** z88dk's **newlib** library returns `|a % b|` for 8-bit and
16-bit **signed** modulo (the remainder-sign negation is dropped); C requires the
sign of the dividend. `-30000 % 7` → `+5` on newlib, `-5` (correct) on classic.

**NOT a clang bug** — stock z88dk reproduces it with its OWN compilers, and ONLY
on newlib (proving it is the library):

| compiler | classic | newlib |
|---|:-:|:-:|
| sccz80 | -5 ✓ | +5 ✗ |
| sdcc | +5 ✗ | +5 ✗ |
| llvmz80 | -5 ✓ | +5 ✗ |

32-bit signed mod and all division (quotient) are correct. sdcc is also wrong on
classic (its own `__modsint`).

**Root cause:** the 16-bit signed-divide source was fixed upstream in
**af5630797c** (suborb / Dominic Morris, 2026-06-28, in upstream/master:
`l_small_divs_16_16x16.asm` `jp m`→`call m`). But the committed prebuilt newlib
archives under `libsrc/newlib/lib/` were last regenerated **2026-03-26**
(948098a908) — they predate the fix and ship the stale buggy core. The classic
clib is assembled from current (fixed) source, so it is correct. **Fix = rebuild
the newlib libs.** (Audit the 8-bit `-Os/-Oz` path too.)

**Decision (user 2026-07-23):** treat as a z88dk bug; matching z88dk's own
newlib result is "good enough for now". The llvmz80 integer bridge
([[reference_newlib_integer_helper_gap]]) faithfully reproduces it and must NOT
paper over it — the fix belongs in z88dk newlib. Report:
`z88dk/test/clang/BUG_newlib_signed_mod.md` (staged for later upstream filing).
Ignored test: `z88dk/test/clang/xfail_signed_mod.{c,sh}` — PASS on classic,
XFAIL on newlib (retire the xfail when the newlib libs are rebuilt).

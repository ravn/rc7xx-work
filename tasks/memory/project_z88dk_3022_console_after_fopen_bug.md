---
name: project_z88dk_3022_console_after_fopen_bug
description: z88dk newlib +cpm bug — fopen corrupts stdout so console output after fopen is lost. Maintainer-CONFIRMED (memory reuse, default subtype); test PR #3031 open, feilipu will fix then merge.
metadata:
  type: project
---

**z88dk/z88dk#3022 / PR #3031** — newlib `+cpm` defect found while wiring the
#3025 CP/M FCB file driver.

**Symptom (deterministic):** after an `fopen()`, console output is misrouted
into the file — `puts("BEFORE"); fopen(...); puts("AFTER")` prints only
`BEFORE` on newlib; the file write path itself is fine. Classic clib
unaffected. Reproduces under stock sccz80 (`-clib=new`) AND SDCC
(`-clib=sdcc_iy`) AND clang-llvmz80, so it is a newlib CP/M stdio/fcntl bug,
NOT a compiler calling-convention issue.
- clang manifests worse: with `fflush(stdout)` after fopen it HANGS in
  `asm_p_forward_list_push_front` on a circular stdio stream list. Without
  fflush it just loses the line (clean, assertable).

**Our localization** (session 2026-07-28): `fopen` rebinds/reuses stdout's
FILE/stream so its driver dispatch points at the file driver. Ruled out: clang
conventions (SDCC hits it), FILE open/closed-list overlap, fopen_max/open_max
config counts (10/16, 6 static).

**Maintainer CONFIRMED (feilipu, 2026-07-28):** "confirmed on default. It is a
**memory reuse issue** that is only in the **default subtype**. Will provide a
fix then merge your test PR." — validates the reuse/aliasing localization.

**Status:** PR #3031 (`test/suites/target_io/console_after_fopen.c`, stock
sccz80 repro) OPEN, awaiting feilipu's fix + merge. When merged/fixed:
re-verify and flip our fork's XFAIL test `z88dk/test/clang/runtime_file_console.{c,sh}`
(currently XFAIL on all newlib routes, PASS on classic) → it auto-emits XPASS
when the gap closes. Repro verified under ntvcm. See
[[reference_z88dk_direction_classic_not_newlib]],
[[reference_z88dk_native_z80asm_perl_patch]].

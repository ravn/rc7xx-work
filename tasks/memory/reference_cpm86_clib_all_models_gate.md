---
name: reference_cpm86_clib_all_models_gate
description: CP/M-86 Watcom clib now builds+passes runtime tests in ALL three memory models (s/m/c); run-all-models.sh is the gate; compact no longer blocked
metadata:
  type: reference
---

# CP/M-86 Watcom clib: all-memory-models runtime gate (2026-08-20)

`open-watcom-v2/contrib/ravn/watcom-cpm86-libc/run-all-models.sh` builds the
CP/M-86 C library for **small (s), medium (m) AND compact (c)** and runs the
runtime-library functional suite against each, from the ONE installed model lib
`lib286/cpm86/clib{s,m,c}.lib` (no bespoke object list — a link failure means a
routine is genuinely missing from the archive, which is what the gate catches).

`run-all-models.sh` is now ONE command: it builds+installs each model's clib+libm
via `build-lib.sh` if missing (or `BUILD=1` to force), then runs the gate. Process
docs: `docs/BUILDING_ALL_MODELS.md` + `docs/FLOAT_PRINTF.md`.

**Result matrix (all GREEN, 18 PASS / 0 FAIL / 0 SKIP):** heap / stdio / float /
math / fltfmt PASS in s, m, c under the Unicorn runner (`cpm86run_unicorn.py`, applies P_LOAD
reloc so it runs m+c too). **disk PASS in s, m AND c under emu2** — emu2 now also
applies P_LOAD relocation (`[[reference_cpm86_emu2_p_load_reloc]]`, closes
ravn/emu2-cpm86#1), so it runs medium/compact .CMDs with the file BDOS the
Unicorn harness lacks. The former m/c disk SKIP (MAME-only) is GONE. NB: needs
the reloc-capable emu2 on `EMU2`/PATH; an older emu2 mis-loads m/c disk.

**Compact model is NO LONGER blocked** (contradicts the old `-mc` BLOCKED note in
`build-lib.sh` + `[[reference_watcom_cpm86_heap_shim]]`): the wlink type-3 EXTRA
fix (`09c2eb3099`, `[[reference_wlink_cpm86_far_data_type3]]`) placed program far
data in one loader-placeable group, so `__heap_enabled` now reads 1 and the
TRANSPARENT far `malloc()`/`realloc()` path runs — compact heaptest allocates via
the far heap and round-trips. Link compact programs with `option farheap=<size>`.
Open residual: far-HEAP-vs-far-DATA slab overlap for programs with LOTS of far
data (`cmd_check.py [F1]`, `test/compact_farheap_test.c`); heaptest's small far
data doesn't hit it.

## Routines added to the archive to make all models complete (build-lib.sh)

Driven by resolving every undefined symbol when tests link the FULL model lib:
- `cprintf` (port helper: direct-to-console printf for stdio-free tests)
- `qsort` (stdlib)
- `bexpand` (`_bexpand`: based/far realloc grow-in-place core)
- `fexpand` (`_fexpand`) + `fmemcpy` (`_fmemcpy`): far `realloc()` deps (compact)
- soft-float package (double, -fpc, NO 8087, `__real87=0` path):
  `fdmth086` (__FDA/S/M/D), `fdi4086` (__FDI4 double→long),
  `i4fd086` (__I4FD long→double), `chipd16` (__fdiv_m64r), `emustub` (FIxRQQ),
  `fpsupport` (F8Over/Under/DivZero), `fpsoftstub` (__real87=0).
  NB: programs using `double` must compile `-fpc` (else the -fpi 8087-emulator
  path pulls `__CHP` etc., which are NOT archived — by design, no 8087 here).

## libm (transcendentals) NOW per-model too (2026-08-20)

sin/cos/atan/exp/log/sqrt work in ALL three models via a separate per-model
`libm{s,m,c}.lib` (the classic -lc/-lm split, installed alongside clib). Why
per-model and not one: the arithmetic is identical but the objects differ for two
real reasons — **code model** → near vs far RET (a medium far-code caller must
far-call; verified `mm/atan.obj` uses `retf`, `ms`/`mc` near `ret`), and **data
model** → a function's private coefficient tables sit in DGROUP (near data: s/m)
but are EMBEDDED in the code segment for far-data compact (verified: `mc/atan.obj`
`_TEXT` is ~123 B larger, holding the L$n coefficient doubles). So one libm can
only serve same-code-model programs; per-model is required (Watcom itself ships
mc/mm/ms/ml/mh mathlib). `build-lib.sh` archives Watcom's stock 80186-safe
SOFT-FLOAT mathlib (`mathlib/library/msdos.286/m$MODEL`, 0 x87 + 0 286-only
opcodes) into `libm$MODEL.lib`.

To make libm linkable, build-lib.sh also gained its clib-side deps: the rest of
the soft-float core (`__FDC` compare, `__FDN`/`__FSN` negate, `__FDFS`/`__FSFD`
conversions, `fstat086` status), the fpu atan/tan wrappers (`chipw16`/`chipt16`/
`chipa16`), math seams (`seterrno`, `rtcntrl`, `iobaddr`, `_matherr`, `hugeval`),
plus two tiny no-8087 stubs in `port/`: `fesoft.c` (soft `feraiseexcept`, since
stock `fenv.c` is inline-8087) and `_fltused_` in `fpsoftstub.asm` (the marker
alone, WITHOUT stock fltused.c's `AXIN(__setEFGfmt)` %f-formatter cascade).
Programs that want `printf("%f")` link `setefg.c` explicitly. Test:
`test/mathtest.c` (scaled-integer oracle) — `run-all-models.sh` math row, 15/15.

## Real %e/%f/%g printf — DONE, opt-in (2026-08-20)

Works in all 3 models (`fltfmt` row, oracle `f=3.1416 e=2.500e+00 g=0.001`). It is
OPT-IN because the dtoa/cvt subsystem is ~4 KB: a program must (1) compile `-fpc`,
(2) call `__setEFGfmt()` ONCE before its first %f (our minimal crt0 does NOT walk
Watcom's auto-init table, so the formatter isn't installed automatically), and (3)
link libm (which carries `_EFG_Format`/`__cnvs2d`). The formatter chain (`setefg`,
`cvt`, `ldcvt`, `efcvt`, `gcvt`, `cvtbuf`, `i8ls086`=__U8LS 64-bit shift) is
archived in clib but pulled ONLY by the `__setEFGfmt` reference, so integer-only
programs pay nothing (default = the `noefgfmt` stub). Full how-to:
`docs/FLOAT_PRINTF.md`. Test: `test/floatfmt_test.c`.

## NOT included

`scanf("%f")` (read side `__cnvs2d` archived but untested) and `%a` hex-float.

## Also fixed this session

`con_write()` CR/LF idempotency in `port/diskio.c` now keeps `prev` STATIC across
`__qwrite` calls, so a "\r\n" split on a FILE-buffer boundary no longer injects a
spurious CR ("\r\r\n"). See `[[reference_watcom_cpm86_heap_shim]]`.

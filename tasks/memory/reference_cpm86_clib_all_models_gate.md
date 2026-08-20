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

**Result matrix (all GREEN, 12 PASS / 0 FAIL / 0 SKIP):** heap / stdio / float
PASS in s, m, c under the Unicorn runner (`cpm86run_unicorn.py`, applies P_LOAD
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

## NOT included (separate subsystem)

libm transcendentals (sin/cos/atan/exp/log/sqrt, `IF@Dxxx`) are still
small-model-only: build-whetstone.sh links them from PREBUILT msdos.086/286
small-model objects (`mathlib/library/msdos.286/ms`), not a per-model source
compile. Adding libm across models is a distinct, larger effort with
model/precision risk — out of scope for the core runtime-library gate.

## Also fixed this session

`con_write()` CR/LF idempotency in `port/diskio.c` now keeps `prev` STATIC across
`__qwrite` calls, so a "\r\n" split on a FILE-buffer boundary no longer injects a
spurious CR ("\r\r\n"). See `[[reference_watcom_cpm86_heap_shim]]`.

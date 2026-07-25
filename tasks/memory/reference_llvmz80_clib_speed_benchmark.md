---
name: llvmz80 classic-vs-newlib speed — depends on op; qsort gap = shellsort vs quicksort
description: Benchmark verdict (compiler fixed, lib varies); newlib ~half size; newlib qsort slow only because CP/M newlib picks shellsort (tunable)
type: reference
metadata:
  type: reference
---

**Benchmark 2026-07-26** (full data + harness: `tasks/benchmarks/
llvmz80-clib-speed-2026-07-26.md` + `bench_lib.c`). Compiler held fixed
(llvmz80 -O2), only `-clib` varies (default=classic vs newlib_iy). Cycle-accurate
via `scratch/dcc-clang-bench/ticks_cpm.py` (NOT ntvcm — its DD/FD/ED cycles are
wrong).

**Verdict: no single winner — depends on the operation; compiler codegen is
identical between routes (only library calls differ, so pure compute is equal):**
- qsort: **classic 1.51× faster** (82.9M vs 125.3M).
- sprintf: **newlib 1.47× faster** (18.5M vs 27.2M).
- string (strcpy/strlen/memcpy): ~tie.
- **newlib ~half the .com size** across the board.

**qsort gap root cause (verified):** both share `libsrc/stdlib/z80/sort/`, but
`__CLIB_OPT_SORT` differs — classic=2 (quicksort, `qsort_core.asm`), CP/M
newlib=1 (**shellsort**, template `libsrc/newlib/target/cpm/config/config_clib.m4:470`
-> generated `config_cpm_private.inc`; edit the .m4 not the .inc). Setting it to
2 + `make -C libsrc/newlib cpm-clean && cpm` cut newlib qsort 125.3M->93.2M
(−26%) for +194 B (gap to classic +51%->+12%). Change was REVERTED (shellsort is
the z88dk default; switching is a size/speed + z88dk-target decision, not shipped).

Note: a naive combined benchmark read "newlib 38% slower overall" — that was
qsort-dominated and misleading; always split per operation.
Related: [[reference_z88dk_direction_classic_not_newlib]].

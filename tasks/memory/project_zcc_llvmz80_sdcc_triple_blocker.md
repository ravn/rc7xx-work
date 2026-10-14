---
name: project_zcc_llvmz80_sdcc_triple_blocker
description: zcc+llvmz80 z88dk integration — RESOLVED 2026-10-14 (classic clib compat)
metadata:
  type: project
---

**RESOLVED 2026-10-14** — `zcc +cpm -compiler=llvmz80` works end-to-end with z88dk's classic library on `ravn/llvm-z80 main` + `ravn/z88dk master`.

## Final state

- llvm-z80: `main` is at `upstream/users/zlfn/runtime-4-z88dk` (adds `Triple::Z88DK`) merged with cherry-picks of #114/#116/#117 and `trunc-global-address-byte.ll` reloc-name fix. Verified: lit 151/151 PASS, cargo 444/444 PASS.
- z88dk: `ravn/z88dk master` is upstream + 3 commits:
  - `477166d97d` zcc llvmz80: wire classic library ABI (3 files)
  - `6657f369b6` test/llvmz80: update run_minimal.sh tests for __smallc default
  - `070888b3f7` test/llvmz80: update smoke test for __smallc default ABI
- ntvcm `run_minimal.sh` passes 9/9 (varargs, header_abi, math32 × O0/O2/Os).
- Workspace repo tracks all three via submodules.

## Key ABI finding (2026-10-14)

**llvmz80's `__smallc` under z88dk triple = L-to-R push order (sccz80 convention), NOT sdcccall(0)/R-to-L.** Empirically verified: `callee(42,99)` with `printf("%p %p",&a,&b)` shows `&a` at higher address (deeper) than `&b`, i.e. first arg pushed first.

The `__Z88DK_R2L_CALLING_CONVENTION 1` define in `include/sys/compiler.h` only gates ZPROTO behavior (whether `*_callee` variants are emitted in headers), **not** actual push order.

Three distinct conventions on Z80:
- `__smallc` (llvmz80, z88dk triple) = L-to-R push, caller cleanup = sccz80 compatible
- `__smallc __z88dk_callee` = L-to-R push, callee cleanup
- `__sdcccall(0)` = R-to-L push, caller cleanup = sdcc compatible

z88dk's classic library has two entries per function:
- bare name (`qsort`, `strcpy`, …) = sccz80 L-to-R entries
- underscore (`_qsort`, `_strcpy`, …) = sdcc R-to-L entries

LLVM auto-prefixes C symbols with `_`, so without intervention `qsort(...)` in C → `_qsort` in asm → sdcc entry → wrong for llvmz80.

## How the fix works

1. `include/sys/compiler.h`: don't define `__STDC_ABI_ONLY` for `__LLVMZ80` → ZPROTO bridges activate → `strcpy(a,b)` → `strcpy_callee(a,b)` (L-to-R variant exists in library and matches llvmz80).

2. `include/stdlib.h`: declare `qsort`/`bsearch` with `__asm__("qsort")`/`__asm__("bsearch")` for `__LLVMZ80` → bypasses LLVM's `_` prefix → routes to bare-name sccz80 entries with correct `l_cmp_sccz80` thunk.

3. `src/zcc/zcc.c` configure_compiler for llvmz80:
   - Force `c_clib = "ixiy"` (unconditionally): llvmz80 reserves IY → needs `z80iy_crt0.lib` + `cpmixiy_clib.lib` which ship the `__z80_memset_builtin` / `__z80_memcpy_builtin` helpers.
   - Add `-fno-builtin-strcpy -fno-builtin-memcpy …` (all string funcs) so clang's builtin lowering doesn't bypass ZPROTO redirects.

## What works

- `strcpy`, `strncpy`, `strcat`, `strcmp`, `memcpy`, `memmove`, `memset`, `memcmp` via ZPROTO `*_callee` variants (sccz80 L-to-R, callee cleanup).
- `malloc`, `calloc`, `realloc`, `free`.
- `qsort`, `bsearch` via `__asm__` symbol override.
- `abs_fastcall`, `wcmatch`, printf-family.
- Variadic via `__smallc` + SP-relative access.
- All verified under ntvcm.

## What to check if things break

- Z80 clang reads param 1 at IX+6 (deeper), param 2 at IX+4 (top) — L-to-R.
- If a classic-library call misbehaves, check if the ZPROTO `*_callee` is actually linked (via map file). The `.lib` lookup for callee variants is in `sdcc_ix/` and `sccz80/` subdirs of libsrc.
- `qsort` comparator receives `a` = left (deeper, IX+6), `b` = right (top, IX+4) under llvmz80. `return va - vb` for ascending sort.

## Related memory

See [[reference_z88dk_evaluation_doc]] for broader llvmz80+z88dk compatibility status.

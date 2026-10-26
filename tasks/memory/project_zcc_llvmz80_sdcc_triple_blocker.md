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

## Sharpened mechanism map (2026-10-26)

The llvmz80↔classic-lib compat has **three independent problem layers**; mentally confusing them wastes time. Each has its own fix:

| Layer | Problem | Fix |
|---|---|---|
| 1. Push order | Clang default R-to-L, classic lib expects L-to-R | **Zlfn's smallc-default** on `z80-unknown-none-z88dk` triple — every C func auto-gets `__smallc`, no attribute needed. |
| 2. Cleanup side | `__smallc` = caller cleanup; `_callee` variants = callee cleanup (RET N, smaller code) | **ZPROTO bridges** (headers): `#define memcpy(a,b,c) memcpy_callee(a,b,c)` + `extern memcpy_callee(...) __smallc __z88dk_callee`. Activated by NOT setting `__STDC_ABI_ONLY` under `__LLVMZ80`. |
| 3. Backend-synthesized memops | Backend emits `__z80_memset_builtin`/`__z80_memcpy_builtin` from struct copies / aggregate inits — bypasses headers entirely | **`-clib=ixiy`** (symbols only live in cpmixiy_clib + z80iy_crt0), OR `upstream-z88dk-native-runtime` branch that emits `asm_memset`/`asm_memmove` instead (available in both crt0 variants). |

### ZPROTO internals — three macro expansions in `include/sys/proto.h`
```
__SCCZ80 branch:  extern r __LIB__ p n(t1,t2,t3) __smallc;
__SDCC branch:    extern r p n(t1,t2,t3) __smallc;
else (generic):   extern r p __n(t3,t2,t1);                          /* params REVERSED */
                  static inline r p n(t1,t2,t3) { return __n(t3,t2,t1); }
```
The generic branch tries to simulate smallc under a R-to-L clang by reversing the declared param order AND the call-site args — stack bytes end up identical to L-to-R push. **Dead code for us**: no `__memcpy` symbol exists in classic lib; the `#define memcpy memcpy_callee` directly below overrides the inline wrapper anyway.

### `__STDC_ABI_ONLY` — role shift after zlfn's smallc-default
- **Before smallc-default**: setting it was a **correctness switch** (R-to-L push vs L-to-R lib → miscompile).
- **After smallc-default**: setting it is a **performance switch** — plain `memcpy(a,b,c)` still link-compatible via the smallc-default base symbol, you just lose the `_callee` cleanup optimization and any lib func that *only* exists in `_callee` form.

### Watch for
- A new backend-synthesized memop pattern that doesn't resolve to `__z80_*_builtin` or `asm_*` → will fail link under either workaround. Covered by `test/llvmz80/memops_emission.c` + `check_memops_emission.sh` on `ravn/z88dk:llvmz80-runtime-testsuite` (not yet in PR #90).

### Verified empirically 2026-10-26 — `-clib=ixiy` is NOT an ABI trap
Initially suspected: `-clib=ixiy` might pull sdcc_ix R-to-L `_strcpy_callee` into an L-to-R llvmz80 build → arg swap. **Not the case.** z80nm'd `z80iy_crt0.lib`: `strcpy_callee` object is built from `string/c/sccz80/strcpy_callee.asm` and exports `strcpy_callee`, `_strcpy_callee`, `___strcpy_callee` as aliases of the same L-to-R implementation. `-clib=ixiy` refers to IX/IY register-allocation strategy in crt0 only, not to sdcc_ix ABI selection for `_callee` variants. Runtime probe `strcpy(dst, src)` with asymmetric buffers copies correctly. The dangling `libsrc/string/c/sdcc_ix/strcpy_callee.asm` is for a different clib build (`-clib=sdcc_ix`) that targets SDCC, not llvmz80.

Underscore-prefix mechanics (verified via asm emission + nm):
- LLVM emits `call _strcpy_callee` (WITH underscore) regardless of `__smallc` / `__z88dk_callee` attributes.
- sccz80 library asm defines **both** `strcpy_callee` and `_strcpy_callee` as aliases → resolves either way.
- `qsort`/`bsearch` have NO `_callee` form, so the underscore selects the sdcc-R-to-L entry → fix: `__asm__("qsort")` symbol override in `stdlib.h` under `__LLVMZ80`.

## Related memory

See [[reference_z88dk_evaluation_doc]] for broader llvmz80+z88dk compatibility status.

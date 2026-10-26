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

## Minimum change set to eliminate -clib=ixiy (2026-10-26)

Why `-clib=ixiy` is needed TODAY: on 2026-09-29, commit `776e8ee9ae` deleted `libsrc/l/llvmz80/__memset_builtin.asm` + `__memmove_rt.asm` with message "backend now calls asm_memmove and asm_memset directly" — but the matching llvm-z80 change lives on branch `upstream-z88dk-native-runtime`, UNMERGED. So the plain `z80_crt0.lib` lost those symbols (rebuilt after deletion), while `z80iy_crt0.lib` + several others still carry them as stale .o files from before the deletion. `-clib=ixiy` works purely by selecting the archive that happens to still contain the symbols.

### Verified ABI compatibility (git show 776e8ee9ae^:libsrc/l/llvmz80/*)

- `__z80_memset_builtin`: original source was literally `jp asm_memset`. Backend emits HL=dst, E=val, BC=n; `asm_memset` expects identical layout. **A `defc` linker alias suffices** — no instruction, no bytes.
- `__memmove_rt` / `__z80_memmove_builtin`: backend emits HL=dst, DE=src, BC=n; `asm_memmove` expects HL=src, DE=dst, BC=n (swapped). Needs a 4-byte thunk `ex de,hl ; jp asm_memmove` — a `defc` alias would miscompile.

### Minimum fix (~10 asm lines)
```asm
PUBLIC ___z80_memset_builtin
defc   ___z80_memset_builtin = asm_memset       ; alias, 0 bytes

PUBLIC ___memmove_rt
PUBLIC ___z80_memmove_builtin
___memmove_rt:
___z80_memmove_builtin:
    ex de,hl
    jp asm_memmove                               ; 4-byte thunk
EXTERN asm_memset
EXTERN asm_memmove
```
Place in `libsrc/l/llvmz80/` and register in a `.lst` that is included in **every** crt0 variant (not just ixiy). Rebuild crt0 libraries; `-clib=ixiy` default in zcc.c becomes removable for memops reasons.

### Strategic alternative
Merge llvm-z80 branch `upstream-z88dk-native-runtime` into main: backend emits `asm_memset`/`asm_memmove` directly under the z88dk triple, no bridge needed. ~110 lines already written in `Z80LegalizerInfo.cpp`. This is the correct long-term retirement path for the whole bridge layer.

### Both analyses agreed (opus independent review 2026-10-26)
- Taktical fix: ~10-line defc+thunk alias (better than restoring the full 60-line original bridges — opus caught this; my first draft had restored them verbatim).
- Strategic fix: merge native-runtime branch into llvm-z80 main.
- Dropped: backend inline-everything (code bloat), zcc auto-link stub lib (unnecessary indirection), rename emitted symbol (ABI drift risk).

## Zlfn's PR #112 ships z80_z88dk_rt.lib (2026-10-26 — the real answer)

Zlfn pointed out on llvm-z80/llvm-z80#127: **the supplement library is zlfn's design, not ours to invent.** llvm-z80 PR #112 (OPEN, branch `users/zlfn/runtime-4-z88dk`) ships a `compiler-rt`-built archive `z80_z88dk_rt.lib` containing z88dk-syntax versions of exactly the symbols the backend emits — including `___z80_memset_builtin`, `___z80_memcpy_builtin`, `___z80_memmove_builtin` (sources `compiler-rt/lib/builtins/z80/z80_memset_builtin.asm` etc.). Those are small `jp asm_memset`-style thunks; identical to the pre-sletning z88dk bridge files, just owned by LLVM instead of z88dk.

Build gates in `llvm/lib/Target/Z80/CMakeLists.txt`:
- `find_program(Z88DK_Z80ASM z88dk-z80asm)` must succeed at cmake config time
- Target `Z80Runtime` builds `${LLVM_LIBRARY_OUTPUT_INTDIR}/z80/z80_z88dk_rt.lib`
- Install destination: `lib/z80/z80_z88dk_rt.lib` (via `install(FILES ...)`)

### Verified empirically 2026-10-26
Built `z80_z88dk_rt.lib` locally (packed `z80_memset_builtin.o`, `z80_memcpy_builtin.o`, `z80_memmove_builtin.o` with `z88dk-z80asm -x=`). Patched zcc.c to skip the ixiy override, linked bigagg.c (aggregate struct copy → G_MEMCPY, aggregate init → G_MEMSET) with `-lz80_z88dk_rt -L...`. Result:
- `___z80_memset_builtin` resolved from `/Users/ravn/z80/llvm-z80/build-macos-asserts/lib/z80/z88dk/z80_memset_builtin.asm:4` (section `code_compiler`), NOT the stale `../../l/llvmz80/__memset_builtin.asm:15` from z80iy_crt0.lib
- Runtime output correct: aggregate copy preserves byte values, aggregate zero fills correctly
- `-clib=ixiy` default no longer needed; standard `cpm_crt0` + `cpm_clib` suffices alongside the rt.lib

### Still-missing wiring (future work, scoped)
1. zcc driver has NO awareness of `z80_z88dk_rt.lib` — no `-l`/`-L` auto-injected under `-compiler=llvmz80`. Needs ~5 lines in `src/zcc/zcc.c` to add it to the link command.
2. Our local llvm-z80 build currently FAILS at `umulhisi3.asm` (undefined `___umulhi3`) when running the `Z80Runtime` target — appears to be a bug on PR #112's branch or snapshot divergence. We built the three memop .o manually to proceed, but a full `Z80Runtime` build is blocked until this upstream issue clears.
3. The old static-dangling bridge .o files in `z80iy_crt0.lib` + 6 other crt0 variants are still there (never cleaned since 776e8ee9ae on z88dk-side). Harmless but misleading in archaeology.

### Preferred strategy (not an alternative to zlfn's design)
Wire zcc to link `z80_z88dk_rt.lib` automatically under `-compiler=llvmz80`. Drop the `-clib=ixiy` override. zlfn's design wins — our mental model of "backend calls asm_memset directly" was a shortcut that bypassed his cleaner compiler-rt-shipped scheme.

## Phase 1+2 implemented 2026-10-26 (not yet pushed to ravn/*)

### llvm-z80 (local `main`, commit `35d80b2f59e8`)
`llvm/lib/Target/Z80/CMakeLists.txt`: HINTS for z88dk-z80asm + exclude 4 mul*-files blocked by llvm-mc bug on PR #112 (mulhisi3, muldi3, mulsi3, umulhisi3 all reference `___umulhi3` but z88dk-asm backend doesn't emit `EXTERN`). z80_z88dk_rt.lib now builds with 50+ compiler-rt helpers + the three memops.

### z88dk (local `llvmz80-runtime-testsuite`, commit `a561d15208`)
`src/zcc/zcc.c`: ~50 lines. Replaced ixiy force-default with probe:
1. `$LLVMZ80_RTLIB_DIR/z80_z88dk_rt.lib` (explicit override)
2. `$(dirname (dirname $LLVMZ80EXE))/lib/z80/z80_z88dk_rt.lib`
3. Hard fail (exit 1 + stderr help) if neither found

### Verified end-to-end
- test/llvmz80/run_minimal.sh: 7 runtime tests × O0/O2/Os = 21 PASS
- memops_emission: 24/24 checks PASS
- All without `-clib=ixiy` anywhere; `___z80_memset_builtin` resolves from the fresh rt.lib

### Still open
- PR #90 branch not yet rebased on top of this (Phase 3)
- Not pushed to ravn/* yet (user decides timing)
- umulhisi3 llvm-mc translator bug: on zlfn's side (strongly looks like a compiler-rt→z80asm text backend missing EXTERN emission)
- Communication with zlfn on #127 (gated on explicit "ja post det")

## Related memory

See [[reference_z88dk_evaluation_doc]] for broader llvmz80+z88dk compatibility status.

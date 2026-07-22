# Evaluation: `zcc +cpm -clib=new -compiler=llvmz80` (newlib CP/M target with clang-z80)

**Date:** 2026-07-22.  Empirical, run under native macOS clang-z80
(`build-macos/bin/clang-23`) + z88dk `bin/zcc` + `ntvcm` in the workspace.
This closes the user's "to do later: see if llvmz80 can work with new lib cpm
target too".

## TL;DR

- **The literal command `-clib=new -compiler=llvmz80` FAILS** at link
  (`undefined symbol: _printf`).  The `new` clib variant hardcodes the
  **sccz80**-ABI newlib archive, whose C symbols have no leading underscore
  (`printf`), while clang emits `_printf`.
- **But `-clib=sdcc_ix -compiler=llvmz80` WORKS and runs correctly.**  The
  *sdcc* newlib variant uses `_`-prefixed symbols AND the sdcccall(1) ABI, both
  of which clang-z80 matches.  Verified end-to-end in ntvcm.
- **Bonus: newlib binaries are ~half the size** of the classic clib for the same
  program (hello: **3289 B newlib vs 7233 B classic**) — newlib's per-function
  sectioning gives much tighter dead-code elimination.
- **Still an UNSUPPORTED / accidental path**: `-clib=sdcc_ix` forces
  `-compiler=sdcc` in its config line; we override it with `-compiler=llvmz80`
  and rely on sdcc≈clang ABI coincidence.  No `llvmz80` newlib variant, no
  `cpm.cfg` line, and `%f`/float is broken.

## What was tested (all in ntvcm, all PASS unless noted)

| Program | Result |
|---------|--------|
| `printf("hello %d",42)` | `hello newlib 42` ✓ |
| `strcpy`/`strcat`/`strlen` | `str=abcdef len=6` ✓ |
| `malloc`/`free` + int array | `malloc=0,1,4,9` ✓ |
| `snprintf("%x/%o/%u")` | `ff/10/60000` ✓ |
| `atoi` | `1234` ✓ |
| `printf`/`sprintf` **return value** | `n=0 m=3`, `sprintf ret=5` ✓ (native — no bridge) |
| `qsort` with clang comparator | `1 2 3 5 8 9` ✓ (cross-ABI callback both ways) |
| `printf("%f",3.14159)` | `f=` ✗ (newlib float ≠ IEEE-754, same as classic) |

Compile-only (`-c`) also succeeds under `-clib=new`: the `_DEVELOPMENT/common`
headers are clang-clean.  **The front end is not the obstacle** — only the
library ABI/symbol-prefix layer is.

## Root cause of the `-clib=new` failure

`lib/config/cpm.cfg` line 21:

```
CLIB  new  ... -lcpm -LDESTDIR/libsrc/newlib/lib/sccz80 -crt0=.../cpm_crt.asm.m4
```

It points at the **sccz80** pre-built newlib archive.  Symbol-prefix survey
(`strings … | grep '^_?printf$'`):

| newlib variant | `_printf` | `printf` |
|----------------|:---------:|:--------:|
| `sccz80`  (what `-clib=new` uses) | 0 | 2 |
| `sdcc_ix` | **2** | 1 |
| `sdcc_iy` | 0 | 0 (IY-reserved, printf pulled elsewhere) |
| classic `cpm_clib.lib` (for contrast) | 2 | 2 |

clang-z80 emits `_printf` (leading underscore, the sdcc convention).  The classic
clib carries **both** `_printf` and `printf`, so it resolves — that plus the
`libsrc/l/llvmz80/` bridge layer is why the shipping `-clib=default` path works.
The sccz80 newlib carries only bare `printf`, so every stdlib reference from
clang is undefined.  The **sdcc_ix** newlib carries `_printf`, so clang links.

## Why sdcc_ix works at runtime, not just at link

clang-z80's calling convention is `sdcccall(1)` — literally sdcc's
`--sdcccall=1` (sdcc's default since 4.2), which `Z80CallLowering` implements.
The sdcc newlib archive is compiled to that same ABI, so:
- 16-bit args in HL/DE, 8-bit return in A, 16-bit return in DE — match.
- The HL→DE return mismatch that forced the classic `__ZPROTO` bridges does NOT
  arise here, so `printf`/`sprintf` return values are correct **natively**
  (classic needed ravn/z88dk#31 to fix this).
- The strongest cross-check — `qsort` (sdcc-compiled) invoking a
  clang-compiled comparator, i.e. a call *from* newlib *into* clang code — sorts
  correctly, confirming the callback ABI lines up in both directions.

## Assessment vs the classic clib path

| Axis | classic (`-clib=default`, shipping) | newlib (`-clib=sdcc_ix`, this experiment) |
|------|------|------|
| Links with clang | ✓ (supported, `cpm.cfg` line + bridge) | ✓ (only by overriding `-compiler`) |
| Runs correctly | ✓ verified suite | ✓ core stdlib verified |
| Code size (hello) | 7233 B | **3289 B** (−55 %) |
| printf/sprintf return value | ✓ (needed #31 bridge) | ✓ native |
| `printf("%f")` IEEE | ✓ via nanoprintf opt-in | ✗ (not wired; would need same shim) |
| Supported / sanctioned | **yes** | **no** (accidental sdcc-ABI reuse) |
| Bridge layer maintained | `libsrc/l/llvmz80/` exists | none |

## Verdict

**Newlib is genuinely usable with clang-z80 today via the sdcc_ix ABI — and it
is materially smaller than classic.**  This is a better result than the earlier
assumption ("no llvmz80 newlib variant → won't work").  However it remains an
*unsupported coincidence*, not a product:

- It rides on `-clib=sdcc_ix` (sdcc ABI) with `-compiler=llvmz80` overriding the
  config's own `-compiler=sdcc`.  Nothing guarantees every newlib TU was built
  `--sdcccall=1`; a function built to a different convention would miscompile
  silently.  A full regression sweep (not just the smoke tests above) would be
  needed before trusting it.
- `%f`/`double` is broken (newlib float format ≠ clang IEEE-754).  Fixing it
  means the same nanoprintf route we built for classic, re-plumbed against
  newlib's `FILE*`.
- Any sdcc-specific inline asm / intrinsic in a pulled newlib module is a latent
  landmine for clang.

### Recommendation

1. **Keep `-clib=default` (classic) as the supported llvmz80 CP/M path.**  It is
   complete, bridged, `%f`-capable, and CI/MAME-verified.
2. **Record newlib-via-sdcc_ix as a known-working, unsupported option** for
   size-critical integer programs (−55 % is real), with the caveats above.
3. **If newlib support is ever wanted as a product**, the clean route is a
   dedicated `llvmz80` newlib variant: add a `cpm.cfg` CLIB line pointing at an
   `llvmz80` lib dir, and either (a) build newlib's clang-compatible C sources
   with clang while reusing the sdcc-ABI asm modules (feasible precisely because
   the ABIs match — as demonstrated), or (b) a thin bridge layer for the handful
   of entry points that differ.  Option (a) is now the plausible path *because*
   sdcc_ix already links and runs.
4. **Not on the critical path** for the four finishing-firmware components
   (rcbios, autoload, CP/NET, cpnos) — those use the classic clib / freestanding
   builds.  File as a documented opportunity, not scheduled work.

## Repro

```sh
export LLVMZ80EXE=.../llvm-z80/build-macos/bin/clang
export ZCCCFG=.../z88dk/lib/config ; export PATH=.../z88dk/bin:.../ntvcm:$PATH
# FAILS (undefined _printf):
zcc +cpm -clib=new     -compiler=llvmz80 -O2 -create-app -o h hello.c
# WORKS:
zcc +cpm -clib=sdcc_ix -compiler=llvmz80 -O2 -create-app -o h hello.c && ntvcm h.com
```

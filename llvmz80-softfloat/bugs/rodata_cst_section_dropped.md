# BUG: mergeable constants (`.rodata.cstN`) dropped → `const double[]` reads 0

- **Repro:** [`bugs/rodata_cst_section_dropped.c`](rodata_cst_section_dropped.c)
  (= `tests/ft_rocst.c`, wired into `tests/run.sh` step 4/4 as a regression guard)
- **Status:** **FIXED 2026-07-16** in `z88dk/lib/llvmz80/llvmz80_rules.1`.
- **Component:** `z88dk/lib/llvmz80/llvmz80_rules.1` (the `-compiler=llvmz80` copt
  bridge). **NOT** the llvm-z80 backend — raw clang emits the section correctly
  (`.section .rodata.cst32,"aM",@progbits,32`); the bridge just had no rule for it.
- **Severity:** high / silent data corruption. Any fully-constant, power-of-2-sized
  (4/8/16/32-byte) read-only object read at runtime returned all-zero, at **every**
  optimization level, with **no diagnostic**. This is what made musl
  `atan()`/`exp()`/`log()` return 0 on Z80 (they index static const coefficient
  tables such as `atanhi[]`/`atanlo[]`).
- **Distinct from [ravn/z88dk#27](https://github.com/ravn/z88dk/issues/27)** (the
  `.quad`→`DEFQ` 64-bit-init truncation, fixed via `splitquad.pl`). Here the *bytes*
  are correct; the whole *section* was discarded.

---

## 1. One-line

Under `zcc +cpm -compiler=llvmz80`, a fully-constant power-of-2-sized read-only
array (e.g. `static const double tab[4]` = 32 B) that clang places in a mergeable
constant section `.section .rodata.cstN` was **dropped from the binary** and read
back as all-zero at runtime.

## 2. Symptom (verified on target)

Build & run `bugs/rodata_cst_section_dropped.c` under the cycle-accurate CP/M
harness (`z88dk-ticks` + BDOS stub, `scratch/dcc-clang-bench/ticks_cpm.py`).
`pick(s)` returns `hi[s?1:0]` from `static const double hi[]={10,20,30,40}`; the
test prints the IEEE-754 top 16 bits of each result.

| call        | expected top16          | actual (buggy) | verdict                 |
|-------------|-------------------------|----------------|-------------------------|
| `pick(1)`   | `16436` (20.0 = 0x4034) | `0`            | ❌ array dropped         |
| `pick(0)`   | `16420` (10.0 = 0x4024) | `0`            | ❌ array dropped         |

Red/green (revert the fix rule to reproduce RED):
```
RED  (no .rodata.cst rule): ROCST 0 0
GREEN(with fix)           : ROCST 16436 16420
```

## 3. Root cause

`llvmz80_rules.1` mapped `.section .rodata` and `.section .rodata.str1.1` to
`SECTION rodata_compiler`, but had **no** rule for clang's mergeable-constant
sections `.section .rodata.cstN` (N = 4/8/16/32). They therefore fell through to
the catch-all

```
	.section	%1
=
	SECTION IGNORE
```

`SECTION IGNORE` is a bit-bucket segment that the z88dk linker never places, so the
initialiser bytes vanished. clang uses `.rodata.cstN` for any fully-constant object
whose size is a power of two (a single `double` is `.rodata.cst8`; four are
`.rodata.cst32`), so the corruption is common, not exotic.

## 4. Fix

Add a rule ahead of the catch-all mapping the mergeable pools to ordinary rodata
(z80asm has no section merging, but the data must still be emitted):

```
	.section	.rodata.cst%2,%1
=
	SECTION rodata_compiler
```

Verified: `tests/run.sh` step 4/4 `ft_rocst PASS` (`ROCST 16436 16420`), and musl
`atan(1.0)` — whose `id≥0` path reads the `atanhi[]/atanlo[]` tables — now returns
`7853` (was `0`).

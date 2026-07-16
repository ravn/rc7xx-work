# nanoprintf on clang-z80: `<float.h>` describes 48-bit software float, not IEEE-754 `double`

Regression test: `bugs/ftoa_rev_hiword_dropped.c` (self-checking; must PASS with
the `src/npf_cpm.h` float-limits override in place).

> **NOTE (2026-07-16).** Earlier revisions of this file diagnosed a clang-z80
> *backend* miscompile ("64-bit `>> 52` reads the wrong word inside a large
> function") and this was filed as **ravn/llvm-z80#271**. **That diagnosis was
> wrong and #271 is invalid** -- there is no compiler codegen bug. The real
> cause is a header/ABI mismatch, root-caused below with a differential oracle
> (clang codegen vs. the LLVM IR interpreter `lli`).

## Symptom (verified)
`nanoprintf`'s `npf_ftoa_rev()` converted every finite `double` to the wrong
magnitude under `zcc +cpm -compiler=llvmz80`:

| input | Z80 output | want |
|---|---|---|
| `1.0` | `0.000000` | `1.000000` |
| `0.3333333333333333` | `715827882.666016` | `0.333333` |
| `10.0` | `0.000000` | `10.000000` |

`715827882 == (1/3)*2^31` -- the base-2 exponent was decoded with the wrong
parameters, so the fraction was never scaled.

## Root cause (verified, red-green)
`npf_ftoa_rev` decodes a `double`'s raw IEEE-754 layout using constants
nanoprintf derives from `<float.h>`:

```
exp  = (bin >> (DBL_MANT_DIG-1)) & (DBL_MAX_EXP*2-1);
exp -= (DBL_MAX_EXP-1);
```

Two sources disagree about what a `double` is on this target:

- **clang-z80's `double` is IEEE-754 binary64.** Builtins are correct:
  `__DBL_MANT_DIG__ = 53`, `__DBL_MAX_EXP__ = 1024`, `__SIZEOF_DOUBLE__ = 8`.
  The bytes handed to nanoprintf *are* binary64.
- **z88dk's `<float.h>` describes z88dk's native 48-bit software float.**
  Via `include/math/math_genmath.h`: `DBL_MANT_DIG = 39`, `DBL_MAX_EXP = 37`.

So nanoprintf generated:

| constant | genmath `<float.h>` | correct for binary64 |
|---|---|---|
| shift `DBL_MANT_DIG-1` | **38** | 52 |
| mask `DBL_MAX_EXP*2-1` | **73** | 2047 |
| bias `DBL_MAX_EXP-1` | **36** | 1023 |

The emitted IR reflects exactly this at `-O0` and `-O2`:

```
%46 = lshr i64 %45, 38        ; should be 52
%48 = and  i16 %47, 73        ; should be 2047
```

`bin` itself is correct; only the *decode constants* are wrong.

### Why this is NOT a codegen bug
The wrong shift/mask are already in the LLVM IR. Running that IR through the
LLVM interpreter (`lli --force-interpreter`, no target backend) produces the
**same** wrong output as the Z80 build, while an isolated `bin >> 52` runs
correctly under `lli`. clang, `llc`, and `lli` all faithfully execute the
correctly-compiled but wrongly-parameterised IR.

### Red-green
| `DBL_MANT_DIG` | IR | output |
|---|---|---|
| 39 (genmath `<float.h>`) | `lshr i64, 38` | `0.000000` / `715827882.666016` -- FAIL |
| 53 (override) | `lshr i64, 52` | `1.000000` / `0.333333` / `10.000000` -- PASS |

## Fix
`src/npf_cpm.h` overrides the `<float.h>` `DBL_*` macros with the compiler's own
builtins (`__DBL_MANT_DIG__` etc.) before including `nanoprintf.h`. All 50 cases
of `tests/ft_fmt` now match the glibc golden output.

## Broader implication
Any clang-z80 code that reads `<float.h>` `DBL_*`/`FLT_*` to interpret a
`double`/`float` bit layout breaks the same way: z88dk's `llvmz80` clib ships
`<float.h>` describing 48-bit genmath, but clang-z80's `double` is IEEE-64.
Candidate ravn/z88dk issue: the `llvmz80` `<float.h>` should reflect the
compiler's real (IEEE-754) float, e.g. by deferring to `__DBL_*__` / `__FLT_*__`.

## Environment
- `zcc +cpm -compiler=llvmz80`; clang/llc/lli at `llvm-z80/build-macos/bin/`.
- nanoprintf vendored @ `74fea30` (v0.6.1), config in `src/npf_cpm.h`.
- Run harness: `scratch/dcc-clang-bench/ticks_cpm.py`.

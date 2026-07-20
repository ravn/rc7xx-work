# BUG: `(double)int` conversion (`__floatsidf`) miscompiled by clang-z80

- **Upstream issue:** [ravn/llvm-z80#273](https://github.com/ravn/llvm-z80/issues/273)
- **Repro:** [`bugs/f64_int_to_double_miscompiled.c`](f64_int_to_double_miscompiled.c)
- **Status:** **FIXED 2026-07-21.** Root cause was **NOT** a compiler backend bug
  (as this doc originally hypothesized) — it was a **SoftFloat build-config bug**
  in *our* closure: a 16-bit `__builtin_clz` used where a 32-bit clz was required.
  See §6 for the confirmed cause and §8 for the fix + green verification.
- **Component:** ~~ravn/llvm-z80 backend~~ **CORRECTED:** our vendored SoftFloat
  header `vendor/berkeley-softfloat-3/source/include/opts-GCC.h` (the
  `SOFTFLOAT_BUILTIN_CLZ` clz definitions). The clang-z80 backend is **not** at
  fault. **ravn/llvm-z80#273 should be closed as not-a-compiler-bug.**
- **Severity (before fix):** high / silent value corruption. Every `(double)someInt`
  yielded garbage at every optimization level with no diagnostic.
- **Confirmed root cause:** `softfloat_countLeadingZeros32` was defined as
  `__builtin_clz(a)`, but clang-z80 `int` is **16-bit**, so `__builtin_clz` counts
  only 16 bits → the count is off by 16 → `i32_to_f64`'s `shiftDist` is 16 too
  small → the packed exponent is 16 too large. Fix = width-match the builtin
  (`__builtin_clzl` for the 32-bit clz); see §6/§8.

---

## 1. One-line

Under `zcc +cpm -compiler=llvmz80` with the Berkeley-SoftFloat f64 closure linked,
`(double)anInt` (which clang lowers to the `__floatsidf` soft-float libcall)
returns a **corrupt** `double`. `(double)5` formats as `131074.500000` instead of
`5.000000`. Every arithmetic value derived from a converted integer is then wrong.

## 2. Symptom (verified on target 2026-07-17)

`bugs/f64_int_to_double_miscompiled.c` emits five lines through the **non-variadic**
`npf_snprintf_f("%f", d)` formatter (chosen to avoid the unrelated variadic
`va_start` bug ravn/llvm-z80#270). Run under `z88dk-ticks`:

| tag     | expression        | expected     | actual          | verdict                     |
|---------|-------------------|--------------|-----------------|-----------------------------|
| `conv5` | `(double)5`       | `5.000000`   | `131074.500000` | ❌ int→double corrupt        |
| `conv2` | `(double)2`       | `2.000000`   | `65537.000000`  | ❌ int→double corrupt        |
| `lit5`  | literal `5.0`     | `5.000000`   | `5.000000`      | ✓ **control** (literal ok)  |
| `div`   | `5.0 / 2.0`       | `2.500000`   | `2.000008`      | ❌ operands poisoned by conv |
| `dm`    | `5.0 / 2.0 *1000` | `2500.000000`| `2000.007629`   | ❌ operands poisoned by conv |

The literal `5.0` (`lit5`) formats correctly, so the formatter, the `double`
storage, and the raw-bit read are all fine. Only the **conversion result** is
wrong, and everything computed from it inherits the corruption.

## 3. Isolation — what is NOT the cause (each verified)

- **NOT the caller's optimization level.** Rebuilding *only the repro TU* at
  `-Cg-O0`, `-O1`, `-O2` (same closure lib) gives byte-identical wrong output.
  So the fault is in the shared int→f64 path, not the repro's own codegen.
- **NOT the generic f64 sret return ABI.** Sibling shims that also return an
  8-byte `double` via sret (`__adddf3`/`__muldf3`/`__divdf3` on non-converted
  operands, and `f64_add` on hand-built bit patterns → exactly `10.0`, see
  `bugs/quad_global_init_truncated.md` §4) are correct. The corruption is
  **specific to the int→double entry** (`__floatsidf`), which uniquely takes an
  integer argument and returns a double.
- **NOT the copt bridge.** The bridge rewrites all emitted asm uniformly; literal
  doubles pass through it and are correct.
- **NOT the SoftFloat algorithm.** See §4.

## 4. The conversion algorithm is correct on the host

`src/sf64.c:43`:

```c
double __floatsidf(long a){ return f642d(i32_to_f64((int_fast32_t)a)); }
```

Compiling the vendored `i32_to_f64.c` core natively (host clang -O2) and printing
the produced bits:

```
i32_to_f64(2):  bits=4000000000000000  d=2.000000
i32_to_f64(5):  bits=4014000000000000  d=5.000000   <-- correct IEEE 5.0
i32_to_f64(10): bits=4024000000000000  d=10.000000
```

The algorithm produces the correct IEEE-754 bit patterns **on the host**. This was
originally read as "the math is sound, so the Z80 backend must be miscompiling it."
That inference was **wrong** (see §6): the host cross-check compiles with the same
`-DSOFTFLOAT_BUILTIN_CLZ`, but on a 64-bit host `int` is **32-bit**, so
`__builtin_clz` is a correct 32-bit clz there. The very flag that is buggy on the
16-bit-`int` Z80 target is **benign on the host** — which is exactly why the host
passed and the target failed. The host green is a *false exoneration* of the
config, not proof of a backend defect.

## 5. Relationship to already-filed sret bugs (distinct)

Related but NOT the same as:
- **ravn/llvm-z80#268** — sret return copied to the wrong dest when the value comes
  from an sret-returning call. Control passes here (`__adddf3` etc. are fine).
- **ravn/llvm-z80#269** — `createFCMPLibcall` hardcoded i32 return. Fixed in-fork;
  this build already contains that fix, and the symptom persists.
- **ravn/llvm-z80#270** — broken `va_start` (variadic). Deliberately avoided by
  using the non-variadic `npf_snprintf_f`; the corruption is still present, so it
  is independent of #270.

## 6. Confirmed root cause (was "suspected backend" — REFUTED)

The original hypothesis in this section — "clang-z80 miscompiles the int→double
conversion" — is **refuted**. The real cause is a **width bug in our SoftFloat
config**, not in the compiler.

`vendor/berkeley-softfloat-3/source/include/opts-GCC.h`, under
`#ifdef SOFTFLOAT_BUILTIN_CLZ`, originally defined (upstream, assuming 32-bit int):

```c
softfloat_countLeadingZeros16(a) = a ? __builtin_clz(a) - 16 : 16;
softfloat_countLeadingZeros32(a) = a ? __builtin_clz(a)      : 32;   // <-- bug on z80
```

clang-z80 `int` is **16-bit** (`__INT_WIDTH__ == 16`), so `__builtin_clz` counts
leading zeros in a **16-bit** value. For a 32-bit `absA`, `countLeadingZeros32`
therefore returned a count that is **16 too small**.

`i32_to_f64` uses it as `shiftDist = countLeadingZeros32(absA) + 21`, then packs
`exp = 0x432 - shiftDist`. A 16-too-small `shiftDist` makes the exponent 16 too
large, i.e. the value is scaled by ~2¹⁶ (mixed with the mantissa shift, giving the
observed `(double)5 → 131074.5`, `(double)2 → 65537`, etc.).

**Why only int→double.** `countLeadingZeros32` has exactly **one** caller in this
closure: `i32_to_f64`. The f64 arithmetic shims (`__adddf3`/`__muldf3`/…) normalize
via `countLeadingZeros64` (`__builtin_clzll`, a correct 64-bit clz because
`long long` is 64-bit here), so they were unaffected — matching §3/§5's observation
that only the conversion entry was corrupt.

**Fix.** Width-match the builtin to the requested clz width (correct on any target
with int=16/long=32/longlong=64):

```c
softfloat_countLeadingZeros16(a) = a ? __builtin_clz (a) : 16;  // uint int  = 16 bits
softfloat_countLeadingZeros32(a) = a ? __builtin_clzl(a) : 32;  // uint long = 32 bits
softfloat_countLeadingZeros64(a) = a ? __builtin_clzll(a): 64;  // uint llong= 64 bits
```

Guarded by a `_Static_assert(__SIZEOF_INT__==2 && __SIZEOF_LONG__==4 &&
__SIZEOF_LONG_LONG__==8, ...)` so the assumption can't silently rot.

**Note (why not just drop `-DSOFTFLOAT_BUILTIN_CLZ`):** dropping the flag pulls the
portable table `s_countLeadingZeros8.c`, whose 256-byte `.ascii` initializer the
z88dk copt/z80asm stage cannot parse ("syntax error"). Keeping the flag with the
width-matched inline defs both fixes the bug and avoids that toolchain limitation.

## 8. The fix + green verification

Fixed in our closure, none in the backend or z88dk. The width-matched clz defs
(§6) + `_Static_assert` live in project-owned `vendor/config/platform.h`, **not**
in the vendored submodule. `platform.h` was already the sole includer of
`opts-GCC.h` (pulling it in only for the clz builtins; its INT128 block is
inactive here), so we drop that `#include` and define the three width-matched
`softfloat_countLeadingZeros{16,32,64}` inline in `platform.h` instead. The
`berkeley-softfloat-3` submodule stays pinned to pristine upstream
(`ucb-bar` a0c6494) — editing a vendored submodule is not reproducible after
`git submodule update` on another machine, which is exactly how this fix was
first (wrongly) placed.
- `build64.sh`, `build_fmt.sh` — comments documenting why the flag stays.
- `tests/ft_i2d.c` + `tests/ft_i2d.expected` + `tests/i2d_run.sh` — a permanent
  int→double oracle wired into `tests/run.sh` (the pre-existing `ft_dbl` only
  observed `__floatsidf` through a **lossy** `(long)` cast, which recovered `-42`
  from the corrupt double and so never caught the bug; the new oracle formats the
  **full** value via `%f`).

Green (after fix):

```bash
export PATH="/Users/ravn/z80/z88dk/bin:$PATH"; export ZCCCFG=/Users/ravn/z80/z88dk/lib/config/
export LLVMZ80EXE=/Users/ravn/z80/llvm-z80/build-macos/bin/clang
cd /Users/ravn/z80/llvmz80-softfloat
sh tests/i2d_run.sh    # -> i5|5.000000 ... div52|2.500000 ; RESULT: ft_i2d PASS
```

Red/green proof captured 2026-07-21: against a closure built with the old buggy
clz, `ft_i2d` prints `i5|131074.500000 … i32767|536887295.500000` (every value
corrupt); against the fixed closure it prints the exact expected integers and
`div52|2.500000`.

## 7. How to re-verify (red)

```bash
export PATH="/Users/ravn/z80/z88dk/bin:$PATH"; export ZCCCFG=/Users/ravn/z80/z88dk/lib/config/
cd /Users/ravn/z80/llvmz80-softfloat
# Prereq: the f64 closure lib at /tmp/sfclos2/softfloat_cpm_z80.lib
#   (build:  OPT=Oz OUT=/tmp/sfclos2 bash build64.sh
#            cd /tmp/sfclos2 && rm -f ft_dbl.o softfloat_cpm_z80.lib
#            z88dk-z80asm -d -xsoftfloat_cpm_z80 *.o)
# and the nanoprintf objects from build_fmt.sh (bash build_fmt.sh -> /tmp/fmt64_out)
OUT=/tmp/f64repro_out; mkdir -p $OUT
cp /tmp/fmt64_out/{fmt64,intrt,rt_mem}.o $OUT/
zcc +cpm -compiler=llvmz80 -Cg-O2 -Ivendor/nanoprintf -Isrc \
    -c -o $OUT/r.o bugs/f64_int_to_double_miscompiled.c
zcc +cpm -compiler=llvmz80 -Cg-O2 -o $OUT/r \
    $OUT/r.o $OUT/fmt64.o $OUT/intrt.o $OUT/rt_mem.o \
    -L/tmp/sfclos2 -lsoftfloat_cpm_z80
python3 /Users/ravn/z80/scratch/dcc-clang-bench/ticks_cpm.py $OUT/r | grep -v '^\[ticks\]'
# RED: conv5 prints 131074.500000. After a fix it must print 5.000000.
```

Host algorithm cross-check (green — proves the math is sound):

```bash
cd /Users/ravn/z80/llvmz80-softfloat
V=vendor/berkeley-softfloat-3/source
cc -O2 -Ivendor/config -I$V/8086 -I$V/include \
   -DSOFTFLOAT_FAST_INT64 -DSOFTFLOAT_ROUND_ODD -DINLINE_LEVEL=1 \
   -DSOFTFLOAT_FAST_DIV32TO16 -DSOFTFLOAT_FAST_DIV64TO32 -DSOFTFLOAT_BUILTIN_CLZ \
   -x c - $V/i32_to_f64.c -o /tmp/hc <<'EOF'
#include <stdint.h>
#include <stdio.h>
#include "softfloat.h"
int main(void){ float64_t f=i32_to_f64(5);
  printf("i32_to_f64(5) bits=%016llx\n",(unsigned long long)f.v); return 0; }
EOF
/tmp/hc   # -> bits=4014000000000000 (correct 5.0)
```

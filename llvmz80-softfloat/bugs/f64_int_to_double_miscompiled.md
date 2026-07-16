# BUG: `(double)int` conversion (`__floatsidf`) miscompiled by clang-z80

- **Upstream issue:** [ravn/llvm-z80#273](https://github.com/ravn/llvm-z80/issues/273)
- **Repro:** [`bugs/f64_int_to_double_miscompiled.c`](f64_int_to_double_miscompiled.c)
- **Status:** verified 2026-07-17, unfixed. **Blocks** any `double` program that
  converts an integer to `double` under `-compiler=llvmz80`.
- **Component:** ravn/llvm-z80 **backend** (int→f64 codegen). NOT the SoftFloat
  shim (the `i32_to_f64` algorithm is correct on host — see §4), NOT the copt
  bridge (literal doubles are correct — see §3).
- **Severity:** high / silent value corruption. Every `(double)someInt` yields
  garbage, at **every** optimization level, with **no diagnostic**.
- **Suspected root cause (UNCONFIRMED):** clang-z80 miscompiles the int→double
  conversion path — the `__floatsidf` shim body and/or the marshaling of its
  `int_fast32_t` argument / 8-byte `float64_t` return. The exact defective
  instruction/pass has **not** been isolated (investigation stopped by request).

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

The algorithm produces the correct IEEE-754 bit patterns. So the Z80 corruption is
introduced by **clang-z80's compilation** of this path (the `__floatsidf` shim body
and/or its argument/return marshaling), not by the math.

## 5. Relationship to already-filed sret bugs (distinct)

Related but NOT the same as:
- **ravn/llvm-z80#268** — sret return copied to the wrong dest when the value comes
  from an sret-returning call. Control passes here (`__adddf3` etc. are fine).
- **ravn/llvm-z80#269** — `createFCMPLibcall` hardcoded i32 return. Fixed in-fork;
  this build already contains that fix, and the symptom persists.
- **ravn/llvm-z80#270** — broken `va_start` (variadic). Deliberately avoided by
  using the non-variadic `npf_snprintf_f`; the corruption is still present, so it
  is independent of #270.

## 6. Suspected root cause (UNCONFIRMED — do not treat as verified)

clang-z80 miscompiles the int→double conversion. Candidate mechanisms, none
isolated:
- (a) miscompilation of the `i32_to_f64` core / `__floatsidf` shim body as built by
  clang-z80;
- (b) wrong marshaling of the `long`→`int_fast32_t` argument or the 8-byte
  `float64_t` return of `__floatsidf` specifically.
Investigation was stopped by request; this section is a hypothesis, not a diagnosis.

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

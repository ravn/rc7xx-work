# llvmz80-softfloat — an IEEE-754 soft-float runtime for zcc + llvm-z80

**Goal:** make floating point actually work at runtime when compiling C with
`zcc +cpm -compiler=llvmz80` (our llvm-z80 clang) and linking against z88dk.
Today float is effectively non-functional at runtime (see "The gap" below).

This mirrors how the CE-Programming eZ80 toolchain (ez80-clang) does it, but
targets **our** compiler + z88dk pipeline.

---

## Status (2026-07-15)

| Phase | Scope | State |
|-------|-------|-------|
| **1** | single-precision **no-multiply** ops: `__addsf3` `__subsf3` `__fixsfsi` and all six compares (`__gtsf2` `__ltsf2` `__gesf2` `__lesf2` `__eqsf2` `__nesf2`) | **DONE — verified on host + on Z80 (ticks)** |
| **2** | single-precision multiply/divide: `__mulsf3` `__divsf3` (shift-add `mul24` + restoring division — no `__mulsi3`/`__muldi3`/`__udiv*` needed, all of which z88dk lacks) | **DONE — host 2M/0 + Z80 (ticks)** |
| 3 | double precision (`__adddf3` … `__fixdfsi` …) — vendor **Berkeley SoftFloat** (BSD), FAST_INT64 + `INLINE_LEVEL=1` | **DONE — `ft_dbl` green on Z80 (ticks): `s=10 m=21 d=-4 q10=2333 / df10=15 sf=1000000 fx=1000000 di=-42 / gt=0 lt=1 eq=1 ne=0`.** Required fixing three bugs (see below). Closure links ~49 KB. |
| 4 | `printf("%f")` — the classic z88dk formatter reads **math48**, not IEEE. Wire **nanoprintf** (MIT) or an IEEE float→string. | **`%f` works via this project's `npf_snprintf_f` shim** (50/50 byte-identical to glibc). **Stock `zcc printf("%f")` is a GAP** (broken — see Known limitations). **`%e`/`%g` NOT supported** (nanoprintf v0.6.1 gap). |

Whetstone (double + libm sin/cos/exp/log) is the end-goal driver; it needs
phases 3 + 4 plus `sinl/cosl/...`.

> **Phase 3 — three bugs fixed to reach green (2026-07-15):**
> 1. **[ravn/z88dk#27](https://github.com/ravn/z88dk/issues/27)** — 64-bit
>    (`long long`/`double`) **global initializers** silently truncated to 32 bits
>    by the `-compiler=llvmz80` copt bridge (`.quad` → a 4-byte `DEFQ`). Fixed by
>    a pre-copt `splitquad.pl` pass (`z88dk/lib/llvmz80/`) that splits each
>    `.quad` into two `.long` halves. Bridge bug, not the backend / not SoftFloat.
>    Write-up: [`bugs/quad_global_init_truncated.md`](bugs/quad_global_init_truncated.md).
> 2. **ravn/llvm-z80#268** — backend miscompile: a function returning
>    double/aggregate via sret whose value comes from another sret-returning call
>    copied the callee result to the wrong slot (`eliminateFrameIndex` added
>    `CalleeSavedFrameSize` to incoming-arg / sret fixed objects, not just BSS
>    locals → sret `[ix+4]` misread as `[ix+6]`; with low word 0x0000 the copy
>    hit CP/M's warm-boot vector → hang). Repro: [`bugs/sret_dest_from_sret_call.c`](bugs/sret_dest_from_sret_call.c).
> 3. **FCMP libcall return width** — GlobalISel's `createFCMPLibcall` hardcoded
>    the soft-float compare libcalls (`__eqdf2` …) as returning **i32** and built
>    the `G_ICMP`-with-#0 on i32; on 16-bit-int Z80 the high word was callee
>    garbage, so `a == a` returned false. Fixed by routing through
>    `getCmpLibcallReturnType()` (default i32; Z80 override → i16).

---

## The gap (all verified this session — see EVIDENCE.md for commands/output)

- Our llvm-z80 clang emits **IEEE-754** `float` (4 B) / `double` (8 B) with the
  **standard compiler-rt libcall names**: `__mulsf3 __addsf3 __fixsfsi __gtsf2`,
  `__adddf3 __muldf3 __divdf3 __eqdf2 __ltdf2 __extendsfdf2 __truncdfsf2
  __fixdfsi __floatsidf`, etc. (In asm the leading `_` is z88dk's, shown as
  `___mulsf3`.)
- z88dk's classic clib provides **none** of them (its float lib is a different,
  non-IEEE **math48** 6-byte format with different entry names). It also lacks
  the integer helpers `__mulsi3` (32-bit) and `__muldi3` (64-bit) multiply.
- Result: only **constant-folded** float works; any runtime float op fails at
  **link** time (`undefined symbol: ___mulsf3` …).

So the fix is a **runtime library**, not a codegen change. Our clang is already
correct (IEEE + standard names) — we just have to supply the routines.

## How ez80-clang (CE-Programming) does it — verified from source

`CE-Programming/llvm-project` (branch `z80`), `llvm/lib/Target/Z80/Z80ISelLowering.cpp`
remaps **every** float RTLIB entry to a custom-named runtime with **custom
calling conventions**, e.g.:

```
ADD_F32 -> "_fadd" (Z80_LibCall_L)   ADD_F64 -> "_dadd" (Z80_LibCall)
MUL_F32 -> "_fmul"                    MUL_F64 -> "_dmul"
FPTOSINT_F32_I32 -> "_ftol"          FPEXT_F32_F64 -> "_ftod"
SQRT_F64 -> "sqrtl"  SIN_F64 -> "sinl"  ... (libm = *l names, long double==double)
```

Their f64 core is **Berkeley SoftFloat** (`src/softfloat/f64_*.c`), reached
through custom-CC glue; their f32 path is hand-written eZ80 ADL asm
(`src/libc/float32_*.src`); `%f` uses **nanoprintf** (`src/libc/printf/nanoprintf.c`).

**Not reusable for us:** their runtime glue uses eZ80 calling conventions and
ADL (24-bit) asm; their backend table targets those custom names.
**Reusable for us:** the portable **Berkeley SoftFloat C core** (BSD) and
**nanoprintf** (MIT). We compile them with **our** clang (default C ABI ⇒ ABI
matches by construction) and bridge names with trivial shims.

## Why this is easy for us

We already have the hard half — a Z80 clang that emits IEEE + standard
compiler-rt names. We do **not** need CE's custom-CC scheme. We compile the
library with the same clang that compiles the caller, so argument/return
layout matches automatically. Bridging is just:

```c
float  __addsf3(float a, float b);   // = sf_add on the bit patterns
long   __fixsfsi(float a);           // returns 32-bit; int case uses low 16
int    __gtsf2 (float a, float b);   // 16-bit int; >0 means a>b
```

### Verified ABI facts (from generated asm, EVIDENCE.md)
- `__gtsf2` return is a **16-bit `int`** (our `int`); `>0 ⇒ a>b`.
- `__fixsfsi` return is **32-bit** (`_cvt` and `_cvtl` both tail-call it).
- Shims are compiled by the same clang ⇒ **no manual register matching needed.**
- 16-bit multiply links (inlined); **32-bit (`__mulsi3`) and 64-bit (`__muldi3`)
  do NOT** — Phase 2's mantissa multiply is built from shift-add instead.
  For Phase 3 (f64) these wide integer multiplies/divides are supplied by the
  sibling **`../llvmz80-intrt`** compiler-rt subset (now in place), so a vendored
  Berkeley SoftFloat f64 core (which relies on 32×32→64 sub-multiplies) will link.

---

## Layout

```
src/sf32.c      Phase 1 single-precision cores + compiler-rt-named shims.
                Pure integer (no float ops, no wide multiply). Host self-test
                built in under -DSF_SELFTEST (compares cores to native float).
tests/ft_add.c  On-target runtime test (add/sub/compare/fix; NO multiply).
tests/run.sh    Build + run host self-test AND the Z80 target test (ticks).
EVIDENCE.md     Every probe command + output backing the claims above.
```

## Stock `printf("%f")` status (verified 2026-07-16)

Out-of-the-box `zcc +cpm -compiler=llvmz80` `printf("%f", x)` **does not work** —
the `llvmz80-softfloat` nanoprintf path is the only working route:

- **No pragma:** links fine but the float converter is stripped, so `%f`
  silently produces nothing — `printf("x=%f\n", 3.14)` prints `x=f` on Z80
  (literal `f`, value dropped).
- **With `#pragma printf = "%f"`:** **link fails** — z88dk's `__dtoa__.asm`
  pulls `asm_fpclassify`, `__dtoa_base10`, `__dtoa_digits`, `__dtoa_sgnabs`,
  which are only supplied by the sccz80/sdcc genmath math libs, not the
  `llvmz80` lib. Those helpers also assume the **48-bit math48** layout, so even
  if linked they would misformat clang-z80's IEEE-754 binary64. Confirms the
  header/ABI split behind [ravn/z88dk#28](https://github.com/ravn/z88dk/issues/28).

## Footprint / should we split the f64 closure? (analysis 2026-07-16)

**Recommendation: do NOT split the SoftFloat arithmetic closure.** Measured per
`build64.sh` (32 objects, ~49 KB) the closure is already delivered at
**per-function granularity**: `build64.sh` compiles only the objects reachable
by undefined-symbol resolution from the program, so a program that never divides
never pulls `f64_div.o` (4566 B), never multiplies → no `f64_mul.o` (2472 B) /
`s_mul64To128.o` (1034 B), etc. The 49 KB figure is the *full-API* `ft_dbl`
test (add+sub+mul+div+compares+all conversions); a real driver pays for its
subset only.

A two-way split would not help, because the bulk that any real double op needs
is a **shared rounding/normalise core** that cannot be partitioned away:
`s_subMagsF64` 5219, `s_normRoundPackToF64` 3972, `s_roundPackToF64` 2463,
`s_addMagsF64` 2424, `s_shiftRightJam64` 1972, `s_shortShiftRightJam64` 1805,
`s_propagateNaNF64UI` 1615 ≈ **15.5 KB shared**. Add-only ≈ that core + a couple
hundred bytes; the closure already shrinks to ~20 KB for add-only. So the useful
axis is *per-op selection* (already automatic), not a fixed two-file split.

The **one split that IS real and already exploited**: `%f` formatting
(nanoprintf) needs **zero soft-float** — it reads raw IEEE bits — so it is a
separate ~24 KB closure built by `build_fmt.sh`, independent of the arithmetic
closure above. Arithmetic-only and format-only programs are already two disjoint
footprints.

Actionable follow-up (not a split): package the arithmetic closure as a z88dk
**`.lib`** so downstream programs get on-demand pulling without re-running
`build64.sh`'s discovery loop.

## Path to stock `printf("%f")` (roadmap)

`%f` splits into two independent capabilities; the **conversion already works**,
only the **variadic delivery** is blocked:

| Capability | State | Blocker |
|-----------|-------|---------|
| `double`→string `%f` conversion (nanoprintf, IEEE bits) | **WORKS**, 50/50 vs glibc | none |
| Fetch the `double` from `printf`'s `...` via `va_arg` | **FIXED** | was [ravn/llvm-z80#270](https://github.com/ravn/llvm-z80/issues/270) — **not a backend bug**: z88dk `<stdarg.h>` located varargs via `&last` (breaks under clang param-spilling). Fixed in z88dk `bb914a1` (defer to `__builtin_va_*` under `__LLVMZ80`). |
| Stock z88dk `__dtoa_*` converter | math48-only, wrong for IEEE | irrelevant once nanoprintf is the `printf` backend |

**So real variadic `printf("%f", x)` now works.** The `va_arg` blocker (#270)
was a **z88dk header bug** (`<stdarg.h>` located varargs via `&last`, which
breaks under clang's parameter spilling — same class as the #28 `<float.h>`
divergence), **not** an llvm-z80 backend defect. Fixed in z88dk `bb914a1` by
deferring `va_start`/`va_arg`/`va_end` to `__builtin_va_*` under `__LLVMZ80`.
Verified on Z80: `vsum(3,10,20,30)` -> 60 at -O0/-O1/-O2, and variadic
`npf_snprintf("%.4f|%d|%.2f", 3.14159, 42, -2.5)` -> `3.1416|42|-2.50`.

The non-variadic `npf_snprintf_f(buf, x)` shim is therefore **no longer
required** (kept only as a stock-z88dk fallback; `ft_fmt` can switch to variadic
`npf_snprintf` — tracked as `wire-variadic-printf`).

## Known limitations

> For an upstream-facing, ready-to-paste version of these caveats (for when this
> is filed with the z88dk project), see [`UPSTREAM_CAVEATS.md`](UPSTREAM_CAVEATS.md).

- **`%f` is a gap in *stock* z88dk — it works ONLY through this project's
  shim.** `%f` is verified correct (50/50 byte-identical to glibc) *when routed
  through this project's nanoprintf* — now via the **variadic** `npf_snprintf`
  (since the `va_arg` fix below) or the non-variadic `npf_snprintf_f` shim.
  Plain `zcc +cpm -compiler=llvmz80` `printf("%f", x)` (z88dk's own precompiled
  formatter) still does **not** work (see "Stock `printf("%f")` status" above):
  without a pragma the converter is stripped and `%f` silently prints literal
  `f`; with `#pragma printf = "%f"` it fails to link (genmath-only
  `asm_fpclassify`/`__dtoa_*` helpers, math48 layout). The remaining stock
  blocker is the header/ABI split ([ravn/z88dk#28](https://github.com/ravn/z88dk/issues/28));
  the `va_arg` blocker is fixed (below). So "float works for llvmz80" means *via
  this project's nanoprintf*, not via z88dk's stock `printf`.
- **`%e` / `%g` are NOT supported** (known bug, tracked). This is a **nanoprintf
  v0.6.1 feature gap, not a compiler bug**: `npf_ftoa_rev` always renders fixed
  decimal, and the exponent code path (`nanoprintf.h` ~line 858) is `%a`
  hex-float only. Scientific / shortest conversions are *parsed* but silently
  degrade to `%f`, so the emitted string is wrong for `%e`/`%g`. The `ft_fmt`
  test is deliberately scoped to `%f` so it never asserts a wrong `%e`/`%g`
  string. Fix options if a driver needs them: enable a newer nanoprintf with
  scientific support, or add an IEEE float→string exponent path.
- **`va_arg` was broken via z88dk `<stdarg.h>`, now FIXED** (z88dk `bb914a1`).
  This was **not** an llvm-z80 backend bug (clang's `__builtin_va_start` is
  ABI-correct): z88dk's classic `<stdarg.h>` located varargs via `&last`, which
  breaks under clang's parameter spilling. Same class as z88dk#28. With it
  fixed, variadic `printf("%f")` via nanoprintf works; the non-variadic
  `npf_snprintf_f` shim is now only a stock-z88dk fallback. Was tracked as
  [ravn/llvm-z80#270](https://github.com/ravn/llvm-z80/issues/270).
- **`s_roundPackToF64.c` must be built at `-O0`** to dodge
  [ravn/llvm-z80#267](https://github.com/ravn/llvm-z80/issues/267) (textual `jr`
  under-relaxation once it is inlined large).

## How to resume / test

```sh
cd llvmz80-softfloat
./tests/run.sh          # host self-test (native oracle) + Z80 link+run via ticks
```

Environment the harness expects (macbook):
- llvm-z80 clang:  `../llvm-z80/build-macos/bin/clang`
- z88dk on PATH:   `export PATH=../z88dk/bin:$PATH ; export ZCCCFG=../z88dk/lib/config/`
- cycle-accurate runner: `z88dk-ticks` (on PATH via z88dk/bin) driven by
  `../scratch/dcc-clang-bench/ticks_cpm.py`

### Next actions (Phase 3)
Phases 1 & 2 are DONE (single precision: add/sub/mul/div/fix/compares, host 2M/0
+ Z80 ticks). Remaining:
1. Consider supplying `__mulsi3`/`__muldi3`/`__udivsi3` as general integer
   helpers (separate concern; the whole compiler-rt integer runtime is missing —
   the soft-float cores deliberately avoid them via shift-add).
2. Phase 3: vendor **Berkeley SoftFloat** (BSD) for double precision
   (`__adddf3` … `__fixdfsi` …), pure-int (SOFTFLOAT_FAST_INT64 off).
3. Phase 4: `printf("%f")` via **nanoprintf** (MIT) or an IEEE float→string
   (z88dk's classic formatter reads math48, not IEEE).

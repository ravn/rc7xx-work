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
| 3 | double precision (`__adddf3` … `__fixdfsi` …) — vendor **Berkeley SoftFloat** (BSD), FAST_INT64 + `INLINE_LEVEL=1` | **BLOCKED** — core verified sound (host oracle + raw `f64_add` on Z80), closure links ~49 KB, but **ravn/z88dk#27** truncates 64-bit global initializers → `ft_dbl` reads garbage. See `bugs/quad_global_init_truncated.md`. |
| 4 | `printf("%f")` — the classic z88dk formatter reads **math48**, not IEEE. Wire **nanoprintf** (MIT) or an IEEE float→string. | TODO |

Whetstone (double + libm sin/cos/exp/log) is the end-goal driver; it needs
phases 3 + 4 plus `sinl/cosl/...`.

> **Phase 3 blocker — [ravn/z88dk#27](https://github.com/ravn/z88dk/issues/27):**
> 64-bit (`long long`/`double`) **global initializers** are silently truncated to
> 32 bits by the `-compiler=llvmz80` copt bridge (`.quad` → a 4-byte `DEFQ`).
> This is a z88dk-bridge bug, **not** the llvm-z80 backend (raw clang emits a
> correct 8-byte `.quad`) and **not** SoftFloat (verified sound). Full write-up +
> repro + workarounds: [`bugs/quad_global_init_truncated.md`](bugs/quad_global_init_truncated.md).

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

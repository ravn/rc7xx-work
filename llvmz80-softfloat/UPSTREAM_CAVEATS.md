# Known caveats — `-compiler=llvmz80` floating point

Ready-to-paste **Known caveats** section for when float support for the
`llvmz80` backend is filed with the z88dk project (e.g. attached to
[ravn/z88dk#28](https://github.com/ravn/z88dk/issues/28) or a follow-up PR/issue).
Keep it current as caveats are fixed. When pasted into a GitHub body, preserve
the authorship split below and leave room for a human abstract on top.

---

**From @ravn (human):**

_(abstract goes here)_

---

**From Copilot (AI):**

These are the caveats a z88dk maintainer or user needs to know about running
IEEE-754 floating point through `zcc +cpm -compiler=llvmz80` (ravn/llvm-z80
clang). Each is verified on Z80 via `z88dk-ticks` unless noted.

### 1. Header / ABI split — classic float headers hardcode math48 (fixed in #28)

The classic `<float.h>` → `<math.h>` → `math_genmath.h` chain hardcodes the
48-bit genmath representation (`DBL_MANT_DIG=39`, `DBL_MAX_EXP=37`,
`INFINITY=9.999e37`, `HUGE_VAL=9.990e37`, `MAXFLOAT=9.995e37`). clang-z80's
`double` is IEEE-754 **binary64** (`__DBL_MANT_DIG__=53`, `__DBL_MAX_EXP__=1024`,
`__SIZEOF_DOUBLE__=8`; `float` is binary32). Any consumer that derives from
`<float.h>` (e.g. nanoprintf: `shift=MANT_DIG-1`, `mask=MAX_EXP*2-1`,
`bias=MAX_EXP-1`) then computes 38/73 instead of 52/2047. Fingerprint: `1.0/3.0`
prints `715827882.666016` = `(1/3)·2³¹`.

**Fix (#28):** override the `FLT_/DBL_/LDBL_` family and
`MAXFLOAT/HUGE_VAL/INFINITY/NAN` with compiler builtins under
`#if defined(__DBL_MANT_DIG__)`. **Caveat on the fix:** the guard MUST stay —
sccz80 and sdcc genmath are *genuinely* 48-bit and do NOT define
`__DBL_MANT_DIG__`, so the deferral must not apply to them. (CE-Programming's
ez80-clang can defer unconditionally because it has no genmath compiler in the
same tree; z88dk cannot.)

### 2. No compiler-rt / integer runtime for `llvmz80`

z88dk ships no soft-float or integer runtime for the clang backend. This project
vendors **Berkeley SoftFloat 3** (BSD) for `double` (~49 KB closure at
`INLINE_LEVEL=1`, per-function granularity — a program pays for the ops it uses).
General integer helpers (`__mulsi3`, `__muldi3`, `__udivsi3`, …) are also absent;
the soft-float cores deliberately avoid them via shift-add. Any upstream float
story needs these helpers packaged (ideally as a `.lib`).

### 3. `printf("%f")` — stock converter is math48-only, does not work for IEEE

Stock `zcc +cpm -compiler=llvmz80` `printf("%f", x)` does **not** work:
- No pragma → the float converter is stripped; `%f` silently prints literal `f`.
- `#pragma printf = "%f"` → **link fails**: `__dtoa__.asm` pulls
  `asm_fpclassify`, `__dtoa_base10`, `__dtoa_digits`, `__dtoa_sgnabs`, supplied
  only by the sccz80/sdcc genmath libs, and those operate on the **math48**
  layout — wrong for IEEE binary64 even if linked.

This project routes `%f` through vendored **nanoprintf** (MIT), verified 50/50
byte-identical to glibc. **`%e`/`%g` are unsupported** in nanoprintf v0.6.1
(fixed-decimal only; scientific silently degrades to `%f`).

### 4. `va_arg` is broken in clang-z80 (llvm-z80#270)

Because of [ravn/llvm-z80#270](https://github.com/ravn/llvm-z80/issues/270),
variadic `printf("%f", x)` cannot fetch the `double` argument correctly. This
project uses a **non-variadic** `npf_snprintf_f` shim to sidestep it; a real
variadic `printf("%f")` needs #270 fixed first.

### 5. Backend bugs worked around (llvm-z80 side, not z88dk)

Reaching green required fixing/dodging several ravn/llvm-z80 bugs — listed so a
z88dk maintainer knows they are compiler-side, not header/library-side:
- **#267** — textual asm printer under-relaxes far `jr` (>±127 B); external
  z80asm rejects (`integer range: $84`). Worked around by building
  `s_roundPackToF64.c` at `-O0`. Regression test filed (XFAIL).
- **#268** — sret-dest miscompile (`eliminateFrameIndex` added
  `CalleeSavedFrameSize` to incoming-arg/sret fixed objects) → wrong copy slot,
  CP/M warm-boot hang. Fixed.
- **#270** — `va_arg` (above).
- **z88dk#27** — the `llvmz80` copt bridge truncated 64-bit (`long long`/
  `double`) **global initializers** to 32 bits (`.quad` → 4-byte `DEFQ`). Fixed
  by a pre-copt `splitquad.pl` pass in `z88dk/lib/llvmz80/`.

### 6. TPA footprint

The full double closure is ~49 KB (arithmetic) + ~24 KB (`%f` formatting,
independent — needs no soft-float, reads raw IEEE bits). A program doing real
double math on a 64 KB-TPA CP/M target should budget accordingly.

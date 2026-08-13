---
name: DR C 1.11 (CP/M-86) float/8087 ABI facts
description: DR C -f needs an 8087; default is software float; double returns in DX:CX:BX:AX, float in BX:AX
type: reference
metadata:
  node_type: memory
  type: reference
---
From the DRI C Language Programmer's Guide for CP/M-86, 2nd ed. 1983
(`cpm86-crossdev/docs/manuals/DRI_C_Programming_86.pdf`, see
[[reference_dri_cpm86_manuals_location]]). Relevant to the RC759 (8086, **no
8087**) Mandelbrot / ABI-oracle work.

**8087 vs software float (§2.1, the `-f` switch):**
- `-f` = "Use 8087 math coprocessor" for FP arithmetic. **Requires the 8087
  hardware.** A `-f` binary on a machine without an 8087 "does not execute
  properly."
- **Without `-f` (default), the compiler emits calls to software FP routines in
  the system library.** This is the RC759-faithful path — confirmed empirically:
  our DR C float build had **0 x87/ESC opcodes** (pure software). So the DR C
  software-float Mandelbrot timing (77,804 ms @6 MHz) is the valid RC759 number;
  the Watcom `-fpi87` (inline 8087) number is NOT RC759-faithful.

**Float formats (§6.3–6.4):** `float` = 4-byte IEEE (8-bit exp, bias 0x7F, 23+1
mantissa, ~7 digits); `double` = 8-byte IEEE (11-bit exp, bias 0x3FF, 52+1
mantissa, 15 digits). **"C performs all floating point arithmetic in double
precision"** — `float` widens to double; results narrow with round-then-truncate.
Matches the READ.ME note that `-f` float-returning functions must be declared
`double`.

**Function return registers (Table 5-1, §5.5):**
| C type | register(s) |
|---|---|
| `int`, `char`, `short`, small-model pointer | `AX` |
| `long`, `float`, big-model pointer | `BX:AX` (BX = high word, AX = low) |
| `double` | `DX:CX:BX:AX` (DX high, CX high-mid, BX low-mid, AX low) |

So a returned `double` lands in **DX:CX:BX:AX** — use this when single-stepping
or bridging a Watcom↔DR C float oracle. (Args are pushed on the stack; DR C
defaults to LARGE model and calls externals FAR — see
[[reference_dri_cpm86_manuals_location]].)

**CLEARL transcendentals are REAL software routines, not stubs (bwdis-verified
2026-08-13).** Retracts an earlier wrong "nofloat stub / garbage" claim. CLEARL
module `FPTRAN` publishes `sqrt sin cos tan exp log log10 atan` as thin wrappers
that `call _DP*` (impl in module `DPFNCS`, which uses software primitives
`_DPADD/_DPMUL/_DPDIV`); **zero 8087 opcodes**. Genuine DR C computes them
correctly at runtime (sqrt2=1.4142, sin1=0.8415, cos1=0.5403, exp1=2.7183,
atan1=0.7854). The earlier "garbage" was a **K&R declaration bug**: an undeclared
math fn defaults to `int` return, truncating the 8-byte double to AX and
corrupting the `%f` vararg — reproducible in genuine DR C too. Declare them
`double`.

**Bridge (Watcom `-fpi87`) carries basic float/double arithmetic + printf
`%f`/`%g` correctly (t_testc), but NOT double-*returning* library calls.** Under
`-fpi87` Watcom's double-return ABI is `fld qword ptr [bx]` (pointer-to-result in
BX / 8087 ST0); the `value [dx cx bx ax]` DRC_DBL pragma is ignored for 8-byte
doubles, so DR C's DX:CX:BX:AX result is lost (prints 0 / denormal). Fix needs an
asm thunk (repackage DX:CX:BX:AX → memory, return ptr in BX) or a non-8087 float
model — NOT a pragma tweak. Full write-up:
`scratch/rc759-cmd-toolchain/DRC_FLOAT_ANALYSIS.md`; repro
`.../drc-libtest/blocked_math.c`.

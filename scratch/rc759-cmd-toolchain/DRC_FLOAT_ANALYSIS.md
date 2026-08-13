# DR C 1.11 floating point & the Watcom→DR C bridge — analysis

Scope: how floating point works in genuine Digital Research C 1.11 (CP/M-86,
RC759), what the manual says, what the CLEARL/CLEARS libraries actually contain,
and exactly where the Open Watcom → DR C ABI bridge does and does not carry
floating point across. Every claim below is **verified** (bwdis disassembly +
runtime under emu2) unless explicitly marked a hypothesis.

Companion files: `drc-libtest/blocked_math.c` (the differential test that
exposes the bridge gap), `drc-libtest/t_testc.c` (official §2.5 TEST.C, the
basic-arithmetic case that PASSES), `tasks/memory/reference_drc_float_8087_abi.md`,
`tasks/memory/reference_watcom_drc_abi_bridge.md`.

---

## 1. What the manual says (DRI C Language Programmer's Guide, 2nd ed. 1983)

**§2.1, the `-f` switch** (verbatim sense):

> The `-f` option switch directs the compiler to use the Intel 8087 math
> coprocessor for floating point arithmetic. You must have the 8087 to use `-f`.
> **If you do not specify `-f`, the compiler calls routines in the system
> library for floating point math.** If you run a `-f` program on a machine
> without an 8087, the program does not execute properly.

READ.ME item 11: with `-f`, float-returning functions must be declared
`double`.

**Consequence:** the RC759 has **no 8087**, so the faithful path is the default
(no `-f`) = **software floating point out of the system library** (CLEARL /
CLEARS). The manual says nothing about "stubs"; it says the software routines
are present. That is correct — see §2.

Return-register convention (Table 5-1, §5.5), reconfirmed by disassembly:

| C type                              | register(s)                    |
|-------------------------------------|--------------------------------|
| `int`, `char`, small-model pointer  | `AX`                           |
| `long`, `float`, large-model pointer| `BX:AX` (BX high, AX low)      |
| `double`                            | `DX:CX:BX:AX` (DX high … AX low)|

---

## 2. What CLEARL actually contains (bwdis-verified)

Unpacked with `unpack_l86.py` → 131 modules. Relevant ones:

- **`040_FPTRAN.obj`** — PUBLICs `sqrt sin cos tan exp log log10 atan`. Each is a
  thin wrapper: pop the 8-byte double argument off the stack, `call _DP*`, then
  `mov dx,hi / cx / bx / ax,lo` and `retf`. **Zero 8087 opcodes.**
- **`023_DPFNCS.obj`** — PUBLICs `_DPSQRT _DPSIN _DPCOS _DPTAN _DPEXP _DPLOG
  _DPLN _DPATN _DPXTOI`. The real double-precision implementations; they call
  the software FP primitives `_DPADD _DPMUL _DPDIV _DPRDIV` and `FPERROR`.
  **Zero 8087 opcodes** → pure software double.
- **`028_FABS.obj`** — `fabs`.
- **`129_YESFLOAT.obj`** — the `yesfloat`/`nofloat` linkage hook (the classic
  DR C "is the float formatter linked?" switch for printf/scanf `%f`).

**Verdict: the transcendentals are REAL software routines, not stubs.** Genuine
DR C computes them correctly (runtime under emu2, fixed-decimal `%.4f`):

```
atof("3.14159") = 3.1416
sqrt(2.0)       = 1.4142
sin(1.0)        = 0.8415
cos(1.0)        = 0.5403
exp(1.0)        = 2.7183
fabs(-2.5)      = 2.5000
atan(1.0)       = 0.7854
```

### 2a. Correction of an earlier wrong claim

A previous session recorded that "CLEARL has only nofloat stubs; transcendentals
return garbage even in the pure genuine build." **That was wrong.** The garbage
was a **K&R declaration bug in the test**, not a library limitation:
`drctest.h` declared `double atof()` but left `sqrt/sin/cos/exp/atan/fabs`
undeclared. In K&R C an undeclared function returns `int`, so `printf("%.4f",
sqrt(2.0))` truncated the 8-byte result to `AX` and the `%f` vararg read stack
garbage — reproducibly, in genuine DR C too (all six printed the *same*
denormal, the tell-tale of a corrupted vararg frame). Declaring them `double`
fixes genuine completely (values above). The oracle discipline lesson: a
"library is broken" verdict that is really a caller-side declaration bug is an
oracle error, not a library fact.

---

## 3. What the bridge carries across — and what it does not

The bridge (`cc-cpm86.sh`) compiles the user source with **Open Watcom
`bwcc -fpi87`** (inline 8087) and links DR C's CLEARL/CLEARS. `_preincl.h`
supplies `#pragma aux` value-register overrides so Watcom reads DR C's return
registers (`DRC_LONG` = `[bx ax]`, `DRC_DBL` = `[dx cx bx ax]`, etc.).

### 3a. WORKS: basic double arithmetic + printf `%f`/`%g`

Official §2.5 `TEST.C` (`t_testc.c`) does `float` add and `double` divide and
prints with `%g`/`%ld`/`%u`. **Genuine and both bridge models are byte-identical**
(float `1.235`, double `4567`). So Watcom's inline-8087 doubles are bit-compatible
with DR C's IEEE format, and DR C's `printf` reads a Watcom-produced double
vararg correctly. Basic FP across the bridge is solid.

### 3b. BLOCKED: double-*returning* DR C library calls under `-fpi87`

`blocked_math.c` calls `sqrt/sin/...` and prints the results. Genuine = correct
(§2). **Bridge = wrong** (large model prints `0.0000`, small prints denormal
garbage). Root cause, from the bridge codegen (bwdis):

```
    call    far ptr sqrt          ; DR C returns double in DX:CX:BX:AX
    fld     qword ptr [bx]        ; <-- Watcom -fpi87 expects a POINTER in BX
    fstp    qword ptr -8[bp]      ;     to the 8-byte result in memory
```

Under `-fpi87`, Watcom's double-return ABI is **`fld qword ptr [bx]`** (result
addressed by `BX`, i.e. pointer-to-result / 8087 `ST0` model). The
`value [dx cx bx ax]` pragma — which correctly redirects `long` and pointer
returns — is **ignored for 8-byte `double`** in 8087 mode. Removing the trailing
`far` from the large-model `DRC_DBL` pragma changes nothing: the `fld [bx]` is
emitted regardless. DR C hands back the *value* in DX:CX:BX:AX, Watcom reads a
*pointer* from BX → the double is lost.

This is a genuine ABI mismatch, **not fixable by pragma alone** while the bridge
uses `-fpi87`.

### 3c. Why `-fpi87` in the first place

DR C's libraries provide **no Watcom-compatible software-float helpers**
(`__fltused`, `IF@D*`, etc.). Compiling the bridge with Watcom's software float
(`-fpc`) would drag in Watcom's own float runtime, which is not linked. `-fpi87`
sidesteps that by doing FP inline on the 8087 (emu2/emulated) — which is why
basic arithmetic works. The cost is the return-ABI mismatch in §3b.

---

## 4. Options to unblock double-returning calls (not yet implemented)

Ranked by effort/risk. All are **hypotheses** pending a build+run.

1. **Asm thunks per double-returning routine.** For each of `sqrt/sin/cos/exp/
   tan/atan/log/log10/atof`, ship a tiny large-model asm shim that `call`s DR C's
   routine (value in DX:CX:BX:AX), stores the 8 bytes to a static buffer, and
   returns the buffer *pointer in BX* — exactly what Watcom's `fld qword ptr [bx]`
   wants. Declare the shims (not the raw routines) in `_preincl.h`. Lowest risk;
   purely additive; matches the observed Watcom expectation.
2. **Watcom 8087 math helpers instead of DR C's.** With ANSI prototypes +
   `#pragma intrinsic`, `fabs`/`sqrt` inline to 8087 ops; `sin/cos/exp/log/tan/
   atan/pow` emit EXTRN `IF@DSIN`/`IF@DSQRT`/… + `__8087`, `_fltused_`. Would
   require classicizing Watcom's `math87*.lib` objects (OMF→LINK-86, like the
   WMARKS/CLEARL path) and linking them. More objects, more ABI surface; verify
   values against an INDEPENDENT oracle (host libm / hand-computed), never DR C's
   own output.
3. **Non-8087 float model for the whole bridge.** Would make register-value
   pragmas apply uniformly but needs a full software-float runtime linked — the
   thing `-fpi87` was chosen to avoid. Highest effort.

For any of these, the acceptance test already exists: `blocked_math.c` under the
differential runner must go byte-identical to genuine across both models.

---

## 5. Bottom line

- **Basic float/double arithmetic + printf/scanf `%f`/`%g` across the bridge:
  COMPATIBLE and verified** (`t_testc.c`, 8/8 suite green).
- **DR C's transcendentals are real software routines and correct in genuine
  DR C** — the earlier "stub" claim is retracted (§2a).
- **Double-*returning* DR C library calls do not bridge under `-fpi87`** (§3b);
  the fix is an asm thunk or a different float model, not a pragma tweak.
- The math library is **not "incompatible"** — it computes correctly; the gap is
  purely the double-return register/pointer ABI on the Watcom side.

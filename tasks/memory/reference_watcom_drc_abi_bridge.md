# Watcom -> DR C calling-convention bridge (verified 2026-08-13)

> **RETIRED 2026-08-19.** The Watcom+LINK-86 hybrid build/test pipeline in
> `scratch/rc759-cmd-toolchain/` (cc-cpm86.sh, ccrc759.sh, omf_classicize.py,
> drcbridge.h, bridge-*.sh, drc-abi-test.sh, drc-libtest.sh, mandel-cpm86.sh,
> install-cpm86-target.sh, l86-to-lib.sh, stdcbench-cpm86.sh + their inputs)
> was REMOVED. The user does not want DR C's LINK-86 linker used with Watcom.
> The sole Watcom CP/M-86 build path is now native one-step `owcc -bcpm86`
> (wcc + wlink `format cpm86`); see `scratch/rc759-cmd-toolchain/USING_OWCC_CPM86.md`.
> The genuine DR C 1.11 oracle (`drc-oracle.sh`, `drc86111/`) is KEPT as an
> INDEPENDENT reference (no Watcom). The contrib-side Open-Watcom→DR
> experiment trees `open-watcom-v2/contrib/ravn/{owc-drc,owc-drlink}/` still
> exist (they feed the contrib benchmark suite) and are a separate, larger
> decision — NOT removed here. Content below is kept as verified history.


How Open Watcom C objects are made ABI-compatible with Digital Research C's
CP/M-86 runtime (CLEARL/CLEARS.L86). This is the "watcall vs cdecl / cmain vs
main" bridge the blocked todos (write-cmdcpm/write-loadcmd) refer to.

## The bridge (VERIFIED WORKING in the contrib pipeline)

`open-watcom-v2/contrib/ravn/owc-drc/build-owc-drc.sh`:
```
CFLAGS="-0 -ms -s -zl -ecc -fpi87 -nt=CODE -fi=compat.h"
```
- **`-ecc`** = set default calling convention to `__cdecl`: arguments pushed on
  the stack RIGHT-TO-LEFT, CALLER removes them. Matches DR C exactly (manual
  §5.4: "places each argument on the stack reading from right to left" +
  "the calling C routine removes the arguments ... ADD SP,<nnn>").
- **`compat.h`: `#pragma aux default "*";`** — emit every symbol (defs AND refs)
  verbatim with NO leading underscore, matching DR C's naming (`atoi`, not
  `_atoi`; confirmed against CLEARL.L86 publics). Applied via `-fi=compat.h`.
- Proven: hello/dhry/mandel/stdcbench compile with Open Watcom C, link against
  DR's CLEARL/CLEARS runtime, and RUN correctly (under emu2 / Unicorn).

## What the bridge does NOT yet cover (the remaining ABI gap)

`-ecc` fixes argument passing + caller-cleanup; `aux default "*"` fixes naming.
But Open Watcom's RETURN-register convention is fixed and DIFFERS from DR C for
multi-word returns (Watcom `docs/doc/cg/ccall.gml`: 16-bit `reg4 = DX AX`,
`reg8 = AX BX CX DX`; DR C manual Table 5-1: long/float = BX:AX, double =
DX:CX:BX:AX). No `-ec` flag changes this.

| return type        | Open Watcom 16-bit | DR C (manual 5-1) | match |
|--------------------|--------------------|-------------------|-------|
| int/char/short/ptr | AX                 | AX                | YES   |
| long / float       | DX:AX              | BX:AX             | NO    |
| double             | AX:BX:CX:DX        | DX:CX:BX:AX       | NO    |

**VERIFIED against the genuine oracle (not just the manual)** — disassembled the
official CLEARL.L86 modules (Open Watcom `bwdis -a` on the unpacked OMF):
- `ATOL` epilogue: `push -6[bp]; push -8[bp]; pop ax; pop bx; ... retf` -> AX=low
  word, BX=high word, i.e. **long returns in BX:AX**.
- `FTELL`, `GETL` epilogues likewise end `pop ax; pop bx; ... retf` -> BX:AX.
- `ATOF` epilogue: `pop ax; pop bx; pop cx; pop dx; ... retf` -> **double returns
  in DX:CX:BX:AX** (AX least significant .. DX most significant).
These confirm the table above; the Watcom defaults (DX:AX, AX:BX:CX:DX) differ.

The working pipeline SIDESTEPS this: stdcbench excludes float/double modules;
floats use `-fpi87` (8087 ST(0), not DR's software BX:AX float return); `long`
multiplies use Watcom's OWN `__I4M/__I4D` cgsupp helpers, not DR's runtime. So a
function that RETURNS long/float/double FROM DR's library is still unbridged.

## Closing the gap -- DONE for long (BX:AX), staged for double

**FIXED for the CP/M-86 target (`cc-cpm86.sh`/`_preincl.h`), 2026-08-13.** The
generated glue `install-cpm86-target.sh` -> `_preincl.h` now splits the DRC
convention by return width via three aliases:
```
#pragma aux DRC      "*" parm caller [] [far];                    /* int/ptr */
#pragma aux DRC_LONG "*" parm caller [] value [bx ax] [far];      /* long/float */
#pragma aux DRC_DBL  "*" parm caller [] value [dx cx bx ax] [far];/* double */
```
and tags the VERIFIED long-returning routines `atol/ftell/getl` as `(DRC_LONG)`
and `atof` as `(DRC_DBL)`; everything else stays `(DRC)`. Extend the LONG/DBL
sets only after the same `bwdis` epilogue check (the generator lists them in
`DRC_LONG_FNS`/`DRC_DBL_FNS`).

**A wrong prior claim was corrected**: the old `_preincl.h` comment asserted
"DX:AX for long ... matches DR C exactly" — that was FALSE (DR C is BX:AX). The
bug was latent only because no shipped program consumed a long/double return.

Proof (failing-test-first, `drc-abi-test.sh` + `atol_bridge_test.c`):
`atol("70000")` = 0x00011170. BEFORE the fix both models printed `00001170`
(high word 0x0001 stranded in BX; Watcom read DX=0). AFTER the fix both models
print `00011170`. Mandelbrot (int/fixed-point) still oracle-verified -> no
regression on int/ptr returns.

**Double (DRC_DBL) caveat**: the register mapping is disassembly-verified, but a
clean RUNTIME double proof is confounded by DR C's separate "nofloat" atof-stub
linkage (a probe built with the genuine DR C compiler returned 0.0 because the
linker pulled the nofloat stub). So `atof` is bridged on the strength of the
disassembly, not yet a runtime value assertion.

## Cross-refs
- DR C return regs / float ABI: reference_drc_float_8087_abi.md
- wlink reads DR OMF, .L86 repackage: reference_wlink_drc_omf_l86.md
- DR C manual: cpm86-crossdev/docs/manuals/DRI_C_Programming_86.txt §5.3-5.5

## How aux pragma is stored (VERIFIED 2026-08-13, empirical)

`#pragma aux` is a COMPILE-TIME directive; it is NOT a linkable attribute. There
is no "calling convention" record in OMF. Its effects surface in the object only
as two things, demonstrated by compiling the same `long caller(void){return
foo(42)+1;}` two ways:

1. **Symbol NAME** — visible in EXTDEF(0x8C)/PUBDEF(0x90) strings. `-ecc` alone
   emits `_foo`/`_caller`; adding `#pragma aux default "*"` emits `foo`/`caller`
   (no underscore). This IS the linkable contract.
2. **Generated CODE bytes** — the register/stack convention is baked into the
   instruction stream, NOT stored as metadata. With `#pragma aux foo value
   [bx ax]` (DR C long-return) the caller emits `... call _foo / add ax,1 /
   mov dx,bx / adc dx,0` — the extra `mov dx,bx` because the high word comes back
   in BX. Without the pragma (Watcom default DX:AX) it is just `add ax,1 /
   adc dx,0`. The linker never sees "returns in BX:AX"; only the bytes.

Consequence: the aux definition MUST be in scope at compile time for EVERY
translation unit that defines OR calls the function — i.e. put it in a shared
HEADER (`#include` or force-include `-fi=compat.h`). A caller TU missing the
pragma silently generates wrong call/return code; the link still SUCCEEDS
(names match) but the runtime ABI is broken. You cannot bake the convention into
a prebuilt library and rely on the OMF to carry it forward.

## Return-register classes -- COMPLETE table (verified 2026-08-13, bwdis)

DR C's return register is a COMPILER-WIDE convention, uniform by return TYPE (not
per function). Proven by disassembling CLEARL/CLEARS modules with `bwdis -a`:

| return type            | registers         | Watcom default | alias    |
|------------------------|-------------------|----------------|----------|
| int / char / near ptr  | AX                | AX (match)     | DRC      |
| far ptr (LARGE model)  | **BX:AX** seg:off | DX:AX (WRONG)  | DRC_PTR  |
| long / float           | **BX:AX**         | DX:AX (WRONG)  | DRC_LONG |
| double                 | **DX:CX:BX:AX**   | AX:BX:CX:DX(W) | DRC_DBL  |

Evidence: `0INDEX`/`0STRN` epilogues end `lea ax,-1[..]; mov bx,es; retf`
(far ptr seg in BX, off in AX). CLEARS `0INDEX` ends `lea ax,..; ret` (near ptr
AX only, small model -> DRC_PTR == plain DRC there).

### BUG FOUND + FIXED (2026-08-13): far-ptr return was mis-mapped
`_preincl.h` previously claimed "large-model far ptr -> DX:AX (Watcom default:
matches)" and used the plain DRC alias for pointer returns. That is WRONG: DR C
returns far pointers in BX:AX. Every pointer-returning routine (malloc, calloc,
realloc, strchr, strcpy-family, fopen, gets/fgets, ...) returned a corrupt far
pointer whose segment (DX, read by Watcom) was garbage -> crash the moment the
result was dereferenced. It "worked" before only because no test had USED a
returned pointer (strcpy tests printed the dest buffer, not the return value).
Fix: DRC_PTR alias (`value [bx ax] far` large / plain AX small), applied to all
pointer-returning routines. Classified from DR C's own STDIO.H return types.

Also completed the DRC_LONG set (added lseek/tell/putl) and DRC_DBL set (added
sqrt/sin/cos/exp/fabs/tan/atan/log/log10) -- previously only atol/ftell/getl and
atof were tagged, so any program calling e.g. sqrt() across the bridge got a
mis-returned double.

### Co-location of prototype + pragma (design, 2026-08-13)
The value-register override only takes effect if the compiler also knows the
return WIDTH, so `install-cpm86-target.sh` now emits, in `_preincl.h`, a matching
prototype right before each PTR/LONG/DBL pragma (`extern char *malloc(); #pragma
aux (DRC_PTR) malloc;` etc.). This makes `_preincl.h` the single source of truth
for BOTH the return type and its register mapping -- they can never drift apart
(the exact bug class above). A far ptr is 4 bytes regardless of pointee, so
`char*` stands in for `FILE*`. These prototypes are Watcom-only (`_preincl.h` is
auto-included via `bwcc -i`); genuine DR C uses its own headers and never sees
them. The original DR C files (rc759-drc-official/, drc86111/) are NEVER modified
-- all Watcom-side glue lives in the generated `_preincl.h`.

## Library conformance suite (drc-libtest/, 2026-08-13)
`drc-libtest.sh` = differential-oracle suite: each portable K&R test built by
genuine DR C (ground truth) + bridge large + small, run under emu2, outputs
diffed. 7 tests PASS both models (string/mem, conv, mem-alloc, qsort/rand,
setjmp, sprintf/sscanf, file I/O). Float/math BLOCKED by DR C's nofloat stubs in
CLEARL (transcendentals return garbage even in the pure genuine build) + software
-double-vs-8087 representation gap. File I/O uses a committed `.expect` oracle
because genuine DR C's read path is confounded under emu2 (bridge is
independently correct). Full per-routine status: drc-libtest/COVERAGE.md.

## Math library compatibility (verified 2026-08-13 via official §2.5 TEST.C)
Q: is DR C's math library compatible with Watcom, or use Watcom's? Answer, split:
- **Basic float/double arithmetic (+ - * /) + printf/scanf %g/%f/%ld: COMPATIBLE.**
  DR C's distribution TEST.C (rc759-drc-official/test.c, manual §2.5) built by
  genuine DR C AND both bridge models gives byte-identical output (float
  1.234+0.001=1.235; double 5635678.0/1234.0=4567). DR C's printf reads Watcom's
  IEEE-8087 doubles correctly. => keep DR C's CLEARL runtime for float VALUE I/O.
  It is now suite test t_testc (differential, PASS both models).
- **Transcendentals (sqrt sin cos tan atan exp log log10 pow): use WATCOM'S.**
  DR C's default CLEARL has only nofloat STUBS (garbage even in pure genuine
  build; real DR C math = a separate FP lib absent from the v1.11 disk). Watcom
  -fpi87: fabs/sqrt inline to 8087 ops (with ANSI proto + #pragma intrinsic);
  sin/cos/exp/log/tan/atan/pow emit EXTRN `IF@DSQRT`/`IF@DSIN`/... + `__8087`,
  `_fltused_` -> Watcom's 8087 helper lib must be linked into the CMD
  (Watcom-OMF -> classicize, or provide equivalents). NOT yet wired; tracked in
  drc-libtest/blocked_float.c. Note: K&R `extern double sqrt()` does NOT trigger
  intrinsic inlining -- needs the typed prototype `double sqrt(double)`.

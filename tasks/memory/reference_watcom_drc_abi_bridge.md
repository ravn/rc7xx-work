# Watcom -> DR C calling-convention bridge (verified 2026-08-13)

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

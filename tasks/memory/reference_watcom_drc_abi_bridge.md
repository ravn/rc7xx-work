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

The working pipeline SIDESTEPS this: stdcbench excludes float/double modules;
floats use `-fpi87` (8087 ST(0), not DR's software BX:AX float return); `long`
multiplies use Watcom's OWN `__I4M/__I4D` cgsupp helpers, not DR's runtime. So a
function that RETURNS long/float/double FROM DR's library is still unbridged.

## Closing the gap (if/when non-int DR returns are needed)

Open Watcom's aux pragma CAN pin the DR return registers per function:
`#pragma aux <fn> value [bx ax]` (long/float) and
`#pragma aux <fn> value [dx cx bx ax]` (double), plus `parm caller []` for stack
args and `"*"` for the bare name (`docs/doc/cmn/pragma.gml` §"Returning ...
Values in Registers"). That is the precise, per-signature way to be 100%
DR-C-compatible on returns — needed only for functions that actually return
long/float/double across the Watcom<->DR boundary.

## Cross-refs
- DR C return regs / float ABI: reference_drc_float_8087_abi.md
- wlink reads DR OMF, .L86 repackage: reference_wlink_drc_omf_l86.md
- DR C manual: cpm86-crossdev/docs/manuals/DRI_C_Programming_86.txt §5.3-5.5

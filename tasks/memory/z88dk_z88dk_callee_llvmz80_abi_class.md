# z88dk __z88dk_callee ABI mismatch class under -compiler=llvmz80

Found 2026 (rc700-gensmedet sem702-flip-test session). Two distinct, compounding
bugs affecting hand-written classic-sccz80 `.asm` stack workers (functions
declared `__smallc __z88dk_callee`) when called from clang under
`-compiler=llvmz80`:

1. **Push-order mismatch.** clang's `sdcccall(0)` pushes stack args with the
   FIRST-declared C parameter ending up TOPMOST of stack. Many classic workers
   (written against sccz80's own natural call-site order) instead expect the
   LAST-declared parameter topmost. Confirmed via `clang -S` vs classic `zcc -S`
   comparison for both `bdos(func,arg)` and `z80_outp(port,data)`.
   - `bdos(2,'H')` silently executed BDOS function 72 with argument 2 instead
     of function 2 with argument 'H' -- surfaced as "Unsupported BDOS call
     72/69/76/76/79/87/79/82/76/68/13/10" (ASCII "HELLO WORLD").

2. **Stack-slot width mismatch (independent bug, only some functions).**
   Classic sccz80 always reserves a full 2-byte stack slot per argument, even
   for `uint8_t`. clang narrows a `uint8_t` parameter to a 1-byte push
   (`push af; inc sp`), so the worker's fixed 2-byte `pop` under-reads/over-reads
   and corrupts the stack -> hang. Reproduced with `z80_outp(uint16_t,uint8_t)`:
   z88dk-ticks ran the full tick budget (hang) with `uint8_t data`; widening
   the low-level reversed prototype's parameter to `uint16_t` fixed it
   (18337 ticks, matching classic's 18334).

**Fix pattern (established, matches existing fread/fseek precedent):** under
`#if defined(__LLVMZ80)`, bind the macro to a NEW low-level prototype with (a)
reversed C parameter order and (b) all narrow (<16-bit) params widened to
their natural register width, bound via `__asm__("original_worker_symbol")
__smallc __z88dk_callee` to the SAME underlying `.asm` symbol -- no assembly
changes needed. See `z88dk/include/cpm.h` (`bdos`/`bdosh`) and
`z88dk/include/arch/z80.h` (`z80_outp`), commit 68a3462825.

**Scope of remaining risk:** ~1500 other `__z88dk_callee` declarations exist
across z88dk headers (string.h, stdio.h, stdlib.h, math.h, arch/*.h, etc.).
Only `bdos`/`bdosh`/`z80_outp` have been audited and fixed so far. Any other
multi-arg `__z88dk_callee` function reached via `-compiler=llvmz80` should be
assumed unverified until individually checked with the same `-S`
push-order + width comparison, since the register/stack layout differs per
function signature (this is NOT a single global backend bug -- each function
needs its own reversed/widened prototype).

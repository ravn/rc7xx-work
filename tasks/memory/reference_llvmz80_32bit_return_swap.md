# llvmz80 32-bit (`long`) return word-swapped vs classic clib — clock() case

**Status: verified + fixed (ravn/z88dk#51). 2026-08-07.**

## The bug (one line)
Under `-compiler=llvmz80`, any classic-clib function returning a 32-bit value
(`long`/`unsigned long`/`clock_t`) delivers the two 16-bit halves **word-swapped**
to C. This is the 32-bit facet of the same HL<->DE return-register class as
ravn/z88dk#50 (16-bit int) and #31 (variadic stdio).

## Root cause (proven via `clang -S`, no-arg call)
- classic clib returns 32-bit as **HL = low word, DE = high word** (SDCC `DEHL`).
- clang default llvmz80 reads 32-bit return as **DE = low, HL = high**.
- => the two words are exchanged.

Minimal proof (store `clock()` low/high to globals, read the asm):
```
default : g_lo = DE, g_hi = HL      ; swapped vs clib
fastcall: g_lo = HL, g_hi = DE      ; matches clib
```
Runtime symptom: a real 0xFFFC tick counter of 285 arrives in C as
`0x011D0000` (i.e. `285 << 16`).

## The fix (existing attribute, NOT a new one)
Enrich the prototype with `__z88dk_fastcall` — it makes clang read the 32-bit
return as HL=low/DE=high, matching the asm worker. Applied to `clock()` in
`z88dk/include/time.h` (line ~109). Same mechanism as the #50 graphics fix
(`getx/gety/getmaxx/getmaxy`).

Commit `aa9d9d8103` on z88dk branch `fix/llvmz80-graphics-hl-return`
(sibling of graphics fix `b284cd5b14`). NOT pushed / NOT merged as of 2026-08-07.

## Verified (external MAME oracle: store clock() to RAM, read back via Lua)
- llvmz80: `221 -> 285` correct (was `0x00DD0000 -> 0x011D0000` swapped).
- sccz80: `221 -> 291` unchanged (NO regression — fastcall harmless for 0-arg
  32-bit return under sccz80).
Harness: `rc700-gensmedet/scratch/sine-demo/clkverify.c` + `clkverify_run.lua`.

## clock() facts (confirmed this session)
- `clock()` correctly reads the RC700 BIOS-ISR 32-bit tick counter at `0xFFFC`
  (low word) / `0xFFFE` (high word), ~50 Hz. `CLOCKS_PER_SEC = 50` for __RC700__.
  The ONLY bug was the compiler return-ABI word-swap — the binding itself is right.
- User note (not yet acted on): the ORIGINAL RC700 BIOS also has a vendor-extension
  BIOS call for reading the clock (more robust across BIOSes than reading 0xFFFC
  directly; rcbios-in-c may not maintain 0xFFFC). Optional future robustness lever.

## Remaining exposure
NOT clock()-specific: EVERY long-returning classic entry point reachable under
llvmz80 has the same swap unless its prototype is bridged (or routed through a
stack/`__ZPROTO` worker like #31/#41). Only `clock()` is fixed so far; the general
audit of long-returning classic decls is open work tracked in #51 (cf the ~1500
unaudited decls noted in z88dk_z88dk_callee_llvmz80_abi_class.md).

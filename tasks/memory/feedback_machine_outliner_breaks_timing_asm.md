---
name: feedback_machine_outliner_breaks_timing_asm
description: LTO's machine outliner can replace __asm__ volatile("") barriers with a CALL to an outlined snippet, breaking cycle-counted timing loops — use real asm, not C+barrier
metadata:
  type: feedback
---

Cycle-counted timing loops in C (with `__asm__ volatile("")` as
optimization barrier) are NOT safe under LTO: the machine outliner
replaces common instruction sequences — including the loop body
containing the empty asm — with a CALL to an outlined function. The
call+ret overhead corrupts the cycle count.

**Why:** The user's RC702 autoload `delay()` function (2026-10-09)
suffered this: FDC's floppy-ready wait timed out because the delay
ran at 1/N speed. Symptom: "NO DISK" on an otherwise valid floppy.
Visible in listing as `call $NNNN` inside the inner `dec/jr nz` loop,
with the outlined target being 5 bytes of `add a,ff; sbc a,a; and 1;
xor 1; ret`.

Three remediation options, ordered by robustness:
1. **Pure assembly implementation** in a `.s` file (RECOMMENDED).
   Immune to all compiler optimization. See `autoload-in-c/clang/delay.s`
   as a 13-byte template using `sdcccall(0)` (outer=A, inner=L).
2. `__attribute__((noinline, optnone))` on the C function. Works but
   forces IX frame (+17 B overhead vs 1 register pair) and still risks
   future LTO changes.
3. `__attribute__((noipa))` — tried, insufficient; outliner still fires.

**How to apply:** For any cycle-timing code (FDC delays, bitbang I/O,
hardware polling calibrated to T-states): write it in `.s` from day
one. Don't start with "C + volatile asm barrier" and only move to
assembly after a boot failure.

TODO on autoload: switch to z88dk's `z80_delay_ms()` once the native
z88dk integration is stable — it's hand-tuned and verified by
`z88dk-ticks` on real hardware.

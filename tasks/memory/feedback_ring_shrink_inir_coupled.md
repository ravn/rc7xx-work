---
name: feedback-ring-shrink-inir-coupled
description: cpnos PIO-B ring-shrink (256 -> 16 B) and INIR data-block-recv are COUPLED — shrinking the ring without using INIR drops bytes on bursts and breaks netboot
metadata:
  type: feedback
---

When bundling a PIO-B `pio_rx_buf` ring-size reduction with the INIR
block-recv refactor (#115 Steps 2+4), the two changes are NOT
independent.  Bisecting them was the trap I fell into 2026-06-14.

**Rule:** ring-shrink REQUIRES INIR.  Don't ship the shrink without
INIR, and don't test the shrink with INIR forcibly bypassed
(`transport_uses_pio = 0` for "just SIO loop" debug) — that
configuration breaks for reasons that aren't a bug in your code.

**Why:** the design refinement in
`cpnos-in-c/tasks/session-2026-06-13-phase4-inir-and-mame-findings.md`
"Design refinement" section sizes the ring to **max contiguous
control-byte burst (8 B)**, on the assumption that **data bytes go via
INIR direct to `msg+5..msg+SIZ+5`, bypassing the ring**.  Without INIR,
the 41-byte data block flows through the ring; a 16-byte ring overflows
during burst transfers; `isr_pio_par` drops bytes; slave's step (7)
ETX check fails; RC_RETRY without NAK; outer loop waits for an ENQ
master never sends; deadlock; slave eventually falls into the
`_resident_handoff` `jr $f301` netboot-failed dead loop.

Diagnosed via MAME debugger CPU trace (`cpnos-polypascal-test-trace`):
17 ISR fires, 2 to the drop path = 12 % drop rate.  See
`cpnos-in-c/tasks/session-2026-06-14-inir-step-2-4-blocked-on-size.md`
for the full bisect.

**How to apply:**

1. If you're shrinking the ring as a size-or-BSS optimization,
   confirm INIR is the data path FIRST.  If it isn't, leave the ring
   at 256.
2. If you're trying to bisect a ring-shrink + INIR bundle by
   forcing the INIR off (e.g. `transport_uses_pio = 0` to test the
   "SIO-loop branch in isolation"), don't expect it to pass — that's
   an invalid configuration.  Restore the ring to 256 in the same
   step that disables INIR.
3. If you see the slave hang AFTER receiving a full data block in
   the bridge log (last byte is EOT but no ACK back), suspect ring
   overflow first.  CPU-trace with `cpnos-polypascal-test-trace` and
   count `EEC8: in   a,($11)` lines vs `EEE5: pop  af` lines — the
   ratio is your drop rate.
4. The same coupling applies wherever a fixed-size SPSC ring's
   sizing assumes a fast-path consumer (INIR, DMA, etc.) drains the
   bulk and the ring only holds control bytes.  Always check the
   sizing assumption matches the actual deployed configuration.

**Related:**

- `cpnos-in-c/tasks/PIO_INIR_PARKED.md` — the parked bundle
- `cpnos-in-c/tasks/session-2026-06-13-phase4-inir-and-mame-findings.md`
  — the design refinement that sized the ring at 16 B
- `cpnos-in-c/tasks/session-2026-06-14-inir-step-2-4-blocked-on-size.md`
  — the bisect writeup
- [[feedback_dig_deeper_before_parking]] — the deeper-investigation
  rule; the debugger trace was the dig that found this

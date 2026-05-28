---
name: no-taps-in-polled-rx
description: Never inline per-byte debug TX inside a polled-RX hot path on a CPU without RX interrupts -- the blocking TX consumes far more time than the next byte's arrival window, overruns the 3-byte Z80 SIO FIFO, and bytes vanish without warning.
metadata:
  type: feedback
---

Don't place per-byte blocking-emit instrumentation (`call emit_a` / `out
(SIO-B), a` etc.) **inside** a polled receive routine that runs without
RX interrupts.  On Z80 SIO each channel has a 3-deep RX FIFO; if the
per-byte service time (poll + read + debug-emit) exceeds the master's
byte time for more than 3 consecutive bytes the FIFO overruns silently
and bytes go missing — looks exactly like "master skipped the byte" or
"timeout in the receive loop".

**Why:** Caught in cpnos-in-asm session 73e, phase 4c+ → 4d.  After
adding `>XX` / `<XX` taps in `snios_sio_a_rx_to` / `snios_sio_a_tx_a`,
RCVMSG against z80pack mpm-net2 timed out on the 7th header byte
(SOH+5 received, HCS lost).  Both SIO-A (RX) and SIO-B (debug TX) ran
at the same CTC-derived baud (TC=1 + clk/16 → ~15.6 kBaud, ~640 µs
per byte).  Each rx produced 3 chars of SIO-B output ≈ 1.9 ms of
blocking poll-and-out, so after the FIFO primed the 4th-and-onward
byte was lost.  Stripping the taps and rerunning the 6-oracle test
matrix flipped 1 FAIL + 5 PASS → 6/6 PASS, including the real-master
LOGIN exchange.

**How to apply:** Use markers that fire **once per frame** (the per-handler
'r', 'S', 'B', 'c' chars are fine) instead of per byte.  If per-byte
visibility is needed for debugging, push bytes into a RAM ring buffer
inside the rx routine and flush the ring AFTER the frame completes
(EOT seen or timeout), never between successive byte reads.  Same rule
applies to any polled-RX transport (PIO, SIO-B, async UART) on this
class of hardware.  Generalizes [[feedback-verify-writes-before-chasing-reads]]
and [[feedback-recognize-rom-shadow-patterns]] — instrumentation can
introduce the very bug you're trying to diagnose.

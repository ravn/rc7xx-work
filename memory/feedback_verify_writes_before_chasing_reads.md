---
name: feedback-verify-writes-before-chasing-reads
description: "HARD - when a buffer holds wrong data, first verify writes landed; only then investigate what's arriving at the input"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: b20efbb1-10f2-452a-bfa2-432a9ba5a6a3
---

**Rule:** When code reads back wrong bytes from a buffer it just
populated, the first diagnostic question is **"did the write
succeed?"**, NOT "where are the wrong bytes coming from?"  Walking
backward from the read site you immediately wonder about external
sources; walking forward from the write site you find PROM-shadow,
read-only memory, MMIO, etc.

**Why:** cpnos-in-asm phase 3d-γ recv_cpnet_frame stored received
SIO-A bytes into rx_frame_buf and the post-loop dump showed
`08 20 20 52 43 37 30` instead of the master's
`01 01 FF 00 FF 00 00`.  I spent multiple iterations on "what's
flowing into SIO-A?" -- hypothesizing loopback, baud mismatch,
cross-port wiring, hidden SIO echo bits -- before I switched to
"what's the buffer actually holding?"  Once I instrumented the
write site (per-byte SIO-B dump showed A held the RIGHT byte) the
gap closed: `ld (hl), a` was running but the bytes weren't sticking,
which IMMEDIATELY pointed at "HL is not pointing at writable RAM."

The bytes the post-loop dump returned happened to spell out
PROM1's first 7 bytes -- a pattern that, recognised, would have
short-circuited the whole investigation.  See
[[feedback-recognize-rom-shadow-patterns]] for that detail.

**How to apply:** When a buffer reads back wrong:

  1. **Verify the write succeeded.**  Dump the value RIGHT BEFORE
     and RIGHT AFTER each `ld (hl), a` (or equivalent store).  Use
     SIO / a debug serial / MAME Lua to surface it.  If "before"
     matches expected but "after-and-read-back" does NOT, the write
     went into a black hole -- read-only ROM, MMIO, unmapped page,
     CTC counter, etc.  This is a memory-map problem, not an input
     problem.

  2. **Only if writes are confirmed sticking,** investigate what
     the input source is sending.  Now you can reason about wires,
     buffers, protocols.

  3. **If "before" doesn't match expected,** the bug is upstream
     of the store -- arithmetic, register clobber, wrong source
     register, etc.

Embedded systems have non-RAM regions interleaved with RAM (banked
ROMs, MMIO, mirrors).  The instinct that "writes always work" is a
desktop-software habit; on bare metal it isn't true.

**Related:**
  - [[feedback-grep-memmap-before-bss]] is the prophylactic;
    this rule is the diagnostic.
  - [[feedback-rc702-bank2h-mirror]] is the specific bug that
    drove this rule's discovery.

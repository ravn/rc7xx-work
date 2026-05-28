---
name: feedback-rc702-bank2h-mirror
description: "HARD - RC702 maps 0x2800..0x2FFF as bank2h PROM mirror, not RAM. Never put BSS there."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: b20efbb1-10f2-452a-bfa2-432a9ba5a6a3
---

**Rule:** On the RC702, addresses **0x2800..0x2FFF** are NOT plain RAM
-- MAME's `rc702` driver (and the real 74S287 address decoder in IC55)
maps them as `bank2h`, the "extended-EPROM" mirror of the PROM1
socket.  Writes are silently lost; reads return PROM1 bytes (the same
bytes you'd see at 0x2000..0x27FF).

The pattern of bank-mapped regions on the RC702 is:

    0x0000..0x07FF   bank1   PROM0
    0x0800..0x0FFF   bank1h  PROM0 extended-EPROM mirror
    0x2000..0x27FF   bank2   PROM1
    0x2800..0x2FFF   bank2h  PROM1 extended-EPROM mirror

`OUT (0x18), A` (RAMEN) flips all four banks to RAM at once, but until
that happens the 4 KB beyond each EPROM socket is unwritable.

**Why:** Found the hard way in cpnos-in-asm phase 3d-γ.  rx_frame_buf
at 0x2800 made recv_cpnet_frame appear to receive PROM1's own header
bytes (08 20 20 52 43 37 30 = `dw slave_entry + " RC70"`) regardless
of what the master sent.  The receive loop wrote bytes to A correctly,
but `ld (hl), a` writes to 0x2800 vanished and post-loop reads returned
PROM mirror contents.  See cpnos-in-asm/src/prom1.asm comment around
`rx_frame_buf equ 0x3000` for the full diagnostic story.

**How to apply:** When allocating BSS / buffers for code that runs
before PROM-disable, use **0x1000..0x1FFF** or **0x3000..0xF7FF** (the
"between bank1h and bank2" gap, or "above bank2h up to display
memory").  Avoid 0x0000..0x0FFF and 0x2000..0x2FFF entirely.  Confirm
via MAME's rc702.cpp mem_map block before parking anything there.

[[feedback-no-literal-addresses]] -- BSS placement is similarly
linker-derivable; this rule is a precondition for picking a safe
literal range when no linker is involved (zmac).

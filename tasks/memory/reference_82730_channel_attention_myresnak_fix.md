---
name: 82730 channel-attention frame-int lost when field taller than frame (MYRESNAK freeze fix)
description: RC759 MYRESNAK BB/HENT/HUSK froze because the 82730 end-of-frame housekeeping (deferred channel-attention service + EONF interrupt) was keyed to a scanline past frame_length. Fixed by clamping to screen height. (ravn/mame#31, commit 2a4b21cdbdb.)
metadata:
  type: reference
---

**Bug (FIXED 2026-08-30, ravn/mame#31, commit `2a4b21cdbdb`, branch
`rc759-82730-graphics`, NOT pushed / issue NOT closed):** RC759 MYRESNAK froze on
`BB`/`HENT`/`HUSK` (all switch to the text page).

**Root cause — MAME `i82730.cpp`, not MYRESNAK:** end-of-frame housekeeping in
`row_update` (afvikling af udskudt channel-attention `m_ca_latch` + periodisk
EONF frame-interrupt) was keyed to scanline `vfldstp+scroll_margin+1+lpr+1`.
MYRESNAK's text page loads a field TALLER than the frame (288+31+1+15+1 = **336**
vs `frame_length` = **312**); `row_update` only walks `y = 0..frame_length-1`, so
y never reaches 336 → EONF never set → no SINT. MYRESNAK's handshake ("set flag;
OUT CA port 0x240; spin until 82730 ISR clears flag") runs with display active
(DIP set), so CA takes the DEFERRED path and spins forever → apparent freeze.

**Fix:** clamp trigger scanline to `screen().height()-1` (fires exactly once/frame
regardless of field geometry); move the housekeeping out of the y-range if/else
chain into a standalone check; guard `frame_int_count` modulo against div-by-zero.

**Channel-attention facts (verified):**
- ONE CA entry on RC759/RC750: port `0x240` → `txt_ca_w` (`rc75x.cpp:110`) pulses
  `ca_w(1);ca_w(0)`; falling edge latches. Shared by rc759 + rc750.
- TWO service sites: immediate in `ca_w` when display inactive (DIP clear);
  deferred to `row_update` end-of-frame when display active. Latch is only
  re-checked on a new CA edge → `row_update` is the SOLE servicer for
  "latched during active display". So the clamp is the complete fix; no other
  CA site needs it.
- CBP commands (`execute_command`, `i82730.cpp:326`) implemented: 0x00 NOP,
  0x01 START DISPLAY, 0x03 STOP DISPLAY, 0x04 MODE SET, 0x05 LOAD CBP (recurses),
  0x06 LOAD INTMASK, 0x08 READ STATUS, 0x09 LD CUR POS. Stubs: 0x02, 0x07 LPEN,
  0x0a SELF TEST, 0x0b TEST ROW BUFFER. MYRESNAK's page switch = MODE SET (0x04).
  Datastream cmds 0x80-0x8f are separate (row drawing, not CA).

Full writeup: `rc700-gensmedet/docs/RC759_82730_channel_attention.md`.

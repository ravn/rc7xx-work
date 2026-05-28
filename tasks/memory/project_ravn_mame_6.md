---
name: ravn/mame#6 — PIO-B slot regression blocks Option P bring-up
description: Open MAME bug; cpnos-rom IM2 IRQs die when any card is on PIO-B; gating item for the cpnet-fast-link parallel-port path
type: project
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
**Filed 2026-04-26 as [ravn/mame#6](https://github.com/ravn/mame/issues/6).**
On `ravn/mame:cpnet-fast-link`, plugging any card into the PIO-B slot
(`-piob keyboard` or `-piob cpnet_bridge`) stops the cpnos-rom guest
from completing IM2 init: no IRQs fire, screen black, CCP never loads.
The bridge byte path itself works (6 test bytes verified flowing
through listener → chip `read()` in order); the failure is purely
chip→Z80 IRQ delivery.

**Why this is the blocker:** Option P bring-up cannot end-to-end PASS
until this is fixed.  cpnos-rom has to call `enable_interrupts()` for
`isr_pio_par` to fire on incoming bytes; with the regression in
place, EI is never reached.

**Architectural cause (narrowed 2026-04-26 in a comment on #6):**
Z80-PIO is the only multi-channel-callback chip in MAME *without*
per-channel `device_t` subdevices.  Z80-SIO/DART, Z80-SCC, scnxx562
DUART, upd765a/wd17xx all expose multiple slots successfully because
each channel/drive is its own MAME device, and each slot binds to
that subdevice.  Z80-PIO has all seven port-side callbacks (in_pa,
out_pa, out_ardy, in_pb, out_pb, out_brdy, out_int) as flat members
of one `z80pio_device`; per-port state lives in an internal
`pio_port` struct that isn't a `device_t`.  Two slot wrappers binding
on the same flat device hits an unexercised path.

**Two-channels vs two-slots (the precise framing, also in a #6 comment):**
- Two channels on a Z80-PIO are *intended, supported, well-tested* —
  >20 drivers wire both ports directly (xerox820/kbpio, attache,
  altos5, jupace, tiki100, …).  The chip model has per-port state
  structs and distinct callback bindings; this has always worked.
- Two channels each routed through a *MAME slot wrapper* on the same
  Z80-PIO is the unexercised case.  Z80-PIO predates
  `device_slot_interface` / `device_single_card_slot_interface` by
  years; when the chip author wrote it, "wire either port to a
  peripheral" assumed direct/early-bound wiring (a function,
  output_latch_device, centronics).
- The slot mechanism itself was developed against chips that already
  had per-channel device_t subdevices (z80sio_channel, z80scc_channel,
  floppy_connector).  Composes naturally with per-channel start order.
- The missing case is the unswept seam between a flat pre-slot chip
  model and a slot mechanism validated only against per-channel-
  subdevice chips.  Einstein's "PIO-A direct + PIO-B userport slot"
  exercises one-slot-per-Z80-PIO and works; RC702 is the first
  driver to push to two-slots-per-Z80-PIO.

**History (verified from upstream mamedev/mame, posted on #6):**
z80pio.cpp present at MAME 0.121 checkin 2007-12-17 (predates modern
slot infra).  device_slot_interface added to MAME 2011-05-04 by
Miodrag Milanovic.  Einstein userport slot added 2017-10-31 by Dirk
Best (908529aa32) — first slot wrapper around any Z80-PIO port in
MAME.  The pre-2017 Einstein had Port A and Port B both direct to
centronics (printer-only).  The 2017 commit kept Port A direct
(centronics is a fixed real-hardware peripheral) and promoted Port B
to a userport slot (because the physical user port on the Einstein
is, by definition, runtime-pluggable).  So "one slot per Z80-PIO" in
Einstein is **incidental, not deliberate** — nobody decided to cap
it.  RC702 is the first machine where BOTH PIO ports are slot-shaped
on real hardware (J3 + J4), so first driver to push two slots
through one PIO.

**Verified comprehensive (also on #6):** grepped all of src/mame for
Z80-PIO port callbacks bound to peripheral devices.  Only three
drivers do this beyond simple sinks like output_latch_device:
emusys/emu2.cpp (chip-to-chip), tecmo/senjyo.cpp (generic_latch_8),
tatung/einstein.cpp (einstein_userport_device).  Only einstein's
target is a device_slot_interface-derived slot.  Centronics is a
slot but is always bound behind an output_latch_device intermediary,
not directly to a PIO port — so it doesn't count.  In all of MAME
history, exactly TWO slot wrappers have ever existed around a Z80-PIO
port: Einstein (2017, Port B only) and RC702 (2026, both ports).
The userport slot design was NOT pre-existing in MESS; it was added
in unified MAME 2 years after the 2015 MESS-into-MAME merge, when
slot infrastructure was already 6 years old.

**How to apply:**
- When resuming Option P / cpnet-fast-link work, check the issue
  first: `gh issue view 6 --repo ravn/mame --json state,comments`.
  If still open, do not waste time on harness-side bring-up — the
  blocker is upstream of every Z80-side test.
- Two fix paths exist; minimum-disruption is path 2:
  1. Refactor z80pio to introduce `z80pio_channel` subdevices —
     architecturally correct, big surface area, touches a widely-used
     MAME chip model.
  2. Wire PIO-A keyboard directly in rc702.cpp (no slot wrapper),
     keep PIO-B as a slot for cpnet_bridge.  Matches Einstein
     topology, localized to `rc702.cpp` + small edit to
     `bus/rc702/pio_port/`.  Loses the "PIO-A keyboard as runtime
     slot card" property (never actually exercised by users).
- The local mirror of the issue body is at
  `rc700-gensmedet/docs/mame-rc702-piob-slot-regression.md`.  Keep it
  in sync if the issue body is edited.
- The design doc `rc700-gensmedet/docs/cpnet_fast_link.md` has a
  "Blocker (2026-04-26)" callout pointing at #6; remove or update
  that callout once the issue is closed.
- When the issue is resolved, the harness in
  `rc700-gensmedet/tests/cpnet_bridge/` should run end-to-end without
  any further Z80-side changes (the harness was hardened in commit
  `db57751`; the simpler tap.lua is in `3b6d8b8`).

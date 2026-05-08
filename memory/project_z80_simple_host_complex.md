---
name: Z80 simple, host complex, hardware-compatible
description: Optimise for the smallest/fastest slave-side Z80 code; push protocol complexity to the host; must still run on physical RC702 hardware (not MAME-only)
type: project
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
User-stated project goal (2026-04-28): **make the Z80 (CP/NOS slave)
side as fast and as small as possible, delegating as much complexity
as possible to the host side, while remaining compatible with physical
RC702 hardware.**

**How to apply:**

- When choosing between transport variants, prefer the one with less
  Z80 work even if it requires more host-side Python.  Concrete
  example: PIO-PROXY (slave does raw OTIR/INIR, host adds SNIOS
  envelope) is preferred over PIO-IRQ direct (slave does full
  envelope + IRQ ring) on this axis — slave side is shorter and
  faster.
- Don't propose slave-side compute that could happen host-side
  instead (e.g., a checksum that validates wire integrity AND a
  data property — let the host validate the data; have the slave
  only do what the wire/protocol forces it to).
- When designing a new feature, picture it running on a physical
  RC702 with a Pi-Pico-on-J3 acting as host bridge.  If the slave
  side requires anything that doesn't exist in the real PIO chip
  (or in real CP/NOS), that's a non-starter — must work in MAME AND
  on real silicon.
- Memory-map mocks, MAME Lua taps, install_write_tap-style probes,
  etc., are MAME-only conveniences and DO NOT count as a working
  feature for the slave's runtime path.  Use them for diagnostics
  only.

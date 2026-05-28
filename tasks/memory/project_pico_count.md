---
name: User has two Pi Picos available for RC702 work
description: User owns two Pi Picos as of 2026-04-25 — one running the cbl923 keyboard rig, one available for the J3 CP/NET cable bridge
type: project
originSessionId: b07ba379-19bf-4244-a50b-7118b0bab69d
---
The user has two physical Pi Pico boards on hand for RC702 host-side work:

- **Pico #1** — running the existing `ravn/cbl923` keyboard rig (MicroPython `ascii.py`, GP0-7 = J4 PA0-7, GP14 = J4 ASTB, GP25 = LED). Stays on J4 / PIO-A as a development-time keyboard-injection fixture for automated testing.
- **Pico #2** — currently unused. Earmarked as the J3 / PIO-B CP/NET cable bridge under the Option P design (`docs/cpnet_fast_link.md`). Will run Pico-SDK C firmware when the bring-up phase begins.

**Why:** stated by user 2026-04-25 in response to "two Picos vs one shared Pico" question for Option P.

**How to apply:**
- Don't suggest buying additional Picos for the design.
- Don't suggest repurposing Pico #1 for the J3 role — it stays on cbl923. Pico #2 is available for new firmware.
- Both Picos plug into the same host (Mac during dev, Pi 4B in production); both expose USB-CDC endpoints; firmware is independent.
- This still leaves the J3 cable, 9 series resistors, and Pi 4B (or 3B) as the remaining hardware acquisitions before bring-up can start. The Pi is the load-bearing missing item per the broader fast-link memory.

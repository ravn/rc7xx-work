---
name: Run MAME at full speed in tests
description: MAME invocations during automated testing must include -nothrottle so emulation runs as fast as the host can drive it
type: feedback
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
When launching MAME for any automated test (boot probe, cpnet-smoke,
fdc-acceptance, cpnos-mame, etc.), include `-nothrottle` in the command
line.  This removes the real-time governor and lets MAME run at the
host's max throughput (typically 5x–10x real Z80 speed on this Mac).

**Why:** explicit user request 2026-04-25.  Smoke tests that simulate
many seconds of CCP/CP/NET activity become wall-clock-painful without
this flag; throttled runs also masked some ordering issues during the
session.

**How to apply:**
- Always include `-nothrottle` alongside `-skip_gameinfo` and the
  `-rs232*/-bitb*` flags in any MAME launch script or Makefile target
  that runs unattended.
- Don't add it to interactive launches (those that drop the user into
  the MAME window) unless the user asks.
- The `Average speed:` line in MAME's exit output is the verification:
  expect a multi-hundred-percent figure for unthrottled tests.

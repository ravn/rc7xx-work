---
name: MAME must always run windowed with a timeout
description: HARD — every MAME launch needs -window AND a finite -seconds_to_run. Never fullscreen, never seconds_to_run 0 / no timeout. User cannot stop a runaway fullscreen instance.
metadata:
  type: feedback
---
**HARD RULE: every MAME invocation must include BOTH `-window` AND a finite
`-seconds_to_run N` (N > 0).**

Never launch MAME:
- in fullscreen (i.e. without `-window`), or
- without a timeout, i.e. `-seconds_to_run 0` (which runs indefinitely) or
  omitting the flag entirely.

**Why:** a fullscreen MAME with no timeout takes over the display and the user
cannot stop it. Reported 2026-07-31 after a background `regnecentralend rc703
... -verbose -seconds_to_run 0` (no `-window`, timeout 0) launched fullscreen
forever.

**How to apply:**
- Always pass `-window -nothrottle -skip_gameinfo -seconds_to_run N` (N a few
  seconds to a couple of minutes, matched to what is being observed).
- This applies to quick one-off checks too (validate/verbose/listxml runs that
  actually start the machine) — not just the scripted boot tests, which already
  set `-window` + a timeout via `mame_boot_test.lua`.
- For info that does not need to start the machine, prefer non-emulating
  commands: `-validate`, `-listxml`, `-verifyroms` (these do not open a window).

---
name: feedback_mame_windowed_only
description: "Always launch MAME in windowed mode (-window), never fullscreen"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 90439589-e8b2-4e34-94a8-798e56731341
---

Always launch MAME in windowed mode: pass `-window` on every MAME invocation. Never run fullscreen.

**Why:** User directive (2026-05-25). Fullscreen MAME disrupts the user's desktop during unattended/attended RC702 test runs.

**How to apply:** Add `-window` to every `mame` command line (alongside `-nothrottle` for unattended runs per [[feedback_mame_full_speed]] and OSD=sdl per [[feedback_mame_osd_sdl]]). Applies to interactive launches, `-aviwrite` captures, and the `scripts/mame_capture.sh` pipeline.

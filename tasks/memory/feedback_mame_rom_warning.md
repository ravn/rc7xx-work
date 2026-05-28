---
name: MAME ROM warning is a bug
description: If MAME shows "system may be broken" ROM warning screen, treat it as a bug and fix it before proceeding
type: feedback
---

If MAME shows the "WRONG CHECKSUMS" / "system may be broken" warning screen when starting, treat this as a bug that must be fixed. Do not just press a key to dismiss it.

**Why:** The warning blocks automated testing (lua scripts can't dismiss it) and wastes time in interactive use. The clang PROM has a different CRC than the original ROA375, so the warning appears every time unless the MAME driver is updated.

**How to apply:** Mark the ROM as `BAD_DUMP` in the MAME driver source (`rc702.cpp`), rebuild MAME with `OSD=sdl USE_SDL=1 SUBTARGET=regnecentralen`, and verify the warning no longer appears. If the warning shows, do not proceed with testing — fix it first.

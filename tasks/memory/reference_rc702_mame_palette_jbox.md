---
name: RC702 MAME palette = jbox/RC752 amber (dark brown bg + soft amber fg), not bright orange
description: ravn/mame-rc702-rc759-rc750 rc702 palette+layout colours sampled from jbox; the authentic RC752 look — don't revert to the old saturated orange
type: reference
metadata:
  type: reference
---

**ravn/mame-rc702-rc759-rc750 rc702 display colours (fixed 2026-07-26, commit ffca0712).** The
RC752 (NEC JB-1201M(A)) amber monitor look, sampled pixel-exact from the jbox
(Michael Ringgard) RC702 emulator:

- **pen 0 (background): `rgb(0x4F, 0x25, 0x09)`** = (79, 37, 9) dark warm-brown.
- **pen 1 (foreground): `rgb(0xC4, 0x9B, 0x47)`** = (196, 155, 71) soft amber.

The earlier values were a bright saturated orange — pen 0 `rgb(0xC0,0x60,0x00)`,
pen 1 `rgb(0xFF,0xB4,0x00)` — which lit the whole screen too hot (background
glowed orange instead of a dark monitor). Do NOT revert to those.

Two places, both must match (both changed in ffca0712):
- `src/mame/regnecentralen/rc702.cpp` `rc702_palette()` (the two `set_pen_color`).
- `src/mame/layout/rc702.lay` `<element name="bg">` rect `<color>` (fractions:
  red=0.3098 green=0.1451 blue=0.0353 for the border/background).

Rebuild: `make SUBTARGET=regnecentralen DEBUG=1
SOURCES=src/mame/regnecentralen/rc702.cpp TOOLS=1 SYMLEVEL=3 SYMBOLS=1 OSD=sdl
-j10` (the .lay is compiled into the binary, so a source-only change still needs
this rebuild). Verified by re-snapshotting the clock demo. Reference sampling:
jbox screenshot top-3 colours via PIL Counter (bg 79/37/9, fg 196/155/71, plus a
blend). Doc: `rc700-gensmedet/docs/MAME_RC702.md`.

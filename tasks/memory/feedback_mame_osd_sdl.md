---
name: MAME OSD=sdl build flag
description: MAME must be built with OSD=sdl (not sdl3). Full command in docs/MAME_RC702.md.
type: feedback
originSessionId: de74af41-d539-4734-b64d-c625ca2729f8
---
MAME must be built with `OSD=sdl` — the default `OSD=sdl3` fails because SDL3 is not installed.

**Why:** SDL3 headers are missing on this machine. SDL2 is installed (not via brew). Without `OSD=sdl`, build fails with `'SDL3/SDL.h' file not found`.

**How to apply:** Always check `rc700-gensmedet/docs/MAME_RC702.md` for the full MAME build command before building. The canonical command is:
```
make SUBTARGET=regnecentralen DEBUG=1 SOURCES=src/mame/regnecentralen/rc702.cpp TOOLS=1 SYMLEVEL=3 SYMBOLS=1 OSD=sdl -j10
```

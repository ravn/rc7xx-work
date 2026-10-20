---
name: MAME OSD build flag (SDL3 default)
description: MAME defaults to OSD=sdl3 on macOS using SDL3 in ~/Library/Frameworks. Full command in docs/MAME_RC702.md.
type: feedback
originSessionId: de74af41-d539-4734-b64d-c625ca2729f8
---
MAME builds with `OSD=sdl3` by default on macOS. SDL3 is installed as `SDL3.xcframework` under `~/Library/Frameworks/SDL3.xcframework/macos-arm64_x86_64/`.

**Why:** Upstream MAME on macOS defaults to `OSD := sdl3`. `mame/scripts/src/osd/sdl3.lua` auto-detects `~/Library/Frameworks` first before system `/Library/Frameworks`.

**How to apply:** Check `rc700-gensmedet/docs/MAME_RC702.md` for the full MAME build command. Canonical command:
```
make SUBTARGET=regnecentralen DEBUG=1 SOURCES=src/mame/regnecentralen/rc702.cpp TOOLS=1 SYMLEVEL=3 SYMBOLS=1 -j10
```

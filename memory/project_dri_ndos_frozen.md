---
name: DRI NDOS sources — no upstream, free to modify
description: cpnet-z80 DRI NDOS/BDOS/BIOS sources have no upstream; we can and should modify them when integration demands it
type: project
originSessionId: b07ba379-19bf-4244-a50b-7118b0bab69d
---
The DRI CP/NET / CP/NOS assembly sources in `/Users/ravn/z80/cpnet-z80/dist/src/` (cpnos.asm, cpndos.asm, cpnios.asm, cpbdos.asm, cpbios.asm, ndos.asm, ccp.asm, cpnetldr.asm) have **no live upstream** — nothing will come back from DRI or durgadas311. Our fork is the endpoint.

**Why:** User clarified 2026-04-21: "we can change NDOS sources (and we probably must) but there is no upstream to keep in sync with." Original framing in this memory ("accommodate quirks permanently") was wrong — the freeze means we own it, not that we must leave it alone.

**How to apply:**
- Treat these sources as ours. Edit them when integration (e.g. running against z80pack MP/M II) requires it; fixing the `ndosrl+0x300` layout TODO or any other DRI quirk is fair game.
- No merge-conflict risk, no "don't diverge from upstream" constraint — the only cost of a change is the work itself.
- Prefer fixing the asm source over piling workarounds into our translator, linker script, or C glue when the source fix is cleaner.
- `cpnos-rom/cpnos-build/dri2gnu.pl` can still hardcode special cases, but if the same edit in the `.asm` is cleaner, do it there.
- Integration architecture (Path B vs Path 5 etc.) is not locked by an upstream — revisit freely.

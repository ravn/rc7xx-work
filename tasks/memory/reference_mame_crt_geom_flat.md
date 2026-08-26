---
name: reference_mame_crt_geom_flat
description: ravn/mame bgfx chain crt-geom-flat = crt-geom with curvature off (flat CRT look) for RC702/RC759 amber; not wired by default
metadata:
  type: reference
---

`ravn/mame` ships `bgfx/chains/crt-geom-flat.json` (commit 7cebd719, master) — a
verbatim copy of MAME's stock `crt-geom` shader with **one** change: the
`curvature` slider default `1.0 -> 0.0`. So it gives the full "real CRT" look
(scanlines, shadow mask/aperture, phosphor glow) but **flat** (no curved-glass
barrel warp), matching the flat amber RC752 monitor of the RC702/RC759.

**It is NOT active by default** — it just sits in `bgfx/chains/` as an available
chain. To actually use it, MAME must run the bgfx renderer with:
`-video bgfx -bgfx_screen_chains crt-geom-flat` (or set `bgfx_screen_chains
crt-geom-flat` in an `.ini`/`cfg`). Headless snapshot runs use `-video none`, so
the shader has no effect there — it is for visual/interactive viewing only.

Related: RC759 82730 amber display + geometry work in [[reference_rc759_i82730_display]].

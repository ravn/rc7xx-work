---
name: feedback_host_no_graphics
description: Some hosts (currently sonnyboy, possibly others) have no graphics available; MAME can't open a window. Use SDL_VIDEODRIVER=offscreen / dummy or xvfb-run. Snapshots + AVI capture still work via the dummy driver. Don't interactively launch MAME on these hosts.
metadata:
  type: feedback
---

**The rule (user-set, 2026-06-06):**

> "When working on sonnyboy, you cannot rely on graphics being
> available, meaning that MAME may not be able to show a window."

This generalizes: any working host might be headless / no X server / no
GPU.  At minimum sonnyboy falls in this category today.  Code paths and
memory entries that assume a visible window need a fallback.

## Affected workflows

* The `make run` / `make mame` targets across the RC700 subprojects --
  they pass `-window` (correct for the mac; not enough on a headless
  host).  See [[feedback_mame_windowed_only]] and the cross-references
  in CLAUDE.md for the project's `mame_capture.sh` pipeline.
* Any direct `mame ... -window` invocation from chat (e.g. one-off
  sanity checks).
* Lua autoboot scripts that drive MAME and rely on
  `manager.machine.video:snapshot()` -- snapshots are FINE on a
  headless host (they go through the same offscreen render path); only
  the WINDOW open fails.

## How to apply on a headless host

Set the SDL video driver to a no-window backend before launching MAME:

```sh
# Option A: no rendering at all (fastest; -snap and -aviwrite still work
# because MAME renders to its own internal buffers, not the SDL window).
SDL_VIDEODRIVER=dummy mame ... -snap -aviwrite ...

# Option B: SDL offscreen (renders to an offscreen surface; useful if a
# Lua script needs the raw pixel buffer via the SDL API).
SDL_VIDEODRIVER=offscreen mame ... -snap -aviwrite ...

# Option C: virtual X server (heaviest, but closest to "real X").
sudo apt install -y xvfb     # one-time
xvfb-run mame ... -window -snap -aviwrite ...
```

For un-attended MAME runs (the bulk of automation work -- snapshot a
boot, drive the keyboard via natkeyboard:post, exit), **Option A**
(`SDL_VIDEODRIVER=dummy`) is the right default.  No window, full
snapshot capability, fastest startup.

## What MAME can NOT do without a window

* Live human interaction (`-noautoboot` then expect to see the screen
  and type at the natkeyboard).
* Use of `-debugger sdl`-style host debugger UIs that depend on SDL
  windows (lldb / gdb attaches via `-gdbstub` are unaffected).

## How to apply when authoring tooling

If you write a Makefile target or shell script that invokes MAME from
chat, branch on the host: keep the macOS-friendly `-window` form, but
prefix with `SDL_VIDEODRIVER=dummy` (or `xvfb-run`) when running on a
headless host.  The cleanest pattern is to honour `MAME_HEADLESS=1` in
the env:

```make
MAME_DRIVER := $(if $(MAME_HEADLESS),SDL_VIDEODRIVER=dummy,)

mame:
	$(MAME_DRIVER) mame ... -window -snap -aviwrite ...
```

Then on sonnyboy: `MAME_HEADLESS=1 make mame`.

Related: [[feedback_mame_windowed_only]] (Mac-side window rule),
[[project_cpnos_mame_prereqs]] (MP/M + clean conn list before MAME),
[[feedback_screenshot_to_verify]] (snapshots still work; in fact more
trustworthy when there's no human to look at a live window),
[[feedback_cross_machine_workflow]] (this rule joins the host-portability
discipline).

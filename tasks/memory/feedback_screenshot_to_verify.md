---
name: Always screenshot to verify display state
description: When testing changes to MAME / RC702 boot, always capture a screenshot before declaring success or inferring init state from logs
type: feedback
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
When verifying that cpnos-rom (or any RC702 guest) has booted in MAME,
**always take a screenshot.**  Do not infer display/init state from
log files, BSS counters, test-script PASS messages, **OR memory dumps
at a presumed display address**.  A test script can return PASS while
the display is black; the screenshot is the authoritative signal that
init_hardware completed and the CRTC is painting.

**Memory dumps at the display address are NOT a substitute for a
screenshot.** What's in RAM at the guessed display base can be:
  - Stale (autoload's framebuffer still holds its banner after the BIOS
    takes over at a different base — burned a session 2026-06-03 around
    this; the lua-harness lesson is in [[feedback_lua_errors_fatal]]);
  - At the wrong base entirely (different PROM / different boot phase /
    CP/M moved it);
  - Not what the i8275 CRTC is actually fetching (the chip's row table
    and DMA-ch2 program determine what paints, not RAM contents alone).
The PNG snapshot is what the user sees and what we are testing for.

**Why:** Restated by the user 2026-04-26 after I declared
"cpnos-netboot PASS" and proceeded to the next step without checking
the actual screen.  The user has emphasised this preference more than
once in the same session — black screen = init incomplete is a real
failure mode that PASS-detecting log scrapers can miss when they look
at the wrong gate (e.g. SIO-B "DONE" marker fires before CRT setup
completes).

**How to apply:**
- After **every** MAME run — including ones that already report a
  textual PASS via display-memory dump — capture a screenshot and
  Read it.  Restated 2026-04-26: "please verify after every mame run
  that the screen was not black."  This applies to normal RC702 boot,
  cpnos-netboot, harness runs, manual one-shots — there is no run
  exempt.
- Use `-snapshot_directory <dir> -seconds_to_run N`, which makes MAME
  auto-write a final-frame PNG, or `manager.machine.video:snapshot()`
  in a Lua autoboot script.  macOS `screencapture` against the MAME
  window and F12 (with `--keep-alive`) also work.
- Inspect the resulting PNG with `Read` so the user (and I) can
  literally see the display state.  If the snapshot dir is empty or
  the only frame is solid black, treat that as a failure regardless
  of what other PASS gates say.
- A black screen does NOT indicate "MAME's CRT renderer can't show
  cpnos-rom output" — proven-working configurations (cpnos-netboot
  with full netboot responder) render the banner and `A>` prompt
  cleanly.  Always-black is therefore always a real init regression.

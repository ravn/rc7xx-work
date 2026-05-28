---
name: Black screen is a fatal error — resolve immediately
description: When a MAME run shows a black screen during cpnos / RC702 work, treat it as the top-priority bug and stop other investigation until it is resolved
type: feedback
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
If a MAME run on the rc702 driver produces a black screen during
cpnos / CP/NET work, that is a **fatal error** — drop whatever else
you were chasing and resolve the black screen first.  Other findings
(TCP byte counts, ISR fire counts, chip register state, port logs)
are meaningless or actively misleading until the screen is
non-black, because cpnos-rom hasn't reached the state those
diagnostics measure.

**Why:** Restated by the user 2026-04-26 after I spent multiple
roundtrips investigating "PIO-B IE=0, IP=1, no brdy_w callbacks"
when the actual root cause was "cpnos-rom isn't booting in this
harness configuration at all" — the chip-level diagnostics were
just measuring a chip that nothing was driving because the guest
was stuck pre-init.  `feedback_screenshot_to_verify` already says
to capture screenshots; this rule says **what to do** when one
comes back black: stop everything else, fix the boot path.

**How to apply:**
- After every MAME run, check the screenshot (existing rule).  If
  it is black: do NOT continue with whatever feature investigation
  was in flight.  Investigate the boot path itself.
- Common boot-path diff causes that produce black screens for the
  rc702 cpnos workflow: missing `-rs232b null_modem -bitb2 ...`,
  wrong netboot port, autoboot_script error, missing PROM, wrong
  PROM (autoload vs cpnos), wrong MAME binary.
- The `cpnos-netboot` Makefile target is the known-good reference
  configuration.  When something else doesn't boot, diff the
  command line against that target.
- Banner check (`feedback_mame_banner`) is a finer-grained version
  of this rule for the autoload PROM phase; the broader rule applies
  to cpnos work too.

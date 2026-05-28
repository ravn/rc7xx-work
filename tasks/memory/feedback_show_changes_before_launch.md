---
name: Show what changed before each MAME launch
description: Before every MAME run, list out the changes since the previous launch — code edits, build state, PROM/disk state, env state — so the user can sanity-check the experiment matches what they expect
type: feedback
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
Before every `regnecentralend` invocation (direct or via `make`),
write a short pre-launch summary describing **what is different**
from the previous launch.  This is in addition to the running
narrative-of-thinking rule (`feedback_show_thinking`); it is a
specific application of it at the moment of running an expensive
test.

What to include:
- Files edited since the last launch (with one-line "what + why").
- Build state: did I rebuild?  Which binary path will run?  Was
  REGENIE used, did the binary timestamp change?
- PROM / disk state: which PROM is in `roms/rc702/roa375.ic66`
  right now (cpnos vs autoload), when was it copied, by what step.
- Test scaffolding: which daemons are about to be spawned, on
  which ports.
- The hypothesis being tested: "I expect this run to ___ because ___".

The goal is for the user to be able to **predict the outcome** from
the summary alone.  If the prediction is wrong, the diagnostic
value of the run is much higher because we can isolate which
assumption was off.

**Why:** Restated by the user 2026-04-26 after a long bisect where
I'd been launching MAME with various combinations of in-flight
edits, stashed code, and toggled #if 0 blocks without surfacing the
exact configuration each run.  The user couldn't tell which run
proved which thing.

**How to apply:**
- Print a short table or bullet list immediately before the Bash
  call that launches MAME (or invokes `make cpnos-netboot`,
  `harness.py`, etc).
- One bullet per category above.  Skip categories that haven't
  changed (don't pad).
- Keep it terse — half a screen max.  The point is auditability
  per launch, not a lecture.
- This applies even on rapid iteration cycles.  If two consecutive
  launches differ by one toggle, say so.

---
name: Bench harness must self-terminate
description: A bench's "test complete" signal must drive MAME exit, not just metric capture; -seconds_to_run timeout is not sufficient
type: feedback
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
When designing a workload-bench harness (cpnos pio-irq-smoke, sio-smoke,
etc.), the "marker observed" event MUST trigger MAME shutdown — typically
via `manager.machine:exit()` from the autoboot Lua tap.  Without that,
MAME sits idle at A> after the workload finishes, and `make` blocks
until `-seconds_to_run` fires (e.g., 20 minutes), even though the test
already passed at second N.

**Why:** User caught this 2026-04-28 ("mame stuck on A> after SUMTEST
printed CPNET OK A314.  Why have you not detected that?").  My Monitor
was watching `[marker]` and `[make-exit]` events, saw the marker, and I
treated that as the run completing — but `make` was still blocked.
I'd been masking the issue by manually killing MAME after each cycle
(`pkill -9 regnecentralend`), which made every "good" run look like the
auto-exit worked.

**How to apply:**
- For any new bench/smoke target, the autoboot Lua should detect the
  finish-signal (port write, screen marker, smoke_inject log line, ...)
  and call `manager.machine:exit()` after a small grace period (~0.5 s
  to flush the trailing A> onto SIO-B).
- The Monitor pattern `[marker] ... → [make-exit] within seconds`
  should be the success criterion.  If `[make-exit]` lags `[marker]`
  by more than the workload-trailing window, the bench is hanging.
- Don't normalise manual `pkill -9` of MAME between iterations — that
  hides a missing auto-exit.

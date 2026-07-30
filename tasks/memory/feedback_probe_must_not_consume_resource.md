---
name: feedback_probe_must_not_consume_resource
description: A health-check/probe must not consume a single-use or single-connection resource the real consumer needs — it can corrupt exactly what it verifies.
metadata:
  type: feedback
---

When adding a startup gate / health probe in front of an expensive test, make
sure the probe does not CONSUME or mutate a single-use resource that the real
consumer then needs.  A probe that grabs the one connection, the one lock, the
one token, etc. can leave the resource in a state the real client can't use —
"the diagnostic corrupts what it diagnoses."

**Why:** concrete case (rc700-gensmedet #119, found 2026-07-06).  `cpnet_ping.py`
was added (eb116e9) as a startup gate before the 4-minute cpnos polypascal-test:
it does a full CP/NET LOGIN round-trip against the mpm-net2 master to prove it
answers.  But the z80pack MP/M master is **single-connection** — the ping
consumed that one connection and left its CP/NET protocol state machine wedged
mid-frame.  MAME's slave was then the *2nd* connection, got ENQ (0x05) instead
of ACK, and hung in `_transport_recv_byte` after its banner, never reaching E>.
The #119 author ran the ping once, saw PASS, and wrongly cleared the master —
missing that the probe itself caused the hang.  Proof: fresh master, ping #1
PASS, ping #2 FAIL.

**How to apply:**
- If a probe must exercise a single-use resource, RESTART/RESET that resource
  after the probe and before the real consumer (the fix here: keep the ping,
  then `_kill-mpm` + `$(START_MPM)` so MAME gets a pristine master).
- Or make the probe truly read-only (don't open the one connection at all).
- When a probe "passes" but the guarded thing still fails identically, suspect
  the probe as the cause — run the probe TWICE against a fresh resource; if the
  2nd attempt fails, the probe is destructive.  Ties into
  [[feedback_verify_process_state_full_enumeration]] and
  [[feedback_dig_deeper_before_parking]].

Full writeup: `rc700-gensmedet/cpnos-in-c/tasks/KNOWN_ISSUE_polypascal_hang_2026-07-04.md`.
Related: the same fix hardened mpm-net2 teardown to kill by saved PID
(`pkill -P $PID`) instead of a broad `pkill -f cpmsim`.  PIO transport still
blocked separately by [[project_ravn_mame_6]] (cpnet_bridge), not this bug.

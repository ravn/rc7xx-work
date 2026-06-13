---
name: feedback-mpm-server-first-fix
description: When the mp/m server (mpm-net2, MP/M XIOS V1.6-NET) behaves unexpectedly under MAME testing, the FIRST diagnostic step is always stop + rebuild + restart + retry. Only after that fails should deeper hypotheses (timing, protocol-state, etc.) be entertained.
metadata:
  type: feedback
---

When mpm-net2 (z80pack's CP/NET host, MP/M XIOS V1.6-NET) behaves unexpectedly during MAME-side CP/NET testing — stops responding, returns garbage, refuses connections, sends bytes out of expected order, etc. — the first fix is:

1. Stop mpm-net2 (`make _kill-mpm` in cpnos-in-c, or kill the screen session).
2. Rebuild it (`cd z80pack/cpmsim && make clean && make` or whatever the actual build command is — check the local Makefile).
3. Restart it (`screen -dmS mpm ./mpm-net2`).
4. Re-run the failing test.

ONLY after that cycle fails to fix the symptom should deeper hypotheses (timing, protocol-state machine, TCP buffering, wall-clock vs sim-clock skew) be entertained.

**Why:** mpm-net2 carries persistent state across runs (disk images, MP/M XIOS internal buffers, possibly socket state from prior partial sessions). When something behaves "as if mpm-net2 is wrong," the cause is overwhelmingly persistent-state contamination, not a fundamental protocol bug. A clean rebuild + restart costs ~30 sec and rules out 90% of mpm-net2-anomaly hypotheses immediately. Skipping that step and jumping to "must be a CP/NET state-machine race" or "mpm-net2 must be wall-clock-sensitive" is premature theorizing.

**How to apply:** When investigating ANY test failure where the symptom is "mpm-net2 stopped responding," "mpm-net2 sent wrong bytes," or "the master is silent" — before forming a theory, before reading mpm-net2 source, before adding instrumentation — do the stop-rebuild-restart cycle first. After it succeeds: the test now passes? You're done. After it fails: **ASK the user** before theorizing or diving deeper. Don't burn an hour on hypotheses; the user often has context (recent z80pack changes, known mpm-net2 quirks, host-specific oddities) that resolves the issue in one exchange.

Related:
- [[feedback_polypascal_stage1_flake]] — narrower version: stage-1/2 flake = MP/M daemon state, retry with `make _kill-mpm; sleep 5-8`. This rule generalizes that to "any unexpected mp/m server behavior" AND adds the rebuild step.
- [[feedback_session_start_kill_daemons]] — kill-on-session-start discipline (related, different trigger).
- [[feedback_dig_deeper_before_parking]] — the inverse: *real* bugs that aren't restart-fixable deserve the investigation budget.

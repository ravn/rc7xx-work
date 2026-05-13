---
name: cpnos-polypascal-test stage-1 flake = MP/M daemon state
description: When cpnos-polypascal-test fails at "stage 1 (deadline 30s): wait for E> on SIO-B" with no E> appearing, the most common cause is leftover MP/M daemon state from a prior run that the Makefile's _kill-mpm didn't fully clean.  Force-kill and retry before suspecting codegen.
type: feedback
---

**Rule:** When `make cpnos-polypascal-test` reports
`FAIL: timeout waiting for E> boot prompt` at stage 1, before
investigating codegen, do:

```bash
make _kill-mpm
sleep 2
make COMPILER=clang TRANSPORT=<...> cpnos-polypascal-test
```

If the retry PASSES, the failure was MP/M state — not your change.

**Why:**
- The test depends on z80pack mpm-net2 being freshly started and
  serving CP/NET on :4002.
- The Makefile's `_kill-mpm` target tries to terminate the screen
  session and the cpmsim process, but per the comments at
  `Makefile:902-909` "actually free at the end so callers get a
  hard error if cleanup fails," cleanup sometimes leaves stragglers.
- Symptoms of stuck MP/M: port 4002 closed but a cpmsim or screen
  process still alive in the background; the next test run's
  `screen -dmS mpm ./mpm-net2` succeeds but the daemon doesn't
  actually serve.
- Distinct from a real codegen regression: if codegen breaks
  cpnos boot, the failure typically happens at the `E>` stage
  with NO subsequent output and the cpnos slave's banner missing
  from `/tmp/cpnos_siob.raw` — but the SAME failure mode also
  occurs from MP/M state issues.

**How to apply:**
- Always retry once with explicit `_kill-mpm` before drawing
  conclusions about a stage-1 fail.
- If the retry also fails AND z80-utils test-runner passes, then
  suspect codegen.  If both lit and test-runner are green but
  polypascal fails after _kill-mpm + retry, escalate to actual
  binary inspection (cmp against a known-good build).

**Symptom this rule catches:**
First observed: session 65 (2026-05-13), #149 ravn/llvm-z80
i16 != -1 fold work.  Polypascal-test failed at stage 1 with
multiple retries; I started bisecting the codegen change.
After `make _kill-mpm; sleep 2; retry`, the test passed
immediately — the codegen change was fine all along.

**Verification short-cut when in doubt:**
- `nc -z 127.0.0.1 4002` while polypascal-test is mid-flight.
  If port 4002 is "closed" during stage 1 but a cpmsim process
  exists, daemon is half-up.
- `pgrep -af cpmsim` after the test exits should return nothing.
  If it does, leftover state is likely.

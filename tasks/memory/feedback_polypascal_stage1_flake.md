---
name: cpnos-polypascal-test stage-1 AND stage-2 flake = MP/M daemon state
description: When cpnos-polypascal-test times out at stage 1 (wait for E> on SIO-B) OR stage 2 (wait for initial PPAS '>>' prompt), the most common cause is leftover MP/M daemon state from a prior run.  Force-kill with longer sleep (5-8s) and retry before suspecting codegen.  Confirmed for stage 1 (#149) AND stage 2 (#152).
type: feedback
originSessionId: 90f5a17f-7f0a-47da-8820-66f3b9c19063
---
**Rule:** When `make cpnos-polypascal-test` reports
`FAIL: timeout waiting for E> boot prompt` (stage 1) OR
`FAIL: timeout waiting for PPAS >> prompt (initial)` (stage 2),
before investigating codegen, do:

```bash
make _kill-mpm
sleep 5-8    # 2s sometimes isn't enough; saw stage-2 timeouts at 3s
make COMPILER=clang TRANSPORT=<...> cpnos-polypascal-test
```

If the retry PASSES, the failure was MP/M state — not your change.

Stage 2 has the same root cause as stage 1: MP/M is up enough
that E> appears, but the network/file-system layer for the load
command (`L PRIMES`) is in a partial-state — looks identical to
a real CP/NOS↔MP/M regression but resolves on a clean restart.

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
- First observed stage 1: session 65 (2026-05-13), #149 i16 != -1
  fold work.  After `make _kill-mpm; sleep 2; retry`, the test
  passed immediately — the codegen change was fine all along.
- Extended to stage 2: session 68 (2026-05-13), #152 SET/RES via
  `LD A,(HL)`.  Polypascal failed twice in a row at different
  stages (1 then 2).  `cmp -l` against baseline payload showed
  0 byte differences — confirmed MP/M state, not codegen.  After
  `make _kill-mpm; sleep 8; retry`, both pio-irq and sio cells
  PASS.  This is why the longer sleep is now the default
  recommendation.

**Verification short-cut when in doubt:**
- `nc -z 127.0.0.1 4002` while polypascal-test is mid-flight.
  If port 4002 is "closed" during stage 1 but a cpmsim process
  exists, daemon is half-up.
- `pgrep -af cpmsim` after the test exits should return nothing.
  If it does, leftover state is likely.

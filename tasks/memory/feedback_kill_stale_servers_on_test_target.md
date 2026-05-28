---
name: Test targets that spawn daemons should auto-cleanup leftover instances, not error out
description: Hard rule — when a test target depends on a port being free (mpm-net2 :4002), check + kill leftover instances automatically rather than aborting and forcing the operator to debug
type: feedback
originSessionId: de6f9865-d9ee-4776-abd2-c579088d6b91
---
HARD RULE — test/bench targets that spawn long-running daemons
(`mpm-net2`, `MAME`, netboot servers) MUST auto-cleanup leftover
instances at the start of the target.  Aborting with "port already
bound — kill the squatter" forces every test invocation to manually
reset state, which costs time and breaks unattended runs.

**Hit this 2026-05-07** during polypascal-test runs: each abort cycle
(stale process from prior failed run still holding :4002) cost ~20s
of operator-driven `kill PID; retry`.  Three iterations stacked up
before the test actually started.

The Makefile recipe already had:
```make
@if lsof -nP -iTCP:4002 -sTCP:LISTEN 2>/dev/null | grep -q .; then \
    echo "ERROR: port 4002 already bound -- kill the squatter first:"; \
    lsof -nP -iTCP:4002 -sTCP:LISTEN; \
    exit 1; \
fi
```

This is "fail loud" but for a port that the SAME target spawned in
a previous run, the right behavior is "fail quiet, kill it, proceed".

**How to apply:**
- For ports that are uniquely associated with one daemon we own
  (mpm-net2 on :4002, our own netboot server, etc.), the test
  target should: detect, identify, kill (with `BYE` first per
  `feedback_mpm_bye_shutdown.md` if it's mpm-net2), wait, retry.
- Only fail if the daemon holding the port is not one we recognize
  (different command name, different PID lineage).
- Memory `feedback_port4002_check.md` ("Abort if anything listens
  on :4002 before launching MAME") was the original rationale —
  but that rule applies when the SQUATTER might be a different
  service.  When the squatter is provably our own stale process,
  cleaning it up is safer than aborting.

**Don't conflict with:** `feedback_mpm_bye_shutdown.md` (use BYE
not kill -9) — auto-cleanup should still try BYE first; only fall
back to SIGTERM if BYE doesn't release the port within a few
seconds.

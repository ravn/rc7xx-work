---
name: session-start-kill-daemons
description: "HARD — at the start of every fresh session that will run polypascal-tests, MAME boots, or any RC702 emulation, proactively kill leftover cpmsim/mpm-net2 daemons and verify port 4002 is free BEFORE the first test run."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6bb2377c-77ab-4014-8339-b92776bcffc5
---

At the start of every fresh session that will exercise RC702 emulation
(MAME boots, polypascal-tests, CP/NET smoke tests), run an explicit
cleanup pass BEFORE the first test:

```sh
make -C cpnos-in-c _kill-mpm
sleep 8
nc -z 127.0.0.1 4002 && echo "STALE: port 4002 still bound" && exit 1
pgrep -af cpmsim && echo "STALE: cpmsim still running"
```

**Why:** sessions don't have shared memory of previous-session state.
cpmsim/mpm-net2 from a prior session may still be running with stale
MP/M filesystem state, stuck at a particular slave-connection
handshake, or holding port 4002.  The first test of the new session
inherits that state and fails in confusing ways -- typically
polypascal-test stage 1 or 2 timeout, masquerading as a code-gen
regression.

This generalises [[feedback-polypascal-stage1-flake]] from "retry
after failure" to "clean up BEFORE first run, so the first run is
the authoritative one."

**How to apply:** before running the FIRST `make cpnos-polypascal-test`,
`bash cpnet/polypascal_pio_test.sh`, or any MAME -bitb3 connection
in a fresh session, do the cleanup above.  Also do it between
COMPILER-switches (clang -> sdcc or vice versa) -- mpm-net2's
internal CP/NET state can be tuned to the previous slave's
handshake-byte cadence and reject a different slave's frames.

Diagnostic for stuck state:
  * `tail -10 /tmp/cpnos_siob.raw` showing `H>PPAS` followed by
    no further output for >60s = stuck PPAS load over CP/NET.
    Almost always master-side state, not slave-side codegen.
  * `nc -z 127.0.0.1 4002 && echo BOUND` = something already on
    the port; kill before starting your fresh mpm-net2.

Re-violated 2026-05-20 (this session): three consecutive clang
polypascal-pio-tests failed at stage 1 timeout immediately after
a passing SDCC run, before `_kill-mpm` was applied between them.
The fourth test (after explicit `_kill-mpm; sleep 8`) passed.
SDCC fix was suspected; was actually mpm-net2 state.

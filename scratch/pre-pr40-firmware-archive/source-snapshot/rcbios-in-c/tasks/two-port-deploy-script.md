# Two-port deploy script: SIO-B console + SIO-A HEX

## Current state

`deploy.sh` still uses the single-port flow: SIO-A is console, then `STAT
CON:=CRT:` frees SIO-A for `PIP RDR:` to receive HEX, then restore. This
has blind spots — you can't see console output while HEX is streaming.

The session-17 work proved the two-port flow works:
- Console on SIO-B (via daemon + ENQ probe)
- HEX on SIO-A (default RDR: routing, no STAT dance)
- Used inline in shell during development — not scripted yet

## What to build

Replace `deploy.sh` (or add alternative `deploy_two_port.sh`) that:

1. Starts `siob_daemon.py` on ttyUSB1 if not already running
2. Builds BIOS + generates HEX (unchanged)
3. If cold-booted: waits for ENQ probe, daemon responds, console becomes
   SIO-B. If already running: assumes SIO-B console is active.
4. Drives deploy through SIO-B console FIFO:
   - `PIP CPM56.HEX=RDR:` on SIO-B
   - Stream HEX data on SIO-A in parallel
   - `MLOAD`, verify, `SYSGEN` on SIO-B — output visible throughout
5. No `STAT CON:=CRT:` needed — console never moves

## Existing building blocks in repo

- `/tmp/siob_daemon.py` — host-side console daemon (rebuild from session
  notes, not in repo yet; worth committing)
- The inline Python in session 17 commit messages shows the full flow
- `mk_cpm56.py` — HEX generation (unchanged)

## Blockers

- [ ] `siob_daemon.py` needs to be committed to the repo (currently
      recreated ad-hoc in `/tmp/`)
- [ ] Decide: keep `deploy.sh` as-is for systems without SIO-B console, or
      make deploy auto-detect which mode to use

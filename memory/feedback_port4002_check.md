---
name: Check port 4002 before MAME
description: Always verify TCP:4002 is free before launching MAME for CP/NET tests
type: feedback
originSessionId: b07ba379-19bf-4244-a50b-7118b0bab69d
---
Before starting MAME for any CP/NET test, verify nothing is already
listening on TCP port 4002 (`lsof -nP -iTCP:4002 -sTCP:LISTEN`).  If
something is, abort and surface the offender — do not proceed.

**Why:** A stray `netboot_server.py` (Python mock CP/NET server) left
over from manual testing once intercepted MAME's netboot on :4002
and produced plausible-looking PASS results for days of work before
discovery.  See Phase 17 in `rc700-gensmedet/tasks/timeline.md`.

**How to apply:** Wire the check into any make target that launches
MAME against a CP/NET server; also run it manually before any
ad-hoc MAME invocation that uses `-bitb1 socket.127.0.0.1:4002`.

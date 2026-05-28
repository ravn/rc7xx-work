---
name: MP/M shutdown via BYE
description: Use `BYE` from the MP/M console to shut down z80pack mpm-net2 cleanly instead of kill/screen-quit
type: feedback
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
When stopping a running `z80pack/cpmsim/mpm-net2` instance (the master CP/NET
server on :4002), the clean path is to type `BYE` on the MP/M console — it
exits MP/M, which terminates `cpmsim`, which releases :4002 and lets the
`screen` session die normally.

**Why:** prior runs killed the cpmsim PID directly and orphaned its `screen`
parent (`87700 login`, `87703 sh`) that had to be hunted down separately;
sometimes the TCP port stayed bound for a few seconds after `kill`. `BYE`
performs the BDOS-side teardown so the host wrapper exits in order.

**How to apply:** when restarting MP/M for a fresh smoke / boot test, prefer
`screen -S mpm -X stuff 'BYE\n'` over `screen -S mpm -X quit` or `kill`.
Fall back to `kill` only if BYE doesn't terminate (e.g., MP/M wedged before
CCP came up).

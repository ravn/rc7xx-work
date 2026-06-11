---
name: cpnet-12-only
description: This project uses CP/NET 1.2 only — never later CP/NET protocol revisions. Concrete consequence: BDOS-105 (Get Date & Time) is NOT a CP/NET-forwardable function under 1.2. Upstream ndos3.asm:504 (`db 0 ; 105 - GET DATE & TIME - can't support here, use SEND NW MESG`) is correct, not a gap. Time-from-master goes via the BDOS-66 (NSEND) / BDOS-67 (NRECV) pair with the FN-105 vendor extension wire frame — exactly what `cpnet/todget/todget.c` does. Any "forward BDOS-105 natively" idea belongs to a hypothetical later-CP/NET track and is out of scope here.
metadata:
  type: feedback
---

**Rule:** assume CP/NET **1.2** semantics for every protocol-level
decision. Don't reach for features specified in later CP/NET revisions
even if they look like they'd fit.

**Why:** session 2026-06-11 nearly went down a track of "patch
upstream ndos3.asm to dispatch BDOS-105 to a CP/NET-level forward
function." User stopped it with: *"You can only use CPNET 1.2 not
later."* BDOS-105 is a CP/M 3 / MP/M II native BDOS call; CP/NET 1.2
predates BDOS-105 entirely. The line `db 0 ; 105 - GET DATE & TIME -
can't support here, use SEND NW MESG` at `cpnet-z80/src/ndos3.asm:504`
is therefore correct CP/NET-1.2 behavior, not an oversight to "fix".

**How to apply:**

1. Before suggesting "let's add CP/NET function N" or "let's intercept
   BDOS-X in NDOS", check whether the function/intercept exists in
   CP/NET 1.2. If it's a CP/M-3/MP/M-II-era native BDOS extension
   (TOD, password, programmable retcode, file-date), it can't be
   forwarded via CP/NET 1.2 — only carried as vendor-extension
   payload over BDOS-66/67.
2. Specifically for getting wall-clock time from the master: callers
   open-code an FN-105 message frame and send it via NSEND/NRECV
   (BDOS-66/67), the way `cpnet/todget/todget.c` does. Do NOT propose
   "let NDOS handle BDOS-105 transparently" — that's a later-CP/NET
   construct, out of scope.
3. The CP/NET 1.2 reference is durgadas311/cpnet-z80 (tracked
   submodule at `cpnet-z80/`). Project-side patches go in
   `rc700-gensmedet/cpnet/mpm-server/` (master side; see
   [[never-push-or-merge-upstream-remotes]] for the upstream-vs-fork
   rule); slave side never patches NDOS3 because the protocol gap is
   real, not a defect.
4. If a future task seems to require a later-CP/NET feature, surface
   that constraint explicitly to the user before designing around it —
   they may either approve a controlled deviation or redesign the
   feature to fit 1.2.

Related: [[never-push-or-merge-upstream-remotes]],
[[mpm-sys-baked-via-gensys]].

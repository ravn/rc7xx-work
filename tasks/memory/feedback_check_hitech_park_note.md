---
name: feedback-check-hitech-park-note
description: "before proposing to add HiTech as a third compiler in rc700-gensmedet, read the in-repo parking note first"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d06c9673-ee08-48ae-b682-83a2ba6bbc45
---

Before proposing to add HiTech C (either V3.09 freeware at
`ghcr.io/ravn/hitech` OR V4.11 cross-compiler at `ravn/hitech-v411`)
as a third compiler for any of cpnos-rom / rcbios-in-c / autoload-in-c,
**read `rc700-gensmedet/tasks/hitech-shortcomings-report.md` first**.
That report covers both distributions; the older
`hitech-port-parked.md` is V3.09-only and superseded.

**Why:** A full investigation in May 2026 parked the port. The
compiler itself works (4 real bugs were found and fixed in
`ravn/hitech` during that investigation, and the published image
now passes its full 11-cell suite), but HiTech has no
register-passing calling convention and no flag/pragma to enable
one — its codegen is fixed at 1989-stack-args. Originally framed
as "a Z80 codegen reference for clang to aspire to," that goal is
unreachable through HiTech because clang with `sdcccall(1)` +
`z80_preserves_regs` will beat HiTech on byte count for any
register-pressure-sensitive code (session 58 demonstrated this with
36 B saved on `xport_send_byte` callers).

**How to apply:** the parking note has the full reasoning, the
ravn/hitech issue references (#1-#5), the source-language
adaptation cost estimate, and resume conditions. Do not re-derive
any of that — it took a multi-hour investigation to produce. If a
future request mentions HiTech in any of these subprojects, point
at the note and discuss what changed about the value calculus
before starting work.

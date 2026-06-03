---
name: project-cpnos-parked-awaiting-parallel-cable
description: cpnos active development paused 2026-06-04 until a physical Z80-PIO parallel cable arrives; user-direction park, not a stop-work
metadata:
  type: project
---

cpnos active development is **PARKED** as of 2026-06-04 awaiting a
physical parallel cable.  Resume when the cable lands.

**Why:** cpnos-in-c is shipped + green under MAME on every oracle
(cpnos-polypascal-test PASS 51.37 s clang × {PIO, SIO}, PROM1 2029 /
2048 B byte-identical post-TPA-grow, BDOS 0xE816 reported back by PPAS).
The remaining "finishing" work — real-hardware confirmation of the
PIO transport on user's RC702 — needs an actual Z80-PIO cable between
the slave and a CP/NET master to exercise.  Until the cable arrives,
any further cpnos compiler/code change is speculative: it cannot be
hardware-validated, the MAME oracle already says PASS, and the 19 B
PROM headroom + 46 B payload-grow budget make blind churn risky.

**How to apply:** when the user opens a session that targets cpnos
(any task touching `cpnos-in-c/`, `cpnos-shared/`, `cpnos-build/`,
SNIOS, CP/NET transport, the PROM1 line program, the slave's
`transport_pio.c` / `isr_pio_par`, or the `cpnos-polypascal-test`
oracle), surface this park BEFORE acting.  Suggested phrasing:
"cpnos is parked awaiting the parallel cable per
`[[project-cpnos-parked-awaiting-parallel-cable]]` — confirm you want
to unpark or that this task is a bugfix / doc / unrelated to the
PIO-transport real-hardware gate."  Unpark trigger = user says the
cable arrived (or explicitly overrides).

Out of scope for this park: cpnos's *dependencies* (llvm-z80 backend,
ravn/z88dk sdcc) — those keep advancing.  In scope: the cpnos source
tree, cpnos-specific docs, the polypascal-test harness, anything
gated on PIO real-hardware behavior.

Related memories: [[project-finishing-firmware-components]] (cpnos
is one of the four named); [[feedback-no-undocumented-default]]
(2 KB PROM cap is hardware-fixed); [[feedback-screenshot-to-verify]]
(MAME PASS is necessary but not sufficient for real-hardware claims).

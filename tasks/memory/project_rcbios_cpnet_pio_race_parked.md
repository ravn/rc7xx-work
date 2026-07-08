---
name: project_rcbios_cpnet_pio_race_parked
description: FIXED 2026-07-08 — rcbios CP/NET PIO stuck-IUS stall fixed in ravn/mame 2eb88cea; remaining constraint is z80pack 10ms poll speed
metadata:
  type: project
---

**FIXED 2026-07-08** — ravn/mame `2eb88cea` (z80pio) + rc700-gensmedet
`8f64d9d` (snios RECVBY_PIO timeout). **polypascal-pio-test PASS 16s.**
Upstream candidate: ravn/mame#13.

**What was fixed:** `check_interrupts` used `ius = A.ius || B.ius` globally,
letting PORT_B's own in-service bit block PORT_B's own next interrupt. After
the first Mode-0→Mode-1 flip during a CP/NET frame exchange, `B.ius` stuck at
1 permanently → ISR never ran → receive ring froze → deadlock. Fix: scan
PORT_A→PORT_B with `ius_above`; each port gated only by higher-priority ports.

**Two-port theory REFUTED:** `A(ip=0 ius=0)` at every blocked event — PORT_A
was never involved. `B.ius` was the single-channel stuck flag.

**Firmware confirmed correct:** `ISR_PIO_RX` ends `EI`+`RETI`, `PIO_TO_INPUT`
matches cpnos `transport_pio.c` (6/6).

**Remaining constraint:** transfer flows (28 436+ bytes without stalling) but
takes ~750 s wall — bottleneck is z80pack's 10 ms I/O poll cycle, NOT a
firmware or bridge bug. Tracked in ravn/rc700-gensmedet#123 (native CP/NET
server). Hardware validation checklist: `tasks/HW_VERIFY_cpnet_pio_ppas.md`.

Related: [[feedback_polypascal_stage1_flake]]; SIO-side parked flake in
`cpnos-in-c/tasks/KNOWN_ISSUE_polypascal_alternation_2026-07-07.md`.

---
name: project_rcbios_cpnet_pio_race_parked
description: rcbios CP/NET PIO PPAS-over-wire stalls on a parked SEND→RECV mode-flip race; surface before rcbios CP/NET PIO test work
metadata:
  type: project
---

The rcbios CP/NET PIO polypascal test (`rc700-gensmedet/cpnet/polypascal_pio_test.sh`)
reaches `H>` cleanly but **stalls partway through the `H:PPAS.COM` multi-record
CP/NET transfer** (non-deterministic stall point → timing race). Root-caused and
PARKED 2026-07-08.

**Root cause (MEASURED 2026-07-08):** at the `write(06)` ACK-send / output→input
mode flip, MAME z80pio leaves **PORT_B's own in-service bit `B.ius` stuck at 1**
(the CPU accepted a B interrupt via `z80daisy_irq_ack` but no RETI ever cleared
it). `check_interrupts` gates on `ius = A.ius || B.ius`, so every subsequent
strobed byte sets `B.ip=1` but is suppressed → ISR never runs → ring never fills
→ deadlock (MAME alive, emu clock frozen, cpmsim pegs a core).

**Two-port theory (A+B interfering) is REFUTED by direct measurement:**
`A(ie=1 ip=0 ius=0)` at every blocked event — PORT_A never has a pending/in-service
interrupt during the test (keyboard comes over SIO-B, not PIO-A). It's PORT_B's
own stuck ius, a single-channel MAME artifact around the send excursion.

Firmware is correct: `ISR_PIO_RX` ends `EI`+`RETI`, `PIO_TO_INPUT` matches
cpnos `transport_pio.c` (6/6). A real Z80 PIO clears IUS on RETI via the daisy
IEO chain → **not expected to reproduce on real hardware**. Pre-existing —
reproduces on the old 0xff-sentinel bridge too.

**Not caused by** the 8-bit-clean bridge cleanup (ravn/mame `12ea19d0`, which is a
real win: login→H> dropped to ~2.9 s, clean; removed the 0xff sentinel).

**Full writeup:** `rc700-gensmedet/tasks/KNOWN_ISSUE_pio_send_recv_race_2026-07-08.md`
(reproduction, MAME z80pio line refs, 3 fix options — recommended fix is option 1:
assert BRDY on Mode-1 entry + hold interrupt pending across IE-enable).

**Why parked:** production CP/NET runs on cpnos-in-c PIO (passes polypascal 6/6,
doesn't stress the 222-record bulk transfer the same way); rcbios CP/NET PIO PPAS
is secondary validation; the fix is larger MAME z80pio chip work. Related:
[[feedback_polypascal_stage1_flake]], and the SIO-side parked flake
`cpnos-in-c/tasks/KNOWN_ISSUE_polypascal_alternation_2026-07-07.md`.

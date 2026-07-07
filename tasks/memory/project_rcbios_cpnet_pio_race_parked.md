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

**Root cause:** SEND→RECV mode-flip race. After the slave sends a CP/NET ACK it
flips PIO-B back to input via four `OUT (ctrl)` writes (`PIO_TO_INPUT` in
`cpnet/snios.asm`); MAME `cpnet_bridge` `poll_tick` can strobe a byte in the
window after mode-set but before interrupt-enable → interrupt lost, byte
consumed-but-dropped → deadlock (MAME alive, emu clock frozen, cpmsim pegs a
core). `z80pio::set_mode(MODE_INPUT)` asserts no BRDY edge, so the bridge is left
polling blind. **Pre-existing** — reproduces on the old 0xff-sentinel bridge too.

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

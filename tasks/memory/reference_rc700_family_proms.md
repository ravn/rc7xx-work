---
name: reference-rc700-family-proms
description: RC700 came in three base variants (RC701/RC702/RC703); RC701 is an earlier variant with DIFFERENT I/O port numbers and NO semigraphics (emulating it in MAME would need code changes). PROM naming inventory per datamuseum.dk.
metadata:
  type: reference
---

The **RC700** system shipped in three base variants: **RC701, RC702, RC703**.

**We target RC702** (the user's physical hardware — see
[[project-user-rc702-has-sem702]]).  We have NOT looked at RC701 before.

**RC701 is an earlier predecessor with DIFFERENT hardware:**
- **Different I/O port numbers** than RC702 — so if we ever want MAME to
  emulate RC701 (once we know more), it needs **driver code changes**, not just
  a ROM swap (the `rc702.cpp` port map would differ).
- **No semigraphics** (no ROA327/sextant character generator path).

**PROM inventory** (per https://datamuseum.dk/wiki/Bits:30004910):

| System | testprom 1 | testprom 2 | system PROM |
|--------|-----------|-----------|-------------|
| RC701  | ROA376    | ROA377    | ROA195      |
| RC702  | ROA378    | ROA379    | **ROA375** (systemprom1) |

We already work with **ROA375** (RC702 systemprom1 = the autoload PROM being
rewritten in `autoload-in-c/`).  Code for the **RC701** PROMs (ROA376/377/195)
has **not been seen and is probably not preserved** (user, 2026-07-02).

**Why it matters:** don't assume RC701 == RC702.  Any RC701 work (MAME
emulation, PROM analysis) starts from "different ports, no semigraphics, source
likely lost" — flag the code-change scope before proposing RC701 emulation.

## Concrete RC701 → RC702 differences (RCSL 42-i-1495 appendix D)

Source: the "RC702 - TESTPROGRAMMER" manual (Knud Henningsen, Aug 1980,
datamuseum.dk Bits:30004910).  It says the general structure is *kept* from
RC701, with these RC702 changes (so these are exactly what an RC701 MAME
variant would have to undo/differ on):

1. **SW0 switch removed** — RC701 had a DIP (SW0) to preset the SIO-A/B
   transmission speed; RC702 drops it and sets baudrate in software (default
   **1200 bps**).
2. **New HW clock-frequency divider** for the SIO-A/B transmit clock on RC702
   → different SIO init.
3. **SW1 bit 7 = MINI/MAXI indicator** on RC702 (drives the µPD765 diskette
   controller's LSB into MINI/MAXI mode, via CTC/SIO); not so on RC701.
4. **SW1 is decoded "from the right" on RC701** — i.e. the SW1 bit order is
   reversed vs RC702.
5. **CRT (8275) init changed on RC702 because of semigraphics** — RC701 has NO
   semigraphics (no ROA327/sextant equivalent); this is the init that differs.
6. **Different HW port numbers** — the actual RC701 vs RC702 port map is in
   **ref [8]: "Hardw. portnumre, Microdatamat line RC701/RC702"** (held by KDH,
   Ballerup).  **We do NOT have ref [8]** — so we know the ports differ but not
   the values.  Getting ref [8] is the prerequisite for an RC701 MAME driver.

**RC702 hardware confirmed by the same manual** (matches our MAME driver):
Intel 8275 CRT, AM9517 DMA, Z80 CTC/CPU/PIO/SIO, NEC µPD765 FDC; **SW1 read on
port 0x14**; NMI/`HALT,RETN` @ 0x0066; display buffer 0x7800–0x7FFF; stack
0xBFFF.  External units: screen RC751, keyboard RC721, printer RC861,
lineselector RC791.

Note: this manual is the **production TEST** manual (test PROMs, run from a
TCP702 MCS85/8080 technician panel) — it does NOT contain the RC701/RC702
system/autoload PROM source (ROA195 / ROA375); only a small test-PROM excerpt
(appendix H).

## RC701 logical port numbers (from Bits:30000046, "Supplement til RC700 COMAL Brugermanual", RCSL 42-11599, printed page 14)

Decimal in source; RC701 given in parens after RC702. Hex here.

| Function | RC702 | RC701 | Chip |
|----------|-------|-------|------|
| Screen 8275 control/data | 0x00/0x01 | 0xC8/0xC9 | I8275 (Intel) |
| Floppy µPD765 control/data | 0x04/0x05 | 0xE0/0xE1 | µPD765 (NEC) |
| SIO data A/B, control A/B | 0x08-0x0B | 0x88-0x8B | Z80A-SIO2 (Zilog) |
| PIO data kbd/par, control kbd/par | 0x10-0x13 | 0x84-0x87 | Z80A-PIO (Zilog) |
| Beeper (audible on positive-number print) | 0x1C | (none) | — |

Note: RC701's 8275 screen port 0xC8/0xC9 is the same range the VPB701 graphics
card (µPD7220) later used on RC702 (see docs/RC702_VPB701_GRAPHICS.md). Fills
catalogue TODO #1 (RC701 ports).

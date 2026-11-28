# Regnecentralen RC750 Partner — CCP/M-86 XIOS & RSP

Dette katalog er forberedt til Concurrent CP/M-86 3.1 XIOS og RSP-moduler for **RC750 Partner** (bærbar 80186-maskine fra Regnecentralen, 1984–1986).

## Arkitektur: Partner (RC750) vs. Piccoline (RC759)

| Komponent | RC759 Piccoline | RC750 Partner |
|---|---|---|
| **CPU** | Intel 80186 @ 6 MHz | Intel 80186 @ 6 MHz |
| **Skærmcontroller** | Intel 82730 tekst-coprocessor | Fladskærm LCD / ekstern CRT controller |
| **Videohukommelse** | Dual-port RAM (0x1000:0x0000 segment) | Dedikeret videoram med anden baseadresse |
| **Tastatur & Input** | 8048 MCU via seriel forbindelse | Indbygget tastaturcontroller (PIN.RSP tilpasning) |
| **Disksystem** | WD1770 FDC + OMTI 5100 SASI | FDC + integreret 3.5" eller 5.25" drev |
| **Systemtick / RTC** | VSYNC fra 82730 (60 Hz) + MM58167 RTC | RTC med afvigende interruptlinje |

## Forberedelse til Partner XIOS

Når Partner XIOS genskabes / tilpasses, følges samme struktur som for Piccoline (`rc/rc759`):
1. `xios/`: Partner hardware-abstraktion (`xios_code.asm`, `hardware.inc`).
2. `rsp/`: Partner-tilpassede Resident System Processes (`tmp750.rsp`, `clock.rsp`, `pin.rsp`, `vout.rsp`, `scroll.rsp`).
3. Modulerne samles via `gen_xios.py` og linkes med `LINK-86` for at danne `XIOS1.CON` og `XIOS4.CON` til Partneren.

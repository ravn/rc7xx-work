---
name: reference_bitsavers_rsync
description: Bitsavers.org understøtter anonym rsync-adgang til datasheets og manualer — bruges til at hente PDF'er der blokeres via HTTP
metadata:
  type: reference
---

## Bitsavers Anonymous Rsync

Bitsavers blokerer HTTP/HTTPS-scraping (HTTP 403) men understøtter **anonym rsync**.

### Rsync-adgang

```bash
# List tilgængelige moduler
rsync --list-only rsync://bitsavers.org/

# List indhold i et modul
rsync --list-only rsync://bitsavers.org/bitsavers/components/intel/80186/

# Hent en specifik fil
rsync -a rsync://bitsavers.org/bitsavers/components/intel/80186/270788-001_...pdf .
```

**Modul:** `bitsavers` (det eneste relevante)

### Nyttige stier

| Indhold | Rsync-sti |
|---------|-----------|
| Intel 80186 manualer | `rsync://bitsavers.org/bitsavers/components/intel/80186/` |
| National Semi. datasheets | `rsync://bitsavers.org/bitsavers/components/national/` |
| National RTC datasheets | `rsync://bitsavers.org/bitsavers/components/national/_dataBooks/` |
| Intel periferimanualer | `rsync://bitsavers.org/bitsavers/components/intel/` |

### Hentede filer (session 2026-11-26)

Gemt i `/Users/ravn/z80/scratch/tmp/`:
- `270788-001_80186_80188_80C186_80C188_Hardware_Reference_Manual_1990.pdf`
  — 80186 PCB Timer Control Register (Fig. 56, s. 6-2): EN/INH/INT/RIU/MC/RTG/P/EXT/ALT/CONT
- `1989_National_Real_Time_Clock_Handbook.pdf`
  — MM58167A register-kort og interrupt-beskrivelse (s. 1-39, 1-100+)

### Nøglefund

**80186 Timer Control Word** (port 0xFF56 = PORT_PCB_T0_CON):
```
bit 15: EN   — Timer Enable
bit 14: INH  — Inhibit: 1 = skriv til EN er effektivt
bit 13: INT  — Interrupt Enable
bit 12: RIU  — Register In Use (read-only)
bit 5:  MC   — Max Count: 0=MAXA, 1=MAXA+MAXB alternerende
bit 4:  RTG  — Retrigger enable
bit 3:  P    — Prescale (÷4 ekstra)
bit 2:  EXT  — External CLK pin
bit 1:  ALT  — Alternate: 0=MAXA, 1=MAXB
bit 0:  CONT — Continuous mode
```
Kassette-timer: `0xC013` = `EN|INH|RTG|ALT|CONT` = internt ur (CPU÷4), MAXB=0xFFFF, continuous.

**MM58167A** register-adresser (5-bit A4:A0):
- 0x00-0x07: Real-time counter (tid)
- 0x08-0x0F: Clock RAM/compare registers (alarm)
- 0x10: Interrupt Output register (read = status)
- 0x11: Interrupt Control register (enable interrupt-periode)
- 0x12: Status bit (ripple under læsning)
- 0x13: GO command (reset sekunder)
- 0x16: Standby interrupt control

Interrupt ryddes ved at LÆSE register 0x10.
RC759 XIOS skriver 0xC4 til reg 0x07 (Month) i 1-sek ISR — RC759-specifik, muligvis
adresselinje-inversion (0x07 → 0x0F = Month compare/RAM register).

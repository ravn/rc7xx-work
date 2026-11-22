---
name: reference_rc759_screen_architecture_piccoline_vs_partner
description: RC759 Piccoline vs. RC750 Partner skærmarkitektur, hukommelsesreservation og interrupthåndtering i XIOS
metadata:
  type: reference
---

# Skærmarkitektur & Forskelle: RC759 Piccoline vs. RC750 Partner

Kilder:
- **Kildekodegennemgang af unified XIOS** i [tasks/rc759-xios/mod4_xios.asm](file:///Users/ravn/z80/tasks/rc759-xios/mod4_xios.asm).
- **RC759 Piccoline Programmer's Guide v2**, kapitel 4 (*The Screen*, side 29–48).
- **RC750 Partner Hardware Manual**.
- Detaljeret arkitektur- og designanalyse: [tasks/rc759-xios/screen_architecture_piccoline_vs_partner.md](file:///Users/ravn/z80/tasks/rc759-xios/screen_architecture_piccoline_vs_partner.md).

---

## 1. Dynamisk Maskin-ID Detektion

Regnecentralen vedligeholdt ét samlet XIOS-binær (`XIOS1.CON` / `XIOS4.CON`), der understøttede både RC759 Piccoline og RC750 Partner. XIOS forgrener sig dynamisk baseret på **Auto-Configuration Map**:
- Placeret af boot-ROM ved `0000:0050h` (kopieres til `SYSDAT:4225h` under boot).
- **Byte offset 0x17 (23 dec)**:
  - ASCII `'P'` (`0x50`): **RC750 Partner** (bærbar PC-kompatibel arbejdsstation).
  - Enhver anden værdi: **RC759 Piccoline** (skolearbejdsstation).

---

## 2. To Fundamentale Arkitekturforskelle

### Forskel 1: Skærmhukommelse (0 KB vs. 24 KB System-RAM)
* **RC759 Piccoline (0 KB reservation i system-RAM)**:
  - Benytter en avanceret **Intel 82730 tekstprocessor** og 32 KB dedikeret, dual-ported CRT-RAM placeret uden for system-RAM (i I/O-adresserummet `0xD0000`–`0xD7FFF`).
  - Hverken tekst eller displaylister stjæler systemhukommelse fra CCP/M-86.
  - Al tekstbehandling sker som et Micro-DMA kanalprogram med hardwarecursor, attributter og flydende scanline-rulning.
* **RC750 Partner (24 KB reservation i system-RAM)**:
  - Benytter en simplere Motorola 6845 CRTC og et 24 KB frame-buffer, der er mappet direkte ind i toppen af systemets almindelige RAM (`0x593d = 0x18` paragraffer = 24 KB).
  - XIOS trækker de 24 KB fra CCP/M's hukommelsespulje, hvilket reducerer tilgængelig TPA for applikationer.
  - Ingen dedikeret CRT-coprocessor; tekst tegnes direkte i frame-bufferet via CPU'en.

### Forskel 2: Interrupthåndtering & ROM Debugger
* **RC750 Partner**:
  - Maskinen leveredes med en indbygget ROM-monitor/debugger til service og udvikling.
  - XIOS bevarer og genopretter eksisterende vektorindhold for **INT 1** (Single Step), **INT 3** (Breakpoint) og **INT 0xE1** via en backup-tabel ved `0x5087`–`0x5093`, så ROM-debuggermiljøet ikke ødelægges.
* **RC759 Piccoline**:
  - Skolemaskine uden hardware ROM-debugger.
  - XIOS overskriver og installerer sin egen interne breakpoint-handler ved `CS:0x471E`.

---

## 3. Rullemekanisme (Soft Scroll vs. Line Scroll)

* **Flag**: `[bx + 0x71]` i konsollens CCB samt global standard `[cs:0x2c08]`.
  - `0` = Hård rulning (Line/Jump Scroll): Opdaterer 82730 displayliste direkte.
  - `1` = Blød rulning (Soft Scroll): Vækker `SCROLL.RSP` via RTM Flag 4. `SCROLL.RSP` driver 1-scanline forskydning via `INT 28H, AL=2` synkroniseret med VSYNC (Flag 9/10).
* **Initialisering**: Hentes fra NVRAM byte 18 (`0x12`), 4 MSB (`0x10` = soft scroll, `0x00` = line scroll).
* **Runtime kontrol via Escape-sekvenser**:
  - `ESC <244>` (`0x1B, 0xF4`): Aktiverer Soft Scroll.
  - `ESC <245>` (`0x1B, 0xF5`): Aktiverer Line Scroll.

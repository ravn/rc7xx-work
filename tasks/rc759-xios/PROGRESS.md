# RC759 XIOS reverse engineering — progress

Plan: `tasks/memory/reference_rc759_xios_re_2026-11-20.md`  
Opus-plan dokumenteret i session 2026-11-20.

## Fase 0.1 — CFG symbol-tabel (DONE 2026-11-20)

`tools/build_xios_map.py` — Capstone 16-bit CFG-traversal fra kendte seeds.
- Output: `xios_map.json` + `xios_map.txt`
- 48 seeds, 2797 instruktioner kortlagt (~7.5% af ccpm.sys)
- Automatisk krydsreference (callers/calls) for alle symboler
- I/O-port-annotation ved OUT/IN

Kan genkøres når nye labels tilføjes.

## Fase 0.2 — Loader-model (DONE 2026-11-20)

ccpm.sys består af 5 MEMIF-moduler, alle med samme sysdat=0x06FA og
supervisor=0x0048:0x0003. Fil loades ved paragraph 0x0048 (physical 0x0480).

| # | Fil-range | Størrelse | DRI-kilde | Indhold |
|---|-----------|-----------|-----------|---------|
| 0 | 0x00080–0x0163F | 5568 B | RTM.A86 | RTM-kerne (scheduler, flags, queues) |
| 1 | 0x01640–0x026BF | 4224 B | BDOS.A86 del 1 | fil-system del 1 (file1-3.bdo) |
| 2 | 0x026C0–0x031DF | 2848 B | BDOS.A86 del 2 | fil-system del 2 + konsol I/O |
| 3 | 0x031E0–0x03ACF | 2288 B | BDOS.A86 del 3 | konsol-I/O manager |
| 4 | 0x03AD0–0x12EFF | 62512 B | XIOS+SYSDAT | RC759 XIOS (Flemming Kraglund) |

Modul 4 indeholder både SYSDAT (data-segment) og XIOS (kode), som linkes sammen.

**SYSDAT segment**: DS=0x06FA, physical 0x06FA0, fil-offset 0x06B20.
**XIOS kode**: starter ved fil 0x0B163 (= SYSDAT:0xC00).
**Dispatch-tabel**: fil 0x16A4 (inde i modul 1).

Modul 4's `mod4_init` ved 0x03B1C er bare `RETF` — faktisk init sker i XIOS'
egen `xios_init` ved fil 0x0B169 (via JMP ved 0x0B163).

## Fase 1.1 — RTM service-tabel (DELVIST DONE 2026-11-20)

RTM-kernen ved fil 0x0282 slår op i tabel ved SYSDAT+0xAA (fil 0x06BCA).
Mapping AL → tabel-indeks:

| AL-range | SI-beregning | Bemærkning |
|----------|--------------|------------|
| 0x00–0x50 | SI = AL×2 | kerne-tjenester (scheduler, memory) |
| 0x62–0x74 | SI = (AL-0x11)×2 | I/O-tjenester |
| 0x80–0xA4 | SI = (AL-0x1C)×2 | konsol/serial-tjenester |

**Verificerede handlers i den statiske binær**:

| AL | Beskrivelse | Handler-fil-offset |
|----|-------------|-------------------|
| 0x80 | poll console buffer (io_const) | **0x8517** |
| 0x87 | blocking read (io_conin) | **0x851E** |

0x851D er en padding-byte (DAS); handleren starter ved 0x851E med klassisk
funktion-prologue (`push si / push di / call ...`).

**Åbent spørgsmål**: AL=0x02 (io_read) giver handler=0x06FA, som er
SYSDAT-segment-værdien, ikke en gyldig kode-adresse. Det TYDER på at nogle
entries patches af GENSYS ved boot. Verificering via MAME-trace er næste skridt.

## Fase 1.2 — XIOS entry() ved 0x8C (DONE 2026-11-20)

`JMP entry` i XIOS-headeren peger på `POP BP / RET` ved XIOS+0x8C.

**Konklusion**: Det er en **ubrugt placeholder**. Der er ingen matchende
`PUSH BP` i init() og ingen eksterne kaldere af XIOS-header fra kode.
RC759 XIOS bruger IKKE DRI's standard JMP init/JMP entry-konvention —
alle XIOS-kald sker via:

1. Dispatch-tabellen ved CS:0x16A4 (io_const, io_conin, ...)
2. RTM service-tabellen ved SYSDAT+0xAA (RTM AL-funktioner)

Både init()-fald-gennem og JMP entry lander samme sted (0x8C) som bare returnerer.

## Fase 1.3 — Inter-modul søgeloop (DONE 2026-11-20)

XIOS+0x4EE3 har `JMP 0x4F20` (bytes E9 3A 00) — koden fra 0x4EE6 til
0x4F17 er **sprunget over** i den statiske binær.

**Konklusion**: Søgeloopet er en **GENSYS extension point** til multi-modul
XIOS-konfigurationer. Søgnøglen ved 0x2B0 (maskinkode fra RTM-kerne!) ville
aldrig matche tabellen ved 0x15F3 (boot-banner-tekst "3.1\r\nCopyright...").
GENSYS kunne patche starten til ikke at springe over, hvis der var flere
XIOS-moduler at dispatch mellem. RC759 bruger single-modul XIOS så koden
er bypass'et.

Den reelle dispatch (brugt i praksis): `JMP CS:[BX + 0x16A4]` ved XIOS+0x4F12,
med BX = funktionsnummer × 2. Dette er allerede kortlagt i xios_map.json.

## Næste

- Fase 2.1: **iSBX ISR** (den faktiske hardware-læse-interrupt på port 0x302)
  — vigtigste resterende punkt for konsol-sporet.
- Fase 3.1: FDC/DMA fuld annotation (afventer fase 1.1 fuld klarhed om RTM fn 2).
- Fase 4.1: io_conout escape-parser (RC759 dansk-specifikke sekvenser).
- Fase 5.1: dd759*.sys device drivers (separate drivere, ikke undersøgt endnu).

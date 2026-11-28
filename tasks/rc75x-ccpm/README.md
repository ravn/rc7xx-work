# RC75x Concurrent CP/M-86 (CC/M-86) Byggemiljø

Dette katalog (`tasks/rc75x-ccpm/`) indeholder det komplette kildetekst- og byggemiljø til Concurrent CP/M-86 v3.1 for Regnecentralens RC75x-serie (RC759 Piccoline og forberedt for RC750 Partner).

Byggemiljøet bygger samtlige XIOS-kerner, RSP-processer og systemkerner i ét samlet modul med fulde, sigende labels under Digital Researchs originale værktøjer (`RASM-86` og `LINK-86`) med 100% byte-perfekthed mod de originale distributionsdisketter.

---

## 1. Mappestruktur

```text
tasks/rc75x-ccpm/
├── build_all.sh                 # Samlet build script (XIOS1, XIOS4, RSP'er, GENCCPM)
├── README.md                    # Denne dokumentation
├── dri/                         # Digital Research originale moduler og værktøjer
│   ├── src/                     # DRI kildetekster (SUP.A86, RTM.A86, MEM.A86, CIO.A86, BDOS.A86, SYSDAT.A86)
│   ├── con/                     # DRI MEMIF moduler og konfigurationsdefinitioner (STDKONF, RDEF*, SDEF)
│   └── tools/                   # DRI værktøjer til CP/M-86 (GENCCPM.CMD, RASM86.CMD, LINK86.CMD)
└── rc/                          # Regnecentralen maskinspecifikke moduler
    ├── rc759/                   # RC759 Piccoline
    │   ├── xios/                # XIOS kildetekst og generator
    │   │   ├── xios_code.asm    # Fuld XIOS kildetekst (1 samlet modul, sigende labels)
    │   │   ├── gen_xios.py      # Generator for XIOS1/XIOS4 A86 kildetekst
    │   │   ├── hardware.inc     # RC759 I/O-porte, CRTC 82730, Floppy/HDC definitioner
    │   │   ├── license.inc      # RC/DRI licenshoved
    │   │   └── rasm86.inc       # RASM-86 kompatibilitetsmakroer og konstanter
    │   └── rsp/                 # Resident System Processes (RSP)
    │       ├── clock/           # CLOCK.RSP (realtidsur / tick)
    │       ├── pin/             # PIN.RSP (tastatur / input)
    │       ├── scroll/          # SCROLL.RSP (skærm-scrolling)
    │       ├── tmp759/          # TMP759.RSP (Terminal Message Process)
    │       ├── vout/            # VOUT.RSP (skærm-output driver)
    │       └── netdrv/          # NETDRV.RSP (RC-Net netværksdriver)
    └── rc750/                   # RC750 Partner (forberedt)
        └── README.md            # Hardwarearkitektur og forskelle fra RC759
```

---

## 2. Arkitektur og Varianter

Regnecentralen leverede to primære Concurrent CP/M kernevarianter til RC759 Piccoline:

| Kerne | Filnavn | Størrelse | Beskrivelse |
|---|---|---|---|
| **Kerne 1** | `XIOS1.CON` | 25.728 bytes | Standard floppy-system (2x 5.25" / 3.5" diskettedrev) |
| **Kerne 4** | `XIOS4.CON` | 29.440 bytes | Harddisk-system (inkl. SASI/MFM harddisk-driver og cache) |

Begge kerner bygges af samme kildetekstgrundlag (`xios_code.asm` + parametrisering via `gen_xios.py` og `rasm86.inc`).

### Hukommelse og RASM-86 optimering
Kildekoden samles i **ét samlet modul** uden opsplitning. For at holde symboltabellen inden for RASM-86 v1.2's 64 KB datasegment anvendes:
- Direkte numerisk RAM-adressering via `.disp` operatoren (`mov es:word ptr .8, ax`).
- Korte, præcise labels på interne hop.
- `USE FACTOR`: 90% (XIOS1), 93% (XIOS4) med 0 fejl.

---

## 3. Byggevejledning

### Forudsætninger
Byggesystemet benytter `emu2` til at afvikle 16-bit CP/M-86 værktøjer på moderne platforme (macOS / Linux):
- `emu2-cpm86/emu2` (ligger i workspace-roden).
- Python 3.

### Hurtig bygning
Kør byggescriptet fra workspace-roden eller fra `tasks/rc75x-ccpm/`:

```bash
cd tasks/rc75x-ccpm
./build_all.sh
```

Scriptet udfører automatisk:
1. Genererer `XIOS.A86` for Kerne 1 og Kerne 4.
2. Samler med `RASM-86` og linker med `LINK-86 [DATA[ORIGIN[0]]]`.
3. Validerer output mod distributionsoraklet med SHA-256 kontrolsummer.
4. Genererer og verificerer RSP-moduler.
5. Kører `GENCCPM.CMD` for at sammensætte det færdige `CCPM1.SYS`.

---

## 4. Verifikations-orakel (SHA-256)

Følgende kontrolsummer verificerer 100% byte-identitet mod distributionsdisketterne (`dist/genccpm-kit/`):

| Komponent | Filnavn | Bytes | SHA-256 Checksum |
|---|---|---|---|
| XIOS Kerne 1 | `xios1.con` | 25.728 | `6e52c1cac38202fff5c6a8e24a9c8747892f6956591373a161aa2da76b6e592d` |
| XIOS Kerne 4 | `xios4.con` | 29.440 | `7ac3a6b9925483795539b42f0be93ec952791dc9fcf33fca740ecec07fbf6a53` |
| Systemkerne | `CCPM1.SYS` | 89.216 | `ce9b433e5fb39223102a0a202a96a928baeb772733d749ee5db985fae4604df0` |

---

## 5. Forberedelse for RC750 Partner

RC750 Partner deler CPU (Intel 80186) og operativsystemstruktur med RC759 Piccoline, men har forskelle i:
- LCD fladskærmscontroller vs. RC759 Intel 82730 CRT controller.
- Intern I/O- og tastaturinterfacetilknytning.
- Fastmonteret RAM/ROM layout.

Kataloget `rc/rc750/` er forberedt til disse kilder og definitioner, så samme byggemetode kan anvendes til Partneren.

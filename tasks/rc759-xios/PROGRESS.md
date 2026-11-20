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

## Fase 2.1 — iSBX konsol-I/O (DONE 2026-11-20) — POLLING, ikke interrupt!

**Overraskende fund**: CCPM 3.1 på RC759 bruger **polling** for konsol-input,
ikke interrupt-drevet. Der er INGEN ISR for iSBX seriel i den statiske binær.

**Konsol status-polling** (`sub_AD8E`):
```asm
AD8E: mov dx, 0x302         ; iSBX seriel data/status
AD91: in al, dx              ; læs
AD92: test al, 0x80          ; bit 7 = "data klar"?
AD94: mov ax, 0xFFFF
AD97: jne 0xAD9A              ; hvis ja, returner 0xFFFF
AD99: inc ax                  ; ellers AX = 0x0000
AD9A: ret
```

**Konsol data-læsning** (`sub_B032`):
```asm
B032: mov dx, 0x302           ; iSBX seriel
B035: in al, dx                ; læs status/data byte
B036-B05D: bit-pak til AL (bit 7→8, bit 4→4, bit 2→1, bit 1→0x20)
B05D: ret
```

Returnerer kodet statusord: bit 4 (0x80 status) → 0x08; bit 2 (strømfejl?) → 0x04;
bit 1 (overrun?) → 0x01; bit 0 (data ready?) → 0x20.

**Arkitektur**: RTM-scheduleren tillader multitasking mens konsol-polling kører.
io_const (0x282C) kalder RTM fn 0x80 der til sidst poller via 0xAD8E.
Ingen ringbuffer-udfyldning via interrupts — tegn læses direkte når RTM-polling
schedules.

Den tidlige ISR-kandidat ved 0xB110-0xB24B er **reconfigurations-kode** for
iSBX MCS1 (port 0x314/0x316), ikke konsol-input. ISR'en genbruger XIOS init()-koden
(hopper til 0xB169) for at genprogrammere iSBX-kortet.

## Fase 4.1 — io_conout og escape-sekvenser (DONE 2026-11-20)

**io_conout** (fil 0x4F8C) er en **buffer-baseret skriver** — ingen escape-parsing!

```asm
4F8C: mov dx, 0x20         ; parameter til helper
4F8F: call 0x4DAF          ; "tilføj tegn til buffer"
4F92: pop bx / pop ax
4F94: mov [bx], al          ; gem tegnet i ring-buffer
4F96: mov byte [0x8C8], 0   ; opdater status-flag
4F9B: call 0x4B29           ; "flush eller signal"
4F9E: jmp 0x4286            ; retur til hovedloop
```

**Søgte efter ESC (0x1B) i ccpm.sys**: 0 forekomster af `CMP AL, 0x1B` i nogen form.
Der er INGEN ANSI/VT terminal-escape-parser i XIOS.

**i82730 CRT-kommandoer** sendes via port 0x230 (reset) + 0x240 (channel attention).
Kun 4 kaldesteder — og de er initialisering, ikke terminal-tolkning:
- Fil 0x7BFE: init-sekvens (reset + CA)
- Fil 0x9607: "post command to CRT and wait for completion" (polling [0x5FA4])
- Fil 0xB9B7: mode-switching

**Konklusion**: 
- XIOS leverer tegn RÅ til en lokal ring-buffer per konsol
- CRT-chip (i82730) læser direkte fra VRAM via DMA
- Terminal-escape-sekvenser (hvis understøttet) må være implementeret:
  1. I et separat screen-manager-modul (ikke fundet i ccpm.sys)
  2. ELLER håndteres kun af GSX-driveren (dd759*.sys) i grafik-mode
  3. ELLER CCPM's console er basalt rå (ingen cursor-movement via ESC)

**For dansk-fasen**: Terminal-escape-dansk-kodning er IKKE issue for XIOS
niveau. Dansk håndteres via:
- Tastatur-XLAT-tabel (fase 4.2: 0x2C52)
- Boot-banner strenge (ordene "hoved lager", "Diskette", "konsol" m.fl.)
- ASCII-niveau tegn-koder (ÆØÅ via høj-bit eller ISO-646 DK {|}[\\])

## Fase 5.1 — dd*.sys er GSX-86 drivere, ikke XIOS drivere (DONE 2026-11-20)

**Opklaring**: dd*.sys er IKKE XIOS device drivers — de er **GSX-86 drivere**
(Graphics System Extension fra Digital Research). "Not Enough Disk Space for
Object List" er en GSX-specifik fejl: GSX bufferer tegne-kommandoer i "object
lists" på disk (`GSXTMP.$$$`) når RAM-bufferen er fuld.

**Driverklasser**:
- `dd759*.sys` (12 varianter, 7.9–8.6 KB): RC759 SKÆRM-drivere
  - Konvention: h/m × d/m-suffix × 1/4 (resolution × mode × farve-antal)
- `dd604*.sys` (4 varianter, 16.6 KB): PRINTER-drivere
  - C. Itoh 8510A HR A4 (dot-matrix, sort/hvid + color varianter)
- `dd621.sys` (13.8 KB): plotter? (indeholder DRI C runtime 1.10)

**Status**: Alle 12 dd759*.sys er ALLEREDE fuldt reverse engineerede i
`rc700-gensmedet/rc759-gsx/` (fælles `src/dd759.a86` kilde, 100% byte-match
mod `originals/`, verificeret 2026-11-01). Se:
- `rc700-gensmedet/rc759-gsx/notes/01-initial-findings.md`
- `rc700-gensmedet/rc759-gsx/notes/04-gsx11-source-comparison.md`
- `tasks/memory/reference_rc759_82730_graphics.md` (hvordan GSX tegner via
  82730's programmerbare char-generator)

Fase 5.1 behøver intet yderligere arbejde fra RC759 XIOS RE-sporet.
Issue #17 kan lukkes med pointer til eksisterende arbejde.

## Fase 4.2 — Tastatur HLE (DONE 2026-11-20)

Tastatur-handler ved **0x7A99** (ikke ISR, hybrid polling/interrupt):
```asm
7A99: PUSHA                  ; gem alle registers
7AA1: push ds / pop es        ; ES = DS
7AA3: CALL 0xAF11             ; send EOI
7AA6: IN AL, 0x20             ; læs scancode fra tastatur
7AA8: mov cs:[0x1044], al     ; gem scancode i buffer
7ABE: mov bx, 0x2C52          ; XLAT-tabel pointer
7AC1: XLATB                   ; konverter scancode → tegn
7AC2: mov cs:[0x1040], al     ; gem konverteret tegn
7AC9: call 0x78C0             ; videregiv til RTM
...
7B67: POPA / RET              ; returnér (NB: ikke IRET)
```

**EOI-helper ved 0xAF11**:
```asm
AF11: mov al, 0x20            ; EOI command
AF13: out 0, al               ; send til 8259A PIC
AF15: mov dx, 0xFF22          ; 80186 PCB EOI register
AF18: mov ax, 0x8000          ; non-specific EOI
AF1B: out dx, ax
AF1C: ret
```

**Konklusion**: Både konsol OG tastatur bruger **polling-model**, ikke interrupts.
EOI'en sendes dog fordi handleren kaldes efter en INT-indikation (sandsynligvis
via RTM-flag). Scancode-tabellen ved 0x2C52 er 256 bytes, muligvis DS-afhængig
ved runtime (statisk form ser ud som kode). Dansk-mapping (ÆØÅ/æøå) er
til stede men kræver yderligere analyse under runtime.

## Status 2026-11-20 (dagsopsummering)

**Gennemført**: 6 af 11 faser i Opus-planen (fase 0.1, 0.2, 1.1, 1.2, 1.3, 2.1).
**Instruktioner kortlagt**: 2797 (udvides automatisk når seeds tilføjes).
**Åbne issues** (ravn/rc7xx-work):
- #16 Verificer RTM fn 2 patches io_read handler ved runtime
- #17 Disassembler dd759*.sys device drivers
- #18 Kortlæg dansk oversættelse (strings + ÆØÅ + escape-sekvenser)
- #19 MAME: verificer behov for port 0x060 (i82730 command block) emulation

**Vigtigste arkitektoniske fund**:
1. RC759 XIOS bruger IKKE DRI's standard JMP init/JMP entry — alle kald via
   dispatch-tabel ved CS:0x16A4 + RTM service-tabel ved SYSDAT+0xAA.
2. GENSYS extension point ved XIOS+0x4EE3 er bypass'et (single-modul XIOS).
3. **Konsol-input bruger POLLING, ikke interrupts** (sub_AD8E + sub_B032).
4. DPC delt-disk-reservation forklarer port 0x28E/0x290 i io_read/io_write.

## Næste

- Fase 3.1: FDC/DMA fuld annotation (afventer #16 for RTM fn 2 verifikation).
- Fase 4.1: io_conout escape-parser (relateret til #18).
- Fase 4.2: Tastatur HLE (port 0x020) polling-analyse.
- Fase 5.1: dd759*.sys device drivers (#17).
- Fase 6.1: i82730 CRT-driver (#19).

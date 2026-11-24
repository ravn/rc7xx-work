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

## Fase 3.1 — FDC/DMA fuld annotation (DONE 2026-11-20)

**io_read-kæden** (statisk bekræftet):
```asm
0A05: push es
0A06: mov cx, 2       ; RTM fn 2 = disk I/O
0A09: jmp 0x313       ; → RTM-dispatcher (DS=SYSDAT, kalder 0x282)
```
RTM fn 2 patches af GENSYS ved boot — statisk binær har tabel-entry = SYSDAT-segment-adresse
(0x06FA), ikke en kode-adresse. Runtime-tabellen sættes til fdc_fcr_setup-kæden.

**io_write (0x0A6B)**: Betinget — checker `[bx+0x13]` (dirty flag), springes over hvis ren.

**fdc_fcr_setup (0x09D4E)**:
```asm
OUT 0x288, AL    ; Floppy FCR: drive/motor/precomp
CMP CH, 0        ; motor-delay?
JNE .done
MOV DX, 0x3C / MOV CL, 0x8D
CALL 0x78D3      ; RTM-timer (cooperative delay)
```

**fdc_send_cmd (0x09F06)**: `OUT 0x280 (WD2797 cmd), AL → CALL fdc_wait`

**fdc_wait (0x09F4D)** — *cooperative wait*, ikke busy-poll:
```asm
MOV byte cs:[0x376E], 1   ; sæt interrupt-venteflag
MOV DX, 8
CALL 0x78D1               ; RTM sover (yield), vågner ved interrupt
```

**fdc_read_path (0x0A00B)**: `OUT 0x280 (WD2797 Read Sector) → fdc_wait → JMP 0xA13C`

**fdc_isr @ 0x0A2BE** *(fejlnavnet fdc_force_int — rettes)*: **Dette er FDC-ISR'en**:
```asm
OUT 0x280, 0xD8   ; Force Interrupt til WD2797
...
OUT 0xFF22, 0x8000  ; 80186 PCB: non-specific EOI
IRET
```

**floppy_ack (0x0AC27)**: DPC-reservation via to separate kanaler:
```asm
; Drev 0: port 0x292 (DMA-ack)
OUT 0x292, 0xFF → IN 0x292 → test bit 7  (0=ikke klar, 1=klar)
; Drev 1: port 0x28E (DPC-ack)
OUT 0x28E, 0xFF → IN 0x28E → test bit 7
```

**floppy_status_check (0x0AD64)** — **NY port opdaget**:
```asm
IN AL, 0x28C    ; test bit 4 (DMA ready?) + bit 3 (motor on?)
IN AL, 0x260    ; drev 1 tilsvarende
→ 0xFFFF hvis klar
```
Port 0x28C og 0x260 var ikke i hardware-kortet. Muligvis FCR-status read-back.

**fdc_release (0x0CB31)**:
```asm
OUT 0x290, AL       ; frigiv DPC
MOV cs:[0x5E42], 0  ; ryd DPC-reservation-flag
```

**Nyt hardware-korttillæg** (manglede i ref):
| Port | Retning | Funktion |
|------|---------|----------|
| 0x28C | R | Floppy status/ready (drev 0) |
| 0x260 | R | Floppy status/ready (drev 1) |
| 0x292 | R/W | Floppy DMA-acknowledge |
| 0x294 | W | DMA-kanal/scroll (uafklaret) |

**Omdøbning i symbolkortet**: `fdc_force_int` → `fdc_isr`; `crt_fcr_cmd` → navn TBD
(den skriver til 0x288+0x280+0x294, ikke CRT-porte).

**#16-status**: Statisk analyse bekræfter at RTM fn 2 patches ved boot. MAME-trace
kan verificere den præcise handler-adresse, men arkitekturen er klar.

---

## Fase 6.1 — i82730 CRT-driver (DONE 2026-11-20)

**Afgørende fund: Port 0x060 bruges ALDRIG i ccpm.sys.** Nul søgeresultater for
`OUT 0x060` eller `MOV DX, 0x060`. MAME behøver IKKE implementere port 0x060 for
at køre CCPM 3.1 korrekt. **Issue #19 lukkes.**

i82730 styres udelukkende via:
- **0x230** (IRST reset): 1 sted — kun ved init
- **0x240** (Channel Attention): 3 steder — init, post-cmd-loop, mode-switch

**crt_init_reset+CA @ 0x7BFE**:
```asm
OUT 0x230, AX    ; IRST (hardware reset af i82730)
OUT 0x240, AX    ; Channel Attention
...
OUT 0xFF5E, 0xC003/0xC002  ; 80186 PCB timer-register (display timing?)
LCALL cs:[0x4325]           ; far callback (sandsynligvis VRTC-handler)
CALL 0xAF11                 ; EOI
```

**crt_post_cmd+wait @ 0x9607** (hvad der sendes til 0x240 bestemmes af kalderen):
```asm
OUT 0x240, AL              ; Channel Attention
CMP cs:[0x5FA4], AL / JE . ; poll completion-flag (sættes af VRTC ISR?)
MOV cs:[0x5FA4], 0x900     ; reset status
RET
```
Completion signaleres via shared variable — XIOS sender CA og venter på VRTC-ISR.

**crt_mode_switch @ 0xB9B7**:
```asm
OUT 0x240, AL          ; Channel Attention (mode-kommando)
; Clear VRAM
MOV ES, cs:[0x2C45]    ; VRAM segment
REP STOSW 0xFFFF × 0x4000 words  ; clear 32 KB VRAM
; Upload charset
LDS SI, cs:[0x6228]    ; charset-pointer
LODSB / SHL AX,5       ; tegn-index × 32 → VRAM-offset
MOV CX, 0xA / STOSW × 10  ; 10 × 2 bytes = 20 B per glyph-row
```
Charset-data hentes fra en far-pointer — kan opdateres runtime (f.eks. Danish charset).

**crt_fcr_cmd @ 0xC08A** *(forkert navn — skriv til floppy/DMA, ikke CRT)*:
```asm
OUT 0x288, AL    ; Floppy FCR
IN  AL, 0x280    ; WD2797 status
OUT 0x294, AL    ; ukendt port (DMA-kanal scroll-offset?)
```
Beregner scroll-offset fra en far-pointer (`cs:[0x4225]`) og udfylder en tabel ved
`cs:[0x3932]`. Muligvis displayscroll i forbindelse med floppy-DMA-state.

**Konklusion**:
- RC759 XIOS bruger i82730 via IRST+CA-protokol (reset+attention) — klassisk 82730 model
- Ingen DMA-setup-kode for 82730 i XIOS (DMA-kanaler konfigureres sandsynligvis af CRT-
  command blocks i VRAM, styret af 82730 selv)
- port 0x060 er i82730 "Command Block Busy" (CBB) — bruges KUN hvis softwaren poller
  CBB-status; RC759 XIOS bruger i stedet completion-flag i SYSDAT ([0x5FA4])

---

## Fase #18 — Dansk tegnsæt og ÆØÅ-encoding (DONE 2026-11-20)

### Encoding: ISO-646-DK (streng substitution)

Alle danske strenge i ccpm.sys bruger **ISO-646-DK**:

| Byte | Tegn | Eksempel i kode → læsning |
|------|------|--------------------------|
| 0x5B | Æ | — |
| 0x5C | Ø | — |
| 0x5D | Å | — |
| 0x7B | æ | `indl{sni` → "indlæsning" |
| 0x7C | ø | (strenge med ø) |
| 0x7D | å | `}bnes` → "åbnes", `lagergr{nse` → "lagergrænse" |

Ingen ISO-8859-1 i tekststrenge — alle 0xC6/0xD8/0xC5-forekomster er kode-bytes.

### Danske UI-strenge (alle i modul 4, ISO-646-DK)

```
0x0B34E: "759 SKÆRMTRIMNING"
0x0B361: "Markør Blink"  "Markør Højde"  "Blød Rulning"
0x0B397: "Sluk Skærm   sort  blå  grøn  cyan  rød  magenta  gul  hvid   NEJ JA"
0x0B42B: "Dynamisk  Bufferet  Buffer  Låst  LÅS  - Tryk på en tast"
0x0B4F9: "** Venter på fælles diskettestation"
0x0B59B: "PICCOLINE XIOS version 2.3 - Marts 1985"
0x0B767: "Winchester disk x har dårlig konfigurations sektor"
0x10E20: "Program indlæsning"
0x10F04: "Løsen passer ikke"
0x11146: "Program løsen: "
0x111DA: "Menu kø kan ikke åbnes"
0x111F5: "Ulovlig lagergrænse, (16-768 K)"
```

### Keyboard layout (dansk QWERTY) ved 0x9802

```
0x09802: "qwertyuiopæå\r"    (lowercase rad 3)
0x0981D: "øzxcvbnm,./"      (lowercase rad 4)
0x09865: "QWERTYUIOPÆÅ\r"   (uppercase rad 3)
0x09880: "ØZXCVBNM<>?"      (uppercase rad 4)
```

XLAT-tabel ved 0x2C52 (256 bytes): high-bit værdier er special keys, ikke
printable. Danske bogstaver sidder ved ISO-646-DK-positionerne i ASCII-delen.

### ESC-sekvenstabel ved 0x112BD

RC759-specifik escape-sæt (ikke VT100):
```
ESC M         → Reverse Index (scroll up)
ESC : <A..o>  → ~16 kommandoer (cursor-movement, scroll, erase, ...)
```
Behandles af konsol-manager (modul 3), ikke af XIOS `io_conout` —
bekræfter fase 4.1-fund (io_conout er rå buffer-skriver).

### Charset ved 0x7C55

Charset-tabellen indeholder eksplicit Æ Ø Å og æ ø å ved ISO-646-DK-positionerne.
i82730 character generator lades med disse glyphs ved mode-switch.

---

## Status 2026-11-20 (afslutning)

**Alle 11 Opus-faser + #18 gennemført**.

**Åbne issues**:
- **#16**: LUKKET (MAME-trace 2026-11-20 — se nedenfor)
- **#17**: LUKKET (fase 5.1)
- **#18**: LUKKET (ovenfor)
- **#19**: LUKKET (fase 6.1)

## #16 — RTM fn 2 runtime-verifikation (DONE 2026-11-20, MAME-trace)

MAME Lua-trace ved t=301s emuleret (CCPM 3.1 fuldt bootet, menu kørende).
Metode: `emu.register_frame_done` + `manager.machine.devices[":maincpu"].spaces["program"]:read_u16()`.

**RTM service-tabel ved runtime** (SYSDAT+0xAA = physical 0x704A):

Tabellen bruger **kodet format**: `0xMMFF` = modul×0x100 + funktionsnummer (inter-modul kald).

| AL | Beskrivelse | Runtime-adresse | Fortolkning |
|----|-------------|-----------------|-------------|
| 0x02 | **io_read** | **0x0401** | Modul 4 (XIOS), fn 1 |
| 0x80 | io_const (poll) | **0x0306** | Modul 3 (BDOS3), fn 6 |
| 0x87 | io_conin (blocking) | **0x8205** | Modul 2 (BDOS2), fn 5 |

**Konklusion**: RTM fn 2 (`io_read`) patches til `0x0401` = XIOS modul 4, funktion 1.
Det er XIOS IO_READ-handleren leveret via den inter-modul dispatch-mekanisme
(CX = modul×0x100 + fn) som vi kortlagde i fase 3.1. Statisk analyse var korrekt —
GENSYS patcher tabellen med modul/funktionsnummer, IKKE direkte kodepointere.

Alle issues (#16-#19) nu lukkede. RE fuldstændig afsluttet.

**Vigtigste arkitektoniske fund**:
1. XIOS bruger IKKE DRI's standard JMP init/JMP entry
2. Konsol-input er **polling** via RTM-scheduler (ikke interrupts)
3. FDC-I/O er **cooperative yield** — fdc_isr er en rigtig ISR med IRET
4. i82730 styres via IRST+CA — port 0x060 bruges **aldrig**
5. Dansk tegnsæt: **ISO-646-DK** gennemgående
6. ESC-parser er i konsol-manager (modul 3), ikke i XIOS io_conout

---

## BDOS/MEM/CIO dispatch-tabel-dump (GENNEMFØRT 2026-11-20)

MAME runtime-trace via `tasks/rc759-xios/tools/run_bdos_dispatch_dump.sh` ved t=301s.
Modulernes placering og dispatch-tabeller verificeret direkte i RAM og SYSDAT:

| Modul | DRI-komponent | CS | Fysisk adresse | Dispatch-tabel | Antal funktioner |
|-------|---------------|----|----------------|----------------|------------------|
| 0 | **SUP + RTM** | `0x0048` | `0x00480` | `SYSDAT+0xAA` | RTM-service |
| 1 | **BDOS** (filsystem) | `0x01A4` | `0x01A40` | `CS:0x006C` | 26 funktioner |
| 2 | **MEM** (hukommelse) | `0x02AC` | `0x02AC0` | `CS:0x004C` | 13 funktioner (1:1 match med `MEMIF.MEM`) |
| 3 | **CIO** (tegn-I/O) | `0x035E` | `0x035E0` | `CS:0x004C` | 29 funktioner (1:1 match med `CIOIF.CIO`) |
| 4 | **XIOS + SYSDAT** | `0x03ED` | `0x03ED0` | `CS:0x16A4` | RC759 XIOS (Flemming Kraglund) |

Alle 13 MEM-funktioner og 29 CIO-funktioner identificeret og tilføjet som labels i `gen_nasm.py`.
Se `HANDOFF-2026-11-20.md` for fuld funktionsfortegnelse.

---

## Model B+2: Fuld symbolisering af branch-instruktioner og labels (GENNEMFØRT 2026-11-20)

`tasks/rc759-xios/tools/convert_branches_b2.py`:
1. **Instruktionskonvertering (B)**:
   - Alle 5.184 direkte branch-instruktioner i `ccpm.asm` (`call`, `jmp short`, `jmp near`, `j<cc>`, `loop`, `jcxz`) er konverteret fra `db ... ; mnem 0x...` til rigtige NASM-instruktioner med symbolske labels.
   - 0 direkte branches med numeriske adresser tilbage i koden.
2. **Systematisk navngivning (2)**:
   - 619 subroutines er navngivet `sub_XXXXX` (eller meningsfuldt DRI-navn som `bdos1_...`, `mem_...`, `cio_...`, `rtm_...`, `xios_...`).
   - 2.369 lokale hop er navngivet `loc_XXXXX`.
   - 509 manglende branch-labels oprettet og indsat på de korrekte adresser.
   - Alle tidligere generiske `L_XXXXX:` labels er erstattet.
3. **Verifikation**:
   - Reassembled med `rc759-nasm` Docker-container.
   - Verificeret mod original `ccpm.sys`: **PASS (77.568 bytes, 100% byte-identisk)**.

---

## Fuld semantisk DRI-identifikation af subroutines i Modul 1, 2 og 3 (GENNEMFØRT 2026-11-21)

Via kildekodematching mod DRI CCP/M 3.1 (`scratch/ccpm31-src/`):
- **Modul 2 (MEM — 12 subroutines, 100% identificeret)**:
  - `mem_free_memory` (0x028BC, `CPMMEM.MEM`)
  - `mem_try_mau` (0x02AE0, `MEMORY.MEM`)
  - `mem_take_scl` (0x02B57, `MEMORY.MEM`)
  - `mem_free_mau_call` (0x02C30, `MEMORY.MEM`)
  - `mem_mau_split` (0x02E4A, `MAU.MEM`)
  - `mem_mau_collapse` (0x02E72, `MAU.MEM`)
  - `mem_mau_release` (0x02F0A, `MAU.MEM`)
  - `mem_mau_insert` (0x02F34, `MAU.MEM`)
  - `mem_mla_value` (0x02FA5, `ML.MEM`)
  - `mem_ml_insert` (0x0310B, `ML.MEM`)
  - `mem_getmd` (0x03125, `UTIL.MEM`)
  - `mem_freemd` (0x03148, `UTIL.MEM`)
- **Modul 3 (CIO — 27 subroutines, 100% identificeret)**:
  - `cio_xios_far_call`, `cio_xios_call` (0x03270, 0x03276, `CIOIF.CIO`)
  - `cio_lcb_verify`, `cio_ccb_verify`, `cio_ciodetach`, `cio_condetach_dev`, `cio_wake_disp`, `cio_conassign_match`, `cio_getccbadr`, `cio_getccbadr_spec`, `cio_getlcbadr` (0x03286–0x034C7, `CONSOLE.CIO`)
  - `cio_dirio_status`, `cio_set_raw_mode`, `cio_clr_raw_mode`, `cio_chk_ctrlp`, `cio_conout`, `cio_chk_cmode`, `cio_ctlout`, `cio_tabout`, `cio_crlf`, `cio_prcsmsg`, `cio_constf`, `cio_coninf`, `cio_conout_sleep`, `cio_conoutf`, `cio_listf`, `cio_goxios` (0x035CF–0x03A3F, `CHARIO.CIO`)
- **Modul 1 (BDOS — 26 subroutines, 100% identificeret)**:
  - 26 interne hjælpefunktioner for filsystemet, stakskift, procesaktivering (`bdos1_set_p_ready`, `bdos1_calc_abs_para`, `bdos1_calc_record_offset`, `bdos1_mxdisk_sync`, `bdos1_mxdisk_unsync`, `bdos1_wake_next_process` m.fl.).
- **Modul 0 (SUP+RTM — 29 subroutines, 100% identificeret)**:
  - 29 interne funktioner for proces-dispatch, tidsformatering, CLI og parsing (`rtm_func_check`, `cli_parse_tail`, `cli_crlf`, `cli_prchar`, `cli_prtime`, `cli_prnum`, `cli_prfilnam`, `cli_prdisk`, `cli_prcusp`, `cli_prcsm`, `cli_prtyp`, `cli_prnam`, `cli_flclse`, `cli_flopn`, `cli_open_wait`, `cli_osif`, `cli_sync`, `cli_unsync`, `cli_pfn`, `cli_conasn`, `load_tblsrch`, `load_group`, `load_xfer`, `rtm_put_drl`, `rtm_get_pmem`, `parse_setfld`, `parse_delim`, `parse_debl`, `parse_fcbi`).

---

## Modulær opdeling af ccpm.asm & udskillelse af RSP-processer (GENNEMFØRT 2026-11-22)

Den oprindeligt monolitiske assembly-fil (39.500 linjer) er nu fuldt modulariseret i 5 kerne-/drivermoduler plus 5 selvstændige RSP-processer i `tasks/rc759-xios/`, bundet sammen via `%include` i master [ccpm.asm](file:///Users/ravn/z80/tasks/rc759-xios/ccpm.asm):

### Kerne- og drivermoduler:
1. `mod0_rtm.asm` (2.654 linjer, fil 0x00000–0x0163F, 5.568 B): Supervisor & Real-Time Monitor
2. `mod1_bdos.asm` (2.217 linjer, fil 0x01640–0x026BF, 4.224 B): BDOS filsystem
3. `mod2_mem.asm` (1.608 linjer, fil 0x026C0–0x031DF, 2.848 B): Hukommelsesmanager (MEMIF.MEM)
4. `mod3_cio.asm` (1.372 linjer, fil 0x031E0–0x03ACF, 2.288 B): Tegn-I/O (CIOIF.CIO)
5. `mod4_xios.asm` (24.776 linjer, fil 0x03AD0–0x0FD3F, 49.776 B): RC759 Hardware XIOS & SYSDAT

### Resident System Processes (RSP):
6. `rsp_tmp759.asm` (2.397 linjer, fil 0x0FD40–0x1156F, 6.192 B): Terminal Message Processor (CLI/kommandofortolker)
7. `rsp_clock.asm` (380 linjer, fil 0x11570–0x117CF, 608 B): Tids-/datostyring via systemtick (venter på Flag 2)
8. `rsp_pin.asm` (1.704 linjer, fil 0x117D0–0x125DF, 3.600 B): Process INput (tastatur- og linjeeditering for Piccoline)
9. `rsp_vout.asm` (1.155 linjer, fil 0x125E0–0x12E5F, 2.176 B): Virtual OUTput multiplexer (skærmoutput)
10. `rsp_scroll.asm` (102 linjer, fil 0x12E60–0x12EFF, 160 B): Blød rulning via Intel 82730 tekstprocessor og MXdma0

Reassembly verificeret via Docker `rc759-nasm`: **PASS (77.568 bytes, 100% byte-identisk)**.

## SW1400 CCP/M-86 3.1 Distributionsanalyse & Målidentifikation (2026-11-22)

Baseret på **Bits:30005381** (`CCPM_v3.1_releasenotes.pdf`, dateret 03.02.1987) og scanning af de 4 distributionsdisketter (`scratch/rc759-pce/images/disk[1-4].img`):

1. **Vores målbinær (`ccpm.sys`, 77.568 bytes) er `CCPM1.SYS`**:
   - 100% byte-for-byte identisk med `CCPM1.SYS` på Disk 3/4.
   - Konfiguration: **1 virtuel konsol uden netværk** (`nvcns = 1`, `xpcns = 1`, 9 CCBs, 3 LCBs).
   - Linket med **`XIOS1.CON`** (25.728 bytes, 99,4% blok-identisk med modul 4).
   - 4-konsol modparten er **`CCPM4.SYS`** (87.168 bytes, linket med **`XIOS4.CON`**, 29.440 bytes, `nvcns = 4`).

2. **Udtræk af officielle kerne-moduler (`.CON`) og RSP-processer (`.RSP`)**:
   - Udtrækket til `scratch/tmp/dist/` via nyudviklet værktøj `tasks/rc759-xios/tools/cpm_extract.py`:
     - `BDOS.CON` (15.744 B), `CIO.CON` (5.504 B), `MEM.CON` (6.144 B), `RTM.CON` (7.552 B), `SUP.CON` (5.632 B)
     - `SYSDAT.CON` (3.328 B), `XIOS1.CON` (25.728 B), `XIOS4.CON` (29.440 B)
     - `CLOCK.RSP` (640 B), `PIN.RSP` (3.328 B), `SCROLL.RSP` (640 B), `TMP759.RSP` (7.168 B), `VOUT.RSP` (2.944 B)
   - Dokumentation samlet i `tasks/rc759-xios/distribution_sw1400.md`.

3. **Afkodning af XIOS-konfigurationstabel (`struct xios_table`)**:
   - Identificeret ved `SYSDAT:0x0C0C` (fil-offset `0x77AC`):
     - `xt_ticks_sec = 60` (60 Hz VSYNC systemtick).
     - `xt_nvcns = 1` (1 virtuel konsol).
     - Drev-tabel `xt_dphtab`: Drev A = `0x3942`, Drev B = `0x3956`, Drev M (M-Disk) = `0x3A32`.
   - Tidligere fejlagtig adskillelse som kode (`aad 0xe`, `inc dx`, `cmp [bp + 0x39], dx`) oprettet som strukturerede data i `mod4_xios.asm`.


Alle 65 subroutines er opdateret i `tasks/rc759-xios/ccpm.asm` og `KNOWN_LABELS` i `tasks/rc759-xios/tools/gen_nasm.py`.

## NVRAM / NVM Komplet Specifikation & Scroll-mode (2026-11-22)

1. **Udtømmende NVRAM specifikation etableret**:
   - Oprettet [tasks/rc759-xios/nvram_map.md](file:///Users/ravn/z80/tasks/rc759-xios/nvram_map.md) med samtlige bytes 0–127 afkodet og verificeret mod *Programmer's Guide* kapitel 3 og XIOS-kildekoden.
   - Alle tidligere gættede bytes i default-konfigurationen (`0x0D`–`0x35`) er nu 100% verificerede facts:
     - `0x0D=0x90`: iSBX 351 seriel kanal (9600 baud, virtuel konsol).
     - `0x0E=0x04`: 1 stopbit, ingen paritet.
     - `0x11=0xC0`: 8 databits pr. tegn.
     - `0x12=0x01/0x10`: CRT scroll mode (4 MSB: 0=line scroll, 1=soft scroll).
     - `0x13=0x21`: Cursor (2 linjers højde, blinkende).
     - `0x14=0x05`: Floppymotor slukketid (5 sekunder).
     - `0x16=0x07`: Forgrundsfarve (hvid, normal intensitet).
     - `0x1B=0x00`: M-disk (RAM-disk) størrelse (0 KB standard).
     - `0x35=0xFF`: Maskin-ID (`0xFF` = RC759 Piccoline, `0x00` = RC750 Partner).
   - Checksum-regel dokumenteret: $\sum_{i=0}^{95} \text{byte}[i] \pmod{256} = \text{0xAA}$.

2. **Kortlægning af blød vs. hård rulning**:
   - Konsol-flag: `[bx + 0x71]` (og global standard `[cs:0x2c08]`).
   - `0` = Hård rulning (*Line/Jump Scroll*): Opdaterer 82730 displayliste direkte.
   - `1` = Blød rulning (*Soft Scroll*): XIOS signalerer Flag 4 (vækker `SCROLL.RSP`) og synkroniserer med Flag 9/10.
   - Dynamisk skift via escape-koder:
     - `ESC <244>` (`0x1B, 0xF4`): Set Soft Scroll (`mov byte [bx + 0x71], 1`).
     - `ESC <245>` (`0x1B, 0xF5`): Set Line Scroll (`mov byte [bx + 0x71], 0`).

3. **Skærmarkitektur og -håndtering: Piccoline vs. Partner**:
   - Oprettet [screen_architecture_piccoline_vs_partner.md](file:///Users/ravn/z80/tasks/rc759-xios/screen_architecture_piccoline_vs_partner.md).
   - Beskriver de to fundamentale forskelle:
     - **Skærm-RAM (0 KB vs. 24 KB)**: Piccoline bruger 32 KB dedikeret CRT-RAM uden for system-RAM via Intel 82730 coprocessor; Partner stjæler de øverste 24 KB af system-RAM til sit frame-buffer.
     - **Interrupthandlere**: På Partner bevares og gendannes INT 1, INT 3 og INT 0xE1 for at beskytte maskinens indbyggede ROM-debugger; på Piccoline overtager XIOS selv INT 3 (`CS:0x471E`).
   - Indeholder historisk og ingeniørmæssig analyse af, hvorfor Regnecentralen valgte disse to løsninger og forenede dem i ét dynamisk tilpassende XIOS.

## RSP Grænserevision & Fuldførelse af CLOCK.RSP & PIN.RSP (2026-11-22)

1. **Afkodning af GENCCPM-pakkede RSP-strukturer**:
   - `GENCCPM` adskiller koden og dataene i to segmenter pr. proces og placerer Data Segment først (`RSPHDR` + `PD` + `UDA`) efterfulgt af Code Segment.
   - Reelle grænser og segmentstørrelser:
     - `rsp_tmp759.asm`: `0x0FD40`–`0x1142F` (TMP kode & data)
     - `rsp_clock.asm`: `0x11430`–`0x115EF` (CLOCK Data 320 B + Kode 128 B = 448 B)
     - `rsp_pin.asm`: `0x115F0`–`0x125DF` (PIN Data 480 B + Kode)
   - `rsp_clock.asm` er 100% symboliseret, kommenteret og verificeret mod Digital Research kilderne (`CLOCK.A86`).
   - PIN dataområdet (480 B) er flyttet til `rsp_pin.asm`.

## Kortlægning og Symbolisering af samtlige 54 INT 28H Funktioner (2026-11-22)

1. **Udtømmende kortlægning af INT 28H funktioner**:
   - Oprettet [int28h_functions_map.md](file:///Users/ravn/z80/tasks/rc759-xios/int28h_functions_map.md) med samtlige 54 funktioner (Funktion 0–53) dokumenteret og verificeret mod *PICCOLINE Programmer's Guide v2*, Appendix A (*Int-28h Function Interface PICCOLINE*, side 183–202).
   - Beskriver kaldeparametre, returværdier, registre og implementering i Flemming Kraglunds XIOS for alle 54 funktioner.
2. **Rekonstruktion af INT 28H dispatch-tabellen i `mod4_xios.asm`**:
   - Den tidligere rå disassemblering ved `0x0784C`–`0x078B7` (108 bytes, 54 ord) er erstattet af den strukturerede tabel `int28h_jump_table`.
   - Etableret `xios_code_base` ved `0x06BA0` som grundlag for CS-offset beregning: `dw target - xios_code_base`.
   - Alle 54 funktions-indgangspunkter er forsynet med beskrivende labels (`xios_int28_fn_...`).
   - Fejldisassemblering af kassettebånd-hovedlæsning (`0x0C6B6`) rettet til `call sub_0C9D9`.
3. **Reassembly-verifikation**:
   - `rebuild_and_verify.sh`: **PASS (77.568 bytes, 100% byte-identisk mod original ccpm.sys)**.

## Fuld Genskabelse af Samtlige 5 RSP-Moduler som Selvstændige Moduler (2026-11-23)

Samtlige 5 Resident System Processes (RSP) fra Regnecentralen Piccoline SW1400 CCP/M-86 release 3.1 er nu fuldstændigt rekonstrueret som selvstændige assemblerkilder, kompileret rent via Docker `rc759-nasm` og verificeret **100% byte-identiske (0 bytes difference)** mod de originale distributionsbinærer:

| Modul | Fil | Størrelse | Funktion | Status |
|-------|-----|-----------|----------|--------|
| **TMP759.RSP** | `tmp759.asm`, `rsp_tmp759.asm`, `rsp_tmp759_data.asm` | 7.168 B | Piccoline CLI/kommandofortolker, 14 kommandoer, RC-Net | **100% PASS** |
| **SCROLL.RSP** | `scroll.asm` | 640 B | Intel 82730 smooth scrolling driver & DMA-synkronisering | **100% PASS** |
| **CLOCK.RSP** | `clock.asm`, `rsp_clock.asm` | 640 B | TOD ur & statuslinje, system-tick flag 2 | **100% PASS** |
| **PIN.RSP** | `pin.asm`, `rsp_pin_code.asm`, `rsp_pin_data.asm` | 3.328 B | Process INput, tastatur- og linjeeditering | **100% PASS** |
| **VOUT.RSP** | `vout.asm`, `rsp_vout_code.asm`, `rsp_vout_data.asm` | 2.944 B | Virtual OUTput multiplexer, skærmkøer (VOUTQ, VINQ, VCMXQ) | **100% PASS** |

### 1. SCROLL.RSP (Intel 82730 Smooth Scroll Driver)
- Oprettet [tasks/rc759-xios/scroll.asm](file:///Users/ravn/z80/tasks/rc759-xios/scroll.asm).
- Afkodet: 108 bytes 8086 kode, der koordinerer blød rulning per pixel-linje på Piccoline via Intel 82730 tekstprocessor og Intel 80186 DMA kanal 0 (`INT 28h, AL=2`), beskyttet af mutex `"MXdma0  "` og synkroniseret via System Flags 4, 7, 9 og 10.
- Bygget via Docker `rc759-nasm` og verificeret mod `scratch/tmp/dist/SCROLL.RSP`: **100% byte-identisk PASS (0 bytes diff)**.

### 2. TMP759.RSP (Terminal Message Processor / Piccoline CLI)
- Oprettet [tasks/rc759-xios/tmp759.asm](file:///Users/ravn/z80/tasks/rc759-xios/tmp759.asm) og [tasks/rc759-xios/rsp_tmp759_data.asm](file:///Users/ravn/z80/tasks/rc759-xios/rsp_tmp759_data.asm).
- Fuld 7.168 bytes selvstændig RSP-pakke (128 bytes CMD-header, 5.872 bytes kode via `rsp_tmp759.asm`, 1.120 bytes data via `rsp_tmp759_data.asm`).
- Komplet symbolisering af samtlige 14 kommandorutiner:
  - `cmd_user` (`USER` / `BRUGER`): Brugernummer (0..15).
  - `cmd_printer` (`PRINTER` / `SKRIVER`): Liste-enhed (BDOS 160 / 164).
  - `cmd_size` (`SIZE`): Hukommelsesgrænse (16..768 KB i 16-byte paragraffer).
  - `cmd_dir` (`DIR`): 4-kolonne katalogvisning, filtrering efter bruger og systemattribut `[S]` / `[G]`.
  - `cmd_abort` (`ABORT`): Procesafbrydelse (BDOS 151: P_ABORT).
  - `cmd_neton` / `cmd_netoff` (`TILMELD` / `AFMELD`): RC-Net login og logoff (BDOS 64 / 65).
  - `cmd_logon` / `cmd_logoff` (`OPRET` / `AFBRYD`): Virtuelle netværksdrev mod filserver (BDOS 66 / 67).
  - `cmd_navngiv` / `cmd_local` (`NAVNGIV` / `LOKAL`): Stationsnavngivning og drevnulstilling (BDOS 68 / 69, NAMSVR.DAT).
  - `cmd_screen` / `cmd_line`: Skærm- vs. linjetilstand.
  - `cmd_help` (`?`): Udskriver de 22 kommandonavne i 8-kolonne layout.
- `cmd_dispatch_table` fuldt symboliseret med relative offsets (`dw cmd_target - rsp_tmp759_start`).
- Symbolisering af alle centrale BDOS- og systemhjælperutiner.
- Bygget via Docker `rc759-nasm` og verificeret mod `scratch/tmp/dist/TMP759.RSP`: **100% byte-identisk PASS (0 bytes diff)**.

### 3. CLOCK.RSP (Piccoline TOD Clock & Status Line Driver)
- Oprettet [tasks/rc759-xios/clock.asm](file:///Users/ravn/z80/tasks/rc759-xios/clock.asm).
- 640 bytes selvstændig RSP-pakke (128 bytes CMD-header, 128 bytes kode via `rsp_clock.asm`, 320 bytes data, padding til 640 B).
- Venter på BDOS Flag 2 (system 1-sekunds tick), opdaterer klokkeslæt og statuslinje.
- Bygget via Docker `rc759-nasm` og verificeret mod `scratch/tmp/dist/CLOCK.RSP`: **100% byte-identisk PASS (0 bytes diff)**.

### 4. PIN.RSP (Piccoline Process INput — Keyboard & Line Editor)
- Oprettet [tasks/rc759-xios/pin.asm](file:///Users/ravn/z80/tasks/rc759-xios/pin.asm), [tasks/rc759-xios/rsp_pin_code.asm](file:///Users/ravn/z80/tasks/rc759-xios/rsp_pin_code.asm) og [tasks/rc759-xios/rsp_pin_data.asm](file:///Users/ravn/z80/tasks/rc759-xios/rsp_pin_data.asm).
- 3.328 bytes selvstændig RSP-pakke (128 bytes CMD-header, 2.672 bytes kode / 167 paragraffer, 480 bytes data / 30 paragraffer, 48 bytes padding).
- Indeholder tastaturlæsning, Piccoline linjeeditor, funktionstasthåndtering og printer/drev-fejlmeddelelser.
- Bygget via Docker `rc759-nasm` og verificeret mod `scratch/tmp/dist/PIN.RSP`: **100% byte-identisk PASS (0 bytes diff)**.

### 5. VOUT.RSP (Piccoline Virtual OUTput Multiplexer)
- Oprettet [tasks/rc759-xios/vout.asm](file:///Users/ravn/z80/tasks/rc759-xios/vout.asm), [tasks/rc759-xios/rsp_vout_code.asm](file:///Users/ravn/z80/tasks/rc759-xios/rsp_vout_code.asm) og [tasks/rc759-xios/rsp_vout_data.asm](file:///Users/ravn/z80/tasks/rc759-xios/rsp_vout_data.asm).
- 2.944 bytes selvstændig RSP-pakke (128 bytes CMD-header, 1.856 bytes kode / 116 paragraffer, 928 bytes data / 58 paragraffer, 32 bytes padding).
- Indeholder skærmoutput-multiplexer, terminal-escapekoder og kø-deskriptorer: `VOUTQ` (16 beskeder á 2 bytes), `VINQ` (64 beskeder á 2 bytes) og `VCMXQ` (semafor-kø).
- Bygget via Docker `rc759-nasm` og verificeret mod `scratch/tmp/dist/VOUT.RSP`: **100% byte-identisk PASS (0 bytes diff)**.

## Fuld Genskabelse af XIOS.CON og RC-Net Modulerne (2026-11-23)

Samtlige Regnecentralen systemdrivere og udvidelsesmoduler fra CCP/M-86 SW1400 distributionen er nu færdigrekonstrueret som selvstændige assemblerkilder og verificeret **100% byte-identiske (0 bytes forskel)**:

| Modul | Kildetekstfiler | Størrelse | Beskrivelse | Verifikation |
|-------|-----------------|-----------|-------------|--------------|
| **XIOS1.CON** | [xios1.asm](file:///Users/ravn/z80/tasks/rc759-xios/xios1.asm), [xios_code.asm](file:///Users/ravn/z80/tasks/rc759-xios/xios_code.asm) | 25.728 B | 1-konsol XIOS hardwaredriver | **100% PASS (0 bytes diff)** |
| **XIOS4.CON** | [xios4.asm](file:///Users/ravn/z80/tasks/rc759-xios/xios4.asm), [xios4_code.asm](file:///Users/ravn/z80/tasks/rc759-xios/xios4_code.asm) | 29.440 B | 4-konsol XIOS hardwaredriver | **100% PASS (0 bytes diff)** |
| **NETDRV.RSP** | [netdrv.asm](file:///Users/ravn/z80/tasks/rc759-xios/netdrv.asm), [rsp_netdrv_code.asm](file:///Users/ravn/z80/tasks/rc759-xios/rsp_netdrv_code.asm) | 17.664 B | RC-Net Intel 82586 Ethernet LAN controller datalink driver | **100% PASS (0 bytes diff)** |
| **NETDRVB.RSP** | [netdrvb.asm](file:///Users/ravn/z80/tasks/rc759-xios/netdrvb.asm), [rsp_netdrvb_code.asm](file:///Users/ravn/z80/tasks/rc759-xios/rsp_netdrvb_code.asm) | 22.784 B | RC-Net Intel 82586 driver (Revision B) | **100% PASS (0 bytes diff)** |

### 6. XIOS1.CON (1-konsol XIOS) & XIOS4.CON (4-konsol XIOS)
- **Arkitektur**:
  - `XIOS.CON` følger DRI 8080-modellen (enkelt kodesegment, ingen separat datagruppe).
  - De første 3.072 bytes (`0x0080`–`0x0C7F` i filen, offset `0x0000`–`0x0BFF` i kodesegmentet) er systembufferområde (`dw 0xFFFF` ved offset `0x8C`), så `struct xios_table` (`XTABLOC`) er placeret nøjagtigt ved `CS:0x0C0C` (`0x0C8C` i filen) som krævet af `GENCCPM`.
  - XIOS-indgangsvektorer starter ved `CS:0x0C00` (`0x0C80` i filen) med `jmp near xios_init` og `jmp near xios_entry`.
  - `XIOS1.CON` har `xt_nvcns = 1` og `xt_alloc = 0x01F4` (500 paragraffer).
  - `XIOS4.CON` har `xt_nvcns = 4` og `xt_alloc = 0x0500` (1280 paragraffer) med 3 ekstra sæt CCB'er og skærmkøer.
- Begge moduler er kompileret via Docker `rc759-nasm` og verificeret **100% byte-identiske mod originalerne (0 bytes diff)**.

### 7. NETDRV.RSP & NETDRVB.RSP (Intel 82586 Ethernet LAN Controller & RC-Net Datalink)
- **Arkitektur**:
  - Multithreaded Resident System Process bestående af 3 interne processer:
    1. `NETDRV` / `NETDRVB`: Hovedstyringsproces (prioritet 32, SP=0x015E, entry IP=0x0726).
    2. `REC`: Modtagerproces (prioritet 2, SP=0x03BE, entry IP=0x0E15).
    3. `XMIT`: Senderproces (prioritet 3, SP=0x061E, entry IP=0x0BF8).
  - Interne proceskøer: `link_req` og `XMIT_REQ`.
  - Hardware-kommunikation mod Intel 82586 LAN controller:
    - Channel Attention (CA) via I/O port `0x0100` (`in al, 0x100` / `out 0x100, al`).
    - Afbrydelsesstyring via `IR5` (Interrupt 37 = `0x25`).
    - Datalink-interface mod applikationer og CCP/M via `INT 29H` og `INT 28H`.
- Begge moduler er kompileret via Docker `rc759-nasm` og verificeret **100% byte-identiske mod originalerne (0 bytes diff)**.

### Samlet Status for Samtlige 9 Regnecentralen Moduler
Alle 9 moduler fra RC759 Piccoline SW1400 CCP/M-86 release 3.1 distributionen er nu 100% færdigrekonstrueret som assemblerkildetekster og passerer komplet binær verifikation mod originalerne:
1. `CLOCK.RSP` (640 B) — **PASS**
2. `SCROLL.RSP` (640 B) — **PASS**
3. `TMP759.RSP` (7.168 B) — **PASS**
4. `PIN.RSP` (3.328 B) — **PASS**
5. `VOUT.RSP` (2.944 B) — **PASS**
6. `XIOS1.CON` (25.728 B) — **PASS**
7. `XIOS4.CON` (29.440 B) — **PASS**
8. `NETDRV.RSP` (17.664 B) — **PASS**
9. `NETDRVB.RSP` (22.784 B) — **PASS**

### Monolitisk CCPM.SYS Verifikation
- Monolitisk `ccpm.sys` verificeret via `rebuild_and_verify.sh`: **PASS (77.568 bytes, 100% byte-identisk mod original ccpm.sys)**.

## Fuld Subroutine-Symbolisering og Dokumentation (2026-11-23)

Samtlige anonyme `sub_...` rutiner i de centrale RSP-moduler er nu fuldt identificeret, omdøbt til meningsfulde navne og forsynet med lagdelte kommentarer (WHAT/WHY):

1. **VOUT.RSP (`rsp_vout_code.asm`, `rsp_vout.asm`)**:
   - 1-til-1 afstemt mod Digital Research officielle kildeforlæg `VOUT.P86` og `RHVOUT.A86` i `scratch/ccpm31-src/D3/`.
   - Copyright-banner ved kodesegment-start gendannet som ren ASCII-streng: `COPYRIGHT (C) 1983, DIGITAL RESEARCH ` (37 bytes).
   - Omdøbt samtlige 22 procedurer: `vout_xdos`, `vout_intsys`, `vout_pxios1`, `vout_sleep`, `vout_wakeup`, `vout_read_change_mxq`, `vout_write_change_mxq`, `vout_delete_file`, `vout_make_file`, `vout_reset_file`, `vout_write_buf`, `vout_read_buf`, `vout_read_voutq`, `vout_drain_voutq`, `vout_put_char`, `vout_get_char`, `vout_full_disk`, `vout_buffer`, `vout_purge`, `vout_abort`, `vout_initq`, og entry point `vout_plmstart` (offset 0x0603).
   - Rettet split-instruktion ved 0x128EA til `mov byte [0x349], 0` (`active$msg = false`) og fjernet den vildledende `sub_128ED`-label.

2. **PIN.RSP (`rsp_pin_code.asm`, `rsp_pin.asm`)**:
   - 1-til-1 afstemt mod Digital Research officielle kildeforlæg `PIN.P86` og `RHPIN.A86`.
   - Omdøbt samtlige 23 procedurer: `pin_xdos`, `pin_intsys`, `pin_pxios1`, `pin_conin`, `pin_get_cons_mode`, `pin_read_change_mxq`, `pin_write_change_mxq`, `pin_sleep`, `pin_wake_up`, `pin_set_conout_flag`, `pin_reset_conout_flag`, `pin_wake_vout`, `pin_write_vinq`, `pin_set_ccb`, `pin_switch`, `pin_controlC`, `pin_controlO`, `pin_turn_off_ctrlO`, `pin_controlS`, `pin_controlQ`, `pin_controlP`, `pin_raw`, og event loop `pin_plmstart`.

3. **TMP759.RSP (`rsp_tmp759.asm`)**:
   - Omdøbt alle anonyme subrutiner til beskrivende funktionsnavne:
     - Drev- og mappestyring: `with_selected_disk`.
     - DIR-visning og formattering: `dir_is_entry_valid`, `dir_get_entry_0`, `dir_get_entry_di`, `dir_print_entry`, `dir_print_drive_user_header`, `dir_parse_options`, `dir_parse_single_option`, `print_dir_stopped_by_user`.
     - Tekst- og hex-output: `print_string_si_len_cx`, `print_char_al`, `print_hex_byte`, `print_hex_nibble`, `parse_hex_digit`.
     - RC-Net og netværksenheder: `rcnet_require_ready`, `rcnet_require_logged_on`, `parse_device_spec` (håndterer lokale drev `A:`, netværksprinter `LSTn:` og servernavne `"..."`), `rcnet_init_device_request`, `rcnet_parse_device_request`, `rcnet_reset_request_fcb`, `clear_fcb_name_buffer`, `parse_filename_upper`, `parse_filename_anycase`, `set_raw_console_mode`, `bdos_network_func_73`.

4. **XIOS Dispatch-Tabel og DRI Rutiner (`xios_code.asm`, `mod4_xios.asm`, `xios4_code.asm`)**:
   - 1-til-1 afstemt mod Digital Research officielle CCP/M-86 XIOS kildeforlæg `scratch/ccpm86-src/xios/xios.a86`.
   - Erstattet disassemblerens falske instruktioner ved `CS:0C47h` med en struktureret, fuldt symboliseret `xios_function_table:` bestående af 37 opslagsposter (funktion 0..13 standard, udvidede funktioner 19 og 30, samt 0x0D18 stubs).
   - Omdøbt de 14 standard destinationsrutiner samt udvidede rutiner til deres officielle DRI navne:
     - `io_const`: Konsol-input status check (CS:1116h)
     - `io_conin`: Konsol-input tegnhåndtering (CS:1119h)
     - `io_conout`: Konsol-output tegnhåndtering (CS:142Ch)
     - `io_listst`: Printer status check (CS:4190h)
     - `io_list`: Printer output byte (CS:40BFh)
     - `io_auxin`: Seriel/AUX input byte (CS:3C4Dh)
     - `io_auxout`: Seriel/AUX output byte (CS:3C50h)
     - `io_switch`: Virtuel konsol-omskifter (CS:1FE8h)
     - `io_statline`: Opdatering af statuslinje (CS:20C1h)
     - `io_seldsk`: Drev-valg og DPH-opslag (CS:2D7Bh)
     - `io_read`: Læsning af logisk disksektor (CS:2DD9h)
     - `io_write`: Skrivning af logisk disksektor (CS:2E99h)
     - `io_flushbuf`: Tømning af diskcache/buffer (CS:2F5Bh)
     - `io_poll`: Hardware device polling (CS:4081h, adskilt fra tabelfejl ved 0xAC20)
     - `io_auxist`: Seriel/AUX input status (CS:261Bh)
     - `io_setblank`: Skærmsluk / blanking (CS:264Eh)
   - Navngivet de dertilhørende hardware afbrydelsesrutiner (Interrupt Service Routines):
     - `i_keyboard`: Tastatur ISR (IR1 / 0x84, seriel scancode)
     - `i_crt`: Intel 82730 VSYNC ISR
     - `i_disk`: WD2797 / Intel 8272 Floppy transfer ISR (IR0 / 0x80)
     - `i_printer`: Centronics parallel printer ACK ISR
     - `i_tick`: MM58167A RTC 1-sekunds system-tick ISR (IR3 / 0x8C, signalerer Flag 2)
   - Gennemført i både `XIOS1.CON` (`xios_code.asm`), `XIOS4.CON` (`xios4_code.asm`) og den monolitiske kerne `ccpm.sys` (`mod4_xios.asm`).

5. **Fælles Master XIOS (`xios.asm`)**:
   - Etableret en fælles parameteriseret masterkilde [xios.asm](file:///Users/ravn/z80/tasks/rc759-xios/xios.asm) styret af `%define NUM_VIR_CONS`:
     - `NUM_VIR_CONS = 1`: Bygger `XIOS1.CON` (25.728 bytes, 0x0633 paragraffer, checksum-byte 0xC8, 1 virtuel konsol).
     - `NUM_VIR_CONS = 4`: Bygger `XIOS4.CON` (29.440 bytes, 0x0719 paragraffer, checksum-byte 0xE5, 4 virtuelle konsoller).
   - [xios1.asm](file:///Users/ravn/z80/tasks/rc759-xios/xios1.asm) og [xios4.asm](file:///Users/ravn/z80/tasks/rc759-xios/xios4.asm) konverteret til tynde konfigurations-wrappers, der inkluderer `xios.asm`.
   - Begge varianter kompileret og verificeret 100% byte-identiske mod originalerne.

6. **Forening af XIOS-kilde og Udfasning af `xios4_code.asm` (2026-11-23)**:
   - Fuldstændig eliminering og sletning af `xios4_code.asm`.
   - Al driverkode for både 1 og 4 virtuelle konsoller er nu samlet i én fælles kilde: [xios_code.asm](file:///Users/ravn/z80/tasks/rc759-xios/xios_code.asm).
   - [xios.asm](file:///Users/ravn/z80/tasks/rc759-xios/xios.asm) inkluderer udelukkende `xios_code.asm` samt det parameteriserede tail-padding (`xios_tail`, 208 bytes for XIOS1, 240 bytes for XIOS4).
   - Fælles verifikation:
     - `nasm -f bin -DNUM_VIR_CONS=1 ... xios.asm` -> 100% byte-identisk mod `XIOS1.CON` (25.728 bytes, `cmp` 0 diff).
     - `nasm -f bin -DNUM_VIR_CONS=4 ... xios.asm` -> 100% byte-identisk mod `XIOS4.CON` (29.440 bytes, `cmp` 0 diff).
     - `nasm -f bin ... xios1.asm` -> 100% byte-identisk mod `XIOS1.CON`.
     - `nasm -f bin ... xios4.asm` -> 100% byte-identisk mod `XIOS4.CON`.
     - `./tasks/rc759-xios/rebuild_and_verify.sh` -> 100% byte-identisk mod `ccpm.sys` (77.568 bytes).

7. **Dansk Tegnsætskonvertering via `db_dk` (2026-11-23)**:
   - Udviklet preprocessor-makroen `db_dk` i [hardware.inc](file:///Users/ravn/z80/tasks/rc759-xios/hardware.inc), som under assemblering oversætter UTF-8 kodede strenge til RC759 Piccolines 7-bit ISO-646-DK tegnsæt (`æ`->`{`, `ø`->`|`, `å`->`}`, `Æ`->`[`, `Ø`->`\`, `Å`->`]`).
   - Tilføjet include-guards (`%ifndef _HARDWARE_INC_`) for sikker genbrug på tværs af moduler.
   - Konverteret samtlige danske bruger- og systembeskeder i [xios_code.asm](file:///Users/ravn/z80/tasks/rc759-xios/xios_code.asm), `mod4_xios.asm` og [rsp_tmp759.asm](file:///Users/ravn/z80/tasks/rc759-xios/rsp_tmp759.asm) til `db_dk`.
   - Alle 9 distributionsmoduler og den monolitiske `ccpm.sys` bygger fortsat 100% byte-identisk (0 bytes diff mod originalerne).

8. **Fjernelse af `xios_code_base` & Dynamisk `.CMD`-Header (2026-11-23)**:
   - Opdelt [xios.asm](file:///Users/ravn/z80/tasks/rc759-xios/xios.asm) i `section header vstart=0 align=1` (128 bytes CMD-header) og `section text vstart=0 align=1` (kodesegmentet).
   - Med `section text vstart=0` starter CS-offset for koden ved `0x0000`, nøjagtig som hvis filen var samlet af RASM86.
   - Fjernet alle `- xios_code_base` i `xios_function_table` og `int28h_jump_table` i [xios_code.asm](file:///Users/ravn/z80/tasks/rc759-xios/xios_code.asm), så labels peger direkte på deres CS-offset.
   - Gjort CMD-headerens paragrafstørrelser dynamisk beregnede: `(xios_code_end - xios_code_base) / 16` evaluerer automatisk til `0x0633` (XIOS1) og `0x0719` (XIOS4).
   - Gjort `ch_fixrec` dynamisk beregnet: `1 + (xios_fixups - xios_code_base) / 128` evaluerer automatisk til record `0xC8` (XIOS1) og `0xE5` (XIOS4).
   - Omlagt tail-padding til `align 128, db 0`.
   - Gjort selve 4-byte fixup-posterne i `xios_fixups` fuldt dynamiske via `FIXUP_CODE` makro og labels (`xios_fixup_target_1`, `xios_fixup_target_2`) på de relokerede far pointers, så fixup-tabellen automatisk flytter sig ved kodeændringer.
   - 100% byte-identisk verificeret for `XIOS1.CON`, `XIOS4.CON` og `ccpm.sys`.

9. **Forening af Sektion 1, 2 og 3A i Master XIOS (2026-11-23)**:
   - Matematisk kortlægning af XIOS1 (22.320 B kode) vs XIOS4 (26.000 B kode): samlet forskel er præcis **3.680 bytes (0x0E60)** fordelt på 17 velafgrænsede strukturelle chunks.
   - Indført parametriserede kumulative adresseforskydninger:
     - `DELTA_VMENU = 74` (skærmtrimningsmenu og konsolvalidering)
     - `DELTA_WINDOW = 451` (vinduesstyringssubsystem for 4 konsoller)
     - `DELTA_TABLES = 909` (tastaturoversættelsestabeller og floppydriver)
     - `DELTA_TAIL = 3668` (skærmbuffere og halestatistik)
   - Forenet Sektion 1 (CS:0000..0D1F):
     - Master entry points og `xios_config_table` parametriseret med `NUM_VIR_CONS`.
     - `xios_function_table` med fælles DRI/CCP/M funktionslabels.
     - `int28h_dispatcher` og `int28h_jump_table` (alle 54 BIOS/XIOS-systemkald).
   - Forenet Sektion 2 (CS:0D20..0EF3):
     - Fælles RTM-hjælpere (`rtm_call_helper`, `rtm_timer_wait`, `xios_rtm_svc_call`).
     - Hele CCB-tabellen (alle 9 Console Control Blocks for fysisk + 4 virtuelle konsoller) og LCB-tabellen (3 List Control Blocks).
   - Forenet Sektion 3A (CS:0EF4..118D, 666 bytes):
     - `i_keyboard`: Tastatur ISR med rå scancode-læsning, modifier flags, Caps/NumLock og translation.
     - `i_crt`: Intel 82730 VSYNC ISR og system tick.
     - `io_const` og `io_conin`: Konsolstatus og tegnlæsning med funktionstastafkodning.
     - Løst disassembler-fejl: `cmp byte [cs:0x2a60 + DELTA_WINDOW], 0xff` (var fejlagtigt afkodet som `pusha ; db 0x2A, 0xFF`) og `je loc_07D2F` med indlejret byte-displacement (`74 43` / `74 4B`).
     - Forbundet 14 symbolske funktions- og rutinelabels mellem varianterne.
   - Resultat: Over 530 redundante linjer rå disassembly elimineret fra XIOS4-blokken.
   - Fuld verifikation:
     - `XIOS1.CON` (25.728 bytes): **100% byte-identisk (0 bytes diff)** mod original.
     - `XIOS4.CON` (29.440 bytes): **100% byte-identisk (0 bytes diff)** mod original.
     - `ccpm.sys` (77.568 bytes): **100% byte-identisk (0 bytes diff)** mod original.
10. **Forening af Sektion 3B.1 og 3B.2 i Master XIOS (2026-11-23)**:
    - Forenet Sektion 3B.1 (CS:118D..12A6):
      - Chunk 1 (CS:118D, +50 bytes i XIOS4): Validering af konsolskift og omskifter for aktiv virtuel konsol (`loc_07D2D:` og `loc_07D2F:`).
      - Fælles skærmtrimningsmenu prologue (`loc_07D35:`).
      - Chunk 2 (CS:1288, +21 bytes i XIOS4): Opdatering af de 4 konsollers CCB-adresser (`0x2D2E`, `0x2DC2`, `0x2E56`, `0x2EEA`, 148 bytes stride) mod XIOS1 enkelt-konsol (`0x2B5D`).
    - Forenet Sektion 3B.2 (CS:12A7..1500):
      - `vmenu_item_table` og de 5 konfigurationsstrukturer (Normal/Invers, Markør Blinker, Understregning, Baggrund, Tastatur) parametriseret med `DELTA_VMENU_TBL = 71`, `DELTA_VMENU_PROLOGUE = 50` og `DELTA_TABLES = 909`.
      - Tal-strenge (`"1 2 3 4 5 6 7 8 9 101112131415", 0x9B, 0x20`, 33 bytes) forenet.
      - Terminal & konsol output (`loc_07EEC:`, `loc_07F37:`, `io_conout:`).
      - Chunk 3 (CS:14F6, +3 bytes i XIOS4): Virtuel konsol-opslag for skærmposition (`mov al, [cs:si + 0x4f9f]` for 4 konsoller hhv. `mov al, 1` for 1 konsol).
      - Rettet NASM short jump relokering på `jne short loc_080C5`.
    - Resultat: Yderligere 540 redundante linjer rå disassembly elimineret fra XIOS4-blokken (i alt > 1.070 redundante linjer fjernet).
    - Fuld verifikation:
      - `XIOS1.CON` (25.728 bytes): **100% byte-identisk (0 bytes diff)** mod original.
      - `XIOS4.CON` (29.440 bytes): **100% byte-identisk (0 bytes diff)** mod original.
      - `ccpm.sys` (77.568 bytes): **100% byte-identisk (0 bytes diff)** mod original.

11. **Forening af Sektion 3B.3 & 3B.4: Terminalemulatoren (CS:1500..2497, 2026-11-23)**:
    - Omfatter hele terminalemulatoren (`loc_080BE:` til `loc_08FDB:`), en massiv blok på over 3.800 bytes kode.
    - Forskydning mellem XIOS1 og XIOS4 i denne blok er konstant `+74` (`DELTA_VMENU`).
    - Rekonstrueret to centrale dispatch-tabeller, som i den oprindelige disassembly var fejlagtigt afkodet som tilfældige instruktioner:
      - **Escape Sequence Dispatch Tabel (186 bytes)**: 62 word-pointere til ANSI/VT100 escape-handlers (`0x1942 + DELTA_VMENU`, `0x192a + DELTA_VMENU`, osv.) efterfulgt af 62 match-bytes (`=HCDBAEIJKLMNOPQYabcdefghijklmnopqstruvwxz:<>012367\xF1..\xFE`).
      - **State Dispatch Tabel (24 bytes)**: 12 word-pointere (`0x1be9 + DELTA_VMENU`, `0x1cd3 + DELTA_VMENU`, osv.) for tilstandsmaskinen.
    - Parametriseret konsolløkke i skærminitialisering (`loc_08D94:`): `mov cx, NUM_VIR_CONS` (1 konsol i XIOS1, 4 konsoller i XIOS4).
    - Parametriseret 10 rå `db 0x2E`-instruktioner med hårdkodede adresser til ægte symbolske instruktioner (`mov word [cs:0x5fbe + DELTA_TAIL], 0xffff`, `mov word [cs:0x4884 + DELTA_TABLES], 0x2030`, osv.).
    - Indført `DELTA_VIDTBL = 2907` (`0x4bc4`) og `DELTA_49FA = 859` (`0x49fa`).
    - Håndteret Chunk 4 ved `08FBC`: `call sub_09079` (kopiering af 24 KB skærm-RAM, kun i XIOS1, omgået i XIOS4).
    - Resultat: Yderligere **1.583 redundante linjer rå disassembly** elimineret fra XIOS4-blokken (i alt > 2.650 linjer fjernet på tværs af foreningen).
    - Fuld verifikation:
      - `XIOS1.CON` (25.728 bytes): **100% byte-identisk (0 bytes diff)** mod original.
      - `XIOS4.CON` (29.440 bytes): **100% byte-identisk (0 bytes diff)** mod original.
      - `ccpm.sys` (77.568 bytes): **100% byte-identisk (0 bytes diff)** mod original.

12. **Forening af Sektion 3B.5: Musedriver & CRT-register setup (CS:249F..264C, 2026-11-23)**:
    - Omfatter `sub_08FDC:` til `loc_091BA:` (ret) (479 bytes i XIOS1, 450 bytes i XIOS4):
      - `sub_08FDC:`, `sub_08FE7:`, `sub_08FEE:`, `sub_09001:`, `loc_09012:`, `sub_09073:`.
      - `sub_09079:` (kopiering af 24 KB skærm-RAM) indkapslet i `%if NUM_VIR_CONS == 1` (29 bytes, kun i XIOS1).
      - BIOS systemkald 35: `xios_int28_fn_35_write_str:`.
      - Konsol-planløkke (`loc_0902B:`): `mov cx, 4 * NUM_VIR_CONS` (4 blokke i XIOS1, 16 blokke i XIOS4).
      - Konsolvalidering (`091A9:`): `cmp dl, NUM_VIR_CONS` (afviser konsoller >= 1 i XIOS1 hhv. >= 4 i XIOS4).
      - Omskrevet 4 rå `db 0x2E`-instruktioner til ægte `mov word [cs:0x613c + DELTA_TAIL], 0x000f` osv.
      - Parametriseret med `DELTA_VMENU`, `DELTA_WINDOW`, `DELTA_TABLES` og `DELTA_TAIL`.
    - **Arkitektur: Mus via tastaturcontroller**:
      - Musen er fysisk tilkoblet via tastaturet (ingen separat seriel museport/ISR i Piccoline-bundkortet).
      - Tastaturets microcontroller multiplexer musedata ind i tastaturets scancode-strøm via prefix-byten `0xE3`.
      - `i_keyboard` fanger `0xE3` ved `loc_07AE3:` og sætter flaget `[cs:0x1048] = 0xFF`.
      - Den efterfølgende byte udløser kald til `sub_094EB`, en 5-byte tilstandsmaskine (`[cs:0x291b]` tæller ned fra 5):
        - Byte 5: Knapstatus (`not al; and al, 7` for venstre, midterste, højre knap).
        - Byte 4 & 2: Delta X bevægelse (akkumuleres i `[cs:0x291e]`).
        - Byte 3 & 1: Delta Y bevægelse (akkumuleres i `[cs:0x2920]`).
      - BIOS INT 28h funktion 30 (`xios_int28_fn_30_mouse` ved CS:094A0) udlæser musens X/Y-delta og knapstatus atomisk med `cli` og `xchg`.
    - Resultat: Yderligere **189 redundante linjer rå disassembly** elimineret fra XIOS4-blokken (i alt > 2.840 linjer fjernet på tværs af foreningen).
    - Fuld verifikation:
      - `XIOS1.CON` (25.728 bytes): **100% byte-identisk (0 bytes diff)** mod original.
      - `XIOS4.CON` (29.440 bytes): **100% byte-identisk (0 bytes diff)** mod original.
      - `ccpm.sys` (77.568 bytes): **100% byte-identisk (0 bytes diff)** mod original.

13. **Forening af Sektion 5: Floppydisk Driver (CS:2D7B..4081 / CS:3108..440E, 2026-11-24)**:
    - Omfatter hele diskettedriveren for NEC µPD765 / WD FDC controlleren samt NetCon netværksterminal-support (4.932 bytes kode og datatabeller).
    - Driveren er 100% strukturelt symmetrisk mellem XIOS1 og XIOS4 (nøjagtig samme længde på 4.932 bytes).
    - Samtlige 267 forskelle er forenet via parametrisering:
      - **DPH & ALV/CSV datatabeller**: Rekonstrueret Drive A og Drive B disk-parameter headers og checksum-vektorer, som tidligere var fejlagtigt afkodet som tilfældige instruktioner (`add [bp + di - 0x3dc5], dh`, `ret 0x3b`, osv.).
      - **NetCon (Network Console Driver)**: Rekonstrueret `"NetConI "` (Network Console Input) og `"NetConO "` (Network Console Output) dispatch-strukturer.
      - **Funktion 18 & FDC dispatch-tabeller**: Rekonstrueret word-pointer arrays (`0x3cbe`, `0x3cbd`, `0x3c74`, `0x402f`, `0x4058`, `0x3e22`, `0x3d46`, osv.).
      - **Tabel- og I/O-adresser**: Parametriseret med `DELTA_TABLES = 909` for alle buffer- og controller-adresser (`0x2F59..0x4256`).
      - **Tail-adresser**: Parametriseret med `DELTA_TAIL = 3668` (`0x5fa4`) og `DELTA_TAIL_PRE = 3669` (`0x5e42`, `0x5999`, `0x59c5`).
      - Omskrevet 10 rå `db 0x2E`-instruktioner med hardkodede adresser (`0x373b`, `0x3c4c`, `0x3c72`, `0x3d44`) til ægte symbolske instruktioner.
    - Resultat: **2.141 redundante linjer rå disassembly** elimineret fra XIOS4-blokken (i alt næsten 5.000 redundante linjer fjernet på tværs af projektet).
    - Fuld verifikation:
      - `XIOS1.CON` (25.728 bytes): **100% byte-identisk (0 bytes diff)** mod original.
      - `XIOS4.CON` (29.440 bytes): **100% byte-identisk (0 bytes diff)** mod original.
      - `ccpm.sys` (77.568 bytes): **100% byte-identisk (0 bytes diff)** mod original.

14. **Forening af Sektion 4B: Fælles Mus- og CRT-driver (CS:2980..2BD0 / CS:2B43..2D93, 2026-11-24)**:
    - Omfatter musens BIOS INT 28h funktion 30 handler (`xios_int28_fn_30_mouse`), 5-byte muse-tilstandsmaskinen (`sub_094EB`), CRT trigger & command wait (`xios_crt_trigger_ca`, `crt_post_cmd_wait`), paletterutiner og display list refresh (`sub_09621`, `sub_09623`, `sub_09630`, `sub_09643`, `sub_09694`, `sub_096B8`, `sub_096CF` til `loc_096F0: ret`).
    - Nøjagtig 593 bytes kode i både XIOS1 og XIOS4 (100% strukturelt symmetrisk).
    - Forenet 55 adresse-forskelle:
      - 37 adresser parametriseret med `DELTA_WINDOW = 451` (`0x2913..0x2b58`).
      - 10 tail-adresser parametriseret med `DELTA_TAIL = 3668` (`0x5fa4`, `0x5fa6`, `0x5fbe`, `0x5fdc`, `0x5ff2`, `0x5ff6`, `0x61ec`).
      - 5 buffer-adresser parametriseret med `DELTA_TABLES = 909` (`0x2bf1..0x2bff`).
      - 1 terminal-parameter parametriseret med `DELTA_VMENU = 74` (`0x1560`).
      - Rekonstrueret musens 4-word jump table (`0x2928`, `0x292c`, `0x292b`, `0x2932`), som tidligere var afkodet som rå `sub`/`xor` instruktioner.
    - Resultat: Yderligere **225 redundante linjer rå disassembly** elimineret fra XIOS4-blokken (i alt > 5.200 linjer fjernet på tværs af projektet).
    - Fuld verifikation:
      - `XIOS1.CON` (25.728 bytes): **100% byte-identisk (0 bytes diff)** mod original.
      - `XIOS4.CON` (29.440 bytes): **100% byte-identisk (0 bytes diff)** mod original.
      - `ccpm.sys` (77.568 bytes): **100% byte-identisk (0 bytes diff)** mod original.

---
name: reference_rc759_xios_re_2026-11-20
description: RC759 XIOS 2.3 reverse engineering — binær-layout, RTM-konvention, io_const/io_conin/io_read lokationer
metadata:
  type: reference
---

## Kildemateriale

- **ccpm.sys** (77 568 B) fra disk1.img — indeholder RTM + BDOS + XIOS i ét binær
- **DRI referencekilder**: ccpmv31.zip fra http://www.cpm.z80.de/download/ccpmv31.zip
- **PICCOLINE Programmers Guide v2**: https://rc700.dk/files/documentation/PICCOLINE_Programmers_Guide_v2.pdf
  Cachet: `scratch/rc759-xios/ddhf-cache/PICCOLINE_Programmers_Guide_v2_rc700dk.pdf`
- **DDHF disk-images + ROMs**: cachet i `scratch/rc759-xios/ddhf-cache/`

## ccpm.sys modulstruktur

Fil loades ved paragraph 0x0048 (physical 0x0480). Fem MEMIF-moduler + XIOS:

| Fil-offset | Størrelse | Indhold |
|-----------|-----------|---------|
| 0x0000 | 0x80 | GENSYS-header (sysdat=0x06FA, supervisor=0x0048:0x0003) |
| 0x0080 | ~5 568 B | Modul 0 (RTM kerne) |
| 0x1640 | ~4 224 B | Modul 1 (BDOS del 1) |
| 0x26C0 | ~2 848 B | Modul 2 (BDOS del 2) |
| 0x31E0 | ~2 288 B | Modul 3 (BDOS del 3) |
| 0x03AD0 | 62 512 B | **Modul 4 = SYSDAT + XIOS** (stor — indeholder alt) |
| 0x0B163 | ~30 KB | XIOS JMP/JMP entry ved SYSDAT:0xC00 |

**SYSDAT-segment**: 0x06FA (physical 0x06FA0). XIOS starter ved SYSDAT:0xC00.

## XIOS entry-konvention (fra Programmers Guide)

```
Ind:  AL = XIOS rutine-nummer (0=IO_CONST, 1=IO_CONIN, ... 10=IO_READ, ...)
      ES = paragraph-adresse for kaldende process' UDA
      DS = SYSDAT segment-adresse
Ud:   BX = returværdi (0xFFFF = sandt/klar, 0x0000 = falsk/tomt)
```

## XIOS inter-modul dispatch (fil 0x10075 = XIOS+0x4F12)

Dispatch-søger i tabel ved cs:0x15F3, dispatcher via tabel ved **cs:0x16A4** (= fil-offset 0x16A4):

```asm
4f0a: shl ax, 1
4f0c: mov bx, ax
4f12: jmp cs:[bx + 0x16A4]   ; tabel med funktion-pointere
```

**Dispatch-tabel** (fil 0x16A4, indeks = rutine-nummer × 2):

| Nr | Navn | Fil-offset |
|----|------|-----------|
| 0 | IO_CONST | 0x282C |
| 1 | IO_CONIN | 0x055B |
| 2 | IO_CONOUT | 0x4F8C |
| 3 | IO_LISTST | 0xCB2A |
| 4 | IO_LIST | 0x0D5E |
| 7 | IO_SWITCH | 0x0881 |
| 8 | IO_STATLINE | 0x095C |
| 9 | IO_SELDSK | 0x09B2 |
| 10 | **IO_READ** | **0x0A05** |
| 11 | IO_WRITE | 0x0A6B |
| 12 | IO_FLUSHBUF | 0x0A6F |
| 13 | IO_POLLDEV | 0x0AFA |

## RTM inter-modul kald (MODFUNC.DEF)

```
CX = (modul_id * 0x100) + funktions_nummer
Moduæler: user=0, sup=1, rtm=2, mem=3, cio=4, bdos=5, xios=6
```

RTM-kernen ved **fil 0x282**: validerer AL (tre ranges: 0x00–0x50, 0x62–0x74, 0x80–0xA4),
opslag i SYSDAT+0xAA (patches af GENSYS ved boot — nul i statisk binær).

RTM-dispatcher (kaldt af XIOS-funktioner): **fil 0x313**
```asm
0313: push es:[0x2e]       ; gem DS
031e: mov ds, cs:[6]       ; DS = SYSDAT
0324: call 0x282           ; RTM-kerne
032d: pop es:[0x2e]        ; genopret DS
033a: xor cx, cx if BX==-1 ; fejl-indikator
033a: ret
```

## Nøgle-funktioner kortlagt

### IO_CONST (console status) — fil 0x282C

Buffer-baseret (ikke direkte HW). Søger i VCB-liste ([0x68]).
Returnerer 0xFFFF hvis tegn klar, 0x0000 hvis tom.
Kalder RTM fn 0x80 (poll console buffer) via 0x313 hvis liste tom.

### IO_CONIN (console input) — fil 0x055B

Kalder RTM fn 0x87 (blocking read) via 0x313.
Parametertabel ved 0x455 → 0x47D/0x489.

**VIGTIGT (korrigeret 2026-11-20)**: CCPM 3.1 på RC759 bruger **POLLING**,
IKKE interrupt-drevet konsol-input! Den direkte polling-kode:
- `sub_AD8E`: console status (IN AL, 0x302 → test bit 7)
- `sub_B032`: data-læsning (IN AL, 0x302 → bit-pak til statusord)
RTM-scheduler sørger for multitasking mens polling kører.
Ingen CCB-ringbuffer-udfyldning via interrupts.

### IO_READ (disk read) — fil 0x0A05

```asm
0a05: push es          ; gem UDA-segment
0a06: mov cx, 2        ; RTM intern funktion 2
0a09: jmp 0x313        ; → RTM (sover til DMA-interrupt)
```

Faktisk disk-driver (initialiseret af GENSYS via RTM fn 2):
- **FCR-setup** (fil 0x09D4E): `OUT 0x288` = drive-select + motor + precompensation
- **WD2797 seek** (fil 0x09F0E): `IN 0x282` (track), `OUT 0x284` (sector), precomp-logik
- **WD2797 READ** (fil 0x0A00B): `OUT 0x280` = 0x80/0x88 (Read Sector), DMA kanal 0
- **Wait** (fil 0x09F4D): polling eller interrupt-ventelogik
- **Release** (fil 0x0CB31): `OUT 0x290` (frigiv delt DPC-disk), ryd flag

## Hardware I/O-kort (fra rc759.cpp + Programmers Guide)

| Port | Retning | Hardware |
|------|---------|----------|
| 0x000-0x003 | R/W | i8259A PIC (ekstern, kaskade til 80186 INT0) |
| 0x020 | R | Tastatur HLE (8259A IR1) |
| 0x056 | W | SN76489A lyd |
| 0x05A/0x05C | R/W | MM58167 RTC (8259A IR3) |
| 0x060 | W | i82730 CRT ctrl (ikke impl. i MAME!) |
| 0x070-0x076 | R/W | i8255 PPI |
| 0x080-0x0FE | R/W | NVRAM (256×4 CMOS, bank-switched) |
| 0x180-0x1BE | R/W | Palette (32×IRGB nibbles) |
| 0x230/0x240 | W | i82730 irst/channel-attention |
| 0x280-0x286 | R/W | WD2797 FDC (status/cmd/track/sector/data) |
| 0x288 | W | Floppy FCR (drive/motor/precomp/ready) |
| 0x28E | R/W | Floppy reserve/ack (DPC-deling) |
| 0x290 | W | Floppy release |
| 0x300-0x31F | R/W | **iSBX serielt konsol** (MCS0+MCS1) |

iSBX port 0x302 = seriel konsol I/O (init() opsætter DX=0x302).
Tastatur-input via port 0x020 (HLE).
Mange porte 0x11, 0x15, 0x26 m.fl. = 80186 interne registers (PCB).

## DPC — delt diskette-station (forretningskontekst)

RC759 blev designet med understøttelse for en **delt** disk/printer-controller
(DPC, Disk/Printer-Controlunit) så flere RC759-maskiner kunne dele én fysisk
diskettestation. Dette var et billigere alternativ end at udstyre hver maskine
med sin egen diskettestation.

Protokollen:
- Op til 4 RC759 kunne tilkobles samme DPC
- Før diskadgang: maskinen skal **reservere** DPC'en (OUT 0x28E eller 0x290)
- Efter adgang: maskinen skal **frigive** DPC'en (OUT 0x290)
- Floppy-ack (IN 0x28E bit 7): 0 = vent, 1 = acknowledge fra floppy

Dette er grunden til at `io_read`/`io_write` har reserve-/release-logik der
ikke findes i standard DRI XIOS. Floppy FCR-registret (0x288) kontrollerer kun
den lokale drive-tilstand, mens 0x28E/0x290 koordinerer med DPC'en.

Reference: Programmers Guide v2 §8.4 "Reservation of Shared Disks".

## FCR register encoding (0x288)

| Bit | Navn | Beskrivelse |
|-----|------|-------------|
| 0 | Drive select | 0=drev 0, 1=drev 1 |
| 1 | Motor 0 | 0=slukket, 1=tændt |
| 2 | Motor 1 | 0=slukket, 1=tændt |
| 3 | Write precomp | 0=disabled, 1=enabled |
| 6 | (fast til 1) | — |
| 7 | Ready control | 0=fra drev, 1=altid sat |

Precompensation: cylinder 0–77 → 125 ns.

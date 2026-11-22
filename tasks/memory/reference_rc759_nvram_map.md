---
name: reference_rc759_nvram_map
description: RC759 Piccoline Non-Volatile RAM (NVM/NVRAM) komplet 128-byte layout, checksum og standardværdier
metadata:
  type: reference
---

# RC759 Piccoline NVRAM / NVM Layout & Specifikation

Kilder:
- **RC759 Piccoline Programmer's Guide v2**, kapitel 3 (*The Nonvolatile Memory*, side 19–27).
- **MAME** driver (`src/mame/regnecentralen/rc759.cpp`).
- **PCE** emulator driver (`src/arch/rc759/rc759.c`).
- **XIOS kildekode** i [tasks/rc759-xios/mod4_xios.asm](file:///Users/ravn/z80/tasks/rc759-xios/mod4_xios.asm).
- Detaljeret byte-for-byte specifikation: [tasks/rc759-xios/nvram_map.md](file:///Users/ravn/z80/tasks/rc759-xios/nvram_map.md).

---

## 1. Hukommelsesområder & Checksum

NVRAM (128 bytes) er opdelt i tre logiske zoner:
1. **Bytes 0–47**: System-konfiguration (konsolparametre, serielle porte, disk, skærm).
2. **Bytes 48–95**: Reserveret / udvidelsesparametre.
3. **Bytes 96–127**: Brugerkonfiguration (permanent lagring for applikationer, bevares ved fabriksreset).

### Checksum-regel (Byte 0)
XIOS validerer NVRAM ved boot via sum-modulo-256 over de første 96 bytes (0–95):
$$\sum_{i=0}^{95} \text{byte}[i] \pmod{256} = \text{0xAA}$$
Hvis summen $\neq \text{0xAA}$, er NVRAM ugyldigt/korrupt, og standardkonfigurationen indlæses automatisk.

---

## 2. Kritiske Konfigurationsbytes

| Byte | Hex standard | Felt / Beskrivelse | Detaljer |
|---|---|---|---|
| **0** | `0x1B` | Checksum byte | Justeres så $\sum_{0}^{95} \equiv \text{0xAA} \pmod{256}$. |
| **1..4** | `0x00,0x00,0x00,0x00` | RTC tidsoffset | Tidsforskel i forhold til hardware realtidsur. |
| **5** | `0x00` | Netværks-bruger ID | Netværksadresse for RC-skolenetværk (0 = lokal maskine). |
| **6** | `0x00` | Bootenhed | 0 = Drev A (diskette), 1 = Drev B, 2 = Netværk/Harddisk. |
| **7..12** | Tekstparametre | Konsolopsætning | Tastaturlayout, printertype, paritet. |
| **13** | `0x90` | iSBX 351 baudrate | Seriel kanal baudrate (`0x90` = 9600 baud, 8 databits). |
| **14** | `0x04` | iSBX 351 framing | 1 stopbit, ingen paritet. |
| **17** | `0xC0` | Databitopsætning | 8 databits pr. tegn. |
| **18** | `0x01` / `0x10` | **Scroll mode** | **4 MSB afgør rulletype**:<br>- `0x00` = Line/jump scroll (hård rulning)<br>- `0x10` = Soft scroll (blød rulning via 82730 og `SCROLL.RSP`). |
| **19** | `0x21` | Cursor definition | Cursorhøjde (2 scanlines) og blinkende tilstand. |
| **20** | `0x05` | Floppymotor slukketid | Antal sekunder motoren kører efter sidste I/O (5 sekunder standard). |
| **22** | `0x07` | Skærm farve/attribut | Forgrundsfarve (hvid/grøn, normal intensitet). |
| **27** | `0x00` | M-disk størrelse | RAM-disk størrelse i 16 KB blokke (0 = ingen M-disk). |
| **53** | `0xFF` / `0x00` | **Maskin-ID** | **Hardwaretype**:<br>- `0xFF` = RC759 Piccoline<br>- `0x00` = RC750 Partner. |

---

## 3. Adgang via XIOS og BIOS

* **Lokal kopi i SYSDAT**: XIOS kopierer NVRAM til `SYSDAT:4896h` under boot.
* **INT 28H Funktion 3** (`get_nvram_copy`): Returnerer pointer `ES:BX = SYSDAT:4896h`.
* **Programmer's Guide**: Advarer mod direkte skrivning til NVRAM-hardwaren; applikationer skal anvende XIOS-tjenester for at bevare checksummen korrekt.

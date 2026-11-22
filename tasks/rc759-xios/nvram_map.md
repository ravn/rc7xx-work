# RC759 Piccoline — NVRAM / NVM Layout og Specifikation

Dette dokument er den autoritative reference for den ikke-flygtige parameterhukommelse (NVM / NVRAM) i **Regnecentralen RC759 Piccoline** (og søstermaskinen RC750 Partner).

Informationen er verificeret mod:
1. *PICCOLINE Programmer's Guide v2*, kapitel 3 (*Configuration*, s. 17–20 / OCR s. 25–32).
2. *PICCOLINE Brugervejledning*, afsnit 8.3.1 (*NVM fejl, ERROR 19*).
3. Kildetekst for CCP/M-86 3.1 XIOS (`tasks/rc759-xios/mod4_xios.asm`).
4. MAME- og PCE-emulatorernes drivere (`rc759.cpp`, `pce/src/arch/rc759/nvm.c`).

---

## 1. Hardware-arkitektur og adgang

| Egenskab | Værdi / Mekanisme |
|---|---|
| **Størrelse** | 256 nibbles (4-bit celler) = 128 bytes i alt |
| **Opdeling** | 4 blokke (blok 0, 1, 2, 3) á 64 nibbles (32 bytes pr. blok) |
| **Blok-valg (bank switch)** | Intel 8255 PPI Port C (I/O-port `0x0C`), bits 4–5 |
| **Nibble-adresser** | Jævne I/O-adresser `0x80`–`0xFE` (64 adresser med trin på 2) |
| **Nibble-rækkefølge** | Lige I/O-adresse (f.eks. `0x80`) = HØJ nibble (bits 7–4) af byte<br>Ulige I/O-adresse (f.eks. `0x82`) = LAV nibble (bits 3–0) af byte |
| **XIOS RAM-kopi** | Ved opstart indlæser XIOS hele NVM til RAM.<br>**Kald:** `INT 0x28, AL=3`<br>**Retur:** `ES:SI` peger på NVM RAM-kopien. |
| **Fil-override ved boot** | Hvis filen `KDEF.SYS` findes på opstartsdisken, indlæses dens indhold automatisk og overskriver NVM ved boot. |

---

## 2. Checksum-algoritme (0xAA)

NVM beskyttes af en checksum i **byte 0**, som dækker de første 3 blokke (blok 0, 1 og 2, dvs. bytes 0–95). Blok 3 (bytes 96–127) indgår ikke i checksummen.

* **Regel:** 
  $$\sum_{i=0}^{95} \text{byte}[i] \pmod{256} = \text{0xAA}$$
* **Fejlkode ved boot:** Hvis summen afviger fra `0xAA`, afbryder ROM-selvtesten med **`ERROR: 19`** (*NVM checksum fejl*).
* **Beregning af byte 0:**
  $$\text{byte}[0] = (\text{byte}[0] + \text{0xAA} - \text{sum}) \pmod{256}$$

---

## 3. Komplet byte-for-byte NVM Layout (Bytes 0–127)

| Offset (hex) | Offset (dec) | Standardværdi | Feltnavn / Betydning | Detaljeret bit-kodning og beskrivelse |
|---|---|---|---|---|
| `0x00` | 0 | `0xDF` | **NVM Checksum** | Værdien gør, at summen af bytes 0..95 modulo 256 er lig `0xAA`. |
| `0x01`–`0x02` | 1–2 | `0x00, 0x00` | **Type number** | RC maskintypekode. |
| `0x03`–`0x04` | 3–4 | `0x00, 0x00` | Reserveret | Nulstillet. |
| `0x05`–`0x06` | 5–6 | `0x00, 0x00` | **Serienummer** | Maskinens hardware-serienummer. |
| `0x07`–`0x0C` | 7–12 | `0x00...` | Reserveret | Fabriksreserveret. |
| `0x0D` | 13 | `0x90` | **Baud rate & kanalvalg** | **Bits 7–4 (Høj nibble):** Baud rate (Rx = Tx):<br>`0`: 75, `1`: 75, `2`: 110, `3`: 150, `4`: 300, `5`: 600, `6`: 1200, `7`: 2400, `8`: 4800, `9`: 9600 baud.<br>**Bits 3–0 (Lav nibble):** Kanalanvendelse:<br>`0`: Virtuel konsol<br>`1`: Printer |
| `0x0E` | 14 | `0x04` | **Stop-bits & paritet** | Format for iSBX 351 seriel kanal (svarer til Intel 8274 WR4):<br>**Bits 1–0:** Paritet (`0`: Ingen, `1`: Ulige/Odd, `3`: Lige/Even)<br>**Bits 3–2:** Stop-bits (`1`: 1 stopbit, `2`: 1.5 stopbits, `3`: 2 stopbits) |
| `0x0F` | 15 | `0x00` | **Initial RTS** | Initial tilstand for RTS (svarer til 8274 WR5):<br>**Bit 1:** `0` = Low, `1` = High. |
| `0x10` | 16 | `0x00` | Reserveret | Svarer til 8274 WR1. |
| `0x11` | 17 | `0xC0` | **Databits pr. tegn** | Bits pr. tegn (svarer til 8274 WR3):<br>**Bits 7–6:** `0`: 5 bits, `1`: 6 bits, `2`: 7 bits, `3`: 8 bits. |
| `0x12` | 18 | `0x01` el. `0x10` | **CRT Scroll Mode** | **Bits 7–4 (Høj nibble):** Skærm-rulletilstand:<br>`0x0_`: **Hård rulning** (*Line/Jump Scroll* — flytter en hel linje straks)<br>`0x1_`: **Blød rulning** (*Soft Scroll* — scanline-for-scanline via `SCROLL.RSP`)<br>*(Bits 3–0 er reserveret).* |
| `0x13` | 19 | `0x21` | **Cursor-parametre** | **Bits 7–4 (Høj nibble):** Cursor-højde (1 til 10 videolinjer; `2` = 2 linjer).<br>**Bits 3–0 (Lav nibble):** Cursor-blink:<br>`0`: Fast lys (*solid*)<br>`1`: Blinkende (*blinking*) |
| `0x14` | 20 | `0x05` | **Floppy stoptid** | Antal inaktive sekunder før floppymotoren slukkes (skal være $\ge 2$). Angiver også tid før disketten frigives. |
| `0x15` | 21 | `0x00` | Reserveret | Reserveret. |
| `0x16` | 22 | `0x07` | **Standard forgrundsfarve** | Farveindstilling for tekst:<br>**Bit 0:** Blå kanon tændt/slukket<br>**Bit 1:** Grøn/gul kanon tændt/slukket<br>**Bit 2:** Rød kanon tændt/slukket<br>**Bit 3:** Høj intensitet (bold) tændt/slukket<br>**Bits 7–4:** `0` |
| `0x17` | 23 | `0x01`–`0x0C` | **Sidste tænding: Måned** | Måneden for maskinens sidste opstart (1–12 hex/bcd). |
| `0x18` | 24 | `0x78`–`0x99` | **Sidste tænding: År** | Årstal for sidste opstart (`0x84` = 1984). |
| `0x19` | 25 | `'A'` | **Default Load (Autoboot)** | Standard opstartsmedie (ASCII-tegn):<br>`'A'`: Floppedrev A (autoboot til CP/M-86)<br>`'B'`: Floppedrev B<br>`'N'`: Lokalt netværk (DR Net)<br>`'P'`: EPROM-bootloader<br>`'M'`: Menu / PROM prompt (`SELECT LOADMEDIUM`) |
| `0x1A` | 26 | `0x02` | **Antal diskbuffere** | Antal data-buffere i operativsystemet (skal være $\ge 2$). Vises som `2 Data buffer(e)` ved boot. |
| `0x1B` | 27 | `0x00` | **Memory-disk størrelse (M-disk)** | Størrelse på RAM-disk:<br>`0`: 0 KB (ingen M-disk)<br>`1`: 64 KB<br>`2`: 128 KB<br>`3`: 192 KB<br>`4`: 256 KB |
| `0x1C` | 28 | `0x00` | **Hardcopy printertype** | Skærmprint-konvertering:<br>`0`: Kun tegn 32–126 udskrives; alle andre bliver til mellemrum.<br>`1`: Rå transparent udskrift (alle 256 koder sendes uændret). |
| `0x1D` | 29 | `0x00` | **DR Net node-ID** | Lokalt netværks-node ID (0–254). |
| `0x1E` | 30 | `0x00` | **DR Net server-ID** | Standard netværksserver node ID (0–254). |
| `0x1F` | 31 | `0x00` | **Autologon maske** | Automatisk logon på server ved start:<br>**Bit 0:** Konsol 0 autologon<br>**Bit 1:** Konsol 1 autologon<br>**Bit 2:** Konsol 2 autologon<br>**Bit 3:** Konsol 3 autologon |
| `0x20`–`0x21` | 32–33 | `0x00, 0x00` | Reserveret | Reserveret til netværk. |
| `0x22`–`0x29` | 34–41 | `8 x 0x20` | **DR Net server-password** | 8 ASCII-tegn med adgangskode til serveren. |
| `0x2A` | 42 | `0x00` | Reserveret | Reserveret. |
| `0x2B`–`0x32` | 43–50 | `8 x 0x20` | **DR Net boot-filnavn** | 8 ASCII-tegn med navnet på filen, der skal hentes over nettet. |
| `0x33` | 51 | `0x00` | **iSBX-modul ID** | Monteret udvidelsesmodul på bundkortet:<br>`0`: Intet modul monteret<br>`1`: Intel iSBX 351 (ekstra seriel RS-232C kanal)<br>`2`: Intel iSBX 488 (GPIB / IEEE-488 instrumentbus) |
| `0x34` | 52 | `0x00` | **Systemdisk-nummer** | Drevnummer for systemdisk (0 = A:, 1 = B:, osv.). |
| `0x35` | 53 | `0xFF` | **CPU / Maskintype ID** | Vigtigt hardware-identifikationsflag:<br>`0xFF`: **RC759 Piccoline** (80186, i82730 video)<br>`0x00`: **RC750 Partner** (80186, Partner CRTC / RS-232C) |
| `0x36`–`0x5F` | 54–95 | `0x00...` | Reserveret (Checksum-dækket) | Reserveret til fremtidige udvidelser (blok 1 og 2). |
| `0x60`–`0x7F` | 96–127 | `0x00...` | Blok 3 data (Ej checksum-dækket) | Fri brugerdata / konfigurationsdata, som ikke indgår i `0xAA` checksummen. |

---

## 4. Samspil med XIOS og Hardware-rutiner

### 4.1 Initialisering i XIOS (`mod4_xios.asm`)
Under koldstart indlæses NVM i XIOS' interne tabel:
1. **Scroll-mode (`0x12`):**
   ```assembly
   ; mod4_xios.asm:16441
   mov al, 0
   test byte [bx + 0x12], 0xf0   ; Test 4 øverste bits
   je loc_0BAC6                  ; 0 -> Line scroll
   mov al, 1                     ; !=0 -> Soft scroll
   loc_0BAC6:
   mov [cs:0x2c08], al           ; Gemmes som standard i XIOS
   ```
2. **Cursor (`0x13`):**
   ```assembly
   ; mod4_xios.asm:16424
   mov al, [bx + 0x13]
   mov dl, al
   and al, 1                     ; Bit 0: solid (0) vs blinking (1)
   mov [cs:0x2bfd], al
   mov cl, 4
   shr dl, cl                    ; Bits 7-4: Cursor-højde
   dec dl
   mov [cs:0x2bfc], dl
   ```
3. **Maskintype (`0x35`):**
   XIOS tjekker om byte `0x35` er `0xFF` (Piccoline) for at aktivere i82730 grafik/tekst-initialisering eller `0x00` (Partner) for Partner-specifik video.

---

## 5. Drift og vedligeholdelse

* **Programmeringsværktøj:** Standardprogrammet på Piccoline-distributionsdisken til visning og redigering af disse parametre er `KONFIG.CMD`.
* **Gendannelse af fabriksindstillinger:** Sletning af NVRAM tvinger systemet til at bruge standardværdierne defineret i boot-ROM eller `KDEF.SYS`.
* **MAME-konfiguration:** I MAME initialiseres NVRAM i `src/mame/regnecentralen/rc759.cpp` med default checksum `0xDF`, autoboot `'A'`, 2 buffere (`0x02`), og maskin-ID `0xFF`.

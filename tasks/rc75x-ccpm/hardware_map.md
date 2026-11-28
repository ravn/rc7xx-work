# Hardware-kortlægning: Regnecentralen RC759 Piccoline

Dette dokument kortlægger arkitekturen, I/O-portene, afbrydelserne (interrupts), hukommelsesopbygningen og styresignalerne for **Regnecentralen RC759 Piccoline** samt samspillet med Concurrent CP/M-86 XIOS (`mod4_xios.asm`).

Grundlaget er verificeret mod:
- *PICCOLINE Programmer's Guide v2* (CCP/M-86 3.1 / XIOS 2.3, Appendix B & C).
- MAME-emulatoren (`mame/src/mame/regnecentralen/rc759.cpp`, `rc75x.h`, `rc75x.cpp`).
- PCE-emulatoren (`pce/src/arch/rc759/rc759.c`, `rc759.h`).
- XIOS kildekoden i dette repository (`tasks/rc75x-ccpm/mod4_xios.asm`).

---

## 1. Systemarkitektur & CPU

- **CPU**: Intel 80186 (16-bit databus, 20-bit adressebus, 1 MB adresserum) taktende ved 6 MHz.
- **On-chip integrerede enheder i 80186**:
  - **3 stk. 16-bit timere** (Timer 0, Timer 1, Timer 2).
  - **2 uafhængige DMA-kanaler** (DMA 0, DMA 1) til byte- og word-transfers.
  - **Integreret Interrupt Control Unit (ICU)** i kaskadekobling med ekstern 8259A.
  - **Peripheral Control Block (PCB)**: 256 bytes styreblok relokeret til I/O-adresser `0xFF00`–`0xFFFF`.
- **Ekstern Master Interrupt Controller**: Intel 8259A tilsluttet CPU'ens `INT0` og `INTA0`.
- **Parallel I/O Controller**: Intel 8255A PPI til systemkonfiguration, båndoptager, NVRAM-banker og tastaturkontrol.
- **Tekst- og videocoprocessor**: Intel 82730 Text Coprocessor med 32 KB dedikeret skærm/pixel-RAM på `0xD0000`–`0xD7FFF`. Understøtter standard Piccoline monitor samt 60 Hz Partner-monitor (350x720 punkter, 9x14 tegnmatrix). På RC750 Partner reserveres i stedet 24 KB i toppen af system-RAM. Se detaljeret sammenligning i [screen_architecture_piccoline_vs_partner.md](file:///Users/ravn/z80/tasks/rc75x-ccpm/screen_architecture_piccoline_vs_partner.md).
- **Lydgenerator**: Texas Instruments SN76494 (eller SN76489A) med 3 tonegeneratorer og 1 støjgenerator (taktet ved 2 MHz, I/O-port 0x0056, READY på PPI Port B bit 2). Spiller autonomt i hardwaren; programmeret musik og dynamisk lyd styres via timer-interrupts (f.eks. 80186 Timer 0/2). Dertil en separat 1-bit bip-højttaler på 80186 Timer 1 (tmrout1).
- **Realtidsur (RTC)**: National Semiconductor MM58167A (32.768 kHz krystal, batteribackup).
- **Diskettedrev-controller**: Western Digital WD2797 Floppy Disk Controller (MFM/FM). Drev A og B (80 spor DSDD). M-Disk (Memory Disk) understøttes som drev M:, og i Release 3.1 1 MB ekstern Lager-disk som drev L:.
- **Udvidelsesslot**: Intel iSBX Multimodule-stik (MCS0 og MCS1). Mulighed for Multi-iSBX med op til 6 kanaler/kort (styret via KANAL.CMD).

---

## 2. Hukommelseskort (Memory Map)

| Adresseområde | Størrelse | Anvendelse |
|---|---|---|
| `0x00000` – `0x003FF` | 1 KB | 80186 & 8259A afbrydelsesvektortabel (vektorer 0–255) |
| `0x00400` – `0x3FFFF` | 255 KB | System-RAM (bundmodul, 256 KB standard) |
| `0x40000` – `0x5FFFF` | 128 KB | Udvidet system-RAM (standard 384 KB konfiguration, kan udvides til 512/640 KB) |
| `0xD0000` – `0xD7FFF` | 32 KB | CRT Pixel-RAM & programmerbar tegngenerator (spejlet ved `0xD8000`–`0xDFFFF`) |
| `0xE8000` – `0xEFFFF` | 32 KB | Boot-ROM & Selftest-firmware (spejlet ved `0xF8000`–`0xFFFFF` for reset-vektor ved `0xFFFF0`) |

---

## 3. Afbrydelsesvektorer (Interrupts)

Afbrydelsessystemet er opdelt i:
1. **80186 interne afbrydelser** (CPU-exceptions, interne timere og DMA).
2. **Ekstern 8259A Master PIC** (kaskaderet via CPU'ens `INT0`, basisvektor `0x80`).
3. **Softwareafbrydelser** til operativsystem og netværk.

### 80186 Interne Vektorer & CPU-exceptions

| Vektornummer | Vektoradresse | Kilde / Enhed | Beskrivelse |
|---|---|---|---|
| 0 | `0000:0000H` | CPU Exception | Divide error (division med nul) |
| 1 | `0000:0004H` | CPU Exception | Single-step trap |
| 2 | `0000:0008H` | NMI pin | Non-Maskable Interrupt |
| 3 | `0000:000CH` | Software/Breakpoint | Breakpoint (`INT 3`) |
| 4 | `0000:0010H` | CPU Exception | Overflow (`INTO`) |
| 5 | `0000:0014H` | CPU Exception | Array Bounds (`BOUND`) |
| 6 | `0000:0018H` | CPU Exception | Invalid / Unused Opcode Exception |
| 7 | `0000:001CH` | CPU Exception | ESC (Coprocessor) Opcode Exception |
| 8 | `0000:0020H` | 80186 Timer 0 | Cassette data modulering / timing |
| 10 | `0000:0028H` | 80186 DMA 0 | DMA-kanal 0 færdig (typisk iSBX bus) |
| 11 | `0000:002CH` | 80186 DMA 1 | DMA-kanal 1 færdig (Floppy transfer) |
| 12 | `0000:0030H` | Ekstern INT0 pin | Kaskadeindgang fra 8259A PIC |
| 13 | `0000:0034H` | Ekstern INT1 pin | iSBX stik `INTR0` |
| 14 | `0000:0038H` | Ekstern INT2 pin | Reserveret |
| 15 | `0000:003CH` | Ekstern INT3 pin | iSBX stik `INTR1` |
| 18 | `0000:0048H` | 80186 Timer 1 | Lyd / system-bell frekvensgenerering |
| 19 | `0000:004CH` | 80186 Timer 2 | Intern prescaler / generel timer |

### Eksterne Afbrydelser via 8259A PIC (Basisvektor `0x80`)

| IRQ-linje | Vektornummer | Vektoradresse | Enhed / Kilde | XIOS Funktion / Handler |
|---|---|---|---|---|
| **IR0** | 32 (`0x20`) | `0000:0080H` | Floppy Disk Controller (WD2797 / DPC) | Diskettedata klar / seek fuldført |
| **IR1** | 33 (`0x21`) | `0000:0084H` | Tastatur-interface | Tastetryk modtaget (seriel protokol) |
| **IR2** | 34 (`0x22`) | `0000:0088H` | DPC Parallel Printer Interface | Ekstern printer klar / ACK |
| **IR3** | 35 (`0x23`) | `0000:008CH` | Real Time Clock (MM58167A) | 1-sekunds tidsopdatering |
| **IR4** | 36 (`0x24`) | `0000:0090H` | Intel 82730 CRT Controller | Vertikal blanking / scroll fuldført |
| **IR5** | 37 (`0x25`) | `0000:0094H` | RC-Net LAN Controller | Netværkspakke sendt / modtaget |
| **IR6** | 38 (`0x26`) | `0000:0098H` | Lokal CPU Parallel Printer Interface | Centronics BUSY/ACK |
| **IR7** | 39 (`0x27`) | `0000:009CH` | Ubenyttet | Spurious interrupt handler |

### Operativsystem- og Driver-afbrydelser (Software Interrupts)

| Afbrydelse | Vektoradresse | Funktion |
|---|---|---|
| `INT 28H` | `0000:00A0H` | RC759 Special Hardware XIOS Extensions (Funktioner 0–53, se [int28h_functions_map.md](int28h_functions_map.md)) |
| `INT 29H` | `0000:00A4H` | RC-Net Local Area Network Driver |
| `INT 30H` | `0000:00A8H` | Inter-Machine Communication (IMC) |
| `INT E0H` (`224`) | `0000:0380H` | Concurrent CP/M-86 Kernel Entry (BDOS / RTM) |

---

## 4. I/O-Porttabel

| I/O-adresse | R/W | Enhed | Signal / Registerbeskrivelse |
|---|---|---|---|
| `0x0000` | R/W | Intel 8259A PIC | ICW1, OCW2 (EOI), OCW3 |
| `0x0002` | R/W | Intel 8259A PIC | ICW2–4, OCW1 (Interrupt Mask Register / IMR) |
| `0x0020` | R | Tastatur | Læsning af tastaturdata / scancode |
| `0x0056` | W | Lydgenerator (SN76494) | Lyddata / frekvens og dæmpning (attenuation) |
| `0x005A` | W | Realtidsur (MM58167A) | Data skrives til adresseret RTC-register |
| `0x005C` | R/W | Realtidsur (MM58167A) | R: Data læses fra RTC-register, W: Registradresse |
| `0x0060` | W | Intel 82730 CRT | CRT styringsregister |
| `0x0070` | R | Intel 8255A PPI Port A | Systemkonfiguration og båndoptagerdata (indgang) |
| `0x0072` | R | Intel 8255A PPI Port B | Hardwareidentifikation og skærmtype (indgang) |
| `0x0074` | W | Intel 8255A PPI Port C | Systemkontrol, NVRAM-banker og motorer (udgang) |
| `0x0076` | W | Intel 8255A PPI Kontrol | Funktionskontrolord for port A, B og C |
| `0x0080`–`0x00FE` | R/W | NVRAM (CMOS RAM) | 64 4-bits nibbles i den valgte bank (lige adresser) |
| `0x0100`–`0x0101` | R/W | RC-Net Controller | Channel Attention (CA) til netværkscontroller |
| `0x0180`–`0x01BE` | W | Farvepalet | 32 paletposter × 2 nibbles (IRGB-farver, lige adresser) |
| `0x0230` | W | Intel 82730 CRT | System Reset (IRST) |
| `0x0240` | W | Intel 82730 CRT | Channel Attention (CA) |
| `0x0250` | R/W | Lokal Printer (Centronics) | 8-bit printerdata udgang |
| `0x0260` | R/W | Lokal Printer Kontrol | R: Printerstatus (BUSY, ACK, PE, ERROR), W: STROBE |
| `0x0280` | R/W | WD2797 Diskettedrev | R: Statusregister, W: Kommandoregister |
| `0x0282` | R/W | WD2797 Diskettedrev | Sporregister (Track register) |
| `0x0284` | R/W | WD2797 Diskettedrev | Sektorregister (Sector register) |
| `0x0286` | R/W | WD2797 Diskettedrev | Dataregister (Data register) |
| `0x0288` | W | Diskettekontrolregister | Drevvalg (A/B), Side (0/1), Motor, Ur (1/2 MHz), Densitet |
| `0x028A` | R/W | DPC Ekstern Printer | Printerdata for ekstern printer |
| `0x028C` | R/W | DPC Ekstern Printer Kontrol | Kontrol- og statusregister for ekstern printer |
| `0x028E` | R/W | Diskettedrev Reservation | R: Floppy ACK, W: Reserver fælles diskettedrev |
| `0x0290` | W | Diskettedrev Frigivelse | Frigiv fælles diskettedrev |
| `0x0292` | R/W | Printer Reservation | R: Printer ACK, W: Reserver fælles printer |
| `0x0294` | W | Printer Frigivelse | Frigiv fælles printer |
| `0x0300`–`0x030E` | R/W | iSBX Slot MCS0 | iSBX I/O-adresserum 0 (fx iSBX 351 seriel USART) |
| `0x0310`–`0x031E` | R/W | iSBX Slot MCS1 | iSBX I/O-adresserum 1 (fx timer / baud rate) |
| `0x0320` | W | iSBX DMA | DMA Acknowledge til iSBX modul |
| `0x0330` | W | iSBX DMA | DMA Terminal Count (TC) til iSBX modul |
| `0xFF00`–`0xFFFF` | R/W | 80186 Interne Registre | Peripheral Control Block (PCB): Timere, DMA, ICU |

---

## 5. Intel 8255A PPI Portkonfiguration

### Port A (`0x0070` – Indgang)
- **Bit 0**: Cassette Data In (læsning af moduleret lydsignal fra båndoptager).
- **Bit 1**: iSBX `MPST` (Module Present: 0 = modul monteret).
- **Bit 2**: iSBX `OPT0` (Option signal 0 fra iSBX).
- **Bit 3**: iSBX `OPT1` (Option signal 1 fra iSBX).
- **Bit 4**: RAM Identifikationsbit 0.
- **Bit 5**: RAM Identifikationsbit 1 (`01b` = 384 KB installeret).
- **Bit 6**: DPC Connect (0 = ekstern disk/printer-adapter tilsluttet).
- **Bit 7**: Ubenyttet (fast 1).

### Port B (`0x0072` – Indgang)
- **Bit 0**: Micronet / RC-Net controller installeret (0 = installeret).
- **Bit 1**: RTC type (0 = MM58167A, 1 = CDP1879).
- **Bit 2**: Lydgenerator READY status (SN76494).
- **Bit 3**: Ubenyttet.
- **Bit 4**: Ubenyttet.
- **Bit 5**: Skærmtype (0 = Farveskærm, 1 = Monokrom).
- **Bit 6**: Skærmfrekvens (0 = 15.625 kHz standard, 1 = 22 kHz højopløsning).
- **Bit 7**: Remote hardware debug enable (0 = aktiveret via iSBX 351).

### Port C (`0x0074` – Udgang)
- **Bit 0**: Cassette Enable (1 = aktiver båndoptagerinterface).
- **Bit 1**: Cassette Motor (0 = motor tændt, 1 = motor slukket).
- **Bit 2–3**: DMA Request Source Selection:
  - `00b`: DMA0 = iSBX, DMA1 = DPC/Floppy
  - `10b`: DMA0 = DPC/Floppy, DMA1 = iSBX
- **Bit 4–5**: NVRAM Bank Select:
  - Vælger hvilken af de 4 banker (hver på 64 nibbles) der er synlig på `0x0080`–`0x00FE`.
  - Se den udtømmende byte-for-byte specifikation i [nvram_map.md](file:///Users/ravn/z80/tasks/rc75x-ccpm/nvram_map.md).
- **Bit 6**: Grafikmodus (0 = Alfanumerisk tekst, 1 = Højopløsningsgrafik).
- **Bit 7**: Tastatur Enable (1 = aktiver modtagelse af serielle tastaturdata).

---

## 5.1 Ikke-flygtig parameterhukommelse (NVRAM / NVM)

Piccoline har 128 bytes batteribackup-parameterhukommelse (se komplet specifikation i [nvram_map.md](nvram_map.md)):
- **Checksum**: Byte 0 sikrer at $\sum_{i=0}^{95} \text{byte}[i] \pmod{256} = \text{0xAA}$. Afvigelse giver `ERROR: 19`.
- **Kopiering til RAM**: XIOS indlæser hele NVM til RAM ved start (`INT 0x28, AL=3` returnerer pointer `ES:BX` til `SYSDAT:4896h`).
- **Nøgleparametre**:
  - `0x0D`–`0x11`: Seriel kommunikation (9600 baud, 8 databits, 1 stopbit, ingen paritet).
  - `0x12`: **CRT Scroll Mode** (4 MSB: `0` = Hård linjerulning, `1` = Blød rulning via `SCROLL.RSP`).
  - `0x13`: **Cursor højde og blink** (4 MSB = linjer, 4 LSB = fast/blinkende).
  - `0x14`: **Floppy stoptid** (sekunder før motor slukker, min. 2).
  - `0x16`: **Standard forgrundsfarve** (`0x07` = normal hvid tekst).
  - `0x19`: **Default Load (Autoboot)** (`'A'` = Diskettedrev A, `'N'` = DR Net, `'M'` = PROM menu).
  - `0x1A`: **Data buffere** (antal CCP/M-86 diskbuffere, standard 2).
  - `0x1B`: **M-Disk (RAM-disk)** (0 = 0 KB, 1 = 64 KB, 2 = 128 KB, 3 = 192 KB, 4 = 256 KB).
  - `0x35`: **CPU / Maskintype ID** (`0xFF` = RC759 Piccoline, `0x00` = RC750 Partner).

For samtlige bytes 0–127 henvises til [nvram_map.md](file:///Users/ravn/z80/tasks/rc75x-ccpm/nvram_map.md).

---

## 6. Diskettecontroller (WD2797) & Kontrolregister

### Kontrolregister (`0x0288` – Udgang)
- **Bit 0**: Drevvalg (0 = Drev A, 1 = Drev B).
- **Bit 1**: Motor Drev A (1 = motor kører).
- **Bit 2**: Motor Drev B (1 = motor kører).
- **Bit 3**: Write Precompensation Enable.
- **Bit 4**: Precompensation timing (125 ns / 250 ns).
- **Bit 5**: Densitet (0 = Enkelt densitet / FM, 1 = Dobbelt densitet / MFM).
- **Bit 6**: FDC Basisur (0 = 1 MHz til 5.25" mini-floppy, 1 = 2 MHz til 8" standard).
- **Bit 7**: Force Ready kontrolsignal til WD2797.

---

## 7. 80186 Integreret Peripheral Control Block (`0xFF00`–`0xFFFF`)

De vigtigste interne registre i 80186, som anvendes af XIOS:
- **`0xFF22`**: EOI (End of Interrupt Register) — XIOS skriver `0x8000` for non-specific EOI.
- **`0xFF28`**: IMR (Interrupt Mask Register) — aktiverer/maskerer interne interrupts.
- **`0xFF50`–`0xFF56`**: Timer 0 (Count, Max Count A, Control).
- **`0xFF58`–`0xFF5E`**: Timer 1 (Count, Max Count A, Control — Bell lyd).
- **`0xFF60`–`0xFF66`**: Timer 2 (Count, Max Count A, Prescaler).
- **`0xFFC0`–`0xFFCA`**: DMA Kanal 0 (Source, Dest, Count, Control).
- **`0xFFD0`–`0xFFDA`**: DMA Kanal 1 (Source, Dest, Count, Control — Floppy transfer).

---

## 8. XIOS Funktionstabel (`mod4_xios.asm`)

XIOS-dispatcherens indgangspunkt er placeret ved `0x03BAD` (`mod4_xios_entry`), hvor funktionsnummeret modtages i register `CX`:
```asm
mod4_xios_entry:
  xor ch, ch
  mov si, cx
  shl si, 1
  add si, cx
  add si, strict word 0x4d
  test byte [cs:si + 2], 1
  je direct_call
  call queue_lock_call
```

Hvert element i tabellen ved CS offset `0x004D` er på 3 bytes: `[dw routine_offset, db flags]`.
Flag-bit 0 bestemmer, om funktionen kræver gensidig udelukkelse / synkronisering via CCP/M-86 ressource-køer (`MXdisk` osv.) før udførelse.

### De 32 XIOS Standardfunktioner

| Funktion (CX) | CS Offset | Rutineadresse | Flag | Standard CP/M-86 XIOS Betydning |
|---|---|---|---|---|
| 0 | `0x4D` | `CS:2F88h` | `0x00` | `?init` (Initialiser XIOS) |
| 1 | `0x50` | `CS:2A65h` | `0x05` | `?wboot` (Varmstart / Warm boot) |
| 2 | `0x53` | `CS:2AA3h` | `0x01` | `?const` (Konsol status) |
| 3 | `0x56` | `CS:2F8Dh` | `0x00` | `?conin` (Konsol input) |
| 4 | `0x59` | `CS:2AB3h` | `0x1B` | `?conout` (Konsol output) |
| 5 | `0x5C` | `CS:2AC0h` | `0x1B` | `?list` (Printer output) |
| 6 | `0x5F` | `CS:2ACDh` | `0x19` | `?auxout` (Hjælpeenhed / Seriel output) |
| 7 | `0x62` | `CS:2AFAh` | `0x09` | `?auxin` (Hjælpeenhed / Seriel input) |
| 8 | `0x65` | `CS:2B0Ah` | `0x01` | `?home` (Søg til spor 0) |
| 9 | `0x68` | `CS:2B24h` | `0x01` | `?seldsk` (Vælg diskettedrev) |
| 10 | `0x6B` | `CS:2B83h` | `0x01` | `?settrk` (Vælg spornummer) |
| 11 | `0x6E` | `CS:2BD2h` | `0x1B` | `?setsec` (Vælg sektornummer) |
| 12 | `0x71` | `CS:2BE0h` | `0x19` | `?setdma` (Sæt DMA-buffer offset) |
| 13 | `0x74` | `CS:2BE8h` | `0x19` | `?read` (Læs diskettesektor) |
| 14 | `0x77` | `CS:2FA1h` | `0x00` | `?write` (Skriv diskettesektor) |
| 15 | `0x7A` | `CS:2FB4h` | `0x00` | `?listst` (Printerstatus) |
| 16 | `0x7D` | `CS:2BF0h` | `0x01` | `?sectrn` (Sektortranslatering) |
| 17 | `0x80` | `CS:2C30h` | `0x01` | `?setdmab` (Sæt DMA-buffer segment/base) |
| 18 | `0x83` | `CS:2FBAh` | `0x00` | `?getsegt` (Hent hukommelsessegmenttabel) |
| 19 | `0x86` | `CS:2FC0h` | `0x00` | `?alloc` (Alloker hukommelsesblok) |
| 20 | `0x89` | `CS:2C3Fh` | `0x01` | `?dealloc` (Frigiv hukommelsesblok) |
| 21 | `0x8C` | `CS:2CC5h` | `0x09` | `?dskreset` (Nulstil disksystem) |
| 22 | `0x8F` | `CS:2DC6h` | `0x05` | `?select` (Hent drevparametre) |
| 23 | `0x92` | `CS:2E42h` | `0x01` | `?conbrk` (Kontroller Ctrl-C / konsolafbrydelse) |
| 24 | `0x95` | `CS:2E4Bh` | `0x05` | `?poll` (Periodisk enhedspolling) |
| 25 | `0x98` | `CS:2E84h` | `0x05` | `?flag` (Håndter CCP/M synkroniseringsflag) |
| 26 | `0x9B` | `CS:2FCEh` | `0x00` | `?tick` (Systemtimer tick) |
| 27 | `0x9E` | `CS:2FE9h` | `0x00` | `?timedate` (Hent/sæt klokkeslæt og dato) |
| 28 | `0xA1` | `CS:2F00h` | `0x01` | `?delay` (Forsinkelse i millisekunder) |
| 29 | `0xA4` | `CS:2F18h` | `0x15` | `?stop` (Stands proces / vent på afbrydelse) |
| 30 | `0xA7` | `CS:1EF7h` | `0x01` | `?exit` (Afslut proces) |
| 31 | `0xAA` | `CS:2F74h` | `0x01` | `?idle` (CPU Idle / lavt energiforbrug) |

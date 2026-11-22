# RC759 Piccoline — INT 28h Extended XIOS Functions Map

Dokumentation for samtlige 54 funktioner (Funktion 0 til 53) tilgængelige via software-afbrydelse `INT 28H` i RC759 Piccoline XIOS (Flemming Kraglund, Regnecentralen).

Kilder:
* **RC759 Piccoline Programmer's Guide v2**, Appendix A: *Int-28h Function Interface PICCOLINE* (side 183–202 / PDF s. 193–212).
* **Binæranalyse af `ccpm.sys`** (`XIOS1.CON`, fil-offset `0x03AD0`–`0x0FD3F`).
* **INT 28h Dispatcher**: Fil-offset `0x07831` (`CS:0C91h`).
* **INT 28h Jump Table**: Fil-offset `0x0784C`–`0x078B7` (`CS:0CACh`, 54 words = 108 bytes).
* **XIOS Code Segment Base**: `0x06BA0` (hvor `CS:offset = filoffset - 0x06BA0`).

---

## 1. INT 28H Dispatcher & Tabelstruktur

Når et brugerprogram eller en proces (f.eks. `SCROLL.RSP` eller `VOUT.RSP`) udfører `INT 28H`, aktiveres dispatcheren ved fil-offset `0x07831`:

```asm
int28h_dispatcher:
  push ds                                      ; 07831
  mov ds, [cs:0xc06]                           ; 07832: Hent SYSDAT segment
  mov bx, [cs:0x68]                            ; 07837: Hent aktiv Process Descriptor (RLR)
  mov es, [bx + 0x10]                          ; 0783C: Hent proces UDA segment
  xor bx, bx                                   ; 0783F
  mov bl, al                                   ; 07841: BL = funktionsnummer (0..53)
  shl bx, 1                                    ; 07843: BX = funktionsnummer * 2 (word offset)
  call word [cs:bx + 0xcac]                    ; 07845: Kald rutine via int28h_jump_table
  pop ds                                       ; 0784A
  iret                                         ; 0784B: Returner fra interrupt
```

Tabelopslaget `[cs:bx + 0xcac]` peger direkte på tabellen ved `CS:0CACh` (fil-offset `0x0784C`), som indeholder 54 16-bit CS-offsets.

---

## 2. Komplet Oversigt over de 54 INT 28h Funktioner

| Nr | Hex | Navn | CS-offset | Fil-offset | Kategori | Beskrivelse (Programmer's Guide Appendix A) |
|---|---|---|---|---|---|---|
| **0** | `0x00` | `set_graphics_mode` | `0x22B5` | `0x08E55` | Skærm/Grafik | Skifter konsollen til grafiktilstand (640x400 / 640x475). |
| **1** | `0x01` | `set_char_mode` | `0x23C7` | `0x08F67` | Skærm/Tekst | Skifter konsollen til standard tekst/karaktertilstand (82730 tekstprocessor). |
| **2** | `0x02` | `smooth_scroll_step` | `0x1D70` | `0x08910` | Skærm/Scroll | Udfører 1 scanline blød rulning (kaldt internt fra `SCROLL.RSP`). Reserveret i manual. |
| **3** | `0x03` | `get_nvram_copy` | `0x42D6` | `0x0AE76` | System/NVRAM | Returnerer pointer til XIOS' interne kopi af NVRAM (ES:BX = `SYSDAT:4896h`). |
| **4** | `0x04` | `get_autoconfig_map` | `0x42DF` | `0x0AE7F` | System/Konfig | Returnerer pointer til Auto-Configuration Map (ES:BX = `SYSDAT:4225h`). |
| **5** | `0x05` | `fdc_recalibrate` | `0x3459` | `0x09FF9` | Floppy Disk | Rekalibrer diskettedrev til spor 0 (WD2797 kommando `0x0C`). |
| **6** | `0x06` | `reserved_6` | `0x3475` | `0x0A015` | Floppy Disk | Reserveret (returnerer `ret`). |
| **7** | `0x07` | `reserved_7` | `0x3476` | `0x0A016` | Floppy Disk | Reserveret (returnerer `ret`). |
| **8** | `0x08` | `fdc_step_in` | `0x3477` | `0x0A017` | Floppy Disk | Step floppy læsehoved 1 spor ind mod midten (spor N -> N+1). |
| **9** | `0x09` | `fdc_step_out` | `0x3493` | `0x0A033` | Floppy Disk | Step floppy læsehoved 1 spor ud mod yderkanten (spor N -> N-1). |
| **10** | `0x0A` | `fdc_write_track` | `0x3494` | `0x0A034` | Floppy Disk | Skriv råt formateret spor til diskette (Write Track / format). |
| **11** | `0x0B` | `fdc_read_track` | `0x351F` | `0x0A0BF` | Floppy Disk | Læs råt helt spor fra diskette (Read Track diagnose). |
| **12** | `0x0C` | `sound_write_byte` | `0x445E` | `0x0AFFE` | Lydgenerator | Skriv data-byte til Piccolines lydchip (SN76489 / generator port `0x50`). |
| **13** | `0x0D` | `get_disk_stats` | `0x35AD` | `0x0A14D` | Floppy Disk | Returnerer pointer til diskdriver-statistikker (ES:BX = `SYSDAT:367Ch`). |
| **14** | `0x0E` | `reserved_14` | `0x35B6` | `0x0A156` | Reserveret | Reserveret (returnerer `ret`). |
| **15** | `0x0F` | `reserved_15` | `0x110D` | `0x07CAD` | Reserveret | Intern konsolhjælper via `sub_08FDC`. |
| **16** | `0x10` | `reserved_stub` | `0x0D18` | `0x078B8` | Reserveret | Ubrugt stub (`ret`). |
| **17** | `0x11` | `reserved_stub` | `0x0D18` | `0x078B8` | Reserveret | Ubrugt stub (`ret`). |
| **18** | `0x12` | `reserved_18` | `0x4024` | `0x0ABC4` | Reserveret | Intern hardwarekontrol (`sub_0ABC4`). |
| **19** | `0x13` | `get_16ms_timer` | `0x447F` | `0x0B01F` | Timer | Returnerer 16 ms timer: DX:AX = 32-bit sekundtæller, CX = antal 16 ms perioder. |
| **20** | `0x14` | `define_alt_char` | `0x2542` | `0x090E2` | Skærm/Font | Definer tegn i det alternative tegnsæt i font-RAM. |
| **21** | `0x15` | `get_display_list` | `0x25A1` | `0x09141` | Skærm/82730 | Returnerer pointer til konsollens 82730 display list. |
| **22** | `0x16` | `set_display_list` | `0x25AA` | `0x0914A` | Skærm/82730 | Sætter adresse for konsollens display list tabel. |
| **23** | `0x17` | `isbx351_status` | `0x4492` | `0x0B032` | Seriel/iSBX | Returnerer status for Intel iSBX 351 serielt multimodulkort (hvis monteret). |
| **24** | `0x18` | `isbx351_init` | `0x4583` | `0x0B123` | Seriel/iSBX | Initialiserer USART og baudrate på iSBX 351. |
| **25** | `0x19` | `reserved_25` | `0x3E5E` | `0x0A9FE` | Reserveret | Reserveret. |
| **26** | `0x1A` | `cas_read_header` | `0x5B16` | `0x0C6B6` | Båndoptager | Læs 128-byte filhoved-blok fra kassettebåndoptager. |
| **27** | `0x1B` | `cas_write_header` | `0x5B35` | `0x0C6D5` | Båndoptager | Skriv 128-byte filhoved-blok til kassettebåndoptager. |
| **28** | `0x1C` | `cas_read_data` | `0x5B52` | `0x0C6F2` | Båndoptager | Læs næste datablok fra kassettebånd. |
| **29** | `0x1D` | `cas_write_data` | `0x5B6F` | `0x0C70F` | Båndoptager | Skriv næste datablok til kassettebånd. |
| **30** | `0x1E` | `mouse_fn` | `0x2900` | `0x094A0` | Mus | Musestyring (Subfn 1: init mus, Subfn 2: deinit, Subfn 3: læs status delta X/Y). |
| **31** | `0x1F` | `def_palette` | `0x25D2` | `0x09172` | Skærm/Farve | Definer farvepalette / gråtoner (pointer til 16-farve palettedefinition). |
| **32** | `0x20` | `reserved_32` | `0x42E8` | `0x0AE88` | Reserveret | Reserveret (internt flag-check). |
| **33** | `0x21` | `reserved_33` | `0x42F6` | `0x0AE96` | Reserveret | Reserveret (internt flag-check). |
| **34** | `0x22` | `reserved_34` | `0x4306` | `0x0AEA6` | Reserveret | Reserveret (internt flag-check). |
| **35** | `0x23` | `write_str_conbuf` | `0x24F6` | `0x09096` | Skærm/Output | Skriv tekststreng direkte til virtuel konsolbuffer (DL=kol, DH=række, CX=antal, DS:SI=tekst). |
| **36** | `0x24` | `set_cursor_pos` | `0x25B6` | `0x09156` | Skærm/Cursor | Sæt cursorposition for aktiv konsol (BH=række, BL=kolonne). |
| **37** | `0x25` | `get_attributes` | `0x25C4` | `0x09164` | Skærm/Attribut | Returnerer aktuelle skærmattributter i AH (invers, understregning, fremhævet osv.). |
| **38** | `0x26` | `set_attributes` | `0x25CB` | `0x0916B` | Skærm/Attribut | Sætter aktuelle skærmattributter fra AL. |
| **39** | `0x27` | `update_screen` | `0x253C` | `0x090DC` | Skærm/Synk | Tving opdatering af den fysiske skærm fra den virtuelle konsolbuffer. |
| **40** | `0x28` | `cas_write_eof` | `0x5B8A` | `0x0C72A` | Båndoptager | Skriv End-Of-File (EOF) blok på kassettebånd. |
| **41** | `0x29` | `reserve_dpc` | `0x5E63` | `0x0CA03` | DPC Bus | Reserver eller frigiv DPC parallelinterface (Subfn 1: reserve, Subfn 2: release). |
| **42** | `0x2A` | `reserve_shared_disk` | `0x5F15` | `0x0CAB5` | Netværk/Disk | Reserver eller frigiv delt netværksdisk (Subfn 1: reserve, Subfn 2: release). |
| **43** | `0x2B` | `reserved_stub` | `0x0D18` | `0x078B8` | Reserveret | Ubrugt stub (`ret`). |
| **44** | `0x2C` | `reserved_stub` | `0x0D18` | `0x078B8` | Reserveret | Ubrugt stub (`ret`). |
| **45** | `0x2D` | `reserved_stub` | `0x0D18` | `0x078B8` | Reserveret | Ubrugt stub (`ret`). |
| **46** | `0x2E` | `reserved_stub` | `0x0D18` | `0x078B8` | Reserveret | Ubrugt stub (`ret`). |
| **47** | `0x2F` | `reserved_stub` | `0x0D18` | `0x078B8` | Reserveret | Ubrugt stub (`ret`). |
| **48** | `0x30` | `reserved_stub` | `0x0D18` | `0x078B8` | Reserveret | Ubrugt stub (`ret`). |
| **49` | `0x31` | `reserved_stub` | `0x0D18` | `0x078B8` | Reserveret | Ubrugt stub (`ret`). |
| **50** | `0x32` | `isbx351_reset` | `0x44BE` | `0x0B05E` | Seriel/iSBX | Udfør hardware-reset af iSBX 351 seriel controller. |
| **51** | `0x33` | `get_font` | `0x256A` | `0x0910A` | Skærm/Font | Hent 16-byte tegndefinition for et tegn fra font-RAM (AL=tegnkode). |
| **52** | `0x34` | `def_font` | `0x2553` | `0x090F3` | Skærm/Font | Definer 16-byte tegndefinition i font-RAM (AL=tegnkode, DS:SI=16 bytes mønster). |
| **53** | `0x35` | `get_xios_version` | `0x0D19` | `0x078B9` | System/Version | Hent XIOS version: Returnerer AX = `0x8523` (v2.3, marts 1985), BX = `0x0206` (v2.06). |

---

## 3. Detaljerede Funktionsbeskrivelser

### Funktion 0 & 1: Konsoltilstand (`set_graphics_mode` & `set_char_mode`)
* **Funktion 0 (Grafik)**:
  - Indgang: `AL = 0`
  - Slukker Intel 82730 tekstvisning og konfigurerer Piccolines 32 KB skærmhukommelse til direkte bitmapped grafik (640x400 punkter i monokrom eller 4-farve/gråtoner).
* **Funktion 1 (Karakter/Tekst)**:
  - Indgang: `AL = 1`
  - Geninitialiserer Intel 82730 tekstcoprocessor, loader display list og genopretter 80x25 tekstvisning med hardware cursor og attributter.

### Funktion 2: Scanline Blød Rulning (`smooth_scroll_step`)
* **Indgang**: `AL = 2`
* **Formål**: Udfører præcis ét scanline-step i 82730 tekstprocessorens kanalprogram via Micro-DMA.
* **Samspil**: Kaldes af `SCROLL.RSP` i en tæt løkke synkroniseret med VSYNC for at skabe flydende pixelskift uden flimmer.

### Funktion 3 & 4: NVRAM & Autokonfiguration
* **Funktion 3 (NVRAM kopi)**:
  - Indgang: `AL = 3`
  - Retur: `ES:BX` peger på XIOS' lokale kopi af de 128 bytes Non-Volatile RAM (i `SYSDAT:4896h`).
* **Funktion 4 (Autokonfiguration)**:
  - Indgang: `AL = 4`
  - Retur: `ES:BX` peger på Auto-Configuration Map (i `SYSDAT:4225h`). Indeholder maskintype (byte 23: `'P'` = Partner, andet = Piccoline), CPU-hastighed, hukommelsesstørrelse og monterede udvidelsesmoduler.

### Funktion 5, 8, 9, 10, 11: Direkte Floppy Disk Lavniveau-I/O
* **Formål**: Anvendes af formateringsprogrammer (`DISKVEDL.CMD`) og diagnoseværktøjer til direkte spor-operationer udenom BDOS.
* **Stak-parametre ved indgang** (standard for alle 5 rutiner):
  ```
  +10: Drevnummer (0 = A:, 1 = B:)
  + 8: Hoved (0 = underside, 1 = overside)
  + 6: Cylinder / spor (0..79)
  + 4: Bytecount (antal bytes)
  + 2: DMA segment
  + 0: DMA offset
  ```
* **Retur**: `AL = WD2797 statusregister`.

### Funktion 12: Lydgenerator (`sound_write_byte`)
* **Indgang**: `AL = 12`, `DL = data-byte`
* **Beskrivelse**: Sender direkte kontrolbyte til Piccolines lydchip (port `0x50`). Kontrollerer frekvens, dæmpning (attenuation) og støjgenerator (white noise / periodic noise).

### Funktion 13: Diskdriver-statistikker (`get_disk_stats`)
* **Indgang**: `AL = 13`
* **Retur**: `ES:BX` peger på diskfejl- og operationstællere i SYSDAT (læse-/skriveantal, bløde og hårde fejl samt WD2797 statusbit-histogrammer for drev A og B).

### Funktion 19: Højopløselig 16 ms Timer (`get_16ms_timer`)
* **Indgang**: `AL = 19`
* **Retur**:
  - `DX:AX`: 32-bit tæller for hele forløbne sekunder siden boot.
  - `CX`: Antal forløbne 16 millisekunders perioder (VSYNC-ticks) i det aktuelle sekund.
* **Formål**: Giver mulighed for præcise tidsmålinger og benchmarking uafhængigt af klokkeslættet i TOD-strukturen.

### Funktion 20, 51, 52: Font- & Tegnsætshåndtering
* **Funktion 20**: Definer tegn i det alternative tegnsæt.
* **Funktion 51 (`get_font`)**:
  - Indgang: `AL = 51`, `BL = tegnkode (0..255)`, `ES:DI = modtagebuffer (16 bytes)`.
  - Kopierer tegnets 16 scanlines fra font-RAM til buffer.
* **Funktion 52 (`def_font`)**:
  - Indgang: `AL = 52`, `BL = tegnkode (0..255)`, `DS:SI = kildebuffer (16 bytes)`.
  - Skriver 16 nye scanlines direkte til font-RAM. Giver fuld understøttelse af brugerdefinerede skrifttyper og matematiske symboler.

### Funktion 23, 24, 50: Intel iSBX 351 Serielt Interface
* Giver lavniveaukontrol over det valgfri iSBX multimodul til seriel kommunikation (V.24 / RS-232 kanal B):
  - `23`: Hent linjestatus og modtageklar-flag.
  - `24`: Initialiser USART til specificeret baudrate, paritet og stopbits.
  - `50`: Udfør hardware reset af interfacet.

### Funktion 26, 27, 28, 29, 40: Kassettebåndoptager Interface
* Komplet BIOS-understøttelse for dataoverførsel via Piccolines standard kassettebånd-interface (FSK-moduleret lyd via båndstik):
  - `26` / `27`: Læs / skriv 128-byte filhoved (filnavn, dato, blokstørrelse).
  - `28` / `29`: Læs / skriv 128- eller 256-byte datablok med checksum.
  - `40`: Skriv End-Of-File (EOF) mærke ved filafslutning.

### Funktion 30: Musestyring (`mouse_fn`)
* **Indgang**: `AL = 30`
* **Subfunktioner** i `CL`:
  - `CL = 1`: Initialiser mus og nulstil positionstællere.
  - `CL = 2`: Deaktiver mus.
  - `CL = 3`: Læs musestatus:
    - `AL = 0`: Ingen hændelse.
    - `AL = 1`, `AH = knap-kode`: Museknap trykket ned.
    - `AL = 2`, `BX = Delta X`, `CX = Delta Y`: Mus bevæget siden sidste aflæsning.

### Funktion 31: Farvepalette (`def_palette`)
* **Indgang**: `AL = 31`, `DS:DX` peger på palettetabel med 16 RGBI-farveværdier.
* Programmerer farve-lookup-hardwaren på Piccoline farvekortet.

### Funktion 35..39: Hurtig Skærm- og Cursor-manipulation
* **Funktion 35 (`write_str_conbuf`)**: Skriver en streng direkte til konsollens buffer uden om BDOS tegnfortolkeren (maksimal skærmhastighed til tekstmenuer og vinduesopbygning).
* **Funktion 36 (`set_cursor_pos`)**: Flytter hardwarecursoren direkte til række `BH` og kolonne `BL`.
* **Funktion 37 / 38**: Læs / skriv hardwareattributter (invers, dæmpet, understreget, blink, farve).
* **Funktion 39 (`update_screen`)**: Tvinger øjeblikkelig opdatering af 82730 displaylisten fra den aktive konsolbuffer.

### Funktion 41 & 42: DPC Bus & Netværk
* **Funktion 41**: Reservering og frigivelse af det hurtige parallelle DPC-interface (Distributed Process Controller).
* **Funktion 42**: Reservering og frigivelse af delte netværksdiske i et RC-skolenetværk, så flere Piccoliner ikke skriver til samme spor samtidigt.

### Funktion 53: XIOS Version (`get_xios_version`)
* **Indgang**: `AL = 53`
* **Retur**:
  - `AX = 0x8523`: BCD-kodet dato og versionsnummer (version 2.3, marts 1985).
  - `BX = 0x0206`: Sub-release version 2.06.

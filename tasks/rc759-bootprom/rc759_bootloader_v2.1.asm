; ============================================================================
; REGNECENTRALEN RC759 PICCOLINE BOOT PROM VERSION 2.1 (32 KB)
; Binary: mame/roms/rc759/rc759-1-2.1.rom (CRC32: 3a777d56, SHA1: a8592d61...)
; EPROM: ROA955 (Low Byte) + ROA956 (High Byte) interleaved
;
; MEMORY ARCHITECTURE:
;   Physical mapping:  0xF8000 - 0xFFFFF (32 KB, mirrored at 0xE8000)
;   Data Segment:      F800h (Offset == ROM file offset 0000h - 7FFFh)
;   Code Segment:      FB84h (Physical 0xFB840, ROM file offset 3840h)
;   Reset Entry:       FFF8:0008h (Physical 0xFFF88, ROM file offset 7F88h)
;   Reset Vector:      FFFF:0000h (Physical 0xFFFF0, ROM file offset 7FF0h)
; ============================================================================

; ============================================================================
; MEMORY ARCHITECTURE & SEGMENT CALCULATION EQUATES
; ============================================================================
ROM_SIZE_BYTES          EQU 08000h                       ; 32 KB Boot PROM
ROM_BASE_PHYSICAL       EQU (0100000h - ROM_SIZE_BYTES)  ; 0F8000h (Toppen af 1 MB CPU-adresserum)
ROM_DATA_SEGMENT        EQU (ROM_BASE_PHYSICAL >> 4)     ; 0F800h (Fuld PROM dækkes fra offset 0000h)

; Datasektion (0000h - 383Bh) og beregning af kodesegment-base via 16-byte paragrafjustering (ALIGN 16)
ROM_DATA_SIZE_BYTES     EQU 0383Ch                       ; Datasektionens faktiske slutning før padding
ROM_CODE_OFFSET         EQU ((ROM_DATA_SIZE_BYTES + 15) & ~15) ; 03840h (Næste paragrafgrænse, ALIGN 16)
ROM_CODE_PHYSICAL       EQU (ROM_BASE_PHYSICAL + ROM_CODE_OFFSET) ; 0FB840h
CODE_SEGMENT_BASE       EQU (ROM_CODE_PHYSICAL >> 4)     ; 0FB84h

; 80186 Reset-stub (initial far jump target fra CPU reset-vektor)
RESET_ENTRY_ROM_OFFSET  EQU 07F88h                       ; 80186 Reset-stub filoffset i PROM
RESET_STUB_PHYSICAL     EQU (ROM_BASE_PHYSICAL + RESET_ENTRY_ROM_OFFSET) ; 0FFF88h
RESET_STUB_IP           EQU 00008h                       ; Entry offset i reset-stub segmentet
RESET_STUB_SEGMENT      EQU ((RESET_STUB_PHYSICAL - RESET_STUB_IP) >> 4) ; 0FFF8h

; 80186 CPU Power-On Reset Vektor (fysisk fastlagt af CPU-arkitekturen til CS:IP = FFFF:0000h)
CPU_RESET_PHYSICAL      EQU 0FFFF0h                      ; CPU Power-on hardware reset entry
RESET_VECTOR_ROM_OFFSET EQU (CPU_RESET_PHYSICAL - ROM_BASE_PHYSICAL) ; 07FF0h (ROM filoffset for reset-vektor)
RESET_VECTOR_SEGMENT    EQU (CPU_RESET_PHYSICAL >> 4)    ; 0FFFFh

; Eksterne hardware- og buffersegmenter
CRT_VRAM_SEGMENT        EQU 0D000h                       ; Intel 82730 VRAM & display-controller styreblok (D000:0000)
LAN_BUFFER_SEGMENT      EQU 03600h                       ; Intel 82586 Ethernet LAN controller buffersegment (3600:0000)
LAN_BUFFER_ALT_SEGMENT  EQU 03000h                       ; Intel 82586 LAN buffer / alternativt testområde (3000:0000)

; ============================================================================
; SECTION 1: INTEL 82730 DISPLAY BLOCKS & FONT TABLES (ROM 0000h - 2161h)
; ============================================================================
SEGMENT DATA_F800 AT ROM_DATA_SEGMENT
ORG 0000h

i82730_header_and_signature:
    DB  059h, 0F4h, 0FAh, 037h, 0FFh   ; Hardware signatur / 82730 header

i82730_scb_block:
    ; Intel 82730 System Configuration Block (SCB, 7 bytes) -> kopieres til D000:6000
    DB  001h, 000h, 000h, 020h, 00Dh, 000h, 061h

i82730_cb_block:
    ; Intel 82730 General Command Block (CB, 38 bytes) -> kopieres til D000:2000
    DB  001h, 004h, 040h, 000h, 050h, 000h, 054h, 020h, 00Dh, 000h, 058h, 020h, 00Dh, 000h, 000h, 020h
    DB  00Dh, 000h, 000h, 000h, 000h, 000h, 002h, 000h, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 026h, 020h
    DB  00Dh, 000h, 000h, 050h, 00Dh, 000h

i82730_mode_params_50hz:
    ; Intel 82730 Mode Block (15 kHz DK710 Piccoline / 50 Hz PAL, 54 bytes)
    ; Kopieres af bootprom (FB84:07B5) til D000:2026 i display controllerens styreblok
    DB  000h, 040h            ; +00h: DMA Burst Space=0, Burst Length=64
    DB  004h, 02Fh            ; +02h: HSync Stop=4 tegn, Linjelængde=47 tegn (47*16 clocks)
    DB  02Ah, 007h            ; +04h: H-Field Stop kolonne 42, Start kolonne 7 (35 tegn aktiv bredde)
    DB  02Ah, 007h            ; +06h: H-Border Stop 42, Start 7
    DB  001h, 000h            ; +08h: Blød scroll margin (1 scanlines)
    DB  009h, 000h            ; +0Ah: Lines Per Row (lpr)=9 (10 scanlines pr. tekstlinje)
    DB  009h, 000h            ; +0Ch: Normal tekst start scanline 0, stop 9
    DB  005h, 000h            ; +0Eh: Hævet skrift (superscript) start 0, stop 5
    DB  009h, 006h            ; +10h: Sænket skrift (subscript) start 6, stop 9
    DB  009h, 008h            ; +12h: Markør 1 (understregning): start scanline 8, stop 9
    DB  009h, 000h            ; +14h: Markør 2 (blokmarkør): start scanline 0, stop 9
    DB  009h, 009h            ; +16h: Understregning linjeplacering: U1=9, U2=9
    DB  000h, 000h            ; +18h: Feltattribut-maske (0000h = default)
    DB  038h, 001h            ; +1Ah: Billedhøjde (Frame length)=312 scanlines total
    DB  005h, 000h            ; +1Ch: VSync Stop=5 scanlines
    DB  024h, 000h            ; +1Eh: V-Field Start scanline 36
    DB  01Eh, 001h            ; +20h: V-Field Stop scanline 286 (250 aktive scanlines)
    DB  000h, 000h            ; +22h: Reserveret
    DB  000h, 000h            ; +24h: Reserveret
    DB  001h, 047h            ; +26h: Markør-blink: FrameIntCount=1, Rate=7, Duty=4
    DB  003h, 047h            ; +28h: Tegn-blink: Mode-flag=03h, Rate=7, Duty=4
    DB  000h, 0FEh            ; +2Ah: Attributkontrol / usynlige tegn / linjetæller
    DB  0F9h, 0FFh            ; +2Ch: Display kanal / FIFO timing (FFF9h)
    DB  000h, 030h            ; +2Eh: Display buffer basesegment i RAM (3000h)
    DB  00Dh, 000h            ; +30h: Row table pointer / kanalstyring (000Dh)
    DB  000h, 040h            ; +32h: Skærmhukommelse / VRAM offset (4000h)
    DB  00Dh, 000h            ; +34h: Slutparameter (000Dh)

i82730_mode_params_60hz:
    ; Intel 82730 Mode Block (22 kHz DK914 Partner / 60 Hz, 54 bytes)
    ; Kopieres af bootprom (FB84:07B5) til D000:2026 i display controllerens styreblok
    DB  000h, 040h            ; +00h: DMA Burst Space=0, Burst Length=64
    DB  005h, 038h            ; +02h: HSync Stop=5 tegn, Linjelængde=56 tegn (56*16 clocks)
    DB  033h, 006h            ; +04h: H-Field Stop kolonne 51, Start kolonne 6 (45 tegn aktiv bredde)
    DB  033h, 006h            ; +06h: H-Border Stop 51, Start 6
    DB  001h, 000h            ; +08h: Blød scroll margin (1 scanlines)
    DB  00Dh, 000h            ; +0Ah: Lines Per Row (lpr)=13 (14 scanlines pr. tekstlinje)
    DB  00Dh, 000h            ; +0Ch: Normal tekst start scanline 0, stop 13
    DB  006h, 000h            ; +0Eh: Hævet skrift (superscript) start 0, stop 6
    DB  00Dh, 007h            ; +10h: Sænket skrift (subscript) start 7, stop 13
    DB  00Dh, 00Ch            ; +12h: Markør 1 (understregning): start scanline 12, stop 13
    DB  00Dh, 000h            ; +14h: Markør 2 (blokmarkør): start scanline 0, stop 13
    DB  00Dh, 00Dh            ; +16h: Understregning linjeplacering: U1=13, U2=13
    DB  000h, 000h            ; +18h: Feltattribut-maske (0000h = default)
    DB  079h, 001h            ; +1Ah: Billedhøjde (Frame length)=377 scanlines total
    DB  004h, 000h            ; +1Ch: VSync Stop=4 scanlines
    DB  016h, 000h            ; +1Eh: V-Field Start scanline 22
    DB  05Dh, 001h            ; +20h: V-Field Stop scanline 349 (327 aktive scanlines)
    DB  000h, 000h            ; +22h: Reserveret
    DB  000h, 000h            ; +24h: Reserveret
    DB  001h, 047h            ; +26h: Markør-blink: FrameIntCount=1, Rate=7, Duty=4
    DB  003h, 047h            ; +28h: Tegn-blink: Mode-flag=03h, Rate=7, Duty=4
    DB  000h, 0FEh            ; +2Ah: Attributkontrol / usynlige tegn / linjetæller
    DB  0FDh, 0FFh            ; +2Ch: Display kanal / FIFO timing (FFFDh)
    DB  000h, 030h            ; +2Eh: Display buffer basesegment i RAM (3000h)
    DB  00Dh, 000h            ; +30h: Row table pointer / kanalstyring (000Dh)
    DB  000h, 040h            ; +32h: Skærmhukommelse / VRAM offset (4000h)
    DB  00Dh, 000h            ; +34h: Slutparameter (000Dh)

special_glyphs_01_to_1f:
    ; Specialtegn og grafik-ikoner (ROM offset 009Eh - 01DCh)
    DB  000h                  ; ........ [009Eh]
    DB  000h                  ; ........ [009Fh]
    DB  000h                  ; ........ [00A0h]
    DB  000h                  ; ........ [00A1h]
    DB  000h                  ; ........ [00A2h]
    DB  000h                  ; ........ [00A3h]
    DB  000h                  ; ........ [00A4h]
    DB  000h                  ; ........ [00A5h]
    DB  000h                  ; ........ [00A6h]
    DB  000h                  ; ........ [00A7h]
    DB  000h                  ; ........ [00A8h]
    DB  001h                  ; .......# [00A9h]
    DB  000h                  ; ........ [00AAh]
    DB  010h                  ; ...#.... [00ABh]
    DB  020h                  ; ..#..... [00ACh]
    DB  07Ch                  ; .#####.. [00ADh]
    DB  020h                  ; ..#..... [00AEh]
    DB  038h                  ; ..###... [00AFh]
    DB  020h                  ; ..#..... [00B0h]
    DB  07Ch                  ; .#####.. [00B1h]
    DB  000h                  ; ........ [00B2h]
    DB  000h                  ; ........ [00B3h]
    DB  002h                  ; ......#. [00B4h]
    DB  000h                  ; ........ [00B5h]
    DB  044h                  ; .#...#.. [00B6h]
    DB  010h                  ; ...#.... [00B7h]
    DB  028h                  ; ..#.#... [00B8h]
    DB  044h                  ; .#...#.. [00B9h]
    DB  07Ch                  ; .#####.. [00BAh]
    DB  044h                  ; .#...#.. [00BBh]
    DB  044h                  ; .#...#.. [00BCh]
    DB  000h                  ; ........ [00BDh]
    DB  000h                  ; ........ [00BEh]
    DB  003h                  ; ......## [00BFh]
    DB  000h                  ; ........ [00C0h]
    DB  044h                  ; .#...#.. [00C1h]
    DB  010h                  ; ...#.... [00C2h]
    DB  028h                  ; ..#.#... [00C3h]
    DB  044h                  ; .#...#.. [00C4h]
    DB  044h                  ; .#...#.. [00C5h]
    DB  028h                  ; ..#.#... [00C6h]
    DB  010h                  ; ...#.... [00C7h]
    DB  000h                  ; ........ [00C8h]
    DB  000h                  ; ........ [00C9h]
    DB  004h                  ; .....#.. [00CAh]
    DB  000h                  ; ........ [00CBh]
    DB  010h                  ; ...#.... [00CCh]
    DB  020h                  ; ..#..... [00CDh]
    DB  038h                  ; ..###... [00CEh]
    DB  044h                  ; .#...#.. [00CFh]
    DB  07Ch                  ; .#####.. [00D0h]
    DB  040h                  ; .#...... [00D1h]
    DB  03Ch                  ; ..####.. [00D2h]
    DB  000h                  ; ........ [00D3h]
    DB  000h                  ; ........ [00D4h]
    DB  005h                  ; .....#.# [00D5h]
    DB  000h                  ; ........ [00D6h]
    DB  044h                  ; .#...#.. [00D7h]
    DB  000h                  ; ........ [00D8h]
    DB  038h                  ; ..###... [00D9h]
    DB  004h                  ; .....#.. [00DAh]
    DB  038h                  ; ..###... [00DBh]
    DB  048h                  ; .#..#... [00DCh]
    DB  07Ch                  ; .#####.. [00DDh]
    DB  000h                  ; ........ [00DEh]
    DB  000h                  ; ........ [00DFh]
    DB  006h                  ; .....##. [00E0h]
    DB  000h                  ; ........ [00E1h]
    DB  044h                  ; .#...#.. [00E2h]
    DB  000h                  ; ........ [00E3h]
    DB  038h                  ; ..###... [00E4h]
    DB  044h                  ; .#...#.. [00E5h]
    DB  044h                  ; .#...#.. [00E6h]
    DB  044h                  ; .#...#.. [00E7h]
    DB  038h                  ; ..###... [00E8h]
    DB  000h                  ; ........ [00E9h]
    DB  000h                  ; ........ [00EAh]
    DB  008h                  ; ....#... [00EBh]
    DB  000h                  ; ........ [00ECh]
    DB  078h                  ; .####... [00EDh]
    DB  044h                  ; .#...#.. [00EEh]
    DB  044h                  ; .#...#.. [00EFh]
    DB  048h                  ; .#..#... [00F0h]
    DB  044h                  ; .#...#.. [00F1h]
    DB  044h                  ; .#...#.. [00F2h]
    DB  048h                  ; .#..#... [00F3h]
    DB  000h                  ; ........ [00F4h]
    DB  000h                  ; ........ [00F5h]
    DB  009h                  ; ....#..# [00F6h]
    DB  000h                  ; ........ [00F7h]
    DB  038h                  ; ..###... [00F8h]
    DB  028h                  ; ..#.#... [00F9h]
    DB  020h                  ; ..#..... [00FAh]
    DB  070h                  ; .###.... [00FBh]
    DB  020h                  ; ..#..... [00FCh]
    DB  024h                  ; ..#..#.. [00FDh]
    DB  078h                  ; .####... [00FEh]
    DB  000h                  ; ........ [00FFh]
    DB  000h                  ; ........ [0100h]
    DB  00Bh                  ; ....#.## [0101h]
    DB  000h                  ; ........ [0102h]
    DB  07Ch                  ; .#####.. [0103h]
    DB  050h                  ; .#.#.... [0104h]
    DB  050h                  ; .#.#.... [0105h]
    DB  078h                  ; .####... [0106h]
    DB  050h                  ; .#.#.... [0107h]
    DB  050h                  ; .#.#.... [0108h]
    DB  05Ch                  ; .#.###.. [0109h]
    DB  000h                  ; ........ [010Ah]
    DB  000h                  ; ........ [010Bh]
    DB  00Ch                  ; ....##.. [010Ch]
    DB  000h                  ; ........ [010Dh]
    DB  038h                  ; ..###... [010Eh]
    DB  044h                  ; .#...#.. [010Fh]
    DB  04Ch                  ; .#..##.. [0110h]
    DB  054h                  ; .#.#.#.. [0111h]
    DB  064h                  ; .##..#.. [0112h]
    DB  044h                  ; .#...#.. [0113h]
    DB  038h                  ; ..###... [0114h]
    DB  000h                  ; ........ [0115h]
    DB  000h                  ; ........ [0116h]
    DB  00Eh                  ; ....###. [0117h]
    DB  000h                  ; ........ [0118h]
    DB  038h                  ; ..###... [0119h]
    DB  028h                  ; ..#.#... [011Ah]
    DB  07Ch                  ; .#####.. [011Bh]
    DB  044h                  ; .#...#.. [011Ch]
    DB  07Ch                  ; .#####.. [011Dh]
    DB  044h                  ; .#...#.. [011Eh]
    DB  044h                  ; .#...#.. [011Fh]
    DB  000h                  ; ........ [0120h]
    DB  000h                  ; ........ [0121h]
    DB  00Fh                  ; ....#### [0122h]
    DB  000h                  ; ........ [0123h]
    DB  044h                  ; .#...#.. [0124h]
    DB  000h                  ; ........ [0125h]
    DB  044h                  ; .#...#.. [0126h]
    DB  044h                  ; .#...#.. [0127h]
    DB  044h                  ; .#...#.. [0128h]
    DB  044h                  ; .#...#.. [0129h]
    DB  038h                  ; ..###... [012Ah]
    DB  000h                  ; ........ [012Bh]
    DB  000h                  ; ........ [012Ch]
    DB  010h                  ; ...#.... [012Dh]
    DB  000h                  ; ........ [012Eh]
    DB  038h                  ; ..###... [012Fh]
    DB  040h                  ; .#...... [0130h]
    DB  038h                  ; ..###... [0131h]
    DB  044h                  ; .#...#.. [0132h]
    DB  044h                  ; .#...#.. [0133h]
    DB  038h                  ; ..###... [0134h]
    DB  004h                  ; .....#.. [0135h]
    DB  038h                  ; ..###... [0136h]
    DB  000h                  ; ........ [0137h]
    DB  011h                  ; ...#...# [0138h]
    DB  000h                  ; ........ [0139h]
    DB  028h                  ; ..#.#... [013Ah]
    DB  028h                  ; ..#.#... [013Bh]
    DB  07Ch                  ; .#####.. [013Ch]
    DB  028h                  ; ..#.#... [013Dh]
    DB  07Ch                  ; .#####.. [013Eh]
    DB  028h                  ; ..#.#... [013Fh]
    DB  028h                  ; ..#.#... [0140h]
    DB  000h                  ; ........ [0141h]
    DB  000h                  ; ........ [0142h]
    DB  012h                  ; ...#..#. [0143h]
    DB  000h                  ; ........ [0144h]
    DB  038h                  ; ..###... [0145h]
    DB  020h                  ; ..#..... [0146h]
    DB  020h                  ; ..#..... [0147h]
    DB  020h                  ; ..#..... [0148h]
    DB  020h                  ; ..#..... [0149h]
    DB  020h                  ; ..#..... [014Ah]
    DB  038h                  ; ..###... [014Bh]
    DB  000h                  ; ........ [014Ch]
    DB  000h                  ; ........ [014Dh]
    DB  013h                  ; ...#..## [014Eh]
    DB  000h                  ; ........ [014Fh]
    DB  040h                  ; .#...... [0150h]
    DB  040h                  ; .#...... [0151h]
    DB  020h                  ; ..#..... [0152h]
    DB  010h                  ; ...#.... [0153h]
    DB  008h                  ; ....#... [0154h]
    DB  004h                  ; .....#.. [0155h]
    DB  004h                  ; .....#.. [0156h]
    DB  000h                  ; ........ [0157h]
    DB  000h                  ; ........ [0158h]
    DB  014h                  ; ...#.#.. [0159h]
    DB  000h                  ; ........ [015Ah]
    DB  038h                  ; ..###... [015Bh]
    DB  008h                  ; ....#... [015Ch]
    DB  008h                  ; ....#... [015Dh]
    DB  008h                  ; ....#... [015Eh]
    DB  008h                  ; ....#... [015Fh]
    DB  008h                  ; ....#... [0160h]
    DB  038h                  ; ..###... [0161h]
    DB  000h                  ; ........ [0162h]
    DB  000h                  ; ........ [0163h]
    DB  015h                  ; ...#.#.# [0164h]
    DB  010h                  ; ...#.... [0165h]
    DB  028h                  ; ..#.#... [0166h]
    DB  000h                  ; ........ [0167h]
    DB  000h                  ; ........ [0168h]
    DB  000h                  ; ........ [0169h]
    DB  000h                  ; ........ [016Ah]
    DB  000h                  ; ........ [016Bh]
    DB  000h                  ; ........ [016Ch]
    DB  000h                  ; ........ [016Dh]
    DB  000h                  ; ........ [016Eh]
    DB  016h                  ; ...#.##. [016Fh]
    DB  000h                  ; ........ [0170h]
    DB  010h                  ; ...#.... [0171h]
    DB  008h                  ; ....#... [0172h]
    DB  000h                  ; ........ [0173h]
    DB  000h                  ; ........ [0174h]
    DB  000h                  ; ........ [0175h]
    DB  000h                  ; ........ [0176h]
    DB  000h                  ; ........ [0177h]
    DB  000h                  ; ........ [0178h]
    DB  000h                  ; ........ [0179h]
    DB  017h                  ; ...#.### [017Ah]
    DB  000h                  ; ........ [017Bh]
    DB  00Ch                  ; ....##.. [017Ch]
    DB  010h                  ; ...#.... [017Dh]
    DB  010h                  ; ...#.... [017Eh]
    DB  060h                  ; .##..... [017Fh]
    DB  010h                  ; ...#.... [0180h]
    DB  010h                  ; ...#.... [0181h]
    DB  00Ch                  ; ....##.. [0182h]
    DB  000h                  ; ........ [0183h]
    DB  000h                  ; ........ [0184h]
    DB  018h                  ; ...##... [0185h]
    DB  000h                  ; ........ [0186h]
    DB  010h                  ; ...#.... [0187h]
    DB  010h                  ; ...#.... [0188h]
    DB  010h                  ; ...#.... [0189h]
    DB  000h                  ; ........ [018Ah]
    DB  010h                  ; ...#.... [018Bh]
    DB  010h                  ; ...#.... [018Ch]
    DB  010h                  ; ...#.... [018Dh]
    DB  000h                  ; ........ [018Eh]
    DB  000h                  ; ........ [018Fh]
    DB  019h                  ; ...##..# [0190h]
    DB  000h                  ; ........ [0191h]
    DB  060h                  ; .##..... [0192h]
    DB  010h                  ; ...#.... [0193h]
    DB  010h                  ; ...#.... [0194h]
    DB  00Ch                  ; ....##.. [0195h]
    DB  010h                  ; ...#.... [0196h]
    DB  010h                  ; ...#.... [0197h]
    DB  060h                  ; .##..... [0198h]
    DB  000h                  ; ........ [0199h]
    DB  000h                  ; ........ [019Ah]
    DB  01Ah                  ; ...##.#. [019Bh]
    DB  000h                  ; ........ [019Ch]
    DB  036h                  ; ..##.##. [019Dh]
    DB  05Ch                  ; .#.###.. [019Eh]
    DB  000h                  ; ........ [019Fh]
    DB  000h                  ; ........ [01A0h]
    DB  000h                  ; ........ [01A1h]
    DB  000h                  ; ........ [01A2h]
    DB  000h                  ; ........ [01A3h]
    DB  000h                  ; ........ [01A4h]
    DB  000h                  ; ........ [01A5h]
    DB  01Bh                  ; ...##.## [01A6h]
    DB  000h                  ; ........ [01A7h]
    DB  038h                  ; ..###... [01A8h]
    DB  044h                  ; .#...#.. [01A9h]
    DB  05Ch                  ; .#.###.. [01AAh]
    DB  054h                  ; .#.#.#.. [01ABh]
    DB  058h                  ; .#.##... [01ACh]
    DB  040h                  ; .#...... [01ADh]
    DB  038h                  ; ..###... [01AEh]
    DB  000h                  ; ........ [01AFh]
    DB  000h                  ; ........ [01B0h]
    DB  01Ch                  ; ...###.. [01B1h]
    DB  000h                  ; ........ [01B2h]
    DB  000h                  ; ........ [01B3h]
    DB  000h                  ; ........ [01B4h]
    DB  038h                  ; ..###... [01B5h]
    DB  054h                  ; .#.#.#.. [01B6h]
    DB  05Ch                  ; .#.###.. [01B7h]
    DB  050h                  ; .#.#.... [01B8h]
    DB  02Ch                  ; ..#.##.. [01B9h]
    DB  000h                  ; ........ [01BAh]
    DB  000h                  ; ........ [01BBh]
    DB  01Dh                  ; ...###.# [01BCh]
    DB  000h                  ; ........ [01BDh]
    DB  000h                  ; ........ [01BEh]
    DB  000h                  ; ........ [01BFh]
    DB  038h                  ; ..###... [01C0h]
    DB  04Ch                  ; .#..##.. [01C1h]
    DB  054h                  ; .#.#.#.. [01C2h]
    DB  064h                  ; .##..#.. [01C3h]
    DB  038h                  ; ..###... [01C4h]
    DB  000h                  ; ........ [01C5h]
    DB  000h                  ; ........ [01C6h]
    DB  01Eh                  ; ...####. [01C7h]
    DB  000h                  ; ........ [01C8h]
    DB  018h                  ; ...##... [01C9h]
    DB  018h                  ; ...##... [01CAh]
    DB  03Ch                  ; ..####.. [01CBh]
    DB  004h                  ; .....#.. [01CCh]
    DB  03Ch                  ; ..####.. [01CDh]
    DB  044h                  ; .#...#.. [01CEh]
    DB  03Ch                  ; ..####.. [01CFh]
    DB  000h                  ; ........ [01D0h]
    DB  000h                  ; ........ [01D1h]
    DB  01Fh                  ; ...##### [01D2h]
    DB  000h                  ; ........ [01D3h]
    DB  000h                  ; ........ [01D4h]
    DB  048h                  ; .#..#... [01D5h]
    DB  000h                  ; ........ [01D6h]
    DB  048h                  ; .#..#... [01D7h]
    DB  048h                  ; .#..#... [01D8h]
    DB  048h                  ; .#..#... [01D9h]
    DB  034h                  ; ..##.#.. [01DAh]
    DB  000h                  ; ........ [01DBh]
    DB  000h                  ; ........ [01DCh]

; ----------------------------------------------------------------------------
; 15 kHz Piccoline skærmfont (DK710, 10 scanlines pr. tegn, ROM 01DDh - 0D3Fh)
; ----------------------------------------------------------------------------
%include "font_50hz_dk710.inc"

; ----------------------------------------------------------------------------
; 22 kHz Partner-skærm font (DK914, 14 scanlines pr. tegn, ROM 0D40h - 2161h)
; ----------------------------------------------------------------------------
%include "font_60hz_dk914.inc"


; ============================================================================
; SECTION 2: LOOKUP TABLES, SYSTEM STRINGS & IVT PROTOTYPE (2162h - 383Fh)
; ============================================================================
; --- table_keyboard_scancodes: Scancode til ASCII / styretaster konverteringstabel (2162h - 21D2h) ---
table_keyboard_scancodes:
    DB  039h, 020h, 04Fh, 092h, 050h, 093h, 04Dh, 090h, 04Eh, 091h, 037h, 01Bh, 01Ch, 00Dh, 00Eh, 058h
    DB  033h, 02Ch, 00Bh, 030h, 002h, 031h, 003h, 032h, 004h, 033h, 005h, 034h, 006h, 035h, 007h, 036h
    DB  008h, 037h, 009h, 038h, 00Ah, 039h, 061h, 030h, 05Dh, 031h, 05Eh, 032h, 05Fh, 033h, 058h, 034h
    DB  059h, 035h, 05Ah, 036h, 053h, 037h, 054h, 038h, 055h, 039h, 01Eh, 041h, 030h, 042h, 02Eh, 043h
    DB  020h, 044h, 012h, 045h, 021h, 046h, 022h, 047h, 023h, 048h, 024h, 04Ah, 017h, 049h, 025h, 04Bh
    DB  026h, 04Ch, 032h, 04Dh, 031h, 04Eh, 018h, 04Fh, 019h, 050h, 011h, 057h, 02Dh, 058h, 015h, 059h
    DB  010h, 051h, 013h, 052h, 01Fh, 053h, 014h, 054h, 016h, 055h, 02Fh, 056h, 02Ch, 05Ah, 000h, 015h

; --- str_selftest_error_messages: Selftest og POST fejlmeddelelser (Pascal counted strings) (21D2h - 2248h) ---
str_selftest_error_messages:
    DB  ' Prom checksum e'
    DB  072h, 072h, 06Fh, 072h, 020h, 003h, 011h, 052h, 041h, 04Dh, 020h, 06Dh, 065h, 06Dh, 06Fh, 072h
    DB  079h, 020h, 065h, 072h, 072h, 06Fh, 072h, 020h, 006h, 03Ah, 04Dh, 065h, 06Dh, 06Fh, 072h, 079h
    DB  020h, 074h, 065h, 073h, 074h, 020h, 03Ah, 011h, 069h, 06Ch, 06Ch, 065h, 067h, 061h, 06Ch, 020h
    DB  069h, 06Eh, 074h, 065h, 072h, 072h, 075h, 070h, 074h, 004h, 018h, 03Eh, 03Eh, 020h, 069h, 06Eh
    DB  'struction except'
    DB  069h, 06Fh, 06Eh, 0FFh, 010h, 063h, 072h, 074h, 020h, 073h, 074h, 061h, 074h, 075h, 073h, 020h
    DB  065h, 072h, 072h, 06Fh, 072h, 003h

; --- prototype_ivt_table: Initialiseringsvektorer for Interrupt Vector Table (IVT 0000:0000) (2248h - 22B8h) ---
prototype_ivt_table:
    DW  00AB5h, CODE_SEGMENT_BASE  ; Int 00h (0000:0000h): Divide Error ISR (FB84:0AB5h)
    DW  00AB5h, CODE_SEGMENT_BASE  ; Int 01h (0000:0004h): Single Step / Debug ISR (FB84:0AB5h)
    DW  00AC1h, CODE_SEGMENT_BASE  ; Int 02h (0000:0008h): NMI Non-Maskable Interrupt ISR (FB84:0AC1h)
    DW  00AB5h, CODE_SEGMENT_BASE  ; Int 03h (0000:000Ch): Breakpoint ISR (FB84:0AB5h)
    DW  00AB5h, CODE_SEGMENT_BASE  ; Int 04h (0000:0010h): Overflow (INTO) ISR (FB84:0AB5h)
    DW  00AB5h, CODE_SEGMENT_BASE  ; Int 05h (0000:0014h): Print Screen / BOUND ISR (FB84:0AB5h)
    DW  00AB5h, CODE_SEGMENT_BASE  ; Int 06h (0000:0018h): Invalid Opcode ISR (FB84:0AB5h)
    DW  00AB5h, CODE_SEGMENT_BASE  ; Int 07h (0000:001Ch): Coprocessor Not Available ISR (FB84:0AB5h)
    DW  00AD7h, CODE_SEGMENT_BASE  ; Int 08h (0000:0020h): IRQ 0 System Timer ISR (FB84:0AD7h)
    DW  00ABBh, CODE_SEGMENT_BASE  ; Int 09h (0000:0024h): IRQ 1 Keyboard ISR (FB84:0ABBh)
    DW  00AD7h, CODE_SEGMENT_BASE  ; Int 0Ah (0000:0028h): IRQ 2 Slave PIC / Reserved ISR (FB84:0AD7h)
    DW  00AD7h, CODE_SEGMENT_BASE  ; Int 0Bh (0000:002Ch): IRQ 3 Serial COM2 ISR (FB84:0AD7h)
    DW  00AD7h, CODE_SEGMENT_BASE  ; Int 0Ch (0000:0030h): IRQ 4 Serial COM1 ISR (FB84:0AD7h)
    DW  00483h, CODE_SEGMENT_BASE  ; Int 0Dh (0000:0034h): IRQ 5 Floppy Disk Controller (WD2797) ISR (FB84:0483h)
    DW  00AD7h, CODE_SEGMENT_BASE  ; Int 0Eh (0000:0038h): IRQ 6 Centronics Printer ISR (FB84:0AD7h)
    DW  00AD7h, CODE_SEGMENT_BASE  ; Int 0Fh (0000:003Ch): IRQ 7 Real Time Clock (MM58167) ISR (FB84:0AD7h)
    DW  00ABBh, CODE_SEGMENT_BASE  ; Int 10h (0000:0040h): 80186 Internal Timer 0 ISR (FB84:0ABBh)
    DW  00ABBh, CODE_SEGMENT_BASE  ; Int 11h (0000:0044h): 80186 Internal Timer 1 ISR (FB84:0ABBh)
    DW  00AD7h, CODE_SEGMENT_BASE  ; Int 12h (0000:0048h): 80186 Internal Timer 2 ISR (FB84:0AD7h)
    DW  00AD7h, CODE_SEGMENT_BASE  ; Int 13h (0000:004Ch): 80186 DMA Channel 0 ISR (FB84:0AD7h)
    DW  00AD7h, CODE_SEGMENT_BASE  ; Int 14h (0000:0050h): 80186 DMA Channel 1 ISR (FB84:0AD7h)
    DW  00428h, CODE_SEGMENT_BASE  ; Int 15h (0000:0054h): 80186 Internal Interrupt ISR (FB84:0428h)
    DW  00AD7h, CODE_SEGMENT_BASE  ; Int 16h (0000:0058h): Reserveret hardware afbrydelse ISR (FB84:0AD7h)
    DW  00AD7h, CODE_SEGMENT_BASE  ; Int 17h (0000:005Ch): Reserveret hardware afbrydelse ISR (FB84:0AD7h)
    DW  00A60h, CODE_SEGMENT_BASE  ; Int 18h (0000:0060h): DMA Channel 0 Handler ISR (FB84:0A60h)
    DW  00AD7h, CODE_SEGMENT_BASE  ; Int 19h (0000:0064h): Reserveret hardware afbrydelse ISR (FB84:0AD7h)
    DW  00AD7h, CODE_SEGMENT_BASE  ; Int 1Ah (0000:0068h): Reserveret hardware afbrydelse ISR (FB84:0AD7h)
    DW  00AD7h, CODE_SEGMENT_BASE  ; Int 1Bh (0000:006Ch): Reserveret hardware afbrydelse ISR (FB84:0AD7h)

; --- str_snooper_commands: Snooper monitor / memory debugger prompt-tekster (22B8h - 2379h) ---
str_snooper_commands:
    DB  '>> Snooper' , 0Dh  , 0Ah , '>> E'
    DB  'nd of snooper' , 0Dh  , 0Ah  , 0Dh 
    DB  '' , 0Ah , '<O> : output to'
    DB  ' port' , 0Dh  , 0Ah , '<I> : inp'
    DB  'ut from port' , 0Dh  , 0Ah , '<N'
    DB  '> : substitute w'
    DB  'ord' , 0Dh  , 0Ah , '<M> : displ'
    DB  'ay memory' , 0Dh  , 0Ah , '<,> :'
    DB  ' continue select'
    DB  'ed' , 0Dh  , 0Ah , '<X> : exit f'
    DB  072h, 06Fh, 06Dh, 020h, 073h, 06Eh, 06Fh, 06Fh, 070h, 065h, 072h, 00Dh, 00Ah, 0FFh, 070h, 06Fh
    DB  'rt : data :segm.'
    DB  03Ah

; --- str_piccoline_test_banner: Banner: *** PICCOLINE TEST, V.2.1 *** (2379h - 2396h) ---
str_piccoline_test_banner:
    DB  '*** PICCOLINE TE'
    DB  'ST, V.2.1 ***'

; --- str_piccoline_selftest_banner: Banner: *** PICCOLINE, PC, Selftest, V.2.1 *** (2396h - 23CDh) ---
str_piccoline_selftest_banner:
    DB  '' , 0Dh , '*** PICCOLINE, '
    DB  'PC, Selftest, V.'
    DB  '2.1 ***' , 0Dh  , 0Ah , ' error '
    DB  '' , 0Dh  , 0Ah , 'END' , 0Dh  , 0Ah 

; --- str_error_formatting: Register- og adresseudskriftsformater (23CDh - 247Ah) ---
str_error_formatting:
    DB  ', addr.: , exp.:'
    DB  ' , rec.: , lev.:'
    DB  ' , reg.:, segm.:'
    DB  ', stat :  drive:'
    DB  ' ? <Y/N>, > Para'
    DB  'meters <' , 0Dh  , 0Ah , 'halt o'
    DB  'n error        l'
    DB  'oop in test     '
    DB  '    boot after t'
    DB  'est      suppres'
    DB  's status chec'

; --- str_selftest_menu: Selftest menu (<0> proceed, <1> list, <2> snooper, etc.) (247Ah - 2512h) ---
str_selftest_menu:
    DB  'ksuppress data c'
    DB  068h, 065h, 063h, 06Bh, 020h, 020h, 012h, 074h, 065h, 073h, 074h, 020h, 06Eh, 06Fh, 02Eh, 03Ah
    DB  020h, 074h, 06Fh, 06Fh, 020h, 062h, 069h, 067h, 021h, 0FFh, 02Dh, 02Dh, 048h, 041h, 04Ch, 054h
    DB  'ED--' , 0Dh  , 0Ah , '**** pass '
    DB  ':' , 0Dh  , 0Ah , '---- MENU ---'
    DB  '-' , 0Dh  , 0Ah , '<0>: proceed '
    DB  'test' , 0Dh  , 0Ah , '<1>: list '
    DB  'of tests' , 0Dh  , 0Ah , '<2>: e'
    DB  'nter snooper' , 0Dh  , 0Ah , '<3'
    DB  '>: chang'

; --- str_hardware_config: Hardwarekonfiguration visningstekster (2512h - 2609h) ---
str_hardware_config:
    DB  'e parameters' , 0Dh  , 0Ah , '<4'
    DB  '>: show hardware'
    DB  ' configuration' , 0Dh  , 0Ah 
    DB  '<5>: CONFIG PROG'
    DB  'RAM' , 0Dh  , 0Ah  , 0Dh  , 0Ah , 'SELECT FR'
    DB  04Fh, 04Dh, 020h, 04Dh, 045h, 04Eh, 055h, 020h, 03Ah, 0FFh, 052h, 041h, 04Dh, 020h, 073h, 069h
    DB  'ze, NET, DPA ADA'
    DB  'PTER, iSBX contr'
    DB  'oller' , 0Dh  , 0Ah , ' KB  YES '
    DB  '    KB  NO      '
    DB  ' YES          NO'
    DB  '        Remote P'
    DB  'rinter NOT READY'
    DB  '  No DPA Adapter'
    DB  '  NO FLOPPY RESE'
    DB  'RVATION'

; --- diag_test_menu_config: Selftest menustyring og konfigurationsparametre (2609h - 262Dh) ---
diag_test_menu_config:
    DB  020h, 0CDh, 023h, 000h, 000h, 002h, 0D5h, 023h, 002h, 000h, 003h, 0DDh, 023h, 004h, 000h, 0FFh
    DB  0E5h, 023h, 000h, 000h, 0FFh, 0EDh, 023h, 000h, 000h, 002h, 0F5h, 023h, 006h, 000h, 001h, 0FDh
    DB  023h, 004h, 000h, 0FFh

; --- diag_test_jump_table: Tabel over de 15 POST selftest-funktioner i FB84-segmentet (CALL [ES:DI+262Dh]) (262Dh - 264Bh) ---
diag_test_jump_table:
    DW  sub_0524                     ; Test  0: Selftest initialisering / dummy
    DW  sub_14d6                     ; Test  1: RAM refresh & hukommelsestest (FB84:14D6h)
    DW  sub_1a79                     ; Test  2: Intel 8255 PPI interface test (FB84:1A79h)
    DW  sub_1af6                     ; Test  3: Lokal Centronics printerport test (FB84:1AF6h)
    DW  sub_1ada                     ; Test  4: Non-volatile memory (NVRAM) test (FB84:1ADAh)
    DW  sub_1530                     ; Test  5: 80186 Timer 0/1/2 test (FB84:1530h)
    DW  sub_1693                     ; Test  6: 80186 DMA kanal 0/1 test (FB84:1693h)
    DW  sub_1752                     ; Test  7: 80186 Interne afbrydelser test (FB84:1752h)
    DW  sub_170c                     ; Test  8: Intel 8259A PIC afbrydelsestest (FB84:170Ch)
    DW  sub_17b6                     ; Test  9: Tastatur-interface test (FB84:17B6h)
    DW  sub_1b89                     ; Test 10: Båndoptager (Cassette) interface test (FB84:1B89h)
    DW  sub_1d88                     ; Test 11: Ekstern Centronics printerport test (FB84:1D88h)
    DW  sub_186e                     ; Test 12: Intel 82586 Ethernet LAN controller test (FB84:186Eh)
    DW  sub_1ee3                     ; Test 13: Diskette-controller (WD2797 FDC) test (FB84:1EE3h)
    DW  sub_1c59                     ; Test 14: Intel 82730 Display tekstcontroller test (FB84:1C59h)

; --- diag_test_descriptor_table: Deskriptorer for de 14 selftest-titler (DW text_ptr, DW text_len) (264Bh - 2683h) ---
diag_test_descriptor_table:
    DW  026E7h, 00012h            ; Test  1: "RAM refresh test :"
    DW  028F5h, 0000Ah            ; Test  2: "PPI 8255 :"
    DW  02939h, 0001Bh            ; Test  3: "Local Centronic Interface :"
    DW  02910h, 00015h            ; Test  4: "Non volatile memory :"
    DW  02708h, 00014h            ; Test  5: "iAPX186 Timer test :"
    DW  0272Ch, 00012h            ; Test  6: "iAPX186 DMA test :"
    DW  02779h, 00018h            ; Test  7: "iAPX186 interrupt test :"
    DW  02764h, 00015h            ; Test  8: "8259 interrupt test :"
    DW  027E1h, 0000Ah            ; Test  9: "Keyboard :"
    DW  0297Bh, 0000Eh            ; Test 10: "CASSETTE TEST:"
    DW  029CCh, 0001Ch            ; Test 11: "Remote Centronic Interface :"
    DW  0280Ch, 0000Bh            ; Test 12: "LAN 82586 :"
    DW  02A0Fh, 0000Fh            ; Test 13: "Flexible disk :"
    DW  029A2h, 0000Eh            ; Test 14: "Display test :"

; --- diag_error_code_table: Selftest fejlkodetabel med pointere til fejltekster (DB kode, DW str_ptr) (2683h - 26E7h) ---
diag_error_code_table:
    DB  007h, 090h, 024h            ; Tabel-header (2490h)
    DB  001h, 0D1h, 021h      ; Fejlkode 01h: "Prom checksum error" (21D1h)
    DB  002h, 0E8h, 021h      ; Fejlkode 02h: "RAM memory error" (21E8h)
    DB  003h, 03Eh, 027h      ; Fejlkode 03h: "data error" (273Eh)
    DB  004h, 04Ah, 027h      ; Fejlkode 04h: "transfer count error" (274Ah)
    DB  005h, 009h, 022h      ; Fejlkode 05h: "illegal interrupt" (2209h)
    DB  006h, 091h, 027h      ; Fejlkode 06h: "interrupt timeout" (2791h)
    DB  008h, 01Ch, 022h      ; Fejlkode 08h: ">> instruction exception" (221Ch)
    DB  009h, 0F9h, 026h      ; Fejlkode 09h: "not refreshed" (26F9h)
    DB  00Ah, 01Ch, 027h      ; Fejlkode 0Ah: "counting error" (271Ch)
    DB  00Bh, 0A4h, 027h      ; Fejlkode 0Bh: "illegal interrupt serviced" (27A4h)
    DB  00Ch, 0C0h, 027h      ; Fejlkode 0Ch: "timeout" (27C0h)
    DB  00Dh, 0C9h, 027h      ; Fejlkode 0Dh: "illegal level serviced" (27C9h)
    DB  010h, 036h, 022h      ; Fejlkode 10h: "crt status error" (2236h)
    DB  011h, 0EBh, 027h      ; Fejlkode 11h: "Test result" (27EBh)
    DB  012h, 0FFh, 028h      ; Fejlkode 12h: "port, bit error" (28FFh)
    DB  013h, 025h, 029h      ; Fejlkode 13h: "Incorrect checksum" (2925h)
    DB  018h, 054h, 029h      ; Fejlkode 18h: "control signals" (2954h)
    DB  019h, 065h, 029h      ; Fejlkode 19h: "data signals" (2965h)
    DB  01Ah, 01Eh, 02Ah      ; Fejlkode 1Ah: "Data lost" (2A1Eh)
    DB  01Bh, 02Ah, 02Ah      ; Fejlkode 1Bh: "CRC error" (2A2Ah)
    DB  01Ch, 036h, 02Ah      ; Fejlkode 1Ch: "Record not found" (2A36h)
    DB  01Dh, 049h, 02Ah      ; Fejlkode 1Dh: "Seek error" (2A49h)
    DB  01Eh, 056h, 02Ah      ; Fejlkode 1Eh: "NOT READY" (2A56h)
    DB  020h, 089h, 029h      ; Fejlkode 20h: "data error" (2989h)
    DB  021h, 095h, 029h      ; Fejlkode 21h: "shift error" (2995h)
    DB  022h, 0E8h, 029h      ; Fejlkode 22h: "control signals" (29E8h)
    DB  023h, 0F9h, 029h      ; Fejlkode 23h: "data signals" (29F9h)
    DB  024h, 02Eh, 028h      ; Fejlkode 24h: "Self Diagnostic error" (282Eh)
    DB  025h, 045h, 028h      ; Fejlkode 25h: "Transmit Status error" (2845h)
    DB  026h, 05Ch, 028h      ; Fejlkode 26h: "Loop Back Data error" (285Ch)
    DB  027h, 072h, 028h      ; Fejlkode 27h: "Missing interrupt" (2872h)
    DB  028h, 085h, 028h      ; Fejlkode 28h: "Receive Status error" (2885h)
    DB  000h                           ; Afslutning på fejlkodetabel (26E6h)

; --- str_diagnostic_tests: Tekster for RAM refresh, Timer, DMA, 8259, LAN 82586, FDC (26E7h - 28B0h) ---
str_diagnostic_tests:
    DB  'RAM refresh test'
    DB  ' :' , 0Dh , 'not refreshed'
    DB  001h, 069h, 041h, 050h, 058h, 031h, 038h, 036h, 020h, 054h, 069h, 06Dh, 065h, 072h, 020h, 074h
    DB  065h, 073h, 074h, 020h, 03Ah, 00Eh, 063h, 06Fh, 075h, 06Eh, 074h, 069h, 06Eh, 067h, 020h, 065h
    DB  072h, 072h, 06Fh, 072h, 005h, 069h, 041h, 050h, 058h, 031h, 038h, 036h, 020h, 044h, 04Dh, 041h
    DB  ' test :' , 0Ah , 'data err'
    DB  06Fh, 072h, 001h, 014h, 074h, 072h, 061h, 06Eh, 073h, 066h, 065h, 072h, 020h, 063h, 06Fh, 075h
    DB  06Eh, 074h, 020h, 065h, 072h, 072h, 06Fh, 072h, 005h, 003h, 017h, 084h, 0FBh, 038h, 032h, 035h
    DB  '9 interrupt test'
    DB  ' :iAPX186 interr'
    DB  075h, 070h, 074h, 020h, 074h, 065h, 073h, 074h, 020h, 03Ah, 011h, 069h, 06Eh, 074h, 065h, 072h
    DB  072h, 075h, 070h, 074h, 020h, 074h, 069h, 06Dh, 065h, 06Fh, 075h, 074h, 0FFh, 01Ah, 069h, 06Ch
    DB  'legal interrupt '
    DB  073h, 065h, 072h, 076h, 069h, 063h, 065h, 064h, 004h, 007h, 074h, 069h, 06Dh, 065h, 06Fh, 075h
    DB  074h, 0FFh, 016h, 069h, 06Ch, 06Ch, 065h, 067h, 061h, 06Ch, 020h, 06Ch, 065h, 076h, 065h, 06Ch
    DB  020h, 073h, 065h, 072h, 076h, 069h, 063h, 065h, 064h, 004h, 04Bh, 065h, 079h, 062h, 06Fh, 061h
    DB  072h, 064h, 020h, 03Ah, 00Bh, 054h, 065h, 073h, 074h, 020h, 072h, 065h, 073h, 075h, 06Ch, 074h
    DB  003h, 06Eh, 06Fh, 020h, 072h, 065h, 073h, 075h, 06Ch, 074h, 020h, 072h, 065h, 063h, 065h, 069h
    DB  'ved, LAN 82586 :'
    DB  'No Network Contr'
    DB  06Fh, 06Ch, 06Ch, 065h, 072h, 00Dh, 00Ah, 015h, 053h, 065h, 06Ch, 066h, 020h, 044h, 069h, 061h
    DB  067h, 06Eh, 06Fh, 073h, 074h, 069h, 063h, 020h, 065h, 072h, 072h, 06Fh, 072h, 007h, 015h, 054h
    DB  'ransmit Status e'
    DB  072h, 072h, 06Fh, 072h, 007h, 014h, 04Ch, 06Fh, 06Fh, 070h, 020h, 042h, 061h, 063h, 06Bh, 020h
    DB  044h, 061h, 074h, 061h, 020h, 065h, 072h, 072h, 06Fh, 072h, 002h, 011h, 04Dh, 069h, 073h, 073h
    DB  069h, 06Eh, 067h, 020h, 069h, 06Eh, 074h, 065h, 072h, 072h, 075h, 070h, 074h, 0FFh, 014h, 052h
    DB  'eceive Status er'
    DB  072h, 06Fh, 072h, 007h, 000h, 000h, 000h, 000h, 01Ah, 064h, 04Ch, 064h, 000h, 000h, 000h, 000h
    DB  000h, 000h, 000h, 000h, 000h, 000h, 002h, 0E0h, 000h

; --- data_subsystems_and_messages: Undersystem-parametre og perifere testblokke (28B0h - 317Ah) ---
data_subsystems_and_messages:
    DB  000h, 00Ch, 008h, 000h, 066h, 000h, 060h, 000h, 0F2h, 001h, 000h, 010h, 000h, 000h, 000h, 004h
    DB  0E0h, 000h, 000h, 038h, 064h, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 000h, 000h, 010h, 080h, 038h
    DB  064h, 000h, 004h, 000h, 000h, 000h, 000h, 000h, 0C0h, 000h, 000h, 062h, 064h, 000h, 000h, 000h
    DB  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 062h, 064h, 000h
    DB  024h, 000h, 000h, 010h, 080h, 050h, 050h, 049h, 020h, 038h, 032h, 035h, 035h, 020h, 03Ah, 00Fh
    DB  070h, 06Fh, 072h, 074h, 02Ch, 020h, 062h, 069h, 074h, 020h, 065h, 072h, 072h, 06Fh, 072h, 002h
    DB  'Non volatile mem'
    DB  06Fh, 072h, 079h, 020h, 03Ah, 012h, 049h, 06Eh, 063h, 06Fh, 072h, 072h, 065h, 063h, 074h, 020h
    DB  063h, 068h, 065h, 063h, 06Bh, 073h, 075h, 06Dh, 003h, 04Ch, 06Fh, 063h, 061h, 06Ch, 020h, 043h
    DB  'entronic Interfa'
    DB  063h, 065h, 020h, 03Ah, 00Fh, 063h, 06Fh, 06Eh, 074h, 072h, 06Fh, 06Ch, 020h, 073h, 069h, 067h
    DB  06Eh, 061h, 06Ch, 073h, 002h, 00Ch, 064h, 061h, 074h, 061h, 020h, 073h, 069h, 067h, 06Eh, 061h
    DB  06Ch, 073h, 002h, 000h, 000h, 001h, 020h, 005h, 060h, 000h, 000h, 043h, 041h, 053h, 053h, 045h
    DB  'TTE TEST:' , 0Ah , 'data e'
    DB  072h, 072h, 06Fh, 072h, 002h, 00Bh, 073h, 068h, 069h, 066h, 074h, 020h, 065h, 072h, 072h, 06Fh
    DB  072h, 002h, 044h, 069h, 073h, 070h, 06Ch, 061h, 079h, 020h, 074h, 065h, 073h, 074h, 020h, 03Ah
    DB  'type <1> : to fr'
    DB  'eeze pictureRemo'
    DB  'te Centronic Int'
    DB  065h, 072h, 066h, 061h, 063h, 065h, 020h, 03Ah, 00Fh, 063h, 06Fh, 06Eh, 074h, 072h, 06Fh, 06Ch
    DB  020h, 073h, 069h, 067h, 06Eh, 061h, 06Ch, 073h, 002h, 00Ch, 064h, 061h, 074h, 061h, 020h, 073h
    DB  069h, 067h, 06Eh, 061h, 06Ch, 073h, 002h, 000h, 000h, 001h, 020h, 005h, 060h, 000h, 000h, 046h
    DB  'lexible disk :' , 0Ah , 'D'
    DB  061h, 074h, 061h, 020h, 06Ch, 06Fh, 073h, 074h, 020h, 007h, 00Ah, 043h, 052h, 043h, 020h, 065h
    DB  072h, 072h, 06Fh, 072h, 020h, 007h, 011h, 052h, 065h, 063h, 06Fh, 072h, 064h, 020h, 06Eh, 06Fh
    DB  074h, 020h, 066h, 06Fh, 075h, 06Eh, 064h, 020h, 007h, 00Bh, 053h, 065h, 065h, 06Bh, 020h, 065h
    DB  072h, 072h, 06Fh, 072h, 020h, 007h, 00Ah, 04Eh, 04Fh, 054h, 020h, 052h, 045h, 041h, 044h, 059h
    DB  020h, 007h, 000h, 001h, 000h, 046h, 007h, 001h, 022h, 003h, 000h, 04Bh, 006h, 001h, 04Ch, 005h
    DB  000h, 014h, 002h, 001h, 023h, 004h, 000h, 000h, 002h, 001h, 04Ch, 001h, 001h, 0FFh, 000h, 000h
    DB  000h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 00Dh, 00Fh, 001h
    DB  02Dh, 042h, 041h, 055h, 044h, 020h, 052h, 041h, 054h, 045h, 020h, 020h, 020h, 00Eh, 0F3h, 065h
    DB  02Dh, 053h, 054h, 04Fh, 050h, 020h, 042h, 049h, 054h, 053h, 020h, 020h, 020h, 00Eh, 0FCh, 0C9h
    DB  02Dh, 050h, 041h, 052h, 049h, 054h, 059h, 020h, 020h, 020h, 020h, 020h, 020h, 011h, 03Fh, 037h
    DB  02Eh, 042h, 049h, 054h, 053h, 02Fh, 054h, 045h, 047h, 04Eh, 020h, 020h, 020h, 019h, 000h, 069h
    DB  02Eh, 044h, 045h, 046h, 041h, 055h, 04Ch, 054h, 020h, 04Ch, 04Fh, 041h, 044h, 033h, 0FCh, 00Fh
    DB  02Eh, 049h, 053h, 042h, 058h, 05Fh, 054h, 059h, 050h, 045h, 020h, 020h, 020h, 00Dh, 0F0h, 0F1h
    DB  02Dh, 04Dh, 04Fh, 044h, 045h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 01Bh, 000h, 08Dh
    DB  02Dh, 04Dh, 02Dh, 044h, 049h, 053h, 04Bh, 020h, 020h, 020h, 020h, 020h, 020h, 014h, 000h, 007h
    DB  02Ch, 044h, 049h, 053h, 04Bh, 020h, 053h, 054h, 04Fh, 050h, 054h, 049h, 044h, 034h, 000h, 057h
    DB  02Ch, 053h, 059h, 053h, 054h, 045h, 04Dh, 020h, 044h, 049h, 053h, 04Bh, 020h, 016h, 000h, 099h
    DB  02Bh, 043h, 04Fh, 04Ch, 04Fh, 055h, 052h, 020h, 020h, 020h, 020h, 020h, 020h, 00Fh, 0FDh, 0E9h
    DB  02Bh, 052h, 054h, 053h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 007h, 000h, 067h
    DB  02Bh, 04Eh, 04Fh, 02Eh, 04Fh, 046h, 02Eh, 046h, 04Ch, 04Fh, 050h, 050h, 059h, 0FFh, 020h, 020h
    DB  020h, 020h, 020h, 020h, 020h, 020h, 020h, 000h, 043h, 04Fh, 04Eh, 046h, 049h, 047h, 020h, 020h
    DB  020h, 080h, 030h, 020h, 046h, 04Ch, 04Fh, 050h, 050h, 059h, 020h, 081h, 031h, 020h, 046h, 04Ch
    DB  04Fh, 050h, 050h, 059h, 020h, 082h, 032h, 020h, 046h, 04Ch, 04Fh, 050h, 050h, 059h, 020h, 0FFh
    DB  020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 001h, 042h, 04Ch, 055h, 045h, 020h, 020h
    DB  020h, 020h, 020h, 002h, 047h, 052h, 045h, 045h, 04Eh, 020h, 020h, 020h, 020h, 003h, 043h, 059h
    DB  041h, 04Eh, 020h, 020h, 020h, 020h, 020h, 004h, 052h, 045h, 044h, 020h, 020h, 020h, 020h, 020h
    DB  020h, 005h, 04Dh, 041h, 047h, 045h, 04Eh, 054h, 041h, 020h, 020h, 006h, 059h, 045h, 04Ch, 04Ch
    DB  04Fh, 057h, 020h, 020h, 020h, 007h, 057h, 048h, 049h, 054h, 045h, 020h, 020h, 020h, 020h, 0FFh
    DB  020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 000h, 04Fh, 046h, 046h, 020h, 020h, 020h
    DB  020h, 020h, 020h, 002h, 04Fh, 04Eh, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 0FFh, 020h, 020h
    DB  020h, 020h, 020h, 020h, 020h, 020h, 020h, 005h, 020h, 020h, 035h, 020h, 053h, 045h, 043h, 020h
    DB  020h, 00Ah, 020h, 031h, 030h, 020h, 053h, 045h, 043h, 020h, 020h, 014h, 020h, 032h, 030h, 020h
    DB  053h, 045h, 043h, 020h, 020h, 01Eh, 020h, 033h, 030h, 020h, 053h, 045h, 043h, 020h, 020h, 028h
    DB  ' 40 SEC  2 50 SE'
    DB  043h, 020h, 020h, 03Ch, 020h, 036h, 030h, 020h, 053h, 045h, 043h, 020h, 020h, 0FFh, 020h, 020h
    DB  020h, 020h, 020h, 020h, 020h, 020h, 020h, 000h, 044h, 049h, 053h, 04Bh, 020h, 041h, 020h, 020h
    DB  020h, 001h, 044h, 049h, 053h, 04Bh, 020h, 042h, 020h, 020h, 020h, 002h, 044h, 049h, 053h, 04Bh
    DB  020h, 043h, 020h, 020h, 020h, 003h, 044h, 049h, 053h, 04Bh, 020h, 044h, 020h, 020h, 020h, 004h
    DB  044h, 049h, 053h, 04Bh, 020h, 045h, 020h, 020h, 020h, 005h, 044h, 049h, 053h, 04Bh, 020h, 046h
    DB  020h, 020h, 020h, 006h, 044h, 049h, 053h, 04Bh, 020h, 047h, 020h, 020h, 020h, 007h, 044h, 049h
    DB  053h, 04Bh, 020h, 048h, 020h, 020h, 020h, 008h, 044h, 049h, 053h, 04Bh, 020h, 049h, 020h, 020h
    DB  020h, 009h, 044h, 049h, 053h, 04Bh, 020h, 04Ah, 020h, 020h, 020h, 00Ah, 044h, 049h, 053h, 04Bh
    DB  020h, 04Bh, 020h, 020h, 020h, 00Bh, 044h, 049h, 053h, 04Bh, 020h, 04Ch, 020h, 020h, 020h, 00Ch
    DB  'DISK M   ' , 0Dh , 'DISK N'
    DB  020h, 020h, 020h, 00Eh, 044h, 049h, 053h, 04Bh, 020h, 04Fh, 020h, 020h, 020h, 00Fh, 044h, 049h
    DB  053h, 04Bh, 020h, 050h, 020h, 020h, 020h, 0FFh, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h
    DB  020h, 010h, 020h, 020h, 020h, 020h, 037h, 035h, 042h, 050h, 053h, 020h, 020h, 020h, 020h, 031h
    DB  '10BPS0   150BPS@'
    DB  '   300BPSP   600'
    DB  'BPS`  1200BPSp  '
    DB  032h, 034h, 030h, 030h, 042h, 050h, 053h, 080h, 020h, 020h, 034h, 038h, 030h, 030h, 042h, 050h
    DB  053h, 090h, 020h, 020h, 039h, 036h, 030h, 030h, 042h, 050h, 053h, 0FFh, 020h, 020h, 020h, 020h
    DB  020h, 020h, 020h, 020h, 020h, 004h, 020h, 031h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 008h
    DB  020h, 031h, 020h, 031h, 02Fh, 032h, 020h, 020h, 020h, 00Ch, 020h, 032h, 020h, 020h, 020h, 020h
    DB  020h, 020h, 020h, 0FFh, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 000h, 030h, 020h
    DB  020h, 020h, 020h, 020h, 020h, 020h, 020h, 001h, 020h, 036h, 034h, 04Bh, 042h, 059h, 054h, 045h
    DB  053h, 002h, 031h, 032h, 038h, 04Bh, 042h, 059h, 054h, 045h, 053h, 003h, 031h, 039h, 032h, 04Bh
    DB  042h, 059h, 054h, 045h, 053h, 004h, 032h, 035h, 036h, 04Bh, 042h, 059h, 054h, 045h, 053h, 0FFh
    DB  020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 001h, 020h, 04Fh, 044h, 044h, 020h, 020h
    DB  020h, 020h, 020h, 003h, 020h, 045h, 056h, 045h, 04Eh, 020h, 020h, 020h, 020h, 000h, 020h, 04Eh
    DB  04Fh, 020h, 020h, 020h, 020h, 020h, 020h, 0FFh, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h
    DB  020h, 000h, 063h, 06Fh, 06Eh, 073h, 06Fh, 06Ch, 065h, 035h, 020h, 001h, 050h, 052h, 049h, 04Eh
    DB  054h, 045h, 052h, 031h, 020h, 0FFh, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 000h
    DB  04Eh, 04Fh, 020h, 049h, 053h, 042h, 058h, 020h, 020h, 001h, 049h, 053h, 042h, 058h, 020h, 033h
    DB  035h, 031h, 020h, 002h, 049h, 053h, 042h, 058h, 020h, 034h, 038h, 038h, 020h, 0FFh, 020h, 020h
    DB  020h, 020h, 020h, 020h, 020h, 020h, 020h, 000h, 020h, 035h, 020h, 020h, 020h, 020h, 020h, 020h
    DB  020h, 080h, 020h, 036h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 040h, 020h, 037h, 020h, 020h
    DB  020h, 020h, 020h, 020h, 020h, 0C0h, 020h, 038h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 0FFh
    DB  '         N NET  '
    DB  '   A DRIVE: AB D'
    DB  'RIVE: BM PROM   '
    DB  020h, 0FFh, 00Dh, 00Ah, 043h, 04Fh, 04Eh, 046h, 049h, 047h, 055h, 052h, 041h, 054h, 049h, 04Fh
    DB  'N OF SYSTEM PARA'
    DB  04Dh, 045h, 054h, 045h, 052h, 053h, 03Ah, 00Dh, 00Ah, 00Dh, 00Ah, 03Ch, 020h, 092h, 020h, 03Eh
    DB  02Ch, 03Ch, 020h, 093h, 020h, 03Eh, 03Ah, 053h, 048h, 049h, 046h, 054h, 020h, 050h, 041h, 052h
    DB  041h, 04Dh, 045h, 054h, 045h, 052h, 020h, 054h, 059h, 050h, 045h, 00Dh, 00Ah, 03Ch, 020h, 090h
    DB  020h, 03Eh, 02Ch, 03Ch, 020h, 091h, 020h, 03Eh, 03Ah, 053h, 048h, 049h, 046h, 054h, 020h, 050h
    DB  'ARAMETER VALUE' , 0Dh  , 0Ah 
    DB  '<Y>:EXIT WITH   '
    DB  ' UPDATE' , 0Dh  , 0Ah , '<N>:EXI'
    DB  'T WITHOUT UPDATE'
    DB  00Dh, 00Ah, 00Dh, 00Ah, 0FFh, 055h, 04Eh, 044h, 045h, 046h, 049h, 04Eh, 045h, 044h, 000h, 04Bh
    DB  'DEF    SYSREADIN'
    DB  'G CONFIGURATION '
    DB  'FILE = KDEF.SYS' , 0Dh 
    DB  00Ah, 042h, 00Dh, 00Fh, 053h, 00Eh, 0F3h, 050h, 00Eh, 0FCh, 046h, 014h, 000h, 04Dh, 01Bh, 000h
    DB  049h, 033h, 0FCh, 044h, 011h, 03Fh, 043h, 016h, 000h, 052h, 00Fh, 0FDh, 0FFh, 000h, 000h, 03Ch
    DB  '1> YEAR         '
    DB  '                '
    DB  '                '
    DB  020h, 020h, 020h, 020h, 020h, 00Dh, 00Ah, 000h, 031h, 001h, 000h, 03Ch, 032h, 03Eh, 020h, 04Dh
    DB  'ONTH            '
    DB  '                '
    DB  '                '
    DB  020h, 00Dh, 00Ah, 000h, 032h, 002h, 000h, 03Ch, 033h, 03Eh, 020h, 044h, 041h, 059h, 020h, 020h
    DB  '                '
    DB  '                '
    DB  020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 00Dh, 00Ah, 000h
    DB  033h, 003h, 000h, 03Ch, 034h, 03Eh, 020h, 048h, 04Fh, 055h, 052h, 020h, 020h, 020h, 020h, 020h
    DB  '                '
    DB  '                '
    DB  020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 00Dh, 00Ah, 000h, 034h, 004h, 000h, 03Ch
    DB  '5> MINUT        '
    DB  '                '
    DB  '                '
    DB  020h, 020h, 020h, 020h, 020h, 00Dh, 00Ah, 000h, 035h, 005h, 000h, 03Ch, 036h, 03Eh, 020h, 053h
    DB  'ECOND           '
    DB  '                '
    DB  '                '
    DB  020h, 00Dh, 00Ah, 000h, 036h, 00Fh, 00Fh, 03Ch, 059h, 03Eh, 020h, 055h, 050h, 044h, 041h, 054h
    DB  'E CLOCK/DATE WIT'
    DB  'H NEW PARAMETERS'
    DB  020h, 041h, 04Eh, 044h, 020h, 045h, 058h, 049h, 054h, 020h, 020h, 020h, 020h, 00Dh, 00Ah, 005h
    DB  059h, 00Fh, 00Fh, 03Ch, 04Eh, 03Eh, 020h, 045h, 058h, 049h, 054h, 020h, 057h, 049h, 054h, 048h
    DB  'OUT UPDATE      '
    DB  '                '
    DB  020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 00Dh, 00Ah, 005h, 04Eh, 0FFh, 000h, 001h
    DB  001h, 000h, 000h, 000h, 064h, 00Dh, 020h, 018h, 03Ch, 03Ch

; --- str_bootloader_banner: Banner: PICCOLINE BOOTLOADER version 2.1 (317Ah - 31B0h) ---
str_bootloader_banner:
    DB  'PICCOLINE BOOTLO'
    DB  'ADER version 2.1'
    DB  '' , 0Dh  , 0Ah , 'NON EXISTING M'
    DB  'EDIUMI'

; --- str_bootloader_errors: Fejlmeddelelser: NON EXISTING MEDIUM, INSERT DISKETTE, etc. (31B0h - 320Ch) ---
str_bootloader_errors:
    DB  'NSERT DISKETTEDI'
    DB  'SKETTE NOT FORMA'
    DB  'TTED  LOADMEDIUM'
    DB  ': SELECT LOADMED'
    DB  049h, 055h, 04Dh, 03Ah, 020h, 00Dh, 00Ah, 00Bh, 032h, 026h, 032h, 041h, 032h, 05Ch, 032h, 077h
    DB  032h, 092h, 032h, 0ADh, 032h, 0D1h, 032h, 0D1h, 032h, 0F8h, 032h, 041h

; --- str_boot_media_menu: Boot-medier (A: DRIVE A, B: DRIVE B, N: NET, M: PROM, etc.) (320Ch - 3348h) ---
str_boot_media_menu:
    DB  ': DRIVE A       '
    DB  '        ' , 0Dh  , 0Ah , 'B: DRI'
    DB  'VE B            '
    DB  '   ' , 0Dh  , 0Ah , 'C: DRIVE C '
    DB  '              ' , 0Dh  , 0Ah 
    DB  'D: DRIVE D      '
    DB  '         ' , 0Dh  , 0Ah , 'N: DO'
    DB  'WNLINE LOAD     '
    DB  '    ' , 0Dh  , 0Ah , 'M: PROM LO'
    DB  'AD             ' , 0Dh 
    DB  '' , 0Ah , 'K: CONFIGURATIO'
    DB  'N OF NET PARAMET'
    DB  'ERS' , 0Dh  , 0Ah , 'L: CONFIGUR'
    DB  'ATION OF SYSTEM '
    DB  'PARAMETERS' , 0Dh  , 0Ah , 'W: C'
    DB  'ONFIGURATION OF '
    DB  'CLOCK/DATE PARAM'
    DB  045h, 054h, 045h, 052h, 053h, 00Dh, 00Ah, 053h, 045h, 04Ch, 045h, 043h, 054h, 03Ah, 020h, 003h
    DB  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 002h, 000h, 0FFh
    DB  0FFh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 01Eh, 000h

; --- str_default_boot_os: Standard OS filnavn: 'CCPM    SYS' (3348h - 336Bh) ---
str_default_boot_os:
    DB  043h, 043h, 050h, 04Dh, 020h, 020h, 020h, 020h, 053h, 059h, 053h, 000h, 000h, 000h, 000h, 000h
    DB  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    DB  000h, 000h, 000h

; --- str_network_boot_errors: Netværks-boot fejlmeddelelser og NDOS protokol (336Bh - 35E0h) ---
str_network_boot_errors:
    DB  'error: 42    log'
    DB  'on error   ' , 0Dh  , 0Ah , 'err'
    DB  'or: 42    NDOS e'
    DB  'rror (multisecto'
    DB  'r)  ' , 0Dh  , 0Ah , 'error: 42 '
    DB  '   openfile erro'
    DB  'r  ' , 0Dh  , 0Ah , 'error: 42  '
    DB  '  readfile error'
    DB  '  ' , 0Dh  , 0Ah , 'error: 42   '
    DB  ' closefile error'
    DB  ' ' , 0Dh  , 0Ah , 'error: 41    '
    DB  'transmission err'
    DB  'or       ' , 0Dh  , 0Ah , 'error'
    DB  ': 43    node  co'
    DB  'nflict error    '
    DB  '  ' , 0Dh  , 0Ah , 'error: 44   '
    DB  ' no connection t'
    DB  'o server  ' , 0Dh  , 0Ah , 'erro'
    DB  'r: 45    no NDOS'
    DB  '-answer from ser'
    DB  'ver ' , 0Dh  , 0Ah , 'error: 42 '
    DB  '   NDOS error (b'
    DB  'ufsize)' , 0Dh  , 0Ah , 'error: '
    DB  '46    Ethernet c'
    DB  'ontroller initia'
    DB  'lization error' , 0Dh  , 0Ah 
    DB  0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 000h, 000h, 047h, 0AAh, 017h, 061h, 060h, 047h, 0AAh
    DB  017h, 061h, 010h, 0A1h, 005h, 000h, 000h, 000h, 000h, 041h, 002h, 000h, 000h, 000h, 000h, 000h
    DB  002h, 002h, 050h, 041h, 053h, 053h, 057h, 04Fh, 052h, 044h, 002h, 043h, 043h, 050h, 04Dh, 020h
    DB  020h, 020h, 020h, 000h, 000h, 0FFh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    DB  01Dh, 0FFh, 03Ch, 031h, 03Eh, 020h, 04Ch, 06Fh, 063h, 061h, 06Ch, 020h, 06Eh, 06Fh, 064h, 065h
    DB  ' id.            '
    DB  '                '
    DB  020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 00Dh, 00Ah, 000h, 031h, 01Eh, 0FFh, 03Ch, 032h
    DB  '> Server node id'
    DB  '.               '
    DB  '                '
    DB  020h, 020h, 020h, 020h, 00Dh, 00Ah, 000h, 032h, 01Fh, 001h, 03Ch, 033h, 03Eh, 020h, 041h, 075h
    DB  'tomatic Net-logo'
    DB  'n con'

; --- str_net_params_config: Konfigurationsmenu for netværk og maskin-ID (35E0h - 383Ch) ---
str_net_params_config:
    DB  'sole 0, (Y/N) ? '
    DB  020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 00Dh, 00Ah, 001h, 033h, 01Fh
    DB  002h, 03Ch, 034h, 03Eh, 020h, 041h, 075h, 074h, 06Fh, 06Dh, 061h, 074h, 069h, 063h, 020h, 04Eh
    DB  'et-logon console'
    DB  ' 1, (Y/N) ?     '
    DB  020h, 020h, 020h, 020h, 020h, 020h, 020h, 00Dh, 00Ah, 001h, 034h, 01Fh, 004h, 03Ch, 035h, 03Eh
    DB  ' Automatic Net-l'
    DB  'ogon console 2, '
    DB  '(Y/N) ?         '
    DB  020h, 020h, 020h, 00Dh, 00Ah, 001h, 035h, 01Fh, 008h, 03Ch, 036h, 03Eh, 020h, 041h, 075h, 074h
    DB  'omatic Net-logon'
    DB  ' console 3, (Y/N'
    DB  ') ?            ' , 0Dh 
    DB  00Ah, 001h, 036h, 00Bh, 0FFh, 03Ch, 037h, 03Eh, 020h, 053h, 079h, 073h, 074h, 065h, 06Dh, 020h
    DB  'file name <exten'
    DB  't .SYS>         '
    DB  020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 00Dh, 00Ah, 002h, 037h, 001h
    DB  0FFh, 03Ch, 038h, 03Eh, 020h, 04Dh, 061h, 063h, 068h, 069h, 06Eh, 065h, 020h, 069h, 064h, 065h
    DB  'ntification     '
    DB  '                '
    DB  020h, 020h, 04Bh, 042h, 04Eh, 03Ah, 020h, 00Dh, 00Ah, 003h, 038h, 005h, 0FFh, 03Ch, 039h, 03Eh
    DB  ' Serial Number  '
    DB  '                '
    DB  '                '
    DB  020h, 020h, 020h, 00Dh, 00Ah, 004h, 039h, 00Fh, 00Fh, 03Ch, 059h, 03Eh, 020h, 075h, 070h, 064h
    DB  'ate nvm with new'
    DB  ' parameters, and'
    DB  ' exit          ' , 0Dh 
    DB  00Ah, 005h, 059h, 00Fh, 00Fh, 03Ch, 04Eh, 03Eh, 020h, 065h, 078h, 069h, 074h, 020h, 077h, 069h
    DB  'thout update    '
    DB  '                '
    DB  020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 00Dh, 00Ah, 005h, 04Eh, 0FFh
    DB  'Configuration of'
    DB  ' Net Parameters:'
    DB  '' , 0Dh  , 0Ah , 'Y' , 0Dh  , 0Ah , 'N' , 0Dh  , 0Ah , ' CCPM' , 0Dh  , 0Ah , 'S'
    DB  'elect:  ' , 0Dh  , 0Ah , 'Type n'
    DB  'ew value or pres'
    DB  's <RETURN>' , 0Dh  , 0Ah 

; ----------------------------------------------------------------------------
; Datasektionens afslutning og paragraf-justering (ROM 383Ch - 383Fh, 4 bytes padding)
; Sørger for at CODE_SEGMENT_BASE / rom_code_start flugter med en 16-byte paragrafgrænse
; ----------------------------------------------------------------------------
data_section_end:
    ALIGN   16, DB 0FFh                          ; 4 bytes padding (0383Ch - 0383Fh) til 16-byte paragrafgrænse

; ============================================================================
; SECTION 3: PRIMARY CODE SEGMENT (ROM offset 3840h - 7F87h)
; Segment FB84h (CS:0000h = Physical 0xFB840 = ROM offset 3840h)
; Indeholder koldstarts-initialisering, POST, RAM-test, skærmopsætning og bootloader
; ============================================================================

; ============================================================================
; RAM SCRATCHPAD & HARDWARE VARIABLES (Segment 0000h)
; ============================================================================
SEGMENT RAM_0000 AT 0000h

ORG 0001h
var_dma0_status:             DB   0                           ; [0001h] DMA Channel 0 statusflag
ORG 0003h
var_dma0_channel_id:         DB   0                           ; [0003h] DMA aktiv kanal-ID
var_dma0_byte_count:         DW   0                           ; [0004h] DMA overførsels-akkumulator
var_dma0_mode_flags:         DB   0                           ; [0006h] DMA mode kontrolflag
var_dma0_reg_dest_hi:        DW   0                           ; [0007h] Cached I/O port: FFC6h (DMA 0 Dest Hi)
var_dma0_reg_dest_lo:        DW   0                           ; [0009h] Cached I/O port: FFC4h (DMA 0 Dest Lo)
var_dma0_reg_src_hi:         DW   0                           ; [000Bh] Cached I/O port: FFC2h (DMA 0 Src Hi)
var_dma0_reg_src_lo:         DW   0                           ; [000Dh] Cached I/O port: FFC0h (DMA 0 Src Lo)
var_dma0_reg_count:          DW   0                           ; [000Fh] Cached I/O port: FFC8h (DMA 0 Transfer Count)
var_dma0_reg_control:        DW   0                           ; [0011h] Cached I/O port: FFCAh (DMA 0 Control Word)
ORG 0014h
var_boot_status:             DB   0                           ; [0014h] Resultat af sektor 1 indlæsning (FFh = gyldig bootsektor)
var_boot_drive_table:        TIMES 4 DB 0               ; [0015h] Drev-tabel og status for floppy drev A, B, C, D (4 bytes, 0015h-0018h)
var_boot_device_char:        DB   0                           ; [0019h] Aktivt boot-medie tegn ('A'=Floppy, 'N'=Net, 'M'=PROM)
var_boot_entry_addr:         DD   0                           ; [001Ah] 32-bit far pointer til startadresse for indlæst bootsektor
ORG 005Dh
var_boot_retry_counter:      DB   0                           ; [005Dh] Antal gensøgningsforsøg ved diskfejl
var_boot_step_rate:          DB   0                           ; [005Eh] FDC stepping rate parameter
var_boot_head_settle:        DB   0                           ; [005Fh] FDC head settle time parameter
var_floppy_motor_off_delay:  DW   0                           ; [0060h] FDC motor-off forsinkelsestæller
var_floppy_motor_timer:      DB   0                           ; [0062h] Diskette motor off timeout
var_floppy_target_drive:     DB   0                           ; [0063h] Valgt diskettedrev buffer (0=A, 1=B, 2=C, 3=D)
var_floppy_current_drive:    DB   0                           ; [0064h] Nuværende aktive diskettedrev
var_nvram_valid_magic:       DB   0                           ; [0065h] NVRAM valideringsbyte (skal matche AAh)
var_nvram_checksum:          DB   0                           ; [0066h] NVRAM beregnet kontrolsum
var_boot_drive_preselect:    DB   0                           ; [0067h] Forvalgt bootdrev fra tastatur under countdown ('A', 'B', ...)
var_floppy_boot_unit:        DB   0                           ; [0068h] Diskette bootdrev enhedsnummer
var_floppy_boot_flag:        DB   0                           ; [0069h] Diskette boot aktiv flag (sat til 1 ved boot)
var_floppy_drive_type:       DB   0                           ; [006Ah] Diskettedrev type (3.5 / 5.25 tommer)
var_floppy_sector_num:       DW   0                           ; [006Bh] Sektornummer til diskette-læsning
var_floppy_buffer_ptr:       DW   0                           ; [006Dh] RAM-bufferadresse til indlæst diskettesektor
var_floppy_head_num:         DW   0                           ; [006Fh] Aktivt diskettehoved (0 eller 1)
var_floppy_media_density:    DW   0                           ; [0071h] Diskette mediadensitet (FM / MFM)
var_floppy_track_num:        DW   0                           ; [0073h] Spurnummer til diskette-læsning
var_floppy_last_seek:        DW   0                           ; [0075h] Sidste søgte spor / kalibrering
var_floppy_step_delay:       DW   0                           ; [0077h] FDC stepping forsinkelse ord
var_floppy_bytes_per_sec:    DB   0                           ; [0079h] Bytes pr. sektor kode
var_floppy_sectors_per_trk:  DW   0                           ; [007Ah] Sektorer pr. spor
var_floppy_gap_length:       DW   0                           ; [007Ch] FDC gap length parameter
var_floppy_data_length:      DW   0                           ; [007Eh] FDC data length parameter
var_nvram_boot_default:      DW   0                           ; [0080h] Standard boot-enhed læst fra NVRAM
ORG 00C7h
var_screen_tab_stop:         DW   0                           ; [00C7h] Tabulatorstop interval
var_screen_bell_duration:    DB   0                           ; [00C9h] Bip-varighed for skærm-klokke
var_screen_bell_pitch:       DB   0                           ; [00CAh] Tonehøjde for skærm-klokke
var_screen_esc_state:        DB   0                           ; [00CBh] ANSI / VT escape-sekvens dekodningstilstand
var_screen_esc_param1:       DB   0                           ; [00CCh] ANSI escape parameter 1
var_screen_esc_param2:       DB   0                           ; [00CDh] ANSI escape parameter 2
var_screen_char_temp:        DB   0                           ; [00CEh] Midlertidigt skærmtegn
var_screen_attrib_temp:      DB   0                           ; [00CFh] Midlertidig skærm-attribut
var_screen_insert_mode:      DB   0                           ; [00D0h] Indsætningstilstand (insert mode) flag
var_screen_keyclick_en:      DB   0                           ; [00D1h] Tastatur-klik lyd aktiveringsflag
var_screen_cursor_type:      DW   0                           ; [00D2h] Markørtype (blok / understregning / skjult)
var_screen_page_offset:      DW   0                           ; [00D4h] Side-offset i skærmhukommelse
var_screen_line_wrap:        DB   0                           ; [00D6h] Automatisk linjeskift flag
var_screen_reverse_video:    DB   0                           ; [00D7h] Inverteret video (reverse) flag
var_screen_charset_mode:     DB   0                           ; [00D8h] Tegnsæt-tilstand (G0/G1/grafik)
var_screen_field_attr:       DB   0                           ; [00D9h] Aktivt feltattribut
var_screen_underl_attr:      DB   0                           ; [00DAh] Understregnings-attribut
var_screen_font_select:      DB   0                           ; [00DBh] Aktivt skærmtegnsæt (50Hz / 60Hz)
var_screen_dim_attr:         DB   0                           ; [00DCh] Dæmpet/halv lysstyrke attribut
var_screen_color_mode:       DB   0                           ; [00DDh] Farve / monokrom tilstand
var_screen_active_page:      DB   0                           ; [00DEh] Aktiv skærmside nummer
var_screen_display_flags:    DB   0                           ; [00DFh] Skærm-status og opdateringsflag
var_screen_cursor_col:       DW   0                           ; [00E0h] Aktiv tekstmarkør kolonneposition (0 - 79)
var_screen_cursor_row:       DW   0                           ; [00E2h] Aktiv tekstmarkør rækkeposition (0 - 24)
var_screen_buffer_base:      DW   0                           ; [00E4h] Skærmbuffer basesegment i RAM (3000h)
var_screen_attribute:        DW   0                           ; [00E6h] Aktiv skærm-attribut (farve, fremhævning, inverteret)
var_screen_window_top:       DW   0                           ; [00E8h] Skærmvindue top-linje
var_screen_window_bottom:    DW   0                           ; [00EAh] Skærmvindue bund-linje
var_screen_window_left:      DW   0                           ; [00ECh] Skærmvindue venstre kolonne
var_screen_window_right:     DW   0                           ; [00EEh] Skærmvindue højre kolonne
var_screen_scroll_count:     DW   0                           ; [00F0h] Antal linjer der skal scrolles
var_screen_scroll_direction: DW   0                           ; [00F2h] Scroll-retning (0=op, 1=ned)
var_screen_fill_char:        DW   0                           ; [00F4h] Udfyldningstegn ved scroll / ryd
var_screen_fill_attr:        DW   0                           ; [00F6h] Udfyldningsattribut
var_screen_status_buffer:    TIMES 6 DB 0               ; [00F8h] Skærm-status descriptor buffer (6 bytes, 00F8h-00FDh)
var_82730_row_table_ptr:     DW   0                           ; [00FEh] Pointer til aktiv rækketabel i 82730 displaybuffer
var_82730_row_attrib:        DW   0                           ; [0100h] 82730 rækkeattribut ord
var_82730_ctrl_flags:        DW   0                           ; [0102h] 82730 interne kontrolflag
var_82730_sync_status:       DW   0                           ; [0104h] 82730 synkroniseringsstatus
var_82730_frame_count:       DW   0                           ; [0106h] 82730 billedtæller / VSYNC frames
var_lan_packet_header:       TIMES 24 DB 0               ; [0108h] Netværks/konsol pakkestyreblok (24 bytes, 0108h-011Fh)
var_selftest_error_flags:    DB   0                           ; [0120h] Diagnostisk fejlstatus (00h = alt OK, 01h = fejl)
var_selftest_error_subcode:  DB   0                           ; [0121h] Detaljeret fejlkode / fejlet register for hardwaretest
var_selftest_failing_reg:    DB   0                           ; [0122h] Fejlet register-ID under selftest
var_selftest_error_count:    DW   0                           ; [0123h] Akkumuleret antal hardwarefejl under selftest
var_selftest_failing_dev:    DB   0                           ; [0125h] ID på fejlet hardware-enhed (FDC, LAN, Timer, DMA, etc.)
var_selftest_dev_subindex:   DB   0                           ; [0126h] Underindeks på fejlet hardwareenhed
var_selftest_loop_count:     DW   0                           ; [0127h] Løkke-tæller ved gentagne diagnostiske tests
var_selftest_pattern:        DW   0                           ; [0129h] Diagnostisk testmønster ord
var_selftest_dma_timer:      DW   0                           ; [012Bh] Diagnostisk DMA/timer timeout tæller
var_boot_status_flags:       DW   0                           ; [012Dh] Boot-status & warm-boot flag word (bit 9=spring RAM-test over, bit 11=fortsæt)
var_kbd_ctrl_alt_state:      DB   0                           ; [012Fh] Tastatur modifier status (Ctrl + Alt detektering)
var_kbd_shift_state:         DB   0                           ; [0130h] Tastatur Shift-tast tracking
var_kbd_caps_lock_state:     DB   0                           ; [0131h] Tastatur Caps Lock tilstand
var_kbd_key_ready:           DB   0                           ; [0132h] Tastatur event-flag (FFh = tastetryk klar i buffer)
var_kbd_ascii_char:          DB   0                           ; [0133h] Modtaget ASCII tegn fra tastaturet
var_kbd_raw_scancode:        DB   0                           ; [0134h] Rå scancode fra tastatur-controller
var_timer0_tick_count:       DW   0                           ; [0135h] Timer 0 interrupt tæller (opdateres hvert 10 ms af timer ISR)
var_console_cursor_pos:      DW   0                           ; [0137h] Aktiv konsol markørposition (AL=kolonne, AH=række)
var_boot_countdown_sec:      DB   0                           ; [0139h] Nedtællingssekunder for bootprompt (10 sekunder nedtælling)
ORG 4B00h
var_lan_rx_base_buf:         TIMES 24 DB 0               ; [4B00h] LAN modtagebuffer startområde (24 bytes, 4B00h-4B17h)
var_lan_desc_ptr:            DW   0                           ; [4B18h] LAN buffer descriptor pointer
var_lan_desc_len:            DW   0                           ; [4B1Ah] LAN buffer descriptor længde
var_lan_desc_flags:          DW   0                           ; [4B1Ch] LAN buffer descriptor kontrolflag
var_lan_station_id:          DW   0                           ; [4B1Eh] Ethernet/LAN lokal maskin-adresse (82586 station ID)
var_lan_server_id:           DB   0                           ; [4B20h] Ethernet/LAN boot-server adresse
var_lan_client_ip_lo:        DW   0                           ; [4B21h] Klient netværksadresse lav
var_lan_client_ip_hi:        DW   0                           ; [4B23h] Klient netværksadresse høj
var_lan_subnet_mask:         DW   0                           ; [4B25h] Netværks subnet maske
var_lan_gateway_id:          DW   0                           ; [4B27h] Netværks gateway station
var_lan_retry_limit:         DW   0                           ; [4B29h] Maksimalt antal genudsendelser
var_lan_packet_len:          DW   0                           ; [4B2Bh] Modtaget netværkspakke længde
var_lan_rx_status:           DW   0                           ; [4B2Dh] Netværks modtage-status flag
var_lan_response_buf:        TIMES 5 DB 0               ; [4B2Fh] Netværks svarmodtagelse buffer (5 bytes, 4B2Fh-4B33h)
var_lan_tx_timeout:          DB   0                           ; [4B34h] Sende-timeout tæller
var_lan_protocol_type:       DB   0                           ; [4B35h] Protokoltype (NDOS / CCP/M Net)
var_lan_buffer_offset:       DB   0                           ; [4B36h] Netværks DMA buffer-adresse
var_lan_command_code:        DB   0                           ; [4B37h] Netværks kommando / NDOS protokolkode
var_lan_sub_command:         DB   0                           ; [4B38h] Netværks underkommando
var_lan_param_buf:           TIMES 8 DB 0               ; [4B39h] Netværks parameter buffer (8 bytes, 4B39h-4B40h)
var_lan_window_size:         DB   0                           ; [4B41h] Pakkestrøm vinduesstørrelse
var_lan_ack_expected:        DB   0                           ; [4B42h] Forventet kvitteringsnummer
var_lan_last_ack:            DB   0                           ; [4B43h] Sidst modtagne kvittering
var_lan_sequence_num:        DB   0                           ; [4B44h] Netværkspakke sekvensnummer
var_lan_tx_packets:          DB   0                           ; [4B45h] Sendte pakker tæller
var_lan_rx_packets:          DB   0                           ; [4B46h] Modtagne pakker tæller
var_lan_nak_count:           DB   0                           ; [4B47h] Modtagne NAK tæller
var_lan_crc_error_count:     DB   0                           ; [4B48h] Modtagne CRC fejl tæller
var_lan_collision_count:     DB   0                           ; [4B49h] Ethernet kollisionstæller
var_lan_mac_address:         TIMES 6 DB 0               ; [4B4Ah] Ethernet hardware MAC-adresse (6 bytes, 4B4Ah-4B4Fh)
var_lan_multicast_flag:      DB   0                           ; [4B50h] Multicast modtageflag
var_lan_tx_packet_buf:       TIMES 36 DB 0               ; [4B51h] Netværks sendepakkebuffer (36 bytes, 4B51h-4B74h)
var_lan_scb_status:          DW   0                           ; [4B75h] 82586 System Control Block status
var_lan_scb_command:         DB   0                           ; [4B77h] 82586 SCB kommandoord
var_lan_timeout_counter:     DB   0                           ; [4B78h] Timeout tæller for netværkssvar
var_lan_boot_entry:          DW   0                           ; [4B79h] 32-bit entry point for netværks-bootet OS
var_lan_dma_channel:         DW   0                           ; [4B7Bh] DMA kanal til 82586
var_lan_irq_vector:          DW   0                           ; [4B7Dh] Afbrudsvektor for LAN interrupt
var_lan_tx_buffer_ptr:       DW   0                           ; [4B7Fh] Sendebuffer pointer
var_lan_rx_buffer_ptr:       DW   0                           ; [4B81h] Modtagebuffer pointer
var_lan_alt_mac_addr:        TIMES 6 DB 0               ; [4B83h] Alternativ Ethernet MAC-adresse (6 bytes, 4B83h-4B88h)
var_lan_conn_state_block:    TIMES 8 DB 0               ; [4B89h] Netværks forbindelsesblok (8 bytes, 4B89h-4B90h)
var_lan_frame_error_count:   DB   0                           ; [4B91h] Modtagne fejlrammer (CRC / Alignment)
var_lan_activity_flag:       DB   0                           ; [4B92h] Netværksaktivitets-indikator
var_lan_link_status:         DB   0                           ; [4B93h] Fysisk kabel / link status
var_lan_last_error:          DB   0                           ; [4B94h] Sidste rapporterede netværksfejlkode
var_lan_connection_state:    DB   0                           ; [4B95h] Forbindelsestilstand
var_lan_remote_port:         DB   0                           ; [4B96h] Fjernport nummer
var_lan_remote_node_params:  TIMES 6 DB 0               ; [4B97h] Fjernstations parametre (6 bytes, 4B97h-4B9Ch)
var_lan_local_port:          DB   0                           ; [4B9Dh] Lokal port nummer
var_lan_tx_retry_count:      DB   0                           ; [4B9Eh] Sendeforsøg tæller
var_lan_rx_ready_flag:       DB   0                           ; [4B9Fh] Pakke modtaget og klar til behandling
var_lan_rx_retries:          DW   0                           ; [4BA0h] Gensendelsesforsøg
var_lan_transfer_len:        DW   0                           ; [4BA2h] Netværks overførselslængde
var_lan_boot_file_desc:      TIMES 12 DB 0               ; [4BA4h] Bootfil descriptor blok (12 bytes, 4BA4h-4BAFh)
var_lan_block_index:         DB   0                           ; [4BB0h] Nuværende blokindeks i bootfil
var_lan_file_eof_flag:       DW   0                           ; [4BB1h] Slut på bootfil (EOF) flag
var_lan_data_byte_count:     DW   0                           ; [4BB3h] Antal databytes i modtaget blok
var_lan_buf_pointer:         DW   0                           ; [4BB5h] Aktiv bufferpointer i modtaget datablok
var_lan_payload_buffer:      TIMES 128 DB 0               ; [4BB7h] Bootfil data payload buffer (128 bytes, 4BB7h-4C36h)
ORG 6400h
var_fdc_text_work_buffer:    TIMES 10 DB 0               ; [6400h] Tekst/diagnostik arbejdsbuffer (10 bytes, 6400h-6409h)
var_fdc_cmd_desc_block:      TIMES 16 DB 0               ; [640Ah] Diskette kommandoblok (16 bytes, 640Ah-6419h)
var_fdc_result_phase_buf:    TIMES 30 DB 0               ; [641Ah] FDC resultatfase buffer (30 bytes, 641Ah-6437h)
var_fdc_geometry_params:     TIMES 20 DB 0               ; [6438h] Diskette geometriparametre (20 bytes, 6438h-644Bh)
var_fdc_calibration_block:   TIMES 42 DB 0               ; [644Ch] Drev kalibrerings- og statusblok (42 bytes, 644Ch-6475h)
var_fdc_status_word:         DW   0                           ; [6476h] Diskette-controller statusord
var_fdc_busy_state:          DB   0                           ; [6478h] Diskette-operation tilstand (FFh=i gang, 01h=færdig, 00h=fejl)
var_fdc_error_phase:         DB   0                           ; [6479h] Fejlfase under disketteoperation
var_fdc_timeout_accum:       DW   0                           ; [647Ah] FDC timeout akkumulator ord
var_fdc_seek_target_trk:     DW   0                           ; [647Ch] FDC søgemål cylinder/spor ord
var_fdc_head_settle_cnt:     DW   0                           ; [647Eh] FDC head settle tæller ord
var_fdc_motor_state:         DW   0                           ; [6480h] Diskettedrev motor-tilstand ord
var_fdc_step_rate_cached:    DW   0                           ; [6482h] Cached stepping rate ord
var_fdc_head_load_time:      DW   0                           ; [6484h] FDC head load tid ord
var_fdc_dma_buffer_seg:      DW   0                           ; [6486h] Diskette DMA buffer segment i RAM
var_fdc_transfer_len:        DW   0                           ; [6488h] Antal bytes overført via DMA til/fra diskette
var_fdc_cylinder_num:        DB   0                           ; [648Ah] Aktiv diskette cylinder/spor
var_fdc_head_sector:         DB   0                           ; [648Bh] Aktivt diskette hoved og sektornummer
var_fdc_drive_unit:          DB   0                           ; [648Ch] Aktivt diskettedrev (0=A:, 1=B:, 2=C:, 3=D:)
var_fdc_retry_count:         DB   0                           ; [648Dh] Akkumuleret diskette genprøvningstæller
var_fdc_last_error_code:     DB   0                           ; [648Eh] Sidste rapporterede diskette controller fejlkode

; ============================================================================
; I/O PORT EQUATES & HARDWARE REGISTERS
; ============================================================================
io_pic_icw1                EQU  0000h    ; 8259A PIC ICW1 (Base port 00h)
io_pic_icw2_ocw            EQU  0002h    ; 8259A PIC ICW2/OCW (Base vector 20h)
io_kbd_data                EQU  0020h    ; Keyboard Data / Status register
io_sn76494_sound           EQU  0056h    ; SN76494 Sound Generator (Volume / Frequency)
io_rtc_data                EQU  005Ah    ; MM58167 RTC Data register
io_rtc_addr                EQU  005Ch    ; MM58167 RTC Address / Control register
io_i82730_ca               EQU  0060h    ; 82730 Channel Attention (CA) trigger
io_ppi_porta               EQU  0070h    ; 8255 PPI Port A (Memory size, Cassette, iSBX)
io_ppi_portb               EQU  0072h    ; 8255 PPI Port B (Monitor type 50/60Hz, RTC type)
io_ppi_portc               EQU  0074h    ; 8255 PPI Port C (Kbd enable, Gfx mode, NVRAM bank)
io_ppi_ctrl                EQU  0076h    ; 8255 PPI Control word (Mode setup)
io_nvram_base              EQU  0080h    ; NVRAM start (128 bytes bank-switched, 80h-FFh)
io_palette_base            EQU  0180h    ; Palette RAM base (180h - 19Fh)
io_i82730_reset            EQU  0230h    ; Intel 82730 CRT Text Coprocessor Reset (IRST)
io_i82730_ca_pulse         EQU  0240h    ; Intel 82730 Channel Attention (CA pulse)
io_centronics_data         EQU  0250h    ; Centronics Printer Data register
io_centronics_ctrl         EQU  0260h    ; Centronics Printer Control register
io_wd2797_status_cmd       EQU  0280h    ; WD2797 FDC Status / Command register
io_wd2797_track            EQU  0282h    ; WD2797 FDC Track register
io_wd2797_sector           EQU  0284h    ; WD2797 FDC Sector register
io_wd2797_data             EQU  0286h    ; WD2797 FDC Data register
io_floppy_ctrl             EQU  0288h    ; Floppy Control register (Motor 0/1, Drive sel, DDEN)
io_floppy_ext              EQU  028Ch    ; Floppy Extended register
io_floppy_reserve_ack      EQU  028Eh    ; Floppy Reserve / Acknowledge register
io_floppy_release          EQU  0290h    ; Floppy Release register
io_floppy_status_aux       EQU  0292h    ; Floppy Auxiliary Status register
io_floppy_param            EQU  0294h    ; Floppy Parameter register
io_isbx0_data              EQU  0300h    ; iSBX Multimodule Slot 0 Data (8274 / 8251 serial)
io_isbx0_ctrl              EQU  0302h    ; iSBX Multimodule Slot 0 Control / Status
io_isbx1_data              EQU  0314h    ; iSBX Multimodule Slot 1 Data
io_isbx1_ctrl              EQU  0316h    ; iSBX Multimodule Slot 1 Control / Status
io_i186_eoi                EQU  0FF22h    ; 80186 INTC End-Of-Interrupt (EOI) register
io_i186_int_mask           EQU  0FF28h    ; 80186 INTC Interrupt Mask register
io_i186_timer_int_ctrl     EQU  0FF30h    ; 80186 INTC Timer Interrupt Control register
io_i186_dma0_int_ctrl      EQU  0FF32h    ; 80186 INTC DMA 0 Interrupt Control register
io_i186_dma1_int_ctrl      EQU  0FF34h    ; 80186 INTC DMA 1 Interrupt Control register
io_i186_int1_ctrl          EQU  0FF38h    ; 80186 INTC INT 1 Control register
io_i186_int2_ctrl          EQU  0FF3Ah    ; 80186 INTC INT 2 Control register
io_i186_int_poll           EQU  0FF3Eh    ; 80186 INTC Interrupt Poll register
io_i186_timer0_count       EQU  0FF50h    ; 80186 Timer 0 Count register (T0CNT)
io_i186_timer0_max_a       EQU  0FF52h    ; 80186 Timer 0 Max Count A register (T0CMPA)
io_i186_timer0_max_b       EQU  0FF54h    ; 80186 Timer 0 Max Count B register (T0CMPB)
io_i186_timer0_ctrl        EQU  0FF56h    ; 80186 Timer 0 Mode / Control register (T0CON)
io_i186_timer1_count       EQU  0FF58h    ; 80186 Timer 1 Count register (T1CNT)
io_i186_timer1_max_a       EQU  0FF5Ah    ; 80186 Timer 1 Max Count A register (T1CMPA)
io_i186_timer1_max_b       EQU  0FF5Ch    ; 80186 Timer 1 Max Count B register (T1CMPB)
io_i186_timer1_ctrl        EQU  0FF5Eh    ; 80186 Timer 1 Mode / Control register (T1CON)
io_i186_timer2_count       EQU  0FF60h    ; 80186 Timer 2 Count register (T2CNT)
io_i186_timer2_max_a       EQU  0FF62h    ; 80186 Timer 2 Max Count A register (T2CMPA)
io_i186_timer2_ctrl        EQU  0FF66h    ; 80186 Timer 2 Mode / Control register (T2CON)
io_i186_umcs               EQU  0FFA0h    ; 80186 UMCS (Upper Memory Chip Select: Boot ROM 32KB)
io_i186_pacs               EQU  0FFA2h    ; 80186 PACS (Peripheral Chip Select: Base 0000h)
io_i186_lmcs               EQU  0FFA4h    ; 80186 LMCS (Lower Memory Chip Select: Base RAM)
io_i186_mpcs               EQU  0FFA6h    ; 80186 MPCS (Mid-Range Memory / Peripheral Chip Select)
io_i186_mmcs               EQU  0FFA8h    ; 80186 MMCS (Mid-Range Memory Chip Select: CRT-RAM D0000h)
io_i186_dma0_src_lo        EQU  0FFC0h    ; 80186 DMA 0 Lower Source Address
io_i186_dma0_src_hi        EQU  0FFC2h    ; 80186 DMA 0 Upper Source Address
io_i186_dma0_dst_lo        EQU  0FFC4h    ; 80186 DMA 0 Lower Destination Address
io_i186_dma0_dst_hi        EQU  0FFC6h    ; 80186 DMA 0 Upper Destination Address
io_i186_dma0_count         EQU  0FFC8h    ; 80186 DMA 0 Transfer Count
io_i186_dma0_ctrl          EQU  0FFCAh    ; 80186 DMA 0 Control register
io_i186_dma1_src_lo        EQU  0FFD0h    ; 80186 DMA 1 Lower Source Address
io_i186_dma1_src_hi        EQU  0FFD2h    ; 80186 DMA 1 Upper Source Address
io_i186_dma1_dst_lo        EQU  0FFD4h    ; 80186 DMA 1 Lower Destination Address
io_i186_dma1_dst_hi        EQU  0FFD6h    ; 80186 DMA 1 Upper Destination Address
io_i186_dma1_count         EQU  0FFD8h    ; 80186 DMA 1 Transfer Count
io_i186_dma1_ctrl          EQU  0FFDAh    ; 80186 DMA 1 Control register
io_i186_pcb_reloc          EQU  0FFFEh    ; 80186 PCB Relocation Register

SEGMENT CODE_FB84 AT CODE_SEGMENT_BASE
ORG 0000h

rom_segment_base:
    DW  ROM_DATA_SEGMENT       ; [CS:0000] = Base segment for ROM data (F800h)
ram_segment_base:
    DW  0000h                  ; [CS:0002] = Base segment for RAM (0000h)


; ----------------------------------------------------------------------------
; cold_boot_entry (ROM: 3844h, FB84:0004h)
; ----------------------------------------------------------------------------
cold_boot_entry:
    MOV     DX, io_ppi_ctrl              ; 8255 PPI Control word (Mode setup) ; [0004: BA 76 00]
    MOV     AL, 92                                           ; [0007: B0 92]
    OUT     DX, AL                                           ; [0009: EE]
    MOV     DX, io_ppi_portc             ; 8255 PPI Port C (Kbd enable, Gfx mode, NVRAM bank) ; [000A: BA 74 00]
    MOV     AL, 08                                           ; [000D: B0 08]
    OUT     DX, AL                                           ; [000F: EE]
    MOV     DX, io_ppi_ctrl              ; 8255 PPI Control word (Mode setup) ; [0010: BA 76 00]
    MOV     AL, 03                                           ; [0013: B0 03]
    OUT     DX, AL                                           ; [0015: EE]
    MOV     AL, 00                                           ; [0016: B0 00]
    OUT     DX, AL                                           ; [0018: EE]
    MOV     AL, 0D                                           ; [0019: B0 0D]
    OUT     DX, AL                                           ; [001B: EE]
    MOV     AL, 0F                                           ; [001C: B0 0F]
    OUT     DX, AL                                           ; [001E: EE]
    MOV     AL, 9F                                           ; [001F: B0 9F]
    MOV     DI, 0026                                         ; [0021: BF 26 00]
    JMPS    loc_003b                                         ; [0024: EB 15]
    MOV     AL, BF                                           ; [0026: B0 BF]
    MOV     DI, 002D                                         ; [0028: BF 2D 00]
    JMPS    loc_003b                                         ; [002B: EB 0E]
    MOV     AL, DF                                           ; [002D: B0 DF]
    MOV     DI, 0034                                         ; [002F: BF 34 00]
    JMPS    loc_003b                                         ; [0032: EB 07]
    MOV     AL, FF                                           ; [0034: B0 FF]
    MOV     DI, 005F                                         ; [0036: BF 5F 00]
    JMPS    loc_003b                                         ; [0039: EB 00]
loc_003b:
    XCHG    AL, AH                                           ; [003B: 86 E0]
    IN      AL, io_sn76494_sound         ; SN76494 Sound Generator (Volume / Frequency) ; [003D: E4 56]
    MOV     CX, 001E                                         ; [003F: B9 1E 00]
loc_0042:
    LOOP    loc_0042                                         ; [0042: E2 FE]
    MOV     AL, 00                                           ; [0044: B0 00]
    OUT     io_rtc_addr, AL              ; MM58167 RTC Address / Control register ; [0046: E6 5C]
    MOV     CX, 001E                                         ; [0048: B9 1E 00]
loc_004b:
    LOOP    loc_004b                                         ; [004B: E2 FE]
    XCHG    AL, AH                                           ; [004D: 86 E0]
    OUT     io_rtc_data, AL              ; MM58167 RTC Data register ; [004F: E6 5A]
    MOV     CX, 001E                                         ; [0051: B9 1E 00]
loc_0054:
    LOOP    loc_0054                                         ; [0054: E2 FE]
    OUT     io_sn76494_sound, AL         ; SN76494 Sound Generator (Volume / Frequency) ; [0056: E6 56]
    MOV     CX, 001E                                         ; [0058: B9 1E 00]
loc_005b:
    LOOP    loc_005b                                         ; [005B: E2 FE]
    JMP     DI                                               ; [005D: FF E7]
    MOV     DX, io_i186_int1_ctrl        ; 80186 INTC INT 1 Control register ; [005F: BA 38 FF]
    MOV     AX, 003F                                         ; [0062: B8 3F 00]
    OUT     DX, AX                                           ; [0065: EF]
    MOV     DX, io_i186_int2_ctrl        ; 80186 INTC INT 2 Control register ; [0066: BA 3A FF]
    MOV     AX, 000F                                         ; [0069: B8 0F 00]
    OUT     DX, AX                                           ; [006C: EF]
    MOV     DX, io_i186_int_poll         ; 80186 INTC Interrupt Poll register ; [006D: BA 3E FF]
    OUT     DX, AX                                           ; [0070: EF]
    MOV     DX, io_i186_int_mask         ; 80186 INTC Interrupt Mask register ; [0071: BA 28 FF]
    MOV     AX, 00CD                                         ; [0074: B8 CD 00]
    OUT     DX, AX                                           ; [0077: EF]
    MOV     AL, 19                                           ; [0078: B0 19]
    MOV     DX, io_pic_icw1              ; 8259A PIC ICW1 (Base port 00h) ; [007A: BA 00 00]
    OUT     DX, AL                                           ; [007D: EE]
    MOV     AL, 20                                           ; [007E: B0 20]
    MOV     DX, io_pic_icw2_ocw          ; 8259A PIC ICW2/OCW (Base vector 20h) ; [0080: BA 02 00]
    OUT     DX, AL                                           ; [0083: EE]

; ----------------------------------------------------------------------------
; init_pic_8259 (ROM: 38C4h, FB84:0084h)
; ----------------------------------------------------------------------------
init_pic_8259:
    MOV     AL, 00                                           ; [0084: B0 00]
    OUT     DX, AL                                           ; [0086: EE]
    MOV     AL, 1D                                           ; [0087: B0 1D]
    OUT     DX, AL                                           ; [0089: EE]
    MOV     AL, ED                                           ; [008A: B0 ED]
    OUT     DX, AL                                           ; [008C: EE]
    IN      AL, io_ppi_portb             ; 8255 PPI Port B (Monitor type 50/60Hz, RTC type) ; [008D: E4 72]
    TEST    AL, 80                                           ; [008F: A8 80]
    JNZ     init_i186_timer0                                 ; [0091: 75 10]
    MOV     AL, B6                                           ; [0093: B0 B6]
    MOV     DX, io_isbx1_ctrl            ; iSBX Multimodule Slot 1 Control / Status ; [0095: BA 16 03]
    OUT     DX, AL                                           ; [0098: EE]
    MOV     DX, io_isbx1_data            ; iSBX Multimodule Slot 1 Data ; [0099: BA 14 03]
    MOV     AX, 0020                                         ; [009C: B8 20 00]
    OUT     DX, AL                                           ; [009F: EE]
    XCHG    AH, AL                                           ; [00A0: 86 C4]
    OUT     DX, AL                                           ; [00A2: EE]

; ----------------------------------------------------------------------------
; init_i186_timer0 (ROM: 38E3h, FB84:00A3h)
; ----------------------------------------------------------------------------
init_i186_timer0:
    MOV     DX, io_i186_timer1_count     ; 80186 Timer 1 Count register (T1CNT) ; [00A3: BA 58 FF]
    MOV     AX, 0000                                         ; [00A6: B8 00 00]
    OUT     DX, AX                                           ; [00A9: EF]
    ADD     DX, +02                                          ; [00AA: 83 C2 02]
    MOV     AX, 03E8                                         ; [00AD: B8 E8 03]
    OUT     DX, AX                                           ; [00B0: EF]
    ADD     DX, +02                                          ; [00B1: 83 C2 02]
    OUT     DX, AX                                           ; [00B4: EF]
    ADD     DX, +02                                          ; [00B5: 83 C2 02]
    MOV     AX, C002                                         ; [00B8: B8 02 C0]
    OUT     DX, AX                                           ; [00BB: EF]
    IN      AL, io_ppi_portb             ; 8255 PPI Port B (Monitor type 50/60Hz, RTC type) ; [00BC: E4 72]
    TEST    AL, 80                                           ; [00BE: A8 80]
    JNZ     init_palette                                     ; [00C0: 75 17]
    MOV     AX, [CS:rom_segment_base]                        ; [00C2: 2E A1 00 00]
    MOV     ES, AX                                           ; [00C6: 8E C0]
    MOV     DI, 0002                                         ; [00C8: BF 02 00]
    MOV     DX, io_isbx0_ctrl            ; iSBX Multimodule Slot 0 Control / Status ; [00CB: BA 02 03]
loc_00ce:
    MOV     AL, BYTE [ES:DI]                                 ; [00CE: 26 8A 05]
    CMP     AL, FF                                           ; [00D1: 3C FF]
    JZ      init_palette                                     ; [00D3: 74 04]
    OUT     DX, AL                                           ; [00D5: EE]
    INC     DI                                               ; [00D6: 47]
    JMPS    loc_00ce                                         ; [00D7: EB F5]

; ----------------------------------------------------------------------------
; init_palette (ROM: 3919h, FB84:00D9h)
; ----------------------------------------------------------------------------
init_palette:
    MOV     BX, 0000                                         ; [00D9: BB 00 00]
    MOV     CX, 0010                                         ; [00DC: B9 10 00]
    MOV     AL, F0                                           ; [00DF: B0 F0]
loc_00e1:
    MOV     DX, io_palette_base          ; Palette RAM base (180h - 19Fh) ; [00E1: BA 80 01]
    ADD     DX, BX                                           ; [00E4: 03 D3]
    OUT     DX, AL                                           ; [00E6: EE]
    NOT     AL                                               ; [00E7: F6 D0]
    INC     BX                                               ; [00E9: 43]
    INC     BX                                               ; [00EA: 43]
    LOOP    loc_00e1                                         ; [00EB: E2 F4]
    TEST    BP, 0200                                         ; [00ED: F7 C5 00 02]
    JNZ     loc_010a                                         ; [00F1: 75 17]
    MOV     AX, 0000                                         ; [00F3: B8 00 00]
    MOV     BX, AX                                           ; [00F6: 8B D8]
loc_00f8:
    MOV     CX, 0008                                         ; [00F8: B9 08 00]
    MOV     ES, AX                                           ; [00FB: 8E C0]
loc_00fd:
    MOV     WORD [ES:BX], AX                                 ; [00FD: 26 89 07]
    LOOP    loc_00fd                                         ; [0100: E2 FB]
    ADD     AX, 1000                                         ; [0102: 05 00 10]
    CMP     AX, 0000                                         ; [0105: 3D 00 00]
    JC      loc_00f8                                         ; [0108: 72 EE]
loc_010a:
    MOV     AX, [CS:rom_segment_base]                        ; [010A: 2E A1 00 00]
    MOV     DS, AX                                           ; [010E: 8E D8]
    MOV     BX, 2396                                         ; [0110: BB 96 23]
    MOV     CX, FFFF                                         ; [0113: B9 FF FF]
    MOV     DI, 04D1                                         ; [0116: BF D1 04]
    JMPN    serial_tx_banner_loop                            ; [0119: E9 00 00]

; ----------------------------------------------------------------------------
; serial_tx_banner_loop (ROM: 395Ch, FB84:011Ch)
; ----------------------------------------------------------------------------
serial_tx_banner_loop:
    IN      AL, io_ppi_portb             ; 8255 PPI Port B (Monitor type 50/60Hz, RTC type) ; [011C: E4 72]
    TEST    AL, 80                                           ; [011E: A8 80]
    JNZ     loc_013d                                         ; [0120: 75 1B]
    MOV     DX, io_isbx0_ctrl            ; iSBX Multimodule Slot 0 Control / Status ; [0122: BA 02 03]
loc_0125:
    IN      AL, DX                                           ; [0125: EC]
    TEST    AL, 80                                           ; [0126: A8 80]
    JZ      loc_013d                                         ; [0128: 74 13]
    AND     AL, 01                                           ; [012A: 24 01]
    CMP     AL, 01                                           ; [012C: 3C 01]
    JNZ     loc_0125                                         ; [012E: 75 F5]
    MOV     DX, io_isbx0_data            ; iSBX Multimodule Slot 0 Data (8274 / 8251 serial) ; [0130: BA 00 03]
    MOV     AL, BYTE [BX]                                    ; [0133: 8A 07]
    OUT     DX, AL                                           ; [0135: EE]
    CMP     AL, 0A                                           ; [0136: 3C 0A]
    JZ      loc_013d                                         ; [0138: 74 03]
    INC     BX                                               ; [013A: 43]
    LOOP    serial_tx_banner_loop                            ; [013B: E2 DF]
loc_013d:
    JMP     DI                                               ; [013D: FF E7]
loc_013f:
    IN      AL, io_ppi_portb             ; 8255 PPI Port B (Monitor type 50/60Hz, RTC type) ; [013F: E4 72]
    TEST    AL, 80                                           ; [0141: A8 80]
    JNZ     loc_0185                                         ; [0143: 75 40]
    MOV     AH, 02                                           ; [0145: B4 02]
loc_0147:
    MOV     BH, 03                                           ; [0147: B7 03]
    MOV     BL, CH                                           ; [0149: 8A DD]
    ROL     CH, 1                                            ; [014B: D0 C5]
    ROL     CH, 1                                            ; [014D: D0 C5]
    ROL     CH, 1                                            ; [014F: D0 C5]
    ROL     CH, 1                                            ; [0151: D0 C5]
loc_0153:
    DEC     BH                                               ; [0153: FE CF]
    JZ      loc_017f                                         ; [0155: 74 28]
    AND     CH, 0F                                           ; [0157: 80 E5 0F]
    CMP     CH, 0A                                           ; [015A: 80 FD 0A]
    JNC     loc_0164                                         ; [015D: 73 05]
    ADD     CH, 30                                           ; [015F: 80 C5 30]
    JMPS    loc_0167                                         ; [0162: EB 03]
loc_0164:
    ADD     CH, 37                                           ; [0164: 80 C5 37]
loc_0167:
    MOV     DX, io_isbx0_ctrl            ; iSBX Multimodule Slot 0 Control / Status ; [0167: BA 02 03]
    IN      AL, DX                                           ; [016A: EC]
    TEST    AL, 80                                           ; [016B: A8 80]
    JZ      loc_0185                                         ; [016D: 74 16]
    AND     AL, 01                                           ; [016F: 24 01]
    CMP     AL, 01                                           ; [0171: 3C 01]
    JNZ     loc_0167                                         ; [0173: 75 F2]
    MOV     AL, CH                                           ; [0175: 8A C5]
    MOV     DX, io_isbx0_data            ; iSBX Multimodule Slot 0 Data (8274 / 8251 serial) ; [0177: BA 00 03]
    OUT     DX, AL                                           ; [017A: EE]
    MOV     CH, BL                                           ; [017B: 8A EB]
    JMPS    loc_0153                                         ; [017D: EB D4]
loc_017f:
    MOV     CH, CL                                           ; [017F: 8A E9]
    DEC     AH                                               ; [0181: FE CC]
    JNZ     loc_0147                                         ; [0183: 75 C2]
loc_0185:
    JMP     DI                                               ; [0185: FF E7]

; ----------------------------------------------------------------------------
; char_out_helper (ROM: 39C7h, FB84:0187h)
; ----------------------------------------------------------------------------
char_out_helper:
    PUSH    AX                                               ; [0187: 50]
    PUSH    DX                                               ; [0188: 52]
    XCHG    AH, AL                                           ; [0189: 86 C4]
    IN      AL, io_ppi_portb             ; 8255 PPI Port B (Monitor type 50/60Hz, RTC type) ; [018B: E4 72]
    TEST    AL, 80                                           ; [018D: A8 80]
    JNZ     loc_01a5                                         ; [018F: 75 14]
loc_0191:
    MOV     DX, io_isbx0_ctrl            ; iSBX Multimodule Slot 0 Control / Status ; [0191: BA 02 03]
    IN      AL, DX                                           ; [0194: EC]
    TEST    AL, 80                                           ; [0195: A8 80]
    JZ      loc_01a5                                         ; [0197: 74 0C]
    AND     AL, 01                                           ; [0199: 24 01]
    CMP     AL, 01                                           ; [019B: 3C 01]
    JNZ     loc_0191                                         ; [019D: 75 F2]
    XCHG    AH, AL                                           ; [019F: 86 C4]
    MOV     DX, io_isbx0_data            ; iSBX Multimodule Slot 0 Data (8274 / 8251 serial) ; [01A1: BA 00 03]
    OUT     DX, AL                                           ; [01A4: EE]
loc_01a5:
    POP     DX                                               ; [01A5: 5A]
    POP     AX                                               ; [01A6: 58]
    RETN                                                     ; [01A7: C3]
sub_01a8:
    PUSH    DX                                               ; [01A8: 52]
    MOV     DX, io_isbx0_ctrl            ; iSBX Multimodule Slot 0 Control / Status ; [01A9: BA 02 03]
loc_01ac:
    IN      AL, DX                                           ; [01AC: EC]
    TEST    AL, 02                                           ; [01AD: A8 02]
    JZ      loc_01ac                                         ; [01AF: 74 FB]
    MOV     DX, io_isbx0_data            ; iSBX Multimodule Slot 0 Data (8274 / 8251 serial) ; [01B1: BA 00 03]
    IN      AL, DX                                           ; [01B4: EC]
    AND     AL, 7F                                           ; [01B5: 24 7F]
    CMP     AL, 61                                           ; [01B7: 3C 61]
    JC      loc_01bd                                         ; [01B9: 72 02]
    SUB     AL, 20                                           ; [01BB: 2C 20]
loc_01bd:
    POP     DX                                               ; [01BD: 5A]
    RETN                                                     ; [01BE: C3]

; ----------------------------------------------------------------------------
; clear_screen_or_cursor (ROM: 39FFh, FB84:01BFh)
; ----------------------------------------------------------------------------
clear_screen_or_cursor:
    PUSH    AX                                               ; [01BF: 50]
    PUSH    BX                                               ; [01C0: 53]
    PUSH    DX                                               ; [01C1: 52]
    PUSH    ES                                               ; [01C2: 06]
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [01C3: B8 00 30]
    MOV     ES, AX                                           ; [01C6: 8E C0]
    MOV     BX, 2000                                         ; [01C8: BB 00 20]
loc_01cb:
    MOV     AL, 01                                           ; [01CB: B0 01]
    LOCK XCHG BYTE [ES:BX], AL                               ; [01CD: F0 26 86 07]
    CMP     AL, 01                                           ; [01D1: 3C 01]
    JZ      loc_01cb                                         ; [01D3: 74 F6]
    INC     BX                                               ; [01D5: 43]
    MOV     BYTE [ES:BX], 01                                 ; [01D6: 26 C6 07 01]
    INC     BX                                               ; [01DA: 43]
    MOV     AL, 40                                           ; [01DB: B0 40]
    TEST    WORD [var_boot_status_flags], 2000 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [01DD: F7 06 2D 01 00 20]
    JZ      loc_01e7                                         ; [01E3: 74 02]
    MOV     AL, C0                                           ; [01E5: B0 C0]
loc_01e7:
    MOV     BYTE [ES:BX], AL                                 ; [01E7: 26 88 07]
    MOV     DX, io_i82730_ca_pulse       ; Intel 82730 Channel Attention (CA pulse) ; [01EA: BA 40 02]
    OUT     DX, AX                                           ; [01ED: EF]
    POP     ES                                               ; [01EE: 07]
    POP     DX                                               ; [01EF: 5A]
    POP     BX                                               ; [01F0: 5B]
    POP     AX                                               ; [01F1: 58]
    RETN                                                     ; [01F2: C3]
sub_01f3:
    PUSH    AX                                               ; [01F3: 50]
    PUSH    CX                                               ; [01F4: 51]
    PUSH    SI                                               ; [01F5: 56]
    PUSH    DI                                               ; [01F6: 57]
    PUSH    ES                                               ; [01F7: 06]
    PUSH    DS                                               ; [01F8: 1E]
    PUSH    BP                                               ; [01F9: 55]
    MOV     AX, [CS:ram_segment_base]                        ; [01FA: 2E A1 02 00]
    MOV     DS, AX                                           ; [01FE: 8E D8]
    MOV     BP, 0137                                         ; [0200: BD 37 01]
    MOV     AX, WORD [DS:BP+00]                              ; [0203: 3E 8B 46 00]
    CMP     AH, 18                                           ; [0207: 80 FC 18]
    JNC     loc_0234                                         ; [020A: 73 28]
    CMP     AH, 17                                           ; [020C: 80 FC 17]
    JC      loc_025f                                         ; [020F: 72 4E]
    DEC     AH                                               ; [0211: FE CC]
    MOV     WORD [DS:BP+00], AX                              ; [0213: 3E 89 46 00]
    MOV     SI, 3144                                         ; [0217: BE 44 31]
    MOV     DI, 30A4                                         ; [021A: BF A4 30]
    MOV     CX, 06DF                                         ; [021D: B9 DF 06]
    CLD                                                      ; [0220: FC]
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [0221: B8 00 30]
    MOV     ES, AX                                           ; [0224: 8E C0]
    MOV     DS, AX                                           ; [0226: 8E D8]
    JMPS    loc_022a                                         ; [0228: EB 00]
loc_022a:
    REP MOVSW                                                ; [022A: F3 A5]
    MOV     AL, 20                                           ; [022C: B0 20]
    MOV     BYTE [ES:BX+04], AL                              ; [022E: 26 88 47 04]
    JMPS    loc_025f                                         ; [0232: EB 2B]
loc_0234:
    CMP     AH, 2F                                           ; [0234: 80 FC 2F]
    JC      loc_025f                                         ; [0237: 72 26]
    CMP     AH, 30                                           ; [0239: 80 FC 30]
    JNC     loc_025f                                         ; [023C: 73 21]
    DEC     AH                                               ; [023E: FE CC]
    MOV     WORD [DS:BP+00], AX                              ; [0240: 3E 89 46 00]
    MOV     SI, 4144                                         ; [0244: BE 44 41]
    MOV     DI, 40A4                                         ; [0247: BF A4 40]
    MOV     CX, 06DF                                         ; [024A: B9 DF 06]
    CLD                                                      ; [024D: FC]
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [024E: B8 00 30]
    MOV     ES, AX                                           ; [0251: 8E C0]
    MOV     DS, AX                                           ; [0253: 8E D8]
    JMPS    loc_0257                                         ; [0255: EB 00]
loc_0257:
    REP MOVSW                                                ; [0257: F3 A5]
    MOV     AL, 20                                           ; [0259: B0 20]
    MOV     BYTE [ES:BX+04], AL                              ; [025B: 26 88 47 04]
loc_025f:
    POP     BP                                               ; [025F: 5D]
    POP     DS                                               ; [0260: 1F]
    POP     ES                                               ; [0261: 07]
    POP     DI                                               ; [0262: 5F]
    POP     SI                                               ; [0263: 5E]
    POP     CX                                               ; [0264: 59]
    POP     AX                                               ; [0265: 58]
    RETN                                                     ; [0266: C3]
sub_0267:
    PUSH    DS                                               ; [0267: 1E]
    PUSH    BP                                               ; [0268: 55]
    MOV     AX, [CS:ram_segment_base]                        ; [0269: 2E A1 02 00]
    MOV     DS, AX                                           ; [026D: 8E D8]
    MOV     BP, 0137                                         ; [026F: BD 37 01]
    MOV     AX, WORD [DS:BP+00]                              ; [0272: 3E 8B 46 00]
    POP     BP                                               ; [0276: 5D]
    POP     DS                                               ; [0277: 1F]
    RETN                                                     ; [0278: C3]

; ----------------------------------------------------------------------------
; set_cursor_pos (ROM: 3AB9h, FB84:0279h)
; ----------------------------------------------------------------------------
set_cursor_pos:
    PUSH    BX                                               ; [0279: 53]
    PUSH    DS                                               ; [027A: 1E]
    PUSH    BP                                               ; [027B: 55]
loc_027c:
    CMP     AL, 50                                           ; [027C: 3C 50]
    JC      loc_0286                                         ; [027E: 72 06]
    SUB     AL, 50                                           ; [0280: 2C 50]
    INC     AH                                               ; [0282: FE C4]
    JMPS    loc_027c                                         ; [0284: EB F6]
loc_0286:
    MOV     BX, WORD [CS:ram_segment_base]                   ; [0286: 2E 8B 1E 02 00]
    MOV     DS, BX                                           ; [028B: 8E DB]
    MOV     BP, 0137                                         ; [028D: BD 37 01]
    MOV     WORD [DS:BP+00], AX                              ; [0290: 3E 89 46 00]
    POP     BP                                               ; [0294: 5D]
    POP     DS                                               ; [0295: 1F]
    POP     BX                                               ; [0296: 5B]
    RETN                                                     ; [0297: C3]

; ----------------------------------------------------------------------------
; conout_char (ROM: 3AD8h, FB84:0298h)
; ----------------------------------------------------------------------------
conout_char:
    PUSH    AX                                               ; [0298: 50]
    PUSH    BX                                               ; [0299: 53]
    PUSH    DX                                               ; [029A: 52]
    PUSH    DS                                               ; [029B: 1E]
    PUSH    ES                                               ; [029C: 06]
    PUSH    BP                                               ; [029D: 55]
    MOV     BX, WORD [CS:ram_segment_base]                   ; [029E: 2E 8B 1E 02 00]
    MOV     DS, BX                                           ; [02A3: 8E DB]
    MOV     BX, LAN_BUFFER_ALT_SEGMENT                       ; [02A5: BB 00 30]
    MOV     ES, BX                                           ; [02A8: 8E C3]
    MOV     BP, 0137                                         ; [02AA: BD 37 01]
    MOV     BX, LAN_BUFFER_ALT_SEGMENT                       ; [02AD: BB 00 30]
    MOV     DX, WORD [DS:BP+00]                              ; [02B0: 3E 8B 56 00]
    CMP     DH, 30                                           ; [02B4: 80 FE 30]
    JNZ     loc_02c0                                         ; [02B7: 75 07]
    MOV     BX, 5000                                         ; [02B9: BB 00 50]
    MOV     DH, 00                                           ; [02BC: B6 00]
    JMPS    loc_02cb                                         ; [02BE: EB 0B]
loc_02c0:
    CMP     DH, 18                                           ; [02C0: 80 FE 18]
    JC      loc_02cb                                         ; [02C3: 72 06]
    MOV     BX, 4000                                         ; [02C5: BB 00 40]
    SUB     DH, 18                                           ; [02C8: 80 EE 18]
loc_02cb:
    TEST    WORD [var_boot_status_flags], 0100 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [02CB: F7 06 2D 01 00 01]
    JNZ     loc_02e5                                         ; [02D1: 75 12]
    TEST    WORD [var_boot_status_flags], 8000 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [02D3: F7 06 2D 01 00 80]
    JNZ     loc_02e2                                         ; [02D9: 75 07]
    CMP     BYTE [var_selftest_error_flags], 00 ; Selftest error flags buffer ; [02DB: 80 3E 20 01 00]
    JZ      loc_02e5                                         ; [02E0: 74 03]
loc_02e2:
    CALL    char_out_helper                                  ; [02E2: E8 A2 FE]
loc_02e5:
    CMP     AL, 0A                                           ; [02E5: 3C 0A]
    JNZ     loc_02f5                                         ; [02E7: 75 0C]
    CALL    sub_0267                                         ; [02E9: E8 7B FF]
    XOR     AL, AL                                           ; [02EC: 32 C0]
    INC     AH                                               ; [02EE: FE C4]
    CALL    set_cursor_pos                                   ; [02F0: E8 86 FF]
    JMPS    loc_033e                                         ; [02F3: EB 49]
loc_02f5:
    ADD     BL, DL                                           ; [02F5: 02 DA]
    ADD     BL, DL                                           ; [02F7: 02 DA]
loc_02f9:
    ADD     BX, 00A0                                         ; [02F9: 81 C3 A0 00]
    DEC     DH                                               ; [02FD: FE CE]
    CMP     DH, 00                                           ; [02FF: 80 FE 00]
    JGE     loc_02f9                                         ; [0302: 7D F5]
    SUB     BX, 00A0                                         ; [0304: 81 EB A0 00]
    MOV     AH, AL                                           ; [0308: 8A E0]
    CMP     AH, FF                                           ; [030A: 80 FC FF]
    JZ      loc_0330                                         ; [030D: 74 21]
    CMP     AH, 90                                           ; [030F: 80 FC 90]
    JZ      loc_0330                                         ; [0312: 74 1C]
    CMP     AH, 91                                           ; [0314: 80 FC 91]
    JZ      loc_0330                                         ; [0317: 74 17]
    CMP     AH, 92                                           ; [0319: 80 FC 92]
    JZ      loc_0330                                         ; [031C: 74 12]
    CMP     AH, 93                                           ; [031E: 80 FC 93]
    JZ      loc_0330                                         ; [0321: 74 0D]
    AND     AH, 7F                                           ; [0323: 80 E4 7F]
    CMP     AH, 61                                           ; [0326: 80 FC 61]
    JC      loc_0330                                         ; [0329: 72 05]
    SUB     AH, 20                                           ; [032B: 80 EC 20]
    MOV     AL, AH                                           ; [032E: 8A C4]
loc_0330:
    MOV     BYTE [ES:BX+04], AL                              ; [0330: 26 88 47 04]
    CALL    sub_0267                                         ; [0334: E8 30 FF]
    INC     AX                                               ; [0337: 40]
    CALL    set_cursor_pos                                   ; [0338: E8 3E FF]
    CALL    sub_01f3                                         ; [033B: E8 B5 FE]
loc_033e:
    POP     BP                                               ; [033E: 5D]
    POP     ES                                               ; [033F: 07]
    POP     DS                                               ; [0340: 1F]
    POP     DX                                               ; [0341: 5A]
    POP     BX                                               ; [0342: 5B]
    POP     AX                                               ; [0343: 58]
    RETN                                                     ; [0344: C3]
sub_0345:
    PUSH    AX                                               ; [0345: 50]
    PUSH    BX                                               ; [0346: 53]
    PUSH    CX                                               ; [0347: 51]
    MOV     CX, AX                                           ; [0348: 8B C8]
    MOV     AH, 02                                           ; [034A: B4 02]
loc_034c:
    MOV     BH, 03                                           ; [034C: B7 03]
    MOV     BL, CH                                           ; [034E: 8A DD]
    ROL     CH, 1                                            ; [0350: D0 C5]
    ROL     CH, 1                                            ; [0352: D0 C5]
    ROL     CH, 1                                            ; [0354: D0 C5]
    ROL     CH, 1                                            ; [0356: D0 C5]
loc_0358:
    DEC     BH                                               ; [0358: FE CF]
    JZ      loc_0375                                         ; [035A: 74 19]
    AND     CH, 0F                                           ; [035C: 80 E5 0F]
    CMP     CH, 0A                                           ; [035F: 80 FD 0A]
    JNC     loc_0369                                         ; [0362: 73 05]
    ADD     CH, 30                                           ; [0364: 80 C5 30]
    JMPS    loc_036c                                         ; [0367: EB 03]
loc_0369:
    ADD     CH, 37                                           ; [0369: 80 C5 37]
loc_036c:
    MOV     AL, CH                                           ; [036C: 8A C5]
    CALL    conout_char                                      ; [036E: E8 27 FF]
    MOV     CH, BL                                           ; [0371: 8A EB]
    JMPS    loc_0358                                         ; [0373: EB E3]
loc_0375:
    MOV     CH, CL                                           ; [0375: 8A E9]
    DEC     AH                                               ; [0377: FE CC]
    JNZ     loc_034c                                         ; [0379: 75 D1]
    POP     CX                                               ; [037B: 59]
    POP     BX                                               ; [037C: 5B]
    POP     AX                                               ; [037D: 58]
    RETN                                                     ; [037E: C3]

; ----------------------------------------------------------------------------
; decimal_divisor_table (ROM: 3BBFh, FB84:037Fh)
; 16-bit divisortabel for binær-til-decimal ASCII rutine (FB84:0393)
; ----------------------------------------------------------------------------
decimal_divisor_table:
    DW  02710h                       ; [037Fh] 10000 decimal
    DW  003E8h                       ; [0381h] 1000 decimal
    DW  00064h                       ; [0383h] 100 decimal
    DW  0000Ah                       ; [0385h] 10 decimal
    DW  00001h                       ; [0387h] 1 decimal
    ADD     BYTE [BX+SI], AL                                 ; [0389: 00 00]
sub_038b:
    PUSH    BX                                               ; [038B: 53]
    PUSH    DX                                               ; [038C: 52]
    PUSH    SI                                               ; [038D: 56]
    MOV     SI, 0000                                         ; [038E: BE 00 00]
loc_0391:
    SUB     DX, DX                                           ; [0391: 2B D2]
    IDIV    WORD [CS:SI+decimal_divisor_table]               ; [0393: 2E F7 BC 7F 03]
    MOV     BL, 30                                           ; [0398: B3 30]
    ADD     AL, BL                                           ; [039A: 02 C3]
    CALL    conout_char                                      ; [039C: E8 F9 FE]
    INC     SI                                               ; [039F: 46]
    INC     SI                                               ; [03A0: 46]
    MOV     AX, DX                                           ; [03A1: 8B C2]
    CMP     SI, +0A                                          ; [03A3: 83 FE 0A]
    JNZ     loc_0391                                         ; [03A6: 75 E9]
    POP     SI                                               ; [03A8: 5E]
    POP     DX                                               ; [03A9: 5A]
    POP     BX                                               ; [03AA: 5B]
    RETN                                                     ; [03AB: C3]

; ----------------------------------------------------------------------------
; print_string_es_ax (ROM: 3BECh, FB84:03ACh)
; ----------------------------------------------------------------------------
print_string_es_ax:
    PUSH    AX                                               ; [03AC: 50]
    PUSH    BX                                               ; [03AD: 53]
    PUSH    CX                                               ; [03AE: 51]
    PUSH    DS                                               ; [03AF: 1E]
    MOV     BX, AX                                           ; [03B0: 8B D8]
    MOV     AX, [CS:rom_segment_base]                        ; [03B2: 2E A1 00 00]
    MOV     DS, AX                                           ; [03B6: 8E D8]
loc_03b8:
    MOV     AL, BYTE [BX]                                    ; [03B8: 8A 07]
    CALL    conout_char                                      ; [03BA: E8 DB FE]
    CMP     AL, 0A                                           ; [03BD: 3C 0A]
    JZ      loc_03c4                                         ; [03BF: 74 03]
    INC     BX                                               ; [03C1: 43]
    LOOP    loc_03b8                                         ; [03C2: E2 F4]
loc_03c4:
    POP     DS                                               ; [03C4: 1F]
    POP     CX                                               ; [03C5: 59]
    POP     BX                                               ; [03C6: 5B]
    POP     AX                                               ; [03C7: 58]
    RETN                                                     ; [03C8: C3]

; ----------------------------------------------------------------------------
; wait_key_press (ROM: 3C09h, FB84:03C9h)
; ----------------------------------------------------------------------------
wait_key_press:
    MOV     AX, 23BD                                         ; [03C9: B8 BD 23]
    MOV     CX, FFFF                                         ; [03CC: B9 FF FF]
    CALL    print_string_es_ax                               ; [03CF: E8 DA FF]
    RETN                                                     ; [03D2: C3]

; ----------------------------------------------------------------------------
; read_key_poll (ROM: 3C13h, FB84:03D3h)
; ----------------------------------------------------------------------------
read_key_poll:
    PUSH    DS                                               ; [03D3: 1E]
    PUSH    ES                                               ; [03D4: 06]
    MOV     DS, WORD [CS:ram_segment_base]                   ; [03D5: 2E 8E 1E 02 00]
    MOV     ES, WORD [CS:rom_segment_base]                   ; [03DA: 2E 8E 06 00 00]
loc_03df:
    CMP     BYTE [var_kbd_key_ready], FF ; Keyboard event flag (FFh = key pressed) ; [03DF: 80 3E 32 01 FF]
    JZ      loc_03eb                                         ; [03E4: 74 05]
    STI                                                      ; [03E6: FB]
    HLT                                                      ; [03E7: F4]
    CLI                                                      ; [03E8: FA]
    JMPS    loc_03df                                         ; [03E9: EB F4]
loc_03eb:
    MOV     BYTE [var_kbd_key_ready], 00 ; Keyboard event flag (FFh = key pressed) ; [03EB: C6 06 32 01 00]
    MOV     AL, [var_kbd_ascii_char]     ; Keyboard ASCII char buffer ; [03F0: A0 33 01]
    POP     ES                                               ; [03F3: 07]
    POP     DS                                               ; [03F4: 1F]
    RETN                                                     ; [03F5: C3]

; ----------------------------------------------------------------------------
; check_hotkey_ctrl_alt_del (ROM: 3C36h, FB84:03F6h)
; ----------------------------------------------------------------------------
check_hotkey_ctrl_alt_del:
    CMP     AL, 0E                                           ; [03F6: 3C 0E]
    JNZ     loc_0407                                         ; [03F8: 75 0D]
    CMP     BYTE [var_kbd_ctrl_alt_state], 02 ; Keyboard modifier counter (Ctrl + Alt) ; [03FA: 80 3E 2F 01 02]
    JC      loc_0407                                         ; [03FF: 72 06]
    CALL    issue_82730_channel_attention                    ; [0401: E8 E1 06]
    JMPN    start_bootloader_sequence                        ; [0404: E9 21 09]
loc_0407:
    CMP     AL, 1D                                           ; [0407: 3C 1D]
    JNZ     loc_040f                                         ; [0409: 75 04]
    INC     BYTE [var_kbd_ctrl_alt_state] ; Keyboard modifier counter (Ctrl + Alt) ; [040B: FE 06 2F 01]
loc_040f:
    CMP     AL, 9D                                           ; [040F: 3C 9D]
    JNZ     loc_0417                                         ; [0411: 75 04]
    DEC     BYTE [var_kbd_ctrl_alt_state] ; Keyboard modifier counter (Ctrl + Alt) ; [0413: FE 0E 2F 01]
loc_0417:
    CMP     AL, 37                                           ; [0417: 3C 37]
    JNZ     loc_041f                                         ; [0419: 75 04]
    INC     BYTE [var_kbd_ctrl_alt_state] ; Keyboard modifier counter (Ctrl + Alt) ; [041B: FE 06 2F 01]
loc_041f:
    CMP     AL, B7                                           ; [041F: 3C B7]
    JNZ     loc_0427                                         ; [0421: 75 04]
    DEC     BYTE [var_kbd_ctrl_alt_state] ; Keyboard modifier counter (Ctrl + Alt) ; [0423: FE 0E 2F 01]
loc_0427:
    RETN                                                     ; [0427: C3]

; ----------------------------------------------------------------------------
; isr_keyboard_int1 (ROM: 3C68h, FB84:0428h)
; ----------------------------------------------------------------------------
isr_keyboard_int1:
    PUSH    AX                                               ; [0428: 50]
    PUSH    BX                                               ; [0429: 53]
    PUSH    DX                                               ; [042A: 52]
    MOV     DX, io_kbd_data              ; Keyboard Data / Status register ; [042B: BA 20 00]
    IN      AL, DX                                           ; [042E: EC]
    MOV     [var_kbd_raw_scancode], AL   ; Keyboard raw scancode buffer ; [042F: A2 34 01]
    CALL    check_hotkey_ctrl_alt_del                        ; [0432: E8 C1 FF]
    CMP     AL, F5                                           ; [0435: 3C F5]
    JC      loc_0440                                         ; [0437: 72 07]
    NOT     AL                                               ; [0439: F6 D0]
    MOV     [var_nvram_valid_magic], AL  ; NVRAM Magic byte 0xAA validation ; [043B: A2 65 00]
    JMPS    loc_0447                                         ; [043E: EB 07]
loc_0440:
    CMP     AL, E4                                           ; [0440: 3C E4]
    JC      loc_044e                                         ; [0442: 72 0A]
    MOV     [var_nvram_checksum], AL                         ; [0444: A2 66 00]
loc_0447:
    MOV     BYTE [var_kbd_key_ready], 00 ; Keyboard event flag (FFh = key pressed) ; [0447: C6 06 32 01 00]
    JMPS    loc_047c                                         ; [044C: EB 2E]
loc_044e:
    MOV     BX, 2162                                         ; [044E: BB 62 21]
loc_0451:
    MOV     AH, BYTE [ES:BX]                                 ; [0451: 26 8A 27]
    CMP     AH, 00                                           ; [0454: 80 FC 00]
    JZ      loc_047c                                         ; [0457: 74 23]
    CMP     AL, AH                                           ; [0459: 3A C4]
    JZ      loc_0461                                         ; [045B: 74 04]
    INC     BX                                               ; [045D: 43]
    INC     BX                                               ; [045E: 43]
    JMPS    loc_0451                                         ; [045F: EB F0]
loc_0461:
    INC     BX                                               ; [0461: 43]
    MOV     AL, BYTE [ES:BX]                                 ; [0462: 26 8A 07]
    MOV     [var_kbd_ascii_char], AL     ; Keyboard ASCII char buffer ; [0465: A2 33 01]
    TEST    WORD [var_boot_status_flags], 2000 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [0468: F7 06 2D 01 00 20]
    JNZ     loc_0477                                         ; [046E: 75 07]
    CMP     AL, 20                                           ; [0470: 3C 20]
    JZ      loc_0477                                         ; [0472: 74 03]
    MOV     [var_boot_drive_preselect], AL ; Boot drive preselection buffer ('A', 'B', etc.) ; [0474: A2 67 00]
loc_0477:
    MOV     BYTE [var_kbd_key_ready], FF ; Keyboard event flag (FFh = key pressed) ; [0477: C6 06 32 01 FF]
loc_047c:
    CALL    issue_82730_channel_attention                    ; [047C: E8 66 06]
    POP     DX                                               ; [047F: 5A]
    POP     BX                                               ; [0480: 5B]
    POP     AX                                               ; [0481: 58]
    IRET                                                     ; [0482: CF]
    PUSH    AX                                               ; [0483: 50]
    IN      AL, io_ppi_portb             ; 8255 PPI Port B (Monitor type 50/60Hz, RTC type) ; [0484: E4 72]
    TEST    AL, 80                                           ; [0486: A8 80]
    JNZ     loc_0495                                         ; [0488: 75 0B]
    CALL    sub_01a8                                         ; [048A: E8 1B FD]
    MOV     BYTE [var_kbd_key_ready], FF ; Keyboard event flag (FFh = key pressed) ; [048D: C6 06 32 01 FF]
    MOV     [var_kbd_ascii_char], AL     ; Keyboard ASCII char buffer ; [0492: A2 33 01]
loc_0495:
    CALL    issue_82730_channel_attention                    ; [0495: E8 4D 06]
    POP     AX                                               ; [0498: 58]
    IRET                                                     ; [0499: CF]
sub_049a:
    PUSH    AX                                               ; [049A: 50]
    PUSH    DX                                               ; [049B: 52]
    PUSH    AX                                               ; [049C: 50]
    MOV     DX, io_i186_timer1_count     ; 80186 Timer 1 Count register (T1CNT) ; [049D: BA 58 FF]
    MOV     AX, 0000                                         ; [04A0: B8 00 00]
    OUT     DX, AX                                           ; [04A3: EF]
    ADD     DX, +02                                          ; [04A4: 83 C2 02]
    POP     AX                                               ; [04A7: 58]
    OUT     DX, AX                                           ; [04A8: EF]
    ADD     DX, +02                                          ; [04A9: 83 C2 02]
    OUT     DX, AX                                           ; [04AC: EF]
    ADD     DX, +02                                          ; [04AD: 83 C2 02]
    MOV     AX, C003                                         ; [04B0: B8 03 C0]
    OUT     DX, AX                                           ; [04B3: EF]
    MOV     AX, 2710                                         ; [04B4: B8 10 27]
    CALL    busy_loop_delay_ax                               ; [04B7: E8 04 07]
    MOV     AX, C002                                         ; [04BA: B8 02 C0]
    OUT     DX, AX                                           ; [04BD: EF]
    POP     DX                                               ; [04BE: 5A]
    POP     AX                                               ; [04BF: 58]
    RETN                                                     ; [04C0: C3]

; ----------------------------------------------------------------------------
; ram_top_segment_table (ROM: 3D01h, FB84:04C1h)
; RAM top-segmenter ud fra Port 70h DIP-switches (FB84:0884)
; ----------------------------------------------------------------------------
ram_top_segment_table:
    DW  09000h                       ; [04C1h] 0000h (Reserved/Invalid)
    DW  05000h                       ; [04C3h] 1000h (64 KB)
    DW  0B000h                       ; [04C5h] 2000h (128 KB)
    DW  03000h                       ; [04C7h] 3000h (192 KB)
    DW  0000Ah                       ; [04C9h] 4000h (256 KB)
    DW  00006h                       ; [04CBh] 5000h (320 KB)
    DW  0000Ch                       ; [04CDh] 6000h (384 KB)
    DW  cold_boot_entry              ; [04CFh] 7000h (448 KB)

; ----------------------------------------------------------------------------
; test_prom_checksum (ROM: 3D11h, FB84:04D1h)
; ----------------------------------------------------------------------------
test_prom_checksum:
    CLI                                                      ; [04D1: FA]
    MOV     AX, F000                                         ; [04D2: B8 00 F0]
    MOV     ES, AX                                           ; [04D5: 8E C0]
    MOV     BX, FFFF                                         ; [04D7: BB FF FF]
    MOV     AX, 4000                                         ; [04DA: B8 00 40]
    SHL     AX, 1                                            ; [04DD: D1 E0]
    DEC     AX                                               ; [04DF: 48]
    MOV     DX, BX                                           ; [04E0: 8B D3]
    SUB     DX, AX                                           ; [04E2: 2B D0]
    DEC     BX                                               ; [04E4: 4B]
    XOR     AX, AX                                           ; [04E5: 33 C0]
    MOV     CX, AX                                           ; [04E7: 8B C8]
loc_04e9:
    MOV     CX, WORD [ES:BX]                                 ; [04E9: 26 8B 0F]
    ADD     AH, CH                                           ; [04EC: 02 E5]
    ADD     AL, CL                                           ; [04EE: 02 C1]
    DEC     BX                                               ; [04F0: 4B]
    DEC     BX                                               ; [04F1: 4B]
    CMP     BX, DX                                           ; [04F2: 3B DA]
    JNC     loc_04e9                                         ; [04F4: 73 F3]
    CMP     AX, 0000                                         ; [04F6: 3D 00 00]
    JZ      test_crt_vram_start                              ; [04F9: 74 4D]
    MOV     CX, AX                                           ; [04FB: 8B C8]
    MOV     AX, [CS:ram_segment_base]                        ; [04FD: 2E A1 02 00]
    MOV     DS, AX                                           ; [0501: 8E D8]
    MOV     WORD [var_selftest_failing_dev], CX              ; [0503: 89 0E 25 01]
    MOV     BYTE [var_selftest_error_flags], 01 ; Selftest error flags buffer ; [0507: C6 06 20 01 01]
    MOV     AX, [CS:rom_segment_base]                        ; [050C: 2E A1 00 00]
    MOV     DS, AX                                           ; [0510: 8E D8]
    MOV     DI, 0518                                         ; [0512: BF 18 05]
    JMPN    loc_013f                                         ; [0515: E9 27 FC]
    MOV     BX, 21D2                                         ; [0518: BB D2 21]
    MOV     CX, FFFF                                         ; [051B: B9 FF FF]
    MOV     DI, 0677                                         ; [051E: BF 77 06]
    JMPN    serial_tx_banner_loop                            ; [0521: E9 F8 FB]
sub_0524:
    CLI                                                      ; [0524: FA]
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [0525: B8 00 30]
    MOV     ES, AX                                           ; [0528: 8E C0]
    MOV     BX, 2000                                         ; [052A: BB 00 20]
loc_052d:
    MOV     AL, 01                                           ; [052D: B0 01]
    LOCK XCHG BYTE [ES:BX], AL                               ; [052F: F0 26 86 07]
    CMP     AL, 01                                           ; [0533: 3C 01]
    JZ      loc_052d                                         ; [0535: 74 F6]
    MOV     BYTE [ES:BX+01], 03                              ; [0537: 26 C6 47 01 03]
    MOV     DX, io_i82730_ca_pulse       ; Intel 82730 Channel Attention (CA pulse) ; [053C: BA 40 02]
    OUT     DX, AX                                           ; [053F: EF]
    MOV     BP, WORD [var_boot_status_flags] ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [0540: 8B 2E 2D 01]
    MOV     SP, WORD [var_kbd_shift_state]                   ; [0544: 8B 26 30 01]

; ----------------------------------------------------------------------------
; test_crt_vram_start (ROM: 3D88h, FB84:0548h)
; ----------------------------------------------------------------------------
test_crt_vram_start:
    STD                                                      ; [0548: FD]
    MOV     AX, 55AA                                         ; [0549: B8 AA 55]
    MOV     CL, 02                                           ; [054C: B1 02]
loc_054e:
    MOV     DX, CRT_VRAM_SEGMENT                             ; [054E: BA 00 D0]
    MOV     ES, DX                                           ; [0551: 8E C2]
    MOV     DI, 7FFE                                         ; [0553: BF FE 7F]
    NOT     AX                                               ; [0556: F7 D0]
loc_0558:
    NOT     AX                                               ; [0558: F7 D0]
    STOSW                                                    ; [055A: AB]
    CMP     DI, -02                                          ; [055B: 83 FF FE]
    JNC     test_crt_vram_verify                             ; [055E: 73 0E]
    STOSW                                                    ; [0560: AB]
    CMP     DI, -02                                          ; [0561: 83 FF FE]
    JNC     test_crt_vram_verify                             ; [0564: 73 08]
    STOSW                                                    ; [0566: AB]
    CMP     DI, -02                                          ; [0567: 83 FF FE]
    JNC     test_crt_vram_verify                             ; [056A: 73 02]
    JMPS    loc_0558                                         ; [056C: EB EA]

; ----------------------------------------------------------------------------
; test_crt_vram_verify (ROM: 3DAEh, FB84:056Eh)
; ----------------------------------------------------------------------------
test_crt_vram_verify:
    MOV     DS, DX                                           ; [056E: 8E DA]
    MOV     SI, 7FFE                                         ; [0570: BE FE 7F]
    MOV     AX, 55AA                                         ; [0573: B8 AA 55]
    CMP     CL, 02                                           ; [0576: 80 F9 02]
    JZ      loc_057d                                         ; [0579: 74 02]
    NOT     AX                                               ; [057B: F7 D0]
loc_057d:
    MOV     DX, AX                                           ; [057D: 8B D0]
loc_057f:
    LODSW                                                    ; [057F: AD]
    CMP     AX, DX                                           ; [0580: 3B C2]
    JNZ     error_crt_vram                                   ; [0582: 75 2E]
    CMP     SI, -02                                          ; [0584: 83 FE FE]
    JNC     loc_05a1                                         ; [0587: 73 18]
    LODSW                                                    ; [0589: AD]
    CMP     AX, DX                                           ; [058A: 3B C2]
    JNZ     error_crt_vram                                   ; [058C: 75 24]
    CMP     SI, -02                                          ; [058E: 83 FE FE]
    JNC     loc_05a1                                         ; [0591: 73 0E]
    LODSW                                                    ; [0593: AD]
    CMP     AX, DX                                           ; [0594: 3B C2]
    JNZ     error_crt_vram                                   ; [0596: 75 1A]
    CMP     SI, -02                                          ; [0598: 83 FE FE]
    JNC     loc_05a1                                         ; [059B: 73 04]
    NOT     DX                                               ; [059D: F7 D2]
    JMPS    loc_057f                                         ; [059F: EB DE]
loc_05a1:
    DEC     CL                                               ; [05A1: FE C9]
    CMP     CL, 00                                           ; [05A3: 80 F9 00]
    JZ      loc_05af                                         ; [05A6: 74 07]
    MOV     AX, 55AA                                         ; [05A8: B8 AA 55]
    NOT     AX                                               ; [05AB: F7 D0]
    JMPS    loc_054e                                         ; [05AD: EB 9F]
loc_05af:
    JMPN    init_video_and_fonts                             ; [05AF: E9 BA 00]

; ----------------------------------------------------------------------------
; error_crt_vram (ROM: 3DF2h, FB84:05B2h)
; ----------------------------------------------------------------------------
error_crt_vram:
    INC     SI                                               ; [05B2: 46]
    INC     SI                                               ; [05B3: 46]
    MOV     SS, DX                                           ; [05B4: 8E D2]
    MOV     ES, AX                                           ; [05B6: 8E C0]
    MOV     AX, [CS:rom_segment_base]                        ; [05B8: 2E A1 00 00]
    MOV     DS, AX                                           ; [05BC: 8E D8]
    MOV     BX, 21E9                                         ; [05BE: BB E9 21]
    MOV     CX, 0011                                         ; [05C1: B9 11 00]
    MOV     DI, 05CA                                         ; [05C4: BF CA 05]
    JMPN    serial_tx_banner_loop                            ; [05C7: E9 52 FB]
    MOV     BX, 23CD                                         ; [05CA: BB CD 23]
    MOV     CX, 0008                                         ; [05CD: B9 08 00]
    MOV     DI, 05D6                                         ; [05D0: BF D6 05]
    JMPN    serial_tx_banner_loop                            ; [05D3: E9 46 FB]
    MOV     CX, CRT_VRAM_SEGMENT                             ; [05D6: B9 00 D0]
    MOV     AX, [CS:ram_segment_base]                        ; [05D9: 2E A1 02 00]
    MOV     DS, AX                                           ; [05DD: 8E D8]
    MOV     WORD [var_selftest_loop_count], CX               ; [05DF: 89 0E 27 01]
    MOV     BYTE [var_selftest_error_flags], 02 ; Selftest error flags buffer ; [05E3: C6 06 20 01 02]
    MOV     AX, [CS:rom_segment_base]                        ; [05E8: 2E A1 00 00]
    MOV     DS, AX                                           ; [05EC: 8E D8]
    MOV     DI, 05F4                                         ; [05EE: BF F4 05]
    JMPN    loc_013f                                         ; [05F1: E9 4B FB]
    MOV     BX, 21FB                                         ; [05F4: BB FB 21]
    MOV     CX, 0001                                         ; [05F7: B9 01 00]
    MOV     DI, 0600                                         ; [05FA: BF 00 06]
    JMPN    serial_tx_banner_loop                            ; [05FD: E9 1C FB]
    MOV     CX, SI                                           ; [0600: 8B CE]
    MOV     AX, [CS:ram_segment_base]                        ; [0602: 2E A1 02 00]
    MOV     DS, AX                                           ; [0606: 8E D8]
    MOV     WORD [var_selftest_error_subcode], CX            ; [0608: 89 0E 21 01]
    MOV     AX, [CS:rom_segment_base]                        ; [060C: 2E A1 00 00]
    MOV     DS, AX                                           ; [0610: 8E D8]
    MOV     DI, 0618                                         ; [0612: BF 18 06]
    JMPN    loc_013f                                         ; [0615: E9 27 FB]
    MOV     BX, 23D5                                         ; [0618: BB D5 23]
    MOV     CX, 0008                                         ; [061B: B9 08 00]
    MOV     DI, 0624                                         ; [061E: BF 24 06]
    JMPN    serial_tx_banner_loop                            ; [0621: E9 F8 FA]
    MOV     CX, SS                                           ; [0624: 8C D1]
    MOV     AX, [CS:ram_segment_base]                        ; [0626: 2E A1 02 00]
    MOV     DS, AX                                           ; [062A: 8E D8]
    MOV     WORD [var_selftest_error_count], CX              ; [062C: 89 0E 23 01]
    MOV     AX, [CS:rom_segment_base]                        ; [0630: 2E A1 00 00]
    MOV     DS, AX                                           ; [0634: 8E D8]
    MOV     DI, 063C                                         ; [0636: BF 3C 06]
    JMPN    loc_013f                                         ; [0639: E9 03 FB]
    MOV     BX, 23DD                                         ; [063C: BB DD 23]
    MOV     CX, 0008                                         ; [063F: B9 08 00]
    MOV     DI, 0648                                         ; [0642: BF 48 06]
    JMPN    serial_tx_banner_loop                            ; [0645: E9 D4 FA]
    MOV     CX, ES                                           ; [0648: 8C C1]
    MOV     AX, [CS:ram_segment_base]                        ; [064A: 2E A1 02 00]
    MOV     DS, AX                                           ; [064E: 8E D8]
    MOV     WORD [var_selftest_failing_dev], CX              ; [0650: 89 0E 25 01]
    MOV     AX, [CS:rom_segment_base]                        ; [0654: 2E A1 00 00]
    MOV     DS, AX                                           ; [0658: 8E D8]
    MOV     DI, 0660                                         ; [065A: BF 60 06]
    JMPN    loc_013f                                         ; [065D: E9 DF FA]
    MOV     BX, 23BD                                         ; [0660: BB BD 23]
    MOV     CX, FFFF                                         ; [0663: B9 FF FF]
    MOV     DI, 0677                                         ; [0666: BF 77 06]
    JMPN    serial_tx_banner_loop                            ; [0669: E9 B0 FA]

; ----------------------------------------------------------------------------
; init_video_and_fonts (ROM: 3EACh, FB84:066Ch)
; ----------------------------------------------------------------------------
init_video_and_fonts:
    MOV     AX, [CS:ram_segment_base]                        ; [066C: 2E A1 02 00]
    MOV     DS, AX                                           ; [0670: 8E D8]
    MOV     BYTE [var_selftest_error_flags], 00 ; Selftest error flags buffer ; [0672: C6 06 20 01 00]
    MOV     AX, CRT_VRAM_SEGMENT                             ; [0677: B8 00 D0]
    MOV     ES, AX                                           ; [067A: 8E C0]
    MOV     DI, 0000                                         ; [067C: BF 00 00]
    MOV     CX, 4000                                         ; [067F: B9 00 40]
    MOV     AX, 0000                                         ; [0682: B8 00 00]
    CLD                                                      ; [0685: FC]
    REP STOSW                                                ; [0686: F3 AB]
    MOV     BX, SP                                           ; [0688: 8B DC]
    MOV     DX, BP                                           ; [068A: 8B D5]
    MOV     AX, CRT_VRAM_SEGMENT                             ; [068C: B8 00 D0]
    MOV     SS, AX                                           ; [068F: 8E D0]
    MOV     SP, 8000                                         ; [0691: BC 00 80]
    MOV     BP, SP                                           ; [0694: 8B EC]
    PUSH    DX                                               ; [0696: 52]
    PUSH    BX                                               ; [0697: 53]
    CALL    setup_interrupt_vectors                          ; [0698: E8 90 04]
    MOV     AX, [CS:rom_segment_base]                        ; [069B: 2E A1 00 00]
    MOV     DS, AX                                           ; [069F: 8E D8]
    MOV     DX, io_ppi_portb             ; 8255 PPI Port B (Monitor type 50/60Hz, RTC type) ; [06A1: BA 72 00]
    IN      AL, DX                                           ; [06A4: EC]
    AND     AL, 40                                           ; [06A5: 24 40]
    JNZ     load_fonts_60hz                                  ; [06A7: 75 32]

; ----------------------------------------------------------------------------
; load_fonts_50hz (ROM: 3EE9h, FB84:06A9h)
; ----------------------------------------------------------------------------
load_fonts_50hz:
    MOV     BX, 01DD                                         ; [06A9: BB DD 01]
loc_06ac:
    MOV     CL, 05                                           ; [06AC: B1 05]
    XOR     AH, AH                                           ; [06AE: 32 E4]
    MOV     AL, BYTE [BX]                                    ; [06B0: 8A 07]
    SHL     AX, CL                                           ; [06B2: D3 E0]
    MOV     DI, AX                                           ; [06B4: 8B F8]
    MOV     CX, 000A                                         ; [06B6: B9 0A 00]
loc_06b9:
    INC     BX                                               ; [06B9: 43]
    MOV     AH, BYTE [BX]                                    ; [06BA: 8A 27]
    MOV     AL, 00                                           ; [06BC: B0 00]
    MOV     WORD [ES:DI], AX                                 ; [06BE: 26 89 05]
    INC     DI                                               ; [06C1: 47]
    INC     DI                                               ; [06C2: 47]
    LOOP    loc_06b9                                         ; [06C3: E2 F4]
    INC     BX                                               ; [06C5: 43]
    MOV     AX, 0000                                         ; [06C6: B8 00 00]
    MOV     CX, 0006                                         ; [06C9: B9 06 00]
loc_06cc:
    MOV     WORD [ES:DI], AX                                 ; [06CC: 26 89 05]
    INC     DI                                               ; [06CF: 47]
    INC     DI                                               ; [06D0: 47]
    LOOP    loc_06cc                                         ; [06D1: E2 F9]
    CMP     BYTE [BX], 00                                    ; [06D3: 80 3F 00]
    JNZ     loc_06ac                                         ; [06D6: 75 D4]
    JMPN    init_82730_buffers                               ; [06D8: E9 5B 00]

; ----------------------------------------------------------------------------
; load_fonts_60hz (ROM: 3F1Bh, FB84:06DBh)
; ----------------------------------------------------------------------------
load_fonts_60hz:
    MOV     BX, 0D40                                         ; [06DB: BB 40 0D]
loc_06de:
    MOV     CL, 05                                           ; [06DE: B1 05]
    XOR     AH, AH                                           ; [06E0: 32 E4]
    MOV     AL, BYTE [BX]                                    ; [06E2: 8A 07]
    SHL     AX, CL                                           ; [06E4: D3 E0]
    MOV     DI, AX                                           ; [06E6: 8B F8]
    MOV     CX, 000E                                         ; [06E8: B9 0E 00]
loc_06eb:
    INC     BX                                               ; [06EB: 43]
    MOV     AH, BYTE [BX]                                    ; [06EC: 8A 27]
    MOV     AL, 00                                           ; [06EE: B0 00]
    MOV     WORD [ES:DI], AX                                 ; [06F0: 26 89 05]
    INC     DI                                               ; [06F3: 47]
    INC     DI                                               ; [06F4: 47]
    LOOP    loc_06eb                                         ; [06F5: E2 F4]
    INC     BX                                               ; [06F7: 43]
    MOV     AX, 0000                                         ; [06F8: B8 00 00]
    MOV     CX, 0002                                         ; [06FB: B9 02 00]
loc_06fe:
    MOV     WORD [ES:DI], AX                                 ; [06FE: 26 89 05]
    INC     DI                                               ; [0701: 47]
    INC     DI                                               ; [0702: 47]
    LOOP    loc_06fe                                         ; [0703: E2 F9]
    CMP     BYTE [BX], 00                                    ; [0705: 80 3F 00]
    JNZ     loc_06de                                         ; [0708: 75 D4]
    INC     BX                                               ; [070A: 43]
loc_070b:
    MOV     CL, 05                                           ; [070B: B1 05]
    XOR     AH, AH                                           ; [070D: 32 E4]
    MOV     AL, BYTE [BX]                                    ; [070F: 8A 07]
    SHL     AX, CL                                           ; [0711: D3 E0]
    MOV     DI, AX                                           ; [0713: 8B F8]
    MOV     CX, 000E                                         ; [0715: B9 0E 00]
    INC     BX                                               ; [0718: 43]
loc_0719:
    MOV     AX, WORD [BX]                                    ; [0719: 8B 07]
    MOV     WORD [ES:DI], AX                                 ; [071B: 26 89 05]
    INC     DI                                               ; [071E: 47]
    INC     DI                                               ; [071F: 47]
    INC     BX                                               ; [0720: 43]
    INC     BX                                               ; [0721: 43]
    LOOP    loc_0719                                         ; [0722: E2 F5]
    MOV     AX, 0000                                         ; [0724: B8 00 00]
    MOV     CX, 0002                                         ; [0727: B9 02 00]
loc_072a:
    MOV     WORD [ES:DI], AX                                 ; [072A: 26 89 05]
    INC     DI                                               ; [072D: 47]
    INC     DI                                               ; [072E: 47]
    LOOP    loc_072a                                         ; [072F: E2 F9]
    CMP     WORD [BX], +00                                   ; [0731: 83 3F 00]
    JNZ     loc_070b                                         ; [0734: 75 D5]

; ----------------------------------------------------------------------------
; init_82730_buffers (ROM: 3F76h, FB84:0736h)
; ----------------------------------------------------------------------------
init_82730_buffers:
    MOV     DI, LAN_BUFFER_ALT_SEGMENT                       ; [0736: BF 00 30]
    MOV     AX, 8E00                                         ; [0739: B8 00 8E]
    STOSW                                                    ; [073C: AB]
    XOR     AX, AX                                           ; [073D: 33 C0]
    MOV     CX, 07D0                                         ; [073F: B9 D0 07]
    REP STOSW                                                ; [0742: F3 AB]
    MOV     DI, 4000                                         ; [0744: BF 00 40]
    MOV     AX, 8E00                                         ; [0747: B8 00 8E]
    STOSW                                                    ; [074A: AB]
    XOR     AX, AX                                           ; [074B: 33 C0]
    MOV     CX, 07D0                                         ; [074D: B9 D0 07]
    REP STOSW                                                ; [0750: F3 AB]
    XOR     AX, AX                                           ; [0752: 33 C0]
    MOV     DI, 5000                                         ; [0754: BF 00 50]
    MOV     CX, 0050                                         ; [0757: B9 50 00]
    REP STOSW                                                ; [075A: F3 AB]
    MOV     BX, 0FFF                                         ; [075C: BB FF 0F]
    MOV     ES, BX                                           ; [075F: 8E C3]
    MOV     BX, 000E                                         ; [0761: BB 0E 00]
    MOV     WORD [ES:BX], 6000                               ; [0764: 26 C7 07 00 60]
    MOV     WORD [ES:BX+02], 000D                            ; [0769: 26 C7 47 02 0D 00]

; ----------------------------------------------------------------------------
; setup_82730_cb_scb (ROM: 3FAFh, FB84:076Fh)
; ----------------------------------------------------------------------------
setup_82730_cb_scb:
    MOV     AX, CRT_VRAM_SEGMENT                             ; [076F: B8 00 D0]
    MOV     ES, AX                                           ; [0772: 8E C0]
    MOV     AX, [CS:rom_segment_base]                        ; [0774: 2E A1 00 00]
    MOV     DS, AX                                           ; [0778: 8E D8]
    MOV     DI, 6000                                         ; [077A: BF 00 60]
    MOV     SI, 0005                                         ; [077D: BE 05 00]
    MOV     CX, 0007                                         ; [0780: B9 07 00]
    CLD                                                      ; [0783: FC]
    JMPS    loc_0786                                         ; [0784: EB 00]
loc_0786:
    REP MOVSB                                                ; [0786: F3 A4]
    MOV     AX, CRT_VRAM_SEGMENT                             ; [0788: B8 00 D0]
    MOV     ES, AX                                           ; [078B: 8E C0]
    MOV     DI, 2000                                         ; [078D: BF 00 20]
    MOV     SI, 000C                                         ; [0790: BE 0C 00]
    MOV     CX, 0026                                         ; [0793: B9 26 00]
    CLD                                                      ; [0796: FC]
    JMPS    loc_0799                                         ; [0797: EB 00]
loc_0799:
    REP MOVSB                                                ; [0799: F3 A4]
    MOV     DX, io_ppi_portb             ; 8255 PPI Port B (Monitor type 50/60Hz, RTC type) ; [079B: BA 72 00]
    IN      AL, DX                                           ; [079E: EC]
    AND     AL, 40                                           ; [079F: 24 40]
    JNZ     loc_07ac                                         ; [07A1: 75 09]
    MOV     SI, 0032                                         ; [07A3: BE 32 00]
    MOV     CX, 0036                                         ; [07A6: B9 36 00]
    JMPN    loc_07b2                                         ; [07A9: E9 06 00]
loc_07ac:
    MOV     SI, 0068                                         ; [07AC: BE 68 00]
    MOV     CX, 0036                                         ; [07AF: B9 36 00]
loc_07b2:
    CLD                                                      ; [07B2: FC]
    JMPS    loc_07b5                                         ; [07B3: EB 00]
loc_07b5:
    REP MOVSB                                                ; [07B5: F3 A4]
    MOV     CX, 0002                                         ; [07B7: B9 02 00]
    MOV     BP, SP                                           ; [07BA: 8B EC]
    MOV     AX, WORD [BP+02]                                 ; [07BC: 8B 46 02]
    TEST    AX, 0200                                         ; [07BF: A9 00 02]
    JZ      loc_07e7                                         ; [07C2: 74 23]
    MOV     AX, [CS:ram_segment_base]                        ; [07C4: 2E A1 02 00]
    MOV     ES, AX                                           ; [07C8: 8E C0]
    MOV     DI, 0058                                         ; [07CA: BF 58 00]
    MOV     BX, WORD [ES:DI]                                 ; [07CD: 26 8B 1D]
    MOV     DX, WORD [ES:DI+02]                              ; [07D0: 26 8B 55 02]
    MOV     ES, DX                                           ; [07D4: 8E C2]
loc_07d6:
    MOV     BYTE [ES:BX+01], 05                              ; [07D6: 26 C6 47 01 05]
    MOV     WORD [ES:BX+0E], 2000                            ; [07DB: 26 C7 47 0E 00 20]
    MOV     WORD [ES:BX+10], 000D                            ; [07E1: 26 C7 47 10 0D 00]
loc_07e7:
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [07E7: B8 00 30]
    MOV     ES, AX                                           ; [07EA: 8E C0]
    MOV     BX, 2000                                         ; [07EC: BB 00 20]
    LOOP    loc_07d6                                         ; [07EF: E2 E5]
    MOV     AX, CRT_VRAM_SEGMENT                             ; [07F1: B8 00 D0]
    MOV     ES, AX                                           ; [07F4: 8E C0]
    MOV     DX, io_i82730_ca_pulse       ; Intel 82730 Channel Attention (CA pulse) ; [07F6: BA 40 02]
    OUT     DX, AX                                           ; [07F9: EF]
    MOV     BX, 2000                                         ; [07FA: BB 00 20]
loc_07fd:
    MOV     AL, 01                                           ; [07FD: B0 01]
    LOCK XCHG BYTE [ES:BX], AL                               ; [07FF: F0 26 86 07]
    CMP     AL, 01                                           ; [0803: 3C 01]
    JZ      loc_07fd                                         ; [0805: 74 F6]
    INC     BX                                               ; [0807: 43]
    MOV     BYTE [ES:BX], 06                                 ; [0808: 26 C6 07 06]
    MOV     DX, io_i82730_ca_pulse       ; Intel 82730 Channel Attention (CA pulse) ; [080C: BA 40 02]
    OUT     DX, AX                                           ; [080F: EF]
    DEC     BX                                               ; [0810: 4B]
loc_0811:
    MOV     AL, 01                                           ; [0811: B0 01]
    LOCK XCHG BYTE [ES:BX], AL                               ; [0813: F0 26 86 07]
    CMP     AL, 01                                           ; [0817: 3C 01]
    JZ      loc_0811                                         ; [0819: 74 F6]
    INC     BX                                               ; [081B: 43]
    MOV     BYTE [ES:BX], 01                                 ; [081C: 26 C6 07 01]
    MOV     DX, io_i82730_ca_pulse       ; Intel 82730 Channel Attention (CA pulse) ; [0820: BA 40 02]
    OUT     DX, AX                                           ; [0823: EF]
    POP     AX                                               ; [0824: 58]
    POP     BX                                               ; [0825: 5B]
    PUSH    BX                                               ; [0826: 53]
    PUSH    AX                                               ; [0827: 50]

; ----------------------------------------------------------------------------
; check_warm_boot_skip_memtest (ROM: 4068h, FB84:0828h)
; ----------------------------------------------------------------------------
check_warm_boot_skip_memtest:
    TEST    BX, 0200                                         ; [0828: F7 C3 00 02]
    JZ      delay_40k_and_show_banner                        ; [082C: 74 03]
    JMPN    skip_memtest_dest                                ; [082E: E9 1E 02]

; ----------------------------------------------------------------------------
; delay_40k_and_show_banner (ROM: 4071h, FB84:0831h)
; ----------------------------------------------------------------------------
delay_40k_and_show_banner:
    MOV     DX, io_kbd_data              ; Keyboard Data / Status register ; [0831: BA 20 00]
    IN      AL, DX                                           ; [0834: EC]
    MOV     AX, 9C40                                         ; [0835: B8 40 9C]
    CALL    busy_loop_delay_ax                               ; [0838: E8 83 03]
    MOV     AX, CRT_VRAM_SEGMENT                             ; [083B: B8 00 D0]
    MOV     DS, AX                                           ; [083E: 8E D8]
    MOV     DI, 3004                                         ; [0840: BF 04 30]
    MOV     AX, [CS:rom_segment_base]                        ; [0843: 2E A1 00 00]
    MOV     ES, AX                                           ; [0847: 8E C0]
    MOV     SI, 2379                                         ; [0849: BE 79 23]
    MOV     CX, 001D                                         ; [084C: B9 1D 00]
    XOR     AH, AH                                           ; [084F: 32 E4]
loc_0851:
    MOV     AL, BYTE [ES:SI]                                 ; [0851: 26 8A 04]
    MOV     WORD [DI], AX                                    ; [0854: 89 05]
    INC     SI                                               ; [0856: 46]
    INC     DI                                               ; [0857: 47]
    INC     DI                                               ; [0858: 47]
    LOOP    loc_0851                                         ; [0859: E2 F6]
    MOV     AX, [CS:ram_segment_base]                        ; [085B: 2E A1 02 00]
    MOV     DS, AX                                           ; [085F: 8E D8]
    CMP     BYTE [var_selftest_error_flags], 00 ; Selftest error flags buffer ; [0861: 80 3E 20 01 00]
    JZ      test_system_ram_start                            ; [0866: 74 03]
    JMPN    skip_memtest_dest                                ; [0868: E9 E4 01]

; ----------------------------------------------------------------------------
; test_system_ram_start (ROM: 40ABh, FB84:086Bh)
; ----------------------------------------------------------------------------
test_system_ram_start:
    STD                                                      ; [086B: FD]
    MOV     AX, 55AA                                         ; [086C: B8 AA 55]
    MOV     CL, 02                                           ; [086F: B1 02]
loc_0871:
    XCHG    CH, AL                                           ; [0871: 86 C5]
    MOV     DX, io_ppi_porta             ; 8255 PPI Port A (Memory size, Cassette, iSBX) ; [0873: BA 70 00]
    IN      AL, DX                                           ; [0876: EC]
    SHR     AL, 1                                            ; [0877: D0 E8]
    SHR     AL, 1                                            ; [0879: D0 E8]
    SHR     AL, 1                                            ; [087B: D0 E8]
    AND     AL, 06                                           ; [087D: 24 06]
    MOV     BX, 04C1                                         ; [087F: BB C1 04]
    ADD     BL, AL                                           ; [0882: 02 D8]
    MOV     DX, WORD [CS:BX+0000]                            ; [0884: 2E 8B 97 00 00]
    XCHG    CH, AL                                           ; [0889: 86 C5]
    MOV     ES, DX                                           ; [088B: 8E C2]
    MOV     DI, FFFF                                         ; [088D: BF FF FF]
    DEC     DI                                               ; [0890: 4F]
    MOV     BX, FFFE                                         ; [0891: BB FE FF]
    NOT     AX                                               ; [0894: F7 D0]

; ----------------------------------------------------------------------------
; ram_write_loop (ROM: 40D6h, FB84:0896h)
; ----------------------------------------------------------------------------
ram_write_loop:
    NOT     AX                                               ; [0896: F7 D0]
    STOSW                                                    ; [0898: AB]
    CMP     DI, BX                                           ; [0899: 3B FB]
    JZ      loc_08a9                                         ; [089B: 74 0C]
loc_089d:
    STOSW                                                    ; [089D: AB]
    CMP     DI, BX                                           ; [089E: 3B FB]
    JZ      loc_08c7                                         ; [08A0: 74 25]
loc_08a2:
    STOSW                                                    ; [08A2: AB]
    CMP     DI, BX                                           ; [08A3: 3B FB]
    JZ      loc_08e5                                         ; [08A5: 74 3E]
loc_08a7:
    JMPS    ram_write_loop                                   ; [08A7: EB ED]
loc_08a9:
    MOV     CH, AL                                           ; [08A9: 8A E8]
    MOV     AX, ES                                           ; [08AB: 8C C0]
    CMP     AX, 1000                                         ; [08AD: 3D 00 10]
    JNZ     loc_08b5                                         ; [08B0: 75 03]
    MOV     BX, 000A                                         ; [08B2: BB 0A 00]
loc_08b5:
    CMP     AX, 0000                                         ; [08B5: 3D 00 00]
    JZ      loc_0903                                         ; [08B8: 74 49]
    SUB     AX, 1000                                         ; [08BA: 2D 00 10]
    MOV     ES, AX                                           ; [08BD: 8E C0]
    MOV     AL, CH                                           ; [08BF: 8A C5]
    MOV     AH, AL                                           ; [08C1: 8A E0]
    NOT     AH                                               ; [08C3: F6 D4]
    JMPS    loc_089d                                         ; [08C5: EB D6]
loc_08c7:
    MOV     CH, AL                                           ; [08C7: 8A E8]
    MOV     AX, ES                                           ; [08C9: 8C C0]
    CMP     AX, 1000                                         ; [08CB: 3D 00 10]
    JNZ     loc_08d3                                         ; [08CE: 75 03]
    MOV     BX, 000A                                         ; [08D0: BB 0A 00]
loc_08d3:
    CMP     AX, 0000                                         ; [08D3: 3D 00 00]
    JZ      loc_0903                                         ; [08D6: 74 2B]
    SUB     AX, 1000                                         ; [08D8: 2D 00 10]
    MOV     ES, AX                                           ; [08DB: 8E C0]
    MOV     AL, CH                                           ; [08DD: 8A C5]
    MOV     AH, AL                                           ; [08DF: 8A E0]
    NOT     AH                                               ; [08E1: F6 D4]
    JMPS    loc_08a2                                         ; [08E3: EB BD]
loc_08e5:
    MOV     CH, AL                                           ; [08E5: 8A E8]
    MOV     AX, ES                                           ; [08E7: 8C C0]
    CMP     AX, 1000                                         ; [08E9: 3D 00 10]
    JNZ     loc_08f1                                         ; [08EC: 75 03]
    MOV     BX, 000A                                         ; [08EE: BB 0A 00]
loc_08f1:
    CMP     AX, 0000                                         ; [08F1: 3D 00 00]
    JZ      loc_0903                                         ; [08F4: 74 0D]
    SUB     AX, 1000                                         ; [08F6: 2D 00 10]
    MOV     ES, AX                                           ; [08F9: 8E C0]
    MOV     AL, CH                                           ; [08FB: 8A C5]
    MOV     AH, AL                                           ; [08FD: 8A E0]
    NOT     AH                                               ; [08FF: F6 D4]
    JMPS    loc_08a7                                         ; [0901: EB A4]
loc_0903:
    MOV     BX, FFFE                                         ; [0903: BB FE FF]
    MOV     DS, DX                                           ; [0906: 8E DA]
    MOV     SI, FFFF                                         ; [0908: BE FF FF]
    MOV     AX, 55AA                                         ; [090B: B8 AA 55]
    DEC     SI                                               ; [090E: 4E]
    CMP     CL, 02                                           ; [090F: 80 F9 02]
    JZ      loc_0916                                         ; [0912: 74 02]
    NOT     AX                                               ; [0914: F7 D0]
loc_0916:
    MOV     DX, AX                                           ; [0916: 8B D0]

; ----------------------------------------------------------------------------
; ram_verify_loop (ROM: 4158h, FB84:0918h)
; ----------------------------------------------------------------------------
ram_verify_loop:
    LODSW                                                    ; [0918: AD]
    CMP     AX, DX                                           ; [0919: 3B C2]
    JNZ     error_ram_memory                                 ; [091B: 75 6B]
    CMP     SI, BX                                           ; [091D: 3B F3]
    JZ      loc_0937                                         ; [091F: 74 16]
loc_0921:
    LODSW                                                    ; [0921: AD]
    CMP     AX, DX                                           ; [0922: 3B C2]
    JNZ     error_ram_memory                                 ; [0924: 75 62]
    CMP     SI, BX                                           ; [0926: 3B F3]
    JZ      loc_094d                                         ; [0928: 74 23]
loc_092a:
    LODSW                                                    ; [092A: AD]
    CMP     AX, DX                                           ; [092B: 3B C2]
    JNZ     error_ram_memory                                 ; [092D: 75 59]
    CMP     SI, BX                                           ; [092F: 3B F3]
    JZ      loc_0963                                         ; [0931: 74 30]
loc_0933:
    NOT     DX                                               ; [0933: F7 D2]
    JMPS    ram_verify_loop                                  ; [0935: EB E1]
loc_0937:
    MOV     AX, DS                                           ; [0937: 8C D8]
    CMP     AX, 1000                                         ; [0939: 3D 00 10]
    JNZ     loc_0941                                         ; [093C: 75 03]
    MOV     BX, 000A                                         ; [093E: BB 0A 00]
loc_0941:
    CMP     AX, 0000                                         ; [0941: 3D 00 00]
    JZ      loc_0979                                         ; [0944: 74 33]
    SUB     AX, 1000                                         ; [0946: 2D 00 10]
    MOV     DS, AX                                           ; [0949: 8E D8]
    JMPS    loc_0921                                         ; [094B: EB D4]
loc_094d:
    MOV     AX, DS                                           ; [094D: 8C D8]
    CMP     AX, 1000                                         ; [094F: 3D 00 10]
    JNZ     loc_0957                                         ; [0952: 75 03]
    MOV     BX, 000A                                         ; [0954: BB 0A 00]
loc_0957:
    CMP     AX, 0000                                         ; [0957: 3D 00 00]
    JZ      loc_0979                                         ; [095A: 74 1D]
    SUB     AX, 1000                                         ; [095C: 2D 00 10]
    MOV     DS, AX                                           ; [095F: 8E D8]
    JMPS    loc_092a                                         ; [0961: EB C7]
loc_0963:
    MOV     AX, DS                                           ; [0963: 8C D8]
    CMP     AX, 1000                                         ; [0965: 3D 00 10]
    JNZ     loc_096d                                         ; [0968: 75 03]
    MOV     BX, 000A                                         ; [096A: BB 0A 00]
loc_096d:
    CMP     AX, 0000                                         ; [096D: 3D 00 00]
    JZ      loc_0979                                         ; [0970: 74 07]
    SUB     AX, 1000                                         ; [0972: 2D 00 10]
    MOV     DS, AX                                           ; [0975: 8E D8]
    JMPS    loc_0933                                         ; [0977: EB BA]
loc_0979:
    DEC     CL                                               ; [0979: FE C9]
    CMP     CL, 00                                           ; [097B: 80 F9 00]
    JZ      ram_test_passed                                  ; [097E: 74 0C]
    MOV     AX, 55AA                                         ; [0980: B8 AA 55]
    NOT     AX                                               ; [0983: F7 D0]
    JMPN    loc_0871                                         ; [0985: E9 E9 FE]

; ----------------------------------------------------------------------------
; error_ram_memory (ROM: 41C8h, FB84:0988h)
; ----------------------------------------------------------------------------
error_ram_memory:
    INC     SI                                               ; [0988: 46]
    INC     SI                                               ; [0989: 46]
    JMPS    loc_0991                                         ; [098A: EB 05]

; ----------------------------------------------------------------------------
; ram_test_passed (ROM: 41CCh, FB84:098Ch)
; ----------------------------------------------------------------------------
ram_test_passed:
    MOV     AL, 00                                           ; [098C: B0 00]
    JMPN    post_ram_test_return                             ; [098E: E9 B3 00]
loc_0991:
    PUSH    AX                                               ; [0991: 50]
    PUSH    DX                                               ; [0992: 52]
    PUSH    SI                                               ; [0993: 56]
    PUSH    DS                                               ; [0994: 1E]
    MOV     AX, [CS:rom_segment_base]                        ; [0995: 2E A1 00 00]
    MOV     DS, AX                                           ; [0999: 8E D8]
    MOV     BX, 21E9                                         ; [099B: BB E9 21]
    MOV     CX, 0011                                         ; [099E: B9 11 00]
loc_09a1:
    MOV     AL, BYTE [BX]                                    ; [09A1: 8A 07]
    CALL    char_out_helper                                  ; [09A3: E8 E1 F7]
    INC     BX                                               ; [09A6: 43]
    LOOP    loc_09a1                                         ; [09A7: E2 F8]
    MOV     BX, 23CD                                         ; [09A9: BB CD 23]
    MOV     CX, 0008                                         ; [09AC: B9 08 00]
loc_09af:
    MOV     AL, BYTE [BX]                                    ; [09AF: 8A 07]
    CALL    char_out_helper                                  ; [09B1: E8 D3 F7]
    INC     BX                                               ; [09B4: 43]
    LOOP    loc_09af                                         ; [09B5: E2 F8]
    POP     CX                                               ; [09B7: 59]
    MOV     AX, [CS:ram_segment_base]                        ; [09B8: 2E A1 02 00]
    MOV     DS, AX                                           ; [09BC: 8E D8]
    MOV     WORD [var_selftest_loop_count], CX               ; [09BE: 89 0E 27 01]
    MOV     AX, [CS:rom_segment_base]                        ; [09C2: 2E A1 00 00]
    MOV     DS, AX                                           ; [09C6: 8E D8]
    MOV     DI, 09CE                                         ; [09C8: BF CE 09]
    JMPN    loc_013f                                         ; [09CB: E9 71 F7]
    MOV     AL, 3A                                           ; [09CE: B0 3A]
    CALL    char_out_helper                                  ; [09D0: E8 B4 F7]
    POP     CX                                               ; [09D3: 59]
    MOV     AX, [CS:ram_segment_base]                        ; [09D4: 2E A1 02 00]
    MOV     DS, AX                                           ; [09D8: 8E D8]
    MOV     WORD [var_selftest_error_subcode], CX            ; [09DA: 89 0E 21 01]
    MOV     AX, [CS:rom_segment_base]                        ; [09DE: 2E A1 00 00]
    MOV     DS, AX                                           ; [09E2: 8E D8]
    MOV     DI, 09EA                                         ; [09E4: BF EA 09]
    JMPN    loc_013f                                         ; [09E7: E9 55 F7]
    MOV     BX, 23D5                                         ; [09EA: BB D5 23]
    MOV     CX, 0008                                         ; [09ED: B9 08 00]
loc_09f0:
    MOV     AL, BYTE [BX]                                    ; [09F0: 8A 07]
    CALL    char_out_helper                                  ; [09F2: E8 92 F7]
    INC     BX                                               ; [09F5: 43]
    LOOP    loc_09f0                                         ; [09F6: E2 F8]
    POP     CX                                               ; [09F8: 59]
    MOV     AX, [CS:ram_segment_base]                        ; [09F9: 2E A1 02 00]
    MOV     DS, AX                                           ; [09FD: 8E D8]
    MOV     WORD [var_selftest_error_count], CX              ; [09FF: 89 0E 23 01]
    MOV     AX, [CS:rom_segment_base]                        ; [0A03: 2E A1 00 00]
    MOV     DS, AX                                           ; [0A07: 8E D8]
    MOV     DI, 0A0F                                         ; [0A09: BF 0F 0A]
    JMPN    loc_013f                                         ; [0A0C: E9 30 F7]
    MOV     BX, 23DD                                         ; [0A0F: BB DD 23]
    MOV     CX, 0008                                         ; [0A12: B9 08 00]
loc_0a15:
    MOV     AL, BYTE [BX]                                    ; [0A15: 8A 07]
    CALL    char_out_helper                                  ; [0A17: E8 6D F7]
    INC     BX                                               ; [0A1A: 43]
    LOOP    loc_0a15                                         ; [0A1B: E2 F8]
    POP     CX                                               ; [0A1D: 59]
    MOV     AX, [CS:ram_segment_base]                        ; [0A1E: 2E A1 02 00]
    MOV     DS, AX                                           ; [0A22: 8E D8]
    MOV     WORD [var_selftest_failing_dev], CX              ; [0A24: 89 0E 25 01]
    MOV     AX, [CS:rom_segment_base]                        ; [0A28: 2E A1 00 00]
    MOV     DS, AX                                           ; [0A2C: 8E D8]
    MOV     DI, 0A34                                         ; [0A2E: BF 34 0A]
    JMPN    loc_013f                                         ; [0A31: E9 0B F7]
    MOV     BX, 23BD                                         ; [0A34: BB BD 23]
    MOV     CX, 0002                                         ; [0A37: B9 02 00]
loc_0a3a:
    MOV     AL, BYTE [BX]                                    ; [0A3A: 8A 07]
    CALL    char_out_helper                                  ; [0A3C: E8 48 F7]
    INC     BX                                               ; [0A3F: 43]
    LOOP    loc_0a3a                                         ; [0A40: E2 F8]
    MOV     AL, 02                                           ; [0A42: B0 02]

; ----------------------------------------------------------------------------
; post_ram_test_return (ROM: 4284h, FB84:0A44h)
; ----------------------------------------------------------------------------
post_ram_test_return:
    PUSH    AX                                               ; [0A44: 50]
    MOV     AX, [CS:ram_segment_base]                        ; [0A45: 2E A1 02 00]
    MOV     DS, AX                                           ; [0A49: 8E D8]
    POP     AX                                               ; [0A4B: 58]
    MOV     [var_selftest_error_flags], AL ; Selftest error flags buffer ; [0A4C: A2 20 01]

; ----------------------------------------------------------------------------
; skip_memtest_dest (ROM: 428Fh, FB84:0A4Fh)
; ----------------------------------------------------------------------------
skip_memtest_dest:
    MOV     AX, [CS:ram_segment_base]                        ; [0A4F: 2E A1 02 00]
    MOV     DS, AX                                           ; [0A53: 8E D8]
    POP     AX                                               ; [0A55: 58]
    MOV     [var_kbd_shift_state], AX                        ; [0A56: A3 30 01]
    POP     AX                                               ; [0A59: 58]
    MOV     [var_boot_status_flags], AX  ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [0A5A: A3 2D 01]
    JMPN    init_video_buffers_and_selftest                  ; [0A5D: E9 77 01]

; ----------------------------------------------------------------------------
; isr_82730_command_done (ROM: 42A0h, FB84:0A60h)
; ----------------------------------------------------------------------------
isr_82730_command_done:
    PUSH    AX                                               ; [0A60: 50]
    PUSH    BX                                               ; [0A61: 53]
    PUSH    DX                                               ; [0A62: 52]
    PUSH    SI                                               ; [0A63: 56]
    PUSH    ES                                               ; [0A64: 06]
    PUSH    DS                                               ; [0A65: 1E]
    MOV     AX, [CS:ram_segment_base]                        ; [0A66: 2E A1 02 00]
    MOV     DS, AX                                           ; [0A6A: 8E D8]
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [0A6C: B8 00 30]
    MOV     ES, AX                                           ; [0A6F: 8E C0]
    MOV     BX, 2000                                         ; [0A71: BB 00 20]
loc_0a74:
    MOV     AL, 01                                           ; [0A74: B0 01]
    LOCK XCHG BYTE [ES:BX], AL                               ; [0A76: F0 26 86 07]
    CMP     AL, 01                                           ; [0A7A: 3C 01]
    JZ      loc_0a74                                         ; [0A7C: 74 F6]
    INC     BX                                               ; [0A7E: 43]
    MOV     BYTE [ES:BX], 08                                 ; [0A7F: 26 C6 07 08]
    MOV     DX, io_i82730_ca_pulse       ; Intel 82730 Channel Attention (CA pulse) ; [0A83: BA 40 02]
    OUT     DX, AX                                           ; [0A86: EF]
    DEC     BX                                               ; [0A87: 4B]
    MOV     SI, 0014                                         ; [0A88: BE 14 00]
    MOV     AX, WORD [ES:BX+SI]                              ; [0A8B: 26 8B 00]
    TEST    AX, 0065                                         ; [0A8E: A9 65 00]
    JNZ     loc_0a9c                                         ; [0A91: 75 09]
    MOV     AX, [var_timer0_tick_count]  ; Timer 0 tick counter (incremented by timer ISR) ; [0A93: A1 35 01]
    INC     AX                                               ; [0A96: 40]
    MOV     [var_timer0_tick_count], AX  ; Timer 0 tick counter (incremented by timer ISR) ; [0A97: A3 35 01]
    JMPS    loc_0aa4                                         ; [0A9A: EB 08]
loc_0a9c:
    MOV     [var_selftest_failing_dev], AX                   ; [0A9C: A3 25 01]
    MOV     BYTE [var_selftest_error_flags], 10 ; Selftest error flags buffer ; [0A9F: C6 06 20 01 10]
loc_0aa4:
    MOV     DX, io_i82730_reset          ; Intel 82730 CRT Text Coprocessor Reset (IRST) ; [0AA4: BA 30 02]
    OUT     DX, AX                                           ; [0AA7: EF]
    CALL    issue_82730_channel_attention                    ; [0AA8: E8 3A 00]
    MOV     [var_boot_countdown_sec], AX                     ; [0AAB: A3 39 01]
    POP     DS                                               ; [0AAE: 1F]
    POP     ES                                               ; [0AAF: 07]
    POP     SI                                               ; [0AB0: 5E]
    POP     DX                                               ; [0AB1: 5A]
    POP     BX                                               ; [0AB2: 5B]
    POP     AX                                               ; [0AB3: 58]
    IRET                                                     ; [0AB4: CF]
    MOV     BYTE [var_selftest_error_flags], 08 ; Selftest error flags buffer ; [0AB5: C6 06 20 01 08]
    IRET                                                     ; [0ABA: CF]
    PUSH    AX                                               ; [0ABB: 50]
    CALL    issue_82730_channel_attention                    ; [0ABC: E8 26 00]
    POP     AX                                               ; [0ABF: 58]
    IRET                                                     ; [0AC0: CF]
    PUSH    AX                                               ; [0AC1: 50]
    PUSH    CX                                               ; [0AC2: 51]
    MOV     CX, 0002                                         ; [0AC3: B9 02 00]
loc_0ac6:
    MOV     AX, 03E8                                         ; [0AC6: B8 E8 03]
    CALL    sub_049a                                         ; [0AC9: E8 CE F9]
    MOV     AX, C350                                         ; [0ACC: B8 50 C3]
    CALL    busy_loop_delay_ax                               ; [0ACF: E8 EC 00]
    LOOP    loc_0ac6                                         ; [0AD2: E2 F2]
    POP     CX                                               ; [0AD4: 59]
    POP     AX                                               ; [0AD5: 58]
    IRET                                                     ; [0AD6: CF]
    PUSH    AX                                               ; [0AD7: 50]
    CALL    issue_82730_channel_attention                    ; [0AD8: E8 0A 00]
    MOV     [var_selftest_error_subcode], AX                 ; [0ADB: A3 21 01]
    MOV     BYTE [var_selftest_error_flags], 05 ; Selftest error flags buffer ; [0ADE: C6 06 20 01 05]
    POP     AX                                               ; [0AE3: 58]
    IRET                                                     ; [0AE4: CF]

; ----------------------------------------------------------------------------
; issue_82730_channel_attention (ROM: 4325h, FB84:0AE5h)
; ----------------------------------------------------------------------------
issue_82730_channel_attention:
    PUSH    CX                                               ; [0AE5: 51]
    PUSH    DX                                               ; [0AE6: 52]
    MOV     DX, io_pic_icw1              ; 8259A PIC ICW1 (Base port 00h) ; [0AE7: BA 00 00]
    MOV     AL, 0B                                           ; [0AEA: B0 0B]
    OUT     DX, AL                                           ; [0AEC: EE]
    IN      AL, DX                                           ; [0AED: EC]
    MOV     AH, FF                                           ; [0AEE: B4 FF]
loc_0af0:
    INC     AH                                               ; [0AF0: FE C4]
    CMP     AH, 08                                           ; [0AF2: 80 FC 08]
    JZ      loc_0b07                                         ; [0AF5: 74 10]
    SHR     AL, 1                                            ; [0AF7: D0 E8]
    JNC     loc_0af0                                         ; [0AF9: 73 F5]
    MOV     CH, 00                                           ; [0AFB: B5 00]
    MOV     CL, AH                                           ; [0AFD: 8A CC]
    ADD     CL, 20                                           ; [0AFF: 80 C1 20]
    MOV     AL, 20                                           ; [0B02: B0 20]
    OUT     DX, AL                                           ; [0B04: EE]
    JMPS    loc_0b1f                                         ; [0B05: EB 18]
loc_0b07:
    MOV     DX, FF2C                                         ; [0B07: BA 2C FF]
    IN      AX, DX                                           ; [0B0A: ED]
    MOV     AH, FF                                           ; [0B0B: B4 FF]
loc_0b0d:
    INC     AH                                               ; [0B0D: FE C4]
    CMP     AH, 08                                           ; [0B0F: 80 FC 08]
    JZ      loc_0b18                                         ; [0B12: 74 04]
    SHR     AL, 1                                            ; [0B14: D0 E8]
    JNC     loc_0b0d                                         ; [0B16: 73 F5]
loc_0b18:
    MOV     CH, 00                                           ; [0B18: B5 00]
    MOV     CL, AH                                           ; [0B1A: 8A CC]
    ADD     CL, 08                                           ; [0B1C: 80 C1 08]
loc_0b1f:
    MOV     DX, io_i186_eoi              ; 80186 INTC End-Of-Interrupt (EOI) register ; [0B1F: BA 22 FF]
    MOV     AX, 8000                                         ; [0B22: B8 00 80]
    OUT     DX, AX                                           ; [0B25: EF]
    POP     DX                                               ; [0B26: 5A]
    MOV     AX, CX                                           ; [0B27: 8B C1]
    POP     CX                                               ; [0B29: 59]
    RETN                                                     ; [0B2A: C3]

; ----------------------------------------------------------------------------
; setup_interrupt_vectors (ROM: 436Bh, FB84:0B2Bh)
; ----------------------------------------------------------------------------
setup_interrupt_vectors:
    PUSH    AX                                               ; [0B2B: 50]
    PUSH    CX                                               ; [0B2C: 51]
    PUSH    SI                                               ; [0B2D: 56]
    PUSH    DI                                               ; [0B2E: 57]
    PUSH    DS                                               ; [0B2F: 1E]
    PUSH    ES                                               ; [0B30: 06]
    MOV     AX, [CS:rom_segment_base]                        ; [0B31: 2E A1 00 00]
    MOV     DS, AX                                           ; [0B35: 8E D8]
    CLD                                                      ; [0B37: FC]
    MOV     SI, 2248                                         ; [0B38: BE 48 22]
    MOV     DI, 0000                                         ; [0B3B: BF 00 00]
    MOV     ES, DI                                           ; [0B3E: 8E C7]
    MOV     CX, 0050                                         ; [0B40: B9 50 00]
    JMPS    loc_0b45                                         ; [0B43: EB 00]
loc_0b45:
    REP MOVSB                                                ; [0B45: F3 A4]
    MOV     SI, 2298                                         ; [0B47: BE 98 22]
    MOV     DI, 0080                                         ; [0B4A: BF 80 00]
    MOV     CX, 0020                                         ; [0B4D: B9 20 00]
    JMPS    loc_0b52                                         ; [0B50: EB 00]
loc_0b52:
    REP MOVSB                                                ; [0B52: F3 A4]
    POP     ES                                               ; [0B54: 07]
    POP     DS                                               ; [0B55: 1F]
    POP     DI                                               ; [0B56: 5F]
    POP     SI                                               ; [0B57: 5E]
    POP     CX                                               ; [0B58: 59]
    POP     AX                                               ; [0B59: 58]
    RETN                                                     ; [0B5A: C3]

; ----------------------------------------------------------------------------
; clear_memory_words (ROM: 439Bh, FB84:0B5Bh)
; ----------------------------------------------------------------------------
clear_memory_words:
    PUSH    ES                                               ; [0B5B: 06]
    PUSH    DI                                               ; [0B5C: 57]
    CLD                                                      ; [0B5D: FC]
    MOV     DI, AX                                           ; [0B5E: 8B F8]
    MOV     AX, [CS:ram_segment_base]                        ; [0B60: 2E A1 02 00]
    MOV     ES, AX                                           ; [0B64: 8E C0]
    XOR     AX, AX                                           ; [0B66: 33 C0]
loc_0b68:
    STOSW                                                    ; [0B68: AB]
    INC     AX                                               ; [0B69: 40]
    LOOP    loc_0b68                                         ; [0B6A: E2 FC]
    POP     DI                                               ; [0B6C: 5F]
    POP     ES                                               ; [0B6D: 07]
    RETN                                                     ; [0B6E: C3]
sub_0b6f:
    PUSH    ES                                               ; [0B6F: 06]
    PUSH    DI                                               ; [0B70: 57]
    CLD                                                      ; [0B71: FC]
    MOV     DI, AX                                           ; [0B72: 8B F8]
    MOV     AX, [CS:ram_segment_base]                        ; [0B74: 2E A1 02 00]
    MOV     ES, AX                                           ; [0B78: 8E C0]
    XOR     AX, AX                                           ; [0B7A: 33 C0]
    REP STOSW                                                ; [0B7C: F3 AB]
    POP     DI                                               ; [0B7E: 5F]
    POP     ES                                               ; [0B7F: 07]
    RETN                                                     ; [0B80: C3]
sub_0b81:
    PUSH    DI                                               ; [0B81: 57]
    PUSH    SI                                               ; [0B82: 56]
    MOV     SI, AX                                           ; [0B83: 8B F0]
    MOV     DI, BX                                           ; [0B85: 8B FB]
    PUSH    ES                                               ; [0B87: 06]
    MOV     AL, 00                                           ; [0B88: B0 00]
    TEST    WORD [var_boot_status_flags], 0400 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [0B8A: F7 06 2D 01 00 04]
    JNZ     loc_0bba                                         ; [0B90: 75 28]
    MOV     AX, [CS:ram_segment_base]                        ; [0B92: 2E A1 02 00]
    MOV     ES, AX                                           ; [0B96: 8E C0]
    CLD                                                      ; [0B98: FC]
    REP CMPSW                                                ; [0B99: F3 A7]
    MOV     AL, 00                                           ; [0B9B: B0 00]
    CMP     CX, +00                                          ; [0B9D: 83 F9 00]
    JZ      loc_0bba                                         ; [0BA0: 74 18]
    SUB     DI, +02                                          ; [0BA2: 83 EF 02]
    SUB     SI, +02                                          ; [0BA5: 83 EE 02]
    MOV     AX, WORD [DI]                                    ; [0BA8: 8B 05]
    MOV     [var_selftest_failing_dev], AX                   ; [0BAA: A3 25 01]
    MOV     AX, WORD [SI]                                    ; [0BAD: 8B 04]
    MOV     [var_selftest_error_count], AX                   ; [0BAF: A3 23 01]
    SUB     DI, BX                                           ; [0BB2: 2B FB]
    MOV     WORD [var_selftest_error_subcode], DI            ; [0BB4: 89 3E 21 01]
    MOV     AL, FF                                           ; [0BB8: B0 FF]
loc_0bba:
    POP     ES                                               ; [0BBA: 07]
    POP     SI                                               ; [0BBB: 5E]
    POP     DI                                               ; [0BBC: 5F]
    RETN                                                     ; [0BBD: C3]

; ----------------------------------------------------------------------------
; busy_loop_delay_ax (ROM: 43FEh, FB84:0BBEh)
; ----------------------------------------------------------------------------
busy_loop_delay_ax:
    PUSH    CX                                               ; [0BBE: 51]
loc_0bbf:
    MOV     CL, F0                                           ; [0BBF: B1 F0]
    SHR     CL, CL                                           ; [0BC1: D2 E9]
    DEC     AX                                               ; [0BC3: 48]
    JNZ     loc_0bbf                                         ; [0BC4: 75 F9]
    POP     CX                                               ; [0BC6: 59]
    RETN                                                     ; [0BC7: C3]

; ----------------------------------------------------------------------------
; timer_tick_wait_ax (ROM: 4408h, FB84:0BC8h)
; ----------------------------------------------------------------------------
timer_tick_wait_ax:
    MOV     WORD [var_timer0_tick_count], 0000 ; Timer 0 tick counter (incremented by timer ISR) ; [0BC8: C7 06 35 01 00 00]
    STI                                                      ; [0BCE: FB]
loc_0bcf:
    CMP     AX, WORD [var_timer0_tick_count] ; Timer 0 tick counter (incremented by timer ISR) ; [0BCF: 3B 06 35 01]
    JA      loc_0bcf                                         ; [0BD3: 77 FA]
    CLI                                                      ; [0BD5: FA]
    RETN                                                     ; [0BD6: C3]

; ----------------------------------------------------------------------------
; init_video_buffers_and_selftest (ROM: 4417h, FB84:0BD7h)
; ----------------------------------------------------------------------------
init_video_buffers_and_selftest:
    CLI                                                      ; [0BD7: FA]
    MOV     AX, 1000                                         ; [0BD8: B8 00 10]
    MOV     SS, AX                                           ; [0BDB: 8E D0]
    MOV     SP, 0320                                         ; [0BDD: BC 20 03]
    MOV     BP, SP                                           ; [0BE0: 8B EC]
    MOV     AX, CRT_VRAM_SEGMENT                             ; [0BE2: B8 00 D0]
    MOV     DS, AX                                           ; [0BE5: 8E D8]
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [0BE7: B8 00 30]
    MOV     ES, AX                                           ; [0BEA: 8E C0]
    MOV     SI, 2000                                         ; [0BEC: BE 00 20]
    MOV     DI, 2000                                         ; [0BEF: BF 00 20]
    MOV     CX, 2000                                         ; [0BF2: B9 00 20]
    CLD                                                      ; [0BF5: FC]
    JMPS    loc_0bf8                                         ; [0BF6: EB 00]
loc_0bf8:
    REP MOVSW                                                ; [0BF8: F3 A5]
    MOV     AX, CRT_VRAM_SEGMENT                             ; [0BFA: B8 00 D0]
    MOV     ES, AX                                           ; [0BFD: 8E C0]
    MOV     BX, 2000                                         ; [0BFF: BB 00 20]
loc_0c02:
    MOV     AL, 01                                           ; [0C02: B0 01]
    LOCK XCHG BYTE [ES:BX], AL                               ; [0C04: F0 26 86 07]
    CMP     AL, 01                                           ; [0C08: 3C 01]
    JZ      loc_0c02                                         ; [0C0A: 74 F6]
    MOV     BYTE [ES:BX+01], 03                              ; [0C0C: 26 C6 47 01 03]
    MOV     DX, io_i82730_ca_pulse       ; Intel 82730 Channel Attention (CA pulse) ; [0C11: BA 40 02]
    OUT     DX, AX                                           ; [0C14: EF]
    MOV     AX, CRT_VRAM_SEGMENT                             ; [0C15: B8 00 D0]
    MOV     ES, AX                                           ; [0C18: 8E C0]
    MOV     DI, 0000                                         ; [0C1A: BF 00 00]
    MOV     CX, 1000                                         ; [0C1D: B9 00 10]
    MOV     DX, io_ppi_portb             ; 8255 PPI Port B (Monitor type 50/60Hz, RTC type) ; [0C20: BA 72 00]
    IN      AL, DX                                           ; [0C23: EC]
    AND     AL, 40                                           ; [0C24: 24 40]
    JNZ     loc_0c2c                                         ; [0C26: 75 04]
    MOV     BL, FF                                           ; [0C28: B3 FF]
    JMPS    loc_0c31                                         ; [0C2A: EB 05]
loc_0c2c:
    MOV     BL, 3F                                           ; [0C2C: B3 3F]
    MOV     CX, 0800                                         ; [0C2E: B9 00 08]
loc_0c31:
    MOV     AX, WORD [ES:DI]                                 ; [0C31: 26 8B 05]
    MOV     AL, BL                                           ; [0C34: 8A C3]
    MOV     WORD [ES:DI], AX                                 ; [0C36: 26 89 05]
    INC     DI                                               ; [0C39: 47]
    INC     DI                                               ; [0C3A: 47]
    LOOP    loc_0c31                                         ; [0C3B: E2 F4]
    IN      AL, DX                                           ; [0C3D: EC]
    AND     AL, 40                                           ; [0C3E: 24 40]
    JZ      loc_0c4b                                         ; [0C40: 74 09]
    MOV     DI, 0BF8                                         ; [0C42: BF F8 0B]
    MOV     AX, FFBF                                         ; [0C45: B8 BF FF]
    MOV     WORD [ES:DI], AX                                 ; [0C48: 26 89 05]
loc_0c4b:
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [0C4B: B8 00 30]
    MOV     DS, AX                                           ; [0C4E: 8E D8]
    MOV     BX, 2000                                         ; [0C50: BB 00 20]
    MOV     AX, 0003                                         ; [0C53: B8 03 00]
    MOV     WORD [BX+08], AX                                 ; [0C56: 89 47 08]
    MOV     WORD [BX+0C], AX                                 ; [0C59: 89 47 0C]
    MOV     WORD [BX+10], AX                                 ; [0C5C: 89 47 10]
    MOV     WORD [BX+20], AX                                 ; [0C5F: 89 47 20]
    MOV     WORD [BX+24], AX                                 ; [0C62: 89 47 24]
    ADD     BX, +54                                          ; [0C65: 83 C3 54]
    MOV     WORD [BX+02], AX                                 ; [0C68: 89 47 02]
    MOV     WORD [BX+06], AX                                 ; [0C6B: 89 47 06]
    MOV     BX, 2000                                         ; [0C6E: BB 00 20]
    MOV     WORD [ES:BX+10], AX                              ; [0C71: 26 89 47 10]
loc_0c75:
    MOV     AL, 01                                           ; [0C75: B0 01]
    LOCK XCHG BYTE [ES:BX], AL                               ; [0C77: F0 26 86 07]
    CMP     AL, 01                                           ; [0C7B: 3C 01]
    JZ      loc_0c75                                         ; [0C7D: 74 F6]
    MOV     BYTE [ES:BX+01], 05                              ; [0C7F: 26 C6 47 01 05]
    MOV     DX, io_i82730_ca_pulse       ; Intel 82730 Channel Attention (CA pulse) ; [0C84: BA 40 02]
    OUT     DX, AX                                           ; [0C87: EF]
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [0C88: B8 00 30]
    MOV     ES, AX                                           ; [0C8B: 8E C0]
loc_0c8d:
    MOV     AL, 01                                           ; [0C8D: B0 01]
    LOCK XCHG BYTE [ES:BX], AL                               ; [0C8F: F0 26 86 07]
    CMP     AL, 01                                           ; [0C93: 3C 01]
    JZ      loc_0c8d                                         ; [0C95: 74 F6]
    MOV     BYTE [ES:BX+01], 01                              ; [0C97: 26 C6 47 01 01]
    MOV     DX, io_i82730_ca_pulse       ; Intel 82730 Channel Attention (CA pulse) ; [0C9C: BA 40 02]
    OUT     DX, AX                                           ; [0C9F: EF]
    MOV     AX, [CS:ram_segment_base]                        ; [0CA0: 2E A1 02 00]
    MOV     DS, AX                                           ; [0CA4: 8E D8]
    MOV     AX, [CS:rom_segment_base]                        ; [0CA6: 2E A1 00 00]
    MOV     ES, AX                                           ; [0CAA: 8E C0]
    CALL    setup_interrupt_vectors                          ; [0CAC: E8 7C FE]
    CALL    sub_11dd                                         ; [0CAF: E8 2B 05]
    TEST    WORD [var_boot_status_flags], 0200 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [0CB2: F7 06 2D 01 00 02]
    JNZ     start_bootloader_sequence                        ; [0CB8: 75 6E]
    MOV     BYTE [var_kbd_ctrl_alt_state], 00 ; Keyboard modifier counter (Ctrl + Alt) ; [0CBA: C6 06 2F 01 00]
    MOV     BYTE [var_kbd_key_ready], 00 ; Keyboard event flag (FFh = key pressed) ; [0CBF: C6 06 32 01 00]
    MOV     BYTE [var_nvram_valid_magic], AA ; NVRAM Magic byte 0xAA validation ; [0CC4: C6 06 65 00 AA]
    MOV     AL, 00                                           ; [0CC9: B0 00]
    MOV     AH, 18                                           ; [0CCB: B4 18]
    CALL    set_cursor_pos                                   ; [0CCD: E8 A9 F5]
    MOV     AX, 2396                                         ; [0CD0: B8 96 23]
    MOV     CX, FFFF                                         ; [0CD3: B9 FF FF]
    CALL    print_string_es_ax                               ; [0CD6: E8 D3 F6]
    MOV     AX, 21FC                                         ; [0CD9: B8 FC 21]
    MOV     CX, 000D                                         ; [0CDC: B9 0D 00]
    CALL    print_string_es_ax                               ; [0CDF: E8 CA F6]
    CALL    clear_screen_or_cursor                           ; [0CE2: E8 DA F4]
    CALL    cursor_blink_handler                             ; [0CE5: E8 6C 06]
    MOV     AX, 0400                                         ; [0CE8: B8 00 04]
    MOV     CX, 1000                                         ; [0CEB: B9 00 10]
    CALL    clear_memory_words                               ; [0CEE: E8 6A FE]
    CALL    selftest_status_display                          ; [0CF1: E8 5B 07]
    MOV     AX, 0006                                         ; [0CF4: B8 06 00]
    CALL    timer_tick_wait_ax                               ; [0CF7: E8 CE FE]
    MOV     BYTE [var_selftest_error_flags], 00 ; Selftest error flags buffer ; [0CFA: C6 06 20 01 00]

; ----------------------------------------------------------------------------
; selftest_countdown_loop (ROM: 453Fh, FB84:0CFFh)
; ----------------------------------------------------------------------------
selftest_countdown_loop:
    STI                                                      ; [0CFF: FB]
    NOP                                                      ; [0D00: 90]
    CLI                                                      ; [0D01: FA]
    MOV     AX, [var_boot_status_flags]  ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [0D02: A1 2D 01]
    TEST    AX, 4000                                         ; [0D05: A9 00 40]
    JNZ     loc_0d43                                         ; [0D08: 75 39]
    INC     AL                                               ; [0D0A: FE C0]
    CMP     AL, 0B                                           ; [0D0C: 3C 0B]
    JC      loc_0d43                                         ; [0D0E: 72 33]
    TEST    AX, 1000                                         ; [0D10: A9 00 10]
    JNZ     start_bootloader_sequence                        ; [0D13: 75 13]
    MOV     DX, 000F                                         ; [0D15: BA 0F 00]
    CMP     AL, DL                                           ; [0D18: 3A C2]
    JC      loc_0d43                                         ; [0D1A: 72 27]
    XOR     AL, AL                                           ; [0D1C: 32 C0]
    PUSH    AX                                               ; [0D1E: 50]
    MOV     AX, 0078                                         ; [0D1F: B8 78 00]
    CALL    timer_tick_wait_ax                               ; [0D22: E8 A3 FE]
    POP     AX                                               ; [0D25: 58]
    JMPS    loc_0d43                                         ; [0D26: EB 1B]

; ----------------------------------------------------------------------------
; start_bootloader_sequence (ROM: 4568h, FB84:0D28h)
; ----------------------------------------------------------------------------
start_bootloader_sequence:
    MOV     AH, 01                                           ; [0D28: B4 01]
    MOV     AL, 15                                           ; [0D2A: B0 15]
    MOV     CL, FF                                           ; [0D2C: B1 FF]
    CALL    boot_setup_memory_params                         ; [0D2E: E8 0A 31]
    MOV     AX, 9000                                         ; [0D31: B8 00 90]
    OR      AX, 0100                                         ; [0D34: 0D 00 01]
    MOV     [var_boot_status_flags], AX  ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [0D37: A3 2D 01]
    CALL    clear_screen_or_cursor                           ; [0D3A: E8 82 F4]
    CALL    mute_sound_chip                                  ; [0D3D: E8 F6 06]
    JMPN    bootloader_main_entry                            ; [0D40: E9 BD 19]
loc_0d43:
    MOV     [var_boot_status_flags], AX  ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [0D43: A3 2D 01]
    CALL    selftest_check_keyboard                          ; [0D46: E8 C7 03]
    CALL    selftest_poll_devices                            ; [0D49: E8 24 07]
    CALL    cursor_blink_handler                             ; [0D4C: E8 05 06]
    JMPS    selftest_countdown_loop                          ; [0D4F: EB AE]

; ----------------------------------------------------------------------------
; ascii_hex_digits_table (ROM: 4591h, FB84:0D51h)
; ASCII heksadecimale cifre opslagstabel (FB84:0D8D, FB84:22EC)
; ----------------------------------------------------------------------------
ascii_hex_digits_table:
    DB  030h                    ; [0D51h] '0'
    DB  031h                    ; [0D52h] '1'
    DB  032h                    ; [0D53h] '2'
    DB  033h                    ; [0D54h] '3'
    DB  034h                    ; [0D55h] '4'
    DB  035h                    ; [0D56h] '5'
    DB  036h                    ; [0D57h] '6'
    DB  037h                    ; [0D58h] '7'
    DB  038h                    ; [0D59h] '8'
    DB  039h                    ; [0D5Ah] '9'
    DB  041h                    ; [0D5Bh] 'A'
    DB  042h                    ; [0D5Ch] 'B'
    DB  043h                    ; [0D5Dh] 'C'
    DB  044h                    ; [0D5Eh] 'D'
    DB  045h                    ; [0D5Fh] 'E'
    DB  046h                    ; [0D60h] 'F'
sub_0d61:
    PUSH    BX                                               ; [0D61: 53]
    PUSH    CX                                               ; [0D62: 51]
    PUSH    DX                                               ; [0D63: 52]
    PUSH    SI                                               ; [0D64: 56]
    MOV     DI, FFFF                                         ; [0D65: BF FF FF]
    MOV     CH, 04                                           ; [0D68: B5 04]
    MOV     CL, 04                                           ; [0D6A: B1 04]
    MOV     DX, io_pic_icw1              ; 8259A PIC ICW1 (Base port 00h) ; [0D6C: BA 00 00]
    MOV     BX, 0D51                                         ; [0D6F: BB 51 0D]
loc_0d72:
    PUSH    DX                                               ; [0D72: 52]
    CALL    read_key_poll                                    ; [0D73: E8 5D F6]
    MOV     SI, 0000                                         ; [0D76: BE 00 00]
    MOV     DL, 00                                           ; [0D79: B2 00]
    CMP     AL, 58                                           ; [0D7B: 3C 58]
    JNZ     loc_0d8d                                         ; [0D7D: 75 0E]
    POP     DX                                               ; [0D7F: 5A]
    SHR     DX, CL                                           ; [0D80: D3 EA]
    AND     DX, FFF0                                         ; [0D82: 81 E2 F0 FF]
    INC     CH                                               ; [0D86: FE C5]
    CALL    conout_char                                      ; [0D88: E8 0D F5]
    JMPS    loc_0d72                                         ; [0D8B: EB E5]
loc_0d8d:
    MOV     DH, BYTE [CS:BX+SI+0000]                         ; [0D8D: 2E 8A B0 00 00]
    CMP     AL, DH                                           ; [0D92: 3A C6]
    JZ      loc_0db0                                         ; [0D94: 74 1A]
    INC     SI                                               ; [0D96: 46]
    INC     DL                                               ; [0D97: FE C2]
    CMP     DL, 10                                           ; [0D99: 80 FA 10]
    JNZ     loc_0d8d                                         ; [0D9C: 75 EF]
    MOV     AH, CH                                           ; [0D9E: 8A E5]
    MOV     DI, AX                                           ; [0DA0: 8B F8]
    MOV     AL, 20                                           ; [0DA2: B0 20]
loc_0da4:
    CALL    conout_char                                      ; [0DA4: E8 F1 F4]
    DEC     CH                                               ; [0DA7: FE CD]
    JNZ     loc_0da4                                         ; [0DA9: 75 F9]
    POP     DX                                               ; [0DAB: 5A]
    SHR     DX, CL                                           ; [0DAC: D3 EA]
    JMPS    loc_0dc0                                         ; [0DAE: EB 10]
loc_0db0:
    CALL    conout_char                                      ; [0DB0: E8 E5 F4]
    MOV     AL, DL                                           ; [0DB3: 8A C2]
    POP     DX                                               ; [0DB5: 5A]
    ADD     DL, AL                                           ; [0DB6: 02 D0]
    DEC     CH                                               ; [0DB8: FE CD]
    JZ      loc_0dc0                                         ; [0DBA: 74 04]
    SHL     DX, CL                                           ; [0DBC: D3 E2]
    JMPS    loc_0d72                                         ; [0DBE: EB B2]
loc_0dc0:
    MOV     AX, DX                                           ; [0DC0: 8B C2]
    POP     SI                                               ; [0DC2: 5E]
    POP     DX                                               ; [0DC3: 5A]
    POP     CX                                               ; [0DC4: 59]
    POP     BX                                               ; [0DC5: 5B]
    RETN                                                     ; [0DC6: C3]
sub_0dc7:
    PUSH    DS                                               ; [0DC7: 1E]
    PUSH    AX                                               ; [0DC8: 50]
    PUSH    BX                                               ; [0DC9: 53]
    PUSH    CX                                               ; [0DCA: 51]
    PUSH    DX                                               ; [0DCB: 52]
    PUSH    SI                                               ; [0DCC: 56]
    PUSH    DI                                               ; [0DCD: 57]
    PUSH    BP                                               ; [0DCE: 55]
    MOV     AX, 22B8                                         ; [0DCF: B8 B8 22]
    MOV     CX, 000C                                         ; [0DD2: B9 0C 00]
    CALL    print_string_es_ax                               ; [0DD5: E8 D4 F5]
loc_0dd8:
    MOV     BX, 22D7                                         ; [0DD8: BB D7 22]
loc_0ddb:
    MOV     AL, BYTE [ES:BX]                                 ; [0DDB: 26 8A 07]
    CMP     AL, FF                                           ; [0DDE: 3C FF]
    JZ      loc_0de8                                         ; [0DE0: 74 06]
    CALL    conout_char                                      ; [0DE2: E8 B3 F4]
    INC     BX                                               ; [0DE5: 43]
    JMPS    loc_0ddb                                         ; [0DE6: EB F3]
loc_0de8:
    CALL    read_key_poll                                    ; [0DE8: E8 E8 F5]
    CALL    conout_char                                      ; [0DEB: E8 AA F4]
loc_0dee:
    MOV     SI, AX                                           ; [0DEE: 8B F0]
    CMP     AL, 4E                                           ; [0DF0: 3C 4E]
    JZ      loc_0e4f                                         ; [0DF2: 74 5B]
    CMP     AL, 4D                                           ; [0DF4: 3C 4D]
    JZ      loc_0e4f                                         ; [0DF6: 74 57]
    CMP     AL, 49                                           ; [0DF8: 3C 49]
    JZ      loc_0e07                                         ; [0DFA: 74 0B]
    CMP     AL, 4F                                           ; [0DFC: 3C 4F]
    JZ      loc_0e07                                         ; [0DFE: 74 07]
    CMP     AL, 58                                           ; [0E00: 3C 58]
    JNZ     loc_0dd8                                         ; [0E02: 75 D4]
    JMPN    loc_0f71                                         ; [0E04: E9 6A 01]
loc_0e07:
    CALL    wait_key_press                                   ; [0E07: E8 BF F5]
    MOV     AX, 2366                                         ; [0E0A: B8 66 23]
    MOV     CX, 0006                                         ; [0E0D: B9 06 00]
    CALL    print_string_es_ax                               ; [0E10: E8 99 F5]
    CALL    sub_0d61                                         ; [0E13: E8 4B FF]
    MOV     CX, DI                                           ; [0E16: 8B CF]
    CMP     CH, 04                                           ; [0E18: 80 FD 04]
    JZ      loc_0e4c                                         ; [0E1B: 74 2F]
    MOV     DX, AX                                           ; [0E1D: 8B D0]
    MOV     AX, 236C                                         ; [0E1F: B8 6C 23]
    MOV     CX, 0007                                         ; [0E22: B9 07 00]
    CALL    print_string_es_ax                               ; [0E25: E8 84 F5]
    MOV     AX, SI                                           ; [0E28: 8B C6]
    CMP     AL, 49                                           ; [0E2A: 3C 49]
    JZ      loc_0e3b                                         ; [0E2C: 74 0D]
    CALL    sub_0d61                                         ; [0E2E: E8 30 FF]
    MOV     CX, DI                                           ; [0E31: 8B CF]
    CMP     CH, 04                                           ; [0E33: 80 FD 04]
    JZ      loc_0e4c                                         ; [0E36: 74 14]
    OUT     DX, AX                                           ; [0E38: EF]
    JMPS    loc_0e3f                                         ; [0E39: EB 04]
loc_0e3b:
    IN      AX, DX                                           ; [0E3B: ED]
    CALL    sub_0345                                         ; [0E3C: E8 06 F5]
loc_0e3f:
    CALL    read_key_poll                                    ; [0E3F: E8 91 F5]
    CALL    conout_char                                      ; [0E42: E8 53 F4]
    CMP     AL, 2C                                           ; [0E45: 3C 2C]
    JZ      loc_0e07                                         ; [0E47: 74 BE]
    JMPN    loc_0dee                                         ; [0E49: E9 A2 FF]
loc_0e4c:
    JMPN    loc_0dd8                                         ; [0E4C: E9 89 FF]
loc_0e4f:
    CALL    wait_key_press                                   ; [0E4F: E8 77 F5]
    MOV     AX, 2373                                         ; [0E52: B8 73 23]
    MOV     CX, 0006                                         ; [0E55: B9 06 00]
    CALL    print_string_es_ax                               ; [0E58: E8 51 F5]
    CALL    sub_0d61                                         ; [0E5B: E8 03 FF]
    MOV     CX, DI                                           ; [0E5E: 8B CF]
    CMP     CH, 04                                           ; [0E60: 80 FD 04]
    JZ      loc_0e4c                                         ; [0E63: 74 E7]
    MOV     DS, AX                                           ; [0E65: 8E D8]
    MOV     AX, 23CD                                         ; [0E67: B8 CD 23]
    MOV     CX, 0008                                         ; [0E6A: B9 08 00]
    CALL    print_string_es_ax                               ; [0E6D: E8 3C F5]
    CALL    sub_0d61                                         ; [0E70: E8 EE FE]
    MOV     CX, DI                                           ; [0E73: 8B CF]
    CMP     CH, 04                                           ; [0E75: 80 FD 04]
    JZ      loc_0e4c                                         ; [0E78: 74 D2]
    MOV     BX, AX                                           ; [0E7A: 8B D8]
loc_0e7c:
    MOV     DH, 14                                           ; [0E7C: B6 14]
    CALL    wait_key_press                                   ; [0E7E: E8 48 F5]
loc_0e81:
    CALL    wait_key_press                                   ; [0E81: E8 45 F5]
    MOV     BP, 6400                                         ; [0E84: BD 00 64]
    MOV     AX, DS                                           ; [0E87: 8C D8]
    CALL    sub_0345                                         ; [0E89: E8 B9 F4]
    MOV     AL, 3A                                           ; [0E8C: B0 3A]
    CALL    conout_char                                      ; [0E8E: E8 07 F4]
    MOV     AX, BX                                           ; [0E91: 8B C3]
    CALL    sub_0345                                         ; [0E93: E8 AF F4]
    MOV     AL, 3D                                           ; [0E96: B0 3D]
    CALL    conout_char                                      ; [0E98: E8 FD F3]
    MOV     DL, 05                                           ; [0E9B: B2 05]
loc_0e9d:
    LOCK MOV AL, BYTE [BX]                                   ; [0E9D: F0 8A 07]
    LOCK MOV AL, BYTE [BX]                                   ; [0EA0: F0 8A 07]
    LOCK MOV AL, BYTE [BX]                                   ; [0EA3: F0 8A 07]
    LOCK MOV AH, BYTE [BX+01]                                ; [0EA6: F0 8A 67 01]
    LOCK MOV AH, BYTE [BX+01]                                ; [0EAA: F0 8A 67 01]
    LOCK MOV AH, BYTE [BX+01]                                ; [0EAE: F0 8A 67 01]
    PUSH    AX                                               ; [0EB2: 50]
    CALL    sub_0345                                         ; [0EB3: E8 8F F4]
    MOV     AL, 2F                                           ; [0EB6: B0 2F]
    CALL    conout_char                                      ; [0EB8: E8 DD F3]
    POP     AX                                               ; [0EBB: 58]
    CMP     AL, 7F                                           ; [0EBC: 3C 7F]
    JNC     loc_0ec4                                         ; [0EBE: 73 04]
    CMP     AL, 20                                           ; [0EC0: 3C 20]
    JNC     loc_0ec6                                         ; [0EC2: 73 02]
loc_0ec4:
    MOV     AL, 2E                                           ; [0EC4: B0 2E]
loc_0ec6:
    PUSH    DS                                               ; [0EC6: 1E]
    MOV     CX, WORD [CS:ram_segment_base]                   ; [0EC7: 2E 8B 0E 02 00]
    MOV     DS, CX                                           ; [0ECC: 8E D9]
    MOV     BYTE [DS:BP+00], AL                              ; [0ECE: 3E 88 46 00]
    INC     BP                                               ; [0ED2: 45]
    POP     DS                                               ; [0ED3: 1F]
    XCHG    AL, AH                                           ; [0ED4: 86 E0]
    CMP     AL, 7F                                           ; [0ED6: 3C 7F]
    JNC     loc_0ede                                         ; [0ED8: 73 04]
    CMP     AL, 20                                           ; [0EDA: 3C 20]
    JNC     loc_0ee0                                         ; [0EDC: 73 02]
loc_0ede:
    MOV     AL, 2E                                           ; [0EDE: B0 2E]
loc_0ee0:
    PUSH    DS                                               ; [0EE0: 1E]
    MOV     CX, WORD [CS:ram_segment_base]                   ; [0EE1: 2E 8B 0E 02 00]
    MOV     DS, CX                                           ; [0EE6: 8E D9]
    MOV     BYTE [DS:BP+00], AL                              ; [0EE8: 3E 88 46 00]
    INC     BP                                               ; [0EEC: 45]
    POP     DS                                               ; [0EED: 1F]
    MOV     AL, 20                                           ; [0EEE: B0 20]
    MOV     CX, 0006                                         ; [0EF0: B9 06 00]
loc_0ef3:
    CALL    conout_char                                      ; [0EF3: E8 A2 F3]
    MOV     AX, SI                                           ; [0EF6: 8B C6]
    CMP     AL, 4E                                           ; [0EF8: 3C 4E]
    JNZ     loc_0f29                                         ; [0EFA: 75 2D]
    CALL    sub_0d61                                         ; [0EFC: E8 62 FE]
    MOV     CX, DI                                           ; [0EFF: 8B CF]
    CMP     CH, 04                                           ; [0F01: 80 FD 04]
    JZ      loc_0f12                                         ; [0F04: 74 0C]
    LOCK MOV BYTE [BX], AL                                   ; [0F06: F0 88 07]
    LOCK MOV BYTE [BX+01], AH                                ; [0F09: F0 88 67 01]
    CMP     CL, FF                                           ; [0F0D: 80 F9 FF]
    JZ      loc_0f18                                         ; [0F10: 74 06]
loc_0f12:
    MOV     AX, CX                                           ; [0F12: 8B C1]
    CMP     AL, 2C                                           ; [0F14: 3C 2C]
    JNZ     loc_0f6e                                         ; [0F16: 75 56]
loc_0f18:
    MOV     AL, 20                                           ; [0F18: B0 20]
    CALL    conout_char                                      ; [0F1A: E8 7B F3]
    INC     BX                                               ; [0F1D: 43]
    INC     BX                                               ; [0F1E: 43]
    DEC     DL                                               ; [0F1F: FE CA]
    JZ      loc_0f26                                         ; [0F21: 74 03]
    JMPN    loc_0e9d                                         ; [0F23: E9 77 FF]
loc_0f26:
    JMPN    loc_0e81                                         ; [0F26: E9 58 FF]
loc_0f29:
    MOV     AL, 20                                           ; [0F29: B0 20]
    LOOP    loc_0ef3                                         ; [0F2B: E2 C6]
    INC     BX                                               ; [0F2D: 43]
    INC     BX                                               ; [0F2E: 43]
    DEC     DL                                               ; [0F2F: FE CA]
    JZ      loc_0f36                                         ; [0F31: 74 03]
    JMPN    loc_0e9d                                         ; [0F33: E9 67 FF]
loc_0f36:
    MOV     AL, 20                                           ; [0F36: B0 20]
    CALL    conout_char                                      ; [0F38: E8 5D F3]
    MOV     AL, 3C                                           ; [0F3B: B0 3C]
    CALL    conout_char                                      ; [0F3D: E8 58 F3]
    PUSH    DS                                               ; [0F40: 1E]
    MOV     AX, [CS:ram_segment_base]                        ; [0F41: 2E A1 02 00]
    MOV     DS, AX                                           ; [0F45: 8E D8]
    MOV     CX, 000A                                         ; [0F47: B9 0A 00]
    MOV     BP, 6400                                         ; [0F4A: BD 00 64]
loc_0f4d:
    MOV     AL, BYTE [DS:BP+00]                              ; [0F4D: 3E 8A 46 00]
    CALL    conout_char                                      ; [0F51: E8 44 F3]
    INC     BP                                               ; [0F54: 45]
    LOOP    loc_0f4d                                         ; [0F55: E2 F6]
    POP     DS                                               ; [0F57: 1F]
    MOV     AL, 3E                                           ; [0F58: B0 3E]
    CALL    conout_char                                      ; [0F5A: E8 3B F3]
    DEC     DH                                               ; [0F5D: FE CE]
    JNZ     loc_0f26                                         ; [0F5F: 75 C5]
    CALL    read_key_poll                                    ; [0F61: E8 6F F4]
    CALL    conout_char                                      ; [0F64: E8 31 F3]
    CMP     AL, 2C                                           ; [0F67: 3C 2C]
    JNZ     loc_0f6e                                         ; [0F69: 75 03]
    JMPN    loc_0e7c                                         ; [0F6B: E9 0E FF]
loc_0f6e:
    JMPN    loc_0dee                                         ; [0F6E: E9 7D FE]
loc_0f71:
    CALL    wait_key_press                                   ; [0F71: E8 55 F4]
    MOV     AX, 22C4                                         ; [0F74: B8 C4 22]
    MOV     CX, FFFF                                         ; [0F77: B9 FF FF]
    CALL    print_string_es_ax                               ; [0F7A: E8 2F F4]
    POP     BP                                               ; [0F7D: 5D]
    POP     DI                                               ; [0F7E: 5F]
    POP     SI                                               ; [0F7F: 5E]
    POP     DX                                               ; [0F80: 5A]
    POP     CX                                               ; [0F81: 59]
    POP     BX                                               ; [0F82: 5B]
    POP     AX                                               ; [0F83: 58]
    POP     DS                                               ; [0F84: 1F]
    RETN                                                     ; [0F85: C3]

; ----------------------------------------------------------------------------
; decimal_base_ten_const (ROM: 47C6h, FB84:0F86h)
; Inline konstant 10 decimal efter RETN instruktion (FB84:0FAC, FB84:0FC2)
; ----------------------------------------------------------------------------
decimal_base_ten_const:
    DW  0000Ah                       ; [0F86h] 10 decimal (div/mul base)
sub_0f88:
    PUSH    DX                                               ; [0F88: 52]
    PUSH    BX                                               ; [0F89: 53]
    CALL    print_string_es_ax                               ; [0F8A: E8 1F F4]
    MOV     AX, BX                                           ; [0F8D: 8B C3]
    CALL    sub_038b                                         ; [0F8F: E8 F9 F3]
    MOV     AL, 2F                                           ; [0F92: B0 2F]
    CALL    conout_char                                      ; [0F94: E8 01 F3]
    MOV     DX, io_pic_icw1              ; 8259A PIC ICW1 (Base port 00h) ; [0F97: BA 00 00]
    MOV     CX, DX                                           ; [0F9A: 8B CA]
loc_0f9c:
    CALL    read_key_poll                                    ; [0F9C: E8 34 F4]
    CMP     AL, 0D                                           ; [0F9F: 3C 0D]
    JZ      loc_0fdd                                         ; [0FA1: 74 3A]
    CALL    conout_char                                      ; [0FA3: E8 F2 F2]
    CMP     AL, 58                                           ; [0FA6: 3C 58]
    JNZ     loc_0fb7                                         ; [0FA8: 75 0D]
    MOV     AX, CX                                           ; [0FAA: 8B C1]
    DIV     WORD [CS:0F86]                                   ; [0FAC: 2E F7 36 86 0F]
    MOV     CX, AX                                           ; [0FB1: 8B C8]
    MOV     BX, AX                                           ; [0FB3: 8B D8]
    JMPS    loc_0f9c                                         ; [0FB5: EB E5]
loc_0fb7:
    CMP     AL, 30                                           ; [0FB7: 3C 30]
    JC      loc_0f9c                                         ; [0FB9: 72 E1]
    CMP     AL, 3A                                           ; [0FBB: 3C 3A]
    JNC     loc_0f9c                                         ; [0FBD: 73 DD]
    PUSH    AX                                               ; [0FBF: 50]
    MOV     AX, CX                                           ; [0FC0: 8B C1]
    MUL     WORD [CS:0F86]                                   ; [0FC2: 2E F7 26 86 0F]
    MOV     CX, AX                                           ; [0FC7: 8B C8]
    POP     AX                                               ; [0FC9: 58]
    JC      loc_0fd5                                         ; [0FCA: 72 09]
    SUB     AL, 30                                           ; [0FCC: 2C 30]
    CBW                                                      ; [0FCE: 98]
    ADD     CX, AX                                           ; [0FCF: 03 C8]
    MOV     BX, CX                                           ; [0FD1: 8B D9]
    JNC     loc_0f9c                                         ; [0FD3: 73 C7]
loc_0fd5:
    MOV     BX, FFFF                                         ; [0FD5: BB FF FF]
    MOV     AL, 3F                                           ; [0FD8: B0 3F]
    CALL    conout_char                                      ; [0FDA: E8 BB F2]
loc_0fdd:
    CALL    wait_key_press                                   ; [0FDD: E8 E9 F3]
    MOV     AX, BX                                           ; [0FE0: 8B C3]
    POP     BX                                               ; [0FE2: 5B]
    POP     DX                                               ; [0FE3: 5A]
    RETN                                                     ; [0FE4: C3]
sub_0fe5:
    CALL    print_string_es_ax                               ; [0FE5: E8 C4 F3]
    MOV     AX, 240D                                         ; [0FE8: B8 0D 24]
    MOV     CX, 000A                                         ; [0FEB: B9 0A 00]
    CALL    print_string_es_ax                               ; [0FEE: E8 BB F3]
    MOV     AX, [var_boot_status_flags]  ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [0FF1: A1 2D 01]
    MOV     AL, 59                                           ; [0FF4: B0 59]
    AND     AH, BH                                           ; [0FF6: 22 E7]
    JNZ     loc_0ffc                                         ; [0FF8: 75 02]
    MOV     AL, 4E                                           ; [0FFA: B0 4E]
loc_0ffc:
    CALL    conout_char                                      ; [0FFC: E8 99 F2]
    MOV     AL, 2F                                           ; [0FFF: B0 2F]
    CALL    conout_char                                      ; [1001: E8 94 F2]
    CALL    read_key_poll                                    ; [1004: E8 CC F3]
    CALL    conout_char                                      ; [1007: E8 8E F2]
    MOV     CX, WORD [var_boot_status_flags] ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [100A: 8B 0E 2D 01]
    CMP     AL, 59                                           ; [100E: 3C 59]
    JNZ     loc_1016                                         ; [1010: 75 04]
    OR      CH, BH                                           ; [1012: 0A EF]
    JMPS    loc_101e                                         ; [1014: EB 08]
loc_1016:
    CMP     AL, 4E                                           ; [1016: 3C 4E]
    JNZ     loc_1022                                         ; [1018: 75 08]
    NOT     BH                                               ; [101A: F6 D7]
    AND     CH, BH                                           ; [101C: 22 EF]
loc_101e:
    MOV     WORD [var_boot_status_flags], CX ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [101E: 89 0E 2D 01]
loc_1022:
    CALL    wait_key_press                                   ; [1022: E8 A4 F3]
    RETN                                                     ; [1025: C3]
sub_1026:
    PUSH    AX                                               ; [1026: 50]
    PUSH    BX                                               ; [1027: 53]
    PUSH    CX                                               ; [1028: 51]
    MOV     AX, 2417                                         ; [1029: B8 17 24]
    MOV     CX, FFFF                                         ; [102C: B9 FF FF]
    CALL    print_string_es_ax                               ; [102F: E8 7A F3]
    MOV     AX, 2427                                         ; [1032: B8 27 24]
    MOV     CX, 0015                                         ; [1035: B9 15 00]
    MOV     BX, 8000                                         ; [1038: BB 00 80]
    CALL    sub_0fe5                                         ; [103B: E8 A7 FF]
    MOV     AX, 243C                                         ; [103E: B8 3C 24]
    MOV     CX, 0015                                         ; [1041: B9 15 00]
    MOV     BX, 4000                                         ; [1044: BB 00 40]
    CALL    sub_0fe5                                         ; [1047: E8 9B FF]
    MOV     AX, 2451                                         ; [104A: B8 51 24]
    MOV     CX, 0015                                         ; [104D: B9 15 00]
    MOV     BX, 1000                                         ; [1050: BB 00 10]
    CALL    sub_0fe5                                         ; [1053: E8 8F FF]
    MOV     AX, 2466                                         ; [1056: B8 66 24]
    MOV     CX, 0015                                         ; [1059: B9 15 00]
    MOV     BX, 0800                                         ; [105C: BB 00 08]
    CALL    sub_0fe5                                         ; [105F: E8 83 FF]
    MOV     AX, 247B                                         ; [1062: B8 7B 24]
    MOV     CX, 0015                                         ; [1065: B9 15 00]
    MOV     BX, 0400                                         ; [1068: BB 00 04]
    CALL    sub_0fe5                                         ; [106B: E8 77 FF]
loc_106e:
    MOV     BX, WORD [var_boot_status_flags] ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [106E: 8B 1E 2D 01]
    PUSH    BX                                               ; [1072: 53]
    AND     BX, 00FF                                         ; [1073: 81 E3 FF 00]
    MOV     AX, 2491                                         ; [1077: B8 91 24]
    MOV     CX, 000A                                         ; [107A: B9 0A 00]
    CALL    sub_0f88                                         ; [107D: E8 08 FF]
    POP     BX                                               ; [1080: 5B]
    CMP     AX, 000F                                         ; [1081: 3D 0F 00]
    JC      loc_108d                                         ; [1084: 72 07]
    MOV     AL, 07                                           ; [1086: B0 07]
    CALL    sub_109d                                         ; [1088: E8 12 00]
    JMPS    loc_106e                                         ; [108B: EB E1]
loc_108d:
    MOV     BL, AL                                           ; [108D: 8A D8]
    MOV     WORD [var_boot_status_flags], BX ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [108F: 89 1E 2D 01]
    MOV     WORD [var_kbd_shift_state], 0000                 ; [1093: C7 06 30 01 00 00]
    POP     CX                                               ; [1099: 59]
    POP     BX                                               ; [109A: 5B]
    POP     AX                                               ; [109B: 58]
    RETN                                                     ; [109C: C3]
sub_109d:
    PUSH    BX                                               ; [109D: 53]
    PUSH    CX                                               ; [109E: 51]
    PUSH    BP                                               ; [109F: 55]
    PUSH    SI                                               ; [10A0: 56]
    MOV     BX, 2683                                         ; [10A1: BB 83 26]
    MOV     SI, 0003                                         ; [10A4: BE 03 00]
loc_10a7:
    CMP     AL, BYTE [ES:BX]                                 ; [10A7: 26 3A 07]
    JZ      loc_10b0                                         ; [10AA: 74 04]
    ADD     BX, SI                                           ; [10AC: 03 DE]
    JMPS    loc_10a7                                         ; [10AE: EB F7]
loc_10b0:
    INC     BX                                               ; [10B0: 43]
    MOV     BP, WORD [ES:BX]                                 ; [10B1: 26 8B 2F]
    MOV     CH, 00                                           ; [10B4: B5 00]
    MOV     CL, BYTE [ES:BP+00]                              ; [10B6: 26 8A 4E 00]
    MOV     SI, CX                                           ; [10BA: 8B F1]
    INC     BP                                               ; [10BC: 45]
    MOV     AX, BP                                           ; [10BD: 8B C5]
    CALL    print_string_es_ax                               ; [10BF: E8 EA F2]
    MOV     AL, BYTE [ES:BP+SI]                              ; [10C2: 26 8A 02]
    CMP     AL, FF                                           ; [10C5: 3C FF]
    JZ      loc_10cc                                         ; [10C7: 74 03]
    CALL    sub_10d4                                         ; [10C9: E8 08 00]
loc_10cc:
    POP     SI                                               ; [10CC: 5E]
    CALL    wait_key_press                                   ; [10CD: E8 F9 F2]
    POP     BP                                               ; [10D0: 5D]
    POP     CX                                               ; [10D1: 59]
    POP     BX                                               ; [10D2: 5B]
    RETN                                                     ; [10D3: C3]
sub_10d4:
    PUSH    BP                                               ; [10D4: 55]
    PUSH    BX                                               ; [10D5: 53]
    PUSH    CX                                               ; [10D6: 51]
    PUSH    SI                                               ; [10D7: 56]
loc_10d8:
    XOR     AH, AH                                           ; [10D8: 32 E4]
    MOV     CX, AX                                           ; [10DA: 8B C8]
    MOV     BX, 260A                                         ; [10DC: BB 0A 26]
    MOV     SI, 0005                                         ; [10DF: BE 05 00]
loc_10e2:
    ADD     BX, SI                                           ; [10E2: 03 DE]
    LOOP    loc_10e2                                         ; [10E4: E2 FC]
    SUB     BX, SI                                           ; [10E6: 2B DE]
    MOV     AX, WORD [ES:BX]                                 ; [10E8: 26 8B 07]
    MOV     CX, 0008                                         ; [10EB: B9 08 00]
    CALL    print_string_es_ax                               ; [10EE: E8 BB F2]
    ADD     BX, +02                                          ; [10F1: 83 C3 02]
    MOV     SI, WORD [ES:BX]                                 ; [10F4: 26 8B 37]
    LEA     BP, WORD [var_selftest_error_subcode]            ; [10F7: 8D 2E 21 01]
    MOV     AX, WORD [DS:BP+SI]                              ; [10FB: 3E 8B 02]
    CALL    sub_0345                                         ; [10FE: E8 44 F2]
    ADD     BX, +02                                          ; [1101: 83 C3 02]
    MOV     AL, BYTE [ES:BX]                                 ; [1104: 26 8A 07]
    CMP     AL, FF                                           ; [1107: 3C FF]
    JNZ     loc_10d8                                         ; [1109: 75 CD]
    POP     SI                                               ; [110B: 5E]
    POP     CX                                               ; [110C: 59]
    POP     BX                                               ; [110D: 5B]
    POP     BP                                               ; [110E: 5D]
    RETN                                                     ; [110F: C3]

; ----------------------------------------------------------------------------
; selftest_check_keyboard (ROM: 4950h, FB84:1110h)
; ----------------------------------------------------------------------------
selftest_check_keyboard:
    PUSH    AX                                               ; [1110: 50]
    PUSH    BX                                               ; [1111: 53]
    PUSH    CX                                               ; [1112: 51]
    CMP     BYTE [var_kbd_key_ready], FF ; Keyboard event flag (FFh = key pressed) ; [1113: 80 3E 32 01 FF]
    JNZ     loc_1173                                         ; [1118: 75 59]
    MOV     AL, [var_kbd_ascii_char]     ; Keyboard ASCII char buffer ; [111A: A0 33 01]
    CMP     AL, 20                                           ; [111D: 3C 20]
    JNZ     loc_1173                                         ; [111F: 75 52]
    OR      WORD [var_boot_status_flags], 2000 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1121: 81 0E 2D 01 00 20]
    CALL    clear_screen_or_cursor                           ; [1127: E8 95 F0]
loc_112a:
    CMP     AL, 35                                           ; [112A: 3C 35]
    JNZ     loc_1131                                         ; [112C: 75 03]
    CALL    menu_enter_snooper                               ; [112E: E8 47 10]
loc_1131:
    CMP     AL, 34                                           ; [1131: 3C 34]
    JNZ     loc_1138                                         ; [1133: 75 03]
    CALL    menu_show_hw_config                              ; [1135: E8 A6 01]
loc_1138:
    CMP     AL, 33                                           ; [1138: 3C 33]
    JNZ     loc_113f                                         ; [113A: 75 03]
    CALL    sub_1026                                         ; [113C: E8 E7 FE]
loc_113f:
    CMP     AL, 32                                           ; [113F: 3C 32]
    JNZ     loc_1146                                         ; [1141: 75 03]
    CALL    sub_0dc7                                         ; [1143: E8 81 FC]
loc_1146:
    CMP     AL, 31                                           ; [1146: 3C 31]
    JNZ     loc_114d                                         ; [1148: 75 03]
    CALL    menu_list_of_tests                               ; [114A: E8 2F 00]
loc_114d:
    CMP     AL, 30                                           ; [114D: 3C 30]
    JZ      loc_1173                                         ; [114F: 74 22]
    MOV     BX, 24BB                                         ; [1151: BB BB 24]
loc_1154:
    MOV     AL, BYTE [ES:BX]                                 ; [1154: 26 8A 07]
    CMP     AL, FF                                           ; [1157: 3C FF]
    JZ      loc_1161                                         ; [1159: 74 06]
    CALL    conout_char                                      ; [115B: E8 3A F1]
    INC     BX                                               ; [115E: 43]
    JMPS    loc_1154                                         ; [115F: EB F3]
loc_1161:
    MOV     BYTE [var_kbd_key_ready], 00 ; Keyboard event flag (FFh = key pressed) ; [1161: C6 06 32 01 00]
    CALL    read_key_poll                                    ; [1166: E8 6A F2]
    CALL    conout_char                                      ; [1169: E8 2C F1]
    PUSH    AX                                               ; [116C: 50]
    CALL    wait_key_press                                   ; [116D: E8 59 F2]
    POP     AX                                               ; [1170: 58]
    JMPS    loc_112a                                         ; [1171: EB B7]
loc_1173:
    MOV     BYTE [var_kbd_key_ready], 00 ; Keyboard event flag (FFh = key pressed) ; [1173: C6 06 32 01 00]
    POP     CX                                               ; [1178: 59]
    POP     BX                                               ; [1179: 5B]
    POP     AX                                               ; [117A: 58]
    RETN                                                     ; [117B: C3]

; ----------------------------------------------------------------------------
; menu_list_of_tests (ROM: 49BCh, FB84:117Ch)
; ----------------------------------------------------------------------------
menu_list_of_tests:
    PUSH    AX                                               ; [117C: 50]
    PUSH    CX                                               ; [117D: 51]
    PUSH    BX                                               ; [117E: 53]
    PUSH    DX                                               ; [117F: 52]
    PUSH    BP                                               ; [1180: 55]
    PUSH    SI                                               ; [1181: 56]
    MOV     AX, 24E5                                         ; [1182: B8 E5 24]
    MOV     CX, FFFF                                         ; [1185: B9 FF FF]
    CALL    print_string_es_ax                               ; [1188: E8 21 F2]
    MOV     CX, 000E                                         ; [118B: B9 0E 00]
loc_118e:
    MOV     AX, CX                                           ; [118E: 8B C1]
    CALL    sub_038b                                         ; [1190: E8 F8 F1]
    MOV     AL, 3D                                           ; [1193: B0 3D]
    CALL    conout_char                                      ; [1195: E8 00 F1]
    CMP     CX, +00                                          ; [1198: 83 F9 00]
    JZ      loc_11cd                                         ; [119B: 74 30]
    PUSH    CX                                               ; [119D: 51]
    MOV     BX, 264B                                         ; [119E: BB 4B 26]
    MOV     SI, 0004                                         ; [11A1: BE 04 00]
loc_11a4:
    ADD     BX, SI                                           ; [11A4: 03 DE]
    LOOP    loc_11a4                                         ; [11A6: E2 FC]
    SUB     BX, SI                                           ; [11A8: 2B DE]
    MOV     AX, WORD [ES:BX]                                 ; [11AA: 26 8B 07]
    MOV     CX, WORD [ES:BX+02]                              ; [11AD: 26 8B 4F 02]
    DEC     CX                                               ; [11B1: 49]
    CALL    print_string_es_ax                               ; [11B2: E8 F7 F1]
    POP     CX                                               ; [11B5: 59]
    PUSH    CX                                               ; [11B6: 51]
    RCR     CX, 1                                            ; [11B7: D1 D9]
    JNC     loc_11c0                                         ; [11B9: 73 05]
    CALL    wait_key_press                                   ; [11BB: E8 0B F2]
    JMPS    loc_11c8                                         ; [11BE: EB 08]
loc_11c0:
    CALL    sub_0267                                         ; [11C0: E8 A4 F0]
    MOV     AL, 28                                           ; [11C3: B0 28]
    CALL    set_cursor_pos                                   ; [11C5: E8 B1 F0]
loc_11c8:
    POP     CX                                               ; [11C8: 59]
    DEC     CX                                               ; [11C9: 49]
    JMPN    loc_118e                                         ; [11CA: E9 C1 FF]
loc_11cd:
    MOV     AX, 21FC                                         ; [11CD: B8 FC 21]
    MOV     CX, 000C                                         ; [11D0: B9 0C 00]
    CALL    print_string_es_ax                               ; [11D3: E8 D6 F1]
    POP     SI                                               ; [11D6: 5E]
    POP     BP                                               ; [11D7: 5D]
    POP     DX                                               ; [11D8: 5A]
    POP     BX                                               ; [11D9: 5B]
    POP     CX                                               ; [11DA: 59]
    POP     AX                                               ; [11DB: 58]
    RETN                                                     ; [11DC: C3]
sub_11dd:
    PUSH    AX                                               ; [11DD: 50]
    PUSH    BX                                               ; [11DE: 53]
    PUSH    CX                                               ; [11DF: 51]
    PUSH    DX                                               ; [11E0: 52]
    MOV     BX, 0050                                         ; [11E1: BB 50 00]
    MOV     CX, 0015                                         ; [11E4: B9 15 00]
loc_11e7:
    MOV     BYTE [BX], 00                                    ; [11E7: C6 07 00]
    INC     BX                                               ; [11EA: 43]
    LOOP    loc_11e7                                         ; [11EB: E2 FA]
    MOV     DX, io_ppi_porta             ; 8255 PPI Port A (Memory size, Cassette, iSBX) ; [11ED: BA 70 00]
    IN      AL, DX                                           ; [11F0: EC]
    MOV     AH, AL                                           ; [11F1: 8A E0]
    SHR     AL, 1                                            ; [11F3: D0 E8]
    SHR     AL, 1                                            ; [11F5: D0 E8]
    SHR     AL, 1                                            ; [11F7: D0 E8]
    AND     AL, 06                                           ; [11F9: 24 06]
    MOV     BX, 04C9                                         ; [11FB: BB C9 04]
    ADD     BL, AL                                           ; [11FE: 02 D8]
    MOV     DX, WORD [CS:BX+0000]                            ; [1200: 2E 8B 97 00 00]
    MOV     BX, 0050                                         ; [1205: BB 50 00]
    MOV     WORD [BX], 0000                                  ; [1208: C7 07 00 00]
    INC     BX                                               ; [120C: 43]
    INC     BX                                               ; [120D: 43]
    MOV     WORD [BX], DX                                    ; [120E: 89 17]
    INC     BX                                               ; [1210: 43]
    INC     BX                                               ; [1211: 43]
    MOV     WORD [BX], 8000                                  ; [1212: C7 07 00 80]
    INC     BX                                               ; [1216: 43]
    INC     BX                                               ; [1217: 43]
    MOV     WORD [BX], DX                                    ; [1218: 89 17]
    INC     BX                                               ; [121A: 43]
    INC     BX                                               ; [121B: 43]
    MOV     WORD [BX], 2000                                  ; [121C: C7 07 00 20]
    INC     BX                                               ; [1220: 43]
    INC     BX                                               ; [1221: 43]
    MOV     WORD [BX], 0003                                  ; [1222: C7 07 03 00]
    INC     BX                                               ; [1226: 43]
    INC     BX                                               ; [1227: 43]
    MOV     DX, io_ppi_portb             ; 8255 PPI Port B (Monitor type 50/60Hz, RTC type) ; [1228: BA 72 00]
    IN      AL, DX                                           ; [122B: EC]
    MOV     AH, AL                                           ; [122C: 8A E0]
    MOV     DL, 02                                           ; [122E: B2 02]
    TEST    DL, AL                                           ; [1230: 84 C2]
    JNZ     loc_1237                                         ; [1232: 75 03]
    MOV     BYTE [BX], FF                                    ; [1234: C6 07 FF]
loc_1237:
    INC     BX                                               ; [1237: 43]
    RCR     DL, 1                                            ; [1238: D0 DA]
    TEST    DL, AL                                           ; [123A: 84 C2]
    JNZ     loc_1241                                         ; [123C: 75 03]
    MOV     BYTE [BX], FF                                    ; [123E: C6 07 FF]
loc_1241:
    INC     BX                                               ; [1241: 43]
    MOV     DX, io_ppi_porta             ; 8255 PPI Port A (Memory size, Cassette, iSBX) ; [1242: BA 70 00]
    IN      AL, DX                                           ; [1245: EC]
    TEST    AL, 02                                           ; [1246: A8 02]
    JNZ     loc_124d                                         ; [1248: 75 03]
    MOV     BYTE [BX], FF                                    ; [124A: C6 07 FF]
loc_124d:
    INC     BX                                               ; [124D: 43]
    TEST    AL, 40                                           ; [124E: A8 40]
    JNZ     loc_1255                                         ; [1250: 75 03]
    MOV     BYTE [BX], FF                                    ; [1252: C6 07 FF]
loc_1255:
    INC     BX                                               ; [1255: 43]
    INC     BX                                               ; [1256: 43]
    INC     BX                                               ; [1257: 43]
    MOV     AL, AH                                           ; [1258: 8A C4]
    MOV     CL, 05                                           ; [125A: B1 05]
    SHR     AL, CL                                           ; [125C: D2 E8]
    AND     AL, 03                                           ; [125E: 24 03]
    MOV     [var_floppy_motor_timer], AL                     ; [1260: A2 62 00]
    MOV     AL, 00                                           ; [1263: B0 00]
    MOV     [var_floppy_target_drive], AL                    ; [1265: A2 63 00]
    CMP     BYTE [var_boot_head_settle], FF                  ; [1268: 80 3E 5F 00 FF]
    JNZ     loc_12cc                                         ; [126D: 75 5D]
    MOV     AX, 0007                                         ; [126F: B8 07 00]
    CALL    nvram_read_byte_al                               ; [1272: E8 45 29]
    TEST    AL, 80                                           ; [1275: A8 80]
    JZ      loc_1285                                         ; [1277: 74 0C]
    AND     AL, 03                                           ; [1279: 24 03]
    CMP     AL, 03                                           ; [127B: 3C 03]
    JZ      loc_1285                                         ; [127D: 74 06]
    MOV     [var_floppy_target_drive], AL                    ; [127F: A2 63 00]
    JMPN    loc_12cc                                         ; [1282: E9 47 00]
loc_1285:
    INC     BYTE [var_floppy_target_drive]                   ; [1285: FE 06 63 00]
    MOV     CX, C350                                         ; [1289: B9 50 C3]
loc_128c:
    MOV     DX, io_floppy_reserve_ack    ; Floppy Reserve / Acknowledge register ; [128C: BA 8E 02]
    MOV     AL, FF                                           ; [128F: B0 FF]
    OUT     DX, AL                                           ; [1291: EE]
    IN      AL, DX                                           ; [1292: EC]
    TEST    AL, 80                                           ; [1293: A8 80]
    JZ      loc_12a6                                         ; [1295: 74 0F]
    MOV     AX, 001E                                         ; [1297: B8 1E 00]
    CALL    busy_loop_delay_ax                               ; [129A: E8 21 F9]
    LOOP    loc_128c                                         ; [129D: E2 ED]
    MOV     DX, io_floppy_release        ; Floppy Release register ; [129F: BA 90 02]
    OUT     DX, AL                                           ; [12A2: EE]
    JMPN    loc_12cc                                         ; [12A3: E9 26 00]
loc_12a6:
    MOV     DX, io_floppy_ctrl           ; Floppy Control register (Motor 0/1, Drive sel, DDEN) ; [12A6: BA 88 02]
    MOV     AL, 47                                           ; [12A9: B0 47]
    OUT     DX, AL                                           ; [12AB: EE]
    MOV     CX, 0001                                         ; [12AC: B9 01 00]
loc_12af:
    MOV     DX, io_wd2797_status_cmd     ; WD2797 FDC Status / Command register ; [12AF: BA 80 02]
    IN      AL, DX                                           ; [12B2: EC]
    TEST    AL, 80                                           ; [12B3: A8 80]
    JNZ     loc_12bd                                         ; [12B5: 75 06]
loc_12b7:
    INC     BYTE [var_floppy_target_drive]                   ; [12B7: FE 06 63 00]
    JMPS    loc_12c4                                         ; [12BB: EB 07]
loc_12bd:
    PUSH    CX                                               ; [12BD: 51]
    CALL    fdc_wait_ready_timeout                           ; [12BE: E8 3B 27]
    POP     CX                                               ; [12C1: 59]
    JNC     loc_12b7                                         ; [12C2: 73 F3]
loc_12c4:
    MOV     DX, io_floppy_ctrl           ; Floppy Control register (Motor 0/1, Drive sel, DDEN) ; [12C4: BA 88 02]
    MOV     AL, 46                                           ; [12C7: B0 46]
    OUT     DX, AL                                           ; [12C9: EE]
    LOOP    loc_12af                                         ; [12CA: E2 E3]
loc_12cc:
    CALL    sub_39c6                                         ; [12CC: E8 F7 26]
    MOV     BX, 0068                                         ; [12CF: BB 68 00]
    MOV     BYTE [BX], 00                                    ; [12D2: C6 07 00]
    INC     BX                                               ; [12D5: 43]
    MOV     BYTE [BX], 00                                    ; [12D6: C6 07 00]
    POP     DX                                               ; [12D9: 5A]
    POP     CX                                               ; [12DA: 59]
    POP     BX                                               ; [12DB: 5B]
    POP     AX                                               ; [12DC: 58]
    RETN                                                     ; [12DD: C3]

; ----------------------------------------------------------------------------
; menu_show_hw_config (ROM: 4B1Eh, FB84:12DEh)
; ----------------------------------------------------------------------------
menu_show_hw_config:
    PUSH    AX                                               ; [12DE: 50]
    PUSH    BX                                               ; [12DF: 53]
    PUSH    CX                                               ; [12E0: 51]
    MOV     AX, 256C                                         ; [12E1: B8 6C 25]
    MOV     CX, FFFF                                         ; [12E4: B9 FF FF]
    CALL    print_string_es_ax                               ; [12E7: E8 C2 F0]
    MOV     CX, 0029                                         ; [12EA: B9 29 00]
loc_12ed:
    MOV     AL, 2D                                           ; [12ED: B0 2D]
    CALL    conout_char                                      ; [12EF: E8 A6 EF]
    LOOP    loc_12ed                                         ; [12F2: E2 F9]
    MOV     AX, 23BD                                         ; [12F4: B8 BD 23]
    MOV     CX, FFFF                                         ; [12F7: B9 FF FF]
    CALL    print_string_es_ax                               ; [12FA: E8 AF F0]
    MOV     BX, 0054                                         ; [12FD: BB 54 00]
    MOV     AX, WORD [BX+02]                                 ; [1300: 8B 47 02]
    MOV     CL, 06                                           ; [1303: B1 06]
    SHL     AX, CL                                           ; [1305: D3 E0]
    MOV     DX, WORD [BX]                                    ; [1307: 8B 17]
    MOV     CL, 0A                                           ; [1309: B1 0A]
    SHR     DX, CL                                           ; [130B: D3 EA]
    ADD     AX, DX                                           ; [130D: 03 C2]
    CALL    sub_038b                                         ; [130F: E8 79 F0]
    MOV     AX, 2599                                         ; [1312: B8 99 25]
    MOV     CX, 000C                                         ; [1315: B9 0C 00]
    CMP     BYTE [var_boot_retry_counter], FF                ; [1318: 80 3E 5D 00 FF]
    JZ      loc_1321                                         ; [131D: 74 02]
    ADD     AX, CX                                           ; [131F: 03 C1]
loc_1321:
    CALL    print_string_es_ax                               ; [1321: E8 88 F0]
    MOV     AH, 00                                           ; [1324: B4 00]
    MOV     AX, 25B1                                         ; [1326: B8 B1 25]
    MOV     CX, 000C                                         ; [1329: B9 0C 00]
    CMP     BYTE [var_boot_head_settle], FF                  ; [132C: 80 3E 5F 00 FF]
    JZ      loc_1335                                         ; [1331: 74 02]
    ADD     AX, CX                                           ; [1333: 03 C1]
loc_1335:
    CALL    print_string_es_ax                               ; [1335: E8 74 F0]
    MOV     AX, 25B1                                         ; [1338: B8 B1 25]
    MOV     CX, 000C                                         ; [133B: B9 0C 00]
    CMP     BYTE [var_boot_step_rate], FF                    ; [133E: 80 3E 5E 00 FF]
    JZ      loc_1347                                         ; [1343: 74 02]
    ADD     AX, CX                                           ; [1345: 03 C1]
loc_1347:
    CALL    print_string_es_ax                               ; [1347: E8 62 F0]
    MOV     CX, 0006                                         ; [134A: B9 06 00]
    CALL    wait_key_press                                   ; [134D: E8 79 F0]
    POP     CX                                               ; [1350: 59]
    POP     BX                                               ; [1351: 5B]
    POP     AX                                               ; [1352: 58]
    RETN                                                     ; [1353: C3]

; ----------------------------------------------------------------------------
; cursor_blink_handler (ROM: 4B94h, FB84:1354h)
; ----------------------------------------------------------------------------
cursor_blink_handler:
    PUSH    AX                                               ; [1354: 50]
    PUSH    CX                                               ; [1355: 51]
    PUSH    DX                                               ; [1356: 52]
    CALL    mute_sound_chip                                  ; [1357: E8 DC 00]
    MOV     AL, [var_selftest_error_flags] ; Selftest error flags buffer ; [135A: A0 20 01]
    CMP     AL, 00                                           ; [135D: 3C 00]
    JNZ     loc_136d                                         ; [135F: 75 0C]
    MOV     AX, 23C8                                         ; [1361: B8 C8 23]
    MOV     CX, FFFF                                         ; [1364: B9 FF FF]
    CALL    print_string_es_ax                               ; [1367: E8 42 F0]
    JMPN    loc_13fc                                         ; [136A: E9 8F 00]
loc_136d:
    CALL    sub_109d                                         ; [136D: E8 2D FD]
    CALL    sub_0267                                         ; [1370: E8 F4 EE]
    PUSH    AX                                               ; [1373: 50]
    PUSH    ES                                               ; [1374: 06]
    PUSH    BX                                               ; [1375: 53]
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [1376: B8 00 30]
    MOV     ES, AX                                           ; [1379: 8E C0]
    MOV     BX, 5000                                         ; [137B: BB 00 50]
    MOV     WORD [ES:BX], 8E00                               ; [137E: 26 C7 07 00 8E]
    MOV     WORD [ES:BX+02], 0400                            ; [1383: 26 C7 47 02 00 04]
    POP     BX                                               ; [1389: 5B]
    POP     ES                                               ; [138A: 07]
    MOV     AL, 00                                           ; [138B: B0 00]
    MOV     AH, 30                                           ; [138D: B4 30]
    CALL    set_cursor_pos                                   ; [138F: E8 E7 EE]
    MOV     AX, 23BF                                         ; [1392: B8 BF 23]
    MOV     CX, 0007                                         ; [1395: B9 07 00]
    CALL    print_string_es_ax                               ; [1398: E8 11 F0]
    MOV     AH, 00                                           ; [139B: B4 00]
    MOV     AL, [var_selftest_error_flags] ; Selftest error flags buffer ; [139D: A0 20 01]
    CALL    sub_038b                                         ; [13A0: E8 E8 EF]
    MOV     AL, 0D                                           ; [13A3: B0 0D]
    CALL    conout_char                                      ; [13A5: E8 F0 EE]
    MOV     AL, 0A                                           ; [13A8: B0 0A]
    CALL    conout_char                                      ; [13AA: E8 EB EE]
    POP     AX                                               ; [13AD: 58]
    CALL    set_cursor_pos                                   ; [13AE: E8 C8 EE]
    MOV     AX, [var_boot_status_flags]  ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [13B1: A1 2D 01]
    AND     AX, 8000                                         ; [13B4: 25 00 80]
    JZ      loc_13fc                                         ; [13B7: 74 43]
    MOV     AX, 24A4                                         ; [13B9: B8 A4 24]
    MOV     CX, FFFF                                         ; [13BC: B9 FF FF]
    CALL    print_string_es_ax                               ; [13BF: E8 EA EF]
loc_13c2:
    STI                                                      ; [13C2: FB]
    CALL    sub_1405                                         ; [13C3: E8 3F 00]
    CLI                                                      ; [13C6: FA]
    MOV     WORD [var_timer0_tick_count], 0000 ; Timer 0 tick counter (incremented by timer ISR) ; [13C7: C7 06 35 01 00 00]
loc_13cd:
    STI                                                      ; [13CD: FB]
    CMP     WORD [var_timer0_tick_count], 0258 ; Timer 0 tick counter (incremented by timer ISR) ; [13CE: 81 3E 35 01 58 02]
    CLI                                                      ; [13D4: FA]
    JNC     loc_13c2                                         ; [13D5: 73 EB]
    MOV     AL, [var_kbd_key_ready]      ; Keyboard event flag (FFh = key pressed) ; [13D7: A0 32 01]
    CMP     AL, FF                                           ; [13DA: 3C FF]
    JNZ     loc_13cd                                         ; [13DC: 75 EF]
    CMP     BYTE [var_kbd_ascii_char], 20 ; Keyboard ASCII char buffer ; [13DE: 80 3E 33 01 20]
    JNZ     loc_13cd                                         ; [13E3: 75 E8]
    CALL    selftest_check_keyboard                          ; [13E5: E8 28 FD]
    MOV     AX, [var_boot_status_flags]  ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [13E8: A1 2D 01]
    TEST    AX, 4000                                         ; [13EB: A9 00 40]
    JNZ     loc_13fc                                         ; [13EE: 75 0C]
    CMP     WORD [var_kbd_shift_state], +00                  ; [13F0: 83 3E 30 01 00]
    JNZ     loc_13fc                                         ; [13F5: 75 05]
    DEC     AL                                               ; [13F7: FE C8]
    MOV     [var_boot_status_flags], AX  ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [13F9: A3 2D 01]
loc_13fc:
    MOV     BYTE [var_selftest_error_flags], 00 ; Selftest error flags buffer ; [13FC: C6 06 20 01 00]
    POP     DX                                               ; [1401: 5A]
    POP     CX                                               ; [1402: 59]
    POP     AX                                               ; [1403: 58]
    RETN                                                     ; [1404: C3]
sub_1405:
    PUSH    AX                                               ; [1405: 50]
    PUSH    BX                                               ; [1406: 53]
    PUSH    CX                                               ; [1407: 51]
    MOV     CH, 00                                           ; [1408: B5 00]
    MOV     CL, BYTE [var_selftest_error_flags] ; Selftest error flags buffer ; [140A: 8A 0E 20 01]
    MOV     BL, 01                                           ; [140E: B3 01]
loc_1410:
    CMP     BYTE [var_kbd_key_ready], FF ; Keyboard event flag (FFh = key pressed) ; [1410: 80 3E 32 01 FF]
    JZ      loc_1432                                         ; [1415: 74 1B]
    MOV     AX, 03E8                                         ; [1417: B8 E8 03]
    AND     BL, 03                                           ; [141A: 80 E3 03]
    JNZ     loc_1422                                         ; [141D: 75 03]
    ADD     AX, 03E8                                         ; [141F: 05 E8 03]
loc_1422:
    PUSHF                                                    ; [1422: 9C]
    CLI                                                      ; [1423: FA]
    CALL    sub_049a                                         ; [1424: E8 73 F0]
    POPF                                                     ; [1427: 9D]
    INC     BL                                               ; [1428: FE C3]
    MOV     AX, C350                                         ; [142A: B8 50 C3]
    CALL    busy_loop_delay_ax                               ; [142D: E8 8E F7]
    LOOP    loc_1410                                         ; [1430: E2 DE]
loc_1432:
    POP     CX                                               ; [1432: 59]
    POP     BX                                               ; [1433: 5B]
    POP     AX                                               ; [1434: 58]
    RETN                                                     ; [1435: C3]

; ----------------------------------------------------------------------------
; mute_sound_chip (ROM: 4C76h, FB84:1436h)
; ----------------------------------------------------------------------------
mute_sound_chip:
    PUSH    ES                                               ; [1436: 06]
    PUSH    AX                                               ; [1437: 50]
    PUSH    CX                                               ; [1438: 51]
    PUSH    DI                                               ; [1439: 57]
    CLD                                                      ; [143A: FC]
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [143B: B8 00 30]
    MOV     ES, AX                                           ; [143E: 8E C0]
    MOV     DI, 5000                                         ; [1440: BF 00 50]
    MOV     CX, 0050                                         ; [1443: B9 50 00]
    XOR     AX, AX                                           ; [1446: 33 C0]
    REP STOSW                                                ; [1448: F3 AB]
    POP     DI                                               ; [144A: 5F]
    POP     CX                                               ; [144B: 59]
    POP     AX                                               ; [144C: 58]
    POP     ES                                               ; [144D: 07]
    RETN                                                     ; [144E: C3]

; ----------------------------------------------------------------------------
; selftest_status_display (ROM: 4C8Fh, FB84:144Fh)
; ----------------------------------------------------------------------------
selftest_status_display:
    MOV     AX, [var_boot_status_flags]  ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [144F: A1 2D 01]
    PUSH    AX                                               ; [1452: 50]
    OR      AX, 8000                                         ; [1453: 0D 00 80]
    MOV     [var_boot_status_flags], AX  ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1456: A3 2D 01]
    MOV     AX, 24B0                                         ; [1459: B8 B0 24]
    MOV     CX, 000B                                         ; [145C: B9 0B 00]
    CALL    print_string_es_ax                               ; [145F: E8 4A EF]
    MOV     AX, [var_kbd_shift_state]                        ; [1462: A1 30 01]
    CALL    sub_038b                                         ; [1465: E8 23 EF]
    CALL    wait_key_press                                   ; [1468: E8 5E EF]
    POP     AX                                               ; [146B: 58]
    MOV     [var_boot_status_flags], AX  ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [146C: A3 2D 01]
    RETN                                                     ; [146F: C3]

; ----------------------------------------------------------------------------
; selftest_poll_devices (ROM: 4CB0h, FB84:1470h)
; ----------------------------------------------------------------------------
selftest_poll_devices:
    PUSH    AX                                               ; [1470: 50]
    PUSH    BX                                               ; [1471: 53]
    PUSH    CX                                               ; [1472: 51]
    PUSH    DI                                               ; [1473: 57]
    PUSH    SI                                               ; [1474: 56]
    MOV     CX, WORD [var_boot_status_flags] ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1475: 8B 0E 2D 01]
    CALL    sub_0267                                         ; [1479: E8 EB ED]
    PUSH    AX                                               ; [147C: 50]
    MOV     AL, CL                                           ; [147D: 8A C1]
    DEC     AL                                               ; [147F: FE C8]
    MOV     AH, 02                                           ; [1481: B4 02]
    CALL    set_cursor_pos                                   ; [1483: E8 F3 ED]
    MOV     AL, 2A                                           ; [1486: B0 2A]
    CALL    conout_char                                      ; [1488: E8 0D EE]
    POP     AX                                               ; [148B: 58]
    CALL    set_cursor_pos                                   ; [148C: E8 EA ED]
    TEST    CX, 00FF                                         ; [148F: F7 C1 FF 00]
    JNZ     loc_149e                                         ; [1493: 75 09]
loc_1495:
    INC     WORD [var_kbd_shift_state]                       ; [1495: FF 06 30 01]
    CALL    selftest_status_display                          ; [1499: E8 B3 FF]
    JMPS    loc_14a4                                         ; [149C: EB 06]
loc_149e:
    TEST    CX, 4000                                         ; [149E: F7 C1 00 40]
    JNZ     loc_1495                                         ; [14A2: 75 F1]
loc_14a4:
    MOV     CX, WORD [var_boot_status_flags] ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [14A4: 8B 0E 2D 01]
    AND     CX, 00FF                                         ; [14A8: 81 E1 FF 00]
    MOV     DI, CX                                           ; [14AC: 8B F9]
    CMP     CL, 00                                           ; [14AE: 80 F9 00]
    JZ      loc_14cb                                         ; [14B1: 74 18]
    MOV     BX, 264B                                         ; [14B3: BB 4B 26]
    MOV     SI, 0004                                         ; [14B6: BE 04 00]
loc_14b9:
    ADD     BX, SI                                           ; [14B9: 03 DE]
    LOOP    loc_14b9                                         ; [14BB: E2 FC]
    SUB     BX, SI                                           ; [14BD: 2B DE]
    MOV     AX, WORD [ES:BX]                                 ; [14BF: 26 8B 07]
    MOV     CX, WORD [ES:BX+02]                              ; [14C2: 26 8B 4F 02]
    CALL    print_string_es_ax                               ; [14C6: E8 E3 EE]
    SHL     DI, 1                                            ; [14C9: D1 E7]
loc_14cb:
    CALL    WORD [ES:DI+diag_test_jump_table]                ; [14CB: 26 FF 95 2D 26]
    POP     SI                                               ; [14D0: 5E]
    POP     DI                                               ; [14D1: 5F]
    POP     CX                                               ; [14D2: 59]
    POP     BX                                               ; [14D3: 5B]
    POP     AX                                               ; [14D4: 58]
    RETN                                                     ; [14D5: C3]
sub_14d6:
    LEA     AX, WORD [0400]                                  ; [14D6: 8D 06 00 04]
    MOV     CX, 1000                                         ; [14DA: B9 00 10]
    CALL    clear_memory_words                               ; [14DD: E8 7B F6]
    MOV     CX, 0002                                         ; [14E0: B9 02 00]
    TEST    WORD [var_boot_status_flags], 4000 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [14E3: F7 06 2D 01 00 40]
    JZ      loc_14ee                                         ; [14E9: 74 03]
    MOV     CX, 003C                                         ; [14EB: B9 3C 00]
loc_14ee:
    MOV     AX, C350                                         ; [14EE: B8 50 C3]
    CALL    busy_loop_delay_ax                               ; [14F1: E8 CA F6]
    LOOP    loc_14ee                                         ; [14F4: E2 F8]
    TEST    WORD [var_boot_status_flags], 0400 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [14F6: F7 06 2D 01 00 04]
    JNZ     loc_151c                                         ; [14FC: 75 1E]
    MOV     CX, 0064                                         ; [14FE: B9 64 00]
loc_1501:
    PUSH    CX                                               ; [1501: 51]
    LEA     BX, WORD [0400]                                  ; [1502: 8D 1E 00 04]
    MOV     CX, 1000                                         ; [1506: B9 00 10]
    MOV     SI, 0000                                         ; [1509: BE 00 00]
    MOV     AX, 0000                                         ; [150C: B8 00 00]
loc_150f:
    CMP     AX, WORD [BX+SI]                                 ; [150F: 3B 00]
    JNZ     loc_151d                                         ; [1511: 75 0A]
    ADD     SI, +02                                          ; [1513: 83 C6 02]
    INC     AX                                               ; [1516: 40]
    LOOP    loc_150f                                         ; [1517: E2 F6]
    POP     CX                                               ; [1519: 59]
    LOOP    loc_1501                                         ; [151A: E2 E5]
loc_151c:
    RETN                                                     ; [151C: C3]
loc_151d:
    POP     CX                                               ; [151D: 59]
    MOV     WORD [var_selftest_error_subcode], SI            ; [151E: 89 36 21 01]
    MOV     [var_selftest_error_count], AX                   ; [1522: A3 23 01]
    MOV     AX, WORD [BX+SI]                                 ; [1525: 8B 00]
    MOV     [var_selftest_failing_dev], AX                   ; [1527: A3 25 01]
    MOV     BYTE [var_selftest_error_flags], 09 ; Selftest error flags buffer ; [152A: C6 06 20 01 09]
    RETN                                                     ; [152F: C3]
sub_1530:
    MOV     DX, io_i186_timer2_count     ; 80186 Timer 2 Count register (T2CNT) ; [1530: BA 60 FF]
    MOV     AX, 0000                                         ; [1533: B8 00 00]
    OUT     DX, AX                                           ; [1536: EF]
    MOV     DX, io_i186_timer2_max_a     ; 80186 Timer 2 Max Count A register (T2CMPA) ; [1537: BA 62 FF]
    MOV     AX, 2710                                         ; [153A: B8 10 27]
    MOV     [var_selftest_error_count], AX                   ; [153D: A3 23 01]
    OUT     DX, AX                                           ; [1540: EF]
    MOV     DX, io_i186_timer2_ctrl      ; 80186 Timer 2 Mode / Control register (T2CON) ; [1541: BA 66 FF]
    MOV     AX, C000                                         ; [1544: B8 00 C0]
    OUT     DX, AX                                           ; [1547: EF]
    MOV     BX, 03E8                                         ; [1548: BB E8 03]
    IN      AX, DX                                           ; [154B: ED]
    TEST    AX, 0020                                         ; [154C: A9 20 00]
    JNZ     loc_155e                                         ; [154F: 75 0D]
loc_1551:
    MOV     CL, F0                                           ; [1551: B1 F0]
    SHR     CL, CL                                           ; [1553: D2 E9]
    IN      AX, DX                                           ; [1555: ED]
    TEST    AX, 0020                                         ; [1556: A9 20 00]
    JNZ     loc_1578                                         ; [1559: 75 1D]
    DEC     BX                                               ; [155B: 4B]
    JNZ     loc_1551                                         ; [155C: 75 F3]
loc_155e:
    TEST    WORD [var_boot_status_flags], 0800 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [155E: F7 06 2D 01 00 08]
    JNZ     loc_1576                                         ; [1564: 75 10]
    MOV     BYTE [var_selftest_error_flags], 0A ; Selftest error flags buffer ; [1566: C6 06 20 01 0A]
    SUB     DX, +06                                          ; [156B: 83 EA 06]
    MOV     WORD [var_selftest_error_subcode], DX            ; [156E: 89 16 21 01]
    IN      AX, DX                                           ; [1572: ED]
    MOV     [var_selftest_failing_dev], AX                   ; [1573: A3 25 01]
loc_1576:
    JMPS    loc_15c3                                         ; [1576: EB 4B]
loc_1578:
    MOV     DX, io_i186_timer1_count     ; 80186 Timer 1 Count register (T1CNT) ; [1578: BA 58 FF]
    MOV     AX, 0000                                         ; [157B: B8 00 00]
    OUT     DX, AX                                           ; [157E: EF]
    MOV     DX, io_i186_timer1_max_a     ; 80186 Timer 1 Max Count A register (T1CMPA) ; [157F: BA 5A FF]
    MOV     AX, 0005                                         ; [1582: B8 05 00]
    MOV     [var_selftest_error_count], AX                   ; [1585: A3 23 01]
    OUT     DX, AX                                           ; [1588: EF]
    MOV     DX, io_i186_timer1_ctrl      ; 80186 Timer 1 Mode / Control register (T1CON) ; [1589: BA 5E FF]
    MOV     AX, C008                                         ; [158C: B8 08 C0]
    OUT     DX, AX                                           ; [158F: EF]
    MOV     DX, io_i186_timer2_count     ; 80186 Timer 2 Count register (T2CNT) ; [1590: BA 60 FF]
    MOV     AX, 0000                                         ; [1593: B8 00 00]
    OUT     DX, AX                                           ; [1596: EF]
    MOV     DX, io_i186_timer2_max_a     ; 80186 Timer 2 Max Count A register (T2CMPA) ; [1597: BA 62 FF]
    MOV     AX, 2710                                         ; [159A: B8 10 27]
    OUT     DX, AX                                           ; [159D: EF]
    MOV     DX, io_i186_timer2_ctrl      ; 80186 Timer 2 Mode / Control register (T2CON) ; [159E: BA 66 FF]
    MOV     AX, C000                                         ; [15A1: B8 00 C0]
    ADD     AX, 0001                                         ; [15A4: 05 01 00]
    OUT     DX, AX                                           ; [15A7: EF]
    MOV     DX, io_i186_timer1_ctrl      ; 80186 Timer 1 Mode / Control register (T1CON) ; [15A8: BA 5E FF]
    MOV     BX, C350                                         ; [15AB: BB 50 C3]
    IN      AX, DX                                           ; [15AE: ED]
    TEST    AX, 0020                                         ; [15AF: A9 20 00]
    JNZ     loc_155e                                         ; [15B2: 75 AA]
loc_15b4:
    MOV     CL, F0                                           ; [15B4: B1 F0]
    SHR     CL, CL                                           ; [15B6: D2 E9]
    IN      AX, DX                                           ; [15B8: ED]
    TEST    AX, 0020                                         ; [15B9: A9 20 00]
    JNZ     loc_15c3                                         ; [15BC: 75 05]
    DEC     BX                                               ; [15BE: 4B]
    JNZ     loc_15b4                                         ; [15BF: 75 F3]
    JMPS    loc_155e                                         ; [15C1: EB 9B]
loc_15c3:
    MOV     DX, io_i186_timer2_count     ; 80186 Timer 2 Count register (T2CNT) ; [15C3: BA 60 FF]
    MOV     AX, 0000                                         ; [15C6: B8 00 00]
    OUT     DX, AX                                           ; [15C9: EF]
    MOV     DX, io_i186_timer2_max_a     ; 80186 Timer 2 Max Count A register (T2CMPA) ; [15CA: BA 62 FF]
    MOV     AX, 2710                                         ; [15CD: B8 10 27]
    OUT     DX, AX                                           ; [15D0: EF]
    MOV     DX, io_i186_timer2_ctrl      ; 80186 Timer 2 Mode / Control register (T2CON) ; [15D1: BA 66 FF]
    MOV     AX, C000                                         ; [15D4: B8 00 C0]
    OUT     DX, AX                                           ; [15D7: EF]
    MOV     DX, io_i186_timer1_count     ; 80186 Timer 1 Count register (T1CNT) ; [15D8: BA 58 FF]
    MOV     AX, 0000                                         ; [15DB: B8 00 00]
    OUT     DX, AX                                           ; [15DE: EF]
    ADD     DX, +02                                          ; [15DF: 83 C2 02]
    MOV     AX, 03E8                                         ; [15E2: B8 E8 03]
    OUT     DX, AX                                           ; [15E5: EF]
    ADD     DX, +02                                          ; [15E6: 83 C2 02]
    OUT     DX, AX                                           ; [15E9: EF]
    ADD     DX, +02                                          ; [15EA: 83 C2 02]
    MOV     AX, C002                                         ; [15ED: B8 02 C0]
    OUT     DX, AX                                           ; [15F0: EF]
    MOV     AX, C350                                         ; [15F1: B8 50 C3]
    CALL    busy_loop_delay_ax                               ; [15F4: E8 C7 F5]
    RETN                                                     ; [15F7: C3]
sub_15f8:
    PUSH    AX                                               ; [15F8: 50]
    PUSH    BX                                               ; [15F9: 53]
    PUSH    CX                                               ; [15FA: 51]
    PUSH    DX                                               ; [15FB: 52]
    MOV     DX, io_i186_dma0_src_lo      ; 80186 DMA 0 Lower Source Address ; [15FC: BA C0 FF]
    MOV     CL, 04                                           ; [15FF: B1 04]
    MOV     BX, DS                                           ; [1601: 8C DB]
    AND     BX, 0FFF                                         ; [1603: 81 E3 FF 0F]
    SHL     BX, CL                                           ; [1607: D3 E3]
    MOV     AX, 0400                                         ; [1609: B8 00 04]
    ADD     AX, BX                                           ; [160C: 03 C3]
    OUT     DX, AX                                           ; [160E: EF]
    MOV     AX, DS                                           ; [160F: 8C D8]
    AND     AX, F000                                         ; [1611: 25 00 F0]
    XCHG    AH, AL                                           ; [1614: 86 C4]
    SHR     AL, CL                                           ; [1616: D2 E8]
    ADD     DX, +02                                          ; [1618: 83 C2 02]
    OUT     DX, AX                                           ; [161B: EF]
    MOV     AX, 2400                                         ; [161C: B8 00 24]
    ADD     AX, BX                                           ; [161F: 03 C3]
    ADD     DX, +02                                          ; [1621: 83 C2 02]
    OUT     DX, AX                                           ; [1624: EF]
    MOV     AX, DS                                           ; [1625: 8C D8]
    AND     AX, F000                                         ; [1627: 25 00 F0]
    XCHG    AH, AL                                           ; [162A: 86 C4]
    SHR     AL, CL                                           ; [162C: D2 E8]
    ADD     DX, +02                                          ; [162E: 83 C2 02]
    OUT     DX, AX                                           ; [1631: EF]
    MOV     AX, 1000                                         ; [1632: B8 00 10]
    SHL     AX, 1                                            ; [1635: D1 E0]
    ADD     DX, +02                                          ; [1637: 83 C2 02]
    OUT     DX, AX                                           ; [163A: EF]
    MOV     AX, B606                                         ; [163B: B8 06 B6]
    ADD     DX, +02                                          ; [163E: 83 C2 02]
    OUT     DX, AX                                           ; [1641: EF]
    MOV     DX, io_i186_dma1_src_lo      ; 80186 DMA 1 Lower Source Address ; [1642: BA D0 FF]
    MOV     CL, 04                                           ; [1645: B1 04]
    MOV     BX, DS                                           ; [1647: 8C DB]
    AND     BX, 0FFF                                         ; [1649: 81 E3 FF 0F]
    SHL     BX, CL                                           ; [164D: D3 E3]
    MOV     AX, 0400                                         ; [164F: B8 00 04]
    ADD     AX, 1FFF                                         ; [1652: 05 FF 1F]
    ADD     AX, BX                                           ; [1655: 03 C3]
    OUT     DX, AX                                           ; [1657: EF]
    MOV     AX, DS                                           ; [1658: 8C D8]
    AND     AX, F000                                         ; [165A: 25 00 F0]
    XCHG    AH, AL                                           ; [165D: 86 C4]
    SHR     AL, CL                                           ; [165F: D2 E8]
    ADD     DX, +02                                          ; [1661: 83 C2 02]
    OUT     DX, AX                                           ; [1664: EF]
    MOV     AX, 4400                                         ; [1665: B8 00 44]
    ADD     AX, 1FFF                                         ; [1668: 05 FF 1F]
    ADD     AX, BX                                           ; [166B: 03 C3]
    ADD     DX, +02                                          ; [166D: 83 C2 02]
    OUT     DX, AX                                           ; [1670: EF]
    MOV     AX, DS                                           ; [1671: 8C D8]
    AND     AX, F000                                         ; [1673: 25 00 F0]
    XCHG    AH, AL                                           ; [1676: 86 C4]
    SHR     AL, CL                                           ; [1678: D2 E8]
    ADD     DX, +02                                          ; [167A: 83 C2 02]
    OUT     DX, AX                                           ; [167D: EF]
    MOV     AX, 1000                                         ; [167E: B8 00 10]
    SHL     AX, 1                                            ; [1681: D1 E0]
    ADD     DX, +02                                          ; [1683: 83 C2 02]
    OUT     DX, AX                                           ; [1686: EF]
    MOV     AX, DA06                                         ; [1687: B8 06 DA]
    ADD     DX, +02                                          ; [168A: 83 C2 02]
    OUT     DX, AX                                           ; [168D: EF]
    POP     DX                                               ; [168E: 5A]
    POP     CX                                               ; [168F: 59]
    POP     BX                                               ; [1690: 5B]
    POP     AX                                               ; [1691: 58]
    RETN                                                     ; [1692: C3]
sub_1693:
    MOV     AX, 2400                                         ; [1693: B8 00 24]
    MOV     CX, 1000                                         ; [1696: B9 00 10]
    CALL    sub_0b6f                                         ; [1699: E8 D3 F4]
    MOV     AX, 4400                                         ; [169C: B8 00 44]
    MOV     CX, 1000                                         ; [169F: B9 00 10]
    CALL    sub_0b6f                                         ; [16A2: E8 CA F4]
    CALL    sub_15f8                                         ; [16A5: E8 50 FF]
    MOV     AX, 07D0                                         ; [16A8: B8 D0 07]
    CALL    busy_loop_delay_ax                               ; [16AB: E8 10 F5]
    MOV     DX, io_i186_dma0_count       ; 80186 DMA 0 Transfer Count ; [16AE: BA C8 FF]
    IN      AX, DX                                           ; [16B1: ED]
    CMP     AX, 0000                                         ; [16B2: 3D 00 00]
    JNZ     loc_16c0                                         ; [16B5: 75 09]
    MOV     DX, io_i186_dma1_count       ; 80186 DMA 1 Transfer Count ; [16B7: BA D8 FF]
    IN      AX, DX                                           ; [16BA: ED]
    CMP     AX, 0000                                         ; [16BB: 3D 00 00]
    JZ      loc_16db                                         ; [16BE: 74 1B]
loc_16c0:
    TEST    WORD [var_boot_status_flags], 0800 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [16C0: F7 06 2D 01 00 08]
    JNZ     loc_16da                                         ; [16C6: 75 12]
    MOV     BYTE [var_selftest_error_flags], 04 ; Selftest error flags buffer ; [16C8: C6 06 20 01 04]
    MOV     WORD [var_selftest_error_subcode], DX            ; [16CD: 89 16 21 01]
    MOV     WORD [var_selftest_error_count], 0000            ; [16D1: C7 06 23 01 00 00]
    MOV     [var_selftest_failing_dev], AX                   ; [16D7: A3 25 01]
loc_16da:
    RETN                                                     ; [16DA: C3]
loc_16db:
    MOV     AX, 0400                                         ; [16DB: B8 00 04]
    MOV     BX, 2400                                         ; [16DE: BB 00 24]
    MOV     CX, 1000                                         ; [16E1: B9 00 10]
    CALL    sub_0b81                                         ; [16E4: E8 9A F4]
    CMP     AL, 00                                           ; [16E7: 3C 00]
    JZ      loc_16f1                                         ; [16E9: 74 06]
loc_16eb:
    MOV     BYTE [var_selftest_error_flags], 03 ; Selftest error flags buffer ; [16EB: C6 06 20 01 03]
loc_16f0:
    RETN                                                     ; [16F0: C3]
loc_16f1:
    MOV     AX, 0400                                         ; [16F1: B8 00 04]
    MOV     BX, 4400                                         ; [16F4: BB 00 44]
    MOV     CX, 1000                                         ; [16F7: B9 00 10]
    CALL    sub_0b81                                         ; [16FA: E8 84 F4]
    CMP     AL, 00                                           ; [16FD: 3C 00]
    JZ      loc_16f0                                         ; [16FF: 74 EF]
    JMPS    loc_16eb                                         ; [1701: EB E8]
    PUSH    AX                                               ; [1703: 50]
    CALL    issue_82730_channel_attention                    ; [1704: E8 DE F3]
    MOV     [var_boot_countdown_sec], AX                     ; [1707: A3 39 01]
    POP     AX                                               ; [170A: 58]
    IRET                                                     ; [170B: CF]
sub_170c:
    STI                                                      ; [170C: FB]
    MOV     AX, C350                                         ; [170D: B8 50 C3]
    CALL    busy_loop_delay_ax                               ; [1710: E8 AB F4]
    CLI                                                      ; [1713: FA]
    TEST    WORD [var_boot_status_flags], 0800 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1714: F7 06 2D 01 00 08]
    JNZ     loc_1737                                         ; [171A: 75 1B]
    MOV     AX, [var_boot_countdown_sec]                     ; [171C: A1 39 01]
    CMP     AX, FFFF                                         ; [171F: 3D FF FF]
    JNZ     loc_172a                                         ; [1722: 75 06]
    MOV     BYTE [var_selftest_error_flags], 06 ; Selftest error flags buffer ; [1724: C6 06 20 01 06]
    RETN                                                     ; [1729: C3]
loc_172a:
    CMP     AX, 0024                                         ; [172A: 3D 24 00]
    JZ      loc_1737                                         ; [172D: 74 08]
    MOV     BYTE [var_selftest_error_flags], 0B ; Selftest error flags buffer ; [172F: C6 06 20 01 0B]
    MOV     [var_selftest_error_subcode], AX                 ; [1734: A3 21 01]
loc_1737:
    RETN                                                     ; [1737: C3]
sub_1738:
    PUSH    DX                                               ; [1738: 52]
    PUSH    AX                                               ; [1739: 50]
    MOV     DX, io_i186_timer2_count     ; 80186 Timer 2 Count register (T2CNT) ; [173A: BA 60 FF]
    MOV     AX, 0000                                         ; [173D: B8 00 00]
    OUT     DX, AX                                           ; [1740: EF]
    MOV     DX, io_i186_timer2_max_a     ; 80186 Timer 2 Max Count A register (T2CMPA) ; [1741: BA 62 FF]
    MOV     AX, 0001                                         ; [1744: B8 01 00]
    OUT     DX, AX                                           ; [1747: EF]
    MOV     DX, io_i186_timer2_ctrl      ; 80186 Timer 2 Mode / Control register (T2CON) ; [1748: BA 66 FF]
    MOV     AX, E000                                         ; [174B: B8 00 E0]
    OUT     DX, AX                                           ; [174E: EF]
    POP     AX                                               ; [174F: 58]
    POP     DX                                               ; [1750: 5A]
    RETN                                                     ; [1751: C3]
sub_1752:
    PUSH    DS                                               ; [1752: 1E]
    PUSH    ES                                               ; [1753: 06]
    MOV     WORD [var_boot_countdown_sec], FFFF              ; [1754: C7 06 39 01 FF FF]
    MOV     AX, [CS:rom_segment_base]                        ; [175A: 2E A1 00 00]
    MOV     DS, AX                                           ; [175E: 8E D8]
    MOV     AX, 0000                                         ; [1760: B8 00 00]
    MOV     ES, AX                                           ; [1763: 8E C0]
    MOV     SI, 2760                                         ; [1765: BE 60 27]
    MOV     DI, 004C                                         ; [1768: BF 4C 00]
    MOV     CX, 0004                                         ; [176B: B9 04 00]
    CLD                                                      ; [176E: FC]
    JMPS    loc_1771                                         ; [176F: EB 00]
loc_1771:
    REP MOVSB                                                ; [1771: F3 A4]
    POP     ES                                               ; [1773: 07]
    POP     DS                                               ; [1774: 1F]
    MOV     DX, io_i186_int_mask         ; 80186 INTC Interrupt Mask register ; [1775: BA 28 FF]
    IN      AX, DX                                           ; [1778: ED]
    PUSH    AX                                               ; [1779: 50]
    MOV     AX, 00FC                                         ; [177A: B8 FC 00]
    OUT     DX, AX                                           ; [177D: EF]
    CALL    sub_1738                                         ; [177E: E8 B7 FF]
    STI                                                      ; [1781: FB]
    MOV     AX, 0FA0                                         ; [1782: B8 A0 0F]
    CALL    busy_loop_delay_ax                               ; [1785: E8 36 F4]
    CLI                                                      ; [1788: FA]
    POP     AX                                               ; [1789: 58]
    MOV     DX, io_i186_int_mask         ; 80186 INTC Interrupt Mask register ; [178A: BA 28 FF]
    OUT     DX, AX                                           ; [178D: EF]
    CALL    setup_interrupt_vectors                          ; [178E: E8 9A F3]
    TEST    WORD [var_boot_status_flags], 0800 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1791: F7 06 2D 01 00 08]
    JNZ     loc_17a6                                         ; [1797: 75 0D]
    MOV     AX, [var_boot_countdown_sec]                     ; [1799: A1 39 01]
    CMP     AX, FFFF                                         ; [179C: 3D FF FF]
    JNZ     loc_17a7                                         ; [179F: 75 06]
    MOV     BYTE [var_selftest_error_flags], 0C ; Selftest error flags buffer ; [17A1: C6 06 20 01 0C]
loc_17a6:
    RETN                                                     ; [17A6: C3]
loc_17a7:
    CMP     AX, 0008                                         ; [17A7: 3D 08 00]
    JZ      loc_17b5                                         ; [17AA: 74 09]
    MOV     BYTE [var_selftest_error_flags], 0D ; Selftest error flags buffer ; [17AC: C6 06 20 01 0D]
    MOV     [var_selftest_error_subcode], AX                 ; [17B1: A3 21 01]
    RETN                                                     ; [17B4: C3]
loc_17b5:
    RETN                                                     ; [17B5: C3]
sub_17b6:
    TEST    WORD [var_boot_status_flags], 0800 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [17B6: F7 06 2D 01 00 08]
    JNZ     loc_17dd                                         ; [17BC: 75 1F]
    MOV     AL, [var_nvram_valid_magic]  ; NVRAM Magic byte 0xAA validation ; [17BE: A0 65 00]
    CMP     AL, AA                                           ; [17C1: 3C AA]
    JNZ     loc_17cf                                         ; [17C3: 75 0A]
    MOV     AX, 27F8                                         ; [17C5: B8 F8 27]
    MOV     CX, 0014                                         ; [17C8: B9 14 00]
    CALL    print_string_es_ax                               ; [17CB: E8 DE EB]
    RETN                                                     ; [17CE: C3]
loc_17cf:
    CMP     AL, 00                                           ; [17CF: 3C 00]
    JZ      loc_17dd                                         ; [17D1: 74 0A]
    MOV     BYTE [var_selftest_error_flags], 11 ; Selftest error flags buffer ; [17D3: C6 06 20 01 11]
    MOV     AH, 00                                           ; [17D8: B4 00]
    MOV     [var_selftest_failing_dev], AX                   ; [17DA: A3 25 01]
loc_17dd:
    RETN                                                     ; [17DD: C3]
    PUSH    AX                                               ; [17DE: 50]
    PUSH    DS                                               ; [17DF: 1E]
    MOV     AX, [CS:ram_segment_base]                        ; [17E0: 2E A1 02 00]
    MOV     DS, AX                                           ; [17E4: 8E D8]
    PUSHA                                                    ; [17E6: 60]
    MOV     BYTE [var_fdc_busy_state], FF                    ; [17E7: C6 06 78 64 FF]
    MOV     BX, 640A                                         ; [17EC: BB 0A 64]
    CMP     BYTE [var_fdc_busy_state], 01                    ; [17EF: 80 3E 78 64 01]
    JZ      loc_1808                                         ; [17F4: 74 12]
    MOV     AX, 0770                                         ; [17F6: B8 70 07]
    MOV     CX, FFFF                                         ; [17F9: B9 FF FF]
loc_17fc:
    TEST    WORD [BX+02], AX                                 ; [17FC: 85 47 02]
    JZ      loc_1808                                         ; [17FF: 74 07]
    LOOP    loc_17fc                                         ; [1801: E2 F9]
    MOV     BYTE [var_fdc_busy_state], 00                    ; [1803: C6 06 78 64 00]
loc_1808:
    MOV     AX, WORD [BX]                                    ; [1808: 8B 07]
    MOV     [var_fdc_status_word], AX                        ; [180A: A3 76 64]
    AND     AX, F000                                         ; [180D: 25 00 F0]
    MOV     CX, WORD [BX+02]                                 ; [1810: 8B 4F 02]
    OR      AX, CX                                           ; [1813: 0B C1]
    MOV     WORD [BX+02], AX                                 ; [1815: 89 47 02]
    MOV     DX, 0100                                         ; [1818: BA 00 01]
    IN      AL, DX                                           ; [181B: EC]
loc_181c:
    MOV     AX, WORD [BX+02]                                 ; [181C: 8B 47 02]
    OR      AX, AX                                           ; [181F: 0B C0]
    JNZ     loc_181c                                         ; [1821: 75 F9]
    CALL    issue_82730_channel_attention                    ; [1823: E8 BF F2]
    POPA                                                     ; [1826: 61]
    POP     DS                                               ; [1827: 1F]
    POP     AX                                               ; [1828: 58]
    IRET                                                     ; [1829: CF]
sub_182a:
    MOV     BYTE [var_fdc_busy_state], 00                    ; [182A: C6 06 78 64 00]
    MOV     DX, 0100                                         ; [182F: BA 00 01]
    IN      AL, DX                                           ; [1832: EC]
    MOV     CX, FFFF                                         ; [1833: B9 FF FF]
sub_1836:
    STI                                                      ; [1836: FB]
    CMP     BYTE [var_fdc_busy_state], FF                    ; [1837: 80 3E 78 64 FF]
    CLI                                                      ; [183C: FA]
    JZ      loc_1849                                         ; [183D: 74 0A]
    LOOP    sub_1836                                         ; [183F: E2 F5]
    MOV     BYTE [var_selftest_error_flags], 27 ; Selftest error flags buffer ; [1841: C6 06 20 01 27]
    MOV     AL, FF                                           ; [1846: B0 FF]
    RETN                                                     ; [1848: C3]
loc_1849:
    MOV     AL, 00                                           ; [1849: B0 00]
    RETN                                                     ; [184B: C3]
sub_184c:
    MOV     WORD [BX], 0000                                  ; [184C: C7 07 00 00]
    MOV     WORD [BX+02], 0080                               ; [1850: C7 47 02 80 00]
    MOV     DX, 0100                                         ; [1855: BA 00 01]
    IN      AL, DX                                           ; [1858: EC]
    MOV     CX, 03E8                                         ; [1859: B9 E8 03]
loc_185c:
    LOOP    loc_185c                                         ; [185C: E2 FE]
    MOV     BX, 640A                                         ; [185E: BB 0A 64]
    MOV     WORD [BX], 0000                                  ; [1861: C7 07 00 00]
    MOV     WORD [BX+02], 0000                               ; [1865: C7 47 02 00 00]
    CALL    sub_182a                                         ; [186A: E8 BD FF]
    RETN                                                     ; [186D: C3]
sub_186e:
    CMP     BYTE [var_boot_retry_counter], FF                ; [186E: 80 3E 5D 00 FF]
    JZ      loc_187f                                         ; [1873: 74 0A]
    MOV     AX, 2817                                         ; [1875: B8 17 28]
    MOV     CX, FFFF                                         ; [1878: B9 FF FF]
    CALL    print_string_es_ax                               ; [187B: E8 2E EB]
    RETN                                                     ; [187E: C3]
loc_187f:
    PUSH    DS                                               ; [187F: 1E]
    PUSH    ES                                               ; [1880: 06]
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [1881: B8 00 30]
    MOV     DS, AX                                           ; [1884: 8E D8]
    MOV     BX, FFF6                                         ; [1886: BB F6 FF]
    MOV     WORD [BX], 0000                                  ; [1889: C7 07 00 00]
    MOV     WORD [BX+06], FFE0                               ; [188D: C7 47 06 E0 FF]
    MOV     WORD [BX+08], 0003                               ; [1892: C7 47 08 03 00]
    MOV     BX, FFE0                                         ; [1897: BB E0 FF]
loc_189a:
    MOV     AX, [CS:ram_segment_base]                        ; [189A: 2E A1 02 00]
    PUSH    AX                                               ; [189E: 50]
    MOV     CL, 0C                                           ; [189F: B1 0C]
    SHR     AX, CL                                           ; [18A1: D3 E8]
    MOV     WORD [BX+06], AX                                 ; [18A3: 89 47 06]
    POP     AX                                               ; [18A6: 58]
    MOV     CL, 04                                           ; [18A7: B1 04]
    SHL     AX, CL                                           ; [18A9: D3 E0]
    MOV     WORD [BX+04], AX                                 ; [18AB: 89 47 04]
    MOV     WORD [BX+02], 640A                               ; [18AE: C7 47 02 0A 64]
    MOV     WORD [BX], 0001                                  ; [18B3: C7 07 01 00]
    CMP     BX, -20                                          ; [18B7: 83 FB E0]
    JNZ     loc_18c6                                         ; [18BA: 75 0A]
    MOV     BX, 6000                                         ; [18BC: BB 00 60]
    MOV     AX, CRT_VRAM_SEGMENT                             ; [18BF: B8 00 D0]
    MOV     DS, AX                                           ; [18C2: 8E D8]
    JMPS    loc_189a                                         ; [18C4: EB D4]
loc_18c6:
    MOV     AX, [CS:ram_segment_base]                        ; [18C6: 2E A1 02 00]
    MOV     ES, AX                                           ; [18CA: 8E C0]
    MOV     AX, [CS:rom_segment_base]                        ; [18CC: 2E A1 00 00]
    MOV     DS, AX                                           ; [18D0: 8E D8]
    MOV     DI, 640A                                         ; [18D2: BF 0A 64]
    MOV     SI, 289B                                         ; [18D5: BE 9B 28]
    MOV     CX, 0010                                         ; [18D8: B9 10 00]
    CLD                                                      ; [18DB: FC]
    REP MOVSB                                                ; [18DC: F3 A4]
    XOR     AX, AX                                           ; [18DE: 33 C0]
    MOV     ES, AX                                           ; [18E0: 8E C0]
    MOV     DI, 0094                                         ; [18E2: BF 94 00]
    MOV     AX, 17DE                                         ; [18E5: B8 DE 17]
    STOSW                                                    ; [18E8: AB]
    MOV     AX, CS                                           ; [18E9: 8C C8]
    STOSW                                                    ; [18EB: AB]
    POP     ES                                               ; [18EC: 07]
    POP     DS                                               ; [18ED: 1F]
    MOV     DX, io_pic_icw2_ocw          ; 8259A PIC ICW2/OCW (Base vector 20h) ; [18EE: BA 02 00]
    IN      AL, DX                                           ; [18F1: EC]
    PUSH    AX                                               ; [18F2: 50]
    MOV     AL, DF                                           ; [18F3: B0 DF]
    OUT     DX, AL                                           ; [18F5: EE]
    MOV     AX, 2400                                         ; [18F6: B8 00 24]
    MOV     CX, 0008                                         ; [18F9: B9 08 00]
    CALL    sub_0b6f                                         ; [18FC: E8 70 F2]
    MOV     BYTE [var_fdc_busy_state], 01                    ; [18FF: C6 06 78 64 01]
    MOV     DX, 0100                                         ; [1904: BA 00 01]
    IN      AL, DX                                           ; [1907: EC]
    MOV     CX, FFFF                                         ; [1908: B9 FF FF]
    CALL    sub_1836                                         ; [190B: E8 28 FF]
    CMP     AL, FF                                           ; [190E: 3C FF]
    JNZ     loc_1915                                         ; [1910: 75 03]
    JMPN    loc_1a17                                         ; [1912: E9 02 01]
loc_1915:
    PUSH    DS                                               ; [1915: 1E]
    PUSH    ES                                               ; [1916: 06]
    POP     DS                                               ; [1917: 1F]
    POP     ES                                               ; [1918: 07]
    MOV     DI, 641A                                         ; [1919: BF 1A 64]
    MOV     SI, 28AB                                         ; [191C: BE AB 28]
    MOV     CX, 0012                                         ; [191F: B9 12 00]
    REP MOVSB                                                ; [1922: F3 A4]
    PUSH    DS                                               ; [1924: 1E]
    PUSH    ES                                               ; [1925: 06]
    POP     DS                                               ; [1926: 1F]
    POP     ES                                               ; [1927: 07]
    MOV     BX, 640A                                         ; [1928: BB 0A 64]
    MOV     WORD [BX], 0000                                  ; [192B: C7 07 00 00]
    MOV     WORD [BX+02], 0100                               ; [192F: C7 47 02 00 01]
    CALL    sub_182a                                         ; [1934: E8 F3 FE]
    CMP     AL, FF                                           ; [1937: 3C FF]
    JNZ     loc_193e                                         ; [1939: 75 03]
    JMPN    loc_1a17                                         ; [193B: E9 D9 00]
loc_193e:
    MOV     BX, 641A                                         ; [193E: BB 1A 64]
    MOV     WORD [BX], 0000                                  ; [1941: C7 07 00 00]
    MOV     WORD [BX+02], E007                               ; [1945: C7 47 02 07 E0]
    MOV     WORD [BX+04], 0000                               ; [194A: C7 47 04 00 00]
    MOV     BX, 640A                                         ; [194F: BB 0A 64]
    MOV     WORD [BX], 0000                                  ; [1952: C7 07 00 00]
    MOV     WORD [BX+02], 0100                               ; [1956: C7 47 02 00 01]
    CALL    sub_182a                                         ; [195B: E8 CC FE]
    CMP     AL, FF                                           ; [195E: 3C FF]
    JNZ     loc_1965                                         ; [1960: 75 03]
    JMPN    loc_1a17                                         ; [1962: E9 B2 00]
loc_1965:
    MOV     BX, 641A                                         ; [1965: BB 1A 64]
    MOV     AX, WORD [BX]                                    ; [1968: 8B 07]
    TEST    AX, 2000                                         ; [196A: A9 00 20]
    JNZ     loc_1972                                         ; [196D: 75 03]
    JMPN    loc_1a40                                         ; [196F: E9 CE 00]
loc_1972:
    MOV     BX, 640A                                         ; [1972: BB 0A 64]
    CALL    sub_184c                                         ; [1975: E8 D4 FE]
    CMP     AL, FF                                           ; [1978: 3C FF]
    JNZ     loc_197f                                         ; [197A: 75 03]
    JMPN    loc_1a17                                         ; [197C: E9 98 00]
loc_197f:
    PUSH    DS                                               ; [197F: 1E]
    PUSH    ES                                               ; [1980: 06]
    POP     DS                                               ; [1981: 1F]
    POP     ES                                               ; [1982: 07]
    MOV     DI, 641A                                         ; [1983: BF 1A 64]
    MOV     SI, 28AB                                         ; [1986: BE AB 28]
    MOV     CX, 0012                                         ; [1989: B9 12 00]
    REP MOVSB                                                ; [198C: F3 A4]
    PUSH    DS                                               ; [198E: 1E]
    PUSH    ES                                               ; [198F: 06]
    POP     DS                                               ; [1990: 1F]
    POP     ES                                               ; [1991: 07]
    IN      AL, io_ppi_portb             ; 8255 PPI Port B (Monitor type 50/60Hz, RTC type) ; [1992: E4 72]
    TEST    AL, 80                                           ; [1994: A8 80]
    JNZ     loc_199f                                         ; [1996: 75 07]
    MOV     BX, 641A                                         ; [1998: BB 1A 64]
    MOV     BYTE [BX+09], 52                                 ; [199B: C6 47 09 52]
loc_199f:
    MOV     BX, 640A                                         ; [199F: BB 0A 64]
    MOV     WORD [BX], 0000                                  ; [19A2: C7 07 00 00]
    MOV     WORD [BX+02], 0100                               ; [19A6: C7 47 02 00 01]
    CALL    sub_182a                                         ; [19AB: E8 7C FE]
    CMP     AL, FF                                           ; [19AE: 3C FF]
    JZ      loc_1a17                                         ; [19B0: 74 65]
    PUSH    DS                                               ; [19B2: 1E]
    PUSH    ES                                               ; [19B3: 06]
    POP     DS                                               ; [19B4: 1F]
    POP     ES                                               ; [19B5: 07]
    MOV     DI, 644C                                         ; [19B6: BF 4C 64]
    MOV     SI, 28D5                                         ; [19B9: BE D5 28]
    MOV     CX, 0020                                         ; [19BC: B9 20 00]
    REP MOVSB                                                ; [19BF: F3 A4]
    MOV     DI, 641A                                         ; [19C1: BF 1A 64]
    MOV     SI, 28BD                                         ; [19C4: BE BD 28]
    MOV     CX, 0010                                         ; [19C7: B9 10 00]
    REP MOVSB                                                ; [19CA: F3 A4]
    MOV     DI, 6438                                         ; [19CC: BF 38 64]
    MOV     SI, 28CD                                         ; [19CF: BE CD 28]
    MOV     CX, 0008                                         ; [19D2: B9 08 00]
    REP MOVSB                                                ; [19D5: F3 A4]
    PUSH    DS                                               ; [19D7: 1E]
    PUSH    ES                                               ; [19D8: 06]
    POP     DS                                               ; [19D9: 1F]
    POP     ES                                               ; [19DA: 07]
    MOV     BX, 640A                                         ; [19DB: BB 0A 64]
    MOV     WORD [BX], 0000                                  ; [19DE: C7 07 00 00]
    MOV     WORD [BX+02], 0110                               ; [19E2: C7 47 02 10 01]
    CALL    sub_182a                                         ; [19E7: E8 40 FE]
    CMP     AL, FF                                           ; [19EA: 3C FF]
    JZ      loc_1a17                                         ; [19EC: 74 29]
    MOV     BX, 641A                                         ; [19EE: BB 1A 64]
    MOV     AX, WORD [BX]                                    ; [19F1: 8B 07]
    TEST    AX, 2000                                         ; [19F3: A9 00 20]
    JZ      loc_1a53                                         ; [19F6: 74 5B]
    MOV     BX, 644C                                         ; [19F8: BB 4C 64]
    MOV     AX, WORD [BX]                                    ; [19FB: 8B 07]
    TEST    AX, 2000                                         ; [19FD: A9 00 20]
    JZ      loc_1a66                                         ; [1A00: 74 64]
    MOV     AX, 0400                                         ; [1A02: B8 00 04]
    MOV     BX, 2400                                         ; [1A05: BB 00 24]
    MOV     CX, 0008                                         ; [1A08: B9 08 00]
    CALL    sub_0b81                                         ; [1A0B: E8 73 F1]
    CMP     AL, 00                                           ; [1A0E: 3C 00]
    JZ      loc_1a17                                         ; [1A10: 74 05]
    MOV     BYTE [var_selftest_error_flags], 26 ; Selftest error flags buffer ; [1A12: C6 06 20 01 26]
loc_1a17:
    MOV     BX, 640A                                         ; [1A17: BB 0A 64]
    MOV     WORD [BX], 0000                                  ; [1A1A: C7 07 00 00]
    MOV     WORD [BX+02], 0080                               ; [1A1E: C7 47 02 80 00]
    MOV     DX, 0100                                         ; [1A23: BA 00 01]
    IN      AL, DX                                           ; [1A26: EC]
    STI                                                      ; [1A27: FB]
    MOV     CX, 0FA0                                         ; [1A28: B9 A0 0F]
loc_1a2b:
    LOOP    loc_1a2b                                         ; [1A2B: E2 FE]
    CLI                                                      ; [1A2D: FA]
    CMP     BYTE [var_selftest_error_flags], 05 ; Selftest error flags buffer ; [1A2E: 80 3E 20 01 05]
    JNZ     loc_1a3a                                         ; [1A33: 75 05]
    MOV     BYTE [var_selftest_error_flags], 00 ; Selftest error flags buffer ; [1A35: C6 06 20 01 00]
loc_1a3a:
    MOV     DX, io_pic_icw2_ocw          ; 8259A PIC ICW2/OCW (Base vector 20h) ; [1A3A: BA 02 00]
    POP     AX                                               ; [1A3D: 58]
    OUT     DX, AL                                           ; [1A3E: EE]
    RETN                                                     ; [1A3F: C3]
loc_1a40:
    TEST    WORD [var_boot_status_flags], 0800 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1A40: F7 06 2D 01 00 08]
    JNZ     loc_1a17                                         ; [1A46: 75 CF]
    MOV     BYTE [var_selftest_error_flags], 24 ; Selftest error flags buffer ; [1A48: C6 06 20 01 24]
    MOV     [var_selftest_failing_dev], AX                   ; [1A4D: A3 25 01]
    JMPN    loc_1a17                                         ; [1A50: E9 C4 FF]
loc_1a53:
    TEST    WORD [var_boot_status_flags], 0800 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1A53: F7 06 2D 01 00 08]
    JNZ     loc_1a17                                         ; [1A59: 75 BC]
    MOV     BYTE [var_selftest_error_flags], 25 ; Selftest error flags buffer ; [1A5B: C6 06 20 01 25]
    MOV     [var_selftest_failing_dev], AX                   ; [1A60: A3 25 01]
    JMPN    loc_1a17                                         ; [1A63: E9 B1 FF]
loc_1a66:
    TEST    WORD [var_boot_status_flags], 0800 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1A66: F7 06 2D 01 00 08]
    JNZ     loc_1a17                                         ; [1A6C: 75 A9]
    MOV     BYTE [var_selftest_error_flags], 28 ; Selftest error flags buffer ; [1A6E: C6 06 20 01 28]
    MOV     [var_selftest_failing_dev], AX                   ; [1A73: A3 25 01]
    JMPN    loc_1a17                                         ; [1A76: E9 9E FF]
sub_1a79:
    MOV     DX, io_ppi_portc             ; 8255 PPI Port C (Kbd enable, Gfx mode, NVRAM bank) ; [1A79: BA 74 00]
    IN      AL, DX                                           ; [1A7C: EC]
    PUSH    AX                                               ; [1A7D: 50]
    MOV     BL, C0                                           ; [1A7E: B3 C0]
loc_1a80:
    MOV     AL, BL                                           ; [1A80: 8A C3]
    OUT     DX, AL                                           ; [1A82: EE]
    NOT     AL                                               ; [1A83: F6 D0]
    IN      AL, DX                                           ; [1A85: EC]
    CMP     AL, BL                                           ; [1A86: 3A C3]
    JNZ     loc_1ac0                                         ; [1A88: 75 36]
    AND     BL, 3F                                           ; [1A8A: 80 E3 3F]
    SHL     BL, 1                                            ; [1A8D: D0 E3]
    AND     BL, 3F                                           ; [1A8F: 80 E3 3F]
    ADD     BL, C0                                           ; [1A92: 80 C3 C0]
    CMP     BL, C0                                           ; [1A95: 80 FB C0]
    JNZ     loc_1a80                                         ; [1A98: 75 E6]
    MOV     BL, FE                                           ; [1A9A: B3 FE]
loc_1a9c:
    MOV     AL, BL                                           ; [1A9C: 8A C3]
    OUT     DX, AL                                           ; [1A9E: EE]
    NOT     AL                                               ; [1A9F: F6 D0]
    IN      AL, DX                                           ; [1AA1: EC]
    CMP     AL, BL                                           ; [1AA2: 3A C3]
    JNZ     loc_1ac0                                         ; [1AA4: 75 1A]
    AND     BL, 3F                                           ; [1AA6: 80 E3 3F]
    ADD     BL, C0                                           ; [1AA9: 80 C3 C0]
    SHL     BL, 1                                            ; [1AAC: D0 E3]
    AND     BL, 3E                                           ; [1AAE: 80 E3 3E]
    ADD     BL, C1                                           ; [1AB1: 80 C3 C1]
    CMP     BL, FF                                           ; [1AB4: 80 FB FF]
    JNZ     loc_1a9c                                         ; [1AB7: 75 E3]
loc_1ab9:
    POP     AX                                               ; [1AB9: 58]
    OUT     DX, AL                                           ; [1ABA: EE]
    MOV     DX, io_i82730_reset          ; Intel 82730 CRT Text Coprocessor Reset (IRST) ; [1ABB: BA 30 02]
    OUT     DX, AX                                           ; [1ABE: EF]
    RETN                                                     ; [1ABF: C3]
loc_1ac0:
    TEST    WORD [var_boot_status_flags], 0400 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1AC0: F7 06 2D 01 00 04]
    JNZ     loc_1ab9                                         ; [1AC6: 75 F1]
    MOV     BYTE [var_selftest_error_flags], 12 ; Selftest error flags buffer ; [1AC8: C6 06 20 01 12]
    MOV     AH, 00                                           ; [1ACD: B4 00]
    MOV     BH, 00                                           ; [1ACF: B7 00]
    MOV     WORD [var_selftest_error_count], BX              ; [1AD1: 89 1E 23 01]
    MOV     [var_selftest_failing_dev], AX                   ; [1AD5: A3 25 01]
    JMPS    loc_1ab9                                         ; [1AD8: EB DF]
sub_1ada:
    CALL    sub_3dba                                         ; [1ADA: E8 DD 22]
    CMP     BL, AA                                           ; [1ADD: 80 FB AA]
    JZ      loc_1af5                                         ; [1AE0: 74 13]
    TEST    WORD [var_boot_status_flags], 0400 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1AE2: F7 06 2D 01 00 04]
    JNZ     loc_1af5                                         ; [1AE8: 75 0B]
    MOV     BYTE [var_selftest_error_flags], 13 ; Selftest error flags buffer ; [1AEA: C6 06 20 01 13]
    MOV     BH, 00                                           ; [1AEF: B7 00]
    MOV     WORD [var_selftest_failing_dev], BX              ; [1AF1: 89 1E 25 01]
loc_1af5:
    RETN                                                     ; [1AF5: C3]
sub_1af6:
    TEST    WORD [var_boot_status_flags], 1000 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1AF6: F7 06 2D 01 00 10]
    JNZ     loc_1b1d                                         ; [1AFC: 75 1F]
    MOV     DX, io_centronics_ctrl       ; Centronics Printer Control register ; [1AFE: BA 60 02]
    MOV     BX, 2973                                         ; [1B01: BB 73 29]
    MOV     CX, 0004                                         ; [1B04: B9 04 00]
loc_1b07:
    MOV     AL, BYTE [ES:BX]                                 ; [1B07: 26 8A 07]
    OUT     DX, AL                                           ; [1B0A: EE]
    MOV     AX, 000F                                         ; [1B0B: B8 0F 00]
    CALL    timer_tick_wait_ax                               ; [1B0E: E8 B7 F0]
    INC     BX                                               ; [1B11: 43]
    IN      AL, DX                                           ; [1B12: EC]
    AND     AL, 60                                           ; [1B13: 24 60]
    CMP     AL, BYTE [ES:BX]                                 ; [1B15: 26 3A 07]
    JNZ     loc_1b5b                                         ; [1B18: 75 41]
    INC     BX                                               ; [1B1A: 43]
    LOOP    loc_1b07                                         ; [1B1B: E2 EA]
loc_1b1d:
    MOV     DX, io_centronics_data       ; Centronics Printer Data register ; [1B1D: BA 50 02]
    MOV     BL, 00                                           ; [1B20: B3 00]
loc_1b22:
    MOV     AL, BL                                           ; [1B22: 8A C3]
    OUT     DX, AL                                           ; [1B24: EE]
    MOV     AX, [var_timer0_tick_count]  ; Timer 0 tick counter (incremented by timer ISR) ; [1B25: A1 35 01]
    IN      AL, DX                                           ; [1B28: EC]
    CMP     AL, BL                                           ; [1B29: 3A C3]
    JNZ     loc_1b6f                                         ; [1B2B: 75 42]
    CMP     BL, 00                                           ; [1B2D: 80 FB 00]
    JNZ     loc_1b36                                         ; [1B30: 75 04]
    MOV     BL, 01                                           ; [1B32: B3 01]
    JMPS    loc_1b22                                         ; [1B34: EB EC]
loc_1b36:
    SHL     BL, 1                                            ; [1B36: D0 E3]
    JNC     loc_1b22                                         ; [1B38: 73 E8]
    MOV     BL, FF                                           ; [1B3A: B3 FF]
loc_1b3c:
    MOV     AL, BL                                           ; [1B3C: 8A C3]
    OUT     DX, AL                                           ; [1B3E: EE]
    MOV     AX, [var_timer0_tick_count]  ; Timer 0 tick counter (incremented by timer ISR) ; [1B3F: A1 35 01]
    IN      AL, DX                                           ; [1B42: EC]
    CMP     AL, BL                                           ; [1B43: 3A C3]
    JNZ     loc_1b6f                                         ; [1B45: 75 28]
    CMP     BL, FF                                           ; [1B47: 80 FB FF]
    JNZ     loc_1b50                                         ; [1B4A: 75 04]
    MOV     BL, FE                                           ; [1B4C: B3 FE]
    JMPS    loc_1b3c                                         ; [1B4E: EB EC]
loc_1b50:
    SHL     BL, 1                                            ; [1B50: D0 E3]
    JC      loc_1b3c                                         ; [1B52: 72 E8]
loc_1b54:
    MOV     DX, io_centronics_ctrl       ; Centronics Printer Control register ; [1B54: BA 60 02]
    XOR     AL, AL                                           ; [1B57: 32 C0]
    OUT     DX, AL                                           ; [1B59: EE]
    RETN                                                     ; [1B5A: C3]
loc_1b5b:
    TEST    WORD [var_boot_status_flags], 0800 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1B5B: F7 06 2D 01 00 08]
    JNZ     loc_1b1d                                         ; [1B61: 75 BA]
    MOV     AH, BYTE [ES:BX]                                 ; [1B63: 26 8A 27]
    MOV     BL, AH                                           ; [1B66: 8A DC]
    MOV     BYTE [var_selftest_error_flags], 18 ; Selftest error flags buffer ; [1B68: C6 06 20 01 18]
    JMPS    loc_1b7c                                         ; [1B6D: EB 0D]
loc_1b6f:
    TEST    WORD [var_boot_status_flags], 0400 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1B6F: F7 06 2D 01 00 04]
    JNZ     loc_1b54                                         ; [1B75: 75 DD]
    MOV     BYTE [var_selftest_error_flags], 19 ; Selftest error flags buffer ; [1B77: C6 06 20 01 19]
loc_1b7c:
    XOR     AH, AH                                           ; [1B7C: 32 E4]
    XOR     BH, BH                                           ; [1B7E: 32 FF]
    MOV     WORD [var_selftest_error_count], BX              ; [1B80: 89 1E 23 01]
    MOV     [var_selftest_failing_dev], AX                   ; [1B84: A3 25 01]
    JMPS    loc_1b54                                         ; [1B87: EB CB]
sub_1b89:
    MOV     DX, io_ppi_ctrl              ; 8255 PPI Control word (Mode setup) ; [1B89: BA 76 00]
    MOV     AL, 03                                           ; [1B8C: B0 03]
    OUT     DX, AL                                           ; [1B8E: EE]
    MOV     AL, 00                                           ; [1B8F: B0 00]
    OUT     DX, AL                                           ; [1B91: EE]
    MOV     DX, io_i186_timer0_max_a     ; 80186 Timer 0 Max Count A register (T0CMPA) ; [1B92: BA 52 FF]
    MOV     AX, 02EE                                         ; [1B95: B8 EE 02]
    OUT     DX, AX                                           ; [1B98: EF]
    MOV     DX, io_i186_timer0_max_b     ; 80186 Timer 0 Max Count B register (T0CMPB) ; [1B99: BA 54 FF]
    MOV     AX, 02EE                                         ; [1B9C: B8 EE 02]
    OUT     DX, AX                                           ; [1B9F: EF]
    MOV     DX, io_i186_timer0_ctrl      ; 80186 Timer 0 Mode / Control register (T0CON) ; [1BA0: BA 56 FF]
    MOV     AX, C013                                         ; [1BA3: B8 13 C0]
    OUT     DX, AX                                           ; [1BA6: EF]
    MOV     DX, io_ppi_ctrl              ; 8255 PPI Control word (Mode setup) ; [1BA7: BA 76 00]
    MOV     AL, 01                                           ; [1BAA: B0 01]
    OUT     DX, AL                                           ; [1BAC: EE]
    MOV     CX, 0028                                         ; [1BAD: B9 28 00]
    MOV     DX, io_i186_timer0_ctrl      ; 80186 Timer 0 Mode / Control register (T0CON) ; [1BB0: BA 56 FF]
loc_1bb3:
    IN      AX, DX                                           ; [1BB3: ED]
    TEST    AL, 20                                           ; [1BB4: A8 20]
    JZ      loc_1bb3                                         ; [1BB6: 74 FB]
    MOV     AX, C013                                         ; [1BB8: B8 13 C0]
    OUT     DX, AX                                           ; [1BBB: EF]
    LOOP    loc_1bb3                                         ; [1BBC: E2 F5]
    MOV     CX, 00C8                                         ; [1BBE: B9 C8 00]
loc_1bc1:
    MOV     DX, io_i186_timer0_count     ; 80186 Timer 0 Count register (T0CNT) ; [1BC1: BA 50 FF]
loc_1bc4:
    IN      AX, DX                                           ; [1BC4: ED]
    CMP     AX, 0177                                         ; [1BC5: 3D 77 01]
    JC      loc_1bc4                                         ; [1BC8: 72 FA]
    MOV     DX, io_i186_timer0_ctrl      ; 80186 Timer 0 Mode / Control register (T0CON) ; [1BCA: BA 56 FF]
    IN      AX, DX                                           ; [1BCD: ED]
    MOV     BL, 01                                           ; [1BCE: B3 01]
    AND     AH, 10                                           ; [1BD0: 80 E4 10]
    CMP     AH, 10                                           ; [1BD3: 80 FC 10]
    JZ      loc_1bda                                         ; [1BD6: 74 02]
    MOV     BL, 00                                           ; [1BD8: B3 00]
loc_1bda:
    MOV     DX, io_ppi_porta             ; 8255 PPI Port A (Memory size, Cassette, iSBX) ; [1BDA: BA 70 00]
    MOV     AH, 00                                           ; [1BDD: B4 00]
    IN      AL, DX                                           ; [1BDF: EC]
    AND     AL, 01                                           ; [1BE0: 24 01]
    CMP     AL, BL                                           ; [1BE2: 3A C3]
    JNZ     loc_1bfe                                         ; [1BE4: 75 18]
    MOV     DX, io_i186_timer0_ctrl      ; 80186 Timer 0 Mode / Control register (T0CON) ; [1BE6: BA 56 FF]
    MOV     AX, C013                                         ; [1BE9: B8 13 C0]
    OUT     DX, AX                                           ; [1BEC: EF]
loc_1bed:
    IN      AX, DX                                           ; [1BED: ED]
    TEST    AL, 20                                           ; [1BEE: A8 20]
    JZ      loc_1bed                                         ; [1BF0: 74 FB]
    LOOP    loc_1bc1                                         ; [1BF2: E2 CD]
    JMPN    loc_1c16                                         ; [1BF4: E9 1F 00]
loc_1bf7:
    MOV     DX, io_ppi_ctrl              ; 8255 PPI Control word (Mode setup) ; [1BF7: BA 76 00]
    MOV     AL, 00                                           ; [1BFA: B0 00]
    OUT     DX, AL                                           ; [1BFC: EE]
    RETN                                                     ; [1BFD: C3]
loc_1bfe:
    TEST    WORD [var_boot_status_flags], 0400 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1BFE: F7 06 2D 01 00 04]
    JNZ     loc_1bf7                                         ; [1C04: 75 F1]
    MOV     BYTE [var_selftest_error_flags], 20 ; Selftest error flags buffer ; [1C06: C6 06 20 01 20]
loc_1c0b:
    MOV     BH, 00                                           ; [1C0B: B7 00]
    MOV     WORD [var_selftest_error_count], BX              ; [1C0D: 89 1E 23 01]
    MOV     [var_selftest_failing_dev], AX                   ; [1C11: A3 25 01]
    JMPS    loc_1bf7                                         ; [1C14: EB E1]
loc_1c16:
    MOV     DX, io_ppi_porta             ; 8255 PPI Port A (Memory size, Cassette, iSBX) ; [1C16: BA 70 00]
    IN      AL, DX                                           ; [1C19: EC]
    AND     AL, 01                                           ; [1C1A: 24 01]
    MOV     BL, AL                                           ; [1C1C: 8A D8]
loc_1c1e:
    IN      AL, DX                                           ; [1C1E: EC]
    AND     AL, 01                                           ; [1C1F: 24 01]
    CMP     BL, AL                                           ; [1C21: 3A D8]
    JZ      loc_1c1e                                         ; [1C23: 74 F9]
    MOV     DX, io_i186_timer0_count     ; 80186 Timer 0 Count register (T0CNT) ; [1C25: BA 50 FF]
    IN      AX, DX                                           ; [1C28: ED]
    MOV     BX, 0000                                         ; [1C29: BB 00 00]
    CMP     AX, 0118                                         ; [1C2C: 3D 18 01]
    JNC     loc_1c34                                         ; [1C2F: 73 03]
    JMPN    loc_1bf7                                         ; [1C31: E9 C3 FF]
loc_1c34:
    TEST    WORD [var_boot_status_flags], 0400 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1C34: F7 06 2D 01 00 04]
    JNZ     loc_1bf7                                         ; [1C3A: 75 BB]
    MOV     BYTE [var_selftest_error_flags], 21 ; Selftest error flags buffer ; [1C3C: C6 06 20 01 21]
    JMPN    loc_1c0b                                         ; [1C41: E9 C7 FF]
sub_1c44:
    MOV     CX, 000A                                         ; [1C44: B9 0A 00]
loc_1c47:
    STI                                                      ; [1C47: FB]
    MOV     AX, C350                                         ; [1C48: B8 50 C3]
    CALL    busy_loop_delay_ax                               ; [1C4B: E8 70 EF]
    CLI                                                      ; [1C4E: FA]
    LOOP    loc_1c47                                         ; [1C4F: E2 F6]
    CMP     BYTE [var_kbd_ascii_char], 31 ; Keyboard ASCII char buffer ; [1C51: 80 3E 33 01 31]
    JZ      sub_1c44                                         ; [1C56: 74 EC]
    RETN                                                     ; [1C58: C3]
sub_1c59:
    MOV     AX, [var_boot_status_flags]  ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1C59: A1 2D 01]
    PUSH    AX                                               ; [1C5C: 50]
    AND     AX, 7FFF                                         ; [1C5D: 25 FF 7F]
    MOV     [var_boot_status_flags], AX  ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1C60: A3 2D 01]
    CALL    mute_sound_chip                                  ; [1C63: E8 D0 F7]
    CALL    sub_0267                                         ; [1C66: E8 FE E5]
    PUSH    AX                                               ; [1C69: 50]
    MOV     AL, 00                                           ; [1C6A: B0 00]
    MOV     AH, 30                                           ; [1C6C: B4 30]
    CALL    set_cursor_pos                                   ; [1C6E: E8 08 E6]
    MOV     AX, 29B0                                         ; [1C71: B8 B0 29]
    MOV     CX, 001C                                         ; [1C74: B9 1C 00]
    CALL    print_string_es_ax                               ; [1C77: E8 32 E7]
    POP     AX                                               ; [1C7A: 58]
    CALL    set_cursor_pos                                   ; [1C7B: E8 FB E5]
    MOV     CX, 00F0                                         ; [1C7E: B9 F0 00]
loc_1c81:
    MOV     BX, 01DD                                         ; [1C81: BB DD 01]
    MOV     SI, 000B                                         ; [1C84: BE 0B 00]
    MOV     DX, io_ppi_portb             ; 8255 PPI Port B (Monitor type 50/60Hz, RTC type) ; [1C87: BA 72 00]
    IN      AL, DX                                           ; [1C8A: EC]
    AND     AL, 40                                           ; [1C8B: 24 40]
    JZ      loc_1c95                                         ; [1C8D: 74 06]
    MOV     BX, 0D40                                         ; [1C8F: BB 40 0D]
    MOV     SI, 000F                                         ; [1C92: BE 0F 00]
loc_1c95:
    MOV     AL, BYTE [ES:BX]                                 ; [1C95: 26 8A 07]
    CMP     AL, 00                                           ; [1C98: 3C 00]
    JZ      loc_1ca3                                         ; [1C9A: 74 07]
    CALL    conout_char                                      ; [1C9C: E8 F9 E5]
    ADD     BX, SI                                           ; [1C9F: 03 DE]
    JMPS    loc_1c95                                         ; [1CA1: EB F2]
loc_1ca3:
    MOV     SI, 001D                                         ; [1CA3: BE 1D 00]
    INC     BX                                               ; [1CA6: 43]
loc_1ca7:
    MOV     AX, WORD [ES:BX]                                 ; [1CA7: 26 8B 07]
    CMP     AX, 0000                                         ; [1CAA: 3D 00 00]
    JZ      loc_1cb9                                         ; [1CAD: 74 0A]
    MOV     AL, BYTE [ES:BX]                                 ; [1CAF: 26 8A 07]
    CALL    conout_char                                      ; [1CB2: E8 E3 E5]
    ADD     BX, SI                                           ; [1CB5: 03 DE]
    JMPS    loc_1ca7                                         ; [1CB7: EB EE]
loc_1cb9:
    LOOP    loc_1c81                                         ; [1CB9: E2 C6]
    CALL    sub_1c44                                         ; [1CBB: E8 86 FF]
    MOV     CX, 0812                                         ; [1CBE: B9 12 08]
    MOV     AL, 48                                           ; [1CC1: B0 48]
loc_1cc3:
    CALL    conout_char                                      ; [1CC3: E8 D2 E5]
    LOOP    loc_1cc3                                         ; [1CC6: E2 FB]
    CALL    sub_1c44                                         ; [1CC8: E8 79 FF]
    MOV     BX, 0000                                         ; [1CCB: BB 00 00]
    MOV     CX, 0020                                         ; [1CCE: B9 20 00]
    MOV     AL, F0                                           ; [1CD1: B0 F0]
loc_1cd3:
    MOV     DX, io_palette_base          ; Palette RAM base (180h - 19Fh) ; [1CD3: BA 80 01]
    ADD     DX, BX                                           ; [1CD6: 03 D3]
    OUT     DX, AL                                           ; [1CD8: EE]
    INC     AL                                               ; [1CD9: FE C0]
    INC     BX                                               ; [1CDB: 43]
    INC     BX                                               ; [1CDC: 43]
    SUB     AL, 10                                           ; [1CDD: 2C 10]
    LOOP    loc_1cd3                                         ; [1CDF: E2 F2]
    MOV     CX, 001A                                         ; [1CE1: B9 1A 00]
loc_1ce4:
    PUSH    CX                                               ; [1CE4: 51]
    CALL    wait_key_press                                   ; [1CE5: E8 E1 E6]
    POP     CX                                               ; [1CE8: 59]
    LOOP    loc_1ce4                                         ; [1CE9: E2 F9]
    PUSH    ES                                               ; [1CEB: 06]
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [1CEC: B8 00 30]
    MOV     ES, AX                                           ; [1CEF: 8E C0]
    MOV     BX, 4000                                         ; [1CF1: BB 00 40]
    ADD     BX, 0280                                         ; [1CF4: 81 C3 80 02]
    XOR     AH, AH                                           ; [1CF8: 32 E4]
    MOV     CX, 0020                                         ; [1CFA: B9 20 00]
loc_1cfd:
    PUSH    CX                                               ; [1CFD: 51]
    MOV     CX, 0004                                         ; [1CFE: B9 04 00]
loc_1d01:
    PUSH    CX                                               ; [1D01: 51]
    MOV     AL, 30                                           ; [1D02: B0 30]
    MOV     CX, 000A                                         ; [1D04: B9 0A 00]
loc_1d07:
    MOV     WORD [ES:BX+04], AX                              ; [1D07: 26 89 47 04]
    INC     AL                                               ; [1D0B: FE C0]
    INC     BX                                               ; [1D0D: 43]
    INC     BX                                               ; [1D0E: 43]
    LOOP    loc_1d07                                         ; [1D0F: E2 F6]
    POP     CX                                               ; [1D11: 59]
    LOOP    loc_1d01                                         ; [1D12: E2 ED]
    ADD     AH, 04                                           ; [1D14: 80 C4 04]
    POP     CX                                               ; [1D17: 59]
    LOOP    loc_1cfd                                         ; [1D18: E2 E3]
    POP     ES                                               ; [1D1A: 07]
    CALL    sub_1c44                                         ; [1D1B: E8 26 FF]
    PUSH    ES                                               ; [1D1E: 06]
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [1D1F: B8 00 30]
    MOV     ES, AX                                           ; [1D22: 8E C0]
    MOV     DI, 4000                                         ; [1D24: BF 00 40]
    ADD     DI, 00A0                                         ; [1D27: 81 C7 A0 00]
    MOV     CX, 0730                                         ; [1D2B: B9 30 07]
    XOR     AX, AX                                           ; [1D2E: 33 C0]
    CLD                                                      ; [1D30: FC]
    REP STOSW                                                ; [1D31: F3 AB]
    POP     ES                                               ; [1D33: 07]
    MOV     CX, 07D0                                         ; [1D34: B9 D0 07]
loc_1d37:
    MOV     AL, FF                                           ; [1D37: B0 FF]
    CALL    conout_char                                      ; [1D39: E8 5C E5]
    MOV     AL, 37                                           ; [1D3C: B0 37]
    CALL    conout_char                                      ; [1D3E: E8 57 E5]
    MOV     AL, 35                                           ; [1D41: B0 35]
    CALL    conout_char                                      ; [1D43: E8 52 E5]
    MOV     AL, 39                                           ; [1D46: B0 39]
    CALL    conout_char                                      ; [1D48: E8 4D E5]
    LOOP    loc_1d37                                         ; [1D4B: E2 EA]
    CALL    sub_1c44                                         ; [1D4D: E8 F4 FE]
    MOV     DX, io_ppi_ctrl              ; 8255 PPI Control word (Mode setup) ; [1D50: BA 76 00]
    MOV     AL, 0C                                           ; [1D53: B0 0C]
    OUT     DX, AL                                           ; [1D55: EE]
    CALL    sub_1c44                                         ; [1D56: E8 EB FE]
    MOV     CX, 001A                                         ; [1D59: B9 1A 00]
loc_1d5c:
    PUSH    CX                                               ; [1D5C: 51]
    CALL    wait_key_press                                   ; [1D5D: E8 69 E6]
    POP     CX                                               ; [1D60: 59]
    LOOP    loc_1d5c                                         ; [1D61: E2 F9]
    CALL    sub_1c44                                         ; [1D63: E8 DE FE]
    MOV     DX, io_ppi_ctrl              ; 8255 PPI Control word (Mode setup) ; [1D66: BA 76 00]
    MOV     AL, 0D                                           ; [1D69: B0 0D]
    OUT     DX, AL                                           ; [1D6B: EE]
    CALL    mute_sound_chip                                  ; [1D6C: E8 C7 F6]
    MOV     BX, 0000                                         ; [1D6F: BB 00 00]
    MOV     CX, 0010                                         ; [1D72: B9 10 00]
    MOV     AL, F0                                           ; [1D75: B0 F0]
loc_1d77:
    MOV     DX, io_palette_base          ; Palette RAM base (180h - 19Fh) ; [1D77: BA 80 01]
    ADD     DX, BX                                           ; [1D7A: 03 D3]
    OUT     DX, AL                                           ; [1D7C: EE]
    NOT     AL                                               ; [1D7D: F6 D0]
    INC     BX                                               ; [1D7F: 43]
    INC     BX                                               ; [1D80: 43]
    LOOP    loc_1d77                                         ; [1D81: E2 F4]
    POP     AX                                               ; [1D83: 58]
    MOV     [var_boot_status_flags], AX  ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1D84: A3 2D 01]
    RETN                                                     ; [1D87: C3]
sub_1d88:
    CMP     BYTE [var_boot_head_settle], FF                  ; [1D88: 80 3E 5F 00 FF]
    JZ      loc_1d99                                         ; [1D8D: 74 0A]
    MOV     AX, 25E3                                         ; [1D8F: B8 E3 25]
    MOV     CX, 0011                                         ; [1D92: B9 11 00]
    CALL    print_string_es_ax                               ; [1D95: E8 14 E6]
    RETN                                                     ; [1D98: C3]
loc_1d99:
    MOV     DX, io_floppy_status_aux     ; Floppy Auxiliary Status register ; [1D99: BA 92 02]
    OUT     DX, AL                                           ; [1D9C: EE]
    MOV     CX, 0032                                         ; [1D9D: B9 32 00]
loc_1da0:
    MOV     DX, io_floppy_status_aux     ; Floppy Auxiliary Status register ; [1DA0: BA 92 02]
    MOV     AL, FF                                           ; [1DA3: B0 FF]
    OUT     DX, AL                                           ; [1DA5: EE]
    IN      AL, DX                                           ; [1DA6: EC]
    TEST    AL, 80                                           ; [1DA7: A8 80]
    JZ      loc_1dc2                                         ; [1DA9: 74 17]
    MOV     AX, 0001                                         ; [1DAB: B8 01 00]
    CALL    timer_tick_wait_ax                               ; [1DAE: E8 17 EE]
    DEC     CX                                               ; [1DB1: 49]
    JNZ     loc_1da0                                         ; [1DB2: 75 EC]
    MOV     AX, 25C9                                         ; [1DB4: B8 C9 25]
    MOV     CX, 001A                                         ; [1DB7: B9 1A 00]
    CALL    print_string_es_ax                               ; [1DBA: E8 EF E5]
    MOV     DX, io_floppy_param          ; Floppy Parameter register ; [1DBD: BA 94 02]
    OUT     DX, AL                                           ; [1DC0: EE]
    RETN                                                     ; [1DC1: C3]
loc_1dc2:
    TEST    WORD [var_boot_status_flags], 1000 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1DC2: F7 06 2D 01 00 10]
    JNZ     loc_1de9                                         ; [1DC8: 75 1F]
    MOV     DX, io_floppy_ext            ; Floppy Extended register ; [1DCA: BA 8C 02]
    MOV     BX, 2A07                                         ; [1DCD: BB 07 2A]
    MOV     CX, 0004                                         ; [1DD0: B9 04 00]
loc_1dd3:
    MOV     AL, BYTE [ES:BX]                                 ; [1DD3: 26 8A 07]
    OUT     DX, AL                                           ; [1DD6: EE]
    MOV     AX, 000F                                         ; [1DD7: B8 0F 00]
    CALL    timer_tick_wait_ax                               ; [1DDA: E8 EB ED]
    INC     BX                                               ; [1DDD: 43]
    IN      AL, DX                                           ; [1DDE: EC]
    AND     AL, 60                                           ; [1DDF: 24 60]
    CMP     AL, BYTE [ES:BX]                                 ; [1DE1: 26 3A 07]
    JNZ     loc_1e2b                                         ; [1DE4: 75 45]
    INC     BX                                               ; [1DE6: 43]
    LOOP    loc_1dd3                                         ; [1DE7: E2 EA]
loc_1de9:
    MOV     DX, 028A                                         ; [1DE9: BA 8A 02]
    MOV     BL, 00                                           ; [1DEC: B3 00]
loc_1dee:
    MOV     AL, BL                                           ; [1DEE: 8A C3]
    OUT     DX, AL                                           ; [1DF0: EE]
    MOV     AX, [var_timer0_tick_count]  ; Timer 0 tick counter (incremented by timer ISR) ; [1DF1: A1 35 01]
    IN      AL, DX                                           ; [1DF4: EC]
    CMP     AL, BL                                           ; [1DF5: 3A C3]
    JNZ     loc_1e3f                                         ; [1DF7: 75 46]
    CMP     BL, 00                                           ; [1DF9: 80 FB 00]
    JNZ     loc_1e02                                         ; [1DFC: 75 04]
    MOV     BL, 01                                           ; [1DFE: B3 01]
    JMPS    loc_1dee                                         ; [1E00: EB EC]
loc_1e02:
    SHL     BL, 1                                            ; [1E02: D0 E3]
    JNC     loc_1dee                                         ; [1E04: 73 E8]
    MOV     BL, FF                                           ; [1E06: B3 FF]
loc_1e08:
    MOV     AL, BL                                           ; [1E08: 8A C3]
    OUT     DX, AL                                           ; [1E0A: EE]
    MOV     AX, [var_timer0_tick_count]  ; Timer 0 tick counter (incremented by timer ISR) ; [1E0B: A1 35 01]
    IN      AL, DX                                           ; [1E0E: EC]
    CMP     AL, BL                                           ; [1E0F: 3A C3]
    JNZ     loc_1e3f                                         ; [1E11: 75 2C]
    CMP     BL, FF                                           ; [1E13: 80 FB FF]
    JNZ     loc_1e1c                                         ; [1E16: 75 04]
    MOV     BL, FE                                           ; [1E18: B3 FE]
    JMPS    loc_1e08                                         ; [1E1A: EB EC]
loc_1e1c:
    SHL     BL, 1                                            ; [1E1C: D0 E3]
    JC      loc_1e08                                         ; [1E1E: 72 E8]
loc_1e20:
    MOV     DX, io_floppy_ext            ; Floppy Extended register ; [1E20: BA 8C 02]
    XOR     AL, AL                                           ; [1E23: 32 C0]
    OUT     DX, AL                                           ; [1E25: EE]
    MOV     DX, io_floppy_param          ; Floppy Parameter register ; [1E26: BA 94 02]
    OUT     DX, AL                                           ; [1E29: EE]
    RETN                                                     ; [1E2A: C3]
loc_1e2b:
    TEST    WORD [var_boot_status_flags], 0800 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1E2B: F7 06 2D 01 00 08]
    JNZ     loc_1de9                                         ; [1E31: 75 B6]
    MOV     AH, BYTE [ES:BX]                                 ; [1E33: 26 8A 27]
    MOV     BL, AH                                           ; [1E36: 8A DC]
    MOV     BYTE [var_selftest_error_flags], 22 ; Selftest error flags buffer ; [1E38: C6 06 20 01 22]
    JMPS    loc_1e4c                                         ; [1E3D: EB 0D]
loc_1e3f:
    TEST    WORD [var_boot_status_flags], 0400 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1E3F: F7 06 2D 01 00 04]
    JNZ     loc_1e20                                         ; [1E45: 75 D9]
    MOV     BYTE [var_selftest_error_flags], 23 ; Selftest error flags buffer ; [1E47: C6 06 20 01 23]
loc_1e4c:
    XOR     AH, AH                                           ; [1E4C: 32 E4]
    XOR     BH, BH                                           ; [1E4E: 32 FF]
    MOV     WORD [var_selftest_error_count], BX              ; [1E50: 89 1E 23 01]
    MOV     [var_selftest_failing_dev], AX                   ; [1E54: A3 25 01]
    JMPS    loc_1e20                                         ; [1E57: EB C7]
sub_1e59:
    PUSH    AX                                               ; [1E59: 50]
    PUSH    BX                                               ; [1E5A: 53]
    PUSH    CX                                               ; [1E5B: 51]
    PUSH    DX                                               ; [1E5C: 52]
    PUSH    SI                                               ; [1E5D: 56]
    MOV     BX, 647A                                         ; [1E5E: BB 7A 64]
    MOV     SI, 0000                                         ; [1E61: BE 00 00]
    MOV     DX, io_floppy_ctrl           ; Floppy Control register (Motor 0/1, Drive sel, DDEN) ; [1E64: BA 88 02]
    MOV     AL, 46                                           ; [1E67: B0 46]
    OUT     DX, AL                                           ; [1E69: EE]
    MOV     CX, 0002                                         ; [1E6A: B9 02 00]
loc_1e6d:
    MOV     BYTE [BX+SI], 00                                 ; [1E6D: C6 00 00]
    MOV     DX, io_wd2797_status_cmd     ; WD2797 FDC Status / Command register ; [1E70: BA 80 02]
    IN      AL, DX                                           ; [1E73: EC]
    TEST    AL, 80                                           ; [1E74: A8 80]
    JNZ     loc_1e7b                                         ; [1E76: 75 03]
    MOV     BYTE [BX+SI], FF                                 ; [1E78: C6 00 FF]
loc_1e7b:
    MOV     DX, io_floppy_ctrl           ; Floppy Control register (Motor 0/1, Drive sel, DDEN) ; [1E7B: BA 88 02]
    MOV     AL, 47                                           ; [1E7E: B0 47]
    OUT     DX, AL                                           ; [1E80: EE]
    INC     SI                                               ; [1E81: 46]
    LOOP    loc_1e6d                                         ; [1E82: E2 E9]
    POP     SI                                               ; [1E84: 5E]
    POP     DX                                               ; [1E85: 5A]
    POP     CX                                               ; [1E86: 59]
    POP     BX                                               ; [1E87: 5B]
    POP     AX                                               ; [1E88: 58]
    RETN                                                     ; [1E89: C3]
sub_1e8a:
    PUSH    BX                                               ; [1E8A: 53]
    PUSH    CX                                               ; [1E8B: 51]
    PUSH    DX                                               ; [1E8C: 52]
    PUSH    DS                                               ; [1E8D: 1E]
    MOV     DX, LAN_BUFFER_SEGMENT                           ; [1E8E: BA 00 36]
    MOV     DS, DX                                           ; [1E91: 8E DA]
    MOV     BL, BYTE [var_boot_device_char] ; NVRAM Byte 25 (0x19): Boot device parameter ('A'=Floppy, 'N'=Net) ; [1E93: 8A 1E 19 00]
    MOV     AL, 46                                           ; [1E97: B0 46]
    CMP     BL, 00                                           ; [1E99: 80 FB 00]
    JZ      loc_1ea0                                         ; [1E9C: 74 02]
    MOV     AL, 47                                           ; [1E9E: B0 47]
loc_1ea0:
    MOV     DX, io_floppy_ctrl           ; Floppy Control register (Motor 0/1, Drive sel, DDEN) ; [1EA0: BA 88 02]
    OUT     DX, AL                                           ; [1EA3: EE]
    MOV     AL, 1C                                           ; [1EA4: B0 1C]
    MOV     [var_dma0_channel_id], AL                        ; [1EA6: A2 03 00]
    CALL    sub_3a1d                                         ; [1EA9: E8 71 1B]
    JC      loc_1ed4                                         ; [1EAC: 72 26]
    MOV     AX, [CS:ram_segment_base]                        ; [1EAE: 2E A1 02 00]
    MOV     BX, 2400                                         ; [1EB2: BB 00 24]
    CALL    fdc_compute_geometry                             ; [1EB5: E8 EA 1C]
    PUSH    ES                                               ; [1EB8: 06]
    MOV     AX, 0000                                         ; [1EB9: B8 00 00]
    MOV     ES, AX                                           ; [1EBC: 8E C0]
    MOV     BX, WORD [ES:var_floppy_sector_num]              ; [1EBE: 26 8B 1E 6B 00]
    POP     ES                                               ; [1EC3: 07]
    MOV     DL, BYTE [var_dma0_status]                       ; [1EC4: 8A 16 01 00]
    SHL     DL, 1                                            ; [1EC8: D0 E2]
    MOV     AL, 8C                                           ; [1ECA: B0 8C]
    MOV     [var_dma0_channel_id], AL                        ; [1ECC: A2 03 00]
    OR      AL, DL                                           ; [1ECF: 0A C2]
    CALL    fdc_read_sector_dma                              ; [1ED1: E8 81 1B]
loc_1ed4:
    POP     DS                                               ; [1ED4: 1F]
    POP     DX                                               ; [1ED5: 5A]
    POP     CX                                               ; [1ED6: 59]
    POP     BX                                               ; [1ED7: 5B]
    RETN                                                     ; [1ED8: C3]
loc_1ed9:
    MOV     AX, 2A57                                         ; [1ED9: B8 57 2A]
    MOV     CX, 000A                                         ; [1EDC: B9 0A 00]
    JMPN    loc_1f15                                         ; [1EDF: E9 33 00]
    RETN                                                     ; [1EE2: C3]
sub_1ee3:
    CMP     BYTE [var_boot_head_settle], FF                  ; [1EE3: 80 3E 5F 00 FF]
    JZ      loc_1ef4                                         ; [1EE8: 74 0A]
    MOV     AX, 25E3                                         ; [1EEA: B8 E3 25]
    MOV     CX, 0011                                         ; [1EED: B9 11 00]
    CALL    print_string_es_ax                               ; [1EF0: E8 B9 E4]
    RETN                                                     ; [1EF3: C3]
loc_1ef4:
    MOV     DX, io_floppy_reserve_ack    ; Floppy Reserve / Acknowledge register ; [1EF4: BA 8E 02]
    OUT     DX, AL                                           ; [1EF7: EE]
    MOV     CX, 0032                                         ; [1EF8: B9 32 00]
loc_1efb:
    MOV     DX, io_floppy_reserve_ack    ; Floppy Reserve / Acknowledge register ; [1EFB: BA 8E 02]
    MOV     AL, FF                                           ; [1EFE: B0 FF]
    OUT     DX, AL                                           ; [1F00: EE]
    IN      AL, DX                                           ; [1F01: EC]
    TEST    AL, 80                                           ; [1F02: A8 80]
    JZ      loc_1f1d                                         ; [1F04: 74 17]
    MOV     AX, 0001                                         ; [1F06: B8 01 00]
    CALL    timer_tick_wait_ax                               ; [1F09: E8 BC EC]
    DEC     CX                                               ; [1F0C: 49]
    JNZ     loc_1efb                                         ; [1F0D: 75 EC]
    MOV     AX, 25F4                                         ; [1F0F: B8 F4 25]
    MOV     CX, 0016                                         ; [1F12: B9 16 00]
loc_1f15:
    CALL    print_string_es_ax                               ; [1F15: E8 94 E4]
    MOV     DX, io_floppy_release        ; Floppy Release register ; [1F18: BA 90 02]
    OUT     DX, AL                                           ; [1F1B: EE]
    RETN                                                     ; [1F1C: C3]
loc_1f1d:
    MOV     DX, io_floppy_ctrl           ; Floppy Control register (Motor 0/1, Drive sel, DDEN) ; [1F1D: BA 88 02]
    MOV     AL, 47                                           ; [1F20: B0 47]
    OUT     DX, AL                                           ; [1F22: EE]
    MOV     CX, FFFF                                         ; [1F23: B9 FF FF]
loc_1f26:
    PUSH    CX                                               ; [1F26: 51]
    MOV     CX, 000A                                         ; [1F27: B9 0A 00]
loc_1f2a:
    LOOP    loc_1f2a                                         ; [1F2A: E2 FE]
    POP     CX                                               ; [1F2C: 59]
    LOOP    loc_1f26                                         ; [1F2D: E2 F7]
    CALL    sub_1e59                                         ; [1F2F: E8 27 FF]
    MOV     BP, 647A                                         ; [1F32: BD 7A 64]
    MOV     AX, 2400                                         ; [1F35: B8 00 24]
    MOV     CX, 1000                                         ; [1F38: B9 00 10]
    CALL    sub_0b6f                                         ; [1F3B: E8 31 EC]
    CMP     WORD [DS:BP+00], +00                             ; [1F3E: 3E 83 7E 00 00]
    JZ      loc_1ed9                                         ; [1F43: 74 94]
    MOV     CX, 0002                                         ; [1F45: B9 02 00]
loc_1f48:
    MOV     AX, CX                                           ; [1F48: 8B C1]
    DEC     AX                                               ; [1F4A: 48]
    MOV     SI, AX                                           ; [1F4B: 8B F0]
    CMP     BYTE [DS:BP+SI], 00                              ; [1F4D: 3E 80 3A 00]
    JZ      loc_1f95                                         ; [1F51: 74 42]
    PUSH    CX                                               ; [1F53: 51]
    PUSH    AX                                               ; [1F54: 50]
    MOV     AX, 2405                                         ; [1F55: B8 05 24]
    MOV     CX, 0008                                         ; [1F58: B9 08 00]
    CALL    print_string_es_ax                               ; [1F5B: E8 4E E4]
    POP     AX                                               ; [1F5E: 58]
    PUSH    AX                                               ; [1F5F: 50]
    ADD     AL, 41                                           ; [1F60: 04 41]
    CALL    conout_char                                      ; [1F62: E8 33 E3]
    MOV     AL, 20                                           ; [1F65: B0 20]
    CALL    conout_char                                      ; [1F67: E8 2E E3]
    POP     AX                                               ; [1F6A: 58]
    POP     CX                                               ; [1F6B: 59]
    PUSH    DS                                               ; [1F6C: 1E]
    MOV     DX, LAN_BUFFER_SEGMENT                           ; [1F6D: BA 00 36]
    MOV     DS, DX                                           ; [1F70: 8E DA]
    MOV     [var_boot_device_char], AL   ; NVRAM Byte 25 (0x19): Boot device parameter ('A'=Floppy, 'N'=Net) ; [1F72: A2 19 00]
    MOV     BYTE [var_dma0_channel_id], 1C                   ; [1F75: C6 06 03 00 1C]
    PUSH    CX                                               ; [1F7A: 51]
    PUSH    ES                                               ; [1F7B: 06]
    MOV     DX, io_pic_icw1              ; 8259A PIC ICW1 (Base port 00h) ; [1F7C: BA 00 00]
    MOV     ES, DX                                           ; [1F7F: 8E C2]
    CALL    sub_0267                                         ; [1F81: E8 E3 E2]
    PUSH    AX                                               ; [1F84: 50]
    CALL    fdc_recalibrate_track0                           ; [1F85: E8 7E 19]
    XCHG    AX, CX                                           ; [1F88: 91]
    POP     AX                                               ; [1F89: 58]
    PUSHF                                                    ; [1F8A: 9C]
    CALL    set_cursor_pos                                   ; [1F8B: E8 EB E2]
    POPF                                                     ; [1F8E: 9D]
    XCHG    AX, CX                                           ; [1F8F: 91]
    POP     ES                                               ; [1F90: 07]
    POP     CX                                               ; [1F91: 59]
    POP     DS                                               ; [1F92: 1F]
    JC      sub_1fdd                                         ; [1F93: 72 48]
loc_1f95:
    MOV     BX, 2A62                                         ; [1F95: BB 62 2A]
loc_1f98:
    PUSH    DS                                               ; [1F98: 1E]
    MOV     DX, LAN_BUFFER_SEGMENT                           ; [1F99: BA 00 36]
    MOV     DS, DX                                           ; [1F9C: 8E DA]
    MOV     AL, BYTE [ES:BX]                                 ; [1F9E: 26 8A 07]
    MOV     [rom_segment_base], AL                           ; [1FA1: A2 00 00]
    INC     BX                                               ; [1FA4: 43]
    MOV     AL, BYTE [ES:BX]                                 ; [1FA5: 26 8A 07]
    MOV     [ram_segment_base], AL                           ; [1FA8: A2 02 00]
    INC     BX                                               ; [1FAB: 43]
    MOV     AL, BYTE [ES:BX]                                 ; [1FAC: 26 8A 07]
    MOV     [var_dma0_status], AL                            ; [1FAF: A2 01 00]
    INC     BX                                               ; [1FB2: 43]
    POP     DS                                               ; [1FB3: 1F]
    MOV     AX, CX                                           ; [1FB4: 8B C1]
    DEC     AX                                               ; [1FB6: 48]
    MOV     SI, AX                                           ; [1FB7: 8B F0]
    CMP     BYTE [DS:BP+SI], 00                              ; [1FB9: 3E 80 3A 00]
    JZ      loc_1fce                                         ; [1FBD: 74 0F]
    PUSH    DS                                               ; [1FBF: 1E]
    MOV     DX, LAN_BUFFER_SEGMENT                           ; [1FC0: BA 00 36]
    MOV     DS, DX                                           ; [1FC3: 8E DA]
    MOV     [var_boot_device_char], AL   ; NVRAM Byte 25 (0x19): Boot device parameter ('A'=Floppy, 'N'=Net) ; [1FC5: A2 19 00]
    POP     DS                                               ; [1FC8: 1F]
    CALL    sub_1e8a                                         ; [1FC9: E8 BE FE]
    JC      sub_1fdd                                         ; [1FCC: 72 0F]
loc_1fce:
    CMP     BX, 2A7D                                         ; [1FCE: 81 FB 7D 2A]
    JC      loc_1f98                                         ; [1FD2: 72 C4]
    LOOP    loc_1fda                                         ; [1FD4: E2 04]
loc_1fd6:
    CALL    sub_39c6                                         ; [1FD6: E8 ED 19]
    RETN                                                     ; [1FD9: C3]
loc_1fda:
    JMPN    loc_1f48                                         ; [1FDA: E9 6B FF]
sub_1fdd:
    XOR     AH, AH                                           ; [1FDD: 32 E4]
    MOV     [var_selftest_failing_dev], AX                   ; [1FDF: A3 25 01]
    TEST    WORD [var_boot_status_flags], 0800 ; Selftest status / warm-boot flag word (bit 9 = skip memtest) ; [1FE2: F7 06 2D 01 00 08]
    JNZ     loc_1fd6                                         ; [1FE8: 75 EC]
    PUSH    DS                                               ; [1FEA: 1E]
    MOV     DX, LAN_BUFFER_SEGMENT                           ; [1FEB: BA 00 36]
    MOV     DS, DX                                           ; [1FEE: 8E DA]
    CMP     BYTE [var_dma0_channel_id], 1C                   ; [1FF0: 80 3E 03 00 1C]
    POP     DS                                               ; [1FF5: 1F]
    JNZ     loc_1fff                                         ; [1FF6: 75 07]
    MOV     BYTE [var_selftest_error_flags], 1D ; Selftest error flags buffer ; [1FF8: C6 06 20 01 1D]
    JMPS    loc_1fd6                                         ; [1FFD: EB D7]
loc_1fff:
    TEST    AL, 1C                                           ; [1FFF: A8 1C]
    JZ      loc_2020                                         ; [2001: 74 1D]
    TEST    AL, 04                                           ; [2003: A8 04]
    JZ      loc_200c                                         ; [2005: 74 05]
    MOV     BYTE [var_selftest_error_flags], 1A ; Selftest error flags buffer ; [2007: C6 06 20 01 1A]
loc_200c:
    TEST    AL, 08                                           ; [200C: A8 08]
    JZ      loc_2015                                         ; [200E: 74 05]
    MOV     BYTE [var_selftest_error_flags], 1B ; Selftest error flags buffer ; [2010: C6 06 20 01 1B]
loc_2015:
    TEST    AL, 10                                           ; [2015: A8 10]
    JZ      loc_1fd6                                         ; [2017: 74 BD]
    MOV     BYTE [var_selftest_error_flags], 1C ; Selftest error flags buffer ; [2019: C6 06 20 01 1C]
    JMPS    loc_1fd6                                         ; [201E: EB B6]
loc_2020:
    MOV     BYTE [var_selftest_error_flags], 1E ; Selftest error flags buffer ; [2020: C6 06 20 01 1E]
    JMPS    loc_1fd6                                         ; [2025: EB AF]
sub_2027:
    PUSH    DX                                               ; [2027: 52]
    MOV     BX, 647C                                         ; [2028: BB 7C 64]
    MOV     DX, WORD [BX]                                    ; [202B: 8B 17]
    MOV     BX, DX                                           ; [202D: 8B DA]
    POP     DX                                               ; [202F: 5A]
    RETN                                                     ; [2030: C3]
sub_2031:
    PUSH    DX                                               ; [2031: 52]
    MOV     DX, BX                                           ; [2032: 8B D3]
    MOV     BX, 647C                                         ; [2034: BB 7C 64]
    MOV     WORD [BX], DX                                    ; [2037: 89 17]
    MOV     BX, DX                                           ; [2039: 8B DA]
    POP     DX                                               ; [203B: 5A]
    RETN                                                     ; [203C: C3]
sub_203d:
    PUSH    DX                                               ; [203D: 52]
    MOV     BX, 647E                                         ; [203E: BB 7E 64]
    MOV     DX, WORD [BX]                                    ; [2041: 8B 17]
    MOV     BX, DX                                           ; [2043: 8B DA]
    POP     DX                                               ; [2045: 5A]
    RETN                                                     ; [2046: C3]
sub_2047:
    PUSH    DX                                               ; [2047: 52]
    MOV     DX, BX                                           ; [2048: 8B D3]
    MOV     BX, 647E                                         ; [204A: BB 7E 64]
    MOV     WORD [BX], DX                                    ; [204D: 89 17]
    MOV     BX, DX                                           ; [204F: 8B DA]
    POP     DX                                               ; [2051: 5A]
    RETN                                                     ; [2052: C3]
sub_2053:
    MOV     AX, 3002                                         ; [2053: B8 02 30]
    CALL    set_cursor_pos                                   ; [2056: E8 20 E2]
    CALL    sub_2027                                         ; [2059: E8 CB FF]
    ADD     BX, +04                                          ; [205C: 83 C3 04]
    MOV     AX, BX                                           ; [205F: 8B C3]
    MOV     CX, 000C                                         ; [2061: B9 0C 00]
    CALL    print_string_es_ax                               ; [2064: E8 45 E3]
sub_2067:
    MOV     AX, 3039                                         ; [2067: B8 39 30]
    CALL    set_cursor_pos                                   ; [206A: E8 0C E2]
    CALL    sub_203d                                         ; [206D: E8 CD FF]
    MOV     AX, BX                                           ; [2070: 8B C3]
    ADD     AX, 0001                                         ; [2072: 05 01 00]
    MOV     CX, 0009                                         ; [2075: B9 09 00]
    CALL    print_string_es_ax                               ; [2078: E8 31 E3]
    RETN                                                     ; [207B: C3]
sub_207c:
    PUSH    AX                                               ; [207C: 50]
    CALL    sub_203d                                         ; [207D: E8 BD FF]
    ADD     BX, +0A                                          ; [2080: 83 C3 0A]
    MOV     AL, BYTE [ES:BX]                                 ; [2083: 26 8A 07]
    CMP     AL, FF                                           ; [2086: 3C FF]
    JNZ     loc_2097                                         ; [2088: 75 0D]
loc_208a:
    SUB     BX, +0A                                          ; [208A: 83 EB 0A]
    MOV     AL, BYTE [ES:BX]                                 ; [208D: 26 8A 07]
    CMP     AL, FF                                           ; [2090: 3C FF]
    JNZ     loc_208a                                         ; [2092: 75 F6]
    ADD     BX, +0A                                          ; [2094: 83 C3 0A]
loc_2097:
    CALL    sub_2047                                         ; [2097: E8 AD FF]
    CALL    sub_2067                                         ; [209A: E8 CA FF]
    POP     AX                                               ; [209D: 58]
    RETN                                                     ; [209E: C3]
sub_209f:
    PUSH    AX                                               ; [209F: 50]
    CALL    sub_203d                                         ; [20A0: E8 9A FF]
    SUB     BX, +0A                                          ; [20A3: 83 EB 0A]
    MOV     AL, BYTE [ES:BX]                                 ; [20A6: 26 8A 07]
    CMP     AL, FF                                           ; [20A9: 3C FF]
    JNZ     loc_20ba                                         ; [20AB: 75 0D]
loc_20ad:
    ADD     BX, +0A                                          ; [20AD: 83 C3 0A]
    MOV     AL, BYTE [ES:BX]                                 ; [20B0: 26 8A 07]
    CMP     AL, FF                                           ; [20B3: 3C FF]
    JNZ     loc_20ad                                         ; [20B5: 75 F6]
    SUB     BX, +0A                                          ; [20B7: 83 EB 0A]
loc_20ba:
    CALL    sub_2047                                         ; [20BA: E8 8A FF]
    CALL    sub_2067                                         ; [20BD: E8 A7 FF]
    POP     AX                                               ; [20C0: 58]
    RETN                                                     ; [20C1: C3]
sub_20c2:
    CALL    sub_2027                                         ; [20C2: E8 62 FF]
    MOV     AL, BYTE [ES:BX]                                 ; [20C5: 26 8A 07]
    XOR     AH, AH                                           ; [20C8: 32 E4]
    MOV     BX, 648D                                         ; [20CA: BB 8D 64]
    ADD     BX, AX                                           ; [20CD: 03 D8]
    PUSH    BX                                               ; [20CF: 53]
    MOV     AL, BYTE [BX]                                    ; [20D0: 8A 07]
    CALL    sub_2027                                         ; [20D2: E8 52 FF]
    INC     BX                                               ; [20D5: 43]
    AND     AL, BYTE [ES:BX]                                 ; [20D6: 26 22 07]
    CALL    sub_203d                                         ; [20D9: E8 61 FF]
    ADD     AL, BYTE [ES:BX]                                 ; [20DC: 26 02 07]
    POP     BX                                               ; [20DF: 5B]
    MOV     BYTE [BX], AL                                    ; [20E0: 88 07]
    RETN                                                     ; [20E2: C3]
sub_20e3:
    CALL    sub_2027                                         ; [20E3: E8 41 FF]
    MOV     AL, BYTE [ES:BX]                                 ; [20E6: 26 8A 07]
    XOR     AH, AH                                           ; [20E9: 32 E4]
    MOV     BX, 648D                                         ; [20EB: BB 8D 64]
    ADD     BX, AX                                           ; [20EE: 03 D8]
    MOV     AL, BYTE [BX]                                    ; [20F0: 8A 07]
    CALL    sub_2027                                         ; [20F2: E8 32 FF]
    INC     BX                                               ; [20F5: 43]
    MOV     AH, BYTE [ES:BX]                                 ; [20F6: 26 8A 27]
    NOT     AH                                               ; [20F9: F6 D4]
    AND     AL, AH                                           ; [20FB: 22 C4]
    INC     BX                                               ; [20FD: 43]
    MOV     CX, WORD [ES:BX]                                 ; [20FE: 26 8B 0F]
    MOV     BX, CX                                           ; [2101: 8B D9]
loc_2103:
    CMP     AL, BYTE [ES:BX]                                 ; [2103: 26 3A 07]
    JZ      loc_2129                                         ; [2106: 74 21]
    ADD     BX, +0A                                          ; [2108: 83 C3 0A]
    CMP     BYTE [ES:BX], FF                                 ; [210B: 26 80 3F FF]
    JNZ     loc_2103                                         ; [210F: 75 F2]
    MOV     BX, CX                                           ; [2111: 8B D9]
    CALL    sub_2047                                         ; [2113: E8 31 FF]
    CALL    sub_2053                                         ; [2116: E8 3A FF]
    MOV     AX, 3039                                         ; [2119: B8 39 30]
    CALL    set_cursor_pos                                   ; [211C: E8 5A E1]
    MOV     AX, 2F35                                         ; [211F: B8 35 2F]
    MOV     CX, 0009                                         ; [2122: B9 09 00]
    CALL    print_string_es_ax                               ; [2125: E8 84 E2]
    RETN                                                     ; [2128: C3]
loc_2129:
    CALL    sub_2047                                         ; [2129: E8 1B FF]
    CALL    sub_2053                                         ; [212C: E8 24 FF]
    RETN                                                     ; [212F: C3]
sub_2130:
    PUSH    AX                                               ; [2130: 50]
    CALL    sub_20c2                                         ; [2131: E8 8E FF]
    CALL    sub_2027                                         ; [2134: E8 F0 FE]
    ADD     BX, +10                                          ; [2137: 83 C3 10]
    CMP     BYTE [ES:BX], FF                                 ; [213A: 26 80 3F FF]
    JNZ     loc_214c                                         ; [213E: 75 0C]
loc_2140:
    SUB     BX, +10                                          ; [2140: 83 EB 10]
    CMP     BYTE [ES:BX], FF                                 ; [2143: 26 80 3F FF]
    JNZ     loc_2140                                         ; [2147: 75 F7]
    ADD     BX, +10                                          ; [2149: 83 C3 10]
loc_214c:
    CALL    sub_2031                                         ; [214C: E8 E2 FE]
    CALL    sub_20e3                                         ; [214F: E8 91 FF]
    POP     AX                                               ; [2152: 58]
    RETN                                                     ; [2153: C3]
sub_2154:
    PUSH    AX                                               ; [2154: 50]
    CALL    sub_20c2                                         ; [2155: E8 6A FF]
    CALL    sub_2027                                         ; [2158: E8 CC FE]
    SUB     BX, +10                                          ; [215B: 83 EB 10]
    CMP     BYTE [ES:BX], FF                                 ; [215E: 26 80 3F FF]
    JNZ     loc_2170                                         ; [2162: 75 0C]
loc_2164:
    ADD     BX, +10                                          ; [2164: 83 C3 10]
    CMP     BYTE [ES:BX], FF                                 ; [2167: 26 80 3F FF]
    JNZ     loc_2164                                         ; [216B: 75 F7]
    SUB     BX, +10                                          ; [216D: 83 EB 10]
loc_2170:
    CALL    sub_2031                                         ; [2170: E8 BE FE]
    CALL    sub_20e3                                         ; [2173: E8 6D FF]
    POP     AX                                               ; [2176: 58]
    RETN                                                     ; [2177: C3]

; ----------------------------------------------------------------------------
; menu_enter_snooper (ROM: 59B8h, FB84:2178h)
; ----------------------------------------------------------------------------
menu_enter_snooper:
    PUSH    AX                                               ; [2178: 50]
    PUSH    BX                                               ; [2179: 53]
    PUSH    CX                                               ; [217A: 51]
    CALL    mute_sound_chip                                  ; [217B: E8 B8 F2]
    MOV     BX, 2E92                                         ; [217E: BB 92 2E]
loc_2181:
    MOV     AL, BYTE [ES:BX]                                 ; [2181: 26 8A 07]
    CMP     AL, FF                                           ; [2184: 3C FF]
    JZ      loc_218e                                         ; [2186: 74 06]
    CALL    conout_char                                      ; [2188: E8 0D E1]
    INC     BX                                               ; [218B: 43]
    JMPS    loc_2181                                         ; [218C: EB F3]
loc_218e:
    CALL    sub_3dba                                         ; [218E: E8 29 1C]
    JNC     loc_219c                                         ; [2191: 73 09]
    CALL    sub_3dfd                                         ; [2193: E8 67 1C]
    CALL    sub_3de6                                         ; [2196: E8 4D 1C]
    CALL    sub_3d9a                                         ; [2199: E8 FE 1B]
loc_219c:
    CALL    sub_3d7d                                         ; [219C: E8 DE 1B]
    CALL    sub_0267                                         ; [219F: E8 C5 E0]
    PUSH    AX                                               ; [21A2: 50]
    PUSH    ES                                               ; [21A3: 06]
    PUSH    BX                                               ; [21A4: 53]
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [21A5: B8 00 30]
    MOV     ES, AX                                           ; [21A8: 8E C0]
    MOV     BX, 5000                                         ; [21AA: BB 00 50]
    MOV     WORD [ES:BX], 8E00                               ; [21AD: 26 C7 07 00 8E]
    MOV     WORD [ES:BX+02], 0400                            ; [21B2: 26 C7 47 02 00 04]
    POP     BX                                               ; [21B8: 5B]
    POP     ES                                               ; [21B9: 07]
    MOV     BX, 2A8D                                         ; [21BA: BB 8D 2A]
    CALL    sub_2031                                         ; [21BD: E8 71 FE]
    CALL    sub_20e3                                         ; [21C0: E8 20 FF]
    MOV     AX, 03E8                                         ; [21C3: B8 E8 03]
    CALL    sub_049a                                         ; [21C6: E8 D1 E2]
loc_21c9:
    MOV     BYTE [var_kbd_key_ready], 00 ; Keyboard event flag (FFh = key pressed) ; [21C9: C6 06 32 01 00]
    CALL    read_key_poll                                    ; [21CE: E8 02 E2]
    CMP     AL, 92                                           ; [21D1: 3C 92]
    JNZ     loc_21d8                                         ; [21D3: 75 03]
    CALL    sub_2154                                         ; [21D5: E8 7C FF]
loc_21d8:
    CMP     AL, 93                                           ; [21D8: 3C 93]
    JNZ     loc_21df                                         ; [21DA: 75 03]
    CALL    sub_2130                                         ; [21DC: E8 51 FF]
loc_21df:
    CMP     AL, 91                                           ; [21DF: 3C 91]
    JNZ     loc_21e6                                         ; [21E1: 75 03]
    CALL    sub_207c                                         ; [21E3: E8 96 FE]
loc_21e6:
    CMP     AL, 90                                           ; [21E6: 3C 90]
    JNZ     loc_21ed                                         ; [21E8: 75 03]
    CALL    sub_209f                                         ; [21EA: E8 B2 FE]
loc_21ed:
    CMP     AL, 4E                                           ; [21ED: 3C 4E]
    JZ      loc_21fb                                         ; [21EF: 74 0A]
    CMP     AL, 59                                           ; [21F1: 3C 59]
    JNZ     loc_21c9                                         ; [21F3: 75 D4]
    CALL    sub_20c2                                         ; [21F5: E8 CA FE]
    CALL    sub_3d9a                                         ; [21F8: E8 9F 1B]
loc_21fb:
    CALL    mute_sound_chip                                  ; [21FB: E8 38 F2]
    POP     AX                                               ; [21FE: 58]
    CALL    set_cursor_pos                                   ; [21FF: E8 77 E0]
    POP     CX                                               ; [2202: 59]
    POP     BX                                               ; [2203: 5B]
    POP     AX                                               ; [2204: 58]
    RETN                                                     ; [2205: C3]
sub_2206:
    CALL    sub_2355                                         ; [2206: E8 4C 01]
    JC      sub_220c                                         ; [2209: 72 01]
    RETN                                                     ; [220B: C3]
sub_220c:
    CALL    wait_key_press                                   ; [220C: E8 BA E1]
    CALL    wait_key_press                                   ; [220F: E8 B7 E1]
    MOV     AX, 2F4A                                         ; [2212: B8 4A 2F]
    MOV     CX, FFFF                                         ; [2215: B9 FF FF]
    CALL    print_string_es_ax                               ; [2218: E8 91 E1]
    CALL    sub_221f                                         ; [221B: E8 01 00]
    RETN                                                     ; [221E: C3]
sub_221f:
    MOV     SI, 5517                                         ; [221F: BE 17 55]
loc_2222:
    CMP     SI, WORD [var_lan_transfer_len]                  ; [2222: 3B 36 A2 4B]
    JGE     loc_223f                                         ; [2226: 7D 17]
    CALL    sub_2309                                         ; [2228: E8 DE 00]
    JNC     loc_223f                                         ; [222B: 73 12]
    MOV     WORD [var_lan_rx_retries], SI                    ; [222D: 89 36 A0 4B]
    DEC     WORD [var_lan_rx_retries]                        ; [2231: FF 0E A0 4B]
    CALL    sub_226c                                         ; [2235: E8 34 00]
    JNC     loc_2222                                         ; [2238: 73 E8]
    CALL    sub_2240                                         ; [223A: E8 03 00]
    JMPS    loc_2222                                         ; [223D: EB E3]
loc_223f:
    RETN                                                     ; [223F: C3]
sub_2240:
    PUSH    SI                                               ; [2240: 56]
    MOV     SI, WORD [var_lan_rx_retries]                    ; [2241: 8B 36 A0 4B]
    CALL    wait_key_press                                   ; [2245: E8 81 E1]
loc_2248:
    MOV     AL, BYTE [SI]                                    ; [2248: 8A 04]
    CALL    conout_char                                      ; [224A: E8 4B E0]
    INC     SI                                               ; [224D: 46]
    CMP     AL, 3D                                           ; [224E: 3C 3D]
    JNZ     loc_2248                                         ; [2250: 75 F6]
loc_2252:
    MOV     AL, BYTE [SI]                                    ; [2252: 8A 04]
    CMP     AL, 3B                                           ; [2254: 3C 3B]
    JZ      loc_225f                                         ; [2256: 74 07]
    CMP     AL, 0D                                           ; [2258: 3C 0D]
    JZ      loc_226a                                         ; [225A: 74 0E]
    INC     SI                                               ; [225C: 46]
    JMPS    loc_2252                                         ; [225D: EB F3]
loc_225f:
    INC     SI                                               ; [225F: 46]
loc_2260:
    MOV     AL, BYTE [SI]                                    ; [2260: 8A 04]
    CALL    conout_char                                      ; [2262: E8 33 E0]
    INC     SI                                               ; [2265: 46]
    CMP     AL, 0D                                           ; [2266: 3C 0D]
    JNZ     loc_2260                                         ; [2268: 75 F6]
loc_226a:
    POP     SI                                               ; [226A: 5E]
    RETN                                                     ; [226B: C3]
sub_226c:
    PUSH    ES                                               ; [226C: 06]
    MOV     AX, [CS:rom_segment_base]                        ; [226D: 2E A1 00 00]
    MOV     ES, AX                                           ; [2271: 8E C0]
    MOV     AL, BYTE [SI]                                    ; [2273: 8A 04]
    MOV     BX, 2F71                                         ; [2275: BB 71 2F]
loc_2278:
    CMP     AL, BYTE [ES:BX]                                 ; [2278: 26 3A 07]
    JZ      loc_228a                                         ; [227B: 74 0D]
    MOV     DL, BYTE [ES:BX]                                 ; [227D: 26 8A 17]
    CMP     DL, FF                                           ; [2280: 80 FA FF]
    JZ      loc_22c0                                         ; [2283: 74 3B]
    ADD     BX, +03                                          ; [2285: 83 C3 03]
    JMPS    loc_2278                                         ; [2288: EB EE]
loc_228a:
    CALL    sub_2320                                         ; [228A: E8 93 00]
    JNC     loc_22c0                                         ; [228D: 73 31]
    CALL    sub_22c3                                         ; [228F: E8 31 00]
    JNC     loc_22c0                                         ; [2292: 73 2C]
    MOV     CH, AL                                           ; [2294: 8A E8]
    INC     BX                                               ; [2296: 43]
    MOV     AL, BYTE [ES:BX]                                 ; [2297: 26 8A 07]
    MOV     CL, 05                                           ; [229A: B1 05]
    SHR     AL, CL                                           ; [229C: D2 E8]
    AND     AL, 03                                           ; [229E: 24 03]
    MOV     AH, AL                                           ; [22A0: 8A E0]
    MOV     AL, BYTE [ES:BX]                                 ; [22A2: 26 8A 07]
    AND     AL, 1F                                           ; [22A5: 24 1F]
    PUSH    AX                                               ; [22A7: 50]
    CALL    nvram_read_byte_al                               ; [22A8: E8 0F 19]
    INC     BX                                               ; [22AB: 43]
    MOV     CL, AL                                           ; [22AC: 8A C8]
    MOV     AL, BYTE [ES:BX]                                 ; [22AE: 26 8A 07]
    AND     CL, AL                                           ; [22B1: 22 C8]
    NOT     AL                                               ; [22B3: F6 D0]
    AND     CH, AL                                           ; [22B5: 22 E8]
    ADD     CL, CH                                           ; [22B7: 02 CD]
    POP     AX                                               ; [22B9: 58]
    CALL    boot_setup_memory_params                         ; [22BA: E8 7E 1B]
    STC                                                      ; [22BD: F9]
    POP     ES                                               ; [22BE: 07]
    RETN                                                     ; [22BF: C3]
loc_22c0:
    CLC                                                      ; [22C0: F8]
    POP     ES                                               ; [22C1: 07]
    RETN                                                     ; [22C2: C3]
sub_22c3:
    PUSH    CX                                               ; [22C3: 51]
    MOV     AL, BYTE [SI]                                    ; [22C4: 8A 04]
    CALL    sub_22e1                                         ; [22C6: E8 18 00]
    JNC     loc_22df                                         ; [22C9: 73 14]
    MOV     CL, 04                                           ; [22CB: B1 04]
    SHL     AL, CL                                           ; [22CD: D2 E0]
    MOV     AH, AL                                           ; [22CF: 8A E0]
    AND     AH, F0                                           ; [22D1: 80 E4 F0]
    INC     SI                                               ; [22D4: 46]
    MOV     AL, BYTE [SI]                                    ; [22D5: 8A 04]
    CALL    sub_22e1                                         ; [22D7: E8 07 00]
    JNC     loc_22df                                         ; [22DA: 73 03]
    ADD     AL, AH                                           ; [22DC: 02 C4]
    STC                                                      ; [22DE: F9]
loc_22df:
    POP     CX                                               ; [22DF: 59]
    RETN                                                     ; [22E0: C3]
sub_22e1:
    PUSH    SI                                               ; [22E1: 56]
    PUSH    BX                                               ; [22E2: 53]
    PUSH    DX                                               ; [22E3: 52]
    MOV     BX, 0D51                                         ; [22E4: BB 51 0D]
    MOV     SI, 0000                                         ; [22E7: BE 00 00]
    MOV     DL, 00                                           ; [22EA: B2 00]
loc_22ec:
    MOV     DH, BYTE [CS:BX+SI+0000]                         ; [22EC: 2E 8A B0 00 00]
    CMP     AL, DH                                           ; [22F1: 3A C6]
    JZ      loc_2302                                         ; [22F3: 74 0D]
    INC     SI                                               ; [22F5: 46]
    INC     DL                                               ; [22F6: FE C2]
    CMP     DL, 10                                           ; [22F8: 80 FA 10]
    JNZ     loc_22ec                                         ; [22FB: 75 EF]
    CLC                                                      ; [22FD: F8]
    POP     DX                                               ; [22FE: 5A]
    POP     BX                                               ; [22FF: 5B]
    POP     SI                                               ; [2300: 5E]
    RETN                                                     ; [2301: C3]
loc_2302:
    STC                                                      ; [2302: F9]
    MOV     AL, DL                                           ; [2303: 8A C2]
    POP     DX                                               ; [2305: 5A]
    POP     BX                                               ; [2306: 5B]
    POP     SI                                               ; [2307: 5E]
    RETN                                                     ; [2308: C3]
sub_2309:
    PUSH    AX                                               ; [2309: 50]
loc_230a:
    MOV     AL, BYTE [SI]                                    ; [230A: 8A 04]
    AND     AL, 7F                                           ; [230C: 24 7F]
    INC     SI                                               ; [230E: 46]
    CMP     AL, 2A                                           ; [230F: 3C 2A]
    JZ      loc_2331                                         ; [2311: 74 1E]
    CMP     AL, 23                                           ; [2313: 3C 23]
    JZ      loc_231d                                         ; [2315: 74 06]
    CMP     SI, WORD [var_lan_transfer_len]                  ; [2317: 3B 36 A2 4B]
    JL      loc_230a                                         ; [231B: 7C ED]
loc_231d:
    CLC                                                      ; [231D: F8]
    POP     AX                                               ; [231E: 58]
    RETN                                                     ; [231F: C3]
sub_2320:
    PUSH    AX                                               ; [2320: 50]
loc_2321:
    MOV     AL, BYTE [SI]                                    ; [2321: 8A 04]
    AND     AL, 7F                                           ; [2323: 24 7F]
    INC     SI                                               ; [2325: 46]
    CMP     AL, 3D                                           ; [2326: 3C 3D]
    JZ      loc_2331                                         ; [2328: 74 07]
    CMP     AL, 0D                                           ; [232A: 3C 0D]
    JNZ     loc_2321                                         ; [232C: 75 F3]
    CLC                                                      ; [232E: F8]
    POP     AX                                               ; [232F: 58]
    RETN                                                     ; [2330: C3]
loc_2331:
    STC                                                      ; [2331: F9]
    POP     AX                                               ; [2332: 58]
    RETN                                                     ; [2333: C3]
sub_2334:
    PUSH    ES                                               ; [2334: 06]
    MOV     AX, [CS:rom_segment_base]                        ; [2335: 2E A1 00 00]
    MOV     ES, AX                                           ; [2339: 8E C0]
    MOV     CX, 000C                                         ; [233B: B9 0C 00]
    MOV     SI, 0000                                         ; [233E: BE 00 00]
    MOV     DI, 0000                                         ; [2341: BF 00 00]
loc_2344:
    MOV     BX, 2F3E                                         ; [2344: BB 3E 2F]
    MOV     AL, BYTE [ES:BX+SI]                              ; [2347: 26 8A 00]
    MOV     BX, 4BA4                                         ; [234A: BB A4 4B]
    MOV     BYTE [BX+DI], AL                                 ; [234D: 88 01]
    INC     SI                                               ; [234F: 46]
    INC     DI                                               ; [2350: 47]
    LOOP    loc_2344                                         ; [2351: E2 F1]
    POP     ES                                               ; [2353: 07]
    RETN                                                     ; [2354: C3]
sub_2355:
    CALL    sub_2334                                         ; [2355: E8 DC FF]
    CALL    fdc_recalibrate_track0                           ; [2358: E8 AB 15]
    JNC     loc_2360                                         ; [235B: 73 03]
    JMPN    loc_2434                                         ; [235D: E9 D4 00]
loc_2360:
    MOV     AH, 04                                           ; [2360: B4 04]
    CALL    sub_3b95                                         ; [2362: E8 30 18]
    MOV     AX, [ES:var_floppy_last_seek]                    ; [2365: 26 A1 75 00]
    MOV     [rom_segment_base], AL                           ; [2369: A2 00 00]
    CALL    sub_3a1d                                         ; [236C: E8 AE 16]
    JNC     loc_2374                                         ; [236F: 73 03]
    JMPN    loc_2434                                         ; [2371: E9 C0 00]
loc_2374:
    MOV     AX, DS                                           ; [2374: 8C D8]
    MOV     BX, 5517                                         ; [2376: BB 17 55]
    CALL    fdc_compute_geometry                             ; [2379: E8 26 18]
loc_237c:
    MOV     BYTE [ram_segment_base], 01                      ; [237C: C6 06 02 00 01]
    MOV     BX, WORD [ES:var_floppy_buffer_ptr]              ; [2381: 26 8B 1E 6D 00]
    MOV     AL, 9C                                           ; [2386: B0 9C]
    CALL    fdc_read_sector_dma                              ; [2388: E8 CA 16]
    JNC     loc_2390                                         ; [238B: 73 03]
    JMPN    loc_2434                                         ; [238D: E9 A4 00]
loc_2390:
    MOV     AX, [ES:var_floppy_track_num]                    ; [2390: 26 A1 73 00]
    SUB     AX, WORD [ES:var_floppy_buffer_ptr]              ; [2394: 26 2B 06 6D 00]
    MOV     [ES:var_floppy_track_num], AX                    ; [2399: 26 A3 73 00]
    JA      loc_23a2                                         ; [239D: 77 03]
    JMPN    loc_23e7                                         ; [239F: E9 45 00]
loc_23a2:
    MOV     AX, [ES:var_floppy_buffer_ptr]                   ; [23A2: 26 A1 6D 00]
    ADD     WORD [var_dma0_byte_count], AX                   ; [23A6: 01 06 04 00]
    MOV     BYTE [ram_segment_base], 01                      ; [23AA: C6 06 02 00 01]
    MOV     BX, WORD [ES:var_floppy_buffer_ptr]              ; [23AF: 26 8B 1E 6D 00]
    MOV     AL, 9E                                           ; [23B4: B0 9E]
    CALL    fdc_read_sector_dma                              ; [23B6: E8 9C 16]
    JNC     loc_23be                                         ; [23B9: 73 03]
    JMPN    loc_2434                                         ; [23BB: E9 76 00]
loc_23be:
    MOV     AX, [ES:var_floppy_track_num]                    ; [23BE: 26 A1 73 00]
    SUB     AX, WORD [ES:var_floppy_buffer_ptr]              ; [23C2: 26 2B 06 6D 00]
    MOV     [ES:var_floppy_track_num], AX                    ; [23C7: 26 A3 73 00]
    JA      loc_23d0                                         ; [23CB: 77 03]
    JMPN    loc_23e7                                         ; [23CD: E9 17 00]
loc_23d0:
    INC     BYTE [rom_segment_base]                          ; [23D0: FE 06 00 00]
    CALL    sub_3a1d                                         ; [23D4: E8 46 16]
    JNC     loc_23dc                                         ; [23D7: 73 03]
    JMPN    loc_2434                                         ; [23D9: E9 58 00]
loc_23dc:
    MOV     AX, [ES:var_floppy_buffer_ptr]                   ; [23DC: 26 A1 6D 00]
    ADD     WORD [var_dma0_byte_count], AX                   ; [23E0: 01 06 04 00]
    JMPN    loc_237c                                         ; [23E4: E9 95 FF]
loc_23e7:
    MOV     BYTE [var_lan_block_index], FF                   ; [23E7: C6 06 B0 4B FF]
    MOV     SI, 4BB7                                         ; [23EC: BE B7 4B]
    MOV     WORD [var_lan_buf_pointer], SI                   ; [23EF: 89 36 B5 4B]
    MOV     WORD [var_lan_data_byte_count], 0000             ; [23F3: C7 06 B3 4B 00 00]
    CALL    sub_24a0                                         ; [23F9: E8 A4 00]
    JC      loc_2401                                         ; [23FC: 72 03]
    JMPN    loc_2440                                         ; [23FE: E9 3F 00]
loc_2401:
    MOV     SI, 5517                                         ; [2401: BE 17 55]
    MOV     WORD [var_lan_transfer_len], SI                  ; [2404: 89 36 A2 4B]
loc_2408:
    MOV     AX, DS                                           ; [2408: 8C D8]
    MOV     BX, WORD [var_lan_transfer_len]                  ; [240A: 8B 1E A2 4B]
    CALL    fdc_compute_geometry                             ; [240E: E8 91 17]
    CALL    sub_2560                                         ; [2411: E8 4C 01]
    JNC     loc_2432                                         ; [2414: 73 1C]
    ADD     WORD [var_lan_transfer_len], BX                  ; [2416: 01 1E A2 4B]
    CALL    sub_3a1d                                         ; [241A: E8 00 16]
    JC      loc_2434                                         ; [241D: 72 15]
    MOV     AL, 9C                                           ; [241F: B0 9C]
    CMP     BYTE [var_dma0_status], 00                       ; [2421: 80 3E 01 00 00]
    JZ      loc_242a                                         ; [2426: 74 02]
    OR      AL, 02                                           ; [2428: 0C 02]
loc_242a:
    CALL    fdc_read_sector_dma                              ; [242A: E8 28 16]
    JC      loc_2434                                         ; [242D: 72 05]
    JMPN    loc_2408                                         ; [242F: E9 D6 FF]
loc_2432:
    STC                                                      ; [2432: F9]
    RETN                                                     ; [2433: C3]
loc_2434:
    PUSH    DS                                               ; [2434: 1E]
    XOR     DX, DX                                           ; [2435: 33 D2]
    MOV     DS, DX                                           ; [2437: 8E DA]
    CALL    sub_1fdd                                         ; [2439: E8 A1 FB]
    POP     DS                                               ; [243C: 1F]
    CALL    sub_3875                                         ; [243D: E8 35 14]
loc_2440:
    CLC                                                      ; [2440: F8]
    RETN                                                     ; [2441: C3]
sub_2442:
    MOV     DI, 5517                                         ; [2442: BF 17 55]
    MOV     WORD [var_lan_file_eof_flag], 0000               ; [2445: C7 06 B1 4B 00 00]
    INC     BYTE [var_lan_block_index]                       ; [244B: FE 06 B0 4B]
loc_244f:
    CALL    sub_2469                                         ; [244F: E8 17 00]
    INC     WORD [var_lan_file_eof_flag]                     ; [2452: FF 06 B1 4B]
    JC      loc_2468                                         ; [2456: 72 10]
    MOV     AX, [ES:var_floppy_head_num]                     ; [2458: 26 A1 6F 00]
    CMP     AX, WORD [var_lan_file_eof_flag]                 ; [245C: 3B 06 B1 4B]
    JZ      loc_2467                                         ; [2460: 74 05]
    ADD     DI, +20                                          ; [2462: 83 C7 20]
    JMPS    loc_244f                                         ; [2465: EB E8]
loc_2467:
    CLC                                                      ; [2467: F8]
loc_2468:
    RETN                                                     ; [2468: C3]
sub_2469:
    MOV     CX, 000C                                         ; [2469: B9 0C 00]
    XOR     BX, BX                                           ; [246C: 33 DB]
    MOV     DL, BYTE [ES:var_floppy_bytes_per_sec]           ; [246E: 26 8A 16 79 00]
    MOV     DH, DL                                           ; [2473: 8A F2]
loc_2475:
    MOV     AL, BYTE [BX+DI]                                 ; [2475: 8A 01]
    AND     AL, 7F                                           ; [2477: 24 7F]
    CMP     AL, BYTE [BX+SI]                                 ; [2479: 3A 00]
    JNZ     loc_249e                                         ; [247B: 75 21]
    INC     BX                                               ; [247D: 43]
    LOOP    loc_2475                                         ; [247E: E2 F5]
loc_2480:
    MOV     AL, BYTE [BX+SI]                                 ; [2480: 8A 00]
    CMP     AL, BYTE [BX+DI]                                 ; [2482: 3A 01]
    JZ      loc_249c                                         ; [2484: 74 16]
    CMP     DL, 00                                           ; [2486: 80 FA 00]
    JZ      loc_2491                                         ; [2489: 74 06]
    DEC     DL                                               ; [248B: FE CA]
    INC     BYTE [BX+SI]                                     ; [248D: FE 00]
    JMPS    loc_2480                                         ; [248F: EB EF]
loc_2491:
    CMP     DH, 00                                           ; [2491: 80 FE 00]
    JZ      loc_249e                                         ; [2494: 74 08]
    DEC     DH                                               ; [2496: FE CE]
    DEC     BYTE [BX+SI]                                     ; [2498: FE 08]
    JMPS    loc_2491                                         ; [249A: EB F5]
loc_249c:
    STC                                                      ; [249C: F9]
    RETN                                                     ; [249D: C3]
loc_249e:
    CLC                                                      ; [249E: F8]
    RETN                                                     ; [249F: C3]
sub_24a0:
    MOV     SI, 4BA4                                         ; [24A0: BE A4 4B]
    CALL    sub_2442                                         ; [24A3: E8 9C FF]
    JC      loc_24a9                                         ; [24A6: 72 01]
    RETN                                                     ; [24A8: C3]
loc_24a9:
    MOV     BX, 0010                                         ; [24A9: BB 10 00]
    MOV     CX, 0008                                         ; [24AC: B9 08 00]
loc_24af:
    MOV     AX, WORD [BX+DI]                                 ; [24AF: 8B 01]
    CMP     AX, 0000                                         ; [24B1: 3D 00 00]
    JZ      loc_24cc                                         ; [24B4: 74 16]
    PUSH    BX                                               ; [24B6: 53]
    PUSH    CX                                               ; [24B7: 51]
    PUSH    DI                                               ; [24B8: 57]
    CALL    sub_24d4                                         ; [24B9: E8 18 00]
    POP     DI                                               ; [24BC: 5F]
    POP     CX                                               ; [24BD: 59]
    POP     BX                                               ; [24BE: 5B]
    ADD     BX, +02                                          ; [24BF: 83 C3 02]
    LOOP    loc_24af                                         ; [24C2: E2 EB]
    MOV     SI, 4BA4                                         ; [24C4: BE A4 4B]
    CALL    sub_2442                                         ; [24C7: E8 78 FF]
    JC      loc_24a9                                         ; [24CA: 72 DD]
loc_24cc:
    MOV     WORD [var_lan_buf_pointer], 4BB7                 ; [24CC: C7 06 B5 4B B7 4B]
    STC                                                      ; [24D2: F9]
    RETN                                                     ; [24D3: C3]
sub_24d4:
    MOV     SI, WORD [var_lan_buf_pointer]                   ; [24D4: 8B 36 B5 4B]
    MOV     DI, SI                                           ; [24D8: 8B FE]
    MOV     CX, WORD [ES:var_floppy_gap_length]              ; [24DA: 26 8B 0E 7C 00]
    XOR     DX, DX                                           ; [24DF: 33 D2]
    DIV     CX                                               ; [24E1: F7 F1]
    ADD     AX, WORD [ES:var_floppy_last_seek]               ; [24E3: 26 03 06 75 00]
    MOV     BYTE [SI], AL                                    ; [24E8: 88 04]
    MOV     AX, DX                                           ; [24EA: 8B C2]
    XOR     DX, DX                                           ; [24EC: 33 D2]
    MOV     CX, WORD [ES:var_nvram_boot_default]             ; [24EE: 26 8B 0E 80 00]
    DIV     CX                                               ; [24F3: F7 F1]
    MOV     BYTE [SI+01], AL                                 ; [24F5: 88 44 01]
    MOV     AX, DX                                           ; [24F8: 8B C2]
    MOV     CX, WORD [ES:var_floppy_data_length]             ; [24FA: 26 8B 0E 7E 00]
    MUL     CX                                               ; [24FF: F7 E1]
    INC     AX                                               ; [2501: 40]
    MOV     BYTE [SI+02], AL                                 ; [2502: 88 44 02]
    INC     WORD [var_lan_data_byte_count]                   ; [2505: FF 06 B3 4B]
    ADD     DI, +03                                          ; [2509: 83 C7 03]
    MOV     CX, WORD [ES:var_floppy_data_length]             ; [250C: 26 8B 0E 7E 00]
    DEC     CX                                               ; [2511: 49]
    MOV     DL, BYTE [ES:var_floppy_drive_type]              ; [2512: 26 8A 16 6A 00]
loc_2517:
    CMP     AL, DL                                           ; [2517: 3A C2]
    JZ      loc_252c                                         ; [2519: 74 11]
    INC     AL                                               ; [251B: FE C0]
    MOV     BYTE [DI+02], AL                                 ; [251D: 88 45 02]
    MOV     AH, BYTE [SI]                                    ; [2520: 8A 24]
    MOV     BYTE [DI], AH                                    ; [2522: 88 25]
    MOV     AH, BYTE [SI+01]                                 ; [2524: 8A 64 01]
    MOV     BYTE [DI+01], AH                                 ; [2527: 88 65 01]
    JMPS    loc_254f                                         ; [252A: EB 23]
loc_252c:
    CMP     BYTE [SI+01], 00                                 ; [252C: 80 7C 01 00]
    JNZ     loc_253f                                         ; [2530: 75 0D]
    MOV     BYTE [DI+02], AL                                 ; [2532: 88 45 02]
    MOV     BYTE [DI+01], 01                                 ; [2535: C6 45 01 01]
    MOV     AH, BYTE [SI]                                    ; [2539: 8A 24]
    MOV     BYTE [DI], AH                                    ; [253B: 88 25]
    JMPS    loc_254f                                         ; [253D: EB 10]
loc_253f:
    MOV     AH, BYTE [SI]                                    ; [253F: 8A 24]
    INC     AH                                               ; [2541: FE C4]
    MOV     BYTE [DI], AH                                    ; [2543: 88 25]
    MOV     BYTE [DI+01], 00                                 ; [2545: C6 45 01 00]
    MOV     BYTE [DI+02], 01                                 ; [2549: C6 45 02 01]
    MOV     AL, 01                                           ; [254D: B0 01]
loc_254f:
    ADD     DI, +03                                          ; [254F: 83 C7 03]
    ADD     SI, +03                                          ; [2552: 83 C6 03]
    INC     WORD [var_lan_data_byte_count]                   ; [2555: FF 06 B3 4B]
    LOOP    loc_2517                                         ; [2559: E2 BC]
    MOV     WORD [var_lan_buf_pointer], DI                   ; [255B: 89 3E B5 4B]
    RETN                                                     ; [255F: C3]
sub_2560:
    MOV     CX, WORD [var_lan_data_byte_count]               ; [2560: 8B 0E B3 4B]
    MOV     BX, 0000                                         ; [2564: BB 00 00]
    CMP     CX, +00                                          ; [2567: 83 F9 00]
    JNZ     loc_256e                                         ; [256A: 75 02]
    CLC                                                      ; [256C: F8]
    RETN                                                     ; [256D: C3]
loc_256e:
    MOV     DI, WORD [var_lan_buf_pointer]                   ; [256E: 8B 3E B5 4B]
    MOV     AH, BYTE [DI]                                    ; [2572: 8A 25]
    MOV     BYTE [rom_segment_base], AH                      ; [2574: 88 26 00 00]
    MOV     DL, BYTE [DI+01]                                 ; [2578: 8A 55 01]
    MOV     BYTE [var_dma0_status], DL                       ; [257B: 88 16 01 00]
    MOV     AL, BYTE [DI+02]                                 ; [257F: 8A 45 02]
    MOV     [ram_segment_base], AL                           ; [2582: A2 02 00]
loc_2585:
    CMP     BYTE [DI], AH                                    ; [2585: 38 25]
    JNZ     loc_259f                                         ; [2587: 75 16]
    CMP     BYTE [DI+01], DL                                 ; [2589: 38 55 01]
    JNZ     loc_259f                                         ; [258C: 75 11]
    CMP     BYTE [DI+02], AL                                 ; [258E: 38 45 02]
    JNZ     loc_259f                                         ; [2591: 75 0C]
    ADD     BX, WORD [ES:var_floppy_sector_num]              ; [2593: 26 03 1E 6B 00]
    INC     AL                                               ; [2598: FE C0]
    ADD     DI, +03                                          ; [259A: 83 C7 03]
    LOOP    loc_2585                                         ; [259D: E2 E6]
loc_259f:
    MOV     WORD [var_lan_buf_pointer], DI                   ; [259F: 89 3E B5 4B]
    MOV     WORD [var_lan_data_byte_count], CX               ; [25A3: 89 0E B3 4B]
    STC                                                      ; [25A7: F9]
    RETN                                                     ; [25A8: C3]
sub_25a9:
    MOV     DX, io_ppi_portb             ; 8255 PPI Port B (Monitor type 50/60Hz, RTC type) ; [25A9: BA 72 00]
    IN      AL, DX                                           ; [25AC: EC]
    RETN                                                     ; [25AD: C3]
sub_25ae:
    CALL    sub_26e8                                         ; [25AE: E8 37 01]
    MOV     DX, io_rtc_addr              ; MM58167 RTC Address / Control register ; [25B1: BA 5C 00]
    AND     AL, 1F                                           ; [25B4: 24 1F]
    OUT     DX, AL                                           ; [25B6: EE]
    SUB     DX, +02                                          ; [25B7: 83 EA 02]
    XCHG    AL, AH                                           ; [25BA: 86 E0]
    OUT     DX, AL                                           ; [25BC: EE]
    XCHG    AL, AH                                           ; [25BD: 86 E0]
    ADD     DX, +02                                          ; [25BF: 83 C2 02]
    OR      AL, 40                                           ; [25C2: 0C 40]
    OUT     DX, AL                                           ; [25C4: EE]
    NOP                                                      ; [25C5: 90]
    NOP                                                      ; [25C6: 90]
    NOP                                                      ; [25C7: 90]
    NOP                                                      ; [25C8: 90]
    AND     AL, 1F                                           ; [25C9: 24 1F]
    OUT     DX, AL                                           ; [25CB: EE]
    RETN                                                     ; [25CC: C3]
sub_25cd:
    MOV     DX, io_rtc_addr              ; MM58167 RTC Address / Control register ; [25CD: BA 5C 00]
    OR      AL, 80                                           ; [25D0: 0C 80]
    OUT     DX, AL                                           ; [25D2: EE]
    OR      AL, A0                                           ; [25D3: 0C A0]
    OUT     DX, AL                                           ; [25D5: EE]
    NOP                                                      ; [25D6: 90]
    NOP                                                      ; [25D7: 90]
    NOP                                                      ; [25D8: 90]
    NOP                                                      ; [25D9: 90]
    XCHG    AL, AH                                           ; [25DA: 86 E0]
    IN      AL, DX                                           ; [25DC: EC]
    XCHG    AL, AH                                           ; [25DD: 86 E0]
    AND     AL, 9F                                           ; [25DF: 24 9F]
    OUT     DX, AL                                           ; [25E1: EE]
    AND     AH, 7F                                           ; [25E2: 80 E4 7F]
    CALL    sub_26cc                                         ; [25E5: E8 E4 00]
    RETN                                                     ; [25E8: C3]
sub_25e9:
    MOV     BX, 648D                                         ; [25E9: BB 8D 64]
    MOV     AH, 00                                           ; [25EC: B4 00]
    MOV     AL, 18                                           ; [25EE: B0 18]
    PUSH    AX                                               ; [25F0: 50]
    MOV     AH, BYTE [BX]                                    ; [25F1: 8A 27]
    CALL    sub_26e8                                         ; [25F3: E8 F2 00]
    MOV     CL, AH                                           ; [25F6: 8A CC]
    POP     AX                                               ; [25F8: 58]
    CALL    boot_setup_memory_params                         ; [25F9: E8 3F 18]
    MOV     AH, 00                                           ; [25FC: B4 00]
    MOV     AL, 17                                           ; [25FE: B0 17]
    INC     BX                                               ; [2600: 43]
    PUSH    AX                                               ; [2601: 50]
    MOV     AH, BYTE [BX]                                    ; [2602: 8A 27]
    CALL    sub_26e8                                         ; [2604: E8 E1 00]
    MOV     CL, AH                                           ; [2607: 8A CC]
    POP     AX                                               ; [2609: 58]
    CALL    boot_setup_memory_params                         ; [260A: E8 2E 18]
    CALL    sub_25a9                                         ; [260D: E8 99 FF]
    AND     AL, 02                                           ; [2610: 24 02]
    JZ      loc_263c                                         ; [2612: 74 28]
    MOV     AH, BYTE [BX]                                    ; [2614: 8A 27]
    MOV     AL, 07                                           ; [2616: B0 07]
    CALL    sub_25ae                                         ; [2618: E8 93 FF]
    INC     BX                                               ; [261B: 43]
    MOV     AH, BYTE [BX]                                    ; [261C: 8A 27]
    MOV     AL, 06                                           ; [261E: B0 06]
    CALL    sub_25ae                                         ; [2620: E8 8B FF]
    INC     BX                                               ; [2623: 43]
    MOV     AH, BYTE [BX]                                    ; [2624: 8A 27]
    MOV     AL, 04                                           ; [2626: B0 04]
    CALL    sub_25ae                                         ; [2628: E8 83 FF]
    INC     BX                                               ; [262B: 43]
    MOV     AH, BYTE [BX]                                    ; [262C: 8A 27]
    MOV     AL, 03                                           ; [262E: B0 03]
    CALL    sub_25ae                                         ; [2630: E8 7B FF]
    INC     BX                                               ; [2633: 43]
    MOV     AH, BYTE [BX]                                    ; [2634: 8A 27]
    MOV     AL, 02                                           ; [2636: B0 02]
    CALL    sub_25ae                                         ; [2638: E8 73 FF]
    RETN                                                     ; [263B: C3]
loc_263c:
    MOV     AH, BYTE [BX]                                    ; [263C: 8A 27]
    MOV     AL, 06                                           ; [263E: B0 06]
    CALL    sub_25ae                                         ; [2640: E8 6B FF]
    INC     BX                                               ; [2643: 43]
    MOV     AH, BYTE [BX]                                    ; [2644: 8A 27]
    MOV     AL, 05                                           ; [2646: B0 05]
    CALL    sub_25ae                                         ; [2648: E8 63 FF]
    INC     BX                                               ; [264B: 43]
    MOV     AH, BYTE [BX]                                    ; [264C: 8A 27]
    MOV     AL, 04                                           ; [264E: B0 04]
    CALL    sub_25ae                                         ; [2650: E8 5B FF]
    INC     BX                                               ; [2653: 43]
    MOV     AH, BYTE [BX]                                    ; [2654: 8A 27]
    MOV     AL, 03                                           ; [2656: B0 03]
    CALL    sub_25ae                                         ; [2658: E8 53 FF]
    INC     BX                                               ; [265B: 43]
    MOV     AH, BYTE [BX]                                    ; [265C: 8A 27]
    MOV     AL, 02                                           ; [265E: B0 02]
    CALL    sub_25ae                                         ; [2660: E8 4B FF]
    RETN                                                     ; [2663: C3]
sub_2664:
    MOV     BX, 648D                                         ; [2664: BB 8D 64]
    MOV     AX, 0018                                         ; [2667: B8 18 00]
    CALL    nvram_read_byte_al                               ; [266A: E8 4D 15]
    MOV     AH, AL                                           ; [266D: 8A E0]
    CALL    sub_26cc                                         ; [266F: E8 5A 00]
    MOV     BYTE [BX], AH                                    ; [2672: 88 27]
    INC     BX                                               ; [2674: 43]
    CALL    sub_25a9                                         ; [2675: E8 31 FF]
    AND     AL, 02                                           ; [2678: 24 02]
    JZ      loc_26a4                                         ; [267A: 74 28]
    MOV     AL, 07                                           ; [267C: B0 07]
    CALL    sub_25cd                                         ; [267E: E8 4C FF]
    MOV     BYTE [BX], AH                                    ; [2681: 88 27]
    INC     BX                                               ; [2683: 43]
    MOV     AL, 06                                           ; [2684: B0 06]
    CALL    sub_25cd                                         ; [2686: E8 44 FF]
    MOV     BYTE [BX], AH                                    ; [2689: 88 27]
    INC     BX                                               ; [268B: 43]
    MOV     AL, 04                                           ; [268C: B0 04]
    CALL    sub_25cd                                         ; [268E: E8 3C FF]
    MOV     BYTE [BX], AH                                    ; [2691: 88 27]
    INC     BX                                               ; [2693: 43]
    MOV     AL, 03                                           ; [2694: B0 03]
    CALL    sub_25cd                                         ; [2696: E8 34 FF]
    MOV     BYTE [BX], AH                                    ; [2699: 88 27]
    INC     BX                                               ; [269B: 43]
    MOV     AL, 02                                           ; [269C: B0 02]
    CALL    sub_25cd                                         ; [269E: E8 2C FF]
    MOV     BYTE [BX], AH                                    ; [26A1: 88 27]
    RETN                                                     ; [26A3: C3]
loc_26a4:
    MOV     AL, 06                                           ; [26A4: B0 06]
    CALL    sub_25cd                                         ; [26A6: E8 24 FF]
    MOV     BYTE [BX], AH                                    ; [26A9: 88 27]
    INC     BX                                               ; [26AB: 43]
    MOV     AL, 05                                           ; [26AC: B0 05]
    CALL    sub_25cd                                         ; [26AE: E8 1C FF]
    MOV     BYTE [BX], AH                                    ; [26B1: 88 27]
    INC     BX                                               ; [26B3: 43]
    MOV     AL, 04                                           ; [26B4: B0 04]
    CALL    sub_25cd                                         ; [26B6: E8 14 FF]
    MOV     BYTE [BX], AH                                    ; [26B9: 88 27]
    INC     BX                                               ; [26BB: 43]
    MOV     AL, 03                                           ; [26BC: B0 03]
    CALL    sub_25cd                                         ; [26BE: E8 0C FF]
    MOV     BYTE [BX], AH                                    ; [26C1: 88 27]
    INC     BX                                               ; [26C3: 43]
    MOV     AL, 02                                           ; [26C4: B0 02]
    CALL    sub_25cd                                         ; [26C6: E8 04 FF]
    MOV     BYTE [BX], AH                                    ; [26C9: 88 27]
    RETN                                                     ; [26CB: C3]
sub_26cc:
    MOV     DH, AL                                           ; [26CC: 8A F0]
    MOV     AL, AH                                           ; [26CE: 8A C4]
    PUSH    AX                                               ; [26D0: 50]
    MOV     CL, 04                                           ; [26D1: B1 04]
    SHR     AL, CL                                           ; [26D3: D2 E8]
    AND     AL, 0F                                           ; [26D5: 24 0F]
    MOV     DL, 0A                                           ; [26D7: B2 0A]
    MUL     DL                                               ; [26D9: F6 E2]
    MOV     DL, AL                                           ; [26DB: 8A D0]
    POP     AX                                               ; [26DD: 58]
    AND     AH, 0F                                           ; [26DE: 80 E4 0F]
    ADD     AH, DL                                           ; [26E1: 02 E2]
    MOV     AL, DH                                           ; [26E3: 8A C6]
    MOV     AL, DH                                           ; [26E5: 8A C6]
    RETN                                                     ; [26E7: C3]
sub_26e8:
    MOV     DH, AL                                           ; [26E8: 8A F0]
    MOV     AL, AH                                           ; [26EA: 8A C4]
    MOV     AH, 00                                           ; [26EC: B4 00]
    MOV     DL, 0A                                           ; [26EE: B2 0A]
    DIV     DL                                               ; [26F0: F6 F2]
    MOV     CL, 04                                           ; [26F2: B1 04]
    SHL     AL, CL                                           ; [26F4: D2 E0]
    AND     AL, F0                                           ; [26F6: 24 F0]
    AND     AH, 0F                                           ; [26F8: 80 E4 0F]
    ADD     AH, AL                                           ; [26FB: 02 E0]
    MOV     AL, DH                                           ; [26FD: 8A C6]
    RETN                                                     ; [26FF: C3]

; ----------------------------------------------------------------------------
; bootloader_main_entry (ROM: 5F40h, FB84:2700h)
; ----------------------------------------------------------------------------
bootloader_main_entry:
    CLI                                                      ; [2700: FA]
    XOR     AX, AX                                           ; [2701: 33 C0]
    MOV     ES, AX                                           ; [2703: 8E C0]
    MOV     AX, LAN_BUFFER_SEGMENT                           ; [2705: B8 00 36]
    MOV     DS, AX                                           ; [2708: 8E D8]
    MOV     SS, AX                                           ; [270A: 8E D0]
    MOV     SP, 4000                                         ; [270C: BC 00 40]
    CALL    fdc_motor_off                                    ; [270F: E8 FB 15]
    CALL    fdc_release_bus                                  ; [2712: E8 0F 16]
    CALL    init_fdc_hardware                                ; [2715: E8 C6 11]
    MOV     BYTE [var_boot_status], 00                       ; [2718: C6 06 14 00 00]
loc_271d:
    MOV     DX, io_i186_dma0_ctrl        ; 80186 DMA 0 Control register ; [271D: BA CA FF]
    MOV     AX, 0004                                         ; [2720: B8 04 00]
    OUT     DX, AX                                           ; [2723: EF]
    MOV     DX, io_i186_dma1_ctrl        ; 80186 DMA 1 Control register ; [2724: BA DA FF]
    OUT     DX, AX                                           ; [2727: EF]
    MOV     DX, io_pic_icw2_ocw          ; 8259A PIC ICW2/OCW (Base vector 20h) ; [2728: BA 02 00]
    MOV     AL, FD                                           ; [272B: B0 FD]
    OUT     DX, AL                                           ; [272D: EE]
    MOV     DX, io_i186_eoi              ; 80186 INTC End-Of-Interrupt (EOI) register ; [272E: BA 22 FF]
    MOV     AX, 8000                                         ; [2731: B8 00 80]
    OUT     DX, AX                                           ; [2734: EF]
    STI                                                      ; [2735: FB]
    MOV     AL, [ES:var_boot_drive_preselect] ; Boot drive preselection buffer ('A', 'B', etc.) ; [2736: 26 A0 67 00]
    CALL    validate_boot_device_char                        ; [273A: E8 61 11]
    JNC     loc_2759                                         ; [273D: 73 1A]
    MOV     AH, 00                                           ; [273F: B4 00]
    MOV     AL, 19                                           ; [2741: B0 19]
    CALL    nvram_read_byte_al                               ; [2743: E8 74 14]
    CALL    validate_boot_device_char                        ; [2746: E8 55 11]
    JNC     loc_2759                                         ; [2749: 73 0E]
    CMP     BYTE [var_boot_drive_table], 00                  ; [274B: 80 3E 15 00 00]
    JZ      loc_2757                                         ; [2750: 74 05]
    MOV     AL, 00                                           ; [2752: B0 00]
    JMPN    loc_2759                                         ; [2754: E9 02 00]
loc_2757:
    MOV     AL, 04                                           ; [2757: B0 04]
loc_2759:
    XOR     AH, AH                                           ; [2759: 32 E4]
    PUSH    AX                                               ; [275B: 50]
    PUSH    ES                                               ; [275C: 06]
    MOV     AX, 0000                                         ; [275D: B8 00 00]
    CALL    set_cursor_pos                                   ; [2760: E8 16 DB]
    MOV     AX, 317A                                         ; [2763: B8 7A 31]
    MOV     CX, FFFF                                         ; [2766: B9 FF FF]
    CALL    print_string_es_ax                               ; [2769: E8 40 DC]
    POP     ES                                               ; [276C: 07]
    POP     AX                                               ; [276D: 58]
    CMP     AL, 07                                           ; [276E: 3C 07]
    JZ      loc_27a0                                         ; [2770: 74 2E]
    CALL    fdc_reserve_bus                                  ; [2772: E8 C9 15]
    MOV     DI, 278C                                         ; [2775: BF 8C 27]
    SHL     AX, 1                                            ; [2778: D1 E0]
    ADD     DI, AX                                           ; [277A: 03 F8]
    CALL    WORD [CS:DI+0000]                                ; [277C: 2E FF 95 00 00]
    CMP     BYTE [var_boot_status], FF                       ; [2781: 80 3E 14 00 FF]
    JNZ     loc_27a0                                         ; [2786: 75 18]
    JMPF    WORD [var_boot_entry_addr]                       ; [2788: FF 2E 1A 00]

; ----------------------------------------------------------------------------
; boot_device_vector_table (ROM: 5FCCh, FB84:278Ch)
; Boot device funktionstabeller for CALL [CS:DI] (FB84:277C)
; ----------------------------------------------------------------------------
boot_device_vector_table:
    DW  boot_from_floppy_a_or_b      ; [278Ch] Boot Medium 'A': Floppy A (27ACh)
    DW  boot_from_floppy_a_or_b      ; [278Eh] Boot Medium 'B': Floppy B (27ACh)
    DW  boot_from_floppy_a_or_b      ; [2790h] Boot Medium 'C': Floppy C (27ACh)
    DW  boot_from_floppy_a_or_b      ; [2792h] Boot Medium 'D': Floppy D (27ACh)
    DW  sub_28bd                     ; [2794h] Boot Medium 'N': Net (28BDh)
    DW  sub_27ee                     ; [2796h] Boot Medium 'M': ROM-disk (27EEh)
    DW  sub_4191                     ; [2798h] Boot Medium 'W': Winchester (4191h)
    DW  boot_from_network            ; [279Ah] Boot Medium Default/Invalid (27CEh)
    INTO                                                     ; [279C: CE]
    DAA                                                      ; [279D: 27]
    IRET                                                     ; [279E: CF]
    INC     CX                                               ; [279F: 41]
loc_27a0:
    CALL    nvram_write_byte_al                              ; [27A0: E8 49 14]
    CALL    fdc_motor_off                                    ; [27A3: E8 67 15]
    CALL    fdc_release_bus                                  ; [27A6: E8 7B 15]
    JMPN    loc_271d                                         ; [27A9: E9 71 FF]

; ----------------------------------------------------------------------------
; boot_from_floppy_a_or_b (ROM: 5FECh, FB84:27ACh)
; ----------------------------------------------------------------------------
boot_from_floppy_a_or_b:
    SHR     AL, 1                                            ; [27AC: D0 E8]
    PUSH    AX                                               ; [27AE: 50]
    MOV     [var_boot_device_char], AL   ; NVRAM Byte 25 (0x19): Boot device parameter ('A'=Floppy, 'N'=Net) ; [27AF: A2 19 00]
    ADD     AL, 41                                           ; [27B2: 04 41]
    MOV     [ES:var_boot_drive_preselect], AL ; Boot drive preselection buffer ('A', 'B', etc.) ; [27B4: 26 A2 67 00]
    POP     AX                                               ; [27B8: 58]
    MOV     BX, 0015                                         ; [27B9: BB 15 00]
    XLAT                                                     ; [27BC: D7]
    CMP     AL, 00                                           ; [27BD: 3C 00]
    MOV     BX, 0069                                         ; [27BF: BB 69 00]
    JNZ     loc_27c7                                         ; [27C2: 75 03]
    JMPN    loc_388e                                         ; [27C4: E9 C7 10]
loc_27c7:
    MOV     BYTE [ES:BX], 01                                 ; [27C7: 26 C6 07 01]
    JMPN    fdc_boot_read_sector                             ; [27CB: E9 D5 0F]

; ----------------------------------------------------------------------------
; boot_from_network (ROM: 600Eh, FB84:27CEh)
; ----------------------------------------------------------------------------
boot_from_network:
    PUSH    DS                                               ; [27CE: 1E]
    PUSH    ES                                               ; [27CF: 06]
    CALL    fdc_release_bus                                  ; [27D0: E8 51 15]
    MOV     AX, 0200                                         ; [27D3: B8 00 02]
    CALL    set_cursor_pos                                   ; [27D6: E8 A0 DA]
    MOV     AX, [CS:rom_segment_base]                        ; [27D9: 2E A1 00 00]
    MOV     ES, AX                                           ; [27DD: 8E C0]
    MOV     AX, [CS:ram_segment_base]                        ; [27DF: 2E A1 02 00]
    MOV     DS, AX                                           ; [27E3: 8E D8]
    CALL    menu_enter_snooper                               ; [27E5: E8 90 F9]
    POP     ES                                               ; [27E8: 07]
    POP     DS                                               ; [27E9: 1F]
    CALL    fdc_release_bus                                  ; [27EA: E8 37 15]
    RETN                                                     ; [27ED: C3]
sub_27ee:
    CALL    sub_2813                                         ; [27EE: E8 22 00]
    JC      loc_2812                                         ; [27F1: 72 1F]
    CALL    sub_2876                                         ; [27F3: E8 80 00]
    MOV     AL, 41                                           ; [27F6: B0 41]
    MOV     [ES:var_boot_drive_preselect], AL ; Boot drive preselection buffer ('A', 'B', etc.) ; [27F8: 26 A2 67 00]
    MOV     BYTE [var_boot_status], FF                       ; [27FC: C6 06 14 00 FF]
    MOV     AX, DS                                           ; [2801: 8C D8]
    MOV     ES, AX                                           ; [2803: 8E C0]
    MOV     BX, 0020                                         ; [2805: BB 20 00]
    MOV     AX, WORD [ES:BX]                                 ; [2808: 26 8B 07]
    MOV     DS, AX                                           ; [280B: 8E D8]
    JMPF    WORD [ES:var_boot_entry_addr]                    ; [280D: 26 FF 2E 1A 00]
loc_2812:
    RETN                                                     ; [2812: C3]
sub_2813:
    PUSH    DS                                               ; [2813: 1E]
    PUSH    ES                                               ; [2814: 06]
    MOV     AX, LAN_BUFFER_SEGMENT                           ; [2815: B8 00 36]
    MOV     ES, AX                                           ; [2818: 8E C0]
    MOV     AX, 4000                                         ; [281A: B8 00 40]
    MOV     DS, AX                                           ; [281D: 8E D8]
    MOV     DI, 0800                                         ; [281F: BF 00 08]
    CMP     BYTE [DI], 01                                    ; [2822: 80 3D 01]
    CMP     BYTE [DI], 01                                    ; [2825: 80 3D 01]
    CMP     BYTE [DI], 01                                    ; [2828: 80 3D 01]
    JNZ     loc_2872                                         ; [282B: 75 45]
    MOV     BX, WORD [DI+01]                                 ; [282D: 8B 5D 01]
    MOV     BX, WORD [DI+01]                                 ; [2830: 8B 5D 01]
    MOV     BX, WORD [DI+01]                                 ; [2833: 8B 5D 01]
    MOV     AX, WORD [DI+03]                                 ; [2836: 8B 45 03]
    MOV     AX, WORD [DI+03]                                 ; [2839: 8B 45 03]
    MOV     AX, WORD [DI+03]                                 ; [283C: 8B 45 03]
    ADD     BX, AX                                           ; [283F: 03 D8]
    PUSH    BX                                               ; [2841: 53]
    MOV     BX, 001A                                         ; [2842: BB 1A 00]
    MOV     WORD [ES:BX], 0000                               ; [2845: 26 C7 07 00 00]
    INC     BX                                               ; [284A: 43]
    INC     BX                                               ; [284B: 43]
    MOV     WORD [ES:BX], AX                                 ; [284C: 26 89 07]
    SUB     AX, 0008                                         ; [284F: 2D 08 00]
    MOV     BX, 0033                                         ; [2852: BB 33 00]
    MOV     WORD [ES:BX], AX                                 ; [2855: 26 89 07]
    POP     BX                                               ; [2858: 5B]
    MOV     AX, WORD [DI+0C]                                 ; [2859: 8B 45 0C]
    MOV     AX, WORD [DI+0C]                                 ; [285C: 8B 45 0C]
    MOV     AX, WORD [DI+0C]                                 ; [285F: 8B 45 0C]
    CMP     AX, BX                                           ; [2862: 3B C3]
    JNZ     loc_2872                                         ; [2864: 75 0C]
    PUSH    BX                                               ; [2866: 53]
    MOV     BX, 0020                                         ; [2867: BB 20 00]
    MOV     WORD [ES:BX], AX                                 ; [286A: 26 89 07]
    POP     BX                                               ; [286D: 5B]
    POP     ES                                               ; [286E: 07]
    POP     DS                                               ; [286F: 1F]
    CLC                                                      ; [2870: F8]
    RETN                                                     ; [2871: C3]
loc_2872:
    POP     ES                                               ; [2872: 07]
    POP     DS                                               ; [2873: 1F]
    STC                                                      ; [2874: F9]
    RETN                                                     ; [2875: C3]
sub_2876:
    PUSH    DS                                               ; [2876: 1E]
    PUSH    ES                                               ; [2877: 06]
    MOV     BX, 0033                                         ; [2878: BB 33 00]
    MOV     AX, WORD [BX]                                    ; [287B: 8B 07]
    MOV     DS, AX                                           ; [287D: 8E D8]
    MOV     CX, 0000                                         ; [287F: B9 00 00]
    MOV     AX, 4000                                         ; [2882: B8 00 40]
    MOV     ES, AX                                           ; [2885: 8E C0]
    MOV     DX, 0800                                         ; [2887: BA 00 08]
loc_288a:
    MOV     BX, DX                                           ; [288A: 8B DA]
    MOV     AX, WORD [ES:BX]                                 ; [288C: 26 8B 07]
    MOV     AX, WORD [ES:BX]                                 ; [288F: 26 8B 07]
    MOV     AX, WORD [ES:BX]                                 ; [2892: 26 8B 07]
    MOV     BX, CX                                           ; [2895: 8B D9]
    MOV     WORD [BX], AX                                    ; [2897: 89 07]
    INC     CX                                               ; [2899: 41]
    INC     CX                                               ; [289A: 41]
    INC     DX                                               ; [289B: 42]
    INC     DX                                               ; [289C: 42]
    CMP     CX, +00                                          ; [289D: 83 F9 00]
    JNZ     loc_28a9                                         ; [28A0: 75 07]
    MOV     AX, DS                                           ; [28A2: 8C D8]
    ADD     AX, 1000                                         ; [28A4: 05 00 10]
    MOV     DS, AX                                           ; [28A7: 8E D8]
loc_28a9:
    CMP     DX, +00                                          ; [28A9: 83 FA 00]
    JNZ     loc_288a                                         ; [28AC: 75 DC]
    MOV     AX, ES                                           ; [28AE: 8C C0]
    ADD     AX, 1000                                         ; [28B0: 05 00 10]
    MOV     ES, AX                                           ; [28B3: 8E C0]
    CMP     AX, 6000                                         ; [28B5: 3D 00 60]
    JNZ     loc_288a                                         ; [28B8: 75 D0]
    POP     ES                                               ; [28BA: 07]
    POP     DS                                               ; [28BB: 1F]
    RETN                                                     ; [28BC: C3]
sub_28bd:
    MOV     AX, [CS:ram_segment_base]                        ; [28BD: 2E A1 02 00]
    MOV     ES, AX                                           ; [28C1: 8E C0]
    CMP     BYTE [ES:var_boot_retry_counter], FF             ; [28C3: 26 80 3E 5D 00 FF]
    JZ      loc_28db                                         ; [28C9: 74 10]
    MOV     AX, 3001                                         ; [28CB: B8 01 30]
    CALL    set_cursor_pos                                   ; [28CE: E8 A8 D9]
    MOV     AX, 319C                                         ; [28D1: B8 9C 31]
    MOV     CX, 0013                                         ; [28D4: B9 13 00]
    CALL    print_string_es_ax                               ; [28D7: E8 D2 DA]
    RETN                                                     ; [28DA: C3]
loc_28db:
    MOV     BYTE [var_lan_rx_ready_flag], 01                 ; [28DB: C6 06 9F 4B 01]
    JMPN    loc_3584                                         ; [28E0: E9 A1 0C]
sub_28e3:
    PUSHA                                                    ; [28E3: 60]
    MOV     AX, LAN_BUFFER_SEGMENT                           ; [28E4: B8 00 36]
    MOV     ES, AX                                           ; [28E7: 8E C0]
    MOV     DI, 00F8                                         ; [28E9: BF F8 00]
    MOV     CX, 0003                                         ; [28EC: B9 03 00]
    REP MOVSW                                                ; [28EF: F3 A5]
    POPA                                                     ; [28F1: 61]
    RETN                                                     ; [28F2: C3]
sub_28f3:
    CMP     WORD [var_screen_cursor_row], +00                ; [28F3: 83 3E E2 00 00]
    JNZ     sub_28f3                                         ; [28F8: 75 F9]
    MOV     [var_screen_cursor_row], AX                      ; [28FA: A3 E2 00]
    MOV     DX, 0100                                         ; [28FD: BA 00 01]
    IN      AL, DX                                           ; [2900: EC]
    RETN                                                     ; [2901: C3]
sub_2902:
    XCHG    CH, CL                                           ; [2902: 86 CD]
    MOV     WORD [var_82730_row_table_ptr], CX               ; [2904: 89 0E FE 00]
    XCHG    CH, CL                                           ; [2908: 86 CD]
    CMP     CX, +2E                                          ; [290A: 83 F9 2E]
    JNC     loc_2912                                         ; [290D: 73 03]
    MOV     CX, 002E                                         ; [290F: B9 2E 00]
loc_2912:
    OR      CX, 8000                                         ; [2912: 81 C9 00 80]
    MOV     WORD [var_82730_row_attrib], CX                  ; [2916: 89 0E 00 01]
    MOV     WORD [var_screen_scroll_direction], 8004         ; [291A: C7 06 F2 00 04 80]
    MOV     AX, 0100                                         ; [2920: B8 00 01]
    CALL    sub_28f3                                         ; [2923: E8 CD FF]
    CALL    sub_2eda                                         ; [2926: E8 B1 05]
    OR      AL, AL                                           ; [2929: 0A C0]
    JNZ     loc_2934                                         ; [292B: 75 07]
    MOV     WORD [var_screen_scroll_count], 0000             ; [292D: C7 06 F0 00 00 00]
    RETN                                                     ; [2933: C3]
loc_2934:
    RETN                                                     ; [2934: C3]

; ----------------------------------------------------------------------------
; diag_test_handler_vector_table (ROM: 6175h, FB84:2935h)
; Selftest sub-handler funktionstabel for CALL [CS:BX+2935] (FB84:299D)
; ----------------------------------------------------------------------------
diag_test_handler_vector_table:
    DW  sub_29fc                     ; [2935h] Handler 0 (29FCh)
    DW  sub_29fd                     ; [2937h] Handler 1 (29FDh)
    DW  sub_29fc                     ; [2939h] Handler 2 (29FCh)
    DW  sub_2a96                     ; [293Bh] Handler 3 (2A96h)
    DW  sub_2a73                     ; [293Dh] Handler 4 (2A73h)
sub_293f:
    MOV     BYTE [var_lan_rx_status], FF                     ; [293F: C6 06 2D 4B FF]
loc_2944:
    CALL    sub_2c2f                                         ; [2944: E8 E8 02]
    OR      AL, AL                                           ; [2947: 0A C0]
    JNZ     loc_2952                                         ; [2949: 75 07]
    CALL    sub_2c86                                         ; [294B: E8 38 03]
    OR      CX, CX                                           ; [294E: 0B C9]
    JNZ     loc_2967                                         ; [2950: 75 15]
loc_2952:
    PUSH    ES                                               ; [2952: 06]
    MOV     AX, [CS:ram_segment_base]                        ; [2953: 2E A1 02 00]
    MOV     ES, AX                                           ; [2957: 8E C0]
    MOV     AX, [ES:var_timer0_tick_count] ; Timer 0 tick counter (incremented by timer ISR) ; [2959: 26 A1 35 01]
    POP     ES                                               ; [295D: 07]
    CMP     AX, WORD [var_lan_packet_len]                    ; [295E: 3B 06 2B 4B]
    JC      loc_2944                                         ; [2962: 72 E0]
    MOV     AL, 01                                           ; [2964: B0 01]
    RETN                                                     ; [2966: C3]
loc_2967:
    PUSH    CX                                               ; [2967: 51]
    PUSH    BX                                               ; [2968: 53]
    TEST    WORD [BX], 2000                                  ; [2969: F7 07 00 20]
    JZ      loc_29af                                         ; [296D: 74 40]
    MOV     SI, WORD [BX+06]                                 ; [296F: 8B 77 06]
    TEST    WORD [SI], 8000                                  ; [2972: F7 04 00 80]
    JNZ     loc_297a                                         ; [2976: 75 02]
    JMPS    loc_29af                                         ; [2978: EB 35]
loc_297a:
    MOV     DI, WORD [SI+04]                                 ; [297A: 8B 7C 04]
    MOV     AX, WORD [SI+06]                                 ; [297D: 8B 44 06]
    MOV     CL, 0C                                           ; [2980: B1 0C]
    SHL     AX, CL                                           ; [2982: D3 E0]
    MOV     ES, AX                                           ; [2984: 8E C0]
    CMP     BYTE [var_lan_rx_status], 00                     ; [2986: 80 3E 2D 4B 00]
    JZ      loc_29a6                                         ; [298B: 74 19]
    MOV     AL, [var_lan_protocol_type]                      ; [298D: A0 35 4B]
    CMP     BYTE [ES:DI+03], AL                              ; [2990: 26 38 45 03]
    JNZ     loc_29a6                                         ; [2994: 75 10]
loc_2996:
    PUSH    BX                                               ; [2996: 53]
    MOV     BL, AL                                           ; [2997: 8A D8]
    XOR     BH, BH                                           ; [2999: 32 FF]
    SHL     BX, 1                                            ; [299B: D1 E3]
    CALL    WORD [CS:BX+diag_test_handler_vector_table]      ; [299D: 2E FF 97 35 29]
    POP     BX                                               ; [29A2: 5B]
    JMPN    loc_29af                                         ; [29A3: E9 09 00]
loc_29a6:
    CMP     BYTE [ES:DI+03], 03                              ; [29A6: 26 80 7D 03 03]
    MOV     AL, 03                                           ; [29AB: B0 03]
    JZ      loc_2996                                         ; [29AD: 74 E7]
loc_29af:
    POP     BX                                               ; [29AF: 5B]
    POP     CX                                               ; [29B0: 59]
    MOV     WORD [BX], 0000                                  ; [29B1: C7 07 00 00]
    MOV     BX, WORD [BX+04]                                 ; [29B5: 8B 5F 04]
    LOOP    loc_2967                                         ; [29B8: E2 AD]
    CMP     BYTE [var_lan_rx_status], FF                     ; [29BA: 80 3E 2D 4B FF]
    JZ      loc_2944                                         ; [29BF: 74 83]
    XOR     AL, AL                                           ; [29C1: 32 C0]
    RETN                                                     ; [29C3: C3]
sub_29c4:
    PUSH    ES                                               ; [29C4: 06]
    PUSHA                                                    ; [29C5: 60]
    MOV     AX, LAN_BUFFER_SEGMENT                           ; [29C6: B8 00 36]
    MOV     ES, AX                                           ; [29C9: 8E C0]
    MOV     DI, 4B4A                                         ; [29CB: BF 4A 4B]
    MOV     SI, BX                                           ; [29CE: 8B F3]
    ADD     SI, +0E                                          ; [29D0: 83 C6 0E]
    MOV     CX, 0006                                         ; [29D3: B9 06 00]
    REP MOVSB                                                ; [29D6: F3 A4]
    POPA                                                     ; [29D8: 61]
    POP     ES                                               ; [29D9: 07]
    RETN                                                     ; [29DA: C3]
sub_29db:
    PUSH    DI                                               ; [29DB: 57]
    PUSH    SI                                               ; [29DC: 56]
    MOV     SI, 4B4A                                         ; [29DD: BE 4A 4B]
    MOV     DI, BX                                           ; [29E0: 8B FB]
    ADD     DI, +0E                                          ; [29E2: 83 C7 0E]
    MOV     CX, 0006                                         ; [29E5: B9 06 00]
loc_29e8:
    MOV     AL, BYTE [DI]                                    ; [29E8: 8A 05]
    CMP     BYTE [SI], AL                                    ; [29EA: 38 04]
    JNZ     loc_29f7                                         ; [29EC: 75 09]
    INC     DI                                               ; [29EE: 47]
    INC     SI                                               ; [29EF: 46]
    LOOP    loc_29e8                                         ; [29F0: E2 F6]
    XOR     AL, AL                                           ; [29F2: 32 C0]
    POP     SI                                               ; [29F4: 5E]
    POP     DI                                               ; [29F5: 5F]
    RETN                                                     ; [29F6: C3]
loc_29f7:
    MOV     AL, 01                                           ; [29F7: B0 01]
    POP     SI                                               ; [29F9: 5E]
    POP     DI                                               ; [29FA: 5F]
    RETN                                                     ; [29FB: C3]
sub_29fc:
    RETN                                                     ; [29FC: C3]
sub_29fd:
    MOV     AL, [var_lan_buffer_offset]                      ; [29FD: A0 36 4B]
    CMP     BYTE [ES:DI+08], AL                              ; [2A00: 26 38 45 08]
    JNZ     loc_2a55                                         ; [2A04: 75 4F]
    MOV     AL, BYTE [ES:DI+11]                              ; [2A06: 26 8A 45 11]
    MOV     [var_lan_sub_command], AL                        ; [2A0A: A2 38 4B]
    MOV     AL, BYTE [ES:DI+12]                              ; [2A0D: 26 8A 45 12]
    MOV     [var_lan_timeout_counter], AL                    ; [2A11: A2 78 4B]
    PUSH    DI                                               ; [2A14: 57]
    MOV     SI, DI                                           ; [2A15: 8B F7]
    ADD     SI, +09                                          ; [2A17: 83 C6 09]
    MOV     CX, 0008                                         ; [2A1A: B9 08 00]
    MOV     DI, 4B39                                         ; [2A1D: BF 39 4B]
    PUSH    ES                                               ; [2A20: 06]
    MOV     AX, LAN_BUFFER_SEGMENT                           ; [2A21: B8 00 36]
    MOV     ES, AX                                           ; [2A24: 8E C0]
    POP     DS                                               ; [2A26: 1F]
    REP MOVSB                                                ; [2A27: F3 A4]
    PUSH    DS                                               ; [2A29: 1E]
    POP     ES                                               ; [2A2A: 07]
    MOV     AX, LAN_BUFFER_SEGMENT                           ; [2A2B: B8 00 36]
    MOV     DS, AX                                           ; [2A2E: 8E D8]
    POP     DI                                               ; [2A30: 5F]
    MOV     AL, BYTE [ES:DI+04]                              ; [2A31: 26 8A 45 04]
    MOV     [var_lan_ack_expected], AL                       ; [2A35: A2 42 4B]
    MOV     BP, SP                                           ; [2A38: 8B EC]
    MOV     BX, WORD [BP+02]                                 ; [2A3A: 8B 5E 02]
    CALL    sub_29c4                                         ; [2A3D: E8 84 FF]
    MOV     BYTE [var_lan_tx_packets], 00                    ; [2A40: C6 06 45 4B 00]
    MOV     BYTE [var_lan_sequence_num], 00                  ; [2A45: C6 06 44 4B 00]
    CALL    sub_2ff3                                         ; [2A4A: E8 A6 05]
    XOR     AL, AL                                           ; [2A4D: 32 C0]
    MOV     BYTE [var_lan_rx_status], 00                     ; [2A4F: C6 06 2D 4B 00]
    RETN                                                     ; [2A54: C3]
loc_2a55:
    MOV     AL, [var_lan_command_code]                       ; [2A55: A0 37 4B]
    CMP     BYTE [ES:DI+08], AL                              ; [2A58: 26 38 45 08]
    JZ      loc_2a61                                         ; [2A5C: 74 03]
    MOV     AL, 01                                           ; [2A5E: B0 01]
    RETN                                                     ; [2A60: C3]
loc_2a61:
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [2A61: B8 00 30]
    CALL    set_cursor_pos                                   ; [2A64: E8 12 D8]
    MOV     AX, 3436                                         ; [2A67: B8 36 34]
    MOV     CX, FFFF                                         ; [2A6A: B9 FF FF]
    CALL    print_string_es_ax                               ; [2A6D: E8 3C D9]
    MOV     AL, 02                                           ; [2A70: B0 02]
    RETN                                                     ; [2A72: C3]
sub_2a73:
    MOV     BP, SP                                           ; [2A73: 8B EC]
    MOV     BX, WORD [BP+02]                                 ; [2A75: 8B 5E 02]
    CALL    sub_29db                                         ; [2A78: E8 60 FF]
    OR      AL, AL                                           ; [2A7B: 0A C0]
    JNZ     loc_2a8d                                         ; [2A7D: 75 0E]
    MOV     AL, [var_lan_sequence_num]                       ; [2A7F: A0 44 4B]
    CMP     AL, BYTE [ES:DI+04]                              ; [2A82: 26 3A 45 04]
    JNZ     loc_2a8d                                         ; [2A86: 75 05]
    XOR     AL, AL                                           ; [2A88: 32 C0]
    JMPN    loc_2a90                                         ; [2A8A: E9 03 00]
loc_2a8d:
    MOV     AL, 01                                           ; [2A8D: B0 01]
    RETN                                                     ; [2A8F: C3]
loc_2a90:
    MOV     BYTE [var_lan_rx_status], 00                     ; [2A90: C6 06 2D 4B 00]
    RETN                                                     ; [2A95: C3]
sub_2a96:
    MOV     BP, SP                                           ; [2A96: 8B EC]
    MOV     BX, WORD [BP+02]                                 ; [2A98: 8B 5E 02]
    CALL    sub_29db                                         ; [2A9B: E8 3D FF]
    OR      AL, AL                                           ; [2A9E: 0A C0]
    JNZ     loc_2afc                                         ; [2AA0: 75 5A]
    CMP     BYTE [ES:DI+01], 08                              ; [2AA2: 26 80 7D 01 08]
    JNZ     loc_2af5                                         ; [2AA7: 75 4C]
    CMP     BYTE [ES:DI], 08                                 ; [2AA9: 26 80 3D 08]
    JNZ     loc_2af5                                         ; [2AAD: 75 46]
    CMP     BYTE [ES:DI+02], 03                              ; [2AAF: 26 80 7D 02 03]
    JNZ     loc_2af5                                         ; [2AB4: 75 3F]
    MOV     AL, BYTE [ES:DI+04]                              ; [2AB6: 26 8A 45 04]
    CMP     BYTE [var_lan_tx_packets], AL                    ; [2ABA: 38 06 45 4B]
    JNZ     loc_2af5                                         ; [2ABE: 75 35]
    MOV     AL, [var_lan_last_error]                         ; [2AC0: A0 94 4B]
    CMP     AL, BYTE [ES:DI+0B]                              ; [2AC3: 26 3A 45 0B]
    JNZ     loc_2ace                                         ; [2AC7: 75 05]
    MOV     BYTE [var_lan_connection_state], FF              ; [2AC9: C6 06 95 4B FF]
loc_2ace:
    INC     BYTE [var_lan_tx_packets]                        ; [2ACE: FE 06 45 4B]
    AND     BYTE [var_lan_tx_packets], 01                    ; [2AD2: 80 26 45 4B 01]
    CMP     BYTE [ES:DI+0B], 4D                              ; [2AD7: 26 80 7D 0B 4D]
    JZ      loc_2af5                                         ; [2ADC: 74 17]
    MOV     BYTE [var_lan_rx_status], 00                     ; [2ADE: C6 06 2D 4B 00]
    MOV     WORD [var_lan_subnet_mask], ES                   ; [2AE3: 8C 06 25 4B]
    MOV     WORD [var_lan_gateway_id], DI                    ; [2AE7: 89 3E 27 4B]
    PUSH    ES                                               ; [2AEB: 06]
    PUSH    DI                                               ; [2AEC: 57]
    CALL    sub_3029                                         ; [2AED: E8 39 05]
    POP     DI                                               ; [2AF0: 5F]
    POP     ES                                               ; [2AF1: 07]
    XOR     AL, AL                                           ; [2AF2: 32 C0]
    RETN                                                     ; [2AF4: C3]
loc_2af5:
    PUSH    ES                                               ; [2AF5: 06]
    PUSH    DI                                               ; [2AF6: 57]
    CALL    sub_3029                                         ; [2AF7: E8 2F 05]
    POP     DI                                               ; [2AFA: 5F]
    POP     ES                                               ; [2AFB: 07]
loc_2afc:
    MOV     AL, 01                                           ; [2AFC: B0 01]
    RETN                                                     ; [2AFE: C3]
sub_2aff:
    MOV     WORD [var_screen_scroll_count], 0000             ; [2AFF: C7 06 F0 00 00 00]
    MOV     WORD [var_screen_scroll_direction], 0000         ; [2B05: C7 06 F2 00 00 00]
    MOV     WORD [var_screen_fill_char], 0000                ; [2B0B: C7 06 F4 00 00 00]
    MOV     AX, 0100                                         ; [2B11: B8 00 01]
    MOV     [var_screen_fill_attr], AX                       ; [2B14: A3 F6 00]
    MOV     WORD [var_82730_row_table_ptr], 0000             ; [2B17: C7 06 FE 00 00 00]
    MOV     WORD [var_82730_row_attrib], 8000                ; [2B1D: C7 06 00 01 00 80]
    MOV     WORD [var_82730_ctrl_flags], 0000                ; [2B23: C7 06 02 01 00 00]
    MOV     DI, 4AEA                                         ; [2B29: BF EA 4A]
    MOV     WORD [DI], 0000                                  ; [2B2C: C7 05 00 00]
    MOV     WORD [DI+02], 0002                               ; [2B30: C7 45 02 02 00]
    MOV     WORD [DI+04], 4AF4                               ; [2B35: C7 45 04 F4 4A]
    MOV     WORD [DI+06], 0804                               ; [2B3A: C7 45 06 04 08]
    MOV     WORD [DI+08], 6600                               ; [2B3F: C7 45 08 00 66]
    MOV     WORD [DI+0A], 0000                               ; [2B44: C7 45 0A 00 00]
    MOV     AX, 0001                                         ; [2B49: B8 01 00]
    MOV     WORD [DI+0C], AX                                 ; [2B4C: 89 45 0C]
    MOV     AX, 4B00                                         ; [2B4F: B8 00 4B]
    MOV     WORD [DI+0E], AX                                 ; [2B52: 89 45 0E]
    MOV     WORD [DI+16], 0000                               ; [2B55: C7 45 16 00 00]
    MOV     AX, 0003                                         ; [2B5A: B8 03 00]
    MOV     WORD [DI+18], AX                                 ; [2B5D: 89 45 18]
    MOV     WORD [DI+1A], 4B0E                               ; [2B60: C7 45 1A 0E 4B]
    MOV     WORD [DI+1C], 0006                               ; [2B65: C7 45 1C 06 00]
    MOV     WORD [DI+1E], 0003                               ; [2B6A: C7 45 1E 03 00]
    MOV     WORD [DI+20], 0000                               ; [2B6F: C7 45 20 00 00]
    MOV     WORD [DI+22], 0000                               ; [2B74: C7 45 22 00 00]
    MOV     WORD [DI+24], 0000                               ; [2B79: C7 45 24 00 00]
    MOV     WORD [DI+26], 8002                               ; [2B7E: C7 45 26 02 80]
    MOV     WORD [DI+28], 4AF4                               ; [2B83: C7 45 28 F4 4A]
    MOV     WORD [DI+2A], 0804                               ; [2B88: C7 45 2A 04 08]
    MOV     WORD [DI+2C], 2600                               ; [2B8D: C7 45 2C 00 26]
    MOV     WORD [var_screen_cursor_col], 0000               ; [2B92: C7 06 E0 00 00 00]
    MOV     WORD [var_screen_cursor_row], 0000               ; [2B98: C7 06 E2 00 00 00]
    MOV     WORD [var_screen_buffer_base], 4AEA              ; [2B9E: C7 06 E4 00 EA 4A]
    MOV     WORD [var_screen_attribute], 056A                ; [2BA4: C7 06 E6 00 6A 05]
    MOV     WORD [var_screen_window_top], 0000               ; [2BAA: C7 06 E8 00 00 00]
    MOV     WORD [var_screen_window_bottom], 0000            ; [2BB0: C7 06 EA 00 00 00]
    MOV     WORD [var_screen_window_left], 0000              ; [2BB6: C7 06 EC 00 00 00]
    MOV     WORD [var_screen_window_right], 0000             ; [2BBC: C7 06 EE 00 00 00]
sub_2bc2:
    MOV     CX, 0010                                         ; [2BC2: B9 10 00]
    MOV     BX, 0000                                         ; [2BC5: BB 00 00]
    MOV     DI, 056A                                         ; [2BC8: BF 6A 05]
    MOV     SI, 06CA                                         ; [2BCB: BE CA 06]
loc_2bce:
    MOV     WORD [DI], 0000                                  ; [2BCE: C7 05 00 00]
    MOV     WORD [DI+02], 0000                               ; [2BD2: C7 45 02 00 00]
    MOV     AX, DI                                           ; [2BD7: 8B C7]
    ADD     AX, 0016                                         ; [2BD9: 05 16 00]
    MOV     WORD [DI+04], AX                                 ; [2BDC: 89 45 04]
    MOV     WORD [DI+06], FFFF                               ; [2BDF: C7 45 06 FF FF]
    MOV     WORD [DI+14], 0000                               ; [2BE4: C7 45 14 00 00]
    ADD     DI, +16                                          ; [2BE9: 83 C7 16]
    LOOP    loc_2bce                                         ; [2BEC: E2 E0]
    SUB     DI, +16                                          ; [2BEE: 83 EF 16]
    MOV     WORD [DI+04], 0000                               ; [2BF1: C7 45 04 00 00]
    MOV     WORD [DI+02], C000                               ; [2BF6: C7 45 02 00 C0]
    MOV     DI, 056A                                         ; [2BFB: BF 6A 05]
    MOV     WORD [DI+06], 06CA                               ; [2BFE: C7 45 06 CA 06]
    MOV     CX, 0010                                         ; [2C03: B9 10 00]
    MOV     DI, 06CA                                         ; [2C06: BF CA 06]
loc_2c09:
    MOV     WORD [DI], 0000                                  ; [2C09: C7 05 00 00]
    MOV     AX, DI                                           ; [2C0D: 8B C7]
    ADD     AX, 000A                                         ; [2C0F: 05 0A 00]
    MOV     WORD [DI+02], AX                                 ; [2C12: 89 45 02]
    MOV     AX, 0438                                         ; [2C15: B8 38 04]
    MOV     WORD [DI+08], AX                                 ; [2C18: 89 45 08]
    ADD     DI, +0A                                          ; [2C1B: 83 C7 0A]
    LOOP    loc_2c09                                         ; [2C1E: E2 E9]
    SUB     DI, +0A                                          ; [2C20: 83 EF 0A]
    MOV     WORD [DI+02], 0000                               ; [2C23: C7 45 02 00 00]
    ADD     AX, 8000                                         ; [2C28: 05 00 80]
    MOV     WORD [DI+08], AX                                 ; [2C2B: 89 45 08]
    RETN                                                     ; [2C2E: C3]
sub_2c2f:
    CMP     BYTE [var_lan_server_id], 00                     ; [2C2F: 80 3E 20 4B 00]
    JZ      loc_2c82                                         ; [2C34: 74 4C]
    CMP     WORD [var_lan_station_id], +00                   ; [2C36: 83 3E 1E 4B 00]
    JNZ     loc_2c82                                         ; [2C3B: 75 45]
    PUSHF                                                    ; [2C3D: 9C]
    CLI                                                      ; [2C3E: FA]
    MOV     WORD [var_screen_cursor_col], 0000               ; [2C3F: C7 06 E0 00 00 00]
    MOV     WORD [var_screen_cursor_row], 0000               ; [2C45: C7 06 E2 00 00 00]
    CALL    sub_2bc2                                         ; [2C4B: E8 74 FF]
    MOV     BX, 076A                                         ; [2C4E: BB 6A 07]
    MOV     CX, 0010                                         ; [2C51: B9 10 00]
    MOV     DI, 06CA                                         ; [2C54: BF CA 06]
loc_2c57:
    PUSH    CX                                               ; [2C57: 51]
    CALL    sub_2de8                                         ; [2C58: E8 8D 01]
    POP     CX                                               ; [2C5B: 59]
    ADD     DI, +0A                                          ; [2C5C: 83 C7 0A]
    ADD     BX, 0438                                         ; [2C5F: 81 C3 38 04]
    LOOP    loc_2c57                                         ; [2C63: E2 F2]
    MOV     SI, WORD [var_lan_client_ip_lo]                  ; [2C65: 8B 36 21 4B]
    MOV     WORD [var_screen_attribute], SI                  ; [2C69: 89 36 E6 00]
    MOV     WORD [var_lan_station_id], SI                    ; [2C6D: 89 36 1E 4B]
    MOV     BYTE [var_lan_activity_flag], 00                 ; [2C71: C6 06 92 4B 00]
    MOV     BYTE [var_lan_server_id], 00                     ; [2C76: C6 06 20 4B 00]
    POPF                                                     ; [2C7B: 9D]
    MOV     AX, 0010                                         ; [2C7C: B8 10 00]
    CALL    sub_28f3                                         ; [2C7F: E8 71 FC]
loc_2c82:
    CALL    sub_2efd                                         ; [2C82: E8 78 02]
    RETN                                                     ; [2C85: C3]
sub_2c86:
    PUSHF                                                    ; [2C86: 9C]
    CLI                                                      ; [2C87: FA]
    XOR     CX, CX                                           ; [2C88: 33 C9]
    MOV     BX, WORD [var_lan_station_id]                    ; [2C8A: 8B 1E 1E 4B]
    MOV     SI, BX                                           ; [2C8E: 8B F3]
loc_2c90:
    TEST    WORD [SI], 8000                                  ; [2C90: F7 04 00 80]
    JZ      loc_2cae                                         ; [2C94: 74 18]
    CMP     BYTE [var_lan_activity_flag], 00                 ; [2C96: 80 3E 92 4B 00]
    JLE     loc_2cae                                         ; [2C9B: 7E 11]
    DEC     BYTE [var_lan_activity_flag]                     ; [2C9D: FE 0E 92 4B]
    INC     CX                                               ; [2CA1: 41]
    TEST    WORD [SI+02], 8000                               ; [2CA2: F7 44 02 00 80]
    MOV     SI, WORD [SI+04]                                 ; [2CA7: 8B 74 04]
    JNZ     loc_2cae                                         ; [2CAA: 75 02]
    JMPS    loc_2c90                                         ; [2CAC: EB E2]
loc_2cae:
    MOV     WORD [var_lan_station_id], SI                    ; [2CAE: 89 36 1E 4B]
    POPF                                                     ; [2CB2: 9D]
    RETN                                                     ; [2CB3: C3]
sub_2cb4:
    MOV     BX, 0108                                         ; [2CB4: BB 08 01]
    MOV     DI, 0100                                         ; [2CB7: BF 00 01]
    CALL    sub_2de8                                         ; [2CBA: E8 2B 01]
    MOV     BX, 076A                                         ; [2CBD: BB 6A 07]
    MOV     CX, 0010                                         ; [2CC0: B9 10 00]
    MOV     DI, 06CA                                         ; [2CC3: BF CA 06]
loc_2cc6:
    PUSH    CX                                               ; [2CC6: 51]
    CALL    sub_2de8                                         ; [2CC7: E8 1E 01]
    POP     CX                                               ; [2CCA: 59]
    ADD     DI, +0A                                          ; [2CCB: 83 C7 0A]
    ADD     BX, 0438                                         ; [2CCE: 81 C3 38 04]
    LOOP    loc_2cc6                                         ; [2CD2: E2 F2]
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [2CD4: B8 00 30]
    MOV     ES, AX                                           ; [2CD7: 8E C0]
    MOV     DI, FFF6                                         ; [2CD9: BF F6 FF]
    MOV     WORD [ES:DI], 0000                               ; [2CDC: 26 C7 05 00 00]
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [2CE1: B8 00 30]
    MOV     BX, FFE0                                         ; [2CE4: BB E0 FF]
    MOV     CL, 04                                           ; [2CE7: B1 04]
    ROL     AX, CL                                           ; [2CE9: D3 C0]
    MOV     CH, AL                                           ; [2CEB: 8A E8]
    AND     AL, F0                                           ; [2CED: 24 F0]
    ADD     AX, BX                                           ; [2CEF: 03 C3]
    ADC     CH, 00                                           ; [2CF1: 80 D5 00]
    AND     CH, 0F                                           ; [2CF4: 80 E5 0F]
    XCHG    CL, CH                                           ; [2CF7: 86 E9]
    XOR     CH, CH                                           ; [2CF9: 32 ED]
    MOV     WORD [ES:DI+06], AX                              ; [2CFB: 26 89 45 06]
    MOV     WORD [ES:DI+08], CX                              ; [2CFF: 26 89 4D 08]
    PUSH    DS                                               ; [2D03: 1E]
    MOV     AX, F000                                         ; [2D04: B8 00 F0]
    MOV     DS, AX                                           ; [2D07: 8E D8]
    MOV     AX, LAN_BUFFER_SEGMENT                           ; [2D09: B8 00 36]
    MOV     ES, AX                                           ; [2D0C: 8E C0]
    MOV     DI, 4B18                                         ; [2D0E: BF 18 4B]
    MOV     SI, 6000                                         ; [2D11: BE 00 60]
    MOV     CX, 0004                                         ; [2D14: B9 04 00]
    MOV     AX, DS                                           ; [2D17: 8C D8]
    POP     DS                                               ; [2D19: 1F]
    MOV     ES, AX                                           ; [2D1A: 8E C0]
    MOV     DI, 6000                                         ; [2D1C: BF 00 60]
    MOV     WORD [ES:DI], 0001                               ; [2D1F: 26 C7 05 01 00]
    MOV     AX, 00E0                                         ; [2D24: B8 E0 00]
    MOV     WORD [ES:DI+02], AX                              ; [2D27: 26 89 45 02]
    MOV     AX, DS                                           ; [2D2B: 8C D8]
    MOV     CL, 04                                           ; [2D2D: B1 04]
    SHL     AX, CL                                           ; [2D2F: D3 E0]
    MOV     WORD [ES:DI+04], AX                              ; [2D31: 26 89 45 04]
    MOV     AX, DS                                           ; [2D35: 8C D8]
    MOV     CL, 0C                                           ; [2D37: B1 0C]
    SHR     AX, CL                                           ; [2D39: D3 E8]
    MOV     WORD [ES:DI+06], AX                              ; [2D3B: 26 89 45 06]
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [2D3F: B8 00 30]
    MOV     ES, AX                                           ; [2D42: 8E C0]
    MOV     DI, FFE0                                         ; [2D44: BF E0 FF]
    MOV     WORD [ES:DI], 0001                               ; [2D47: 26 C7 05 01 00]
    MOV     AX, 00E0                                         ; [2D4C: B8 E0 00]
    MOV     WORD [ES:DI+02], AX                              ; [2D4F: 26 89 45 02]
    MOV     AX, DS                                           ; [2D53: 8C D8]
    MOV     CL, 04                                           ; [2D55: B1 04]
    SHL     AX, CL                                           ; [2D57: D3 E0]
    MOV     WORD [ES:DI+04], AX                              ; [2D59: 26 89 45 04]
    MOV     AX, DS                                           ; [2D5D: 8C D8]
    MOV     CL, 0C                                           ; [2D5F: B1 0C]
    SHR     AX, CL                                           ; [2D61: D3 E8]
    MOV     WORD [ES:DI+06], AX                              ; [2D63: 26 89 45 06]
    CLI                                                      ; [2D67: FA]
    XOR     AX, AX                                           ; [2D68: 33 C0]
    MOV     ES, AX                                           ; [2D6A: 8E C0]
    MOV     AX, 2E30                                         ; [2D6C: B8 30 2E]
    MOV     DI, 0094                                         ; [2D6F: BF 94 00]
    STOSW                                                    ; [2D72: AB]
    MOV     AX, CS                                           ; [2D73: 8C C8]
    STOSW                                                    ; [2D75: AB]
    MOV     DX, io_pic_icw2_ocw          ; 8259A PIC ICW2/OCW (Base vector 20h) ; [2D76: BA 02 00]
    MOV     AL, CF                                           ; [2D79: B0 CF]
    OUT     DX, AL                                           ; [2D7B: EE]
    STI                                                      ; [2D7C: FB]
    MOV     AX, DS                                           ; [2D7D: 8C D8]
    MOV     ES, AX                                           ; [2D7F: 8E C0]
    MOV     DX, 0100                                         ; [2D81: BA 00 01]
    IN      AL, DX                                           ; [2D84: EC]
    CALL    sub_2eda                                         ; [2D85: E8 52 01]
    MOV     WORD [var_screen_cursor_col], 0000               ; [2D88: C7 06 E0 00 00 00]
    MOV     AX, DS                                           ; [2D8E: 8C D8]
    MOV     ES, AX                                           ; [2D90: 8E C0]
    MOV     DI, 4AFA                                         ; [2D92: BF FA 4A]
    CALL    sub_2e05                                         ; [2D95: E8 6D 00]
    MOV     AX, 0100                                         ; [2D98: B8 00 01]
    CALL    sub_28f3                                         ; [2D9B: E8 55 FB]
    CALL    sub_2eda                                         ; [2D9E: E8 39 01]
    MOV     SI, 4AEA                                         ; [2DA1: BE EA 4A]
    CMP     WORD [SI], A000                                  ; [2DA4: 81 3C 00 A0]
    JZ      loc_2dad                                         ; [2DA8: 74 03]
    JMPN    loc_2dd6                                         ; [2DAA: E9 29 00]
loc_2dad:
    MOV     SI, 4B00                                         ; [2DAD: BE 00 4B]
    CMP     WORD [SI], A000                                  ; [2DB0: 81 3C 00 A0]
    JZ      loc_2db9                                         ; [2DB4: 74 03]
    JMPN    loc_2dd6                                         ; [2DB6: E9 1D 00]
loc_2db9:
    CLI                                                      ; [2DB9: FA]
    XOR     AX, AX                                           ; [2DBA: 33 C0]
    MOV     ES, AX                                           ; [2DBC: 8E C0]
    MOV     AX, 2E68                                         ; [2DBE: B8 68 2E]
    MOV     DI, 0094                                         ; [2DC1: BF 94 00]
    STOSW                                                    ; [2DC4: AB]
    MOV     AX, CS                                           ; [2DC5: 8C C8]
    STOSW                                                    ; [2DC7: AB]
    MOV     AX, DS                                           ; [2DC8: 8C D8]
    MOV     ES, AX                                           ; [2DCA: 8E C0]
    STI                                                      ; [2DCC: FB]
    MOV     WORD [var_screen_buffer_base], 00F0              ; [2DCD: C7 06 E4 00 F0 00]
    XOR     AL, AL                                           ; [2DD3: 32 C0]
    RETN                                                     ; [2DD5: C3]
loc_2dd6:
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [2DD6: B8 00 30]
    CALL    set_cursor_pos                                   ; [2DD9: E8 9D D4]
    MOV     AX, 34D4                                         ; [2DDC: B8 D4 34]
    MOV     CX, FFFF                                         ; [2DDF: B9 FF FF]
    CALL    print_string_es_ax                               ; [2DE2: E8 C7 D5]
    MOV     AL, 01                                           ; [2DE5: B0 01]
    RETN                                                     ; [2DE7: C3]
sub_2de8:
    MOV     AX, DS                                           ; [2DE8: 8C D8]
    MOV     CL, 04                                           ; [2DEA: B1 04]
    ROL     AX, CL                                           ; [2DEC: D3 C0]
    MOV     CH, AL                                           ; [2DEE: 8A E8]
    AND     AL, F0                                           ; [2DF0: 24 F0]
    ADD     AX, BX                                           ; [2DF2: 03 C3]
    ADC     CH, 00                                           ; [2DF4: 80 D5 00]
    AND     CH, 0F                                           ; [2DF7: 80 E5 0F]
    XCHG    CL, CH                                           ; [2DFA: 86 E9]
    XOR     CH, CH                                           ; [2DFC: 32 ED]
    MOV     WORD [DI+04], AX                                 ; [2DFE: 89 45 04]
    MOV     WORD [DI+06], CX                                 ; [2E01: 89 4D 06]
    RETN                                                     ; [2E04: C3]
sub_2e05:
    MOV     SI, 4B2E                                         ; [2E05: BE 2E 4B]
    MOV     AX, WORD [SI+04]                                 ; [2E08: 8B 44 04]
    MOV     DX, WORD [SI]                                    ; [2E0B: 8B 14]
    SHL     DX, 1                                            ; [2E0D: D1 E2]
    CLC                                                      ; [2E0F: F8]
    RCL     AX, 1                                            ; [2E10: D1 D0]
    JNC     loc_2e15                                         ; [2E12: 73 01]
    INC     DX                                               ; [2E14: 42]
loc_2e15:
    MOV     SI, 4B97                                         ; [2E15: BE 97 4B]
    ADD     AX, WORD [SI]                                    ; [2E18: 03 04]
    MOV     WORD [DI], AX                                    ; [2E1A: 89 05]
    ADC     DX, WORD [SI+02]                                 ; [2E1C: 13 54 02]
    MOV     WORD [DI+02], DX                                 ; [2E1F: 89 55 02]
    MOV     AX, 0000                                         ; [2E22: B8 00 00]
    ADC     AX, WORD [SI+04]                                 ; [2E25: 13 44 04]
    MOV     WORD [DI+04], AX                                 ; [2E28: 89 45 04]
    MOV     AX, DS                                           ; [2E2B: 8C D8]
    MOV     ES, AX                                           ; [2E2D: 8E C0]
    RETN                                                     ; [2E2F: C3]
    CLI                                                      ; [2E30: FA]
    PUSHA                                                    ; [2E31: 60]
    PUSH    DS                                               ; [2E32: 1E]
    MOV     AX, LAN_BUFFER_SEGMENT                           ; [2E33: B8 00 36]
    MOV     DS, AX                                           ; [2E36: 8E D8]
    CMP     BYTE [var_lan_frame_error_count], 02             ; [2E38: 80 3E 91 4B 02]
    JZ      loc_2e48                                         ; [2E3D: 74 09]
    MOV     AX, 0770                                         ; [2E3F: B8 70 07]
loc_2e42:
    AND     AX, WORD [var_screen_cursor_row]                 ; [2E42: 23 06 E2 00]
    JNZ     loc_2e42                                         ; [2E46: 75 FA]
loc_2e48:
    MOV     AX, [var_screen_cursor_col]                      ; [2E48: A1 E0 00]
    AND     AX, F000                                         ; [2E4B: 25 00 F0]
    MOV     [var_screen_cursor_row], AX                      ; [2E4E: A3 E2 00]
    MOV     BYTE [var_lan_frame_error_count], 01             ; [2E51: C6 06 91 4B 01]
    MOV     DX, 0100                                         ; [2E56: BA 00 01]
    IN      AL, DX                                           ; [2E59: EC]
    MOV     AL, 20                                           ; [2E5A: B0 20]
    OUT     io_pic_icw1, AL              ; 8259A PIC ICW1 (Base port 00h) ; [2E5C: E6 00]
    MOV     DX, io_i186_eoi              ; 80186 INTC End-Of-Interrupt (EOI) register ; [2E5E: BA 22 FF]
    MOV     AX, 8000                                         ; [2E61: B8 00 80]
    OUT     DX, AX                                           ; [2E64: EF]
    POP     DS                                               ; [2E65: 1F]
    POPA                                                     ; [2E66: 61]
    IRET                                                     ; [2E67: CF]
    CLI                                                      ; [2E68: FA]
    PUSHA                                                    ; [2E69: 60]
    PUSH    DS                                               ; [2E6A: 1E]
    MOV     AX, LAN_BUFFER_SEGMENT                           ; [2E6B: B8 00 36]
    MOV     DS, AX                                           ; [2E6E: 8E D8]
loc_2e70:
    CMP     WORD [var_screen_cursor_row], +00                ; [2E70: 83 3E E2 00 00]
    JNZ     loc_2e70                                         ; [2E75: 75 F9]
    MOV     AX, [var_screen_cursor_col]                      ; [2E77: A1 E0 00]
    MOV     [var_lan_scb_status], AX                         ; [2E7A: A3 75 4B]
    AND     AX, F000                                         ; [2E7D: 25 00 F0]
    MOV     [var_screen_cursor_row], AX                      ; [2E80: A3 E2 00]
    TEST    WORD [var_lan_scb_status], A000                  ; [2E83: F7 06 75 4B 00 A0]
    JZ      loc_2e90                                         ; [2E89: 74 05]
    MOV     BYTE [var_lan_frame_error_count], 01             ; [2E8B: C6 06 91 4B 01]
loc_2e90:
    TEST    WORD [var_lan_scb_status], 5000                  ; [2E90: F7 06 75 4B 00 50]
    JNZ     loc_2ea1                                         ; [2E96: 75 09]
    OR      WORD [var_screen_cursor_row], 0000               ; [2E98: 81 0E E2 00 00 00]
    JMPN    loc_2ec8                                         ; [2E9E: E9 27 00]
loc_2ea1:
    INC     BYTE [var_lan_activity_flag]                     ; [2EA1: FE 06 92 4B]
    MOV     BYTE [var_lan_collision_count], FF               ; [2EA5: C6 06 49 4B FF]
    TEST    WORD [var_lan_scb_status], 1000                  ; [2EAA: F7 06 75 4B 00 10]
    JNZ     loc_2ebb                                         ; [2EB0: 75 09]
    OR      WORD [var_screen_cursor_row], 0000               ; [2EB2: 81 0E E2 00 00 00]
    JMPN    loc_2ec8                                         ; [2EB8: E9 0D 00]
loc_2ebb:
    OR      WORD [var_screen_cursor_row], 0000               ; [2EBB: 81 0E E2 00 00 00]
    MOV     BYTE [var_lan_server_id], FF                     ; [2EC1: C6 06 20 4B FF]
    JMPS    loc_2ec8                                         ; [2EC6: EB 00]
loc_2ec8:
    MOV     DX, 0100                                         ; [2EC8: BA 00 01]
    IN      AL, DX                                           ; [2ECB: EC]
    MOV     AL, 20                                           ; [2ECC: B0 20]
    OUT     io_pic_icw1, AL              ; 8259A PIC ICW1 (Base port 00h) ; [2ECE: E6 00]
    MOV     DX, io_i186_eoi              ; 80186 INTC End-Of-Interrupt (EOI) register ; [2ED0: BA 22 FF]
    MOV     AX, 8000                                         ; [2ED3: B8 00 80]
    OUT     DX, AX                                           ; [2ED6: EF]
    POP     DS                                               ; [2ED7: 1F]
    POPA                                                     ; [2ED8: 61]
    IRET                                                     ; [2ED9: CF]
sub_2eda:
    MOV     WORD [var_lan_retry_limit], 0FFF                 ; [2EDA: C7 06 29 4B FF 0F]
loc_2ee0:
    CLI                                                      ; [2EE0: FA]
    CMP     BYTE [var_lan_frame_error_count], 01             ; [2EE1: 80 3E 91 4B 01]
    JZ      loc_2ef1                                         ; [2EE6: 74 09]
    STI                                                      ; [2EE8: FB]
    DEC     WORD [var_lan_retry_limit]                       ; [2EE9: FF 0E 29 4B]
    JZ      loc_2efa                                         ; [2EED: 74 0B]
    JMPS    loc_2ee0                                         ; [2EEF: EB EF]
loc_2ef1:
    XOR     AL, AL                                           ; [2EF1: 32 C0]
    MOV     BYTE [var_lan_frame_error_count], 00             ; [2EF3: C6 06 91 4B 00]
    STI                                                      ; [2EF8: FB]
    RETN                                                     ; [2EF9: C3]
loc_2efa:
    MOV     AL, 01                                           ; [2EFA: B0 01]
    RETN                                                     ; [2EFC: C3]
sub_2efd:
    MOV     WORD [var_lan_retry_limit], 0FFF                 ; [2EFD: C7 06 29 4B FF 0F]
loc_2f03:
    CLI                                                      ; [2F03: FA]
    CMP     BYTE [var_lan_activity_flag], 01                 ; [2F04: 80 3E 92 4B 01]
    JGE     loc_2f14                                         ; [2F09: 7D 09]
    STI                                                      ; [2F0B: FB]
    DEC     WORD [var_lan_retry_limit]                       ; [2F0C: FF 0E 29 4B]
    JZ      loc_2f18                                         ; [2F10: 74 06]
    JMPS    loc_2f03                                         ; [2F12: EB EF]
loc_2f14:
    XOR     AL, AL                                           ; [2F14: 32 C0]
    STI                                                      ; [2F16: FB]
    RETN                                                     ; [2F17: C3]
loc_2f18:
    MOV     AL, 01                                           ; [2F18: B0 01]
    RETN                                                     ; [2F1A: C3]
sub_2f1b:
    XOR     AH, AH                                           ; [2F1B: 32 E4]
    MOV     AL, 1D                                           ; [2F1D: B0 1D]
    CALL    nvram_read_byte_al                               ; [2F1F: E8 98 0C]
    MOV     [var_lan_command_code], AL                       ; [2F22: A2 37 4B]
    MOV     AL, 1E                                           ; [2F25: B0 1E]
    XOR     AH, AH                                           ; [2F27: 32 E4]
    CALL    nvram_read_byte_al                               ; [2F29: E8 8E 0C]
    MOV     [var_lan_buffer_offset], AL                      ; [2F2C: A2 36 4B]
    MOV     CX, 0006                                         ; [2F2F: B9 06 00]
    XOR     AH, AH                                           ; [2F32: 32 E4]
    MOV     AL, 01                                           ; [2F34: B0 01]
    MOV     SI, 4B2E                                         ; [2F36: BE 2E 4B]
loc_2f39:
    PUSH    CX                                               ; [2F39: 51]
    PUSH    AX                                               ; [2F3A: 50]
    PUSH    SI                                               ; [2F3B: 56]
    CALL    nvram_read_byte_al                               ; [2F3C: E8 7B 0C]
    POP     SI                                               ; [2F3F: 5E]
    MOV     BYTE [SI], AL                                    ; [2F40: 88 04]
    POP     AX                                               ; [2F42: 58]
    POP     CX                                               ; [2F43: 59]
    INC     AL                                               ; [2F44: FE C0]
    INC     SI                                               ; [2F46: 46]
    LOOP    loc_2f39                                         ; [2F47: E2 F0]
    MOV     AL, 1F                                           ; [2F49: B0 1F]
    CALL    nvram_read_byte_al                               ; [2F4B: E8 6C 0C]
    MOV     [var_lan_window_size], AL                        ; [2F4E: A2 41 4B]
    PUSH    DS                                               ; [2F51: 1E]
    PUSH    ES                                               ; [2F52: 06]
    MOV     AX, LAN_BUFFER_SEGMENT                           ; [2F53: B8 00 36]
    MOV     ES, AX                                           ; [2F56: 8E C0]
    MOV     SI, 3347                                         ; [2F58: BE 47 33]
    MOV     DI, 4B51                                         ; [2F5B: BF 51 4B]
    MOV     AX, [CS:rom_segment_base]                        ; [2F5E: 2E A1 00 00]
    MOV     DS, AX                                           ; [2F62: 8E D8]
    MOV     CX, 0024                                         ; [2F64: B9 24 00]
    REP MOVSB                                                ; [2F67: F3 A4]
    POP     ES                                               ; [2F69: 07]
    POP     DS                                               ; [2F6A: 1F]
    MOV     AH, 01                                           ; [2F6B: B4 01]
    MOV     AL, 0B                                           ; [2F6D: B0 0B]
    CALL    nvram_read_byte_al                               ; [2F6F: E8 48 0C]
    OR      AL, AL                                           ; [2F72: 0A C0]
    JZ      loc_2f90                                         ; [2F74: 74 1A]
    MOV     CX, 0008                                         ; [2F76: B9 08 00]
    MOV     AH, 01                                           ; [2F79: B4 01]
    MOV     AL, 0B                                           ; [2F7B: B0 0B]
    MOV     DI, 4B52                                         ; [2F7D: BF 52 4B]
loc_2f80:
    PUSH    AX                                               ; [2F80: 50]
    PUSH    CX                                               ; [2F81: 51]
    PUSH    DI                                               ; [2F82: 57]
    CALL    nvram_read_byte_al                               ; [2F83: E8 34 0C]
    POP     DI                                               ; [2F86: 5F]
    POP     CX                                               ; [2F87: 59]
    MOV     BYTE [DI], AL                                    ; [2F88: 88 05]
    POP     AX                                               ; [2F8A: 58]
    INC     DI                                               ; [2F8B: 47]
    INC     AL                                               ; [2F8C: FE C0]
    LOOP    loc_2f80                                         ; [2F8E: E2 F0]
loc_2f90:
    RETN                                                     ; [2F90: C3]
sub_2f91:
    MOV     SI, 053C                                         ; [2F91: BE 3C 05]
    MOV     AL, [var_lan_rx_packets]                         ; [2F94: A0 46 4B]
    CMP     AL, FE                                           ; [2F97: 3C FE]
    JZ      loc_2f9f                                         ; [2F99: 74 04]
    INC     BYTE [var_lan_rx_packets]                        ; [2F9B: FE 06 46 4B]
loc_2f9f:
    MOV     SI, 053C                                         ; [2F9F: BE 3C 05]
    MOV     BYTE [SI], 08                                    ; [2FA2: C6 04 08]
    MOV     BYTE [SI+01], 08                                 ; [2FA5: C6 44 01 08]
    MOV     BYTE [SI+02], 03                                 ; [2FA9: C6 44 02 03]
    MOV     AH, 00                                           ; [2FAD: B4 00]
    MOV     BYTE [SI+03], AH                                 ; [2FAF: 88 64 03]
    MOV     BYTE [SI+04], 00                                 ; [2FB2: C6 44 04 00]
    MOV     BYTE [SI+05], AL                                 ; [2FB6: 88 44 05]
    MOV     WORD [SI+06], FFFF                               ; [2FB9: C7 44 06 FF FF]
    MOV     AL, [var_lan_command_code]                       ; [2FBE: A0 37 4B]
    MOV     BYTE [SI+08], AL                                 ; [2FC1: 88 44 08]
    MOV     BX, 053C                                         ; [2FC4: BB 3C 05]
    MOV     DI, 0100                                         ; [2FC7: BF 00 01]
    CALL    sub_2de8                                         ; [2FCA: E8 1B FE]
    CMP     BYTE [var_lan_local_port], FF                    ; [2FCD: 80 3E 9D 4B FF]
    JZ      loc_2fd9                                         ; [2FD2: 74 05]
    MOV     SI, 4B83                                         ; [2FD4: BE 83 4B]
    JMPS    loc_2fdc                                         ; [2FD7: EB 03]
loc_2fd9:
    MOV     SI, 4B4A                                         ; [2FD9: BE 4A 4B]
loc_2fdc:
    PUSH    DS                                               ; [2FDC: 1E]
    POP     ES                                               ; [2FDD: 07]
    MOV     DI, 00F8                                         ; [2FDE: BF F8 00]
    MOV     CX, 0003                                         ; [2FE1: B9 03 00]
    REP MOVSW                                                ; [2FE4: F3 A5]
    MOV     WORD [var_82730_row_attrib], 802E                ; [2FE6: C7 06 00 01 2E 80]
    MOV     CX, 002E                                         ; [2FEC: B9 2E 00]
    CALL    sub_2902                                         ; [2FEF: E8 10 F9]
    RETN                                                     ; [2FF2: C3]
sub_2ff3:
    MOV     SI, 0108                                         ; [2FF3: BE 08 01]
    MOV     BYTE [SI], 08                                    ; [2FF6: C6 04 08]
    MOV     BYTE [SI+01], 08                                 ; [2FF9: C6 44 01 08]
    MOV     BYTE [SI+02], 03                                 ; [2FFD: C6 44 02 03]
    MOV     AL, 02                                           ; [3001: B0 02]
    MOV     BYTE [SI+03], AL                                 ; [3003: 88 44 03]
    MOV     AL, [var_lan_last_ack]                           ; [3006: A0 43 4B]
    MOV     BYTE [SI+04], AL                                 ; [3009: 88 44 04]
    MOV     AL, BYTE [ES:DI+04]                              ; [300C: 26 8A 45 04]
    MOV     BYTE [SI+05], AL                                 ; [3010: 88 44 05]
    MOV     BX, 0108                                         ; [3013: BB 08 01]
    MOV     DI, 0100                                         ; [3016: BF 00 01]
    CALL    sub_2de8                                         ; [3019: E8 CC FD]
    MOV     SI, 4B4A                                         ; [301C: BE 4A 4B]
    CALL    sub_28e3                                         ; [301F: E8 C1 F8]
    MOV     CX, 0006                                         ; [3022: B9 06 00]
    CALL    sub_2902                                         ; [3025: E8 DA F8]
    RETN                                                     ; [3028: C3]
sub_3029:
    MOV     SI, 0108                                         ; [3029: BE 08 01]
    MOV     BYTE [SI], 08                                    ; [302C: C6 04 08]
    MOV     BYTE [SI+01], 08                                 ; [302F: C6 44 01 08]
    MOV     BYTE [SI+02], 03                                 ; [3033: C6 44 02 03]
    MOV     AL, 04                                           ; [3037: B0 04]
    MOV     BYTE [SI+03], AL                                 ; [3039: 88 44 03]
    MOV     AL, BYTE [ES:DI+04]                              ; [303C: 26 8A 45 04]
    MOV     BYTE [SI+04], AL                                 ; [3040: 88 44 04]
    MOV     AL, [var_lan_ack_expected]                       ; [3043: A0 42 4B]
    MOV     BYTE [SI+05], AL                                 ; [3046: 88 44 05]
    MOV     BX, 0108                                         ; [3049: BB 08 01]
    MOV     DI, 0100                                         ; [304C: BF 00 01]
    CALL    sub_2de8                                         ; [304F: E8 96 FD]
    PUSH    ES                                               ; [3052: 06]
    MOV     SI, 4B4A                                         ; [3053: BE 4A 4B]
    CALL    sub_28e3                                         ; [3056: E8 8A F8]
    POP     ES                                               ; [3059: 07]
    MOV     CX, 0006                                         ; [305A: B9 06 00]
    CALL    sub_2902                                         ; [305D: E8 A2 F8]
    RETN                                                     ; [3060: C3]
sub_3061:
    PUSH    CX                                               ; [3061: 51]
    MOV     BX, 0108                                         ; [3062: BB 08 01]
    MOV     BYTE [BX], 08                                    ; [3065: C6 07 08]
    MOV     BYTE [BX+01], 08                                 ; [3068: C6 47 01 08]
    MOV     BYTE [BX+02], 03                                 ; [306C: C6 47 02 03]
    MOV     BYTE [BX+03], 03                                 ; [3070: C6 47 03 03]
    MOV     AL, [var_lan_sequence_num]                       ; [3074: A0 44 4B]
    MOV     BYTE [BX+04], AL                                 ; [3077: 88 47 04]
    MOV     AL, [var_lan_ack_expected]                       ; [307A: A0 42 4B]
    MOV     BYTE [BX+05], AL                                 ; [307D: 88 47 05]
    MOV     BX, 0108                                         ; [3080: BB 08 01]
    MOV     DI, 0100                                         ; [3083: BF 00 01]
    CALL    sub_2de8                                         ; [3086: E8 5F FD]
    PUSH    ES                                               ; [3089: 06]
    MOV     SI, 4B4A                                         ; [308A: BE 4A 4B]
    CALL    sub_28e3                                         ; [308D: E8 53 F8]
    POP     ES                                               ; [3090: 07]
    POP     CX                                               ; [3091: 59]
    CALL    sub_2902                                         ; [3092: E8 6D F8]
    RETN                                                     ; [3095: C3]
sub_3096:
    PUSH    CX                                               ; [3096: 51]
    PUSHF                                                    ; [3097: 9C]
    CLI                                                      ; [3098: FA]
    MOV     WORD [var_screen_cursor_col], 0000               ; [3099: C7 06 E0 00 00 00]
    MOV     WORD [var_screen_cursor_row], 0000               ; [309F: C7 06 E2 00 00 00]
    CALL    sub_2bc2                                         ; [30A5: E8 1A FB]
    MOV     BX, 076A                                         ; [30A8: BB 6A 07]
    MOV     CX, 0010                                         ; [30AB: B9 10 00]
    MOV     DI, 06CA                                         ; [30AE: BF CA 06]
loc_30b1:
    PUSH    CX                                               ; [30B1: 51]
    CALL    sub_2de8                                         ; [30B2: E8 33 FD]
    POP     CX                                               ; [30B5: 59]
    ADD     DI, +0A                                          ; [30B6: 83 C7 0A]
    ADD     BX, 0438                                         ; [30B9: 81 C3 38 04]
    LOOP    loc_30b1                                         ; [30BD: E2 F2]
    MOV     SI, WORD [var_lan_client_ip_lo]                  ; [30BF: 8B 36 21 4B]
    MOV     WORD [var_screen_attribute], SI                  ; [30C3: 89 36 E6 00]
    MOV     WORD [var_lan_station_id], SI                    ; [30C7: 89 36 1E 4B]
    MOV     BYTE [var_lan_activity_flag], 00                 ; [30CB: C6 06 92 4B 00]
    MOV     BYTE [var_lan_server_id], 00                     ; [30D0: C6 06 20 4B 00]
    POPF                                                     ; [30D5: 9D]
    MOV     AX, 0010                                         ; [30D6: B8 10 00]
    CALL    sub_28f3                                         ; [30D9: E8 17 F8]
    POP     CX                                               ; [30DC: 59]
    MOV     BYTE [var_lan_connection_state], 00              ; [30DD: C6 06 95 4B 00]
    MOV     BYTE [var_lan_scb_command], 05                   ; [30E2: C6 06 77 4B 05]
    MOV     BYTE [var_lan_connection_state], 00              ; [30E7: C6 06 95 4B 00]
loc_30ec:
    CMP     BYTE [var_lan_scb_command], 00                   ; [30EC: 80 3E 77 4B 00]
    JNZ     loc_30f6                                         ; [30F1: 75 03]
    JMPN    loc_317a                                         ; [30F3: E9 84 00]
loc_30f6:
    DEC     BYTE [var_lan_scb_command]                       ; [30F6: FE 0E 77 4B]
    PUSH    CX                                               ; [30FA: 51]
    CALL    sub_3061                                         ; [30FB: E8 63 FF]
    MOV     AL, 04                                           ; [30FE: B0 04]
    MOV     [var_lan_protocol_type], AL                      ; [3100: A2 35 4B]
    PUSH    ES                                               ; [3103: 06]
    MOV     AX, [CS:ram_segment_base]                        ; [3104: 2E A1 02 00]
    MOV     ES, AX                                           ; [3108: 8E C0]
    MOV     AX, [ES:var_timer0_tick_count] ; Timer 0 tick counter (incremented by timer ISR) ; [310A: 26 A1 35 01]
    POP     ES                                               ; [310E: 07]
    MOV     WORD [var_lan_packet_len], 0014                  ; [310F: C7 06 2B 4B 14 00]
    ADD     WORD [var_lan_packet_len], AX                    ; [3115: 01 06 2B 4B]
    CALL    sub_293f                                         ; [3119: E8 23 F8]
    POP     CX                                               ; [311C: 59]
    CMP     BYTE [var_lan_connection_state], FF              ; [311D: 80 3E 95 4B FF]
    JZ      loc_3128                                         ; [3122: 74 04]
    OR      AL, AL                                           ; [3124: 0A C0]
    JNZ     loc_30ec                                         ; [3126: 75 C4]
loc_3128:
    INC     BYTE [var_lan_sequence_num]                      ; [3128: FE 06 44 4B]
    AND     BYTE [var_lan_sequence_num], 01                  ; [312C: 80 26 44 4B 01]
    CMP     BYTE [var_lan_connection_state], FF              ; [3131: 80 3E 95 4B FF]
    JZ      loc_315a                                         ; [3136: 74 22]
    MOV     AL, 03                                           ; [3138: B0 03]
    MOV     [var_lan_protocol_type], AL                      ; [313A: A2 35 4B]
    PUSH    ES                                               ; [313D: 06]
    MOV     AX, [CS:ram_segment_base]                        ; [313E: 2E A1 02 00]
    MOV     ES, AX                                           ; [3142: 8E C0]
    MOV     AX, [ES:var_timer0_tick_count] ; Timer 0 tick counter (incremented by timer ISR) ; [3144: 26 A1 35 01]
    POP     ES                                               ; [3148: 07]
    MOV     WORD [var_lan_packet_len], 03E8                  ; [3149: C7 06 2B 4B E8 03]
    ADD     WORD [var_lan_packet_len], AX                    ; [314F: 01 06 2B 4B]
    CALL    sub_293f                                         ; [3153: E8 E9 F7]
    OR      AL, AL                                           ; [3156: 0A C0]
    JNZ     loc_3168                                         ; [3158: 75 0E]
loc_315a:
    CALL    sub_318c                                         ; [315A: E8 2F 00]
    MOV     ES, WORD [var_lan_subnet_mask]                   ; [315D: 8E 06 25 4B]
    MOV     DI, WORD [var_lan_gateway_id]                    ; [3161: 8B 3E 27 4B]
    XOR     AL, AL                                           ; [3165: 32 C0]
    RETN                                                     ; [3167: C3]
loc_3168:
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [3168: B8 00 30]
    CALL    set_cursor_pos                                   ; [316B: E8 0B D1]
    MOV     AX, 3487                                         ; [316E: B8 87 34]
    MOV     CX, FFFF                                         ; [3171: B9 FF FF]
    CALL    print_string_es_ax                               ; [3174: E8 35 D2]
    MOV     AL, 01                                           ; [3177: B0 01]
    RETN                                                     ; [3179: C3]
loc_317a:
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [317A: B8 00 30]
    CALL    set_cursor_pos                                   ; [317D: E8 F9 D0]
    MOV     AX, 340E                                         ; [3180: B8 0E 34]
    MOV     CX, FFFF                                         ; [3183: B9 FF FF]
    CALL    print_string_es_ax                               ; [3186: E8 23 D2]
    MOV     AL, 01                                           ; [3189: B0 01]
    RETN                                                     ; [318B: C3]
sub_318c:
    PUSH    ES                                               ; [318C: 06]
    MOV     AX, [CS:ram_segment_base]                        ; [318D: 2E A1 02 00]
    MOV     ES, AX                                           ; [3191: 8E C0]
    CMP     WORD [ES:var_timer0_tick_count], 03E8 ; Timer 0 tick counter (incremented by timer ISR) ; [3193: 26 81 3E 35 01 E8 03]
    POP     ES                                               ; [319A: 07]
    JGE     loc_319e                                         ; [319B: 7D 01]
    RETN                                                     ; [319D: C3]
loc_319e:
    PUSHA                                                    ; [319E: 60]
    CALL    sub_2f91                                         ; [319F: E8 EF FD]
    CALL    sub_3223                                         ; [31A2: E8 7E 00]
    CALL    sub_3061                                         ; [31A5: E8 B9 FE]
    MOV     BYTE [var_lan_protocol_type], 04                 ; [31A8: C6 06 35 4B 04]
    PUSH    ES                                               ; [31AD: 06]
    MOV     AX, [CS:ram_segment_base]                        ; [31AE: 2E A1 02 00]
    MOV     ES, AX                                           ; [31B2: 8E C0]
    MOV     AX, [ES:var_timer0_tick_count] ; Timer 0 tick counter (incremented by timer ISR) ; [31B4: 26 A1 35 01]
    POP     ES                                               ; [31B8: 07]
    MOV     WORD [var_lan_packet_len], 0014                  ; [31B9: C7 06 2B 4B 14 00]
    ADD     WORD [var_lan_packet_len], AX                    ; [31BF: 01 06 2B 4B]
    CALL    sub_293f                                         ; [31C3: E8 79 F7]
    OR      AL, AL                                           ; [31C6: 0A C0]
    JNZ     loc_31d3                                         ; [31C8: 75 09]
    INC     BYTE [var_lan_sequence_num]                      ; [31CA: FE 06 44 4B]
    AND     BYTE [var_lan_sequence_num], 01                  ; [31CE: 80 26 44 4B 01]
loc_31d3:
    PUSH    ES                                               ; [31D3: 06]
    MOV     AX, [CS:ram_segment_base]                        ; [31D4: 2E A1 02 00]
    MOV     ES, AX                                           ; [31D8: 8E C0]
    MOV     WORD [ES:var_timer0_tick_count], 0000 ; Timer 0 tick counter (incremented by timer ISR) ; [31DA: 26 C7 06 35 01 00 00]
    POP     ES                                               ; [31E1: 07]
    POPA                                                     ; [31E2: 61]
    RETN                                                     ; [31E3: C3]
sub_31e4:
    PUSH    SI                                               ; [31E4: 56]
    PUSH    BX                                               ; [31E5: 53]
    MOV     SI, DI                                           ; [31E6: 8B F7]
    ADD     SI, +33                                          ; [31E8: 83 C6 33]
    CMP     BYTE [ES:SI], 01                                 ; [31EB: 26 80 3C 01]
    JNZ     loc_321f                                         ; [31EF: 75 2E]
    MOV     BX, WORD [ES:SI+01]                              ; [31F1: 26 8B 5C 01]
    MOV     AX, WORD [ES:SI+03]                              ; [31F5: 26 8B 44 03]
    ADD     BX, AX                                           ; [31F9: 03 D8]
    MOV     [var_lan_dma_channel], AX                        ; [31FB: A3 7B 4B]
    MOV     WORD [var_lan_boot_entry], 0000                  ; [31FE: C7 06 79 4B 00 00]
    SUB     AX, 0008                                         ; [3204: 2D 08 00]
    MOV     [var_lan_tx_buffer_ptr], AX                      ; [3207: A3 7F 4B]
    MOV     WORD [var_lan_rx_buffer_ptr], 0000               ; [320A: C7 06 81 4B 00 00]
    MOV     AX, WORD [ES:SI+0C]                              ; [3210: 26 8B 44 0C]
    CMP     AX, BX                                           ; [3214: 3B C3]
    JNZ     loc_321f                                         ; [3216: 75 07]
    MOV     [var_lan_irq_vector], AX                         ; [3218: A3 7D 4B]
    CLC                                                      ; [321B: F8]
    POP     BX                                               ; [321C: 5B]
    POP     SI                                               ; [321D: 5E]
    RETN                                                     ; [321E: C3]
loc_321f:
    STC                                                      ; [321F: F9]
    POP     BX                                               ; [3220: 5B]
    POP     SI                                               ; [3221: 5E]
    RETN                                                     ; [3222: C3]
sub_3223:
    MOV     BX, 0108                                         ; [3223: BB 08 01]
    MOV     BYTE [BX+06], 06                                 ; [3226: C6 47 06 06]
    MOV     AL, [var_lan_buffer_offset]                      ; [322A: A0 36 4B]
    XOR     AH, AH                                           ; [322D: 32 E4]
    MOV     WORD [BX+07], AX                                 ; [322F: 89 47 07]
    MOV     AL, [var_lan_command_code]                       ; [3232: A0 37 4B]
    MOV     AH, FF                                           ; [3235: B4 FF]
    MOV     WORD [BX+09], AX                                 ; [3237: 89 47 09]
    MOV     BYTE [BX+0B], 4D                                 ; [323A: C6 47 0B 4D]
    MOV     WORD [BX+0C], 0000                               ; [323E: C7 47 0C 00 00]
    MOV     BYTE [BX+0E], 00                                 ; [3243: C6 47 0E 00]
    MOV     CX, 0010                                         ; [3247: B9 10 00]
    RETN                                                     ; [324A: C3]
sub_324b:
    MOV     BYTE [var_lan_last_error], 40                    ; [324B: C6 06 94 4B 40]
    MOV     BX, 0108                                         ; [3250: BB 08 01]
    MOV     BYTE [BX+06], 06                                 ; [3253: C6 47 06 06]
    MOV     AL, [var_lan_buffer_offset]                      ; [3257: A0 36 4B]
    XOR     AH, AH                                           ; [325A: 32 E4]
    MOV     WORD [BX+07], AX                                 ; [325C: 89 47 07]
    MOV     AL, [var_lan_command_code]                       ; [325F: A0 37 4B]
    MOV     AH, BYTE [var_lan_remote_port]                   ; [3262: 8A 26 96 4B]
    MOV     WORD [BX+09], AX                                 ; [3266: 89 47 09]
    MOV     BYTE [BX+0B], 40                                 ; [3269: C6 47 0B 40]
    MOV     WORD [BX+0C], 0014                               ; [326D: C7 47 0C 14 00]
    MOV     DI, 0116                                         ; [3272: BF 16 01]
    MOV     SI, 4B39                                         ; [3275: BE 39 4B]
    PUSH    DS                                               ; [3278: 1E]
    POP     ES                                               ; [3279: 07]
    MOV     CX, 0008                                         ; [327A: B9 08 00]
    REP MOVSB                                                ; [327D: F3 A4]
    MOV     AL, [var_lan_command_code]                       ; [327F: A0 37 4B]
    MOV     BYTE [DI], AL                                    ; [3282: 88 05]
    INC     DI                                               ; [3284: 47]
    MOV     WORD [DI], 0000                                  ; [3285: C7 05 00 00]
    INC     DI                                               ; [3289: 47]
    MOV     SI, 4B89                                         ; [328A: BE 89 4B]
    MOV     CX, 0008                                         ; [328D: B9 08 00]
    REP MOVSB                                                ; [3290: F3 A4]
    XOR     AL, AL                                           ; [3292: 32 C0]
    MOV     BYTE [DI], AL                                    ; [3294: 88 05]
    INC     DI                                               ; [3296: 47]
    MOV     AL, 02                                           ; [3297: B0 02]
    MOV     BYTE [DI], AL                                    ; [3299: 88 05]
    MOV     AL, FF                                           ; [329B: B0 FF]
    INC     DI                                               ; [329D: 47]
    MOV     BYTE [DI], AL                                    ; [329E: 88 05]
    MOV     CX, 0023                                         ; [32A0: B9 23 00]
    RETN                                                     ; [32A3: C3]
sub_32a4:
    MOV     BYTE [var_lan_last_error], 41                    ; [32A4: C6 06 94 4B 41]
    MOV     BX, 0108                                         ; [32A9: BB 08 01]
    MOV     BYTE [BX+06], 06                                 ; [32AC: C6 47 06 06]
    MOV     AL, [var_lan_buffer_offset]                      ; [32B0: A0 36 4B]
    XOR     AH, AH                                           ; [32B3: 32 E4]
    MOV     WORD [BX+07], AX                                 ; [32B5: 89 47 07]
    MOV     AL, [var_lan_command_code]                       ; [32B8: A0 37 4B]
    MOV     AH, BYTE [var_lan_remote_port]                   ; [32BB: 8A 26 96 4B]
    MOV     WORD [BX+09], AX                                 ; [32BF: 89 47 09]
    MOV     BYTE [BX+0B], 41                                 ; [32C2: C6 47 0B 41]
    MOV     WORD [BX+0C], 0009                               ; [32C6: C7 47 0C 09 00]
    MOV     DI, 0116                                         ; [32CB: BF 16 01]
    MOV     SI, 4B39                                         ; [32CE: BE 39 4B]
    PUSH    DS                                               ; [32D1: 1E]
    POP     ES                                               ; [32D2: 07]
    MOV     CX, 0008                                         ; [32D3: B9 08 00]
    REP MOVSB                                                ; [32D6: F3 A4]
    MOV     AL, [var_lan_command_code]                       ; [32D8: A0 37 4B]
    MOV     BYTE [DI], AL                                    ; [32DB: 88 05]
    INC     DI                                               ; [32DD: 47]
    MOV     WORD [DI], 0000                                  ; [32DE: C7 05 00 00]
    MOV     CX, 0018                                         ; [32E2: B9 18 00]
    RETN                                                     ; [32E5: C3]
sub_32e6:
    MOV     BYTE [var_lan_last_error], 2C                    ; [32E6: C6 06 94 4B 2C]
    MOV     DI, 0108                                         ; [32EB: BF 08 01]
    MOV     BYTE [DI+06], 06                                 ; [32EE: C6 45 06 06]
    MOV     AL, [var_lan_buffer_offset]                      ; [32F2: A0 36 4B]
    XOR     AH, AH                                           ; [32F5: 32 E4]
    MOV     WORD [DI+07], AX                                 ; [32F7: 89 45 07]
    MOV     AL, [var_lan_command_code]                       ; [32FA: A0 37 4B]
    MOV     AH, BYTE [var_lan_remote_port]                   ; [32FD: 8A 26 96 4B]
    MOV     WORD [DI+09], AX                                 ; [3301: 89 45 09]
    MOV     BYTE [DI+0B], 2C                                 ; [3304: C6 45 0B 2C]
    MOV     WORD [DI+0C], 0001                               ; [3308: C7 45 0C 01 00]
    MOV     BYTE [DI+0E], 08                                 ; [330D: C6 45 0E 08]
    INC     DI                                               ; [3311: 47]
    MOV     BYTE [DI+0E], 08                                 ; [3312: C6 45 0E 08]
    MOV     CX, 0010                                         ; [3316: B9 10 00]
    RETN                                                     ; [3319: C3]
sub_331a:
    MOV     BYTE [var_lan_last_error], 4B                    ; [331A: C6 06 94 4B 4B]
    MOV     DI, 0108                                         ; [331F: BF 08 01]
    MOV     BYTE [DI+06], 06                                 ; [3322: C6 45 06 06]
    MOV     AL, [var_lan_buffer_offset]                      ; [3326: A0 36 4B]
    XOR     AH, AH                                           ; [3329: 32 E4]
    MOV     WORD [DI+07], AX                                 ; [332B: 89 45 07]
    MOV     AL, [var_lan_command_code]                       ; [332E: A0 37 4B]
    MOV     AH, BYTE [var_lan_remote_port]                   ; [3331: 8A 26 96 4B]
    MOV     WORD [DI+09], AX                                 ; [3335: 89 45 09]
    MOV     BYTE [DI+0B], 4B                                 ; [3338: C6 45 0B 4B]
    MOV     WORD [DI+0C], 0001                               ; [333C: C7 45 0C 01 00]
    MOV     WORD [DI+0E], 042E                               ; [3341: C7 45 0E 2E 04]
    MOV     CX, 0010                                         ; [3346: B9 10 00]
    RETN                                                     ; [3349: C3]
sub_334a:
    MOV     BYTE [var_lan_last_error], 0F                    ; [334A: C6 06 94 4B 0F]
    MOV     DI, 0108                                         ; [334F: BF 08 01]
    MOV     BYTE [DI+06], 06                                 ; [3352: C6 45 06 06]
    MOV     AL, [var_lan_buffer_offset]                      ; [3356: A0 36 4B]
    XOR     AH, AH                                           ; [3359: 32 E4]
    MOV     WORD [DI+07], AX                                 ; [335B: 89 45 07]
    MOV     AL, [var_lan_command_code]                       ; [335E: A0 37 4B]
    MOV     AH, BYTE [var_lan_remote_port]                   ; [3361: 8A 26 96 4B]
    MOV     WORD [DI+09], AX                                 ; [3365: 89 45 09]
    MOV     BYTE [DI+0B], 0F                                 ; [3368: C6 45 0B 0F]
    MOV     WORD [DI+0C], 002C                               ; [336C: C7 45 0C 2C 00]
    MOV     BYTE [DI+0E], 00                                 ; [3371: C6 45 0E 00]
    ADD     DI, +0F                                          ; [3375: 83 C7 0F]
    MOV     SI, 4B51                                         ; [3378: BE 51 4B]
    OR      BYTE [SI+06], 80                                 ; [337B: 80 4C 06 80]
    MOV     AL, [var_lan_sub_command]                        ; [337F: A0 38 4B]
    CMP     BYTE [var_lan_timeout_counter], 00               ; [3382: 80 3E 78 4B 00]
    JZ      loc_338c                                         ; [3387: 74 03]
    MOV     AL, [var_lan_timeout_counter]                    ; [3389: A0 78 4B]
loc_338c:
    INC     AL                                               ; [338C: FE C0]
    MOV     BYTE [SI], AL                                    ; [338E: 88 04]
    PUSH    DS                                               ; [3390: 1E]
    POP     ES                                               ; [3391: 07]
    MOV     CX, 0024                                         ; [3392: B9 24 00]
    REP MOVSB                                                ; [3395: F3 A4]
    MOV     SI, 4B89                                         ; [3397: BE 89 4B]
    MOV     CX, 0008                                         ; [339A: B9 08 00]
    REP MOVSB                                                ; [339D: F3 A4]
    MOV     CX, 003B                                         ; [339F: B9 3B 00]
    RETN                                                     ; [33A2: C3]
sub_33a3:
    MOV     BYTE [var_lan_last_error], 14                    ; [33A3: C6 06 94 4B 14]
    MOV     DI, 0108                                         ; [33A8: BF 08 01]
    MOV     BYTE [DI+06], 06                                 ; [33AB: C6 45 06 06]
    MOV     AL, [var_lan_buffer_offset]                      ; [33AF: A0 36 4B]
    XOR     AH, AH                                           ; [33B2: 32 E4]
    MOV     WORD [DI+07], AX                                 ; [33B4: 89 45 07]
    MOV     AL, [var_lan_command_code]                       ; [33B7: A0 37 4B]
    MOV     AH, BYTE [var_lan_remote_port]                   ; [33BA: 8A 26 96 4B]
    MOV     WORD [DI+09], AX                                 ; [33BE: 89 45 09]
    MOV     BYTE [DI+0B], 14                                 ; [33C1: C6 45 0B 14]
    MOV     WORD [DI+0C], 0024                               ; [33C5: C7 45 0C 24 00]
    MOV     BYTE [DI+0E], 00                                 ; [33CA: C6 45 0E 00]
    ADD     DI, +0F                                          ; [33CE: 83 C7 0F]
    PUSH    DS                                               ; [33D1: 1E]
    POP     ES                                               ; [33D2: 07]
    MOV     SI, 4B51                                         ; [33D3: BE 51 4B]
    MOV     CX, 0024                                         ; [33D6: B9 24 00]
    REP MOVSB                                                ; [33D9: F3 A4]
    MOV     CX, 0033                                         ; [33DB: B9 33 00]
    RETN                                                     ; [33DE: C3]
sub_33df:
    MOV     BYTE [var_lan_last_error], 10                    ; [33DF: C6 06 94 4B 10]
    MOV     DI, 0108                                         ; [33E4: BF 08 01]
    MOV     BYTE [DI+06], 06                                 ; [33E7: C6 45 06 06]
    MOV     AL, [var_lan_buffer_offset]                      ; [33EB: A0 36 4B]
    XOR     AH, AH                                           ; [33EE: 32 E4]
    MOV     WORD [DI+07], AX                                 ; [33F0: 89 45 07]
    MOV     AL, [var_lan_command_code]                       ; [33F3: A0 37 4B]
    MOV     AH, BYTE [var_lan_remote_port]                   ; [33F6: 8A 26 96 4B]
    MOV     WORD [DI+09], AX                                 ; [33FA: 89 45 09]
    MOV     BYTE [DI+0B], 10                                 ; [33FD: C6 45 0B 10]
    MOV     WORD [DI+0C], 002C                               ; [3401: C7 45 0C 2C 00]
    ADD     DI, +0F                                          ; [3406: 83 C7 0F]
    MOV     SI, 4B51                                         ; [3409: BE 51 4B]
    PUSH    DS                                               ; [340C: 1E]
    POP     ES                                               ; [340D: 07]
    MOV     CX, 0024                                         ; [340E: B9 24 00]
    REP MOVSB                                                ; [3411: F3 A4]
    MOV     CX, 003B                                         ; [3413: B9 3B 00]
    RETN                                                     ; [3416: C3]
sub_3417:
    CMP     BYTE [ES:DI+0E], 00                              ; [3417: 26 80 7D 0E 00]
    JNZ     loc_3421                                         ; [341C: 75 03]
    XOR     AL, AL                                           ; [341E: 32 C0]
    RETN                                                     ; [3420: C3]
loc_3421:
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [3421: B8 00 30]
    CALL    set_cursor_pos                                   ; [3424: E8 52 CE]
    MOV     AX, 336B                                         ; [3427: B8 6B 33]
    MOV     CX, FFFF                                         ; [342A: B9 FF FF]
    CALL    print_string_es_ax                               ; [342D: E8 7C CF]
    MOV     AL, 01                                           ; [3430: B0 01]
    RETN                                                     ; [3432: C3]
sub_3433:
    RETN                                                     ; [3433: C3]
sub_3434:
    CMP     BYTE [ES:DI+0E], 00                              ; [3434: 26 80 7D 0E 00]
    JNZ     loc_343e                                         ; [3439: 75 03]
    XOR     AL, AL                                           ; [343B: 32 C0]
    RETN                                                     ; [343D: C3]
loc_343e:
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [343E: B8 00 30]
    CALL    set_cursor_pos                                   ; [3441: E8 35 CE]
    MOV     AX, 3388                                         ; [3444: B8 88 33]
    MOV     CX, FFFF                                         ; [3447: B9 FF FF]
    CALL    print_string_es_ax                               ; [344A: E8 5F CF]
    MOV     AL, 01                                           ; [344D: B0 01]
    RETN                                                     ; [344F: C3]
sub_3450:
    CMP     BYTE [ES:DI+0E], 00                              ; [3450: 26 80 7D 0E 00]
    JNZ     loc_345a                                         ; [3455: 75 03]
    XOR     AL, AL                                           ; [3457: 32 C0]
    RETN                                                     ; [3459: C3]
loc_345a:
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [345A: B8 00 30]
    CALL    set_cursor_pos                                   ; [345D: E8 19 CE]
    MOV     AX, 34B1                                         ; [3460: B8 B1 34]
    MOV     CX, FFFF                                         ; [3463: B9 FF FF]
    CALL    print_string_es_ax                               ; [3466: E8 43 CF]
    MOV     AL, 01                                           ; [3469: B0 01]
    RETN                                                     ; [346B: C3]
sub_346c:
    CMP     BYTE [ES:DI+0E], 00                              ; [346C: 26 80 7D 0E 00]
    JNZ     loc_348b                                         ; [3471: 75 18]
    PUSH    ES                                               ; [3473: 06]
    PUSH    DS                                               ; [3474: 1E]
    POP     ES                                               ; [3475: 07]
    POP     DS                                               ; [3476: 1F]
    MOV     SI, DI                                           ; [3477: 8B F7]
    ADD     SI, +0F                                          ; [3479: 83 C6 0F]
    MOV     DI, 4B51                                         ; [347C: BF 51 4B]
    MOV     CX, 0024                                         ; [347F: B9 24 00]
    REP MOVSB                                                ; [3482: F3 A4]
    PUSH    ES                                               ; [3484: 06]
    PUSH    DS                                               ; [3485: 1E]
    POP     ES                                               ; [3486: 07]
    POP     DS                                               ; [3487: 1F]
    XOR     AL, AL                                           ; [3488: 32 C0]
    RETN                                                     ; [348A: C3]
loc_348b:
    CMP     BYTE [var_lan_timeout_counter], 00               ; [348B: 80 3E 78 4B 00]
    JNZ     loc_34a8                                         ; [3490: 75 16]
    CMP     BYTE [var_lan_rx_ready_flag], 01                 ; [3492: 80 3E 9F 4B 01]
    JZ      loc_34a8                                         ; [3497: 74 0F]
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [3499: B8 00 30]
    CALL    set_cursor_pos                                   ; [349C: E8 DA CD]
    MOV     AX, 33B1                                         ; [349F: B8 B1 33]
    MOV     CX, FFFF                                         ; [34A2: B9 FF FF]
    CALL    print_string_es_ax                               ; [34A5: E8 04 CF]
loc_34a8:
    MOV     AL, 01                                           ; [34A8: B0 01]
    RETN                                                     ; [34AA: C3]
sub_34ab:
    CMP     BYTE [ES:DI+0E], 02                              ; [34AB: 26 80 7D 0E 02]
    JGE     loc_352c                                         ; [34B0: 7D 7A]
    CMP     BYTE [ES:DI+0E], 01                              ; [34B2: 26 80 7D 0E 01]
    JNZ     loc_34be                                         ; [34B7: 75 05]
    MOV     BYTE [var_lan_multicast_flag], 01                ; [34B9: C6 06 50 4B 01]
loc_34be:
    CMP     BYTE [var_lan_link_status], FF                   ; [34BE: 80 3E 93 4B FF]
    JNZ     loc_34e0                                         ; [34C3: 75 1B]
    PUSH    DS                                               ; [34C5: 1E]
    MOV     AX, LAN_BUFFER_SEGMENT                           ; [34C6: B8 00 36]
    MOV     DS, AX                                           ; [34C9: 8E D8]
    CMP     BYTE [var_lan_rx_ready_flag], 01                 ; [34CB: 80 3E 9F 4B 01]
    POP     DS                                               ; [34D0: 1F]
    JZ      loc_34e0                                         ; [34D1: 74 0D]
    CALL    sub_31e4                                         ; [34D3: E8 0E FD]
    MOV     BYTE [var_lan_link_status], 00                   ; [34D6: C6 06 93 4B 00]
    JNC     loc_34e0                                         ; [34DB: 73 03]
    JMPN    loc_3529                                         ; [34DD: E9 49 00]
loc_34e0:
    PUSH    ES                                               ; [34E0: 06]
    POP     DS                                               ; [34E1: 1F]
    MOV     SI, DI                                           ; [34E2: 8B F7]
    MOV     AX, LAN_BUFFER_SEGMENT                           ; [34E4: B8 00 36]
    MOV     ES, AX                                           ; [34E7: 8E C0]
    ADD     SI, +0F                                          ; [34E9: 83 C6 0F]
    MOV     DI, 4B51                                         ; [34EC: BF 51 4B]
    MOV     CX, 0012                                         ; [34EF: B9 12 00]
    REP MOVSW                                                ; [34F2: F3 A5]
    PUSHA                                                    ; [34F4: 60]
    MOV     DI, WORD [ES:var_lan_rx_buffer_ptr]              ; [34F5: 26 8B 3E 81 4B]
    MOV     ES, WORD [ES:var_lan_tx_buffer_ptr]              ; [34FA: 26 8E 06 7F 4B]
    MOV     CX, 0200                                         ; [34FF: B9 00 02]
    REP MOVSW                                                ; [3502: F3 A5]
    MOV     AX, LAN_BUFFER_SEGMENT                           ; [3504: B8 00 36]
    MOV     DS, AX                                           ; [3507: 8E D8]
    CMP     WORD [var_lan_rx_buffer_ptr], FC00               ; [3509: 81 3E 81 4B 00 FC]
    JZ      loc_3519                                         ; [350F: 74 08]
    ADD     WORD [var_lan_rx_buffer_ptr], 0400               ; [3511: 81 06 81 4B 00 04]
    JMPS    loc_3525                                         ; [3517: EB 0C]
loc_3519:
    ADD     WORD [var_lan_tx_buffer_ptr], 1000               ; [3519: 81 06 7F 4B 00 10]
    MOV     WORD [var_lan_rx_buffer_ptr], 0000               ; [351F: C7 06 81 4B 00 00]
loc_3525:
    POPA                                                     ; [3525: 61]
    XOR     AL, AL                                           ; [3526: 32 C0]
    RETN                                                     ; [3528: C3]
loc_3529:
    MOV     AL, 01                                           ; [3529: B0 01]
    RETN                                                     ; [352B: C3]
loc_352c:
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [352C: B8 00 30]
    CALL    set_cursor_pos                                   ; [352F: E8 47 CD]
    MOV     AX, 33D0                                         ; [3532: B8 D0 33]
    MOV     CX, FFFF                                         ; [3535: B9 FF FF]
    CALL    print_string_es_ax                               ; [3538: E8 71 CE]
    MOV     AL, 01                                           ; [353B: B0 01]
    RETN                                                     ; [353D: C3]
sub_353e:
    CMP     BYTE [ES:DI+0E], 00                              ; [353E: 26 80 7D 0E 00]
    JNZ     loc_3548                                         ; [3543: 75 03]
    XOR     AL, AL                                           ; [3545: 32 C0]
    RETN                                                     ; [3547: C3]
loc_3548:
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [3548: B8 00 30]
    CALL    set_cursor_pos                                   ; [354B: E8 2B CD]
    MOV     AX, 33EF                                         ; [354E: B8 EF 33]
    MOV     CX, FFFF                                         ; [3551: B9 FF FF]
    CALL    print_string_es_ax                               ; [3554: E8 55 CE]
    MOV     AL, 01                                           ; [3557: B0 01]
    RETN                                                     ; [3559: C3]
    PUSHA                                                    ; [355A: 60]
    PUSH    DS                                               ; [355B: 1E]
    PUSH    ES                                               ; [355C: 06]
    PUSHF                                                    ; [355D: 9C]
    MOV     BP, SP                                           ; [355E: 8B EC]
    MOV     AL, 0D                                           ; [3560: B0 0D]
    CALL    conout_char                                      ; [3562: E8 33 CD]
    MOV     AL, 0A                                           ; [3565: B0 0A]
    CALL    conout_char                                      ; [3567: E8 2E CD]
    MOV     CX, 000D                                         ; [356A: B9 0D 00]
loc_356d:
    PUSH    CX                                               ; [356D: 51]
    MOV     AX, WORD [BP+00]                                 ; [356E: 8B 46 00]
    CALL    sub_0345                                         ; [3571: E8 D1 CD]
    MOV     AL, 20                                           ; [3574: B0 20]
    CALL    conout_char                                      ; [3576: E8 1F CD]
    ADD     BP, +02                                          ; [3579: 83 C5 02]
    POP     CX                                               ; [357C: 59]
    LOOP    loc_356d                                         ; [357D: E2 EE]
    POPF                                                     ; [357F: 9D]
    POP     ES                                               ; [3580: 07]
    POP     DS                                               ; [3581: 1F]
    POPA                                                     ; [3582: 61]
    RETF                                                     ; [3583: CB]
loc_3584:
    CLD                                                      ; [3584: FC]
    MOV     AX, [CS:rom_segment_base]                        ; [3585: 2E A1 00 00]
    MOV     DS, AX                                           ; [3589: 8E D8]
    MOV     AX, LAN_BUFFER_SEGMENT                           ; [358B: B8 00 36]
    MOV     ES, AX                                           ; [358E: 8E C0]
    MOV     SI, 332B                                         ; [3590: BE 2B 33]
    MOV     DI, 4B83                                         ; [3593: BF 83 4B]
    MOV     CX, 001C                                         ; [3596: B9 1C 00]
    REP MOVSB                                                ; [3599: F3 A4]
    PUSH    DS                                               ; [359B: 1E]
    PUSH    ES                                               ; [359C: 06]
    POP     DS                                               ; [359D: 1F]
    POP     ES                                               ; [359E: 07]
    MOV     BYTE [var_lan_last_ack], 00                      ; [359F: C6 06 43 4B 00]
    MOV     BYTE [var_lan_tx_timeout], 05                    ; [35A4: C6 06 34 4B 05]
    CALL    sub_2f1b                                         ; [35A9: E8 6F F9]
    CALL    sub_377e                                         ; [35AC: E8 CF 01]
    MOV     AL, [var_lan_buffer_offset]                      ; [35AF: A0 36 4B]
    CMP     AL, BYTE [var_lan_command_code]                  ; [35B2: 3A 06 37 4B]
    JNZ     loc_35ca                                         ; [35B6: 75 12]
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [35B8: B8 00 30]
    CALL    set_cursor_pos                                   ; [35BB: E8 BB CC]
    MOV     AX, 3436                                         ; [35BE: B8 36 34]
    MOV     CX, FFFF                                         ; [35C1: B9 FF FF]
    CALL    print_string_es_ax                               ; [35C4: E8 E5 CD]
    JMPN    loc_374e                                         ; [35C7: E9 84 01]
loc_35ca:
    MOV     AX, 056A                                         ; [35CA: B8 6A 05]
    MOV     [var_lan_station_id], AX                         ; [35CD: A3 1E 4B]
    MOV     [var_lan_client_ip_lo], AX                       ; [35D0: A3 21 4B]
    MOV     AX, 06CA                                         ; [35D3: B8 CA 06]
    MOV     [var_lan_client_ip_hi], AX                       ; [35D6: A3 23 4B]
    CALL    sub_2aff                                         ; [35D9: E8 23 F5]
    MOV     BYTE [var_lan_server_id], 00                     ; [35DC: C6 06 20 4B 00]
    CALL    sub_2cb4                                         ; [35E1: E8 D0 F6]
    OR      AL, AL                                           ; [35E4: 0A C0]
    JZ      loc_35eb                                         ; [35E6: 74 03]
    JMPN    loc_374e                                         ; [35E8: E9 63 01]
loc_35eb:
    MOV     AX, 0010                                         ; [35EB: B8 10 00]
    CALL    sub_28f3                                         ; [35EE: E8 02 F3]
    MOV     BYTE [var_lan_rx_packets], 00                    ; [35F1: C6 06 46 4B 00]
    PUSH    ES                                               ; [35F6: 06]
    MOV     AX, [CS:ram_segment_base]                        ; [35F7: 2E A1 02 00]
    MOV     ES, AX                                           ; [35FB: 8E C0]
    MOV     WORD [ES:var_timer0_tick_count], 0000 ; Timer 0 tick counter (incremented by timer ISR) ; [35FD: 26 C7 06 35 01 00 00]
    POP     ES                                               ; [3604: 07]
loc_3605:
    DEC     BYTE [var_lan_tx_timeout]                        ; [3605: FE 0E 34 4B]
    JZ      loc_3633                                         ; [3609: 74 28]
    CALL    sub_2f91                                         ; [360B: E8 83 F9]
    MOV     AL, 01                                           ; [360E: B0 01]
    MOV     [var_lan_protocol_type], AL                      ; [3610: A2 35 4B]
    PUSH    ES                                               ; [3613: 06]
    MOV     AX, [CS:ram_segment_base]                        ; [3614: 2E A1 02 00]
    MOV     ES, AX                                           ; [3618: 8E C0]
    MOV     AX, [ES:var_timer0_tick_count] ; Timer 0 tick counter (incremented by timer ISR) ; [361A: 26 A1 35 01]
    POP     ES                                               ; [361E: 07]
    MOV     WORD [var_lan_packet_len], 0014                  ; [361F: C7 06 2B 4B 14 00]
    ADD     WORD [var_lan_packet_len], AX                    ; [3625: 01 06 2B 4B]
    CALL    sub_293f                                         ; [3629: E8 13 F3]
    OR      AL, AL                                           ; [362C: 0A C0]
    JNZ     loc_3605                                         ; [362E: 75 D5]
    JMPN    loc_3645                                         ; [3630: E9 12 00]
loc_3633:
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [3633: B8 00 30]
    CALL    set_cursor_pos                                   ; [3636: E8 40 CC]
    MOV     AX, 345F                                         ; [3639: B8 5F 34]
    MOV     CX, FFFF                                         ; [363C: B9 FF FF]
    CALL    print_string_es_ax                               ; [363F: E8 6A CD]
    JMPN    loc_374e                                         ; [3642: E9 09 01]
loc_3645:
    MOV     BYTE [var_lan_local_port], FF                    ; [3645: C6 06 9D 4B FF]
    CALL    sub_324b                                         ; [364A: E8 FE FB]
    CALL    sub_3096                                         ; [364D: E8 46 FA]
    OR      AL, AL                                           ; [3650: 0A C0]
    JZ      loc_3657                                         ; [3652: 74 03]
    JMPN    loc_374e                                         ; [3654: E9 F7 00]
loc_3657:
    CALL    sub_3417                                         ; [3657: E8 BD FD]
    OR      AL, AL                                           ; [365A: 0A C0]
    JZ      loc_3661                                         ; [365C: 74 03]
    JMPN    loc_374e                                         ; [365E: E9 ED 00]
loc_3661:
    CALL    sub_334a                                         ; [3661: E8 E6 FC]
    CALL    sub_3096                                         ; [3664: E8 2F FA]
    OR      AL, AL                                           ; [3667: 0A C0]
    JZ      loc_366e                                         ; [3669: 74 03]
    JMPN    loc_374e                                         ; [366B: E9 E0 00]
loc_366e:
    CALL    sub_346c                                         ; [366E: E8 FB FD]
    OR      AL, AL                                           ; [3671: 0A C0]
    JZ      loc_3684                                         ; [3673: 74 0F]
    CMP     BYTE [var_lan_timeout_counter], 00               ; [3675: 80 3E 78 4B 00]
    MOV     BYTE [var_lan_timeout_counter], 00               ; [367A: C6 06 78 4B 00]
    JNZ     loc_3661                                         ; [367F: 75 E0]
    JMPN    loc_374e                                         ; [3681: E9 CA 00]
loc_3684:
    CALL    sub_331a                                         ; [3684: E8 93 FC]
    CALL    sub_3096                                         ; [3687: E8 0C FA]
    OR      AL, AL                                           ; [368A: 0A C0]
    JZ      loc_3691                                         ; [368C: 74 03]
    JMPN    loc_374e                                         ; [368E: E9 BD 00]
loc_3691:
    CALL    sub_3450                                         ; [3691: E8 BC FD]
    OR      AL, AL                                           ; [3694: 0A C0]
    JZ      loc_369b                                         ; [3696: 74 03]
    JMPN    loc_374e                                         ; [3698: E9 B3 00]
loc_369b:
    CALL    sub_32e6                                         ; [369B: E8 48 FC]
    CALL    sub_3096                                         ; [369E: E8 F5 F9]
    OR      AL, AL                                           ; [36A1: 0A C0]
    JZ      loc_36a8                                         ; [36A3: 74 03]
    JMPN    loc_374e                                         ; [36A5: E9 A6 00]
loc_36a8:
    CALL    sub_3434                                         ; [36A8: E8 89 FD]
    OR      AL, AL                                           ; [36AB: 0A C0]
    JZ      loc_36b2                                         ; [36AD: 74 03]
    JMPN    loc_374e                                         ; [36AF: E9 9C 00]
loc_36b2:
    MOV     BYTE [var_lan_multicast_flag], 00                ; [36B2: C6 06 50 4B 00]
    MOV     AX, 0300                                         ; [36B7: B8 00 03]
    CALL    set_cursor_pos                                   ; [36BA: E8 BC CB]
loc_36bd:
    MOV     AL, 2A                                           ; [36BD: B0 2A]
    CALL    conout_char                                      ; [36BF: E8 D6 CB]
    CMP     BYTE [var_lan_multicast_flag], 01                ; [36C2: 80 3E 50 4B 01]
    JZ      loc_36e0                                         ; [36C7: 74 17]
    CALL    sub_33a3                                         ; [36C9: E8 D7 FC]
    CALL    sub_3096                                         ; [36CC: E8 C7 F9]
    OR      AL, AL                                           ; [36CF: 0A C0]
    JZ      loc_36d6                                         ; [36D1: 74 03]
    JMPN    loc_374e                                         ; [36D3: E9 78 00]
loc_36d6:
    CALL    sub_34ab                                         ; [36D6: E8 D2 FD]
    OR      AL, AL                                           ; [36D9: 0A C0]
    JZ      loc_36bd                                         ; [36DB: 74 E0]
    JMPN    loc_374e                                         ; [36DD: E9 6E 00]
loc_36e0:
    CALL    sub_33df                                         ; [36E0: E8 FC FC]
    CALL    sub_3096                                         ; [36E3: E8 B0 F9]
    OR      AL, AL                                           ; [36E6: 0A C0]
    JZ      loc_36ed                                         ; [36E8: 74 03]
    JMPN    loc_374e                                         ; [36EA: E9 61 00]
loc_36ed:
    CALL    sub_353e                                         ; [36ED: E8 4E FE]
    OR      AL, AL                                           ; [36F0: 0A C0]
    JZ      loc_36f7                                         ; [36F2: 74 03]
    JMPN    loc_374e                                         ; [36F4: E9 57 00]
loc_36f7:
    CALL    sub_32a4                                         ; [36F7: E8 AA FB]
    CALL    sub_3096                                         ; [36FA: E8 99 F9]
    OR      AL, AL                                           ; [36FD: 0A C0]
    JZ      loc_3704                                         ; [36FF: 74 03]
    JMPN    loc_374e                                         ; [3701: E9 4A 00]
loc_3704:
    CALL    sub_3433                                         ; [3704: E8 2C FD]
    MOV     BX, 00E0                                         ; [3707: BB E0 00]
    MOV     WORD [BX], 0000                                  ; [370A: C7 07 00 00]
    MOV     WORD [BX+02], 0080                               ; [370E: C7 47 02 80 00]
    MOV     DX, 0100                                         ; [3713: BA 00 01]
    IN      AL, DX                                           ; [3716: EC]
    MOV     CX, 0064                                         ; [3717: B9 64 00]
loc_371a:
    LOOP    loc_371a                                         ; [371A: E2 FE]
    PUSH    ES                                               ; [371C: 06]
    PUSH    DS                                               ; [371D: 1E]
    MOV     AX, LAN_BUFFER_SEGMENT                           ; [371E: B8 00 36]
    MOV     DS, AX                                           ; [3721: 8E D8]
    XOR     AX, AX                                           ; [3723: 33 C0]
    MOV     ES, AX                                           ; [3725: 8E C0]
    CMP     BYTE [var_lan_rx_ready_flag], 01                 ; [3727: 80 3E 9F 4B 01]
    JNZ     loc_3741                                         ; [372C: 75 13]
    MOV     BYTE [var_lan_rx_ready_flag], 00                 ; [372E: C6 06 9F 4B 00]
    MOV     AX, [var_lan_rx_buffer_ptr]                      ; [3733: A1 81 4B]
    MOV     [var_lan_transfer_len], AX                       ; [3736: A3 A2 4B]
    CALL    sub_220c                                         ; [3739: E8 D0 EA]
    POP     DS                                               ; [373C: 1F]
    POP     ES                                               ; [373D: 07]
    JMPN    loc_3584                                         ; [373E: E9 43 FE]
loc_3741:
    POP     DS                                               ; [3741: 1F]
    POP     ES                                               ; [3742: 07]
    PUSH    DS                                               ; [3743: 1E]
    POP     ES                                               ; [3744: 07]
    MOV     DS, WORD [var_lan_irq_vector]                    ; [3745: 8E 1E 7D 4B]
    JMPF    WORD [ES:var_lan_boot_entry]                     ; [3749: 26 FF 2E 79 4B]
loc_374e:
    MOV     BX, 00E0                                         ; [374E: BB E0 00]
    MOV     WORD [BX], 0000                                  ; [3751: C7 07 00 00]
    MOV     WORD [BX+02], 0080                               ; [3755: C7 47 02 80 00]
    MOV     DX, 0100                                         ; [375A: BA 00 01]
    IN      AL, DX                                           ; [375D: EC]
    MOV     CX, 0064                                         ; [375E: B9 64 00]
loc_3761:
    LOOP    loc_3761                                         ; [3761: E2 FE]
    MOV     BYTE [var_boot_status], 00                       ; [3763: C6 06 14 00 00]
    CMP     BYTE [var_lan_rx_ready_flag], 01                 ; [3768: 80 3E 9F 4B 01]
    JNZ     loc_377a                                         ; [376D: 75 0B]
    MOV     BYTE [var_lan_rx_ready_flag], 00                 ; [376F: C6 06 9F 4B 00]
    CALL    fdc_motor_off                                    ; [3774: E8 96 05]
    JMPN    loc_3584                                         ; [3777: E9 0A FE]
loc_377a:
    CALL    fdc_release_bus                                  ; [377A: E8 A7 05]
    RETN                                                     ; [377D: C3]
sub_377e:
    CMP     BYTE [var_lan_rx_ready_flag], 01                 ; [377E: 80 3E 9F 4B 01]
    JNZ     loc_37a2                                         ; [3783: 75 1D]
    MOV     DI, 4B52                                         ; [3785: BF 52 4B]
    MOV     CX, 0008                                         ; [3788: B9 08 00]
    MOV     BX, 2F3F                                         ; [378B: BB 3F 2F]
loc_378e:
    MOV     AL, BYTE [ES:BX]                                 ; [378E: 26 8A 07]
    MOV     BYTE [DI], AL                                    ; [3791: 88 05]
    INC     DI                                               ; [3793: 47]
    INC     BX                                               ; [3794: 43]
    LOOP    loc_378e                                         ; [3795: E2 F7]
    MOV     AX, 5517                                         ; [3797: B8 17 55]
    MOV     [var_lan_rx_buffer_ptr], AX                      ; [379A: A3 81 4B]
    MOV     AX, DS                                           ; [379D: 8C D8]
    MOV     [var_lan_tx_buffer_ptr], AX                      ; [379F: A3 7F 4B]
loc_37a2:
    RETN                                                     ; [37A2: C3]

; ----------------------------------------------------------------------------
; fdc_boot_read_sector (ROM: 6FE3h, FB84:37A3h)
; ----------------------------------------------------------------------------
fdc_boot_read_sector:
    MOV     BX, 005F                                         ; [37A3: BB 5F 00]
    CMP     BYTE [ES:BX], FF                                 ; [37A6: 26 80 3F FF]
    JZ      loc_37bc                                         ; [37AA: 74 10]
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [37AC: B8 00 30]
    CALL    set_cursor_pos                                   ; [37AF: E8 C7 CA]
    MOV     AX, 25E3                                         ; [37B2: B8 E3 25]
    MOV     CX, 0011                                         ; [37B5: B9 11 00]
    CALL    print_string_es_ax                               ; [37B8: E8 F1 CB]
    RETN                                                     ; [37BB: C3]
loc_37bc:
    MOV     DX, io_floppy_reserve_ack    ; Floppy Reserve / Acknowledge register ; [37BC: BA 8E 02]
    OUT     DX, AL                                           ; [37BF: EE]
loc_37c0:
    MOV     DX, io_floppy_reserve_ack    ; Floppy Reserve / Acknowledge register ; [37C0: BA 8E 02]
    MOV     AL, FF                                           ; [37C3: B0 FF]
    OUT     DX, AL                                           ; [37C5: EE]
    IN      AL, DX                                           ; [37C6: EC]
    TEST    AL, 80                                           ; [37C7: A8 80]
    JNZ     loc_37c0                                         ; [37C9: 75 F5]
    MOV     AX, 0007                                         ; [37CB: B8 07 00]
    CALL    nvram_read_byte_al                               ; [37CE: E8 E9 03]
    TEST    AL, 80                                           ; [37D1: A8 80]
    JNZ     loc_37fc                                         ; [37D3: 75 27]
    MOV     AL, [ES:var_floppy_target_drive]                 ; [37D5: 26 A0 63 00]
    CMP     AL, 02                                           ; [37D9: 3C 02]
    JZ      loc_37fc                                         ; [37DB: 74 1F]
    MOV     DX, io_floppy_ctrl           ; Floppy Control register (Motor 0/1, Drive sel, DDEN) ; [37DD: BA 88 02]
    MOV     AL, 47                                           ; [37E0: B0 47]
    OUT     DX, AL                                           ; [37E2: EE]
    MOV     DX, io_wd2797_status_cmd     ; WD2797 FDC Status / Command register ; [37E3: BA 80 02]
    IN      AL, DX                                           ; [37E6: EC]
    TEST    AL, 80                                           ; [37E7: A8 80]
    JNZ     loc_37f2                                         ; [37E9: 75 07]
    INC     BYTE [ES:var_floppy_target_drive]                ; [37EB: 26 FE 06 63 00]
    JMPS    loc_37fc                                         ; [37F0: EB 0A]
loc_37f2:
    CALL    fdc_wait_ready_timeout                           ; [37F2: E8 07 02]
    JC      loc_37fc                                         ; [37F5: 72 05]
    INC     BYTE [ES:var_floppy_target_drive]                ; [37F7: 26 FE 06 63 00]
loc_37fc:
    CALL    sub_2206                                         ; [37FC: E8 07 EA]
    CALL    fdc_recalibrate_track0                           ; [37FF: E8 04 01]
    JC      loc_3852                                         ; [3802: 72 4E]
    CALL    fdc_check_status                                 ; [3804: E8 DA 04]
    JNC     loc_380c                                         ; [3807: 73 03]
    JMPN    loc_3862                                         ; [3809: E9 56 00]
loc_380c:
    MOV     AX, [var_screen_field_attr]                      ; [380C: A1 D9 00]
    MOV     BX, WORD [var_screen_font_select]                ; [380F: 8B 1E DB 00]
    CALL    fdc_compute_geometry                             ; [3813: E8 8C 03]
    MOV     BX, WORD [ES:var_floppy_buffer_ptr]              ; [3816: 26 8B 1E 6D 00]
    SUB     BX, WORD [ES:var_floppy_sector_num]              ; [381B: 26 2B 1E 6B 00]
    PUSH    BX                                               ; [3820: 53]
    MOV     AL, 9C                                           ; [3821: B0 9C]
    CALL    fdc_read_sector_dma                              ; [3823: E8 2F 02]
    POP     BX                                               ; [3826: 5B]
    JC      loc_3852                                         ; [3827: 72 29]
    ADD     WORD [var_dma0_byte_count], BX                   ; [3829: 01 1E 04 00]
    MOV     BYTE [ram_segment_base], 01                      ; [382D: C6 06 02 00 01]
    MOV     BX, WORD [ES:var_floppy_buffer_ptr]              ; [3832: 26 8B 1E 6D 00]
    MOV     AL, 9E                                           ; [3837: B0 9E]
    CALL    fdc_read_sector_dma                              ; [3839: E8 19 02]
    JC      loc_3852                                         ; [383C: 72 14]
    MOV     BX, 001A                                         ; [383E: BB 1A 00]
    MOV     AX, [var_screen_color_mode]                      ; [3841: A1 DD 00]
    MOV     WORD [BX], AX                                    ; [3844: 89 07]
    MOV     AX, [var_screen_field_attr]                      ; [3846: A1 D9 00]
    MOV     WORD [BX+02], AX                                 ; [3849: 89 47 02]
    MOV     BYTE [var_boot_status], FF                       ; [384C: C6 06 14 00 FF]
    RETN                                                     ; [3851: C3]
loc_3852:
    PUSH    DS                                               ; [3852: 1E]
    XOR     DX, DX                                           ; [3853: 33 D2]
    MOV     DS, DX                                           ; [3855: 8E DA]
    CALL    sub_1fdd                                         ; [3857: E8 83 E7]
    POP     DS                                               ; [385A: 1F]
    CALL    sub_3875                                         ; [385B: E8 17 00]
    CALL    sub_39c6                                         ; [385E: E8 65 01]
    RETN                                                     ; [3861: C3]
loc_3862:
    MOV     AX, 3001                                         ; [3862: B8 01 30]
    CALL    set_cursor_pos                                   ; [3865: E8 11 CA]
    MOV     AX, 31BE                                         ; [3868: B8 BE 31]
    MOV     CX, 0016                                         ; [386B: B9 16 00]
    CALL    print_string_es_ax                               ; [386E: E8 3B CB]
    CALL    sub_39c6                                         ; [3871: E8 52 01]
    RETN                                                     ; [3874: C3]
sub_3875:
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [3875: B8 00 30]
    CALL    set_cursor_pos                                   ; [3878: E8 FE C9]
    MOV     AX, 23BF                                         ; [387B: B8 BF 23]
    MOV     CX, 0007                                         ; [387E: B9 07 00]
    CALL    print_string_es_ax                               ; [3881: E8 28 CB]
    MOV     AL, [ES:var_selftest_error_flags] ; Selftest error flags buffer ; [3884: 26 A0 20 01]
    XOR     AH, AH                                           ; [3888: 32 E4]
    CALL    sub_038b                                         ; [388A: E8 FE CA]
    RETN                                                     ; [388D: C3]
loc_388e:
    MOV     AX, 3001                                         ; [388E: B8 01 30]
    CALL    set_cursor_pos                                   ; [3891: E8 E5 C9]
    MOV     AX, 319C                                         ; [3894: B8 9C 31]
    MOV     CX, 0013                                         ; [3897: B9 13 00]
    CALL    print_string_es_ax                               ; [389A: E8 0F CB]
    RETN                                                     ; [389D: C3]

; ----------------------------------------------------------------------------
; validate_boot_device_char (ROM: 70DEh, FB84:389Eh)
; ----------------------------------------------------------------------------
validate_boot_device_char:
    AND     AL, DF                                           ; [389E: 24 DF]
    CMP     AL, 41                                           ; [38A0: 3C 41]
    JC      loc_38dc                                         ; [38A2: 72 38]
    CMP     AL, 44                                           ; [38A4: 3C 44]
    JA      loc_38ac                                         ; [38A6: 77 04]
    SUB     AL, 41                                           ; [38A8: 2C 41]
    CLC                                                      ; [38AA: F8]
    RETN                                                     ; [38AB: C3]
loc_38ac:
    CMP     AL, 4D                                           ; [38AC: 3C 4D]
    JNZ     loc_38b4                                         ; [38AE: 75 04]
    CLC                                                      ; [38B0: F8]
    MOV     AL, 05                                           ; [38B1: B0 05]
    RETN                                                     ; [38B3: C3]
loc_38b4:
    CMP     AL, 4E                                           ; [38B4: 3C 4E]
    JNZ     loc_38bc                                         ; [38B6: 75 04]
    CLC                                                      ; [38B8: F8]
    MOV     AL, 04                                           ; [38B9: B0 04]
    RETN                                                     ; [38BB: C3]
loc_38bc:
    CMP     AL, 4B                                           ; [38BC: 3C 4B]
    JNZ     loc_38c4                                         ; [38BE: 75 04]
    CLC                                                      ; [38C0: F8]
    MOV     AL, 06                                           ; [38C1: B0 06]
    RETN                                                     ; [38C3: C3]
loc_38c4:
    CMP     AL, 51                                           ; [38C4: 3C 51]
    JNZ     loc_38cc                                         ; [38C6: 75 04]
    CLC                                                      ; [38C8: F8]
    MOV     AL, 07                                           ; [38C9: B0 07]
    RETN                                                     ; [38CB: C3]
loc_38cc:
    CMP     AL, 4C                                           ; [38CC: 3C 4C]
    JNZ     loc_38d4                                         ; [38CE: 75 04]
    CLC                                                      ; [38D0: F8]
    MOV     AL, 08                                           ; [38D1: B0 08]
    RETN                                                     ; [38D3: C3]
loc_38d4:
    CMP     AL, 57                                           ; [38D4: 3C 57]
    JNZ     loc_38dc                                         ; [38D6: 75 04]
    CLC                                                      ; [38D8: F8]
    MOV     AL, 09                                           ; [38D9: B0 09]
    RETN                                                     ; [38DB: C3]
loc_38dc:
    STC                                                      ; [38DC: F9]
    RETN                                                     ; [38DD: C3]

; ----------------------------------------------------------------------------
; init_fdc_hardware (ROM: 711Eh, FB84:38DEh)
; ----------------------------------------------------------------------------
init_fdc_hardware:
    PUSH    AX                                               ; [38DE: 50]
    PUSH    SI                                               ; [38DF: 56]
    PUSH    CX                                               ; [38E0: 51]
    MOV     SI, 0015                                         ; [38E1: BE 15 00]
    PUSH    SI                                               ; [38E4: 56]
    MOV     CX, 0004                                         ; [38E5: B9 04 00]
loc_38e8:
    MOV     BYTE [SI], 00                                    ; [38E8: C6 04 00]
    INC     SI                                               ; [38EB: 46]
    LOOP    loc_38e8                                         ; [38EC: E2 FA]
    POP     SI                                               ; [38EE: 5E]
    MOV     AL, [ES:var_floppy_target_drive]                 ; [38EF: 26 A0 63 00]
    CMP     AL, 00                                           ; [38F3: 3C 00]
    JZ      loc_3902                                         ; [38F5: 74 0B]
    DEC     AL                                               ; [38F7: FE C8]
    MOV     BYTE [SI], 01                                    ; [38F9: C6 04 01]
    JZ      loc_3902                                         ; [38FC: 74 04]
    MOV     BYTE [SI+01], 01                                 ; [38FE: C6 44 01 01]
loc_3902:
    POP     CX                                               ; [3902: 59]
    POP     SI                                               ; [3903: 5E]
    POP     AX                                               ; [3904: 58]
    RETN                                                     ; [3905: C3]

; ----------------------------------------------------------------------------
; fdc_recalibrate_track0 (ROM: 7146h, FB84:3906h)
; ----------------------------------------------------------------------------
fdc_recalibrate_track0:
    MOV     BYTE [rom_segment_base], 00                      ; [3906: C6 06 00 00 00]
    MOV     BYTE [ram_segment_base], 01                      ; [390B: C6 06 02 00 01]
    MOV     BYTE [var_dma0_status], 00                       ; [3910: C6 06 01 00 00]
    MOV     WORD [var_dma0_reg_dest_hi], FFC6                ; [3915: C7 06 07 00 C6 FF]
    MOV     WORD [var_dma0_reg_dest_lo], FFC4                ; [391B: C7 06 09 00 C4 FF]
    MOV     WORD [var_dma0_reg_src_hi], FFC2                 ; [3921: C7 06 0B 00 C2 FF]
    MOV     WORD [var_dma0_reg_src_lo], FFC0                 ; [3927: C7 06 0D 00 C0 FF]
    MOV     WORD [var_dma0_reg_count], FFC8                  ; [392D: C7 06 0F 00 C8 FF]
    MOV     WORD [var_dma0_reg_control], FFCA                ; [3933: C7 06 11 00 CA FF]
    MOV     AH, 04                                           ; [3939: B4 04]
    CALL    sub_3b95                                         ; [393B: E8 57 02]
    MOV     DX, io_floppy_ctrl           ; Floppy Control register (Motor 0/1, Drive sel, DDEN) ; [393E: BA 88 02]
    MOV     AL, 42                                           ; [3941: B0 42]
    CMP     BYTE [var_boot_device_char], 00 ; NVRAM Byte 25 (0x19): Boot device parameter ('A'=Floppy, 'N'=Net) ; [3943: 80 3E 19 00 00]
    JZ      loc_394c                                         ; [3948: 74 02]
    MOV     AL, 45                                           ; [394A: B0 45]
loc_394c:
    OUT     DX, AL                                           ; [394C: EE]
    MOV     CX, FFFF                                         ; [394D: B9 FF FF]
loc_3950:
    PUSH    CX                                               ; [3950: 51]
    MOV     CX, 000A                                         ; [3951: B9 0A 00]
loc_3954:
    LOOP    loc_3954                                         ; [3954: E2 FE]
    POP     CX                                               ; [3956: 59]
    LOOP    loc_3950                                         ; [3957: E2 F7]
    MOV     DX, io_wd2797_status_cmd     ; WD2797 FDC Status / Command register ; [3959: BA 80 02]
    IN      AL, DX                                           ; [395C: EC]
    AND     AL, 80                                           ; [395D: 24 80]
    JZ      loc_397b                                         ; [395F: 74 1A]
    MOV     AX, 3001                                         ; [3961: B8 01 30]
    CALL    set_cursor_pos                                   ; [3964: E8 12 C9]
    MOV     AX, 31AF                                         ; [3967: B8 AF 31]
    MOV     CX, 000F                                         ; [396A: B9 0F 00]
    CALL    print_string_es_ax                               ; [396D: E8 3C CA]
    MOV     DX, io_wd2797_status_cmd     ; WD2797 FDC Status / Command register ; [3970: BA 80 02]
loc_3973:
    IN      AL, DX                                           ; [3973: EC]
    AND     AL, 80                                           ; [3974: 24 80]
    JNZ     loc_3973                                         ; [3976: 75 FB]
    CALL    fdc_motor_off                                    ; [3978: E8 92 03]
loc_397b:
    CALL    fdc_wait_ready_timeout                           ; [397B: E8 7E 00]
    JC      loc_39c0                                         ; [397E: 72 40]
    MOV     AX, DS                                           ; [3980: 8C D8]
    MOV     BX, 00B5                                         ; [3982: BB B5 00]
    CALL    fdc_compute_geometry                             ; [3985: E8 1A 02]
    MOV     BX, 0400                                         ; [3988: BB 00 04]
    MOV     AL, 8C                                           ; [398B: B0 8C]
    CALL    fdc_read_sector_dma                              ; [398D: E8 C5 00]
    JC      loc_39c0                                         ; [3990: 72 2E]
    CALL    sub_3af4                                         ; [3992: E8 5F 01]
    MOV     AX, [var_screen_page_offset]                     ; [3995: A1 D4 00]
    SHR     AX, 1                                            ; [3998: D1 E8]
    MOV     [ES:var_floppy_last_seek], AX                    ; [399A: 26 A3 75 00]
    MOV     AX, [ES:var_floppy_buffer_ptr]                   ; [399E: 26 A1 6D 00]
    PUSH    AX                                               ; [39A2: 50]
    MOV     CX, 0002                                         ; [39A3: B9 02 00]
    MUL     CX                                               ; [39A6: F7 E1]
    XOR     DX, DX                                           ; [39A8: 33 D2]
    DIV     WORD [ES:var_floppy_sectors_per_trk]             ; [39AA: 26 F7 36 7A 00]
    MOV     [ES:var_floppy_gap_length], AX                   ; [39AF: 26 A3 7C 00]
    POP     AX                                               ; [39B3: 58]
    XOR     DX, DX                                           ; [39B4: 33 D2]
    DIV     WORD [ES:var_floppy_sectors_per_trk]             ; [39B6: 26 F7 36 7A 00]
    MOV     [ES:var_nvram_boot_default], AX                  ; [39BB: 26 A3 80 00]
    CLC                                                      ; [39BF: F8]
loc_39c0:
    MOV     BYTE [ram_segment_base], 02                      ; [39C0: C6 06 02 00 02]
    RETN                                                     ; [39C5: C3]
sub_39c6:
    MOV     DX, io_floppy_ctrl           ; Floppy Control register (Motor 0/1, Drive sel, DDEN) ; [39C6: BA 88 02]
    MOV     AL, 40                                           ; [39C9: B0 40]
    OUT     DX, AL                                           ; [39CB: EE]
    PUSH    ES                                               ; [39CC: 06]
    PUSH    DS                                               ; [39CD: 1E]
    MOV     AX, LAN_BUFFER_SEGMENT                           ; [39CE: B8 00 36]
    MOV     DS, AX                                           ; [39D1: 8E D8]
    XOR     AX, AX                                           ; [39D3: 33 C0]
    MOV     ES, AX                                           ; [39D5: 8E C0]
    MOV     AL, [ES:var_boot_drive_preselect] ; Boot drive preselection buffer ('A', 'B', etc.) ; [39D7: 26 A0 67 00]
    CMP     AL, 41                                           ; [39DB: 3C 41]
    JZ      loc_39f9                                         ; [39DD: 74 1A]
    CMP     AL, 42                                           ; [39DF: 3C 42]
    JZ      loc_39f9                                         ; [39E1: 74 16]
    CMP     AL, 00                                           ; [39E3: 3C 00]
    JNZ     loc_39f5                                         ; [39E5: 75 0E]
    MOV     AH, 00                                           ; [39E7: B4 00]
    MOV     AL, 19                                           ; [39E9: B0 19]
    CALL    nvram_read_byte_al                               ; [39EB: E8 CC 01]
    CALL    validate_boot_device_char                        ; [39EE: E8 AD FE]
    AND     AL, 0E                                           ; [39F1: 24 0E]
    JZ      loc_39f9                                         ; [39F3: 74 04]
loc_39f5:
    MOV     DX, io_floppy_release        ; Floppy Release register ; [39F5: BA 90 02]
    OUT     DX, AL                                           ; [39F8: EE]
loc_39f9:
    POP     DS                                               ; [39F9: 1F]
    POP     ES                                               ; [39FA: 07]
    RETN                                                     ; [39FB: C3]

; ----------------------------------------------------------------------------
; fdc_wait_ready_timeout (ROM: 723Ch, FB84:39FCh)
; ----------------------------------------------------------------------------
fdc_wait_ready_timeout:
    MOV     CX, 0005                                         ; [39FC: B9 05 00]
loc_39ff:
    PUSH    DX                                               ; [39FF: 52]
    PUSH    CX                                               ; [3A00: 51]
    MOV     AL, 00                                           ; [3A01: B0 00]
    MOV     DX, io_wd2797_status_cmd     ; WD2797 FDC Status / Command register ; [3A03: BA 80 02]
    OUT     DX, AL                                           ; [3A06: EE]
    CALL    sub_3a91                                         ; [3A07: E8 87 00]
    POP     CX                                               ; [3A0A: 59]
    POP     DX                                               ; [3A0B: 5A]
    TEST    AL, 04                                           ; [3A0C: A8 04]
    JZ      loc_3a12                                         ; [3A0E: 74 02]
    CLC                                                      ; [3A10: F8]
    RETN                                                     ; [3A11: C3]
loc_3a12:
    PUSH    CX                                               ; [3A12: 51]
    MOV     CX, 0009                                         ; [3A13: B9 09 00]
loc_3a16:
    LOOP    loc_3a16                                         ; [3A16: E2 FE]
    POP     CX                                               ; [3A18: 59]
    LOOP    loc_39ff                                         ; [3A19: E2 E4]
    STC                                                      ; [3A1B: F9]
    RETN                                                     ; [3A1C: C3]
sub_3a1d:
    MOV     CX, 0005                                         ; [3A1D: B9 05 00]
    PUSH    DX                                               ; [3A20: 52]
    MOV     DX, io_wd2797_track          ; WD2797 FDC Track register ; [3A21: BA 82 02]
    IN      AL, DX                                           ; [3A24: EC]
    CMP     AL, BYTE [rom_segment_base]                      ; [3A25: 3A 06 00 00]
    POP     DX                                               ; [3A29: 5A]
    JNZ     loc_3a2e                                         ; [3A2A: 75 02]
    CLC                                                      ; [3A2C: F8]
    RETN                                                     ; [3A2D: C3]
loc_3a2e:
    PUSH    DX                                               ; [3A2E: 52]
    PUSH    CX                                               ; [3A2F: 51]
    MOV     AL, [rom_segment_base]                           ; [3A30: A0 00 00]
    MOV     DX, io_wd2797_data           ; WD2797 FDC Data register ; [3A33: BA 86 02]
    OUT     DX, AL                                           ; [3A36: EE]
    MOV     AL, 1C                                           ; [3A37: B0 1C]
    MOV     DX, io_wd2797_status_cmd     ; WD2797 FDC Status / Command register ; [3A39: BA 80 02]
    OUT     DX, AL                                           ; [3A3C: EE]
    CALL    sub_3a91                                         ; [3A3D: E8 51 00]
    POP     CX                                               ; [3A40: 59]
    POP     DX                                               ; [3A41: 5A]
    TEST    AL, 99                                           ; [3A42: A8 99]
    JZ      loc_3a53                                         ; [3A44: 74 0D]
    PUSH    CX                                               ; [3A46: 51]
    PUSH    AX                                               ; [3A47: 50]
    CALL    fdc_wait_ready_timeout                           ; [3A48: E8 B1 FF]
    POP     AX                                               ; [3A4B: 58]
    POP     CX                                               ; [3A4C: 59]
    JC      loc_3a51                                         ; [3A4D: 72 02]
    LOOP    loc_3a2e                                         ; [3A4F: E2 DD]
loc_3a51:
    STC                                                      ; [3A51: F9]
    RETN                                                     ; [3A52: C3]
loc_3a53:
    CLC                                                      ; [3A53: F8]
    RETN                                                     ; [3A54: C3]

; ----------------------------------------------------------------------------
; fdc_read_sector_dma (ROM: 7295h, FB84:3A55h)
; ----------------------------------------------------------------------------
fdc_read_sector_dma:
    MOV     CX, 000A                                         ; [3A55: B9 0A 00]
    MOV     [var_dma0_channel_id], AL                        ; [3A58: A2 03 00]
loc_3a5b:
    PUSH    DX                                               ; [3A5B: 52]
    PUSH    CX                                               ; [3A5C: 51]
    MOV     AX, 0286                                         ; [3A5D: B8 86 02]
    MOV     CX, BX                                           ; [3A60: 8B CB]
    CALL    sub_3b63                                         ; [3A62: E8 FE 00]
    MOV     DX, io_wd2797_sector         ; WD2797 FDC Sector register ; [3A65: BA 84 02]
    MOV     AL, [ram_segment_base]                           ; [3A68: A0 02 00]
    OUT     DX, AL                                           ; [3A6B: EE]
    MOV     DX, io_wd2797_status_cmd     ; WD2797 FDC Status / Command register ; [3A6C: BA 80 02]
    MOV     AL, [var_dma0_channel_id]                        ; [3A6F: A0 03 00]
    OUT     DX, AL                                           ; [3A72: EE]
    CALL    sub_3ac3                                         ; [3A73: E8 4D 00]
    POP     CX                                               ; [3A76: 59]
    POP     DX                                               ; [3A77: 5A]
    TEST    AL, 10                                           ; [3A78: A8 10]
    JZ      loc_3a87                                         ; [3A7A: 74 0B]
    PUSH    AX                                               ; [3A7C: 50]
    MOV     DX, WORD [var_dma0_reg_count]                    ; [3A7D: 8B 16 0F 00]
    IN      AX, DX                                           ; [3A81: ED]
    OR      AX, AX                                           ; [3A82: 0B C0]
    POP     AX                                               ; [3A84: 58]
    JNZ     loc_3a8b                                         ; [3A85: 75 04]
loc_3a87:
    TEST    AL, 8F                                           ; [3A87: A8 8F]
    JZ      loc_3a8f                                         ; [3A89: 74 04]
loc_3a8b:
    LOOP    loc_3a5b                                         ; [3A8B: E2 CE]
    STC                                                      ; [3A8D: F9]
    RETN                                                     ; [3A8E: C3]
loc_3a8f:
    CLC                                                      ; [3A8F: F8]
    RETN                                                     ; [3A90: C3]
sub_3a91:
    PUSH    CX                                               ; [3A91: 51]
    PUSH    DX                                               ; [3A92: 52]
    MOV     DX, io_wd2797_status_cmd     ; WD2797 FDC Status / Command register ; [3A93: BA 80 02]
    MOV     CX, 000B                                         ; [3A96: B9 0B 00]
loc_3a99:
    LOOP    loc_3a99                                         ; [3A99: E2 FE]
    MOV     CX, FFFF                                         ; [3A9B: B9 FF FF]
loc_3a9e:
    IN      AL, DX                                           ; [3A9E: EC]
    TEST    AL, 01                                           ; [3A9F: A8 01]
    JZ      loc_3ac0                                         ; [3AA1: 74 1D]
    LOOP    loc_3a9e                                         ; [3AA3: E2 F9]
    MOV     DX, io_wd2797_status_cmd     ; WD2797 FDC Status / Command register ; [3AA5: BA 80 02]
    MOV     AL, D8                                           ; [3AA8: B0 D8]
    OUT     DX, AL                                           ; [3AAA: EE]
    MOV     CX, 0009                                         ; [3AAB: B9 09 00]
loc_3aae:
    LOOP    loc_3aae                                         ; [3AAE: E2 FE]
    IN      AL, DX                                           ; [3AB0: EC]
    PUSH    AX                                               ; [3AB1: 50]
    MOV     CX, 0009                                         ; [3AB2: B9 09 00]
loc_3ab5:
    LOOP    loc_3ab5                                         ; [3AB5: E2 FE]
    MOV     AL, D0                                           ; [3AB7: B0 D0]
    OUT     DX, AL                                           ; [3AB9: EE]
    MOV     CX, 0009                                         ; [3ABA: B9 09 00]
loc_3abd:
    LOOP    loc_3abd                                         ; [3ABD: E2 FE]
    POP     AX                                               ; [3ABF: 58]
loc_3ac0:
    POP     DX                                               ; [3AC0: 5A]
    POP     CX                                               ; [3AC1: 59]
    RETN                                                     ; [3AC2: C3]
sub_3ac3:
    PUSH    CX                                               ; [3AC3: 51]
    PUSH    DX                                               ; [3AC4: 52]
    MOV     CX, 0009                                         ; [3AC5: B9 09 00]
loc_3ac8:
    LOOP    loc_3ac8                                         ; [3AC8: E2 FE]
loc_3aca:
    MOV     DX, io_wd2797_status_cmd     ; WD2797 FDC Status / Command register ; [3ACA: BA 80 02]
    IN      AL, DX                                           ; [3ACD: EC]
    TEST    AL, 01                                           ; [3ACE: A8 01]
    JZ      loc_3af1                                         ; [3AD0: 74 1F]
    MOV     DX, WORD [var_dma0_reg_count]                    ; [3AD2: 8B 16 0F 00]
    IN      AX, DX                                           ; [3AD6: ED]
    CMP     AX, 0000                                         ; [3AD7: 3D 00 00]
    JNZ     loc_3aca                                         ; [3ADA: 75 EE]
    MOV     DX, io_wd2797_status_cmd     ; WD2797 FDC Status / Command register ; [3ADC: BA 80 02]
    MOV     AL, D8                                           ; [3ADF: B0 D8]
    OUT     DX, AL                                           ; [3AE1: EE]
    MOV     CX, 0009                                         ; [3AE2: B9 09 00]
loc_3ae5:
    LOOP    loc_3ae5                                         ; [3AE5: E2 FE]
    MOV     AL, D0                                           ; [3AE7: B0 D0]
    OUT     DX, AL                                           ; [3AE9: EE]
    MOV     CX, 0009                                         ; [3AEA: B9 09 00]
loc_3aed:
    LOOP    loc_3aed                                         ; [3AED: E2 FE]
    XOR     AX, AX                                           ; [3AEF: 33 C0]
loc_3af1:
    POP     DX                                               ; [3AF1: 5A]
    POP     CX                                               ; [3AF2: 59]
    RETN                                                     ; [3AF3: C3]
sub_3af4:
    MOV     AX, 0001                                         ; [3AF4: B8 01 00]
    MOV     CL, BYTE [var_screen_line_wrap]                  ; [3AF7: 8A 0E D6 00]
    SHL     AX, CL                                           ; [3AFB: D3 E0]
    MOV     CX, 0080                                         ; [3AFD: B9 80 00]
    MUL     CX                                               ; [3B00: F7 E1]
    MOV     [ES:var_floppy_sector_num], AX                   ; [3B02: 26 A3 6B 00]
    MOV     CX, WORD [var_screen_tab_stop]                   ; [3B06: 8B 0E C7 00]
    MOV     BYTE [ES:var_floppy_drive_type], CL              ; [3B0A: 26 88 0E 6A 00]
    MUL     CX                                               ; [3B0F: F7 E1]
    MOV     [ES:var_floppy_buffer_ptr], AX                   ; [3B11: 26 A3 6D 00]
    MOV     AX, 0001                                         ; [3B15: B8 01 00]
    MOV     CL, BYTE [var_screen_bell_duration]              ; [3B18: 8A 0E C9 00]
    SHL     AX, CL                                           ; [3B1C: D3 E0]
    MOV     CX, 0080                                         ; [3B1E: B9 80 00]
    MUL     CX                                               ; [3B21: F7 E1]
    MOV     [ES:var_floppy_sectors_per_trk], AX              ; [3B23: 26 A3 7A 00]
    MOV     AX, [var_screen_char_temp]                       ; [3B27: A1 CE 00]
    INC     AX                                               ; [3B2A: 40]
    MOV     [ES:var_floppy_head_num], AX                     ; [3B2B: 26 A3 6F 00]
    MOV     CX, 0020                                         ; [3B2F: B9 20 00]
    MUL     CX                                               ; [3B32: F7 E1]
    MOV     [ES:var_floppy_track_num], AX                    ; [3B34: 26 A3 73 00]
    MOV     DX, io_pic_icw1              ; 8259A PIC ICW1 (Base port 00h) ; [3B38: BA 00 00]
    MOV     CX, WORD [ES:var_floppy_sector_num]              ; [3B3B: 26 8B 0E 6B 00]
    DIV     CX                                               ; [3B40: F7 F1]
    CMP     DX, +00                                          ; [3B42: 83 FA 00]
    JZ      loc_3b48                                         ; [3B45: 74 01]
    INC     AX                                               ; [3B47: 40]
loc_3b48:
    MOV     [ES:var_floppy_media_density], AX                ; [3B48: 26 A3 71 00]
    MOV     AL, [var_screen_esc_state]                       ; [3B4C: A0 CB 00]
    MOV     [ES:var_floppy_bytes_per_sec], AL                ; [3B4F: 26 A2 79 00]
    MOV     AX, [ES:var_floppy_sectors_per_trk]              ; [3B53: 26 A1 7A 00]
    XOR     DX, DX                                           ; [3B57: 33 D2]
    DIV     WORD [ES:var_floppy_sector_num]                  ; [3B59: 26 F7 36 6B 00]
    MOV     [ES:var_floppy_data_length], AX                  ; [3B5E: 26 A3 7E 00]
    RETN                                                     ; [3B62: C3]
sub_3b63:
    PUSH    DX                                               ; [3B63: 52]
    PUSH    CX                                               ; [3B64: 51]
    PUSH    AX                                               ; [3B65: 50]
    MOV     DX, WORD [var_dma0_reg_dest_lo]                  ; [3B66: 8B 16 09 00]
    MOV     AX, [var_dma0_byte_count]                        ; [3B6A: A1 04 00]
    OUT     DX, AX                                           ; [3B6D: EF]
    MOV     DX, WORD [var_dma0_reg_dest_hi]                  ; [3B6E: 8B 16 07 00]
    XOR     AH, AH                                           ; [3B72: 32 E4]
    MOV     AL, [var_dma0_mode_flags]                        ; [3B74: A0 06 00]
    OUT     DX, AX                                           ; [3B77: EF]
    MOV     DX, WORD [var_dma0_reg_src_lo]                   ; [3B78: 8B 16 0D 00]
    POP     AX                                               ; [3B7C: 58]
    OUT     DX, AX                                           ; [3B7D: EF]
    XOR     AX, AX                                           ; [3B7E: 33 C0]
    MOV     DX, WORD [var_dma0_reg_src_hi]                   ; [3B80: 8B 16 0B 00]
    OUT     DX, AX                                           ; [3B84: EF]
    MOV     DX, WORD [var_dma0_reg_count]                    ; [3B85: 8B 16 0F 00]
    POP     AX                                               ; [3B89: 58]
    OUT     DX, AX                                           ; [3B8A: EF]
    MOV     DX, WORD [var_dma0_reg_control]                  ; [3B8B: 8B 16 11 00]
    MOV     AX, AE66                                         ; [3B8F: B8 66 AE]
    OUT     DX, AX                                           ; [3B92: EF]
    POP     DX                                               ; [3B93: 5A]
    RETN                                                     ; [3B94: C3]
sub_3b95:
    PUSH    CX                                               ; [3B95: 51]
    MOV     CH, F3                                           ; [3B96: B5 F3]
    IN      AL, io_ppi_portc             ; 8255 PPI Port C (Kbd enable, Gfx mode, NVRAM bank) ; [3B98: E4 74]
    AND     AL, CH                                           ; [3B9A: 22 C5]
    OR      AL, AH                                           ; [3B9C: 0A C4]
    OUT     io_ppi_portc, AL             ; 8255 PPI Port C (Kbd enable, Gfx mode, NVRAM bank) ; [3B9E: E6 74]
    POP     CX                                               ; [3BA0: 59]
    RETN                                                     ; [3BA1: C3]

; ----------------------------------------------------------------------------
; fdc_compute_geometry (ROM: 73E2h, FB84:3BA2h)
; ----------------------------------------------------------------------------
fdc_compute_geometry:
    MOV     CL, 04                                           ; [3BA2: B1 04]
    ROL     AX, CL                                           ; [3BA4: D3 C0]
    MOV     CH, AL                                           ; [3BA6: 8A E8]
    AND     AL, F0                                           ; [3BA8: 24 F0]
    ADD     AX, BX                                           ; [3BAA: 03 C3]
    ADC     CH, 00                                           ; [3BAC: 80 D5 00]
    AND     CH, 0F                                           ; [3BAF: 80 E5 0F]
    MOV     [var_dma0_byte_count], AX                        ; [3BB2: A3 04 00]
    MOV     BYTE [var_dma0_mode_flags], CH                   ; [3BB5: 88 2E 06 00]
    RETN                                                     ; [3BB9: C3]

; ----------------------------------------------------------------------------
; nvram_read_byte_al (ROM: 73FAh, FB84:3BBAh)
; ----------------------------------------------------------------------------
nvram_read_byte_al:
    PUSH    DX                                               ; [3BBA: 52]
    PUSH    CX                                               ; [3BBB: 51]
    PUSH    AX                                               ; [3BBC: 50]
    CALL    sub_3bde                                         ; [3BBD: E8 1E 00]
    MOV     DX, io_nvram_base            ; NVRAM start (128 bytes bank-switched, 80h-FFh) ; [3BC0: BA 80 00]
    POP     AX                                               ; [3BC3: 58]
    SHL     AL, 1                                            ; [3BC4: D0 E0]
    SHL     AL, 1                                            ; [3BC6: D0 E0]
    XOR     AH, AH                                           ; [3BC8: 32 E4]
    ADD     DX, AX                                           ; [3BCA: 03 D0]
    IN      AL, DX                                           ; [3BCC: EC]
    ADD     DX, +02                                          ; [3BCD: 83 C2 02]
    XCHG    AL, AH                                           ; [3BD0: 86 E0]
    IN      AL, DX                                           ; [3BD2: EC]
    MOV     CL, 04                                           ; [3BD3: B1 04]
    SHL     AH, CL                                           ; [3BD5: D2 E4]
    AND     AL, 0F                                           ; [3BD7: 24 0F]
    OR      AL, AH                                           ; [3BD9: 0A C4]
    POP     CX                                               ; [3BDB: 59]
    POP     DX                                               ; [3BDC: 5A]
    RETN                                                     ; [3BDD: C3]
sub_3bde:
    MOV     DX, io_ppi_portc             ; 8255 PPI Port C (Kbd enable, Gfx mode, NVRAM bank) ; [3BDE: BA 74 00]
    IN      AL, DX                                           ; [3BE1: EC]
    AND     AL, CF                                           ; [3BE2: 24 CF]
    MOV     CL, 04                                           ; [3BE4: B1 04]
    SHL     AH, CL                                           ; [3BE6: D2 E4]
    OR      AL, AH                                           ; [3BE8: 0A C4]
    OUT     DX, AL                                           ; [3BEA: EE]
    RETN                                                     ; [3BEB: C3]

; ----------------------------------------------------------------------------
; nvram_write_byte_al (ROM: 742Ch, FB84:3BECh)
; ----------------------------------------------------------------------------
nvram_write_byte_al:
    CLI                                                      ; [3BEC: FA]
    MOV     DX, io_pic_icw2_ocw          ; 8259A PIC ICW2/OCW (Base vector 20h) ; [3BED: BA 02 00]
    MOV     AL, FD                                           ; [3BF0: B0 FD]
    OUT     DX, AL                                           ; [3BF2: EE]
    MOV     DX, io_i186_eoi              ; 80186 INTC End-Of-Interrupt (EOI) register ; [3BF3: BA 22 FF]
    MOV     AX, 8000                                         ; [3BF6: B8 00 80]
    OUT     DX, AX                                           ; [3BF9: EF]
    STI                                                      ; [3BFA: FB]
    MOV     AX, 0202                                         ; [3BFB: B8 02 02]
    CALL    set_cursor_pos                                   ; [3BFE: E8 78 C6]
    MOV     CX, 0032                                         ; [3C01: B9 32 00]
    MOV     AL, 20                                           ; [3C04: B0 20]
loc_3c06:
    CALL    conout_char                                      ; [3C06: E8 8F C6]
    LOOP    loc_3c06                                         ; [3C09: E2 FB]
    MOV     AX, 0202                                         ; [3C0B: B8 02 02]
    CALL    set_cursor_pos                                   ; [3C0E: E8 68 C6]
    MOV     CX, FFFF                                         ; [3C11: B9 FF FF]
    MOV     AX, 31E2                                         ; [3C14: B8 E2 31]
    CALL    print_string_es_ax                               ; [3C17: E8 92 C7]
    CALL    sub_3cb9                                         ; [3C1A: E8 9C 00]
    MOV     BX, 0015                                         ; [3C1D: BB 15 00]
    XOR     SI, SI                                           ; [3C20: 33 F6]
    MOV     CX, 0004                                         ; [3C22: B9 04 00]
loc_3c25:
    PUSH    CX                                               ; [3C25: 51]
    CMP     BYTE [BX], 00                                    ; [3C26: 80 3F 00]
    JZ      loc_3c2e                                         ; [3C29: 74 03]
    CALL    sub_3cc3                                         ; [3C2B: E8 95 00]
loc_3c2e:
    POP     CX                                               ; [3C2E: 59]
    INC     BX                                               ; [3C2F: 43]
    INC     SI                                               ; [3C30: 46]
    LOOP    loc_3c25                                         ; [3C31: E2 F2]
    XOR     AX, AX                                           ; [3C33: 33 C0]
    MOV     ES, AX                                           ; [3C35: 8E C0]
    CMP     BYTE [ES:var_boot_retry_counter], FF             ; [3C37: 26 80 3E 5D 00 FF]
    JNZ     loc_3c4b                                         ; [3C3D: 75 0C]
    MOV     SI, 0004                                         ; [3C3F: BE 04 00]
    CALL    sub_3cc3                                         ; [3C42: E8 7E 00]
    MOV     SI, 0006                                         ; [3C45: BE 06 00]
    CALL    sub_3cc3                                         ; [3C48: E8 78 00]
loc_3c4b:
    CALL    sub_2813                                         ; [3C4B: E8 C5 EB]
    JC      loc_3c56                                         ; [3C4E: 72 06]
    MOV     SI, 0004                                         ; [3C50: BE 04 00]
    CALL    sub_3cc3                                         ; [3C53: E8 6D 00]
loc_3c56:
    MOV     SI, 0007                                         ; [3C56: BE 07 00]
    CALL    sub_3cc3                                         ; [3C59: E8 67 00]
    MOV     SI, 0009                                         ; [3C5C: BE 09 00]
    CALL    sub_3cc3                                         ; [3C5F: E8 61 00]
    MOV     AX, 1402                                         ; [3C62: B8 02 14]
    CALL    set_cursor_pos                                   ; [3C65: E8 11 C6]
    MOV     AX, 3323                                         ; [3C68: B8 23 33]
    MOV     CX, 0008                                         ; [3C6B: B9 08 00]
    CALL    print_string_es_ax                               ; [3C6E: E8 3B C7]
    PUSH    AX                                               ; [3C71: 50]
loc_3c72:
    POP     AX                                               ; [3C72: 58]
    CALL    read_key_poll                                    ; [3C73: E8 5D C7]
    PUSH    AX                                               ; [3C76: 50]
    CMP     AL, 4E                                           ; [3C77: 3C 4E]
    JZ      loc_3ca8                                         ; [3C79: 74 2D]
    CMP     AL, 57                                           ; [3C7B: 3C 57]
    JZ      loc_3cb0                                         ; [3C7D: 74 31]
    CMP     AL, 4C                                           ; [3C7F: 3C 4C]
    JZ      loc_3cb0                                         ; [3C81: 74 2D]
    CMP     AL, 4B                                           ; [3C83: 3C 4B]
    JZ      loc_3cb0                                         ; [3C85: 74 29]
    CMP     AL, 4D                                           ; [3C87: 3C 4D]
    JZ      loc_3cb0                                         ; [3C89: 74 25]
    SUB     AL, 41                                           ; [3C8B: 2C 41]
    CMP     AL, 03                                           ; [3C8D: 3C 03]
    JG      loc_3c72                                         ; [3C8F: 7F E1]
    CMP     AL, 00                                           ; [3C91: 3C 00]
    JC      loc_3c72                                         ; [3C93: 72 DD]
    MOV     BX, 0015                                         ; [3C95: BB 15 00]
    XLAT                                                     ; [3C98: D7]
    CMP     AL, 00                                           ; [3C99: 3C 00]
    JZ      loc_3c72                                         ; [3C9B: 74 D5]
    POP     AX                                               ; [3C9D: 58]
    PUSH    AX                                               ; [3C9E: 50]
    CALL    conout_char                                      ; [3C9F: E8 F6 C5]
    POP     AX                                               ; [3CA2: 58]
    MOV     [ES:var_boot_drive_preselect], AL ; Boot drive preselection buffer ('A', 'B', etc.) ; [3CA3: 26 A2 67 00]
    RETN                                                     ; [3CA7: C3]
loc_3ca8:
    CMP     BYTE [ES:var_boot_retry_counter], FF             ; [3CA8: 26 80 3E 5D 00 FF]
    JNZ     loc_3c72                                         ; [3CAE: 75 C2]
loc_3cb0:
    CALL    conout_char                                      ; [3CB0: E8 E5 C5]
    POP     AX                                               ; [3CB3: 58]
    MOV     [ES:var_boot_drive_preselect], AL ; Boot drive preselection buffer ('A', 'B', etc.) ; [3CB4: 26 A2 67 00]
    RETN                                                     ; [3CB8: C3]
sub_3cb9:
    MOV     AX, 31F5                                         ; [3CB9: B8 F5 31]
    MOV     CX, FFFF                                         ; [3CBC: B9 FF FF]
    CALL    print_string_es_ax                               ; [3CBF: E8 EA C6]
    RETN                                                     ; [3CC2: C3]
sub_3cc3:
    PUSH    DS                                               ; [3CC3: 1E]
    PUSH    BX                                               ; [3CC4: 53]
    PUSH    AX                                               ; [3CC5: 50]
    PUSH    SI                                               ; [3CC6: 56]
    MOV     AX, ROM_DATA_SEGMENT                             ; [3CC7: B8 00 F8]
    MOV     DS, AX                                           ; [3CCA: 8E D8]
    SHL     SI, 1                                            ; [3CCC: D1 E6]
    MOV     BX, 31F7                                         ; [3CCE: BB F7 31]
    MOV     CX, FFFF                                         ; [3CD1: B9 FF FF]
    MOV     AX, WORD [BX+SI]                                 ; [3CD4: 8B 00]
    CALL    print_string_es_ax                               ; [3CD6: E8 D3 C6]
    CALL    sub_3cb9                                         ; [3CD9: E8 DD FF]
    POP     SI                                               ; [3CDC: 5E]
    POP     AX                                               ; [3CDD: 58]
    POP     BX                                               ; [3CDE: 5B]
    POP     DS                                               ; [3CDF: 1F]
    RETN                                                     ; [3CE0: C3]

; ----------------------------------------------------------------------------
; fdc_check_status (ROM: 7521h, FB84:3CE1h)
; ----------------------------------------------------------------------------
fdc_check_status:
    PUSH    AX                                               ; [3CE1: 50]
    PUSH    SI                                               ; [3CE2: 56]
    MOV     SI, 00B5                                         ; [3CE3: BE B5 00]
    CLD                                                      ; [3CE6: FC]
    LODSB                                                    ; [3CE7: AC]
    CMP     AL, 52                                           ; [3CE8: 3C 52]
    JNZ     loc_3d09                                         ; [3CEA: 75 1D]
    LODSB                                                    ; [3CEC: AC]
    CMP     AL, 43                                           ; [3CED: 3C 43]
    JNZ     loc_3d09                                         ; [3CEF: 75 18]
    LODSB                                                    ; [3CF1: AC]
    CMP     AL, 37                                           ; [3CF2: 3C 37]
    JNZ     loc_3d09                                         ; [3CF4: 75 13]
    LODSB                                                    ; [3CF6: AC]
    CMP     AL, 35                                           ; [3CF7: 3C 35]
    JNZ     loc_3d09                                         ; [3CF9: 75 0E]
    LODSB                                                    ; [3CFB: AC]
    CMP     AL, 39                                           ; [3CFC: 3C 39]
    JNZ     loc_3d09                                         ; [3CFE: 75 09]
    LODSB                                                    ; [3D00: AC]
    CMP     AL, 20                                           ; [3D01: 3C 20]
    JNZ     loc_3d09                                         ; [3D03: 75 04]
    POP     SI                                               ; [3D05: 5E]
    POP     AX                                               ; [3D06: 58]
    CLC                                                      ; [3D07: F8]
    RETN                                                     ; [3D08: C3]
loc_3d09:
    POP     SI                                               ; [3D09: 5E]
    POP     AX                                               ; [3D0A: 58]
    STC                                                      ; [3D0B: F9]
    RETN                                                     ; [3D0C: C3]

; ----------------------------------------------------------------------------
; fdc_motor_off (ROM: 754Dh, FB84:3D0Dh)
; ----------------------------------------------------------------------------
fdc_motor_off:
    PUSH    AX                                               ; [3D0D: 50]
    PUSH    CX                                               ; [3D0E: 51]
    MOV     AX, LAN_BUFFER_ALT_SEGMENT                       ; [3D0F: B8 00 30]
    CALL    set_cursor_pos                                   ; [3D12: E8 64 C5]
    MOV     CX, 0050                                         ; [3D15: B9 50 00]
loc_3d18:
    XOR     AX, AX                                           ; [3D18: 33 C0]
    MOV     AL, 20                                           ; [3D1A: B0 20]
    CALL    conout_char                                      ; [3D1C: E8 79 C5]
    LOOP    loc_3d18                                         ; [3D1F: E2 F7]
    POP     CX                                               ; [3D21: 59]
    POP     AX                                               ; [3D22: 58]
    RETN                                                     ; [3D23: C3]

; ----------------------------------------------------------------------------
; fdc_release_bus (ROM: 7564h, FB84:3D24h)
; ----------------------------------------------------------------------------
fdc_release_bus:
    PUSH    AX                                               ; [3D24: 50]
    PUSH    CX                                               ; [3D25: 51]
    MOV     AX, 0000                                         ; [3D26: B8 00 00]
    ADD     AX, 0100                                         ; [3D29: 05 00 01]
    CALL    set_cursor_pos                                   ; [3D2C: E8 4A C5]
    MOV     CX, 0780                                         ; [3D2F: B9 80 07]
    XOR     AX, AX                                           ; [3D32: 33 C0]
    MOV     AL, 20                                           ; [3D34: B0 20]
loc_3d36:
    CALL    conout_char                                      ; [3D36: E8 5F C5]
    LOOP    loc_3d36                                         ; [3D39: E2 FB]
    POP     CX                                               ; [3D3B: 59]
    POP     AX                                               ; [3D3C: 58]
    RETN                                                     ; [3D3D: C3]

; ----------------------------------------------------------------------------
; fdc_reserve_bus (ROM: 757Eh, FB84:3D3Eh)
; ----------------------------------------------------------------------------
fdc_reserve_bus:
    CMP     AL, 06                                           ; [3D3E: 3C 06]
    JNZ     loc_3d47                                         ; [3D40: 75 05]
    CMP     AL, 08                                           ; [3D42: 3C 08]
    JNZ     loc_3d47                                         ; [3D44: 75 01]
    RETN                                                     ; [3D46: C3]
loc_3d47:
    PUSH    DS                                               ; [3D47: 1E]
    PUSH    BX                                               ; [3D48: 53]
    PUSH    CX                                               ; [3D49: 51]
    PUSH    SI                                               ; [3D4A: 56]
    PUSH    AX                                               ; [3D4B: 50]
    MOV     AX, 0200                                         ; [3D4C: B8 00 02]
    CALL    set_cursor_pos                                   ; [3D4F: E8 27 C5]
    MOV     AX, 31D4                                         ; [3D52: B8 D4 31]
    MOV     CX, 000E                                         ; [3D55: B9 0E 00]
    CALL    print_string_es_ax                               ; [3D58: E8 51 C6]
    POP     SI                                               ; [3D5B: 5E]
    PUSH    SI                                               ; [3D5C: 56]
    MOV     AX, ROM_DATA_SEGMENT                             ; [3D5D: B8 00 F8]
    MOV     DS, AX                                           ; [3D60: 8E D8]
    MOV     BX, 31F7                                         ; [3D62: BB F7 31]
    SHL     SI, 1                                            ; [3D65: D1 E6]
    MOV     AX, WORD [BX+SI]                                 ; [3D67: 8B 00]
    CMP     AX, 0000                                         ; [3D69: 3D 00 00]
    JZ      loc_3d77                                         ; [3D6C: 74 09]
    ADD     AX, 0003                                         ; [3D6E: 05 03 00]
    MOV     CX, FFFF                                         ; [3D71: B9 FF FF]
    CALL    print_string_es_ax                               ; [3D74: E8 35 C6]
loc_3d77:
    POP     AX                                               ; [3D77: 58]
    POP     SI                                               ; [3D78: 5E]
    POP     CX                                               ; [3D79: 59]
    POP     BX                                               ; [3D7A: 5B]
    POP     DS                                               ; [3D7B: 1F]
    RETN                                                     ; [3D7C: C3]
sub_3d7d:
    MOV     CX, 0040                                         ; [3D7D: B9 40 00]
    MOV     BX, 648D                                         ; [3D80: BB 8D 64]
    XOR     AX, AX                                           ; [3D83: 33 C0]
loc_3d85:
    CMP     CX, +20                                          ; [3D85: 83 F9 20]
    JNZ     loc_3d8e                                         ; [3D88: 75 04]
    MOV     AH, 01                                           ; [3D8A: B4 01]
    XOR     AL, AL                                           ; [3D8C: 32 C0]
loc_3d8e:
    PUSHA                                                    ; [3D8E: 60]
    CALL    nvram_read_byte_al                               ; [3D8F: E8 28 FE]
    MOV     BYTE [BX], AL                                    ; [3D92: 88 07]
    POPA                                                     ; [3D94: 61]
    INC     BX                                               ; [3D95: 43]
    INC     AX                                               ; [3D96: 40]
    LOOP    loc_3d85                                         ; [3D97: E2 EC]
    RETN                                                     ; [3D99: C3]
sub_3d9a:
    MOV     CX, 003F                                         ; [3D9A: B9 3F 00]
    MOV     BX, 648E                                         ; [3D9D: BB 8E 64]
    XOR     AX, AX                                           ; [3DA0: 33 C0]
    INC     AL                                               ; [3DA2: FE C0]
loc_3da4:
    CMP     CX, +20                                          ; [3DA4: 83 F9 20]
    JNZ     loc_3dad                                         ; [3DA7: 75 04]
    MOV     AH, 01                                           ; [3DA9: B4 01]
    XOR     AL, AL                                           ; [3DAB: 32 C0]
loc_3dad:
    PUSHA                                                    ; [3DAD: 60]
    MOV     CL, BYTE [BX]                                    ; [3DAE: 8A 0F]
    CALL    boot_setup_memory_params                         ; [3DB0: E8 88 00]
    POPA                                                     ; [3DB3: 61]
    INC     BX                                               ; [3DB4: 43]
    INC     AL                                               ; [3DB5: FE C0]
    LOOP    loc_3da4                                         ; [3DB7: E2 EB]
    RETN                                                     ; [3DB9: C3]
sub_3dba:
    PUSH    AX                                               ; [3DBA: 50]
    MOV     AX, 0000                                         ; [3DBB: B8 00 00]
    MOV     BL, 00                                           ; [3DBE: B3 00]
    MOV     BH, 03                                           ; [3DC0: B7 03]
    MOV     CX, 0020                                         ; [3DC2: B9 20 00]
loc_3dc5:
    PUSH    AX                                               ; [3DC5: 50]
    CALL    nvram_read_byte_al                               ; [3DC6: E8 F1 FD]
    ADD     BL, AL                                           ; [3DC9: 02 D8]
    POP     AX                                               ; [3DCB: 58]
    INC     AL                                               ; [3DCC: FE C0]
    LOOP    loc_3dc5                                         ; [3DCE: E2 F5]
    INC     AH                                               ; [3DD0: FE C4]
    XOR     AL, AL                                           ; [3DD2: 32 C0]
    MOV     CX, 0020                                         ; [3DD4: B9 20 00]
    DEC     BH                                               ; [3DD7: FE CF]
    JNZ     loc_3dc5                                         ; [3DD9: 75 EA]
    CMP     BL, AA                                           ; [3DDB: 80 FB AA]
    JZ      loc_3de3                                         ; [3DDE: 74 03]
    STC                                                      ; [3DE0: F9]
    POP     AX                                               ; [3DE1: 58]
    RETN                                                     ; [3DE2: C3]
loc_3de3:
    CLC                                                      ; [3DE3: F8]
    POP     AX                                               ; [3DE4: 58]
    RETN                                                     ; [3DE5: C3]
sub_3de6:
    MOV     CX, 003F                                         ; [3DE6: B9 3F 00]
    MOV     DX, 648E                                         ; [3DE9: BA 8E 64]
    MOV     BX, 350C                                         ; [3DEC: BB 0C 35]
loc_3def:
    MOV     AX, WORD [ES:BX]                                 ; [3DEF: 26 8B 07]
    PUSH    BX                                               ; [3DF2: 53]
    MOV     BX, DX                                           ; [3DF3: 8B DA]
    MOV     WORD [BX], AX                                    ; [3DF5: 89 07]
    POP     BX                                               ; [3DF7: 5B]
    INC     DX                                               ; [3DF8: 42]
    INC     BX                                               ; [3DF9: 43]
    LOOP    loc_3def                                         ; [3DFA: E2 F3]
    RETN                                                     ; [3DFC: C3]
sub_3dfd:
    XOR     AH, AH                                           ; [3DFD: 32 E4]
    CALL    sub_3bde                                         ; [3DFF: E8 DC FD]
    CALL    sub_3e2c                                         ; [3E02: E8 27 00]
    MOV     AH, 01                                           ; [3E05: B4 01]
    CALL    sub_3bde                                         ; [3E07: E8 D4 FD]
    CALL    sub_3e2c                                         ; [3E0A: E8 1F 00]
    MOV     AH, 02                                           ; [3E0D: B4 02]
    CALL    sub_3bde                                         ; [3E0F: E8 CC FD]
    CALL    sub_3e2c                                         ; [3E12: E8 17 00]
    MOV     AH, 03                                           ; [3E15: B4 03]
    CALL    sub_3bde                                         ; [3E17: E8 C4 FD]
    CALL    sub_3e2c                                         ; [3E1A: E8 0F 00]
    XOR     AH, AH                                           ; [3E1D: 32 E4]
    CALL    sub_3bde                                         ; [3E1F: E8 BC FD]
    MOV     DX, io_nvram_base            ; NVRAM start (128 bytes bank-switched, 80h-FFh) ; [3E22: BA 80 00]
    MOV     AL, 0A                                           ; [3E25: B0 0A]
    OUT     DX, AL                                           ; [3E27: EE]
    INC     DX                                               ; [3E28: 42]
    INC     DX                                               ; [3E29: 42]
    OUT     DX, AL                                           ; [3E2A: EE]
    RETN                                                     ; [3E2B: C3]
sub_3e2c:
    MOV     DX, io_nvram_base            ; NVRAM start (128 bytes bank-switched, 80h-FFh) ; [3E2C: BA 80 00]
    XOR     AL, AL                                           ; [3E2F: 32 C0]
    MOV     CX, 0040                                         ; [3E31: B9 40 00]
loc_3e34:
    OUT     DX, AL                                           ; [3E34: EE]
    ADD     DX, +02                                          ; [3E35: 83 C2 02]
    LOOP    loc_3e34                                         ; [3E38: E2 FA]
    RETN                                                     ; [3E3A: C3]

; ----------------------------------------------------------------------------
; boot_setup_memory_params (ROM: 767Bh, FB84:3E3Bh)
; ----------------------------------------------------------------------------
boot_setup_memory_params:
    PUSH    DX                                               ; [3E3B: 52]
    PUSH    BX                                               ; [3E3C: 53]
    PUSH    CX                                               ; [3E3D: 51]
    PUSH    AX                                               ; [3E3E: 50]
    CALL    nvram_read_byte_al                               ; [3E3F: E8 78 FD]
    MOV     BL, AL                                           ; [3E42: 8A D8]
    MOV     AH, 00                                           ; [3E44: B4 00]
    MOV     AL, 00                                           ; [3E46: B0 00]
    CALL    nvram_read_byte_al                               ; [3E48: E8 6F FD]
    MOV     BH, AL                                           ; [3E4B: 8A F8]
    POP     AX                                               ; [3E4D: 58]
    PUSH    AX                                               ; [3E4E: 50]
    CALL    sub_3bde                                         ; [3E4F: E8 8C FD]
    POP     AX                                               ; [3E52: 58]
    MOV     DX, io_nvram_base            ; NVRAM start (128 bytes bank-switched, 80h-FFh) ; [3E53: BA 80 00]
    SHL     AL, 1                                            ; [3E56: D0 E0]
    SHL     AL, 1                                            ; [3E58: D0 E0]
    XOR     AH, AH                                           ; [3E5A: 32 E4]
    ADD     DX, AX                                           ; [3E5C: 03 D0]
    POP     CX                                               ; [3E5E: 59]
    PUSH    CX                                               ; [3E5F: 51]
    MOV     AL, CL                                           ; [3E60: 8A C1]
    MOV     CL, 04                                           ; [3E62: B1 04]
    SHR     AL, CL                                           ; [3E64: D2 E8]
    OUT     DX, AL                                           ; [3E66: EE]
    POP     CX                                               ; [3E67: 59]
    MOV     AL, CL                                           ; [3E68: 8A C1]
    AND     AL, 0F                                           ; [3E6A: 24 0F]
    ADD     DX, +02                                          ; [3E6C: 83 C2 02]
    OUT     DX, AL                                           ; [3E6F: EE]
    SUB     BL, CL                                           ; [3E70: 2A D9]
    ADD     BH, BL                                           ; [3E72: 02 FB]
    MOV     AH, 00                                           ; [3E74: B4 00]
    CALL    sub_3bde                                         ; [3E76: E8 65 FD]
    MOV     DX, io_nvram_base            ; NVRAM start (128 bytes bank-switched, 80h-FFh) ; [3E79: BA 80 00]
    MOV     AL, BH                                           ; [3E7C: 8A C7]
    MOV     CL, 04                                           ; [3E7E: B1 04]
    SHR     AL, CL                                           ; [3E80: D2 E8]
    OUT     DX, AL                                           ; [3E82: EE]
    MOV     AL, BH                                           ; [3E83: 8A C7]
    AND     AL, 0F                                           ; [3E85: 24 0F]
    ADD     DX, +02                                          ; [3E87: 83 C2 02]
    OUT     DX, AL                                           ; [3E8A: EE]
    POP     BX                                               ; [3E8B: 5B]
    POP     DX                                               ; [3E8C: 5A]
    RETN                                                     ; [3E8D: C3]
sub_3e8e:
    CALL    fdc_release_bus                                  ; [3E8E: E8 93 FE]
    MOV     AX, 0000                                         ; [3E91: B8 00 00]
    CALL    set_cursor_pos                                   ; [3E94: E8 E2 C3]
    MOV     AX, 317A                                         ; [3E97: B8 7A 31]
    MOV     CX, FFFF                                         ; [3E9A: B9 FF FF]
    CALL    print_string_es_ax                               ; [3E9D: E8 0C C5]
    MOV     AX, 0200                                         ; [3EA0: B8 00 02]
    MOV     [var_fdc_transfer_len], AX                       ; [3EA3: A3 88 64]
    CALL    set_cursor_pos                                   ; [3EA6: E8 D0 C3]
    MOV     AX, 37E0                                         ; [3EA9: B8 E0 37]
    MOV     CX, FFFF                                         ; [3EAC: B9 FF FF]
    CALL    print_string_es_ax                               ; [3EAF: E8 FA C4]
    ADD     WORD [var_fdc_transfer_len], 0200                ; [3EB2: 81 06 88 64 00 02]
    MOV     DI, 354B                                         ; [3EB8: BF 4B 35]
    CMP     BYTE [var_fdc_drive_unit], 00                    ; [3EBB: 80 3E 8C 64 00]
    JZ      loc_3ec5                                         ; [3EC0: 74 03]
    MOV     DI, 2F8D                                         ; [3EC2: BF 8D 2F]
loc_3ec5:
    MOV     AX, [var_fdc_transfer_len]                       ; [3EC5: A1 88 64]
    CALL    set_cursor_pos                                   ; [3EC8: E8 AE C3]
    CMP     BYTE [ES:DI], FF                                 ; [3ECB: 26 80 3D FF]
    JZ      loc_3f0a                                         ; [3ECF: 74 39]
    MOV     AX, DI                                           ; [3ED1: 8B C7]
    MOV     CX, FFFF                                         ; [3ED3: B9 FF FF]
    ADD     AX, 0002                                         ; [3ED6: 05 02 00]
    PUSH    DI                                               ; [3ED9: 57]
    CALL    print_string_es_ax                               ; [3EDA: E8 CF C4]
    POP     DI                                               ; [3EDD: 5F]
    CMP     BYTE [ES:DI+3A], 05                              ; [3EDE: 26 80 7D 3A 05]
    JZ      loc_3eff                                         ; [3EE3: 74 1A]
    MOV     AX, [var_fdc_transfer_len]                       ; [3EE5: A1 88 64]
    ADD     AX, 0036                                         ; [3EE8: 05 36 00]
    CALL    set_cursor_pos                                   ; [3EEB: E8 8B C3]
    MOV     BL, BYTE [ES:DI+3A]                              ; [3EEE: 26 8A 5D 3A]
    XOR     BH, BH                                           ; [3EF2: 32 FF]
    SHL     BX, 1                                            ; [3EF4: D1 E3]
    PUSH    DI                                               ; [3EF6: 57]
    XOR     AL, AL                                           ; [3EF7: 32 C0]
    CALL    WORD [CS:BX+menu_format_vector_table]            ; [3EF9: 2E FF 97 99 3F]
    POP     DI                                               ; [3EFE: 5F]
loc_3eff:
    ADD     DI, +3C                                          ; [3EFF: 83 C7 3C]
    ADD     WORD [var_fdc_transfer_len], 0100                ; [3F02: 81 06 88 64 00 01]
    JMPS    loc_3ec5                                         ; [3F08: EB BB]
loc_3f0a:
    RETN                                                     ; [3F0A: C3]
sub_3f0b:
    MOV     AX, 03E8                                         ; [3F0B: B8 E8 03]
    CALL    sub_049a                                         ; [3F0E: E8 89 C5]
    MOV     AX, 1400                                         ; [3F11: B8 00 14]
    CALL    set_cursor_pos                                   ; [3F14: E8 62 C3]
    MOV     AX, 380F                                         ; [3F17: B8 0F 38]
    MOV     CX, FFFF                                         ; [3F1A: B9 FF FF]
    CALL    print_string_es_ax                               ; [3F1D: E8 8C C4]
    CALL    read_key_poll                                    ; [3F20: E8 B0 C4]
    MOV     DI, 354B                                         ; [3F23: BF 4B 35]
    CMP     BYTE [var_fdc_drive_unit], 00                    ; [3F26: 80 3E 8C 64 00]
    JZ      loc_3f30                                         ; [3F2B: 74 03]
    MOV     DI, 2F8D                                         ; [3F2D: BF 8D 2F]
loc_3f30:
    CMP     BYTE [ES:DI+3B], AL                              ; [3F30: 26 38 45 3B]
    JZ      loc_3f41                                         ; [3F34: 74 0B]
    ADD     DI, +3C                                          ; [3F36: 83 C7 3C]
    CMP     BYTE [ES:DI], FF                                 ; [3F39: 26 80 3D FF]
    JNZ     loc_3f30                                         ; [3F3D: 75 F1]
    JMPS    sub_3f0b                                         ; [3F3F: EB CA]
loc_3f41:
    PUSH    DI                                               ; [3F41: 57]
    CALL    fdc_release_bus                                  ; [3F42: E8 DF FD]
    MOV     AX, 0000                                         ; [3F45: B8 00 00]
    CALL    set_cursor_pos                                   ; [3F48: E8 2E C3]
    MOV     AX, 317A                                         ; [3F4B: B8 7A 31]
    MOV     CX, FFFF                                         ; [3F4E: B9 FF FF]
    CALL    print_string_es_ax                               ; [3F51: E8 58 C4]
    POP     DI                                               ; [3F54: 5F]
    RETN                                                     ; [3F55: C3]
sub_3f56:
    PUSH    DI                                               ; [3F56: 57]
    CMP     BYTE [ES:DI+3A], 05                              ; [3F57: 26 80 7D 3A 05]
    JZ      loc_3f88                                         ; [3F5C: 74 2A]
    MOV     AX, 1400                                         ; [3F5E: B8 00 14]
    CALL    set_cursor_pos                                   ; [3F61: E8 15 C3]
    MOV     AX, 381A                                         ; [3F64: B8 1A 38]
    MOV     CX, FFFF                                         ; [3F67: B9 FF FF]
    CALL    print_string_es_ax                               ; [3F6A: E8 3F C4]
    MOV     AX, 0400                                         ; [3F6D: B8 00 04]
    CALL    set_cursor_pos                                   ; [3F70: E8 06 C3]
    POP     DI                                               ; [3F73: 5F]
    PUSH    DI                                               ; [3F74: 57]
    MOV     AX, DI                                           ; [3F75: 8B C7]
    ADD     AX, 0005                                         ; [3F77: 05 05 00]
    MOV     CX, FFFF                                         ; [3F7A: B9 FF FF]
    CALL    print_string_es_ax                               ; [3F7D: E8 2C C4]
    POP     DI                                               ; [3F80: 5F]
    PUSH    DI                                               ; [3F81: 57]
    MOV     AX, 0433                                         ; [3F82: B8 33 04]
    CALL    set_cursor_pos                                   ; [3F85: E8 F1 C2]
loc_3f88:
    MOV     BL, BYTE [ES:DI+3A]                              ; [3F88: 26 8A 5D 3A]
    XOR     BH, BH                                           ; [3F8C: 32 FF]
    SHL     BX, 1                                            ; [3F8E: D1 E3]
    MOV     AL, 01                                           ; [3F90: B0 01]
    CALL    WORD [CS:BX+menu_format_vector_table]            ; [3F92: 2E FF 97 99 3F]
    POP     DI                                               ; [3F97: 5F]
    RETN                                                     ; [3F98: C3]

; ----------------------------------------------------------------------------
; menu_format_vector_table (ROM: 77D9h, FB84:3F99h)
; Skærmformat og menu dispatch-tabel for CALL [CS:BX+3F99] (FB84:3EF9, 3F92)
; ----------------------------------------------------------------------------
menu_format_vector_table:
    DW  sub_3fa5                     ; [3F99h] Menu 0 (3FA5h)
    DW  sub_4088                     ; [3F9Bh] Menu 1 (4088h)
    DW  sub_40ea                     ; [3F9Dh] Menu 2 (40EAh)
    DW  sub_4058                     ; [3F9Fh] Menu 3 (4058h)
    DW  sub_402f                     ; [3FA1h] Menu 4 (402Fh)
    DW  sub_4164                     ; [3FA3h] Menu 5 (4164h)
sub_3fa5:
    PUSH    DI                                               ; [3FA5: 57]
    PUSH    AX                                               ; [3FA6: 50]
    MOV     SI, 648D                                         ; [3FA7: BE 8D 64]
    MOV     AL, BYTE [ES:DI]                                 ; [3FAA: 26 8A 05]
    MOV     [var_fdc_head_sector], AL                        ; [3FAD: A2 8B 64]
    XOR     AH, AH                                           ; [3FB0: 32 E4]
    ADD     SI, AX                                           ; [3FB2: 03 F0]
    MOV     BL, BYTE [SI]                                    ; [3FB4: 8A 1C]
    XOR     BH, BH                                           ; [3FB6: 32 FF]
    POP     AX                                               ; [3FB8: 58]
    OR      AL, AL                                           ; [3FB9: 0A C0]
    JNZ     loc_3fc4                                         ; [3FBB: 75 07]
    MOV     AX, BX                                           ; [3FBD: 8B C3]
    CALL    sub_038b                                         ; [3FBF: E8 C9 C3]
    POP     DI                                               ; [3FC2: 5F]
    RETN                                                     ; [3FC3: C3]
loc_3fc4:
    PUSH    BX                                               ; [3FC4: 53]
    PUSH    SI                                               ; [3FC5: 56]
    MOV     CX, 0001                                         ; [3FC6: B9 01 00]
    MOV     AX, 3808                                         ; [3FC9: B8 08 38]
    CALL    sub_0f88                                         ; [3FCC: E8 B9 CF]
    CMP     BYTE [var_fdc_drive_unit], 01                    ; [3FCF: 80 3E 8C 64 01]
    JZ      loc_3ffe                                         ; [3FD4: 74 28]
    CMP     AX, 00FF                                         ; [3FD6: 3D FF 00]
    JGE     loc_3fe1                                         ; [3FD9: 7D 06]
loc_3fdb:
    POP     SI                                               ; [3FDB: 5E]
    MOV     BYTE [SI], AL                                    ; [3FDC: 88 04]
    POP     BX                                               ; [3FDE: 5B]
    POP     DI                                               ; [3FDF: 5F]
    RETN                                                     ; [3FE0: C3]
loc_3fe1:
    MOV     AX, 0433                                         ; [3FE1: B8 33 04]
    CALL    set_cursor_pos                                   ; [3FE4: E8 92 C2]
    MOV     CX, 001D                                         ; [3FE7: B9 1D 00]
loc_3fea:
    MOV     AL, 20                                           ; [3FEA: B0 20]
    CALL    conout_char                                      ; [3FEC: E8 A9 C2]
    LOOP    loc_3fea                                         ; [3FEF: E2 F9]
    MOV     AX, 0433                                         ; [3FF1: B8 33 04]
    CALL    set_cursor_pos                                   ; [3FF4: E8 82 C2]
    POP     SI                                               ; [3FF7: 5E]
    POP     BX                                               ; [3FF8: 5B]
    POP     DI                                               ; [3FF9: 5F]
    MOV     AL, 01                                           ; [3FFA: B0 01]
    JMPS    sub_3fa5                                         ; [3FFC: EB A7]
loc_3ffe:
    PUSH    BX                                               ; [3FFE: 53]
    MOV     BX, 316E                                         ; [3FFF: BB 6E 31]
    PUSH    AX                                               ; [4002: 50]
    XOR     AH, AH                                           ; [4003: 32 E4]
    MOV     AL, [var_fdc_head_sector]                        ; [4005: A0 8B 64]
    ADD     BX, AX                                           ; [4008: 03 D8]
    MOV     AL, BYTE [ES:BX]                                 ; [400A: 26 8A 07]
    MOV     BX, AX                                           ; [400D: 8B D8]
    POP     AX                                               ; [400F: 58]
    CMP     AX, BX                                           ; [4010: 3B C3]
    POP     BX                                               ; [4012: 5B]
    JL      loc_3fe1                                         ; [4013: 7C CC]
    PUSH    BX                                               ; [4015: 53]
    MOV     BX, 3174                                         ; [4016: BB 74 31]
    PUSH    AX                                               ; [4019: 50]
    XOR     AH, AH                                           ; [401A: 32 E4]
    MOV     AL, [var_fdc_head_sector]                        ; [401C: A0 8B 64]
    ADD     BX, AX                                           ; [401F: 03 D8]
    MOV     AL, BYTE [ES:BX]                                 ; [4021: 26 8A 07]
    MOV     BX, AX                                           ; [4024: 8B D8]
    POP     AX                                               ; [4026: 58]
    CMP     AX, BX                                           ; [4027: 3B C3]
    POP     BX                                               ; [4029: 5B]
    JGE     loc_3fe1                                         ; [402A: 7D B5]
    JMPN    loc_3fdb                                         ; [402C: E9 AC FF]
sub_402f:
    PUSH    DI                                               ; [402F: 57]
    PUSH    AX                                               ; [4030: 50]
    MOV     SI, 648D                                         ; [4031: BE 8D 64]
    MOV     AL, BYTE [ES:DI]                                 ; [4034: 26 8A 05]
    XOR     AH, AH                                           ; [4037: 32 E4]
    ADD     SI, AX                                           ; [4039: 03 F0]
    MOV     BX, WORD [SI]                                    ; [403B: 8B 1C]
    POP     AX                                               ; [403D: 58]
    OR      AL, AL                                           ; [403E: 0A C0]
    JNZ     loc_4049                                         ; [4040: 75 07]
    MOV     AX, BX                                           ; [4042: 8B C3]
    CALL    sub_038b                                         ; [4044: E8 44 C3]
    POP     DI                                               ; [4047: 5F]
    RETN                                                     ; [4048: C3]
loc_4049:
    PUSH    SI                                               ; [4049: 56]
    MOV     CX, 0001                                         ; [404A: B9 01 00]
    MOV     AX, 3808                                         ; [404D: B8 08 38]
    CALL    sub_0f88                                         ; [4050: E8 35 CF]
    POP     SI                                               ; [4053: 5E]
    MOV     WORD [SI], AX                                    ; [4054: 89 04]
    POP     DI                                               ; [4056: 5F]
    RETN                                                     ; [4057: C3]
sub_4058:
    PUSH    DI                                               ; [4058: 57]
    PUSH    AX                                               ; [4059: 50]
    MOV     SI, 648D                                         ; [405A: BE 8D 64]
    MOV     AL, BYTE [ES:DI]                                 ; [405D: 26 8A 05]
    XOR     AH, AH                                           ; [4060: 32 E4]
    ADD     SI, AX                                           ; [4062: 03 F0]
    MOV     BX, WORD [SI]                                    ; [4064: 8B 1C]
    ADD     BX, 02C3                                         ; [4066: 81 C3 C3 02]
    POP     AX                                               ; [406A: 58]
    OR      AL, AL                                           ; [406B: 0A C0]
    JNZ     loc_4076                                         ; [406D: 75 07]
    MOV     AX, BX                                           ; [406F: 8B C3]
    CALL    sub_038b                                         ; [4071: E8 17 C3]
    POP     DI                                               ; [4074: 5F]
    RETN                                                     ; [4075: C3]
loc_4076:
    PUSH    SI                                               ; [4076: 56]
    MOV     CX, 0001                                         ; [4077: B9 01 00]
    MOV     AX, 3808                                         ; [407A: B8 08 38]
    CALL    sub_0f88                                         ; [407D: E8 08 CF]
    SUB     AX, 02C3                                         ; [4080: 2D C3 02]
    POP     SI                                               ; [4083: 5E]
    MOV     WORD [SI], AX                                    ; [4084: 89 04]
    POP     DI                                               ; [4086: 5F]
    RETN                                                     ; [4087: C3]
sub_4088:
    PUSH    DI                                               ; [4088: 57]
    PUSH    AX                                               ; [4089: 50]
    MOV     SI, 648D                                         ; [408A: BE 8D 64]
    MOV     AL, BYTE [ES:DI]                                 ; [408D: 26 8A 05]
    XOR     AH, AH                                           ; [4090: 32 E4]
    ADD     SI, AX                                           ; [4092: 03 F0]
    PUSH    SI                                               ; [4094: 56]
    MOV     AL, BYTE [SI]                                    ; [4095: 8A 04]
    AND     AL, BYTE [ES:DI+01]                              ; [4097: 26 22 45 01]
    MOV     AX, 3805                                         ; [409B: B8 05 38]
    JZ      loc_40a3                                         ; [409E: 74 03]
    MOV     AX, 3802                                         ; [40A0: B8 02 38]
loc_40a3:
    MOV     CX, 0001                                         ; [40A3: B9 01 00]
    CALL    print_string_es_ax                               ; [40A6: E8 03 C3]
    POP     SI                                               ; [40A9: 5E]
    POP     AX                                               ; [40AA: 58]
    OR      AL, AL                                           ; [40AB: 0A C0]
    JNZ     loc_40b1                                         ; [40AD: 75 02]
    POP     DI                                               ; [40AF: 5F]
    RETN                                                     ; [40B0: C3]
loc_40b1:
    PUSH    SI                                               ; [40B1: 56]
    MOV     AL, 2F                                           ; [40B2: B0 2F]
    CALL    conout_char                                      ; [40B4: E8 E1 C1]
    CALL    read_key_poll                                    ; [40B7: E8 19 C3]
    CMP     AL, 0D                                           ; [40BA: 3C 0D]
    JZ      loc_40e7                                         ; [40BC: 74 29]
    PUSH    AX                                               ; [40BE: 50]
    CALL    conout_char                                      ; [40BF: E8 D6 C1]
    CALL    read_key_poll                                    ; [40C2: E8 0E C3]
    POP     AX                                               ; [40C5: 58]
    CMP     AL, 4E                                           ; [40C6: 3C 4E]
    JZ      loc_40d2                                         ; [40C8: 74 08]
    CMP     AL, 59                                           ; [40CA: 3C 59]
    JZ      loc_40de                                         ; [40CC: 74 10]
    POP     SI                                               ; [40CE: 5E]
    POP     DI                                               ; [40CF: 5F]
    JMPS    sub_4088                                         ; [40D0: EB B6]
loc_40d2:
    POP     SI                                               ; [40D2: 5E]
    POP     DI                                               ; [40D3: 5F]
    MOV     AH, BYTE [ES:DI+01]                              ; [40D4: 26 8A 65 01]
    XOR     AH, FF                                           ; [40D8: 80 F4 FF]
    AND     BYTE [SI], AH                                    ; [40DB: 20 24]
    RETN                                                     ; [40DD: C3]
loc_40de:
    POP     SI                                               ; [40DE: 5E]
    POP     DI                                               ; [40DF: 5F]
    MOV     AH, BYTE [ES:DI+01]                              ; [40E0: 26 8A 65 01]
    OR      BYTE [SI], AH                                    ; [40E4: 08 24]
    RETN                                                     ; [40E6: C3]
loc_40e7:
    POP     SI                                               ; [40E7: 5E]
    POP     DI                                               ; [40E8: 5F]
    RETN                                                     ; [40E9: C3]
sub_40ea:
    PUSH    DI                                               ; [40EA: 57]
    PUSH    AX                                               ; [40EB: 50]
    MOV     SI, 648D                                         ; [40EC: BE 8D 64]
    MOV     AL, BYTE [ES:DI]                                 ; [40EF: 26 8A 05]
    XOR     AH, AH                                           ; [40F2: 32 E4]
    ADD     SI, AX                                           ; [40F4: 03 F0]
    ADD     SI, +20                                          ; [40F6: 83 C6 20]
    CMP     BYTE [SI], 00                                    ; [40F9: 80 3C 00]
    JNZ     loc_410e                                         ; [40FC: 75 10]
    MOV     AX, 3809                                         ; [40FE: B8 09 38]
    MOV     CX, FFFF                                         ; [4101: B9 FF FF]
    CALL    print_string_es_ax                               ; [4104: E8 A5 C2]
    POP     AX                                               ; [4107: 58]
    OR      AL, AL                                           ; [4108: 0A C0]
    JNZ     loc_412a                                         ; [410A: 75 1E]
    POP     DI                                               ; [410C: 5F]
    RETN                                                     ; [410D: C3]
loc_410e:
    PUSH    SI                                               ; [410E: 56]
    MOV     CX, 0008                                         ; [410F: B9 08 00]
    XOR     AH, AH                                           ; [4112: 32 E4]
loc_4114:
    MOV     AL, BYTE [SI]                                    ; [4114: 8A 04]
    CMP     AL, 20                                           ; [4116: 3C 20]
    JZ      loc_4122                                         ; [4118: 74 08]
    PUSHA                                                    ; [411A: 60]
    CALL    conout_char                                      ; [411B: E8 7A C1]
    POPA                                                     ; [411E: 61]
    INC     SI                                               ; [411F: 46]
    LOOP    loc_4114                                         ; [4120: E2 F2]
loc_4122:
    POP     SI                                               ; [4122: 5E]
    POP     AX                                               ; [4123: 58]
    OR      AL, AL                                           ; [4124: 0A C0]
    JNZ     loc_412a                                         ; [4126: 75 02]
    POP     DI                                               ; [4128: 5F]
    RETN                                                     ; [4129: C3]
loc_412a:
    PUSH    SI                                               ; [412A: 56]
    MOV     AL, 2F                                           ; [412B: B0 2F]
    CALL    conout_char                                      ; [412D: E8 68 C1]
    MOV     CX, 0008                                         ; [4130: B9 08 00]
    MOV     SI, 6480                                         ; [4133: BE 80 64]
loc_4136:
    CALL    read_key_poll                                    ; [4136: E8 9A C2]
    CMP     AL, 0D                                           ; [4139: 3C 0D]
    JZ      loc_4154                                         ; [413B: 74 17]
    MOV     BYTE [SI], AL                                    ; [413D: 88 04]
    CALL    conout_char                                      ; [413F: E8 56 C1]
    INC     SI                                               ; [4142: 46]
    LOOP    loc_4136                                         ; [4143: E2 F1]
loc_4145:
    POP     DI                                               ; [4145: 5F]
    PUSH    ES                                               ; [4146: 06]
    PUSH    DS                                               ; [4147: 1E]
    POP     ES                                               ; [4148: 07]
    MOV     CX, 0008                                         ; [4149: B9 08 00]
    MOV     SI, 6480                                         ; [414C: BE 80 64]
    REP MOVSB                                                ; [414F: F3 A4]
    POP     ES                                               ; [4151: 07]
    POP     DI                                               ; [4152: 5F]
    RETN                                                     ; [4153: C3]
loc_4154:
    CMP     CX, +08                                          ; [4154: 83 F9 08]
    JNZ     loc_415c                                         ; [4157: 75 03]
    POP     SI                                               ; [4159: 5E]
    POP     DI                                               ; [415A: 5F]
    RETN                                                     ; [415B: C3]
loc_415c:
    MOV     BYTE [SI], 20                                    ; [415C: C6 04 20]
    INC     SI                                               ; [415F: 46]
    LOOP    loc_415c                                         ; [4160: E2 FA]
    JMPS    loc_4145                                         ; [4162: EB E1]
sub_4164:
    CMP     BYTE [ES:DI+3B], 4E                              ; [4164: 26 80 7D 3B 4E]
    JZ      loc_4175                                         ; [4169: 74 0A]
    CMP     BYTE [var_fdc_drive_unit], 01                    ; [416B: 80 3E 8C 64 01]
    JZ      loc_418b                                         ; [4170: 74 19]
    CALL    sub_3d9a                                         ; [4172: E8 25 FC]
loc_4175:
    MOV     BYTE [var_fdc_cylinder_num], 00                  ; [4175: C6 06 8A 64 00]
    MOV     AX, 0200                                         ; [417A: B8 00 02]
    CALL    set_cursor_pos                                   ; [417D: E8 F9 C0]
    MOV     AL, 20                                           ; [4180: B0 20]
    MOV     CX, 0640                                         ; [4182: B9 40 06]
loc_4185:
    CALL    conout_char                                      ; [4185: E8 10 C1]
    LOOP    loc_4185                                         ; [4188: E2 FB]
    RETN                                                     ; [418A: C3]
loc_418b:
    CALL    sub_25e9                                         ; [418B: E8 5B E4]
    JMPN    loc_4175                                         ; [418E: E9 E4 FF]
sub_4191:
    PUSH    DS                                               ; [4191: 1E]
    PUSH    ES                                               ; [4192: 06]
    MOV     AX, [CS:rom_segment_base]                        ; [4193: 2E A1 00 00]
    MOV     ES, AX                                           ; [4197: 8E C0]
    MOV     AX, [CS:ram_segment_base]                        ; [4199: 2E A1 02 00]
    MOV     DS, AX                                           ; [419D: 8E D8]
    PUSHA                                                    ; [419F: 60]
    MOV     BYTE [var_fdc_drive_unit], 00                    ; [41A0: C6 06 8C 64 00]
    CALL    sub_3dba                                         ; [41A5: E8 12 FC]
    JNC     loc_41b3                                         ; [41A8: 73 09]
    CALL    sub_3dfd                                         ; [41AA: E8 50 FC]
    CALL    sub_3de6                                         ; [41AD: E8 36 FC]
    CALL    sub_3d9a                                         ; [41B0: E8 E7 FB]
loc_41b3:
    CALL    sub_3d7d                                         ; [41B3: E8 C7 FB]
    MOV     BYTE [var_fdc_cylinder_num], 01                  ; [41B6: C6 06 8A 64 01]
loc_41bb:
    CALL    sub_3e8e                                         ; [41BB: E8 D0 FC]
    CALL    sub_3f0b                                         ; [41BE: E8 4A FD]
    CALL    sub_3f56                                         ; [41C1: E8 92 FD]
    CMP     BYTE [var_fdc_cylinder_num], 01                  ; [41C4: 80 3E 8A 64 01]
    JZ      loc_41bb                                         ; [41C9: 74 F0]
    POPA                                                     ; [41CB: 61]
    POP     ES                                               ; [41CC: 07]
    POP     DS                                               ; [41CD: 1F]
    RETN                                                     ; [41CE: C3]
    PUSH    DS                                               ; [41CF: 1E]
    PUSH    ES                                               ; [41D0: 06]
    MOV     AX, [CS:rom_segment_base]                        ; [41D1: 2E A1 00 00]
    MOV     ES, AX                                           ; [41D5: 8E C0]
    MOV     AX, [CS:ram_segment_base]                        ; [41D7: 2E A1 02 00]
    MOV     DS, AX                                           ; [41DB: 8E D8]
    PUSHA                                                    ; [41DD: 60]
    MOV     BYTE [var_fdc_drive_unit], 01                    ; [41DE: C6 06 8C 64 01]
    CALL    sub_2664                                         ; [41E3: E8 7E E4]
    MOV     BYTE [var_fdc_cylinder_num], 01                  ; [41E6: C6 06 8A 64 01]
    JMPN    loc_41bb                                         ; [41EB: E9 CD FF]

; ----------------------------------------------------------------------------
; ROM Padding / Ubrugt ROM-plads (ROM 7A2Eh - 7F7Fh, 1362 bytes)
; ----------------------------------------------------------------------------
    TIMES 1362 DB 0FFh

; ----------------------------------------------------------------------------
; ROM Vektorer / Tabelfarpointere (ROM 7F80h - 7F87h)
; ----------------------------------------------------------------------------
    DW  0009Eh, ROM_DATA_SEGMENT ; [7F80h] Far pointer til special_glyphs_01_to_1f
    DW  00B7Eh, ROM_DATA_SEGMENT ; [7F84h] Far pointer til font/display tabel

; ============================================================================
; SECTION 4: 80186 RESET ENTRY STUB (ROM offset 7F88h - 7FDFh)
; Target for initial far jump from reset vector (FFFF:0000h)
; Konfigurerer 80186 integrerede Peripheral Control Block (PCB) chip-selects
; ============================================================================
SEGMENT RESET_FFF8 AT RESET_STUB_SEGMENT
ORG RESET_STUB_IP

reset_entry_fff8_0008:
    CLI                                                      ; [0008: FA]
    MOV     SP, 0001                                         ; [0009: BC 01 00]
    MOV     BP, 9000                                         ; [000C: BD 00 90]
    JNC     reset_config_pcb_chips                           ; [000F: 73 24]
    OR      BP, 0200                                         ; [0011: 81 CD 00 02]
reset_check_test_lock:
    MOV     AL, 01                                           ; [0015: B0 01]
    LOCK XCHG BYTE [ES:BX], AL                               ; [0017: F0 26 86 07]
    CMP     AL, 01                                           ; [001B: 3C 01]
    JZ      reset_check_test_lock                            ; [001D: 74 F6]
    MOV     BYTE [ES:BX+01], 03                              ; [001F: 26 C6 47 01 03]
    MOV     DX, io_i82730_ca_pulse       ; Intel 82730 Channel Attention (CA pulse) ; [0024: BA 40 02]
    OUT     DX, AX                                           ; [0027: EF]
    MOV     AX, 0000                                         ; [0028: B8 00 00]
    MOV     DS, AX                                           ; [002B: 8E D8]
    MOV     DI, 0058                                         ; [002D: BF 58 00]
    MOV     WORD [DI], BX                                    ; [0030: 89 1D]
    MOV     WORD [DI+02], ES                                 ; [0032: 8C 45 02]
reset_config_pcb_chips:
    MOV     DX, io_i186_umcs             ; 80186 UMCS (Upper Memory Chip Select: Boot ROM 32KB) ; [0035: BA A0 FF]
    MOV     AX, F838                                         ; [0038: B8 38 F8]
    OUT     DX, AX                                           ; [003B: EF]
    MOV     AX, 003A                                         ; [003C: B8 3A 00]
    MOV     DX, io_i186_lmcs             ; 80186 LMCS (Lower Memory Chip Select: Base RAM) ; [003F: BA A4 FF]
    OUT     DX, AX                                           ; [0042: EF]
    MOV     AX, 90BA                                         ; [0043: B8 BA 90]
    MOV     DX, io_i186_mmcs             ; 80186 MMCS (Mid-Range Memory Chip Select: CRT-RAM D0000h) ; [0046: BA A8 FF]
    OUT     DX, AX                                           ; [0049: EF]
    MOV     DX, io_i186_mpcs             ; 80186 MPCS (Mid-Range Memory / Peripheral Chip Select) ; [004A: BA A6 FF]
    MOV     AX, 01F8                                         ; [004D: B8 F8 01]
    OUT     DX, AX                                           ; [0050: EF]
    MOV     DX, io_i186_pacs             ; 80186 PACS (Peripheral Chip Select: Base 0000h) ; [0051: BA A2 FF]
    MOV     AX, 3FF8                                         ; [0054: B8 F8 3F]
    OUT     DX, AX                                           ; [0057: EF]
    JMPF    CODE_SEGMENT_BASE:cold_boot_entry                ; [0058: EA 04 00 84 FB]

; ----------------------------------------------------------------------------
; Reset Stub Padding (ROM 7FDDh - 7FEFh, 19 bytes)
; ----------------------------------------------------------------------------
    TIMES 19 DB 0FFh

; ============================================================================
; SECTION 5: 80186 RESET VECTOR & INTEL 82730 SCP (ROM offset 7FF0h - 7FFFh)
; Fysisk adresse 0xFFFF0 (CPU opstartsadresse efter hardware RESET)
; ============================================================================
SEGMENT RESET_FFFF AT RESET_VECTOR_SEGMENT
ORG 0000h

reset_vector_ffff_0000:
    CLI                                                      ; [0000: FA]
    JMPF    RESET_STUB_SEGMENT:reset_entry_fff8_0008         ; [0001: EA 08 00 F8 FF]

; ----------------------------------------------------------------------------
; Intel 82730 System Configuration Pointer (SCP)
; Fast placering i toppen af hukommelsen (fysisk 0xFFFF6 - 0xFFFFFh).
; Intel 82730 Text Coprocessor læser denne blok ved RESET / initial Channel
; Attention (CA-puls på port 0240h) for at bestemme busbredde og finde IBP/SCB.
; ----------------------------------------------------------------------------
i82730_system_configuration_pointer:
    DB  001h                                                 ; [0006: 01] SYSBUS: 16-bit system bus mode (bit 0 = 1)
    DB  0FFh, 000h, 000h, 000h, 000h                         ; [0007: FF 00 00 00 00] Reserveret / padding
    DW  06000h                                               ; [000C: 00 60] IBP base address lav word
    DW  0000Dh                                               ; [000E: 0D 00] IBP base address høj word -> fysisk 0D6000h (D000:6000h)

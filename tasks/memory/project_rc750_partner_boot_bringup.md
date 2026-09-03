# RC750 Partner — MAME bring-up (boot fra ROM)

Session 2026-09-02. Mistral havde lavet driver-skelettet (`mame/src/mame/regnecentralen/rc750.cpp`,
delt kerne `rc75x.cpp/.h`). Nye ROM-dumps kom: `mame/roms/rc750/ROD398.bin` + `ROD399.bin`
(16 KB hver). Mål: se om rc750 kan boote (floppy).

## Verificerede fakta

- **ROM-interleave**: to byte-brede 16 KB EPROMs på 80186 16-bit bus.
  **ROD398 = even/lav byte, ROD399 = odd/høj byte** → reset-vektor @0xFFFF0 = `FA EA 00 00 F8 FF`
  (`CLI; JMP FFF8:0000`). Mistrals færdigsamlede `rc750.rom`/`rc750_swapped.rom` har FORKERT
  interleave — brug ROD*-filerne via `ROM_LOAD16_BYTE` (CRC rod398=37bb9bf8, rod399=53c8b085).
  Læsbar engelsk tekst i den flettede binær bekræfter rækkefølgen.
- **Boot-ROM er en diagnostik/selvtest-ROM**: banner "RC750 *** TEST, V.4.3 ***", menu, indbygget
  "Snooper" (port-I/O monitor), disk-boot-beskeder ("INSERT DISKETTE", "DISKETTE NOT FORMATTED",
  "NON EXISTING MEDIUM"). rc759's ROM er søskende: "PICCOLINE TEST, V.5.1". rc750 booter også fra
  Winchester (SCSI) — vi har ingen HD-images.
- **RAM-layout afviger fra Piccolinen**: selvtesten lægger stak i segment F000 (`SS=F000,SP=8000`)
  og rydder F000:0000-7FFF → kræver **RAM @ 0xF0000-0xF7FFF** (tilføjet i rc750_map). Uden den
  spinner CPU'en ved F951:07A0.
- **Port-map = rc759 delt kerne** (verificeret mod ROM'ens faktiske I/O): PIC 0x00, kbd 0x20,
  lyd 0x56, RTC 0x5a/5c, PPI 0x70, palette 0x180-0x1be. **Partner-specifikt**: 82730
  channel-attention **0x240** (mailbox-handshake @F000:2000), 82730 reset(irst) **0x210** (pulses
  TIDLIGT før command block bygges — må IKKE mappes som CA, ellers for tidlig attention → garbage
  cmd 0x0c → hang). Uafklarede Partner-porte: **0x40-0x46** (4 registre, sandsynligvis WD1797 FDC
  — driverens 0x280 er Mistrals forkerte gæt), 0x34/0x36, 0x200, 0x220. FDC/0x280 blev ALDRIG rørt.
- **82730 video kører**: init → MODE SET → LOAD INTMASK → START DISPLAY (som rc759). Kræver dog
  patch af **i82730 `ca_w` DIP-guard** (`src/devices/video/i82730.cpp` ~L853: `m_initialized ||
  (m_status&DIP)==0`) — MAME-modellen ignorerede ellers kommandoer under aktivt display, så
  selvtestens READ STATUS-poll (cmd 0x08) hang. Patchen brød IKKE rc759 (verificeret: renderer
  stadig "PICCOLINE TEST"). BEHØVER stadig bredere validering mod andre 82730-brugere.

## LØST 2026-09-02: læsbar skærm (font i ROM)

- Skærm-char-koder er **ASCII** (lav byte af 16-bit ord, høj byte = attribut), lagret i
  display-buffer @F3000 (list[0] via CBP-kæde F2000->lptr F2054->sptr F3000).
- **Fonten ligger i boot-ROM'en** (ikke i m_vram som rc759). Fundet ved fuld 1 MB RAM-dump
  (`ramdump.lua`) + font-scan: en **tagget tabel ved BIOS-ROM offset 0x7f** (0xE807F i CPU-rum),
  **47 poster à 17 bytes**, koder **0x2a '*' .. 0x5a 'Z'** (kun STORE bogstaver + cifre/tegn;
  huller ved ';' 0x3b og '@' 0x40). Postformat: `[byte0=ASCII-kode][15 scanline-rækker, 7 px
  bred, bit6=venstre][pad]`. Glyf-rækkerne læses `record+1 .. record+15` (lc 0..14). Verificeret
  ved at rendere R,C,7,5,0,A,T,E,S,V og matche "*** TEST, V.4.3 ***"-banneret.
- **Implementering** (rc75x delt kerne): `rc75x_state::init_rom_font(table,records,stride,glyph_off)`
  bygger `m_font_glyph[128]` LUT nøglet på tag-byten (ikke base+code*stride pga. hullerne) og sætter
  `m_use_rom_font=true`. `txt_update_row` forgrener på `m_use_rom_font` FØRST (før rows_per_char>=12
  gfx-heuristikken, som ellers fejl-router 15-scanline-teksten). `rc750_state::machine_start` kalder
  `init_rom_font(memregion("bios")->base()+0x7f, 47, 17, 1)`. Amber P3-farver, cursor reverse --
  genbrugt fra tekst-stien.
- **Celle-pitch = 9 px** (ikke 7 som rc759). 82730 mode-block: line_length=61 (bitmap 61*16=976 px),
  aktivt felt hfldstrt=13..hfldstp=58 => (58-13)*16 = **720 px / 80 kol = 9 px/celle**. Den 7 px brede
  glyf venstre-stilles i 9 px-cellen -> 2 px mellemrum (svarer til 82730 char-box: 7 dot-kolonner + 2
  blanke clocks). Konfigurerbart via `m_text_hpitch` i rc75x (rc750 sætter 9 i machine_start; rc759
  urørt, bruger sin egen 7 px tekst-sti). `screen_update` copybitmap'er content (skrevet fra x=0) til
  feltets origo (destx = hfldstrt*16).
- Status: **tekst renderer korrekt med korrekt tegn-afstand** (snapshot pixel-nøjagtigt mod
  ROM-bitmap). Selvtesten viser "ERROR 00035" i statuslinjen (forventet: ingen floppy/HD monteret).
  Ikke committet endnu. Diff: rc75x.h + rc75x.cpp (ROM-font-sti + pitch) + rc750.cpp (machine_start
  + CPU 8 MHz) + i82730.cpp (DIP-guard-patch).
- **CPU = 8 MHz** (rettet fra 6 MHz gæt; user 2026-09-02: rc750 har 8 MHz 80186). 82730 char-clock
  (916'500 Hz i add_common_devices) er uafhængig af CPU-klokken.

## Floppy-boot bring-up (2026-09-03) — SW1500 CCP/M-86

Boot-floppy: **datamuseum.dk Bits:30009620** = `SW1500_2.0.imd` (IMAGEDisk, "SW1500 CCP/M 86 (2.0)").
Hentet til `mame/floppies/`. Monteres `-flop1 floppies/SW1500_2.0.imd` (IMD understøttet af
add_mfm_containers). Selvtest-doku: **datamuseum.dk Bits:30002753** (188-siders service-manual PDF
med tekstlag; fejlkode-tabel side 126-127).

Reverse-engineered port-kort (via unidasm x86_16 på flettet ROM):
- **FDC = WD1797 @ 0x200-0x206** (status/cmd, track, sektor, data på lige bytes). Verificeret:
  selvtest poller 0x200 bit0 (BUSY) ved FD72E, skriver Force-Interrupt 0xD8. (0x280 var Piccoline-gæt.)
- **Floppy drive-select/control @ 0x260** (skriv drive-kode, læs bit4="disk present"), **sense @ 0x220**
  (config-jumpere bit6-7, ready bit4, aktiv-lav). Handlers PROVISORISKE (aldrig eksekveret endnu —
  boot når ikke floppy-læsning).
- **SCSI-controller @ 0x30-0x36 + 0x40-0x46** (80186-DMA-baseret transfer-test; IKKE emuleret).

**ERROR 00035 = SCSI-test (dok. side 127), ROOT-CAUSED + FIXET:** fejl-gaten (fa971) er en
poll-løkke (fa978) der venter på **PPI port B bit3** (`in 0x72`, bit 0x08) skal gå LAV med timeout.
`ppi_portb_r()` hardkodede bit3=1 (Piccoline "not used") -> timeout -> ERROR 35. **Fix: bit3=0** i
ppi_portb_r (bit3 = SCSI-handshake-linje på Partneren). Bekræftet: error 35 forsvinder, POST fortsætter.

**CTRL+ALT+SLET (selvtest-skip, dok. side 125) dekodet men GATED under selvtest:** combo =
scancode CTRL 0x1D (kode 29) + ALT 0x37 (**kode 55**, var IPT_UNUSED i MAME — nu mappet til host
LALT/RALT) + SLET 0x0E (Backspace, kode 14). Detekteres i F9999 via tæller [12Fh]>=2; men ISR'en
(f99e3) springer F9999 over når **[13Bh]==0xFF** (sat mens selvtest kører, fb9b1). Så combo'en er en
warm-boot-genvej der er DEAKTIVERET under selvtest — kan ikke skippe SCSI-haltet. Derfor valgt
SCSI-fix-vejen i stedet (user 2026-09-03).

## LØST 2026-09-03: 82730-mailbox-handshake (test 16 "Dataskærm controller")

To MAME-`i82730.cpp`-bugs blokerede POST-videotesten; begge rettet, ingen rc759-regression
(PICCOLINE TEST renderer stadig). Branch `rc750-rom-font-text`.

1. **EONF/SINT fyrede aldrig** → mailboxen blev aldrig opdateret. Fixet allerede skrevet til
   rc759 (MYRESNAK-freeze, `[[reference_82730_channel_attention_myresnak_fix]]`, commit
   `2a4b21cdbdb`) men manglede i dette træ. **Cherry-picked hertil** (e94bd02f856): clamp
   end-of-frame-housekeeping til `screen().height()-1` + div-by-zero-guard på frame_int_count.
   Uden den: intet SINT → SINT-ISR'en (0xFA0F7) kører aldrig → mailbox (m_cbp+20) står stille.
2. **LOAD CBP ryddede forkert bloks busy** (nyt fix, commit `07ff837f61b`): `execute_command()`
   for cmd 5 satte `m_cbp` = ny pointer og ryddede via den fælles afsluttende `write_word` kun
   busy på den NYE blok. Den blok CPU'en pollede (fast mailbox @ F000:2000-området) fik aldrig
   sin busy ryddet → hang. Fix: ryd den oprindelige bloks busy straks pointeren er latchet, load
   + eksekvér ny blok (rydder sin egen busy), `return`.

SINT-ISR'en (0xFA0F7) semantik: lock-xchg busy @F2000 → skriv cmd 0x08 (READ STATUS) @F2001 →
CA 0x240 → læs mailbox+0x14 (m_cbp+20 interrupt-cause); `test ax,64h` (RDC|RCC|DBOR fejl-bit),
`jne` → errorcode 0x10; ellers tæl [135h] op; slut skriv 0x230 (unmapped/harmløst).

**Verifikation (headless, `-video none`, PC-histogram + mailbox-dump via lua):**
- Pre-fix: mailbox-busy stuck **01**, SINT-ISR (FA110/FA14B) kører ALDRIG.
- Post-fix: busy rydder til **00**, SINT-ISR kører+iret hver frame, mailbox-status = 0x0008 (EONF,
  ingen fejl-bit 0x64 → ISR tæller "god frame", sætter IKKE errorcode 0x10). CPU passerer test 16.

**NY NÆSTE BLOCKER — floppy-læsning (WD1797 @ 0x200 + drive-select @ 0x260):** efter test 16
poller POST FDC-status i timeout-løkke (0xFD72E `in 0x200; test al,1; loop`), men floppy-handlerne
er stadig PROVISORISKE (aldrig eksekveret) → ingen boot fra SW1500_2.0.imd. Selftesten kører
stabilt (banner + POST-cyklus), ikke frosset. Probe-scripts: `scratch/rc750_status_probe.lua`,
`rc750_cbp_probe.lua`. Kør: `-flop1 floppies/SW1500_2.0.imd`.

## 2026-09-03 (forts.): POST-fejl dekodet via SERVICE-MANUAL + hardware-modellering

**Strategi (user):** lav nok hardware til at selvtesten LYKKES (ikke spring-over — CTRL+ALT+SLET
virkede ikke). Iterér: kør → læs errcode `[120h]` (**DS=0!** variablene ligger i lav-RAM) →
tilføj hardware → gentag. Probe: `scratch/rc750_decide.lua`.

**Service-manual gemt i projektet:** `rc700-gensmedet/docs/rc750/` (Bits:30002753, OCR'et dan+eng
via Docker `jbarlow83/ocrmypdf` + `dan.traineddata`). **Fejlkode-tabel** ([120h], hex):
`0x13`=19 systemparam-checksum · `0x18/0x19`=24/25 printer port kontrol/data · `0x1A`=26 diskette ·
`0x1B`=27 CRC · `0x1E-0x22`=30-34 Winchester · `0x23`=35 SCSI.

**Rettet (commit `5efba8f24ea`, master):**
- `0x230`=82730 irst (som rc759; ISR ack'er hver frame) — IKKE 0x210 (rettede tidligere fejl-antagelse).
- `0x210`=FDC-kontrol-latch (0x40|bits, readback bit2-3; bruges i disk-læse-sti FD5DD før READ SECTOR).
- `0x250`/`0x260`=Centronics printer data/kontrol readback-latches → printer-test (fejl 24/25) består.
  (Gamle `fdc_drive`@0x260 var fejlnavngivet — det ER printer-kontrol.)
- Resultat: errcode **25→19**. POST forbi printer-testen.

## 2026-09-03 (forts.): NVRAM systemparam-checksum LØST (fejl 19 forbi) → nu fejl 39

**Autoritativ kilde:** `rc700-gensmedet/docs/PARTNER_Programmers_Guide_v3_jun1986.pdf` (284 sider,
tekstlag). §3.2 (s.34-35, Table 3-2 "NVM format"): checksum = sum af NVM **block 0,1,2** (IKKE block 3)
mod 256 == **0AAH**. `mem[0]` er checksum-byten (`nvm_read(block0,offset0)`), justeret så summen holder.
Byte-layout (s.32,34): byte **25 = load device** ('A'..'D' floppy / 'N' net); byte 20=floppy motor-idle,
22=fg-farve, 69=cursor-config, 71-75=MF144, 76-127 reserveret.

**FDBAE afkodet (ROM `FAF52`+`FDBAE`+`FDBD2`=address_block):** hver "byte" al i block b læses som to
nibble-porte `0x80+al*4` (høj) og `+2` (lav); **block b vælges via port 0x70 (PPI port A) bits 6-7**
(FDBD2 RMW). I MAME-modellen = `mem[b*32+al]`, så checksum = `sum(mem[0..95]) mod 256`.

**Bug (root cause):** RC750 vælger NVM-block via **port 0x70/PPI port A** (address_block), men delt
`rc75x` fangede kun banken fra **port C bits 4-5** (Piccoline-wiring). RC750 driver aldrig port C-banken
→ banken sad fast på 2 → checksum-testen læste block 2 (nul) tre gange → sum 0 → fejl 19. Desuden gav den
delte Piccoline-seed sum 0x2A, ikke 0xAA.

**Fix (rc750.cpp, KUN RC750 — rc759/rc75x urørt, RC759 smoke-booter fint):**
- Port A er **OUTPUT-latch** på Partner (selvtest 18 = walking-bit readback på port 0x70 via 8255 output-
  latch — carve IKKE port 0x70 væk fra PPI'en, det brød test 18!). Fang block via `out_pa_callback` →
  `nvm_block_w`: `m_nvram_bank=(data>>6)&3`. Fjernede bank-latch fra `ppi_portc_w`.
- RC750-specifik seed `nvram_init_partner` (sat via `m_nvram->set_custom_handler` efter
  `add_common_devices`): `mem[25]=0x41` ('A'), `mem[0]=0x69` → sum(0..95)=0xAA. Rører ikke delt seed.
- **Resultat:** live checksum=AA, errcode **0x13→0x27**, banner→**11 stjerner**→ERROR 00039.

## 2026-09-03 (forts.): SELVTEST FULDT BESTÅET → BOOTLOADER (fejl 39 løst)

**Fejl 39 (0x27) = lokalnet-kort giver ikke interrupt** (user-indsigt). Testen `fb0ad`: `in 220h; not al;
test al,10h; jne run-LAN-test`. Port 0x220 **bit4=0 = "LAN-kort tilstede"** → armer netværks-interrupt-vent
(via umappet port 0x100, ISR `fb01e`) → timeout → fejl 39. Winchester-testen `fb7f9` er gated af `[12Dh]`
bit 0x800. Port 0x220-bits: **6-7**=monitor-jumpers (f9e17 inverteret), **5-0**=device-presence (fa8fe-scan,
0=installeret).

**Fix (rc750.cpp, commit `66730659f78`): modellér ingen lokalnet + ingen Winchester** →
`fdc_sense_r` returnerer **0xff** (alle presence-bits fravær; monitor-jumpers uændret) i stedet for 0xef.
Selvtesten springer LAN-testen over og kører **fejlfrit (errcode 0)** → boot-ROM viser:
```
BOOTLOADER  VERSION 4.3
LOADMEDIUM: DRIVE A
INSERT DISKETTE
```
Den vælger **DRIVE A** fra den seedede NVM load-device-byte (mem[25]='A') og beder om en boot-diskette.
Issue #46 lukket (løst-ved-config, IKKE port-0x100-modellering). Fra ikke-fungerende driver → fuld POST →
bootloader-prompt.

## 2026-09-03 (forts.): BOOTER CP/M! + skærm-fidelity (mono/intensitet/font)

**RC750 booter nu CP/M fra floppy** (SW1500_2.0.imd i drev A) — bruger menusystemet, `DIR` virker.
Floppy-læsestien (#45) fungerer i praksis. Commits: `66730659f78` (LAN/Winchester absent → BOOTLOADER),
`b8de89b5563` (mono default + intensitet).

**Skærm-fidelity (user-observationer, commit `b8de89b5563`):**
- **Monitor-type**: Partner understøtter BÅDE mono og farve. Default var "Color" (rc750.cpp `config`-port
  bit5 → PPI port B/0x72) → firmware tolker attribut-byte som fg/bg-farve-nibbles → fg=0 usynlig. Sat default
  til **Monochrome** (matcher amber P3-skærm). Farve-dekodning = issue #47.
- **Fed/intensitet**: hver display-word high-byte = char-attribut. Bit 6 (word-bit 14) = høj-intensitet
  ("bold") på mono. Renderes nu som lysere amber `0xff,0xe0,0x60` (normal `0xff,0xb0,0x00`). Banner+menu-titler
  =0x40, hint-linjer =0x60 (bit 5 ekstra).
- **Usynlige tegn (issue #48, hoved-blocker for læsbar CP/M):** RC750-driveren har **ingen char-gen-ROM** —
  kun boot-ROM'erne. `init_rom_font` udtrækker kun 47 diagnostik-glyffer (**ASCII 0x2A-0x5A = kun STORE
  bogstaver**). Små bogstaver (0x61-0x7A) + menu-ramme (0x88/0x89/0x8D) mangler → usynlige. Bevis: menu-buffer
  = "Tryk A1 for specialfunktioner" men kun T/A1 synlige. 82730 pixel-RAM (m_vram @0xD0000) er TOM (CP/M loader
  ingen soft-font). Fix: skaf/dump Partner char-gen-ROM, ELLER find font-upload-stien.

**Usynlige tegn LØST (stopgap, commit `9fb4d7f0d4e`):** udtrak den fulde RC759-soft-font fra Piccolinens
82730 pixel-RAM (boot rc759 m. disk, dump `program:0xD0000`, ASCII 0x20-0x7f, 7px, bit15=leftmost) →
konverteret til Partner-glyph-format (`>>9 & 0x7f`, shift 1) i `src/mame/regnecentralen/rc759_font.ipp`.
`init_rc759_font()` udfylder KUN de glyffer diagnostik-fonten mangler (kaldes efter `init_rom_font`), så POST
beholder native glyffer. **Installations-menuen er nu fuldt læsbar** ("Diskette vedligeholdelse", "Tryk ESC
for at returnere"...). Udtræks-lua: `scratch/rc759_fontextract.lua`. #48 forbliver åben for den ÆGTE
Partner char-gen (ramme-tegn 0x80+ mangler stadig).

## 2026-09-03 (forts.): Partner font-arkitektur afklaret (RcFont-manual)

**RcFont** (SW1435, manual Bits:30002765 gemt i `rc700-gensmedet/docs/RcFont_Brugervejledning_v1.3_30002765.pdf`;
disk-image `mame/floppies/SW1435_RcFont_1.3.imd`) er et font-værktøj der kører på **BÅDE Partner og Piccoline**.
Afgørende fund: Partner bruger **IKKE en hardware char-gen-ROM** — den bruger et **soft-font pixel-lager**
(pixellager) som Piccoline, bare større celle:
- Skærmens tegngenerator = pixel-lager med **4 font-banke** (Standard 1/2, Alternativ 1/2).
- Fonte op til 16×16; **Partner = 9×14** (matcher den høje celle), Piccoline mindre. Derfor sidder RC759-
  backfill-glyfferne lidt højt (de er mindre end den ægte 9×14-font).

**Emulerings-implikation (#48):** vores RC759-style pixel-RAM @`0xD0000` (delt `vram`) forbliver TOM efter
Partner-boot → vi falder tilbage på diagnostik-font + RC759-backfill. Ægte fix: find Partnerens char-gen-
pixel-lager-adresse / font-load-sti (boot-ROM'en kopierer formentlig font fra ROM til pixel-lageret et andet
sted end 0xD0000), map den, og render derfra → ægte 9×14 Partner-font, stopgap kan droppes.
RcFont-disken kan dekodes (IMD→CP/M: RCFONT.CMD, CHARSET.CMD, fonte DK/US/STD/OVH×{88,99,119,710,914},
printer-fonte RC603/604/605) men læses ikke af drev B i MAME (floppy-format #45).

## 2026-09-03 (forts.): font sættes af XIOS, ikke boot-PROM (DK914 = 9×14)

**User-hypotese (bekræftet af fund):** den fulde skærmfont ligger IKKE i boot-PROM'en — det er **XIOS'ens**
(CCP/M-86 BIOS) opgave at loade den i char-gen pixel-lageret ved opstart. Understøttes af:
- Diagnostik-boot-ROM'ens font (0x7f, 55 records) = store bogstaver + cifre + tegnsætning (0x2A-0x5A) +
  **ramme-tegn 0x80-0x83, 0x90-0x93** — INGEN små bogstaver.
- SW1500 har en `XIOS CON`-fil. Med *install-disken* loader XIOS'en åbenbart ikke den fulde font (bruger
  boot-PROM'ens store-font); en *produktions-system-disk* ville loade DK914.
- Emuleret char-gen (m_vram@0xD0000) tom; ingen font i RAM (scan finder kun RAM-testmønstre/display-buffer).

**RcFont-fontnavne = DIMENSIONER:** `DK914`=9×14 (**Partner**), `DK710`=7×10 (Piccoline), `DK88`=8×8,
`DK99`=9×9, `DK119`=11×9. Så **DK914 på RcFont-disken (`mame/floppies/SW1435_RcFont_1.3.imd`) ER den ægte
Partner-skærmfont.** Blind mønster-scanning af disken narres af komprimerede/repeterende sektorer — kræver
ordentlig CP/M-86-directory+extent-parsing + RcFont-font-filformat (dokumenteret i manualen).

**To veje til ægte Partner-font (#48):** (a) ekstrahér DK914 fra RcFont-disken (CP/M-parse + font-format) og
brug som glyph-tabel; (b) find en produktions-system-disk og tracér XIOS'ens char-gen-skrivning for at
modellere den rigtige font-load-sti. Indtil da: RC759-backfill (7×10-agtig, sidder lidt højt) er stopgap.

## 2026-09-03 (forts.): FONT-MEKANISMEN FUNDET — XIOS INT 0x28 / define_font=52

**Kilde:** PolyPascal-kildekode på RcFont-disken (CHARSET, `define_screen_font`), fundet ved at dekode IMD→
CP/M-blob og søge `swint`. Mekanismen (bekræfter user-hypotesen 100%):
```pascal
CONST xios=$28; define_font=52;
  mask:=$FFFF shl (16-cols); ones:=(NOT mask) shr 1;
  FOR i:=1 TO rows DO charfont[i]:=charfont[i] AND mask OR ones;
  reg.ax:=define_font;                          (* XIOS ekstra-funktion 52 *)
  reg.cx:=(destination-1)*256+ORD(character);   (* destination=font-bank 1..4 *)
  reg.dx:=ofs(charfont[1]); reg.ds:=seg(charfont[1]);  (* DS:DX -> rows words, cols MSB-just. *)
  swint(xios,reg);                              (* INT 0x28 *)
```
Så skærmfonten loades **ét tegn ad gangen via INT 0x28, AL=52 (define_font)**: CX=bank×256+tegnkode,
DS:DX→`rows` 16-bit words (`cols` pixels MSB-justeret; Partner 9×14 → mask 0xFF80). INT 0x28-vektor →
dispatcher @phys **0x074A5** (CS=0x0684), indekseret på AL.

**REN FIX (#48):** intercept `INT 0x28 / AL=52` i rc750-driveren → fang hver glyf (DS:DX) i render-glyph-
tabellen ved CX. Renderer den autentiske 9×14-font uanset hvor XIOS'ens char-gen ligger, og dropper RC759-
stopgap'en. Åbent: om SW1500 *install*-disken laver en fuld define_font-sweep (m_vram@0xD0000 tom + ingen
font-grid fundet i RAM → måske bruger den kun boot-ROM'ens store-font). Intercept-hook'en svarer direkte.
DK914-diskfilerne er små partielle sæt (384 B), IKKE den fulde font — ikke brugbar som kilde.

**Metode-note:** blind mønster-scanning af RAM/disk efter fonten narres af strukturerede data (RAM-test,
display-buffer, kode) — brug hellere API-intercept (INT 0x28/52) eller søg efter *kendte* glyf-bytes.

## 2026-09-03 (forts.): FONT-KILDEN LØST — boot-ROM loader soft-font i pixel-lager

**Afgørende eksperiment:** RC759 **uden diskette** (kun boot-ROM POST) har den fulde font (1536 words =
96 tegn × 16 rækker, inkl. store OG små bogstaver) i pixel-lageret **0xD0000**. Så **RC759's boot-ROM
indeholder + loader den fulde soft-font ved opstart** (ingen disk). RC750 med SAMME SW1500-disk: 0xD0000 TOM.
Forskellen er MASKINEN (boot-ROM), ikke disken.

**Konklusion (velbegrundet):**
- **Fonten kommer fra BOOT-ROM'en**, som kopierer den ind i pixel-lager-char-gen'en (0xD0000) ved opstart —
  IKKE en separat font-PROM (user-gæt var tæt, men det er hoved-ROM'en). Bevist på RC759.
- Vores RC750-ROM er **DIAGNOSTIK-ROM'en** (rod398/399, "TEST V.4.3") — en test-ROM der IKKE loader fonten
  (kun 47 store-bogstav-glyffer @0x7f til banneret; 0xD0000 tom; dens XIOS-dispatch har `define_font`=52 NULL).
- En **produktions-RC750-boot-ROM** ville loade den fulde 9×14-font (som RC759 gør). Den har vi ikke.
- **82730-programmering tænd→menu:** MODE SET (geometri) → LOAD INTMASK(0x02) → LOAD CBP=0x52000 (display-
  liste) → START DISPLAY → poll READ STATUS. 82730'eren loader IKKE char-gen'en (ekstern, i dot-clock-stien).

**Konsekvens (#48):** for den ægte Partner-font kræves en **dump af en produktions-RC750-boot-PROM**. Indtil da
er RC759-backfill'en faktisk tæt på autentisk (det ER RC759's egen boot-ROM-font, bare 7×10 vs Partner 9×14).
Intercept-vejen (INT 0x28/52) er blindgyde her: install/diagnostik-XIOS'en implementerer ikke funktionen, og
read-tap fanger ikke 80186-INT/opcode-fetch.

## 2026-09-03 (forts.): ÆGTE PARTNER-FONT LØST — pixel-hukommelse @0xF0000

**RC750-autoritativt** (Partner Programmer's Guide §4.1.2, som jeg gemte): 82730-display-ordet adresserer en
**32-byte blok i 32KB pixel-hukommelsen @F000:0000**; i alfanumerisk mode ER pixel-blokkene tegngeneratoren
(14 rækker, ét 9-px word pr. linje, bit 15=venstre). **Fonten lå der hele tiden** — jeg kiggede på 0xD0000
(RC759's placering, som Partner IKKE bruger). Mit RAM-dump stoppede ved 0xDFFFF, så jeg så den aldrig.

**Fix (commit `2d6549a90d5`):** gav 0xF0000-RAM'en share "pixmem" + `optional_shared_ptr m_pixmem`; render
læser glyffen direkte fra `m_pixmem[(kode&0x3ff)*16 + lc]`, 9px i bit 15..7. Display-ord: bits 0-9=blok/kode,
bits 10-14=palette/intensitet. **Både banner OG CP/M-menu renderer nu den ægte 9×14 Partner-font** med korrekte
små bogstaver + ramme-glyffer. Fjernede RC759-backfill-stopgap'en (rc759_font.ipp, init_rc759_font) — overflødig.
RC759 uændret (bruger m_vram@0xD0000, kommer aldrig i ROM-font-stien).

**Lærdom:** metodisk fejl tidligere — jeg antog RC750=RC759 (char-gen@0xD0000) og drog ugyldige slutninger fra
RC759's opførsel. RC750/RC759 er SØSKENDE, ikke samme maskine. Den RC750-autoritative guide gav det rigtige
svar (0xF0000). Font kom fra firmwaren (uanset CCP/M 2.0-alder — den ER loadet ved boot).

**Rest på #48:** RC-logo-tegnet øverst-venstre ("IE750" i stedet for "RC750") — ramme/logo-glyf-detalje, minor.

**NÆSTE:** #47 (farve/palette-dekodning — bits 10-14); #45 (floppy/drev B); #48-rest (logo-tegn, minor).

## Byg/kør
```
cd mame && make SUBTARGET=regnecentralen DEBUG=1 \
  SOURCES="src/mame/regnecentralen/rc759.cpp,src/mame/regnecentralen/rc750.cpp" \
  TOOLS=1 SYMLEVEL=3 SYMBOLS=1 OSD=sdl -j10   # REGENIE=1 ved fil-tilføjelse
./regnecentralend rc750 -rompath roms -window -skip_gameinfo -sound none
```
`-sound none` fjerner SN76489-klik. macOS har ikke `timeout`. Skærm læses fra RAM via lua
(char-koder ASCII). Diff: rc750.cpp (ROM-load, F000-RAM, 0x210=irst) + i82730.cpp (DIP-guard).
Ikke committet/pushet.

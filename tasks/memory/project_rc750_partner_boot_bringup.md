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

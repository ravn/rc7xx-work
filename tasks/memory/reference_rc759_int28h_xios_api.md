---
name: reference_rc759_int28h_xios_api
description: RC759 Piccoline INT 28H udvidet XIOS/BIOS interface — samtlige 54 funktioner (0..53)
metadata:
  type: reference
---

# RC759 Piccoline INT 28H Extended XIOS API

Dokumentation for `INT 28H` systemgrænsefladen i Flemming Kraglunds Piccoline XIOS.

Kilder:
- **RC759 Piccoline Programmer's Guide v2**, Appendix A: *Int-28h Function Interface PICCOLINE* (side 183–202).
- **Binæranalyse & kildekode**: [tasks/rc759-xios/mod4_xios.asm](file:///Users/ravn/z80/tasks/rc759-xios/mod4_xios.asm).
- **Udtømmende funktionskort**: [tasks/rc759-xios/int28h_functions_map.md](file:///Users/ravn/z80/tasks/rc759-xios/int28h_functions_map.md).

---

## 1. Kaldemekanisme & Dispatcher

* **Dispatcher**: Fil-offset `0x07831` (`CS:0C91h`).
  - Indlæser SYSDAT segment fra `[cs:0xc06]` i DS.
  - Finder aktiv UDA segment via Ready List Root (`[cs:0x68]`) i ES.
  - Tager funktionsnummer `AL = 0..53`.
  - Udfører indirekte tabelkald: `call word [cs:bx + 0xcac]` (hvor `BX = AL * 2`).
  - Afslutter med `pop ds; iret`.
* **Hop-tabel (`int28h_jump_table`)**: Fil-offset `0x0784C`–`0x078B7` (`CS:0CACh`, 54 words = 108 bytes).
* **Segment-basis (`xios_code_base`)**: `0x06BA0`. Hver tabelpost er: `dw target - xios_code_base`.

---

## 2. API Oversigt (Funktion 0–53)

| Område | Funktioner | Beskrivelse |
|---|---|---|
| **Skærm & Grafik** | **0** (`set_graphics_mode`)<br>**1** (`set_char_mode`)<br>**2** (`smooth_scroll_step`)<br>**31** (`def_palette`) | Skift mellem 82730 tekstvisning og bitmapped grafik (640x400). Funktion 2 udfører 1 scanline blød rulning synkroniseret med VSYNC (kaldes af `SCROLL.RSP`). Funktion 31 programmerer 16-farve paletten. |
| **Font & Tegnsæt** | **20** (`define_alt_char`)<br>**51** (`get_font`)<br>**52** (`def_font`) | Hent og definer 16-byte tegnmønstre direkte i Piccolines font-RAM (`0x910A`/`0x90F3`). |
| **Konsol & Buffer** | **21/22** (Display list pointer)<br>**35** (`write_str_conbuf`)<br>**36** (`set_cursor_pos`)<br>**37/38** (Attributter)<br>**39** (`update_screen`) | Direkte manipulation af virtuel konsolbuffer og Intel 82730 displaylister udenom BDOS. Flytning af hardwarecursor (BH=række, BL=kolonne). |
| **System & Konfig** | **3** (`get_nvram_copy`)<br>**4** (`get_autoconfig_map`)<br>**19** (`get_16ms_timer`)<br>**53** (`get_xios_version`) | Hent pointers til NVRAM (`SYSDAT:4896h`) og Auto-Configuration Map (`SYSDAT:4225h`). Højopløselig 16 ms timer (DX:AX sekunder, CX ticks). XIOS version returnerer AX=`0x8523` (v2.3 marts 1985), BX=`0x0206`. |
| **Floppy Disk** | **5** (Rekalibrer spor 0)<br>**8/9** (Step ind/ud)<br>**10/11** (Skriv/læs helt spor)<br>**13** (Diskfejl-statistik) | Lavniveau spor-I/O til WD2797 controller brugt af formatering og diagnose. Stakparametre: Drev, Hoved, Cylinder, Bytecount, DMA seg:off. |
| **Seriel (iSBX 351)** | **23** (Status)<br>**24** (Initialiser)<br>**50** (Reset) | Styring af det valgfri serielle multimodul (RS-232 kanal B). |
| **Båndoptager** | **26/27** (Læs/skriv filhoved)<br>**28/29** (Læs/skriv datablok)<br>**40** (Skriv EOF) | FSK-moduleret kassettebånd-I/O med 128-byte headers og blok-checksum. |
| **Perifere & Netværk**| **12** (Lydchip SN76489, port 0x50)<br>**30** (Musestyring: init, deinit, delta X/Y)<br>**41** (DPC parallelbus reservation)<br>**42** (Delt netværksdisk reservation) | Kontrol af lydfrekvens/dæmpning, busmus og delt diskadgang i skolenetværk. |
| **Reserverede stubs** | **6, 7, 14, 15, 16, 17, 18, 25, 32, 33, 34, 43..49** | Returnerer direkte (`ret` ved `0x078B8`). |

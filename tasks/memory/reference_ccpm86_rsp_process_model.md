---
name: reference_ccpm86_rsp_process_model
description: Concurrent CP/M-86 Resident System Process (RSP) procesmodel, GENCCPM pakning og placering
metadata:
  type: reference
---

# Concurrent CP/M-86 Resident System Processes (RSP)

Dokumentation for RSP-arkitekturen i CCP/M-86 3.1 og dens realisering i RC759 Piccoline `ccpm.sys`.

Kilder:
- **Digital Research Inc.** CCP/M-86 3.1 kilder (`scratch/ccpm31-src/D7/` GENCCPM, `scratch/ccpm31-src/D9/` CLOCK).
- **SW1400 distributionsdisketter**: `scratch/tmp/dist/` (`TMP759.RSP`, `CLOCK.RSP`, `PIN.RSP`, `VOUT.RSP`, `SCROLL.RSP`).
- **Binæranalyse**: [tasks/rc759-xios/distribution_sw1400.md](file:///Users/ravn/z80/tasks/rc759-xios/distribution_sw1400.md).

---

## 1. 8080 Hukommelsesmodel & Ingen Relokeringstabeller

* **Fravær af Gruppe 7 (Relocation Records)**:
  - Filer med `.RSP` extension på distributionsdisketterne har standard 128-byte CMD-header, men **ingen relokeringstabel** (Gruppe 7 = 0 bytes).
  - RSPs kører under **8080-modellen** i 8086: Alle segmentregistre er identiske (`CS = DS = ES = SS`).
  - Al adressering er position-independent (relative hop, lokale stakoffsets eller absolutte software interrupts som `INT 0xE0` BDOS og `INT 0x28` XIOS).
  - Processen kan placeres på enhver vilkårlig 16-byte paragrafgrænse uden koderelokering.

---

## 2. GENCCPM Pakkemekanisme

Under kørsel af Digital Researchs systemkonfigurationsværktøj `GENCCPM.CMD`:
1. **CMD-header strippes**: Den 128-byte filheader fjernes.
2. **Data Segment foranstilles**: `GENCCPM` opretter og udfylder en procesdeskriptorblok for hver proceskopi:
   - `RSPHDR` (8 bytes): Kædepeger (`p_link`) til næste RSP i systemet.
   - `PD` (Process Descriptor, 48 bytes = `0x30` bytes): Procesnavn (f.eks. `"CLOCK   "`), prioritet, tilstand (`ps_run`), UDA paragraf-offset.
   - `UDA` (User Data Area, 256 bytes): Initial stakpeger (`p_sp`), segmentkopier, `INSYS` flag og stakområde (`0xCC`-initialiseret).
3. **Code Segment placeres bagefter**: Koden fra `.RSP` filens kodesegment lægges umiddelbart efter UDA'en.
4. **Linked List**: Alle RSPs kædes sammen i en liste, hvor `SYSDAT:0x0042` (`sd_rspseg`) peger på den første proces.

---

## 3. Placering i RC759 `ccpm.sys` (77.568 Bytes)

I `CCPM1.SYS` (vores målbinær) optager de 5 RSPs området fra `0x0FD40` til `0x12F00`:

| Proces | Kildefil | Data Segment | Code Segment | Samlet | Funktion |
|---|---|---|---|---|---|
| **TMP759** | `TMP759.RSP` | `0x0FD40`– | –`0x1142F` | 5.872 B kode | CLI og kommandofortolker for Piccoline. |
| **CLOCK** | `CLOCK.RSP` | `0x11430`–`0x1156F` (320 B) | `0x11570`–`0x115EF` (128 B) | 448 B | Venter på Flag 2; opdaterer TOD og konsolstatuslinje. 100% matchet mod DRI `CLOCK.A86`. |
| **PIN** | `PIN.RSP` | `0x115F0`–`0x117CF` (480 B) | `0x117D0`–`0x124CF` (2.672 B) | 3.152 B | Process INput: tastatur- og linjeeditering. |
| **VOUT** | `VOUT.RSP` | `0x12240`–`0x125DF` (928 B) | `0x125E0`–`0x12D1F` (1.856 B) | 2.784 B | Virtual OUTput multiplexer: håndterer skærmudskrift for virtuelle konsoller. |
| **SCROLL** | `SCROLL.RSP` | `0x12D20`–`0x12E5F` (320 B) | `0x12E60`–`0x12EFF` (112 B) | 480 B | Blød rulning: vækkes af Flag 4; driver scanline-scroll via `INT 28H, AL=2`. |

---

## 4. Standalone .RSP-filformat & byte-verificerede NASM-byg (2026-11-26)

Den stående `.RSP`-fil på disk (fx `PIN.RSP`) er **CMD-format uden
relokerings-poster**: `[128 B CMD-header][grupper i fil-rækkefølge][nul-padding
til multiplum af 128]`. Headerens gruppe-deskriptere (`<BH` ved offset i*9,
formular 1=Code 2=Data) angiver grupperne; **i filen ligger Code først
(@0x80), Data efter koden** — modsat placeringen i ccpm.sys (afsnit 3), hvor
GENCCPM har sat PD+UDA foran koden. Ingen FIXUP-poster nogen steder (8080-model,
afsnit 1).

Orakler + byg (alt verificeret 2026-11-26):
- **Orakler**: `tasks/rc759-xios/dist/genccpm-kit/` — 25 filer ekstraheret
  fra SW1400 disk2 (`scratch/rc759-pce/images/disk2.img`): de 5 .RSP'er,
  XIOS1/4.CON, GENCCPM.CMD, CC.PRM/CPNET.PRM/IS.PRM, config-kilder.
- **NASM-mastere**: `tasks/rc759-xios/{clock,pin,scroll,tmp759,vout}_rsp.asm`
  + `rspsrc/`-includes. **5/5 byte-identiske** mod oraklerne.
  Verifikation: `tasks/rc759-xios/build_and_verify_rsp.sh` (lås i pre-commit
  hook pr. 2026-11-26).
- **Annoteringsgrad**: pin fuldt annoteret (kode+data); vout/tmp759 data
  annoteret; clock/scroll raw-dump (clock har DRI-kilde, se nedenfor).
- **GENCCPM-baseline** (uforanderlige DRI-redskaber, JEMEN frem for
  NASM-genbyg): `dist/genccpm-kit/README.md`.

DRI-kilder og toolchain (alle i workspacet — LEDIG efter at have genledt
layout ovenfra fra binærfilene først; se `feedback_check_memory_before_coding`
incidenten):
- `scratch/ccpm31-src/D1-D12` = ORIGINAL DRI CCP/M-86 v3.1-kilde: D1-D3
  kernel (.A86/.DEF incl. SYSDAT.DAT, SYSTEM.DAT), D7 = GENCCPM fuld
  C-kilde (GENC1-6.C; `xfer_rsp`-familien i GENC3.C ~l. 295-421 bekræfter
  ovenstående pakkemekanisme), D9 = RSP-kilder (CLOCK.A86 m.fl.),
  D11/D12 = ASM-86.
- **ASM86 (DRI/CCP-M-86-assembleren) er den korrekte assembler til
  DRI-kilderne**: headless `EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A
  scratch/emu2-rasm86/emu2 ASM86.CMD "CLOCK.A86"` → 0 fejl, clock.h86
  (1033 B). Parameter-kwick: almindeligt filnavn; `CLOCK$SZPZ` misfortolkes.
- **DR C's RASM86 durker IKKE på DRI-kilder**: 5x "ILLEGAL EXPRESSION
  ELEMENT" på `dw offset uda/10h` (RASM86 er OMF/DR-C-ruten iflg.
  `reference_drc_toolchain_architecture.md`; ASM86 er .H86-ruten).
  "rasm86 til DRI-modulerne" skal altså forstås som ASM86 unless the goal
  is DR C-style relocatable output.

---
name: reference_rc759_xios_unification_architecture
description: RC759 XIOS 2.3 master source unificering — parametrisering, eliminering af DELTA-makroer, rasm86-kompatibilitet og 1 vs 4 virtuelle konsoller
metadata:
  type: reference
---

# RC759 XIOS Master Source Arkitektur & Forening

Dette dokument beskriver arkitekturen, opbygningen og læringen fra foreningen af Digital Research CCP/M-86 XIOS driveren for Regnecentralen RC759 Piccoline (`tasks/rc759-xios/xios_code.asm`).

Kildekoden er samlet fra to separate binære distributioner:
* **XIOS1.CON** (25.728 bytes) – 1 virtuel konsol (standard Piccoline).
* **XIOS4.CON** (29.440 bytes) – 4 virtuelle konsoller med fuld vinduesstyring og display-lister.

Begge versioner kompileres nu fra **samme symbolske kildekode** (`tasks/rc759-xios/xios.asm` $\rightarrow$ `xios_code.asm`) ved at angive `-DNUM_VIR_CONS=1` eller `-DNUM_VIR_CONS=4` til NASM i Docker-containeren `rc759-nasm`. Resultatet er **100% byte-for-byte identisk** (0 bytes diff) mod originalerne.

---

## 1. Forskelle mellem XIOS1 og XIOS4

XIOS4 fylder præcis **3.712 bytes mere** end XIOS1. Forskellen skyldes udelukkende multi-konsol og vindueshåndtering:

| Område | XIOS1 (`NUM_VIR_CONS=1`) | XIOS4 (`NUM_VIR_CONS=4`) | Forskel |
|---|---|---|---|
| **Allokeret bufferplads** (`XT_ALLOC_PARAS`) | 500 paragraffer (`0x01F4` = 8.000 B) | 1280 paragraffer (`0x0500` = 20.480 B) | Større arbejdshukommelse til 4 skærmtilstande |
| **Z-Order permutationer** (`ZORDER_LIST_SIZE`) | 2 kombinationer ($2^1$) | 16 kombinationer ($2^4$) | Forreste/bageste vindueslag |
| **Konsol-skifttaster** (`loc_07D2D..loc_07D2F`) | Stub (`jmp short loc_07CCC`) | Fuld konsol-switch og RTM-hændelse | Tastetryk til valg af aktiv konsol |
| **INT 28h funktion 16..24** (`xios_function_table`) | Stubs til `xios_int28_stub_ret` | Komplet vindues- og display-manager | Opret, flyt, vælg, konfigurer konsolvinduer |
| **Vindues-clipping** (`xios4_clip_map`) | Dummy stubs | 3.300 bytes klipningskort og rektangel-beregning | Matematisk klipning af overlappende konsoller |
| **Konsol-deskriptorer (CCB)** | 1 deskriptor (148 bytes) | 4 deskriptorer (592 bytes) | Tilstand, markør, farver og buffer for hver konsol |
| **Display lister (i82730)** | 1 sæt display lister | 4 sæt display lister | Hver konsol har sin egen datastrøm til skærmcontroller |
| **Statuslinje & beskeder** | Tekst: `"** Kun 1 konsol..."` | Fuld 4-konsol statuslinje og dynamisk vinduesoversigt | Brugerfeedback |

---

## 2. Eliminering af DELTA-Makroer

Under disassembly og foreningsprocessen blev der oprindeligt indført en række midlertidige syntetiske forskydninger (`DELTA_...`), fordi XIOS4 skubber samtlige efterfølgende tabeller og rutiner med varierende antal bytes.

Disse forskydninger er nu **fuldstændigt elimineret** og erstattet af ægte symbolske mærker:

1. **`DELTA_VMENU_PROLOGUE` (50) & `DELTA_VMENU_TBL` (71)**:
   - Erstattet med symboler i VMenu-parameterblokken for markør, baggrund og invers video.
2. **`DELTA_VMENU` (74)**:
   - Erstattet med symbolske felter i terminalparameter-strukturen (`0x1560`).
3. **`DELTA_WINDOW` (451)**:
   - Forskydning genereret af den udvidede Sektion 4A. Erstattet af labels på musetilstande, tastaturbuffere og CCB-variable (`0x2b53..0x2b5b`).
4. **`DELTA_VIDTBL` (789)**:
   - Forskydning fra Sektion 4C (CCB og display lister). Erstattet af dynamisk alias:
     `%define xios_screen_state_buf (xios4_clip_map + 0x780)` (XIOS4) vs `xios1_screen_state_buf` (XIOS1).
5. **`DELTA_49FA` (906)**:
   - Erstattet af symbolske mærker på boot- og fejlbeskeder (`0x49FA..0x4BD0`).
6. **`DELTA_TABLES` (909)**:
   - Omfattede 179 symbolske tabeller for floppy (Group A), DPB/BCB (Group B/C), printer/CRT/timer (Group D/E) og diagnostik/VMenu (Group F).
   - Alle 475 rå adresse-opslag i koden er omdannet til symbolske instruktioner.
7. **`DELTA_TAIL_PRE` (3665) & `DELTA_TAIL` (3668)**:
   - Erstattet af symbolske kø- og MX-deskriptorer (`0x593B..0x5B15`) samt floppy-drevparametre og linjebuffere (`0x5FA4..0x6228`).

Assembleren beregner nu automatisk samtlige adresser via labels. Der findes **0 hårde adresse-offsets** i kildekoden.

---

## 3. Kompatibilitet: Digital Research RASM-86 vs NASM (`rasm86.inc`)

Originalen blev kompileret med Digital Researchs egen **RASM-86** assembler.

* **Direction-bit uoverensstemmelse**: For 8086 register-til-register instruktioner (f.eks. `ADD BP, BX` eller `MOV BP, DX`) findes der to gyldige opcodes afhængigt af direction-bittet ($d=0$ eller $d=1$).
  - **RASM-86 standard**: Genererer ofte $d=1$ (f.eks. opcode `0x03` for `ADD`).
  - **NASM standard**: Genererer som standard $d=0$ (f.eks. opcode `0x01` for `ADD`).
* **Løsning**: For at undgå uoverskuelige rå `db 0x..` bytes i kildekoden er der oprettet `tasks/rc759-xios/rasm86.inc`. Makroerne (`add_bp_bx`, `add_dx_bx`, `sub_cx_dx`, `cmp_ch_al`, `mov_bp_dx`, `xor_di_di` osv.) udsteder præcis de binære opcodes som RASM-86 producerede, men læses og vedligeholdes som ren assembly.

---

## 4. Renhed og Label-Struktur

For at sikre en entydig symboltabel uden duplikater gælder følgende principper:
* **Fælles funktioner deklareres før `%if`**:
  Når en funktion findes i begge udgaver, men har forskellig implementation (f.eks. `io_auxist`, `io_setblank`, `xios_clip_draw_char`), placeres label-navnet **før** `%if NUM_VIR_CONS`. Hermed har funktionen ét entydigt definitionspunkt.
* **Beskrivende navne**:
  Rå disassembler-offsets (`loc_07D2D`, `sub_09333` osv.) omdøbes systematisk til funktionelle navne (`xios_handle_con_switch_key`, `xios_clip_repaint_windows`).
* **INT 28h Dispatcher**:
  Funktionstabellen peger direkte på de symbolske navne. NASM relokerer tabellens indhold automatisk.

---

## 5. Verificeringsprocedure

Enhver ændring i kildekoden verificeres med flertrins-oraclet:
```bash
# 1. Byg og sammenlign begge XIOS-varianter i Docker
docker run --rm -v /Users/ravn/z80:/work -w /work/tasks/rc759-xios rc759-nasm sh -c "
nasm -f bin -DNUM_VIR_CONS=1 -o /work/scratch/tmp/xios1_test.bin xios.asm && \
cmp -s /work/scratch/tmp/xios1_test.bin /work/scratch/tmp/dist/XIOS1.CON && echo 'XIOS1 MATCH' && \
nasm -f bin -DNUM_VIR_CONS=4 -o /work/scratch/tmp/xios4_test.bin xios.asm && \
cmp -s /work/scratch/tmp/xios4_test.bin /work/scratch/tmp/dist/XIOS4.CON && echo 'XIOS4 MATCH'
"

# 2. Saml hele den monolitiske CCP/M-86 kerne og sammenlign mod original ccpm.sys
./tasks/rc759-xios/rebuild_and_verify.sh
```
Kravet er altid **0 bytes forskel** (100% identisk).

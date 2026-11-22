# RC759 Piccoline — SW1400 CCP/M-86 3.1 Distributionsanalyse

Dokumentation baseret på Digital Research Inc. (DRI) Concurrent CP/M-86 3.1 kilder samt Regnecentralen release notes (**Bits:30005381**, *CCP/M-86 3.1 PICCOLINE XIOS Release 3.1*, 03.02.1987).

---

## 1. Systemidentifikation & Varianter

Binæren under reverse engineering i dette projekt (`scratch/tmp/ccpm.sys`, 77.568 bytes) er **100% byte-for-byte verificeret** mod **`CCPM1.SYS`** fra distributionens Disk 3/4.

* **Type**: Concurrent CP/M-86 Release 3.1, 1 virtuel konsol uden netværk.
* **Bygget af**: Digital Research `GENCCPM.CMD` med RC parameterfil `STDKONF`.
* **XIOS-modul**: Linket med `XIOS1.CON` (25.728 bytes).
* **4-konsol modparten**: `CCPM4.SYS` (87.168 bytes) linket med `XIOS4.CON` (29.440 bytes). Forskellen på 9.600 bytes udgøres af 3 ekstra sæt virtuelle konsolbuffere, skærmstrukturer og procesdeskriptorer.

---

## 2. Distributionsdisketter (SW1400 4 Diske)

Distributionen leveredes på fire 5.25" disketter (DSDD 80 spor, 154 tracks x 8 sektorer x 1024 bytes = 1.261.568 bytes):

### Disk 1/4: Standard Drift & Runtime
* **Styresystemer**:
  * `CCPM.SYS`: 4 konsoller uden netværk.
  * `CCPM1.SYS`: 1 konsol uden netværk.
* **GSX-86 Skærmdrivere**:
  * `DD759H1.SYS` / `DD759H4.SYS`: Høj opløsning monokrom (1 hhv. 4 konsoller).
  * `DD759HD1.SYS` / `DD759HD4.SYS`: Høj opløsning med digitizer.
  * `DD759HM1.SYS` / `DD759HM4.SYS`: Høj opløsning med mus.
  * `DD759M1.SYS` / `DD759M4.SYS`: Farve/gråtoner (1 hhv. 4 konsoller).
  * `DD759MD1.SYS` / `DD759MD4.SYS`: Farve med digitizer.
  * `DD759MM1.SYS` / `DD759MM4.SYS`: Farve med mus.
* **Eksterne Enhedsdrivere**:
  * `DD604H`, `DD604HC`, `DD604V`, `DD604VC` (RC604/RC603 A4 skærme).
  * `DD608HC`, `DD608VC` (RC608 farveskærme).
  * `DD621.SYS` (RC621 plotter).
* **Værktøjer & Runtime**:
  * `COMAL80.CMD`, `COMAL80.ERM`, `GENERRM.CSV`: RcComal80 Release 2.1.
  * `KONFIG.CMD`, `GKONFIG.CMD`, `OKONFIG.CMD`: System- og GSX-konfigurering.
  * `DISKVEDL.CMD`: Formatering og kopiering.
  * `VINDUE.CMD`, `VMENU.CMD`: Vinduesopsætning.
  * `MENU.CMD`, `MENU.MDF`, `MENUVEDL.CMD`: Menu-system.
  * `FILADM.CMD`, `FUNCTION.CMD`: Filadministration og funktionstastprogrammering.

### Disk 2/4: Systemgenerering & Lokalnet
* **MEMIF Kerne-moduler (`.CON`)**:
  * `SUP.CON` (5.632 B): Supervisor og systemstart.
  * `RTM.CON` (7.552 B): Real-Time Monitor kerne (scheduler, queues, flags).
  * `MEM.CON` (6.144 B): Memory Manager.
  * `CIO.CON` (5.504 B): Tegn-I/O manager (konsol og printer).
  * `BDOS.CON` (15.744 B): Fil- og disksystem.
  * `SYSDAT.CON` (3.328 B): Fælles systemdatasegment (DS = 0x06FA).
  * `XIOS1.CON` (25.728 B): 1-konsol XIOS hardware-driver.
  * `XIOS4.CON` (29.440 B): 4-konsol XIOS hardware-driver.
* **Resident System Processes (`.RSP`)**:
  * `CLOCK.RSP` (640 B): Tids- og datostyring via systemtick (Flag 2 -> Flag 3).
  * `PIN.RSP` (3.328 B): Tastaturproces (Process INput).
  * `SCROLL.RSP` (640 B): Blød rulning (smooth scrolling) via Intel 82730 og `MXdma0`.
  * `TMP759.RSP` (7.168 B): Terminal Message Processor / kommandofortolker for Piccoline.
  * `VOUT.RSP` (2.944 B): Virtuel konsol output-multiplexing.

---

## 4. RSP-processerne i `ccpm.sys`

RSP-filerne (`.RSP`) er **8086 `.CMD`-filer med relokeringstabel**. Under kørsel af `GENCCPM` foretages følgende:
1. `GENCCPM` stripper 128-byte CMD-headeren.
2. Relokerer kodesegmentet til den tildelte segmentadresse i systemfilen.
3. Foranstiller en 310-byte header (`RSPHDR` + `PD` + `UDA`) per proceskopi.
4. Kæder processerne sammen i en linked list via `rs_link`, hvor `SYSDAT:0x0042` (`sd_rspseg`) peger på den første.
5. Skriver dem umiddelbart i forlængelse af XIOS og systemtabellerne.

I vores målbinær (`scratch/tmp/ccpm.sys`) optager disse 5 processer **12.736 bytes** (fra fil-offset `0x0FD40` til `0x12F00`):

| RSP Fil | Kode-størrelse | Relok-tabel | Placering i `ccpm.sys` | Placering i `CCPM4.SYS` | Beskrivelse |
|---|---|---|---|---|---|
| `TMP759.RSP` | 5.872 B | 1.168 B | `0x0FD40`–`0x1156F` | `0x117A0` | Piccolines CLI/kommandofortolker |
| `CLOCK.RSP` | 128 B | 384 B | `0x11570`–`0x117CF` | `0x12FD0` | Tids/dato-opdatering (venter på Flag 2) |
| `PIN.RSP` | 2.672 B | 528 B | `0x117D0`–`0x124CF` | `0x13230` | Process INput (tastatur/linjeeditering) |
| `VOUT.RSP` | 1.856 B | 960 B | `0x125E0`–`0x12E5F` | `0x14B20` | Virtual OUTput multiplexer |
| `SCROLL.RSP` | 112 B | 400 B | `0x12E60`–`0x12EFF` | `0x153A0` | Blød rulning via Intel 82730 |

### Betydning for reverse-engineering:
* **XIOS er mindre end antaget**: XIOS-koden slutter i virkeligheden ved `0x0FD3F`. Koden fra `0x0FD40` til `0x12EFF` i `mod4_xios.asm` er de 5 RSPs.
* **Originale kilder**: Digital Research kilderne til `CLOCK.A86`, `VOUT.P86` og `TMP.A86` findes i `scratch/ccpm31-src/`, hvilket giver de officielle funktionsnavne og datastrukturer.
* **Arkitekturforståelse**: Samspillet mellem hardware-ISRs i XIOS (f.eks. RTC 1-sekunds afbrydelse der trigger Flag 2) og RTM-processer (hvor `CLOCK.RSP` venter på Flag 2 og opdaterer TOD-strukturen) er hermed fuldstændigt kortlagt.

---

## 5. Genskabelsesmekanismen via `GENCCPM`

Kildeteksten til Digital Researchs `GENCCPM` findes i `scratch/ccpm31-src/D7/` (`GENC1.C`..`GENC6.C`, `GENCCPM.H`), og den originale eksekverbare `GENCCPM.CMD` samt parameterfilen `STDKONF` findes på distributionsdiskette 2/4.

Ved hjælp af CP/M-86 emulatoren `emu2` (`emu2-cpm86/emu2`) kan `GENCCPM.CMD` afvikles direkte på moderne værtsmaskiner:

1. **Input-moduler**:
   - `SUP.CON`, `RTM.CON`, `MEM.CON`, `CIO.CON`, `BDOS.CON`, `SYSDAT.CON`
   - `XIOS.CON` (kopi af enten `XIOS1.CON` eller `XIOS4.CON`)
   - `TMP759.RSP`, `CLOCK.RSP`, `PIN.RSP`, `VOUT.RSP`, `SCROLL.RSP`
2. **Kommando-pipeline**:
   Implementeret i [tasks/rc759-xios/tools/run_genccpm.py](file:///Users/ravn/z80/tasks/rc759-xios/tools/run_genccpm.py):
   ```bash
   python3 tasks/rc759-xios/tools/run_genccpm.py 1
   ```
   Genererer `ccpm.sys` (77.568 bytes) med 99,88% byte-identitet mod den originale distributionsbinær (samtlige modulkoder og RSP-koder er 100% identiske).
  * `NETDRV.RSP`: Netværksdriver.
* **Værktøjer**:
  * `GENCCPM.CMD`: Digital Researchs systemgenerator.
  * `STDKONF`: Standard konfigurationsparametre (`mem=3000 nq=30 qb=800 nf=ff osstart=48`).
  * `NETOFF`, `NETON`, `NETSTAT`, `NETVEDL`, `RCNIOS`, `RNET`, `SNET`: Netværksstyring.
  * `SPOOL.CMD`, `DSP.CMD`, `SPL.CMD`: Transparent print-spooling.

### Disk 3/4: 8 Forhåndsgenererede Systemer
Giver mulighed for at vælge det præcise styresystem uden at køre `GENCCPM`:
1. `CCPM1.SYS` (77.568 B): 1 konsol, ingen net (**vores reference**).
2. `CCPM4.SYS` (87.168 B): 4 konsoller, ingen net.
3. `CCPM1R.SYS` (123.136 B): 1 konsol, net-klient (bruger).
4. `CCPM1RS.SYS` (128.384 B): 1 konsol, net-klient og -vært.
5. `CCPM1S.SYS` (115.200 B): 1 konsol, net-vært.
6. `CCPM4R.SYS` (133.888 B): 4 konsoller, net-klient.
7. `CCPM4RS.SYS` (139.776 B): 4 konsoller, net-klient og -vært.
8. `CCPM4S.SYS` (126.080 B): 4 konsoller, net-vært.

### Disk 4/4: Værktøjer, Kilder & Comal80 Pakker
* Udviklingsværktøjer: `ASM86.CMD`, `DDT86.CMD`, `ED.CMD`, `GENCMD.CMD`, `PATCH.CMD`, `SYSVEDL.CMD`.
* Comal80 assembler-pakker med fuld kildetekst:
  * `ADAM.A86` / `ADAM.PCK`: Styring af ADAM interface-kort.
  * `BILLEDE.A86` / `BILLEDE.PCK`: Bit-operationer.
  * `COPY602.A86`, `COPY603.A86`: Grafik hard-copy til printere.
  * `KONSOL.A86`: Konsolrutiner.
  * `OPKALD.A86`: Modem-opkald (sløjfebrydning / pulskald).
  * `PORTIO.A86`: Direkte hardware IN/OUT adgang.
  * `PROGRAM.A86`: Eksekvering af eksterne CCP/M-programmer fra Comal80.
  * `STATUS.A86`: Printer- og portstatus.
  * `STRKONV.A86`: Store/små bogstaver konvertering.
* PolyPascal pakker:
  * `KONTROL.PAS`: Fuld softwarestyring af ADAM-kort (stepmotorer, relæer, A/D, D/A).
  * `MUS.PAS`: PolyPascal musedriver-interface.

---

## 3. XIOS Konfigurationstabel (`struct xios_table`)

Placeret i SYSDAT ved offset `0x0C0C` (fil-offset `0x77AC` i `ccpm1.sys`):

```c
struct xios_table {
    UBYTE xt_tick;        /* 0x00: System tick flag */
    UBYTE xt_ticks_sec;   /* 0x01: Ticks per sekund = 60 (fra 82730 VSYNC) */
    UBYTE xt_door;        /* 0x02: Reserveret */
    UBYTE xt_rsvd;        /* 0x03: Reserveret */
    UBYTE xt_xpcns;       /* 0x04: Antal fysiske konsoller = 1 */
    UBYTE xt_nvcns;       /* 0x05: Antal virtuelle konsoller = 1 (4 i CCPM4) */
    UBYTE xt_nccbs;       /* 0x06: Antal Console Control Blocks = 9 */
    UBYTE xt_nlcbs;       /* 0x07: Antal List Control Blocks = 3 */
    UWORD xt_ccb;         /* 0x08: Offset til CCB-array = 0x0D49 */
    UWORD xt_lcb;         /* 0x0A: Offset til LCB-array = 0x0ED5 */
    UWORD xt_dphtab[16];  /* 0x0C: Disk Parameter Header tabel */
                          /*   Drev A: 0x3942 (Floppy 0) */
                          /*   Drev B: 0x3956 (Floppy 1) */
                          /*   Drev C..L: 0x0000 */
                          /*   Drev M: 0x3A32 (Memory Disk / M-Disk) */
                          /*   Drev N..P: 0x0000 */
    UWORD xt_alloc;       /* 0x2C: Hukommelsesallokerings-offset = 0x132D */
};
```

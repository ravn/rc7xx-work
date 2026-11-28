# Assembler-kompatibilitet og Encoding-forskelle: RASM-86 vs. NASM / MASM / GAS

Dette dokument redegør for de tekniske og historiske forskelle mellem Digital Researchs **RASM-86** assembler (brugt af Flemming Kraglund ved Regnecentralen til udvikling af Piccoline CCP/M-86 og XIOS) og moderne assemblere som **NASM**, **GAS**, **FASM** og **MASM**.

---

## 1. Baggrund: Direction-bitten ($d$-bit) i Intel 8086

I Intel 8086-arkitekturens maskinkode har to-registers instruktioner (ALU-operationer og dataoverførsler) en **Direction-bit ($d$-bit)** i første opcode-byte:

$$\text{Opcode-format: } [\text{6 bit opcode}] \cdot [\mathbf{d}] \cdot [\mathbf{w}]$$

Hvor:
* $\mathbf{w}$ (Word-bit): $0 = 8\text{-bit}$, $1 = 16\text{-bit}$.
* $\mathbf{d}$ (Direction-bit):
  * $\mathbf{d = 0}$: `REG`-feltet i ModR/M er **source**, og `R/M`-feltet er **destination** (flow: `REG` $\rightarrow$ `R/M`).
  * $\mathbf{d = 1}$: `REG`-feltet i ModR/M er **destination**, og `R/M`-feltet er **source** (flow: `R/M` $\rightarrow$ `REG`).

### To ækvivalente repræsentationer af samme instruktion
Når begge operander er registre (fx `XOR CX, CX` eller `MOV AX, BX`), kan CPU'en udføre instruktionen via to forskellige gyldige binære encodings:

1. **Via $d = 0$** (source i `REG`, destination i `R/M`):
   * `xor cx, cx`: Opcode `0x31` (binært `001100 0 1`), ModR/M `0xC9` (`11 001 001` $\rightarrow$ reg=CX, r/m=CX)
   * Resultat: **`31 C9`**
2. **Via $d = 1$** (destination i `REG`, source i `R/M`):
   * `xor cx, cx`: Opcode `0x33` (binært `001100 1 1`), ModR/M `0xC9` (`11 001 001` $\rightarrow$ reg=CX, r/m=CX)
   * Resultat: **`33 C9`**

Begge instruktioner udfører nøjagtig samme logiske operation på 8086 CPU'en og tager nøjagtig samme antal clock-cykler (3 cykler for register-til-register ALU).

---

## 2. Assemblernes Konventioner og Historie

Forskellen i den genererede maskinkode skyldes assemblernes interne valg:

| Assembler | Standard for to-registers ALU/MOV ($d$-bit) | Bemærkninger |
|---|---|---|
| **Digital Research (ASM86, RASM-86, MAC86)** | **$d = 1$** | DRIs compiler/assembler-gruppe (1981–1983) standardiserede på $d=1$ for registerpar. |
| **Intel ASM86 (original)** | **$d = 1$** | Intels oprindelige reference-assembler brugte overvejende $d=1$. |
| **Microsoft MASM / TASM / JWasm / UASM** | **$d = 0$** | Microsoft valgte modsat DRI for to registre. MASM-kloner følger dette. |
| **NASM / Yasm** | **$d = 0$** | NASM genererer konsekvent $d=0$ for register-til-register instruktioner. |
| **GNU as (`gas`)** | **$d = 0$** (kan overstyres) | Default er $d=0$, men tillader `.d` suffix (fx `xor.d %cx, %cx`). |
| **A86 (Eric Isaacson)** | Egen optimeringsheuristik | Isaacson lavede sine egne regler; matcher hverken DRI eller MASM konsekvent. |

---

## 3. Analyse af Alternativer til RASM-86

Findes der en moderne assembler, der opfører sig som RASM-86 ud af boksen?

### A. GNU as (`gas`)
* **Mulighed**: GNU as understøtter `.d`-instruktionssuffixer til at tvinge $d=1$:
  ```gas
  .code16
  xor.d %cx, %cx    /* genererer 0x33, 0xC9 */
  ```
* **Ulempe**: Kræver omskrivning til AT&T syntaks (`%cx, %cx`), mangler DRIs direktiver (`CSEG`, `DSEG`, sektionsstyring), og mangler nem direkte generering af rå formater uden store linker-scripts.

### B. FASM (Flat Assembler)
* **Mulighed**: FASM understøtter fuldstændig macro-overloading på instruktionsniveau. Man kan definere en global makro for `xor`, som fanger registerpar og automatisk genererer $d=1$.
* **Ulempe**: FASM har sin helt egen syntax for sektioner, macroer og binære billeder, som afviger væsentligt fra standardværktøjer.

### C. Den originale RASM-86 (Digital Research) under emulering
* Projektet råder i `tasks/rc75x-ccpm/tools_rasm86/` og `scratch/emu2-rasm86/` over den originale `RASM86.CMD` afviklet via en 8086-emulator.
* **Fordel**: 100% historisk tro mod kilderne.
* **Ulemper**:
  1. Kræver et emuleringslag (CPU-emulator) under byggeprocessen.
  2. Begrænset af 1982-arkitekturens ressourcegrænser: begrænset symboltabellængde, 8-tegns labels, ingen sektionslayout med `vstart`.
  3. Kan ikke samle hele `ccpm.sys` i én arbejdsgang uden efterfølgende `GENCCPM`-kørsler.

---

## 4. Den Valgte Løsning i Dette Projekt: NASM + `rasm86.inc`

For at opnå:
1. **100% bit-for-bit identitet** (0 bytes diff) mod de originale RC759-binærer,
2. **Hurtig og nativ bygning** på moderne 64-bit OS / Linux containere (uden DOS/CP/M emulator),
3. **Menneskelæsbar kildekode** uden rå byte-dumps (`db 0x33, 0xC9`),

anvendes **NASM** sammen med definitionsfilen [rasm86.inc](file:///Users/ravn/z80/tasks/rc75x-ccpm/rasm86.inc).

`rasm86.inc` indeholder 248 dedikerede kompatibilitetsmakroer (`xor_cx_cx`, `sub_bx_bx`, `mov_dx_sp`, `add_bp_bx`, `push_es` osv.), der sikrer, at NASM genererer præcis de $d=1$ opkoder, som RASM-86 oprindeligt producerede.

# Plan: Direkte z80asm assembly output via `-z80-asm-format=z80asm`

Dato: 2026-09-26  
Mål: Gøre `clang` i stand til at generere tekstuel assembly, som forstås 100% af `z88dk`'s `z80asm`, så `bridge_postproc.sh` (og dermed `copt`, `fixlabels.pl` m.v.) gradvist overflødiggøres.

---

## Baggrund & Motivation

I dag benytter `zcc +cpm -compiler=llvmz80` et tekstuelt post-processing filter (`lib/llvmz80/bridge_postproc.sh`), der kører mellem Clang og `z80asm`:
1. `copt` med `llvmz80_rules.1` mapper GNU direktiver (`.text`, `.globl`, `.asciz`, `.short`, `.long` osv.) til `z80asm` (`SECTION`, `GLOBAL`, `DEFM`, `DEFW`, `DEFQ`).
2. `fixlabels.pl` fjerner og flader punktummer ud i symboler (`.LBB0_1` -> `LBB0_1`, `_str.1` -> `_str_1`), fordi `z80asm` forbyder punktummer i identifikatorer.
3. `awk` indsætter `EXTERN` headers og håndterer `.comm`.

`llvm-z80` har allerede understøttelse for dialekterne:
- `Z80AsmFormat_ELF` (standard GNU/ELF format)
- `Z80AsmFormat_SDASZ80` (SDCC sdasz80 format)

Ved at introducere **`Z80AsmFormat_Z80ASM`** under flaget **`-z80-asm-format=z80asm`** kan Clang udskrive direkte `z80asm`-kompatibel syntaks uden at regresse eller påvirke standard ELF-outputtet eller de eksisterende lit-tests.

---

## Dialekt-krav for `z80asm`

| Element | Standard ELF (`elf`) | z80asm format (`z80asm`) |
|---|---|---|
| **Lokale labels** | `.LBB0_1` | `LBB0_1` (ingen førende punktum) |
| **Interne symboler** | `_str.1`, `_counter.1` | `_str_1`, `_counter_1` (alle punktummer erstattes med understregning) |
| **Tekst/data sektioner** | `.text`, `.data`, `.bss`, `.rodata` | `SECTION code_compiler`, `data_compiler`, `bss_compiler`, `rodata_compiler` |
| **Globale symboler** | `.globl name` | `GLOBAL name` |
| **8-bit bytes** | `.byte` | `DEFB` |
| **16-bit words** | `.short` | `DEFW` |
| **32-bit dwords** | `.long` | `DEFQ` |
| **64-bit qwords** | `.quad` | Split til to `DEFQ` (via `Data64bitsDirective = nullptr`) |
| **Pladsallokering** | `.zero N` | `DEFS N` |
| **Strenge** | `.ascii`, `.asciz` | `DEFM "..."` (og `DEFB 0` ved nul-terminering) |
| **Maks. strenglængde**| Ubegrænset | `MaxAsciiLength = 48` |
| **Udeladte direktiver**| `.file`, `.ident`, `.type`, `.size` | Undertykkes (`HasIdentDirective = false`, osv.) |

---

## Gennemførelsesplan

### Trin 1: `Z80AsmFormatTy` og `Z80MCAsmInfoZ80ASM` i `llvm-z80`
1. Opret branch `pr-asm-format-z80asm` i `llvm-z80`.
2. I `llvm/lib/Target/Z80/MCTargetDesc/Z80MCAsmInfo.h` og `.cpp`:
   - Tilføj `Z80AsmFormat_Z80ASM` til enum `Z80AsmFormatTy`.
   - Registrer kommandolinjevalget `clEnumValN(Z80AsmFormat_Z80ASM, "z80asm", "z88dk z80asm compatible")` i `cl::opt<Z80AsmFormatTy> Z80AsmFormat`.
   - Opret klassen `Z80MCAsmInfoZ80ASM : public MCAsmInfo`:
     - `InternalSymbolPrefix = "L";`
     - `GlobalDirective = "\tGLOBAL\t";`
     - `Data8bitsDirective = "\tDEFB\t";`
     - `Data16bitsDirective = "\tDEFW\t";`
     - `Data32bitsDirective = "\tDEFQ\t";`
     - `Data64bitsDirective = nullptr;` (aktiverer automatisk 32-bit split af 64-bit tal)
     - `ZeroDirective = "\tDEFS\t";`
     - `AsciiDirective = "\tDEFM\t";`
     - `AscizDirective = nullptr;`
     - `MaxAsciiLength = 48;`
     - `HasDotTypeDotSizeDirective = false;`
     - `HasIdentDirective = false;`
     - `HasSingleParameterDotFile = false;`
     - Implementer `printSwitchToSection()` for sektionerne `code_compiler`, `data_compiler`, `bss_compiler`, `rodata_compiler`.
3. I `llvm/lib/Target/Z80/MCTargetDesc/Z80MCTargetDesc.cpp`:
   - Tilføj mapping i `createZ80MCAsmInfo()` så `Z80AsmFormat_Z80ASM` returnerer en `Z80MCAsmInfoZ80ASM`.

### Trin 2: Sanering af punktummer i symboler
1. I `Z80AsmPrinter` eller `MCSymbol::print`:
   - Når assembler-formatet er `z80asm`, udskrives alle symbolnavne så eventuelle punktummer `.` erstattes med understregning `_` (f.eks. `L__str_1` og `_func_staticvar_1`).

### Trin 3: Grundige C-baserede lit-tests
1. Skriv C-baseret lit-test i `clang/test/CodeGen/z80-asm-z80asm.c` med `-z80-asm-format=z80asm`:
   - Dækker sektions-switches (`SECTION code_compiler`, `SECTION rodata_compiler`).
   - Dækker data-direktiver (`DEFB`, `DEFW`, `DEFQ`, `DEFS`, `DEFM`).
   - Dækker 64-bit splitting til 2x `DEFQ`.
   - Dækker lokale og interne labels (bekræfter fravær af punktummer: `CHECK-NOT: .`).

### Trin 4: Integration og afprøvning med `z88dk`
1. Afprøv `-mllvm -z80-asm-format=z80asm` direkte med `zcc` i `z88dk`.
2. Verificer `sem702-flip-test` og kørsel under `ntvcm`.
3. Forenkl `bridge_postproc.sh` / udfas `fixlabels.pl` og tilhørende `copt`-regler.

---

## Status: GENNEMFØRT (2026-09-26)

- **llvm-z80 (`pr-asm-format-z80asm`, HEAD `b0640118e8cf`):**
  - Trin 1: `Z80MCAsmInfoZ80ASM` implementeret med alle `z80asm`-direktiver.
  - Trin 2: Dotless mangling i `Z80MCAsmInfoZ80ASM` og dotless labels.
  - Trin 3: C- og LLVM-lit tests i `clang/test/CodeGen/z80-asm-z80asm.c` og `llvm/test/CodeGen/Z80/z80-asm-format-z80asm.ll`.
  - Ekstra: `MCAsmInfo::ExternDirective` + `Z80AsmPrinter::emitEndOfAsmFile` emitter native `EXTERN` for alle udefinerede symboler.
  - Ekstra: `.addrsig` undertrykt for `isZ80ASM()`.
  - **Lit test suite:** 123/123 PASS (100%).
- **z88dk (`fix/zcc-revert-split-quad-flag`, HEAD `0ff6da0d9e0c`):**
  - Clang skriver `.asm` direkte fra `.i`.
  - `OPTFILE`-fasen forbigås fuldstændigt for `CC_LLVMZ80`.
  - `llvmz80_postprocess()` fjernet fra `zcc`.
  - `bridge_postproc.sh`, `llvmz80_rules.1` og `fixlabels.pl` slettet.
  - **Runtime integration tests (`test/clang/run_all.sh`):** 66 PASS, 0 FAIL, 1 XFAIL (103s).


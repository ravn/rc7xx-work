# Rodårsagsbaseret Plan: Upstream-submits til `llvm-z80/llvm-z80` (zlfn)

**Dato**: 2026-10-19  
**Princip**: Ingen lappeløsninger, ingen ad-hoc peepholes, ingen eksterne downstream-motiveringer. Vi identificerer og løser de underliggende arkitektoniske rodårsager direkte i de relevante LLVM-faser (TargetMC, TableGen GISel, RegisterBankInfo, TargetTransformInfo).

---

## 1. Hvorfor ZLFN er skeptisk: Lappeløsninger vs. Rodårsager

Tidligere forsøg fra forks på Z80-backends strander ofte hos zlfn, fordi de typisk angriber symptomer med **post-hoc lapper**:
- Manuel scanning efter instruktionssekvenser i C++ (`tryALUIndirectFold` / `foldSpillReloadToPushPop`).
- Make-flags der slår hele LLVM-passes fra (`-mllvm -disable-lsr`).
- Egenopfundne pseudos der duplikerer eksisterende instruktioner i stedet for at bruge TableGen-mønstre.

ZLFN's krav er entydigt: **LLVM er en modular compiler. Enhver ineffektivitet eller fejl har et veldefineret sted i pipelinen, hvor den retteligt hører hjemme.**

---

## 2. Systematisk Analyse: Symptom → Lappeløsning → ÆGTE Rodårsag

### Problem 1: Crash ved LTO / bitcode symbol extraction
* **Symptom**: `report_fatal_error("target did not implement null MCTargetStreamer")` under bitcode parsing med module-level inline asm.
* **Lappeløsning**: Undgå module inline asm eller slå `-flto` fra i Makefiles.
* **Ægte rodårsag**: `LLVMInitializeZ80TargetMC()` i `Z80MCTargetDesc.cpp` registrerede `ObjectTargetStreamer` og `AsmTargetStreamer`, men manglede den obligatoriske `RegisterNullTargetStreamer`. LLVMs kerne-arkitektur (`ModuleSymbolTable`) forventer, at ethvert target med bitcode-understøttelse kan instantiere en null streamer til at absorbere target-direktiver under symboludtræk.
* **Rodårsagshåndtering**: Implementér `createZ80NullTargetStreamer` og registrér den i `LLVMInitializeZ80TargetMC()`.
* **Klassificering**: 100% ren rodårsagsrettelse. Standard LLVM TargetMC-mønster (identisk med AVR, MSP430, NVPTX, RISCV, X86).

---

### Problem 2: Udebleven foldning af `(HL)` memory-operander i 8-bit ALU
* **Symptom**: C-pointer operationer (`*p |= mask`, `x = *p + a`, `(*p)++`) genererer `LD r, (HL)` + `ALU A, r` i stedet for `ALU (HL)` / `INC (HL)`. Dette binder et ekstra 8-bit register (`B/C/D/E`) og udløser kaskader af dyre register-spills.
* **Tidligere lappeløsning**: En ad-hoc C++ scanning-lambda (`tryALUIndirectFold`) i `Z80InstructionSelector.cpp`, der manuelt kigger frem og tilbage i BasicBlock'en efter `G_LOAD` og genererer nye pseudos (`OR8_IND`, `AND8_IND` osv.).
* **Ægte rodårsag i LLVM GlobalISel**:
  1. Z80 har allerede instruktionerne defineret (`OR_HLind`, `AND_HLind`, `ADD_A_HLind` osv. i `Z80InstrInfo.td`).
  2. ZLFN har allerede skabt infrastrukturen `getAluHLindOpcode(Op)` i `Z80InstrInfo.h` for frame-indekser (`ALU_Ac_FI`).
  3. **Hvorfor GlobalISel fejler på generelle pointere**: Der mangler formelle TableGen selection patterns (`Pat`), der forbinder `G_LOAD` adresseret via `GR16_HL` direkte med `ALU_HLind`-instruktionerne under instruction selection. Uden et TableGen-mønster eller et mønster i `Z80PostLegalizerCombiner` ser ISel `G_LOAD` og `G_OR` som to uafhængige instruktioner og tvinger dem ind i virtuelle registre.
* **Rodårsagshåndtering**:
  Integrér memory-indirect folds deklarativt i TableGen / GlobalISel mønstrene eller i `Z80PostLegalizerCombiner`, så `(load GR16_HL:$ptr)` foldes ind i ALU-operationen *før* registerallokeringen overhovedet ser en mellemliggende virtuel registerdefinition.

---

### Problem 3: Dyre spills til statisk RAM over korte instruktionsspænd
* **Symptom**: Under `+static-frame` udstedes spills til faste RAM-adresser (`LD (L_frame), hl` ... `LD hl, (L_frame)` = 6 bytes, 32 T-states) for midlertidige værdier inden for en enkelt blok, hvor `PUSH`/`POP` (2 bytes, 21 T-states) er langt hurtigere og mere kompakt.
* **Tidligere lappeløsning**: Et 64-instruktioners forward-scan peephole pass i `Z80PreEmitPeephole.cpp` (`foldSpillReloadToPushPop`), der forsøger at redde dårlige spill-valg post-RA.
* **Ægte rodårsag**:
  1. **Hvorfor opstår spillet?** Hovedparten af disse spills er *afledte effekter* af Problem 2 og Problem 4: Fordi compileren unødigt binder registre til pointer-loads og kommutative kopier, løber Greedy RA tør for registre og kalder `TII.storeRegToStackSlot()`.
  2. **Hvorfor bruger storeRegToStackSlot statisk RAM?** `Z80FrameLowering` og `Z80StaticFrameAlloc` er instrueret til at mappe stack slots til statiske RAM-adresser under `+static-frame`. Men LLVMs `TargetInstrInfo` interface skelner ikke mellem *long-lived cross-block variables* (som skal være statiske for at undgå stakvækst) og *short-lived intra-block register spills* (hvor hardware-stakken er 100% sikker og neutral, fordi værdien poppes igen inden for få cykler i samme blok).
* **Rodårsagshåndtering**:
  Primært: Løs Problem 2 og 4, hvilket fjerner kilden til registerpresset.
  Sekundært: Hvis spill-to-push/pop skal beholdes, skal det begrundes overfor zlfn som en Target-specifik spill-slot selektion i `Z80FrameLowering`, der formelt verificerer intra-block stak-neutralitet.

---

### Problem 4: Asymmetrisk 16-bit ADD og overflødige register-ombytninger
* **Symptom**: Unødvendige `EX DE, HL` og register-kopier (`LD H, D; LD L, E`) i pointer-addition.
* **Tidligere lappeløsning**: Manuel ombytning af operander i en `if`-betingelse inde i `Z80InstructionSelector.cpp`.
* **Ægte rodårsag**:
  På Z80 er 16-bit addition asymmetrisk: `ADD HL, rr` kræver `HL` som akkumulator.
  I LLVM GlobalISel behandles kommutative operationer (`G_ADD`) af to komponenter:
  1. `commute_constant_to_rhs` i combiners.
  2. `Z80RegisterBankInfo.cpp`: Det er `RegisterBankInfo`'s opgave at binde de korrekte registerklasser (`GR16_HL` for LHS, `GR16` for RHS).
  Når begge operander er variable, mangler `Z80RegisterBankInfo` at undersøge operanternes definitionshistorik: Hvis operand 2 allerede er genereret af en instruktion med `HL`-binding (f.eks. en pointer-beregning), mens operand 1 er i et generelt register, skal operand-rækkefølgen kommuteres *under registerbank-allokeringen*, så LHS tildeles `GR16_HL`.
* **Rodårsagshåndtering**:
  Implementér korrekt operand-præference i `Z80RegisterBankInfo.cpp` eller som en pre-ISel combine regel, så GlobalISel automatisk placerer det naturlige `HL`-register på akkumulator-pladsen.

---

### Problem 5: Loop Strength Reduction (LSR) ødelægger 8-bit loops
* **Symptom**: 8-bit loop-tællere (`uint8_t i = 0; i < n; i++`) udvides til 16-bit pointer-induktionsvariable, hvilket udelukker `DJNZ` og koster ekstra 16-bit registerpar.
* **Tidligere lappeløsning**: `-mllvm -disable-lsr` i Makefiles (en hård afbryder for hele passet).
* **Ægte rodårsag**:
  Generisk LLVM LSR antager en 32/64-bit CPU, hvor det altid er billigere at bruge native bredde.
  LLVM stiller en formel cost-model til rådighed i `TargetTransformInfo`:
  `TargetTransformInfo::isLSRCostLess(const TargetTransformInfo::LSRCost &C1, const TargetTransformInfo::LSRCost &C2)`.
  I `llvm-z80` mangler `Z80TargetTransformInfo.h` en implementation af `isLSRCostLess`, der straffer 16-bit IVs hårdt i forhold til 8-bit IVs, fordi Z80 har ekstremt få 16-bit registerpar (`BC`, `DE`, `HL`), mens en 8-bit IV kan ligge i `B` og udnytte `DJNZ` (1 byte, 8 T) eller `DEC r` (1 byte, 4 T).
* **Rodårsagshåndtering**:
  Override `isLSRCostLess` i `Z80TargetTransformInfo.h` med en model der afspejler Z80's reelle omkostninger, så LSR træffer de rigtige valg matematisk. Dette fjerner behovet for `-disable-lsr` fuldstændigt.

---

## 3. Eksekveringsplan: Fra Lapper til Upstream-kvalitet

Vi angriber ét veldefineret rodårsagsproblem ad gangen:

```
[Trin 1: PR 1 — NullTargetStreamer i Z80MCTargetDesc]
  - Helt isoleret, 100% standard LLVM, fikser LTO-crash
  - Opret draft PR, afvent zlfn feedback
                ↓
[Trin 2: PR 2 — Deklarativ (HL) Memory Fold i GISel / TableGen]
  - Erstat den manuelle C++ scanner med TableGen/Combiner regler
  - Udnyt zlfn's eksisterende getAluHLindOpcode infrastruktur
  - Skriv rene .ll og .mir lit-tests
                ↓
[Trin 3: PR 3 — RegisterBankInfo asymmetrisk 16-bit kommutativitet]
  - Løs rodårsagen til HL/DE ombytninger i RegisterBankInfo
                ↓
[Trin 4: PR 4 — Z80TargetTransformInfo LSR Cost-Model]
  - Gør -disable-lsr overflødig via matematisk korrekt isLSRCostLess
```

Hvert trin skal:
1. Dokumentere den præcise LLVM-mekanisme (ingen downstream-referencer).
2. Indeholde en isoleret lit-test der demonstrerer før/efter på LLVM IR niveau.
3. Godkendes eksplicit af brugeren inden draft-PR oprettes.

# Plan: Fuld Implementering af Packet-Parser Codegen-Optimeringer (#431, #432, #433, #434)

**Dato:** 2026-11-15  
**Mål:** Lukke kløften mellem compiler-genereret kode (p.t. 101 B + 1 B `.bss`) og optimal håndskreven Z80 assembly (63 B + 0 B `.bss`) for `packet-parser.c`.  
**Branch:** `reimpl` i `llvm-z80`.

---

## 1. Systemisk Analyse: Hvorfor opstår kløften?

Kløften skyldes ikke isolerede mangler, men en kædereaktion gennem LLVM's faser:

```
InstCombine (Generic LLVM)
  └─ Slår *flags |= 0x80 og (*flags)++ sammen til én 'store' ved if.end via PHI-node
       └─ Tvinger store til at ske fra akkumulator A
            ├─ Akkumulator A overskrives i hver løkke-iteration
            │    └─ Issue #431: 'delim' kan IKKE blive stående i A på tværs af løkken
            └─ IX var reserveret, så 'flags' optog et 16-bit registerpar (DE eller BC)
                 └─ Ekstremt registerpres (HL=buf, DE=flags, B=len, kun C tilbage)
                      └─ Issue #433: 'matches' tvinges til at spille til .bss (1 byte)
```

Når vi løser rodårsagen, falder optimeringerne på plads som dominobrikker:
1. **Frigiv `IX` til pointere** $\rightarrow$ `flags` flytter til `IX`.
2. **Reversér store-merging for CISC RMW i GISel** $\rightarrow$ `SET 7,(IX+0)` og `INC (IX+0)` sker direkte i RAM.
3. **Akkumulator `A` forbliver uantastet** $\rightarrow$ `delim` holdes i `A` hele løkken (`cp (hl)`).
4. **Registerpres forsvinder** $\rightarrow$ `C` og `E` er helt frie; `matches` bliver i `C` (0 B `.bss`).
5. **Prolog-coalescing** $\rightarrow$ sekventielle stak-argumenter hentes med `inc hl` i stedet for gentagne `add hl, sp`.

---

## 2. Faseopdelt Implementeringsplan

### Fase 1: Frigivelse af `IX` til pointere og In-Place RMW (#432 fundament)
* **Mål:** Gøre `IX` allokerbar for 16-bit pointere i funktioner uden frame pointer, og udvide in-place hukommelsesinstruktioner til at acceptere `IX`.
* **Filer:**
  - `llvm/lib/Target/Z80/Z80RegisterInfo.cpp`
  - `llvm/lib/Target/Z80/Z80InstructionSelector.cpp`
  - `llvm/lib/Target/Z80/Z80InstrInfo.td`
  - `llvm/lib/Target/Z80/Z80InstrInfo.cpp`
* **Trin:**
  1. I `Z80RegisterInfo::getReservedRegs`: un-reserve `Z80::IX` når `!hasFP(MF) && !STI.hasSM83()`.
  2. I `Z80RegisterInfo::getLargestLegalSuperClass`: ret `hasSuperClass` til `hasSuperClassEq(&Z80::GR16RegClass)`, så `GR16` ikke fejlagtigt inflateres til `Any16`.
  3. I `Z80InstructionSelector::selectFrameIndex`: sænk 16-bit skalar/pointer frame index loads til `RELOAD_ANY16` (tillader Greedy RA at placere stak-pointere direkte i `IX`).
  4. I `Z80InstrInfo.td` og `Z80InstructionSelector.cpp`: ændr adresse-operand for `SET8_IND`, `RES8_IND`, `INC8_IND`, `DEC8_IND` fra `GR16_HL` til `HLI` (`HL`, `IX`, `IY`).
  5. I `Z80InstrInfo.cpp`: ekspandér pseudoerne med `Addr == Z80::IX` til `SET_b_IXd`, `RES_b_IXd`, `INC_IXd`, `DEC_IXd` med offset `0`.
* **Test:**
  - `llvm/test/CodeGen/Z80/ix-allocatable-pointer.ll` verificerer `set 7,(ix+0)`.
  - Hele lit-suiten (`check-llvm-codegen-z80`) skal være grøn (183/183 pass).

---

### Fase 2: GISel Store-Sink Combiner for CISC RMW In-Place Ops
* **Mål:** Modvirke mid-end InstCombine store-merging, så `*p |= mask` og `(*p)++` ikke tvinges sammen til én `store` ved `if.end`.
* **Filer:**
  - `llvm/lib/Target/Z80/Z80PreLegalizerCombiner.cpp` (eller `Z80PostLegalizerCombiner.cpp`)
* **Trin:**
  1. Identificér mønsteret:
     - En blok har en `G_STORE %val, %ptr`.
     - `%val` er defineret af en `G_PHI` i samme blok.
     - Alle indgående værdier i `G_PHI` er RMW-operationer (`G_OR`, `G_ADD`, etc.) baseret på en `G_LOAD %ptr` fra samme adresse.
  2. Transformér:
     - Sink og klon `G_STORE` tilbage i hver forgængerblok (predecessor).
     - Fjern `G_PHI` og den oprindelige `G_STORE`.
  3. Resultat: Hver gren har nu sit eget `load-modify-store` par på samme adresse.
  4. Instruction Selector matcher dem derefter direkte som `SET8_IND` og `INC8_IND` på `IX`.
* **Test:**
  - Skriv C/LLVM IR testcase der efterligner `if (c) *p |= 0x80; else (*p)++;` og bekræft, at der genereres `set 7,(ix+0)` og `inc (ix+0)` uden `store` i `if.end`.

---

### Fase 3: Loop-Invariant Hoisting i `A` & Spill-Eliminering (#431 & #433)
* **Mål:** Fastholde loop-invariant `delim` i `A` gennem hele løkken, og allokere `matches` til et 8-bit register (`C` eller `E`) med 0 B `.bss`.
* **Filer:**
  - `llvm/lib/Target/Z80/Z80InstructionSelector.cpp`
* **Trin:**
  1. Nu hvor Fase 2 fjerner skrivning til `A` i `if.end`, er akkumulatoren `A` ledig i hele løkken.
  2. Sørg for at invarianten `delim` tildeles `A` i loop-preheaderen.
  3. Løkke-kernen udnytter da `cp (hl)` direkte mod `A`.
  4. Fordi `flags` er i `IX`, `buf` er i `HL`, `len` er i `B`, og `delim` er i `A`, er registrene `C`, `D`, `E` fuldstændig frie.
  5. Greedy RA tildeler automatisk `matches` til `C` (eller `E`).
  6. Statisk frame-størrelse for `matches` reduceres fra 1 byte til 0 bytes.
* **Test:**
  - Lit test med pointer-løkke der tæller matches og verificerer:
    - `delim` indlæses i `A` én gang før løkken.
    - `matches` forbliver i register (f.eks. `inc c`).
    - Ingen `.bss` / static frame allokeres.

---

### Fase 4: Coalescing af Sekventielle Stak-Argumenter i Prologen (#434)
* **Mål:** Eliminere gentagne `ld hl, N; add hl, sp` i funktionsprologen for sekventielle stak-argumenter.
* **Filer:**
  - `llvm/lib/Target/Z80/Z80FrameLowering.cpp` eller `llvm/lib/Target/Z80/Z80PreEmitPeephole.cpp`
* **Trin:**
  1. Når en funktion har flere på hinanden følgende argumenter på stakken (f.eks. offsets 2, 4, 5, 6):
  2. Undersøg om prologen kan etablere `HL = SP + base` én gang:
     ```assembly
     ld  hl, 2
     add hl, sp
     ```
  3. Hent argumenter og ryk pegepinden med `inc hl` imellem dem:
     ```assembly
     ld  e, (hl)
     inc hl
     ld  d, (hl)    ; DE = buf (offset 2)
     inc hl
     ld  b, (hl)    ; B = len (offset 4)
     inc hl
     ld  a, (hl)    ; A = delim (offset 5)
     inc hl
     ld  c, (hl)
     inc hl
     ld  h, (hl)
     ld  l, c       ; HL = flags (offset 6)
     push hl
     pop  ix        ; IX = flags
     ```
  4. Dette sparer ~13-15 bytes i prologen alene.
* **Test:**
  - Lit test der verificerer, at en funktion med 4 stak-argumenter genererer sekventiel traversal med `inc hl` i stedet for 4 separate `add hl, sp`.

---

## 3. Estimerede Gevinster og Målepunkter

| Komponent | Før (reimpl) | Efter Fase 1+2 | Efter Fase 3 | Efter Fase 4 (Færdig) | Optimal Z80 Asm |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Prolog (stak loads)** | ~25 bytes | ~25 bytes | ~25 bytes | **~12 bytes** | ~10 bytes |
| **Løkke-kerne** | ~65 bytes | ~35 bytes | ~20 bytes | **~20 bytes** | 14 bytes |
| **Epilog / retur** | ~11 bytes | ~8 bytes | ~6 bytes | **~6 bytes** | 4 bytes |
| **Samlet kode-størrelse** | **101 bytes** | **~68 bytes** | **~51 bytes** | **~38–42 bytes** | **63 bytes** |
| **Statisk frame (.bss)** | **1 byte** | **1 byte** | **0 bytes** | **0 bytes** | **0 bytes** |

---

## 4. Sikkerhed og Discipliner (AGENTS.md)

1. **Test-first discipline:**
   Hver fase indledes med en dedikeret lit-test, der demonstrerer det manglende mønster, før ændringen laves i compileren.
2. **Begrænsning til `Target/Z80`:**
   Ingen ændringer uden for `llvm/lib/Target/Z80/`. LLVM mid-end røres ikke; alle tilpasninger sker i Z80 GISel eller backend-passes.
3. **Graceful Ninja handling:**
   Alle builds stoppes udelukkende med `SIGINT` (Ctrl-C / `kill -2`) eller `SIGTERM`. Ved utilsigtet afbrud køres straks `ninja -t recompact`.
4. **Verifikation mod orakel:**
   Efter hver fase køres `llvm-lit` på de relevante tests, efterfulgt af fuld `check-llvm-codegen-z80`.

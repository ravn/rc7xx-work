---
name: reference-lsr-filter-prefers-wide-stride-match
description: LSR's formel-filter foretrækker IV'er der stride-matcher pointer-IV'er, ikke smaller IV'er — ikke konfigurerbar via TTI
metadata:
  type: reference
---

**Observation (verificeret 2026-10-11 på `cmp6` i `cp-hl-pointer-loop.ll`):**

LSR identificerer korrekt både `{6,+,-1}<nsw>` (i8 nedtælling) og
`{-6,+,1}<nuw><nsw>` (i16 optælling) som gyldige IV-formler for en i8-
counter, men filtrerer `{6,+,-1}` væk med:

```
Filtering out formula reg({6,+,-1}<nsw>)
   in favor of formula reg({-6,+,1}<nuw><nsw>)
```

Begrundelsen i `LSRUse::DeleteFormula` er at `{-6,+,1}` deler stride
(`+1`) med loopens pointer-IV'er, hvilket LSR betragter som
"regster-besparende". På Z80 er dette den omvendte sandhed: `dec r`
på et 8-bit halv-register er 1 byte, mens `inc rr` på en 16-bit tæller
koster byte + registertryk + sign-extend-shuffling omkring brug.

**Hvilke TTI-hooks dækker IKKE dette:**

- `isLSRCostLess` — rangerer færdige løsninger (post-filter)
- `getNumberOfRegisters` — ingen effekt, testet med 3 på Z80TTI
- `isTruncateFree` / `isZExtFree` — allerede korrekte i Z80ISelLowering
- `isLegalAddImmediate` / `isLegalICmpImmediate` — lovlighed, ikke præference
- `getRegisterBitWidth` — kun vektor-pathways

Filter-logikken ligger i core-LSR og eksponerer ingen target-krog til
at udtrykke "smal IV er billigere end stride-matched bred IV".

**Konsekvens for Z80:**

- `-disable-lsr` i produktion (autoload-in-c Makefile) er ikke blot
  pragmatisk, men arkitektonisk korrekt indtil nogen tilføjer en
  TTI-hook upstream (fx `preferNarrowerIV()` eller en bredde-cost-hook).
- Et Z80-specifikt post-LSR unwidening-pass kunne være en mellemløsning
  hvis vi finder flere ofre end `cmp6`-mønsteret.

**Scope:** Dette er en upstream LLVM-core observation; ravn/llvm-z80
kan ikke løse det alene via TTI. Enhver fiks er enten en
Z80-specifik pass eller en upstream patch til `llvm/llvm-project`.

Relateret: [[reference_lsr_sledgehammer_disable]], issue #401
(oprindelig CP (HL) codegen problem der afslørede dette).

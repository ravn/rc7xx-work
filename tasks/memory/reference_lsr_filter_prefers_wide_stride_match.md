---
name: reference-lsr-filter-prefers-wide-stride-match
description: LSR foretrækker wide stride-matched IVs over narrow nedtællere på Z80 — løst med tre TTI hooks (Z80TargetTransformInfo.h)
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
"register-besparende". På Z80 er dette den omvendte sandhed: `dec r`
på et 8-bit halv-register er 1 byte, mens `inc rr` på en 16-bit tæller
koster byte + registertryk + sign-extend-shuffling omkring brug.

**Løsning (ravn/llvm-z80@8d909ab, 2026-10-11): tre TTI-hooks i
`Z80TargetTransformInfo.h` opnår samme effekt uden upstream-ændringer.**

1. **`isHardwareLoopProfitable()`** — returnerer true for sløjfer med
   i8 symbolic max trip count. LSR::RateRegister nulstiller
   `AddRecCost` for `countsDownToZero`-formler, så LSR foretrækker den
   smalle `{C,+,-1}` IV over den stride-matched wide `{−C,+,1}`.
   Hook'en registrerer **ikke** HardwareLoops IR-passet; udnytter kun
   den eksisterende cost-signal. DJNZ-mønsteret.
2. **`getNumberOfRegisters(ClassID)` → 3** — Z80 har BC/DE/HL som GP
   pairs. `Cost::RateFormula` adderer `(NumRegs - TTIRegNum)` til
   `C.Insns` når en formel kræver flere IVs end tilgængelige registre.
   Default er 8; 3 presser LSR til at vælge færre IVs for sløjfer der
   ellers ville overrunne register-filen.
3. **`shouldDropLSRSolutionIfLessProfitable()` → true** — LSR
   detekterer selv "Baseline is more profitable than chosen solution"
   men handler kun på det hvis denne hook er sat. Load-bearing for
   nested-loop-mønstre som `draw_qr` i autoload-in-c.

**Resultat:** autoload-in-c PROM gik fra 2134 B (`-disable-lsr`) til
2131 B (hooks, ingen flag). `-mllvm -disable-lsr` fjernet fra
`autoload-in-c/Makefile` i commit rc700-gensmedet@d4efa1b. MAME-boot
PASS frame 175.

**Hvorfor min oprindelige analyse var forkert:** jeg testede kun
`getNumberOfRegisters=3` isoleret på `cmp6`-sagen, hvor den ikke
flyttede noget — fordi cmp6 vindes af `countsDownToZero`-pathen
(hook 1), ikke af NumRegs-pathen. `draw_qr`-sagen var det omvendte.
Først med alle tre hooks aktive virkede baseline-check'et i hook 3
som sikkerhedsnet mod LSR's regressioner.

**Scope:** Vej A (TTI-hooks) virker fuldt ud for autoload. Lever
B (upstream `preferNarrowerIV` TTI-hook) eller et Z80-specifikt
post-LSR unwidening-pass er ikke længere nødvendigt.

Relateret: [[reference_lsr_sledgehammer_disable]] (nu dateret),
issue ravn/llvm-z80#401 (CP (HL) codegen der afslørede problemet),
issue ravn/llvm-z80#408 (push/pop spill — orthogonal next-step).

---
name: reference_exx_protocol_z88dk_32bit
description: EXX-protokollen for z88dk 32-bit matematik: ABI, Z80LegalizerInfo-mønster og faldgruber ved PUSH_IX.
metadata:
  type: reference
---

## Z88DK 32-bit kerne-ABI (EXX-protokol)

z88dk's 32-bit matematik-kerner bruger Z80's alternate register bank:

**Multiply** (`l_mulu_32_32x32`, `l_muls_32_32x32`):
- Arg1: `dehl'` (alt bank) — DE'=hi, HL'=lo
- Arg2: `dehl` (main bank) — DE=hi, HL=lo
- Resultat: `dehl` (main bank) — DE=hi, HL=lo
- Tramper: af, bc, de, hl, bc', de', hl', **ix**

**Division** (`l_divs_32_32x32`, `l_divu_32_32x32`):
- Dividend: `dehl'` (alt bank) — DE'=hi, HL'=lo
- Divisor: `dehl` (main bank) — DE=hi, HL=lo
- Quotient: `dehl` (main bank) efter kald
- Remainder: `dehl'` (alt bank) efter kald — hent med EXX
- Tramper: af, bc, de, hl, bc', de', hl', **ix**

Clang's i32-format er **HL:DE** (HL=hi, DE=lo) — modsat kernernes **DE:HL** (DE=hi, HL=lo).
Konvertering: `COPY DE ← hi_vreg; COPY HL ← lo_vreg` (omvendt af Clang-rækkefølge).

## Legalizer-mønster (Z80LegalizerInfo.cpp)

```
buildUnmerge(S16, Src32)  →  getReg(0)=lo16, getReg(1)=hi16

; Send arg til alt-bank:
COPY DE ← hi_vreg  ; kerne DE=high
COPY HL ← lo_vreg  ; kerne HL=low
EXX                ; arg → alt bank; Defs=[HL,DE,BC]

; Arg2 / divisor i main-bank:
COPY DE ← arg2_hi
COPY HL ← arg2_lo
PUSH IX
CALL l_mulu_32_32x32  (via addSym, INGEN underscore-mangling)
POP IX

; Hent resultat:
buildCopy(S16, HL)  ; lo
buildCopy(S16, DE)  ; hi
buildMergeLikeInstr(Dst, {lo, hi})
```

Den native legalizer-helper `exchangeZ88DKBanks` tilføjer implicitte
registeroperander til EXX; den globale instruction-definition ændres ikke:
```
EXX implicit HL, implicit DE,
    implicit-def HL, implicit-def DE, implicit-def BC
```

Disse Uses er nødvendige for at holde dividendens registerkopier levende.
Uden dem blev opsætningen slettet i det observerede første integrationsforsøg
(2026-10-03), og `1000000/7` gav 1.

## IX-håndtering

Fast-kernerne tramper IX. Den aktuelle integration gemmer IX umiddelbart før
CALL, markerer kaldets IX-clobber og gendanner IX umiddelbart efter kaldet.
Prologens callee-save alene er ikke nok: en dynamic-frame caller kan læse
locals gennem IX mellem kaldet og epilogen.

Det historiske råd om at undgå PUSH_IX/POP_IX gjaldt et ældre forsøg og må ikke
genbruges som en generel sikkerhedsregel. Den aktuelle
`Z80InstrInfo::getSPAdjust` håndterer PUSH_IX som +2 og POP_IX som -2 ved
stack-offset-korrektion. `runtime_i32_frames` er verificeret ved O0/O2/O3/Oz
med både small- og IX-clobberende fast-kerner, tvungen frame-pointer,
levende volatile stacklocals og stack-passed output-pointere.

## Navnemangling

Kerne-symboler (f.eks. `l_divs_32_32x32`) er rå asm PUBLIC-symboler — **ingen** `_`-præfiks.
`addGlobalAddress` og `addExternalSymbol` tilføjer `_` (C-mangling). Brug i stedet:
```cpp
MCSymbol *Sym = MF.getContext().getOrCreateSymbol("l_divs_32_32x32");
MIRBuilder.buildInstr(Z80::CALL_nn).addSym(Sym);
```

## EX_DE_HL efter multiply

Efter `l_mulu_32_32x32` er resultatet i DE:HL (DE=hi, HL=lo). Clang vil have HL:DE (HL=hi, DE=lo).
Brug `MIRBuilder.buildInstr(Z80::EX_DE_HL)` for én-instruktions swap, derefter:
```cpp
ResLo = buildCopy(S16, Z80::DE)  // efter EX_DE_HL: DE=lo
ResHi = buildCopy(S16, Z80::HL)  // HL=hi
buildMergeLikeInstr(Dst, {ResLo, ResHi})
```
Alternativt (for division, ingen EX_DE_HL nødvendig): kopier direkte fra DE=hi og HL=lo til merge.

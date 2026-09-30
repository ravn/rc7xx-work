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
CALL l_mulu_32_32x32  (via addSym, INGEN underscore-mangling)

; Hent resultat:
buildCopy(S16, HL)  ; lo
buildCopy(S16, DE)  ; hi
buildMergeLikeInstr(Dst, {lo, hi})
```

EXX i `Z80InstrInfo.td`:
```
def EXX : Inst8<"exx", 0xD9> {
  let Uses = [HL, DE];       // HL+DE læses (gem til alt-bank); BC nødvendes ikke
  let Defs = [HL, DE, BC];   // friske værdier fra alt-bank (BC ukendt)
}
```

## IX-håndtering

Kernerne tramper IX (bruges som frame pointer i z88dk). **PUSH_IX/POP_IX må IKKE bruges** i legalizer-kode:
- `PUSH_IX` mangler `Defs=[SP]`, så RA's stack-offset-beregning til stack-passerede argumenter (fx `b` i `sfuse(a, b, r)`) bliver FORKERT med 2 bytes.
- Resulterer i at divisor/multiplikand læses fra forkert stackadresse → stille forkerte tal.

**Korrekt løsning**: slet PUSH_IX/POP_IX. Begrundelse:
1. Funktionsprologen gemmer allerede IX som callee-saved (`push ix`).
2. Med `+static-frame` (BSS-locals) bruges IX IKKE til frame-adgang efter prologen.
3. Kernen tramper IX; epilogen (`pop ix`) retablerer caller's IX korrekt.
4. Ingen kode mellem vores kald og epilogen bruger IX → ingen skade.

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

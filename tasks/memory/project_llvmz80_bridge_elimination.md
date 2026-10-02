---
name: project_llvmz80_bridge_elimination
description: Status for eliminering af llvmz80.lst-broer fra z88dk (session 2026-09-30).
metadata:
  type: project
---

## Status (2026-10-03)

Historisk blev `llvmz80.lst` reduceret fra 13 broer til 3 float-broer
(status pr. 2026-09-30). Den aktuelle målsætning er ingen llvmz80-specifikke
wrapper-/bridge-stubs. For float betyder det, at backend'en kalder z88dk's
eksisterende `cm32_sdcc_*` runtime-indgange med `sdcccall(0)`; de er en del af
den almindelige z88dk-runtime og ikke llvmz80-broer. Allerede eksisterende
adaptere i z88dk er acceptable; der må ikke skrives nye bridges/wrappere i
hverken llvm-z80 eller z88dk. Manglende runtime-indgange skal markeres som gaps,
ikke udfyldes med nye adaptere. Compare-stien bruger eksisterende z88dk
math32-predicate-indgange for finite værdier; den aktuelle testpolicy
udelukker NaN, og faktisk NaN-adfærd er ikke verificeret.

**Eliminerede** (backend kalder z88dk-kerner direkte via MCSymbol/addSym):
| Bridge | Erstatning | Metode |
|--------|-----------|--------|
| `__divhi3` (16-bit div/mod/mul) | `l_divs_16_16x16`, `l_divu_16_16x16`, `l_mulu_16_16x16` | `selectRuntimeLibCall16` — quotient/produkt fra HL, remainder fra DE |
| `__udivqi3` (8-bit div/mod) | `l_fast_divu_8_8x8` | `selectUDivMod8` i Z80InstructionSelector.cpp — E=divisor, L=dividend |
| `__memmove_rt` / `__z80_memmove_builtin` | `asm_memmove` | G_MEMMOVE custom legalizer — HL=src, DE=dst, BC=n |
| `__memset_builtin` / `__z80_memset_builtin` | `asm_memset` | G_MEMSET custom legalizer — HL=dst, DE=val(zext), BC=n |
| `__mulsi3` / `__mulsi3_fast` | `l_mulu_32_32x32` | G_MUL i32 custom legalizer — EXX-protokol |
| `__divsi3` (32-bit div/mod/rem/divmod) | `l_divs_32_32x32`, `l_divu_32_32x32` | G_SDIV/UDIV/SREM/UREM/SDIVREM/UDIVREM i32 custom — EXX-protokol |
| `__call_iy` | compiler-rt/z80/call_iy.asm | Duplikat — slettet |
| `__strerror_table` | — | Newlib-only gap, ikke nødvendig på classic CP/M |
| `__itoa` | — | `#define itoa(a,b,c) itoa_callee(a,b,c)` omgår den altid |

**Compare-status:** Backendens Z88DK lowering kalder `cm32_sdcc___fseq`,
`___fsneq`, `___fslt` og `___fsgt` med `sdcccall(0)`; `ORD`/`UNO` er
konstanter inden for finite-only testkontrakten. 142/142 Z80 lit-tests og de
to finite-only zcc/ntvcm compare-tests passerer. Den lokale z88dk
`llvmz80.lst`-ændring udelader `__cmpsf2.asm`; ingen ny wrapper er tilføjet.
NaN-semantik forbliver uafklaret og uverificeret. Den første root z88dk-suite gav
44 PASS/13 FAIL/11 XFAIL; de 13 ikke-FCMP-fejl mangler en før-baseline og er
ikke tilskrevet denne compare-ændring.

## Tilhørende llvm-z80 branches

Aktiv integration: `upstream-z88dk-native-runtime`. i8/i16 og separate/fused
i32-kerner er nu runtime-verificeret; i32 bruger eksplicit EXX-liveness og
PUSH/POP IX. Builtin-header-ABI bevares på Z88DK-triplen uden `-fno-builtin`.
Endelige suite-resultater registreres i
`llvm-z80/tasks/plan-z88dk-native-runtime-2026-10.md` afsnit 9.

Historisk kildebranch `z88dk-native-libcalls` havde commits:
- `[Z80] z88dk triple: call l_* cores directly for i16 div/mod/mul`
- `[Z80] z88dk triple: call l_fast_divu_8_8x8 directly for i8 udiv/umod`
- `[Z80] z88dk triple: call asm_memmove/asm_memset directly from legalizer`
- `[Z80] z88dk triple: call l_mulu_32_32x32 directly via EXX protocol`
- `[Z80] z88dk triple: call l_div[su]_32_32x32 directly via EXX protocol`

**Why:** Renere arkitektur: compilerens z88dk triple kalder eksisterende
z88dk runtime-symboler med den korrekte ABI. Ingen llvmz80-specifikke adaptere
skal ligge skjult i clib-linkningen.

Se `[[reference_exx_protocol_z88dk_32bit]]` for tekniske detaljer om EXX-protokollen.

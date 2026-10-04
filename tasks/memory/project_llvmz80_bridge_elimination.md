---
name: project_llvmz80_bridge_elimination
description: Status for eliminering af llvmz80.lst-broer fra z88dk (session 2026-09-30).
metadata:
  type: project
---

## Status (2026-10-04)

### Version baseline

Genbrug ikke beslutninger fra før math32-løftet som om de beskrev den aktuelle
runtime. I z88dk v2.4 lå math32 under `libsrc/_DEVELOPMENT/`, og `zcc` havde
`genmath@{ZCC_LIBCPU}` som standard; math32 skulle vælges eksplicit. I den
aktuelle v2.5-udviklingslinje ligger det under `libsrc/math/float/math32/`,
`-lm` og `--math32` vælger math32, og changelog'en lister math32 som default.
Det lokale checkout har endnu ikke et `v2.5` git-tag.

Den konkrete adapter-ABI er ikke automatisk blevet ugyldig: sammenlignede
v2.4- og aktuelle adapterfiler for `fsadd/fssub/fsmul/fsdiv`, integer/float
konverteringer og alle fire compare-predicates er byte-identiske. Det beviser
ikke, at math32's numeriske adfærd er uændret: runtime-kernen er blevet
omarbejdet efter v2.4. Genverificér derfor både biblioteksvalg/linking og
runtime-værdier mod den aktuelle v2.5-udviklingslinje; brug ikke v2.4 Docker-
resultater som bevis for den.

Ingen llvmz80-specifikke float bridge-aliases er nødvendige. Under
`z80-unknown-none-z88dk` kalder backend'en z88dk's almindelige
`cm32_sdcc_*` math32-indgange med `CallingConv::Z80_SDCCCall0`. De eksisterende
runtime-adaptere konverterer stack-argumenterne til math32-kernens ABI; de er
normale medlemmer af `math32_sdcc.lst`, ikke llvmz80-broer. Den lokale
wiki-kopi `z88dk-wiki/Math32.md` beskriver math32 som den fulde IEEE single
library og dokumenterer `--math32`-linkvalget. Runtime README'en
`z88dk/libsrc/math/float/math32/readme.md` beskriver math32's calling
convention og kerneformatet. Der må ikke skrives nye bridges/wrappere i
llvm-z80 eller z88dk; manglende indgange registreres som gaps.

Før runtime-konklusioner skal det linkede `lib/clibs/math32.lib` verificeres
mod assemblykilderne. Arkivet er ignoreret build-output. Den 2026-10-03 var
det linkede arkiv fra 11. august, mens special-case-kilderne var ændret
27. september; de tilsyneladende 13 NaN/Inf-fejl forsvandt efter genbygning og
relink af samme testprogram.

Math32-Makefile sporer nu alle `.asm`- og `.lst`-inputs for samtlige 13
arkivvarianter. `test/llvmz80/math32_archive_deps.sh` kontrollerer
afhængighedsgrafen og fejlede før rettelsen. Behold kontrol af, at den
installerede `lib/clibs/math32.lib` matcher det genbyggede `libsrc/math32.lib`,
før runtime-resultater bruges til at vurdere compilerens ABI eller
math32-semantik.

Float-mappingen er:
- aritmetik: `cm32_sdcc_fsadd`, `fssub`, `fsmul`, `fsdiv`
- konverteringer: `cm32_sdcc___fs2sint`, `___fs2uint`, `___slong2fs`,
  `___ulong2fs`
- sammenligninger: `cm32_sdcc___fseq`, `___fsneq`, `___fslt`, `___fsgt`
  samt `cm32_sdcc_fpclassify`

math32 bruger IEEE-754 binary32-format, men understøtter ikke denormaler.
README'en dokumenterer NaN-kodning og klassifikation. Dens predicate-rutiner
ordner NaN-bitmønstre som tal, så strict LLVM-sammenligninger klassificerer
begge operander og retter resultatet; kun eksplicit `nnan` må udelade dette.
NaN-policyen er derfor ikke finite-only. Runtime-matricen med NaN i begge
operandpositioner og de registrerede resultater står i
`llvm-z80/tasks/plan-z88dk-native-runtime-2026-10.md` afsnit 9; se også
`z88dk/test/llvmz80/runtime_fcmp.c` og
`llvm-z80/llvm/test/CodeGen/Z80/z88dk-fcmp-runtime.ll`.

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

**Compare-status:** Backendens Z88DK lowering kalder de eksisterende
`cm32_sdcc___fseq`, `___fsneq`, `___fslt`, `___fsgt` og
`cm32_sdcc_fpclassify`-indgange med `sdcccall(0)`. Lit- og runtime-matricerne
dækker strict/unordered predicates, eksplicit `nnan` samt 20 NaN-kombinationer
i begge operandpositioner. De registrerede resultater er i
`llvm-z80/tasks/plan-z88dk-native-runtime-2026-10.md` afsnit 9. Der tilføjes
ingen llvmz80 bridge eller ny z88dk-adapter.

## Tilhørende llvm-z80 branches

Aktiv integration: `experiment-z88dk-target-abi-20261004` i llvm-z80 og
`reintegrate-llvmz80-on-upstream-20261003` i z88dk. Compilerens target-ABI er
nu `sdcccall(0)` på z88dk-triplen; zcc injicerer ikke et default-CC-flag.
Almindelige helper-navne og calling conventions vælges gennem LLVM RTLIB;
EXX, FCMP og direkte memory-workers beholder deres specialiserede lowering.
i8/i16 og separate/fused
i32-kerner er nu runtime-verificeret; i32 bruger eksplicit EXX-liveness og
PUSH/POP IX. Builtin-header-ABI bevares på Z88DK-triplen uden `-fno-builtin`.
Endelige suite-resultater registreres i
`llvm-z80/tasks/plan-z88dk-native-runtime-2026-10.md` afsnit 9.

Efter native genbygning den 2026-10-04: 145 backend-lit PASS; upstream
runtime-runner 426 PASS, 6 SKIP, ingen FAIL/FATAL; alle 15 scripts i
`z88dk/test/llvmz80/` PASS. SM83-fallbacks bevarer tidligere codegen, men
dette er ikke en verificering af et SM83-runtime-bibliotek.

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

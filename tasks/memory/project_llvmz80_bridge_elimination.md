---
name: project_llvmz80_bridge_elimination
description: Status for eliminering af llvmz80.lst-broer fra z88dk (session 2026-09-30).
metadata:
  type: project
---

## Resultat (2026-09-30)

Fra 13 broer → **3 resterende** (kun float, arkitektonisk nødvendige).

**Eliminerede** (backend kalder z88dk-kerner direkte via MCSymbol/addSym):
| Bridge | Erstatning | Metode |
|--------|-----------|--------|
| `__divhi3` (16-bit div/mod/mul) | `l_divs_16_16x16`, `l_divu_16_16x16`, `l_mulu_16_16x16` | `selectRuntimeLibCall16` i Z80InstructionSelector.cpp — addSym, result fra HL |
| `__udivqi3` (8-bit div/mod) | `l_fast_divu_8_8x8` | `selectUDivMod8` i Z80InstructionSelector.cpp — E=divisor, L=dividend |
| `__memmove_rt` / `__z80_memmove_builtin` | `asm_memmove` | G_MEMMOVE custom legalizer — HL=src, DE=dst, BC=n |
| `__memset_builtin` / `__z80_memset_builtin` | `asm_memset` | G_MEMSET custom legalizer — HL=dst, DE=val(zext), BC=n |
| `__mulsi3` / `__mulsi3_fast` | `l_mulu_32_32x32` | G_MUL i32 custom legalizer — EXX-protokol |
| `__divsi3` (32-bit div/mod/rem/divmod) | `l_divs_32_32x32`, `l_divu_32_32x32` | G_SDIV/UDIV/SREM/UREM/SDIVREM/UDIVREM i32 custom — EXX-protokol |
| `__call_iy` | compiler-rt/z80/call_iy.asm | Duplikat — slettet |
| `__strerror_table` | — | Newlib-only gap, ikke nødvendig på classic CP/M |
| `__itoa` | — | `#define itoa(a,b,c) itoa_callee(a,b,c)` omgår den altid |

**Resterende** (strukturelt nødvendigt — 1 fil):
- `__cmpsf2.asm` — rigtig kode: NaN-detektion + GCC tri-state (-1/0/+1) konvertering. Kan ikke erstattes af navne-remap. `__addsf3.asm` og `__floatsisf.asm` slettet 2026-09-30 (pure JP-aliases → backend kalder cm32_sdcc_* direkte via MCSymbol i Z80MCInstLower.cpp).

## Tilhørende llvm-z80 branch
`z88dk-native-libcalls` — commits:
- `[Z80] z88dk triple: call l_* cores directly for i16 div/mod/mul`
- `[Z80] z88dk triple: call l_fast_divu_8_8x8 directly for i8 udiv/umod`
- `[Z80] z88dk triple: call asm_memmove/asm_memset directly from legalizer`
- `[Z80] z88dk triple: call l_mulu_32_32x32 directly via EXX protocol`
- `[Z80] z88dk triple: call l_div[su]_32_32x32 directly via EXX protocol`

**Why:** Renere arkitektur: z88dk-specifik ABI-adaptation sker i backenden (z80-unknown-none-z88dk triple) fremfor i z88dk's clib. Reducerer z80_crt0.lib-størrelse og eliminerer usynlige ABI-wrappers.

Se `[[reference_exx_protocol_z88dk_32bit]]` for tekniske detaljer om EXX-protokollen.

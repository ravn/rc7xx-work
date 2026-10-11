---
name: reference-z88dk-triple-tradeoffs
description: Hvad --target=z80-unknown-none-z88dk ændrer vs --target=z80 — konkrete forskelle verificeret 2026-10-11
metadata:
  type: reference
---

Verificeret 2026-10-11 ved A/B-bygning af autoload-in-c under begge
triples (efter #410-crashfix d081b0d). Trippel-skiftet er **ikke** en
cosmetic ændring; den rør flere specifikke lowering-paths.

## Hvad er IDENTISK

- `IntWidth = 16` — `int` promotion-regler. Identisk, sat uden for
  Z88DK-checken i `clang/lib/Basic/Targets/Z80.cpp:32`.

## Hvad er FORSKELLIGT

### Float/double-bredde

- `--target=z80`: `double` = 64-bit IEEE, `long double` = 64-bit.
  Backend emitterer kald til `__floatsidf`, `__adddf3` osv.
- `--target=z80-unknown-none-z88dk`: `double` = `long double` =
  `float` = 32-bit IEEE binary32. Kun single-precision libcalls.
  Set i `clang/lib/Basic/Targets/Z80.cpp:42-49`.

### 32-bit aritmetik (`__mulsi3` / `__divsi3` / `__udivsi3` /
    `__modsi3` / `__umodsi3`)

- `--target=z80`: plain libcall-symboler med `CallingConv::C`
  (stack-passing).
- `--target=z80-unknown-none-z88dk`: `l_mulu_32_32x32` /
  `\01__divsi3` osv. (leading-0x01 symbol-marker) +
  `CallingConv::Z80_SDCCCall0` + bank-exchange via `exx`.
  Set i `Z80LegalizerInfo.cpp:969-1022`.

### memset (G_MEMSET lowering)

- `--target=z80`: `createMemLibcall` → stack-ABI `_memset`
  (IX+d prolog).
- `--target=z80-unknown-none-z88dk`: `call asm_memset` med
  register-ABI (HL=dst, DE=val, BC=count). Ingen IX+d prolog.
  Set i `Z80LegalizerInfo.cpp:1884`.

### DWARF-emission under `-c`

- `--target=z80`: fuld DWARF (.debug_info, .debug_line,
  .debug_str osv.).
- `--target=z80-unknown-none-z88dk`: **ingen** DWARF-sektioner,
  silent. Backend/MC er sat op til at udelade dem. C_LINE-direktiver
  i `-S`-pathen er den eneste debug-mekanisme.

### Preprocessor-macros

- `--target=z80-unknown-none-z88dk`: `__Z88DK__` + `__Z88DK` defineret.

### Register-bank-exchange

- 32-bit returværdier under Z88DK bruger `exchangeZ88DKBanks` =
  `exx`-swap. Ikke relevant for `--target=z80`.

## Netto-effekt for autoload-in-c (2026-10-11 måling)

- `--target=z80` (TTI-hooks aktive): PROM 2131 B
- `--target=z80-unknown-none-z88dk` (samme hooks): PROM **2208 B**
  (+77 B regression)

Memcpy/memset-ABI-forbedringen (fri IX+d prolog i stubs) opvejes af
andre forskelle — formentlig calling convention og
32-bit-arithmetic-paths. **Triple-skift er IKKE en netto-win for
autoload.** For komponenter der rører 32-bit math eller tunge
memset-mønstre kan det være omvendt — mål før beslutning.

## Blokeringer historisk

- Clang-crash #410 ved z88dk-triple + `-g` + `-c` (object emission)
  — løst i d081b0d.
- DWARF-emission under `-c` + Z88DK — stadig off, kendt gap
  (follow-up i #410's close-kommentar).

Relateret: [[reference_llvmz80_bridge_elimination]] (hvorfor
produktionsveje bruger `--target=z80`), issue ravn/llvm-z80#409
(memset/memcpy IX+d — lever A er fiks af stubs selv, lever B er
triple-skift via dette).

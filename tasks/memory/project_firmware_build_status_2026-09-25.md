---
name: project_firmware_build_status_2026-09-25
description: Status for de tre firmware-builds med test/all-prs compileren (2026-09-25) — hvad mangler, hvad virker
metadata:
  type: project
---

Status for firmware builds med `llvm-z80/build-macos` bygget fra `test/all-prs` (HEAD `ad02719112d6`), 2026-09-25.

## z88dk zcc integration tests
**64/66 PASS** (op fra 48/66 tidligere).
- 1 FAIL: `runtime_printf_autoformat.sh` — `printf("%f")` printer 0.000000 (z88dk classic clib dtoa-bug, ikke compiler-relateret)
- 1 XFAIL: `xfail_tmpfile.sh` (forventet)
- Fix committed: `zcc llvmz80: inject -z80-split-quad-directive` → ravn/z88dk master (merge c696fac3ec)

## autoload-in-c
**FEJLER** — `clang/dzx0_standard.s`: `ex af, af'` afvist af Z80 AsmParser.

**Root cause:** Commit `95d2cd718a4f [Z80] AsmParser: accept "ex af, af'" inline asm (#81)` fra `main` er **ikke** cherry-picket til `upstream-main`.

**Fix:** Cherry-pick `95d2cd718a4f` til `upstream-main`, rebyg.

## rcbios-in-c
**FEJLER** — `LLVM ERROR: unable to legalize G_STORE ... p2` under LTO-link i `ld.lld`.

**Root cause:** Bruger `-flto` (påkrævet for .bss fitting). P2-legalizer-fix er til stede (`26b0141ee421`), men LTO whole-program codegen ser anderledes IR. Den eksakte årsag er ukendt — sandsynligvis behøves yderligere fixes fra `main` der ikke er cherry-picket endnu.

**Kendte fakta:**
- Enkelt-fil BC codegen af `bios_hw_init.bc` virker OK
- Problemet opstår kun ved LTO-link (alle .o filer kombineret)
- `make clean && make bios` reproducerer fejlen konsistent

**Mitigering (hurtig):** Disable `-flto` midlertidigt → tillader compilation men overflower .bss (~1.3 KB ekstra).

## cpnos-in-c  
**FEJLER** — `fatal error: cannot select: G_STORE ... p2` + SIGSEGV i `src/snios_c.c`.

**Root cause:** `_port_out(uint8_t p, uint8_t v)` i `src/hal.h` bruger runtime port-adresse `p`. Commit `1d7124dfe7a9` (vores P2-fix) siger eksplicit: "non-constant case fails to select ('cannot select'), a loud error." Compileren opfører sig som designet.

**Fix-muligheder:**
1. Tilføj `__attribute__((always_inline))` til `_port_out`/`_port_in` i `src/hal.h` — tvinger constant folding
2. Tilføj `IN A,(C)` / `OUT (C),A` ISel support for runtime-porte i `Z80InstructionSelector.cpp`

## Why: upstream-main mangler noget
Branchen `upstream-main` / `test/all-prs` er baseret på `llvm-z80/llvm-z80 main` (PR #43). Den har IKKE arvet alle Z80-specifikke fixes fra vores `main`-track. Kendte mangler:
- `95d2cd718a4f` — AsmParser af' fix (KRITISK for autoload)
- Muligvis andre LTO/P2-relaterede fixes

**How to apply:** Cherry-pick manglende commits fra `main` til `upstream-main`, rebase alle PR-branches, rebuild.

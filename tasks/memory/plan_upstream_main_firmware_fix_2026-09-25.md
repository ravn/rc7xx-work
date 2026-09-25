---
name: plan_upstream_main_firmware_fix_2026-09-25
description: Plan for at få alle tre firmware-builds til at kompilere med test/all-prs compileren
metadata:
  type: project
---

Næste session: gør alle tre firmware-builds til at oversætte med `test/all-prs` compileren.

## Trin 1 — autoload (nemt, ~5 min)

Cherry-pick `95d2cd718a4f` til `upstream-main`:
```bash
cd /Users/ravn/z80/llvm-z80
git checkout upstream-main
git cherry-pick 95d2cd718a4f   # [Z80] AsmParser: accept "ex af, af'" inline asm (#81)
```

Derefter rebase alle PR-branches og test/all-prs, rebuild clang, test autoload.

## Trin 2 — cpnos (firmware-fix, ~15 min)

Tilføj `__attribute__((always_inline))` til `_port_out` og `_port_in` i `/Users/ravn/z80/rc700-gensmedet/cpnos-in-c/src/hal.h`:
```c
static __attribute__((always_inline)) inline void _port_out(uint8_t p, uint8_t v) { ... }
static __attribute__((always_inline)) inline uint8_t _port_in(uint8_t p) { ... }
```

Dette tvinger constant folding af port-numrene inden ISel ser dem.

**Verify:** `make prom1-lineprog COMPILER=clang` — bør kompilere.

## Trin 3 — rcbios LTO (sværest, ~30-60 min)

Diagnose-strategi:
1. Find commits fra `main` der ikke er i `upstream-main` og som retter LTO/P2:
   ```bash
   git log main --oneline | grep -i "lto\|p2\|addrspace\|port"
   ```
2. Kandidater: tjek commits efter `1d7124dfe7a9` (addrspace restore, 2026-09-09) og frem
3. Cherry-pick relevante

**Hurtig workaround** (hvis ovenstående er komplekst): Disable `-flto` i rcbios clang/Makefile linje ~39 midlertidigt. Bemærk: dette forårsager .bss overflow (~1.3 KB) så `make bios` linker ikke. Brug `CFLAGS_EXTRA=-fno-lto` eller lign. for compilation-only test.

## Trin 4 — mål størrelser

Når alle tre oversætter:
```bash
# rcbios
wc -c /Users/ravn/z80/rc700-gensmedet/rcbios-in-c/clang/bios.clang.cim

# autoload
wc -c /Users/ravn/z80/rc700-gensmedet/autoload-in-c/clang/prom.clang.bin

# cpnos (uden 2 KB krav)
wc -c /Users/ravn/z80/rc700-gensmedet/cpnos-in-c/clang/cpnos.bin
```

Opdater CLAUDE.md med nye tal + dato.

## Trin 5 — opdater upstream-main-PRs

Force-push upstream-main + alle PR-branches til origin efter cherry-pick i trin 1.

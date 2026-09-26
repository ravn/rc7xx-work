---
name: project_upstream_pr_umbrella_2026-09-26
description: Status for paraplyen #379 (7 PRs til llvm-z80/llvm-z80 upstream) efter session 2026-09-26
metadata:
  type: project
---

## Paraplyen: ravn/llvm-z80#379 (7 PRs til upstream)

GitHub issue #379 er oversat til engelsk (2026-09-26). Tabel-mapping:

| PR | Branch | Indhold | Issue |
|---|---|---|---|
| #371 | pr-366-float-sdcccall0-libcalls | float sdcccall0 libcalls | #366 |
| #372 | pr-367-classic-libc-cc | classic libc CC | #367 |
| ~#373~ | ~pr-368-quad-split~ | ~(lukket, erstattet af #382)~ | #368 |
| #374 | pr-369-divmod-fusion | i32 divmod fusion | #369 |
| #375 | pr-370-div-fast-o3 | i16 div fast at -O3 | #370 |
| #378 (af'-fix) | pr-fix-asmparser-ex-af-prime | AsmParser accept "ex af, af'" | #377 |
| #376 | pr-fix-z80-datalayout | Triple::computeDataLayout z80/sm83 | #380 |
| ~#381~ | ~pr-split-ascii-directive~ | ~(lukket, indlemmet i #382)~ | ~#383~ (lukket, indlemmet i #384) |
| #382 | pr-asm-format-z80asm | Native z80asm format (-z80-asm-format=z80asm) inkl. EXTERN og linjelængde-limit | #384 |

## Branches: rene (2026-09-26)

Alle PR-branches indeholder KUN egne commits, rebased direkte på `upstream-main`:
- **upstream-main** HEAD: `01c80da67276` (uændret)
- `pr-fix-asmparser-ex-af-prime`: 1 commit (`b376e9610ab0`) over upstream-main
- `pr-366`..`pr-370`, `pr-fix-z80-datalayout`, `pr-split-ascii-directive`: egne commits, INGEN af'-fix-tilhæng
- `pr-asm-format-z80asm`: native z80asm dialect output, dotless labels, EXTERN emission, .addrsig undertrykkelse

## test/all-prs

HEAD: `b0640118e8cf` (23 commits over upstream-main)
Rækkefølge: af'-fix → pr-366 → pr-367 → pr-368 → pr-369 → pr-370 → pr-fix-z80-datalayout → pr-split-ascii-directive → pr-asm-format-z80asm

**Lit:** 123 PASS, 0 FAIL, 1 UNRESOLVED (pre-existing `issue-216-cp-sbc-and.s` — ingen `RUN:`-linje)

## Issues

- **#379**: umbrella, oversat til engelsk 2026-09-26
- **#380**: ny issue for Triple::computeDataLayout z80/sm83 crash (oprettet 2026-09-26, linket til #376)

## Næste skridt

1. Kør `make prom COMPILER=clang` i autoload-in-c (verificer af'-fix i compiler)
2. Trin 2 cpnos: `__attribute__((always_inline))` på `_port_out`/`_port_in` i `src/hal.h`
3. Trin 3 rcbios: diagnose LTO + P2 legalizer fejl
4. Force-push upstream-main + alle PR-branches til origin (endnu ikke gjort)

**How to apply:** Før nye commits til PR-branches: tjek at de KUN bygger ovenpå `upstream-main` og at test/all-prs er rebuildet.

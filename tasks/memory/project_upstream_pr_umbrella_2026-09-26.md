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
| #366 | pr-366-float-sdcccall0-libcalls | float sdcccall0 libcalls | #365 |
| #367 | pr-367-classic-libc-cc | classic libc CC | #? |
| #368 | pr-368-quad-split | .quad 64-bit split | #? |
| #369 | pr-369-divmod-fusion | i32 divmod fusion | #? |
| #370 | pr-370-div-fast-o3 | i16 div fast at -O3 | #? |
| #373 (af'-fix) | pr-fix-asmparser-ex-af-prime | AsmParser accept "ex af, af'" | #81 |
| #376 | pr-fix-z80-datalayout | Triple::computeDataLayout z80/sm83 | #380 |

## Branches: rene (2026-09-26)

Alle 7 PR-branches indeholder KUN egne commits, rebased direkte på `upstream-main`:
- **upstream-main** HEAD: `01c80da67276` (uændret)
- `pr-fix-asmparser-ex-af-prime`: 1 commit (`b376e9610ab0`) over upstream-main
- `pr-366`..`pr-370`, `pr-fix-z80-datalayout`: egne commits, INGEN af'-fix-tilhæng

**Why:** Branches var tidligere rebased på `pr-fix-asmparser-ex-af-prime` (fejlagtigt). Alle ryddet op 2026-09-26 og force-pushet.

## test/all-prs

HEAD: `aaa07fc9c96a` (16 commits over upstream-main)
Rækkefølge: af'-fix → pr-366 → pr-367 → pr-368 → pr-369 → pr-370 → pr-fix-z80-datalayout

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

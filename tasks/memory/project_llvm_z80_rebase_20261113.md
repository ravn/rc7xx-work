---
name: project-llvm-z80-rebase-20261113
description: Status og resultat af ravn/llvm-z80 main-rebase til upstream/main (2026-11-13)
metadata:
  type: project
---

ravn/llvm-z80 `main` er rebased til at ligge direkte oven på `upstream/main` (tip `0331c1ca`).

**Why:** zlfn udgav 8 nye Z80-commits (#134–#139: PUSH/POP spills, tail calls, SDCC runtime refaktor, ny release-tag llvmz80-23.1.4-r1). Ravn/main var 40 commits foran shared base med mange superseded commits.

**How to apply:** ved fremtidige upstream-opdateringer er shared base nu `0331c1ca`; `git cherry -v upstream/main main` viser status.

## Hvad blev droppet (superseded)

- 9 SDCC-runtime commits — absorberet af upstream #108 (`84ca0c58`)
- 5 z88dk-env commits — absorberet af `runtime-3-z88dk-env` (`010fcea3`–`6988303f`)
- 2 push/pop spill commits (`42d09a9`, `a9c0a69`) — superseded af upstream #134/#135
- 2 merge-commits — kan ikke rebases
- ~4 tomme commits — allerede patch-ident med upstream

## Hvad blev bevaret (22 commits — heraf 6 er zlfn's WIP, se nedenfor)

Ravn-unikke upstream-kandidater (16):
- CP(HL)/COMPARE8_IND pseudo
- LD A,(nn)/LD (nn),A fold
- OR (HL) fold
- INC/DEC/AND/XOR/ADD/SUB (HL) memory-fold familie
- Prefer HL for commutative 16-bit add
- DEC/INC (HL) zero-compare fold
- TTI LSR cost-model hooks (DJNZ)
- Filter inline asm edges in Z80NonReentrant (#413)
- .globl ___umulhi3 i compiler-rt
- CallingConv-renummerering + Triple::Z88DK fix (`a2fb43fe` — blandet, skal splittes)

Zlfn's WIP-commits (passagerer fra z88dk-udviklingsgren — IKKE ravn-arbejde):
- `855189fb` — Lower fused 16-bit division
- `a3c890e4` — Print z88dk assembly by default
- `ad41303b` — Call z88dk's runtime
- `b3802478` — Divide bytes with z88dk's core

Ravn z88dk-specifik infrastruktur (venter på zlfn's #86/#87):
- `4e93072b` — CMakeLists HINTS for z88dk-z80asm
- `e0cbd3fa` — Libcalls mul-family under z88dk env

## z88dk-wip branch (oprettet 2026-11-14)

`z88dk-wip` branch fra `upstream/main` med zlfn's fire z88dk-commits cherry-picked. Ravn's z88dk-infrastruktur (`4e93072b`, `e0cbd3fa`, z88dk-delen af `a2fb43fe`) cherry-pickes hertil under reimplementeringen. Venter på zlfn's #86/#87.

## Reimplementeringsplan

Fuld plan for at reimplementere alle ravn-unikke commits i upstream-klar kvalitet:
`llvm-z80/tasks/plan-ravn-commits-reimplementation.md`

Nøglepunkter: start fra `upstream/main` på `reimpl`-branch, 17 trin i rækkefølge, Fase 7 implementerer #74 (alle tre no-callback lag) men KRÆVER go-ahead fra fork-owner FØR kode skrives.

## Backup

`backup/main-pre-rebase-20261113` = gammel main (`da06bcd8acc2`)

## Konflikt-løsnings-mønster

Fremtidige rebase-konflikter mod upstream vil typisk ramme:
- `Z80CallLowering.cpp`: IMath `CallOpc` override — fjern `unsigned` redefinering
- `Z80InstrInfo.cpp` linje ~16: tilføj begge include-headers
- `Z80InstrInfo.cpp` getInstSizeInBytes: union af tail-call + CALL_EXX* cases
- `CallingConv.h`: tag HEAD (zlfns nummerskema 240+)
- `Z80RegisterInfo.td`: simple union af register-klasser
- Nye test-filer i `z80-utils/test-runner/testcases/`: `git add z80-test/e2e/c/<fil>`

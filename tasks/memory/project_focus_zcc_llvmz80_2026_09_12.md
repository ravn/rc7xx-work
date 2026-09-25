---
name: project_focus_zcc_llvmz80_2026_09_12
description: 2026-09-12 re-prioritisation — park rcbios as the oracle (blocked by #316 density, too slow to finish); autoload is the working firmware oracle; focus shifts to finishing zcc +cpm -compiler=llvmz80.
metadata:
  type: project
---

Bruger 2026-09-12: "rcbios er midlertidigt ikke orakel fordi det tager for lang tid at
få den helt på plads. Nøjes med autoload; gør zcc med llvmz80 færdig."

**Beslutning:**
- **rcbios PARKERET som orakel** — alle TU'er compilerer + LTO-linker, men `.text+.bss`
  løber ~1306 B over BIOS-RAM-regionen pga. static-frame-densitets-regressionen
  ([[project_pr40_fallout_2026_09_10]] #314/#316). At få den helt på plads afhænger af
  #316 (upstream-arkitektur-beslutning) — for langsomt lige nu.
- **autoload er det fungerende firmware-orakel** — booter den originale RC702-BIOS til
  `A>` (efter `ei()`-i-ISR + fjernet redundant `SET_SP`; rc700 `b6726d8`). Kører på
  4 KB-EPROM (static-stack-densitet rummes af cap'en).
- **Fokus: gøre `zcc +cpm -compiler=llvmz80` færdig** (z88dk clang-integration —
  `z88dk/libsrc/l/llvmz80/`, CP/M-stdlib-flade). Status pr. workspace-CLAUDE.md
  (2026-07-17): "largely complete and verified"; string/ctype/stdlib/malloc/stdio-FILE*
  virker, double==float32 via math32. Resterende "finish"-punkter skal afklares.

**Why:** #316 er en upstream-sag der ikke løses hurtigt; autoload beviser compileren
duer til produktion; zcc/llvmz80 er den nære, afsluttelige leverance.

**How to apply:** brug autoload (`make floppy-boot-test`) som firmware-gate. Fald ikke
tilbage på rcbios-boot som blokerende oracle før #316 er løst. Kør zcc/llvmz80-arbejde
i `z88dk`-dev-forken.

**STATUS 2026-09-12 — zcc/llvmz80-suite BREDT BRUDT af #40 (4 PASS / 59 FAIL):**
Rod (samme R1/R2-klasse — fork-feature droppet i merget): zcc's `-compiler=llvmz80`-gren
injicerer `-mllvm -z80-float-sdcccall0` (`src/zcc/zcc.c:3609`), men PR #40 **fjernede
det flag** fra backenden (verificeret: `--help-hidden` har det ikke; `z80-classic-libc-cc`
på linje 3626 OVERLEVEDE). clang afviser det ukendte flag → **hver** zcc/llvmz80-build
fejler. Flaget er fork'ens #277 (f32-libcalls bruger sdcccall(0)-CC → bro til z88dk
math32). **Upstream har INGEN math32-bro → intet at adaptere til → GENSKAB #277** (ikke
en #316-agtig "adapt"-sag).

**#277 GENSKABT 2026-09-12.** Manuel re-applikation i `Z80LegalizerInfo.cpp`
(cherry-pick umulig — merget omskrev legalizeren): (1) `#include CommandLine.h` +
`cl::opt UseSDCCCall0ForF32Libcalls("z80-float-sdcccall0")`; (2) arith-custom-casen
(G_FADD/SUB/MUL/DIV) bruger nu gated `LibcallCC`; (3) fcmp-casen: `F32LibcallCC` på de
tre `createLibcall`-sites (__cmpsf2/__gtsf2/__gesf2/__unordsf2); (4) NY legalizeCustom-case
G_FPTOSI/FPTOUI/SITOFP/UITOFP (`__fixsfsi/__fixunssfsi/__floatsisf/__floatunsisf`) +
`.customFor({{S32,S32}})` på begge conversion-action-buildere. Merget havde BEHOLDT
fork'ens custom arith+fcmp-stier (fast/IEEE-navne) men uden CC-gaten — kun conversions
var faldet tilbage til generisk libcallForCartesianProduct.

Lit-tests genskabt fra de gamle commits; `issue-277-f32-cmp-conv-sdcccall0.ll` opdateret:
DEFAULT-armen (flag-off) emitter nu `call ___fix*` i stedet for tail-`jp` (benign
R5-tail-call-drift fra 23.1.0, ikke #277-specifik). Begge tests PASS. Fuld Z80 lit:
25 FAIL uændret (samme kendte R5-sæt), ingen nye regressioner. Flag verificeret i
`llc --help-hidden`. Minimal `zcc +cpm -compiler=llvmz80 --math32` bygger nu rent
(var: "Unknown command line argument '-z80-float-sdcccall0'"). Ingen zcc-ændring nødvendig.
Kør suite: `ZCCCFG=…/lib/config PATH=…/bin LLVMZ80EXE=…/build-macos/bin/clang
NTVCM=/Users/ravn/z80/ntvcm/ntvcm sh test/clang/run_all.sh` (baseline var 24/0 classic,
23/0 newlib_iy 2026-07-24).

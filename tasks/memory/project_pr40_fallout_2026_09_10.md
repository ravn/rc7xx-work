---
name: project_pr40_fallout_2026_09_10
description: PR #40 (z88dk CC + llvmz80-23.1.0-r1) merge fallout — tre åbne regressioner, baseline og plan
metadata:
  type: project
---

Upstream PR #40 merged ind i ravn/llvm-z80. Umiddelbare build-brud lappet i
`a3f3f6f`–`1d7124d`, men tre legalizer-/API-regressioner stadig åbne (2026-09-10).

**Baseline målt 2026-09-10:**
- Lit: 285 tests, 189 PASS, 64 XFAIL, **32 FAIL**
- Test-runner clang O1: 205 tests, **86 PASS**, 68 FATAL, 51 SKIP
- z88dk-ticks var ude af PATH — bygget + symlinket `~/.local/bin/z88dk-ticks`

**Rodårsager:**
1. ~~`@llvm.experimental.memset.pattern` ikke legaliseret~~ **FIXED 2026-09-10.** Præcisering: den generiske TTI-hook (`shouldExpandExperimentalMemSetPattern`) OVERLEVEDE merget; det var begge legalizer-arme (`experimental_memset_pattern` + `z80_pattern_fill`) der faldt ud. Valgt fix (bruger: "target-ejet, generisk urørt"): FJERN den generiske hook helt (upstream-korrekt — upstream har intrinsiken men INGEN backend-lowering-vej/claim-hook; læner man sig på den får man en store-loop, ikke LDIR), genskab `z80_pattern_fill`-armen (pre-POC fra `6839ebc^`), lad recognizeren emitte `z80_pattern_fill` for alle K, slet forældet `experimental-memset-pattern.ll`. **Vigtig ekstra-bug:** pre-POC-armen satte `DE=dst+K` FØR seed-store; K>=2 word-seed materialiserer mønsteret i DE og overskrev LDIR-dest → miscompile (test_205_fill_word/_dword=garbage). PR #40's regalloc afslørede det. Fix: seed FØRST, så HL/DE/BC-triplet lige før LDIR (+1 B ZX0). Verificeret: lit 32→29 FAIL, runtime FATAL 68→10 + fill_byte/word/dword PASS.
2. ~~Z80 builtins ulegaliserede~~ **FIXED 2026-09-10 (`a3bd36a4`).** Var TRE lag: (a) `getTargetBuiltins()` returnerede `{}` (frontend-wiring stubbet — `BuiltinsZ80.td/.inc` overlevede) → alle `__builtin_z80_*` "unknown builtin"; (b) ingen `initFeatureMap` → "z80"-featuren aldrig tændt → im2/set_i gated OG **backend `HasZ80=false` for alle clang-builds** (slog tavst en hel klasse Z80-passes fra: HighByteFirstBranch/KeepLoopPointerInPair/NarrowNoIndex/PinLoopPointer/ISel-folds); (c) legalizer+selector manglede im2/set_i-arme. Fix: wire getTargetBuiltins til shard'en, tilføj initFeatureMap (z80-feature for ikke-SM83 → genopretter HasZ80), legalizer+selector im2→`im 2`/set_i→`ld i,a`, `LD_I_A Uses=[A]`. Runtime 144→145 PASS/0 FAIL; rcbios C-kilder compilerer nu. Rest-blokade for rcbios: **separat ld.lld-segfault ved final link** (ikke R2 — minimal im2/set_i linker rent).
3. `-z80-unreserve-iy` flag fjernet/omdøbt → 10 IY-test fatals (test_166–174 + reverse_fill_seed bruger `-z80-reverse-fill-seed`). ÅBEN.
4. `i64/i128/arith-i32` "Found 2 machine code errors" → 3 lit-fails. ÅBEN.
5. ~26 lit-tests med codegen-drift (FileCheck-patterns forældet). ÅBEN.

**Også løst (ikke i original-5):** inline-asm `{de}`-constraint (fork-lokal C-constraint droppet i merget) → firmware migreret til GCC register-variabler `register T x __asm__("de")` (`rc700-gensmedet@57c160a`, tests `74bf5439`). cpnos rest-blokade: `address_space(2)` G_STORE cannot-select i init_hardware. autoload boot-gate + MAME stadig udskudt (MAME nede).

**Why:** PR #40 ændrede register-klasse API, intrinsic-opslag, feature-flag-navne, droppede frontend-builtin-wiring + inline-asm-constraint-udvidelse.

**How to apply:** Se fuld plan i `llvm-z80/tasks/plan-pr40-fallout-recovery-2026-09-10.md`.
STATUS 2026-09-10: R1 (memset.pattern) + R2 (builtins/HasZ80) + inline-asm LØST.
ÅBNE: rcbios ld.lld-segfault, cpnos addrspace, R3 (IY-flag), R4 (machine-errors), R5 (drift).

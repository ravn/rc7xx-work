# ez80clang comparison oracle (CEdev)

**What:** `ez80clang` is the 6th lane in `rc700-gensmedet/tasks/compiler-comparison-corpus/sweep.sh`.
It is CEdev's prebuilt `ez80-clang` (CE-Programming/toolchain releases, built
from CE-Programming/llvm-project — a **SelectionDAG eZ80** LLVM fork, a
*different lineage* from ravn/llvm-z80's GlobalISel z80-native backend). Driven
by z88dk's native `zcc +cpm -compiler=ez80clang`.

**Scope: CODE-QUALITY comparison only** (user 2026-07-06 "jeg ønsker kun
ez80clang som sammenligningsorakel på kodekvalitet"). NOT a runtime-correctness
oracle. Only the cells where it compiles correct code (`word_fill`,
`licm_pessimize`) contribute size/t-state datapoints.

**Setup (reproducible, not vendored):** `./setup_ez80clang.sh` downloads the
CEdev release for the platform, extracts to `cedev-eval/CEdev` (gitignored at
workspace root), symlinks `$Z88DK/bin/ez80-clang`. Full recipe + rationale in
`compiler-comparison-corpus/EZ80CLANG_ORACLE_SETUP.md`.

**z88dk bridge fix required (committed, z88dk branch `rc700-gensmedet-1`,
`d24e19d1e8`):** CEdev v15.0's clang-19 asm printer emits dotted
`.section`/`.ident` and an `rb ($$ - $) and 1` BSS-align idiom that vanilla
`lib/clang_rules.1` (ours == upstream master) doesn't translate → unpatched
z88dk + CEdev v15.0 CANNOT build. Fix prepends dotted-`.section` rules +
`ALIGN 2`. Re-check for other CEdev versions.

**3 skipped cells → rc700-gensmedet#122:**
- `pi` — VERIFIED: ez80-clang emits CE 32-bit libcalls `__llmulu`/`__ldivu`/
  `__llshru`, implemented only in CEdev's ADL-24-bit `libcrt.a`, unresolvable
  on z88dk's z80 clib. Library gap, NOT a codegen bug. (Const-folded 32-bit ops
  work; only *runtime* 32-bit mul/div/shift hits the missing helpers.)
- `sieve`/`fannkuch` — symptom VERIFIED (CE z80 codegen cliff: sieve ≥450
  hangs while emitted binary paradoxically shrinks); CE-codegen-vs-z80asm cause
  NOT confirmed. Skipped (not XFAIL-run) because each hang burns the 300 s alarm.

**Strategic:** llvm-z80 already IS "clang for z80"; building CE's fork from
source gains nothing (same codegen/runtime/libcall names). ez80clang is only a
comparison point.

# M6: narrow i16 EQ/NE of byte sign-extensions (strrchr IY shuttle)

**Tracker: ravn/llvm-z80#259** (own-repo issue, filed 2026-07-12). No upstream
(llvm/llvm-project) report until a fix is verified end-to-end (user directive:
"no upstream bug reports until we are certain and have a verified fix in place").

## Root cause (verified target-independent)

`*s == (char)c` in strrchr lowers to
`icmp eq i16 (ashr(shl %c,8),8), (sext i8 %s to i16)` — both operands are byte
sign-extensions, so it is a provable i8 compare (`sext(a)==sext(b) <=> a==b`).
The un-narrowed i16 compare consumes HL+DE+BC → loop-carried walk pointer spills
to IY → `push iy/pop de` + `push de/pop iy` shuttle every iteration (~2.2x).

InstCombine narrows the CANONICAL `sext==sext` (`both_sext`) but NOT the
`ashr(shl x,8),8` sext-inreg idiom (`shlashr_vs_sext`). `foldICmpWithZextOrSext`
(InstCombineCompares.cpp ~6360) only matches literal SExt/ZExt casts.

Verified repro (`opt -passes=instcombine`, no triple): `/tmp/icmp_canon.ll` —
`both_sext` -> `icmp eq i8`; `shlashr_vs_sext` keeps `icmp eq i16`.

## Two-tier fix landscape

1. **Z80-local GISel combine `z80_narrow_sext_icmp`** (post-legalizer,
   Z80PostLegalizerCombiner.cpp + Z80Combine.td). Fires at **-Oz/-Os only**;
   6/6 opt-level correctness oracle PASS (`test_50_strrchr.c`, DE=0x007F).
   MISSES -O2/-O3 because LICM hoists the sext before GISel. Leaves an IY
   walk-pointer regalloc residual even at -Oz. REVERTED 2026-07-12 (approach 2
   chosen).
2. **IR-level (InstCombine) narrowing** — the uniform fix: narrow i16 EQ/NE
   where both operands have >= W-8 sign bits (sext-inreg recognizer or
   computeNumSignBits). Fires before LICM → all opt levels. Bigger blast
   radius (generic middle-end, #165 precedent). CHOSEN direction (user "a").
   **IMPLEMENTED + verified 2026-07-12** (InstCombineCompares.cpp
   `matchSignExtLowBits` in `foldICmpEquality`): narrows at ALL opt levels
   (`icmp eq i8` in -Oz/-Os/-O2 IR). Red-green lit test
   `llvm/test/Transforms/InstCombine/icmp-eq-sext-inreg-narrow.ll` (RED on
   reverted compiler, GREEN with fix). Value oracle 6/6 PASS. Z80 lit 194 PASS.
   UNCOMMITTED (working tree only; not pushed).

   **Incidental blocker fixed:** `opt` aborted at startup on any input because 5
   Z80 passes gave a `cl::opt` the same string as their INITIALIZE_PASS arg-name
   (legacy PassNameParser collision; clang/llc unaffected). Renamed the 5 flags
   to `z80-enable-*` + updated lit refs. Same class session 75 fixed once for
   AutoStaticStack; new passes reintroduced it.

## Residuals still open after compare-narrowing

CONFIRMED 2026-07-12: even with the compare narrowed to i8 at every opt level,
regalloc still parks `last`/the walk pointer in IY at `-Oz/-Os` (`push iy/pop
iy` each iter). At `-O2/-O3` the IY shuttle is fully gone. So approach 2 fixes
the filed root cause (compare width) but does NOT clear the size-opt IY
residual — that is the deeper regalloc issue (original M6 framing), SEPARATE
from compare-narrowing.

## Verify commands

- opt repro: `/Users/ravn/z80/llvm-z80/build-macos/bin/opt -passes=instcombine -S /tmp/m6/icmp_canon.ll`
- lit red-green: `build-macos/bin/llvm-lit -q llvm/test/Transforms/InstCombine/icmp-eq-sext-inreg-narrow.ll`
- oracle: `cd llvm-z80/z80-utils/test-runner && PATH="/Users/ravn/z80/z88dk/bin:$PATH" BUILD_DIR=/Users/ravn/z80/llvm-z80/build-macos cargo run --release -- clang strrchr`
- build: `cd /Users/ravn/z80/llvm-z80/build-macos && ninja opt llc clang` (ONE ninja at a time)

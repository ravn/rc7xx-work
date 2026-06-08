# [DRAFT — not filed] CorrelatedValuePropagation strips a narrowness marker that AggressiveInstCombine Phase 2 needs, on targets that prefer branches over selects

**Status:** local draft 2026-06-08.  Not filed.  Awaiting per-filing user
go-ahead per [[feedback_explain_before_filing]].
**Target venue:** `ravn/llvm-z80` (fork-of-record `llvm-z80/llvm-z80` if
engagement mode is reactivated).  This is a target-independent middle-end
observation, but framing first as a fork issue keeps it scoped.

## Title

> [AggressiveInstCombine] Phase 2 (and-mask synthetic trunc root) misses narrowing on targets where `getPredictableBranchThreshold = 0` because CVP strips the `(and X, MASK)` marker

## Summary

`AggressiveInstCombine::TruncInstCombine` Phase 2 looks for `(and X, MASK)`
where `MASK = 2^N − 1` as the trigger for synthesising a trunc root and
narrowing X's expression graph.  On targets where `getPredictableBranchThreshold`
is very low (e.g. Z80 returns `BranchProbability(0, 1)` = 0 %), `SimplifyCFG`
keeps the `if (z & 0x80) atb ^= 0x1b;`-style construct as a branch (not a
select).  The branch form gives `CorrelatedValuePropagationPass`'s `LazyValueInfo`
enough per-edge context to prove the loop-carried phi value already fits in
the narrow type — so CVP folds `(and X, MASK)` as redundant, eliminating
the marker before AggressiveInstCombine runs.

After CVP's strip, the IR has lost the constraint that LVI itself used to
prove the narrowness.  LVI alone — at AggressiveInstCombine's point — can
no longer recover the bound from the loop structure.  Result: a narrowing
that fires on AVR (which prefers selects and keeps the marker) misses on
Z80 (which prefers branches and loses it).

## Repro

C source — K&R-style `gf_log` from AES-256:

```c
#include <stdint.h>
uint8_t gf_log(x) uint8_t x;
{
    uint8_t atb = 1, i = 0, z;
    do {
        if (atb == x) break;
        z = atb; atb <<= 1; if (z & 0x80) atb ^= 0x1b; atb ^= z;
    } while (++i > 0);
    return i;
}
```

Compile twice with the same llvm-z80 build's `clang`:

```sh
clang --target=z80 -Os -S -emit-llvm -Wno-deprecated-non-prototype -o - gflog.c | grep -E 'phi|icmp.*i[0-9]+ |and i[0-9]+ %'
clang --target=avr -mmcu=atmega328p -Os -S -emit-llvm -Wno-deprecated-non-prototype -o - gflog.c | grep -E 'phi|icmp.*i[0-9]+ |and i[0-9]+ %'
```

Z80 output (excerpt) — phi at i16, icmps at i16:
```
  %4 = phi i16 [ 1, %1 ], [ %17, %14 ]
  %6 = icmp eq i16 %5, %2
  %10 = and i16 %5, 128
  %11 = icmp eq i16 %10, 0
```

AVR output (excerpt) — phi at i8, icmps at i8:
```
  %4 = phi i8 [ 1, %1 ], [ %16, %9 ]
  %8 = icmp eq i8 %5, %7
  %14 = icmp eq i8 %13, 0
```

Same middle-end code path produced different results because Phase 2's
trigger condition differs between the two pipelines.

## Where the trigger differs

Per-pass IR dump shows the chain on Z80:

1. Early `InstCombine` widens the `atb` phi from i8 to i16 (int-promotion
   artefact).
2. Many passes carry it as i16.
3. The IR shape entering `CorrelatedValuePropagationPass` has
   `%5 = and i16 %4, 255` (the canonical mask preserved by InstCombine —
   *both targets agree at this point*).
4. CVP runs.  On Z80, `LazyValueInfo` proves `%4 ≤ 255` via fixed-point
   over the loop's cycle (using per-edge ranges from the `if (z & 0x80)`
   branch).  CVP folds away the mask as redundant: `(and %4, 255) → %4`.
5. AggressiveInstCombine runs.  Phase 2 (`TruncInstCombine.cpp` line ~829)
   pattern-matches `(and X, MASK)` to inject a synthetic trunc root.  No
   such AND exists anymore — Phase 2 skips this function entirely.
6. The phi stays at i16.  Downstream the icmp and the `(and %4, 128)`
   bit-test stay at i16 too.

On AVR, the `if (z & 0x80)` is lowered to a `select` instead of a branch.
LVI doesn't get the per-edge ranges and doesn't prove `%4 ≤ 255` at CVP's
call site, so CVP doesn't strip the mask.  AggressiveInstCombine then
sees the marker and Phase 2 fires.

## Why the obvious fixes don't work

- **Use LVI in AggressiveInstCombine to recover the bound.**  Tried:
  wired `LazyValueAnalysis` through the pass and added a KnownBits-then-LVI
  fallback in the soundness gate.  Instrumented `errs() << ...`: LVI returns
  full-set on the post-CVP IR.  The constraint that LVI used to prove
  narrowness was the mask CVP stripped — once gone, LVI cannot recover
  the bound from the loop body alone.
- **Change Z80's `getPredictableBranchThreshold`.**  The hook is in
  `Z80TargetTransformInfo.cpp:62-64`, set to `BranchProbability(0, 1)`
  since zlfn's initial backend commit (`31997a6`, 2026-03-12).  Affects
  every branch decision in the backend; high risk of regressing other
  code size / speed.
- **Teach CVP not to strip the mask.**  Architecturally awkward: CVP
  would need to know about a downstream pass's needs, which breaks
  abstraction.

## What we think is needed

A frontend-emitted narrowness hint (`!range` metadata on the int-promoted
uint8_t phi) would survive CVP and serve as Phase 2's trigger.  Or a
stronger middle-end loop-carried KnownBits / range analysis that doesn't
need the explicit `(and X, MASK)` marker.

Filing this issue is mostly to PIN the multi-pass interaction in the
record so future work doesn't re-discover it from scratch.

## Provenance

- Investigated 2026-06-08 after the icmp-narrow sound gate (v1 + v2)
  landed and AES K&R `gf_log` failed to recover the pre-revert wins.
- Full writeup: `llvm-z80/tasks/session-2026-06-08-clang-vs-sdcc-speed-investigation.md`.
- Earlier related bugs filed at `llvm/llvm-project#202112` (#158
  TruncInstCombine Argument-leaf).

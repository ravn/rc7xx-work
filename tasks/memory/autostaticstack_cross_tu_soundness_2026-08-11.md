# Z80AutoStaticStack cross-TU recursion soundness fix (2026-08-11)

## Symptom (verified)
`test_09_cross_recursion` interop FAILed on the 32-bit `unsigned long`
mutual-recursion case: expected `0x000A`, got `0x0008` (clang↔sdcc, O1) or
`0x0002` (clang↔clang, separate TUs). 16-bit recursion and the deep chain
passed. Isolated with a non-foldable manual repro (`/tmp/xr/m.c`+`other.c`,
separate TUs, volatile), run via z88dk-ticks reading DE at `_halt`.

## Root cause (confirmed)
`Z80AutoStaticStack.cpp` is a **default-on** pass (`cl::init(true)`,
`-z80-enable-auto-static-stack`) that auto-injects `+static-stack` on
functions its **module-local** CallGraph-SCC scan deems non-recursive.
`+static-stack` puts live-across-call spills in FIXED BSS
(`__sframe_<name>`/`__sfrend_<name>`); a recursive re-entry clobbers them.

The non-recursion proof is UNSOUND under separate compilation: a function
calling an `extern` declaration lands in its own single-node SCC
(edge → CallsExternalNode / empty callee) and looks non-recursive, but can be
mutually recursive across the TU boundary. Decisively confirmed: with
`-mllvm -z80-enable-auto-static-stack=false`, `__sfrend` count → 0 and
recursion → `0x000A`.

## Fix (option A — sound auto-inject, preserve density)
Non-leaf function is auto-static-stack-safe iff module-SCC-non-recursive AND
(`hasLocalLinkage()` OR NOT `ReachesExternal`). Added a `ReachesExternal`
SmallPtrSet in `runOnModule`: seeded from edges with null callee
(CallsExternalNode) or `Callee->empty()` (declaration), propagated backward via
a predecessor map over resolvable internal edges. `processFunction` takes it as
a 4th arg; Level-2 gate:
`if (!Safe && NonRecursive.contains(&F) && (F.hasLocalLinkage() || !ReachesExternal.contains(&F))) Safe = true;`
Rationale: a local, non-address-taken fn can't be named cross-TU → all cycles
through it are intra-module and visible to the SCC scan. Leaves always safe.

## Production is UNAFFECTED (verified with real artifact)
autoload/BIOS pass `+static-stack` **explicitly**
(`autoload-in-c/Makefile` ~L267: `-Xclang -target-feature -Xclang +static-stack`).
The pass early-outs on `Existing.contains("static-stack")`, so explicit opt-in
is honored verbatim. Real autoload PROM rebuild: byte-identical except the
embedded build-date/commit string. So the user's rule holds — a function is
non-reentrant only when static-stack is EXPLICITLY enabled, or when the pass
soundly proves safety.

## Tests
- `issue-12-auto-static-stack-cross-tu-recursion.ll` — pins the sound gate
  (external+external→no frame; internal→keeps; external+internal-only→keeps;
  global opt-out).
- `issue-254-o0-static-frame-underflow.ll` — `@f` (external + memmove) no
  longer auto-qualifies; re-pinned via explicit `attributes #1 =
  { "target-features"="+static-stack" }`. The frame-layout invariant is
  orthogonal to how the feature was enabled.
- Z80 lit: 217 PASS + 5 XFAIL, 0 FAIL. sdcc interop: 102 PASS / 0 / 0.

## Caveats / gotchas
- `ninja -C build-macos clang` does NOT rebuild `llc`; build it separately or
  lit tests run against a stale llc.
- Single-TU clang recursion probes constant-fold at O1 → useless; use separate
  TUs + volatile.
- Explicit `+static-stack` still bypasses the gate — an explicitly-opted-in
  RECURSIVE function would still be miscompiled (by design; user takes
  responsibility). Production firmware is known-non-recursive / boots.

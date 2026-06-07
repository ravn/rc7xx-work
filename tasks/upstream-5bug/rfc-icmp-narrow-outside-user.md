# [DRAFT — not filed] RFC: Extend TruncInstCombine's outside-user allowlist with a sound icmp narrowing path

**Status:** local draft for user review, 2026-06-08.  Not posted.
**Target venue:** LLVM Discourse, `RFC` tag (the LLVM Project / Subprojects → LLVM IR category typically).  Mirror summary in an issue at `llvm/llvm-project` once the thread has a maintainer ack.
**Per [[feedback_explain_before_filing]]:** user gives explicit per-filing go-ahead before this leaves the project.
**Per [[feedback_file_bugs_not_fixes]]:** this is an RFC, not a bug filing — but the discipline still holds for the "evidence + soundness" framing.  No PR / patch / diff included in the post body; the post proposes the *direction*, the maintainer decides the shape.

---

## Title (one line, for the Discourse subject)

> RFC: Extend `TruncInstCombine` to allow narrowing icmp users that observe the trunc-graph operand at a provably-narrow width

## TL;DR (1 paragraph)

`TruncInstCombine` (in `AggressiveInstCombine`) narrows expression graphs rooted at a `trunc` by walking the graph back from the trunc and rebuilding it at the narrow type.  Today it bails on any outside-graph user that isn't a `ZExt`/`SExt`, including icmps that observe the graph value and are themselves narrowable.  This is conservative-correct but leaves real codegen wins on the floor on small-integer-native targets — Z80, AVR, and any backend whose narrow ops are materially cheaper than its wide ones.

This RFC proposes a narrow extension: admit outside `ICmpInst` users when **both** operands are provably narrow under `KnownBits`, with a tightened threshold for samesign-signed predicates.  The soundness boundary is the question the maintainers should review; the precise hook shape and rewrite mechanics are theirs to decide.

## Background

Today's outside-user gate in `TruncInstCombine::getBestTruncatedType` (today's `TruncInstCombine.cpp`, around the user-iteration loop in `getBestTruncatedType`) returns `nullptr` whenever an in-graph value has a user that's neither in-graph nor an `ext` whose source type matches the narrow type.  An icmp user — even one of the form `icmp eq i16 %t, 0` where `%t` is in the graph and `0` trivially fits the narrow type — disqualifies the entire graph.

That's the right default: an outside icmp observes the full *wide* value of the graph operand it consumes, so narrowing it without proof would replace a wide comparison with one over only the low N bits.  Wrong result whenever the wide operand's high bits are set.

But for many idiomatic C patterns — particularly **C int-promotion of `unsigned char` arithmetic, K&R-style parameters that default-promote to `int`, and bit-test loops over byte values** — every wide value in the graph is provably narrow at the IR level (typically a `zext i8 to i16` lineage).  In those cases the outside icmp is sound to narrow alongside the graph, and the bail is gratuitously conservative.

## Motivation: 8-bit-native targets

On wide-native targets (x86, ARM) the cost difference between an i32 and an i16 comparison is small, often zero after isel.  On 8-bit-native targets the difference is structural:

- **Z80**: a 16-bit compare against a constant is 3 instructions; an 8-bit compare is 2 bytes / 1 instruction.  Inside a tight loop, the compounding adds up — see the AES `gf_log` measurement below.
- **AVR**: similar — 16-bit compare requires the high-byte path; 8-bit compares are register-direct.

Even MSP430 (16-bit native) benefits from the 16→8 narrowing direction in some shapes, though less dramatically.

The current outside-user bail is felt acutely on these targets and only mildly elsewhere.

## Proposed direction

Add a third arm to the outside-user check in `getBestTruncatedType` (alongside the existing in-graph and ext arms): if the user is an `ICmpInst` and a soundness predicate succeeds, record it for later rewrite and `continue`.  Add a corresponding rewrite step in `ReduceExpressionGraph` that runs *before* the phi-erase loop (so the still-wide icmp operands don't get RAUW'd to poison).

The soundness predicate has three parts:

1. **Predicate gate** — admit eq/ne and the unsigned predicates always; admit signed predicates only when the icmp has the `samesign` flag set.

2. **Fit-width** — for unsigned/eq predicates, the operand fit threshold is `NarrowBits` (any value representable at the narrow width is fine).  For samesign-signed predicates, tighten to `NarrowBits − 1` so the sign bit stays clear at the narrow width and the samesign assertion (signed/unsigned agree) survives the narrowing.

3. **Both-operands narrowness** — the crucial step.  KnownBits-prove that **both** the in-graph value and the non-graph operand fit in the fit-width.  Variable non-graph operands additionally require `hasOneUse()` so the narrow trunc inserted at the icmp site doesn't leave the wide value alive in parallel.

Pseudo-shape (not a patch — the maintainer decides where this lives and whether it's a method, a static, or fused into the existing gate):

```
canNarrowIcmpThroughGraph(Cmp, GraphValue, NarrowTy):
  if not predicateGate(Cmp): return false
  fitBits = isSigned(Cmp.predicate) ? NarrowBits - 1 : NarrowBits
  Other = the operand of Cmp that isn't GraphValue (or return false if neither is)
  if computeKnownBits(GraphValue).getMaxValue().getActiveBits() > fitBits:
    return false      // graph-side soundness gate
  if Other is ConstantInt:
    return constant fits in fitBits
  if not Other.hasOneUse(): return false
  return computeKnownBits(Other).getMaxValue().getActiveBits() <= fitBits
```

## Soundness argument (the part to review)

The key insight that the original local extensions on our fork missed: **the trunc graph proves the in-graph value is being narrowed for the graph's own purposes, but it does NOT prove the in-graph value's high bits are zero**.  Narrowing is a *projection*, not a *witness*.  An outside icmp observes the un-projected value.

Concretely: in `%t = add i16 %x, 1; %r = trunc i16 %t to i8; icmp ult i16 %t, 10`, the graph rewrites `%t` to an i8 add and feeds it into both the trunc-consumer (sound) and a hypothetically-narrowed icmp.  When `%x = 260`, `%t` at i16 = 261; at i8 = 5.  The wide icmp says `261 < 10 = false`; the narrow one says `5 < 10 = true`.  Different result.

The graph-side KnownBits gate (`computeKnownBits(GraphValue).getMaxValue().getActiveBits() <= fitBits`) closes this hole.  Without that gate, the optimization is unsound; with it, the narrow icmp's result agrees with the wide icmp's result for every reachable runtime value.

For samesign-signed predicates, the additional `NarrowBits − 1` threshold is needed because samesign's assertion is at the *wide* width.  At the narrow width, a value of 200 (positive at i16, fits unsigned i8) becomes negative (−56) under signed reading, which flips the comparison.  Tightening to `NarrowBits − 1` keeps the narrow-width sign bit clear.

## Evidence

### Z80 (positive)

AES-256 K&R-style `gf_log` lookup loop — the canonical 8-bit cryptographic hot path.  Before: 153 B / a slow loop.  After: 28 B / 5.4× speedup.  IR shape:

```
%9  = zext i8 %atb to i16
%11 = zext i8 %x to i16
%12 = icmp eq i16 %9, %11        ; ← outside-graph user, both operands proven narrow
...
%22 = and i16 (zext i8 to i16), 128
%23 = icmp ne i16 %22, 0          ; ← outside-graph user, both operands proven narrow
```

Without the extension, the graph stays at i16 and the loop never narrows.  With it, narrowing fires and the trunc/zext shoulders disappear.

Larger-corpus measurement (AES-256 13-config sweep at `-Oz` and variants): `09_Oz_prod_like` 2866 → 2581 B (−10 %).  All 13 configs verifier-PASS.

### AVR (positive cross-target witness)

A target-independent middle-end pass should benefit any target whose narrow ops are cheaper.  To confirm, I compiled a runtime soundness probe with `clang --target=avr -mmcu=atmega328p -Os` and ran it under `simavr`.  The probe has two shapes (`pick_var` with a variable bound, `pick_const` with a constant bound), each set up so the *unsound* narrowing would return `0x05` and the *sound* result is `0x63`.

Output:

```
pick_var(260,10)=0x63
pick_const(260)=0x63
VERDICT: SOUND
```

The optimization is target-independent middle-end, so this is a property of the *pass*, not of either backend.  It just makes the cross-platform value concrete.

### Soundness witnesses (runtime + lit)

- **Runtime:** the same `pick_var` / `pick_const` shape returns `0x63` at every opt level (O0/O1/O2/O3/Os/Oz) under Z80 too.  Unsound narrowing returns `0x05` — a clean runtime witness.
- **Lit:** a 21-function matrix pins the soundness boundary precisely: `unproven_*` shapes (graph-side KnownBits doesn't fit) must NOT narrow across all six unsigned + samesign-signed predicates; `proven_*` shapes (both sides fit) must narrow; samesign-signed splits at the `NarrowBits − 1` boundary (mask 127 narrows, mask 255 doesn't); multi-escape and i32→i16 width-generality covered.

## Open questions for reviewers

1. **Where does the gate live?**  In `getBestTruncatedType` (today's outside-user loop) is the natural home.  Alternative: factor the outside-user check into a separate method and dispatch on user kind.  Maintainer call.

2. **Should samesign-signed be in v1 at all?**  The C int-promotion shapes I care about are eq/ne/unsigned exclusively.  Samesign-signed adds matrix surface (the `fitBits − 1` boundary) for limited benefit.  I'd be content to drop it from v1 if reviewers prefer.

3. **Variable-Other use-count gate.**  v1 requires `Other->hasOneUse()` for the non-constant other-operand path, so the trunc inserted at the icmp site doesn't leave the wide value live in parallel.  Is this the right cost gate, or should it be a TTI hook (e.g. `isZExtFree(NarrowTy, OrigTy)`)?  The latter would let wide-native targets accept multi-use variable-Other shapes cheaply.

4. **Phase ordering.**  The rewrite of the admitted icmps must happen before the phi-erase loop in `ReduceExpressionGraph`, otherwise the phi-RAUW-to-poison corrupts the still-wide icmp operands.  Worth surfacing in case the maintainer prefers a different structural rearrangement.

5. **And-mask outside-user path.**  A parallel extension I haven't proposed in v1: `(and X, Const)` users where `Const` fits in the narrow type.  That one is sound *regardless of graph-side proof* (the mask consumes only low bits), so the soundness argument is structurally different.  Worth a follow-up?

## Alternatives considered

- **Do nothing.**  Wide-native targets aren't measurably hurt by the conservative bail.  But narrow-native targets pay a real density / speed cost (5× in the gf_log case).
- **Backend-local LLVM IR pass.**  Z80 could carry this on the fork — and did, with the soundness bug that drove a 2026-06-07 revert.  The maintenance overhead and the soundness risk both point at upstreaming.
- **Patternmatch in the backend instead of the middle end.**  Targets could pattern-match the wide compare and narrow at isel.  More cost, less coverage, doesn't help DCE of the now-dead high-byte chain in the middle end.

## Non-goals

- This RFC does *not* propose a new TTI hierarchy for 8-bit targets.  A `BasicTTIImpl8Bit` base would share modest surface (`getPredictableBranchThreshold=0`, `prefersVectorizedAddressing=false`, vectorizer-hooks-NOT-implemented) and is a separate discussion if anyone wants it.
- This RFC does *not* propose narrowing icmps unconditionally — only admitting them as outside-graph users of the existing trunc-rooted graph, where the graph rewrite is already happening for other reasons.

## Appendix: relationship to prior work

- ravn/llvm-z80 carried a local extension (#160 / #165) that introduced an icmp outside-user path with the same shape but without the graph-side soundness gate.  That extension was reverted on 2026-06-07 after `test_220 / test_221 / test_222` runtime witnesses surfaced the unsoundness.  The current sound version (and the lit matrix that pins its boundary) is the redesign.
- llvm/llvm-project#202112 (the previously-filed K&R argument-leaf bug) is unrelated except thematically: both target the same pass and both come from the same 8-bit C-source pattern.

---

## What to ask before posting

(For my own internal use, not part of the RFC body.)

- Confirm the soundness argument in §"Soundness argument" reads cleanly to a third party.
- Decide whether to include the variable-Other `hasOneUse()` path or scope v1 to constant-Other only (smaller surface, easier sell, less win).
- Decide whether the AVR cross-target evidence stays prominent or moves to an appendix.
- Decide where to mirror the post: Discourse RFC thread is primary; an issue at `llvm/llvm-project` referencing the thread is the typical anchor.
- Confirm with the user that the framing matches their understanding well enough to defend it in a back-and-forth.

# Bug 4 — explanation for the author

Plain-English walkthrough so you can write the upstream issue in your own
words.  My findings (sizes, cycles, IR snippets) become an appendix to
your text.

## The one-sentence framing

LLVM's `TruncInstCombine` middle-end pass tries to narrow expression
graphs rooted at a `trunc` from wide to narrow types.  When any value in
the graph has a user *outside* the graph that isn't a `ZExt`/`SExt`, the
pass refuses to narrow at all — even when the outside user is trivially
narrow itself.  On 8-bit-native backends this turns idiomatic K&R-style
`uint8_t` loops into 16-bit code where 8-bit is achievable.

## The shape that triggers it

C int-promotion is the seed.  This K&R-style declaration:

```c
uint8_t gf_log(x)
uint8_t x;
{
    uint8_t atb = 1, i = 0, z;
    do {
        if (atb == x) break;
        z = atb; atb <<= 1; if (z & 0x80) atb ^= 0x1b; atb ^= z;
    } while (++i > 0);
    return i;
}
```

is, by C's rules, equivalent to declaring `gf_log` with a parameter of
type `int` (promoted from `uint8_t`).  By the time the front-end has
finished, the parameter is `i16` and there's an implicit `(x & 0xFF)`
mask telling later passes that only the low 8 bits matter.

Inside the loop, `atb` is a `uint8_t`.  But because it's compared
against `x` (which is `i16`-typed in IR), the comparison forces `atb`
to be widened to `i16` too.  The middle-end carries this `i16` `atb`
through the whole loop.

At the loop exit, the `return i` (where `i` is the `i8` counter)
introduces a `trunc i16 ... to i8` somewhere.  That `trunc` is the
*root* of an expression graph that the pass walks backwards through to
find narrowable shapes.

The graph rooted at the trunc includes: the `i16 phi` of `atb`, the
`shl i16` (left shift), the `xor i16` (with 0x1b), the `and i16` (with
mask 128) inside the bit test, etc.  All of those operations are i16 in
the IR but would happily fit in i8.

The blocker: the i16 phi has a *second* user — the `icmp eq i16 %atb,
%x_masked` that decides whether to break out of the loop.  That's the
*outside-graph user*.  And `TruncInstCombine` bails on the entire
narrowing because that outside user isn't a ZExt/SExt.

## What the compiler does instead

It keeps everything at `i16`.  On AVR (8-bit register file), `i16`
operations become register-pair operations:

- 16-bit add → `add r24, r24; adc r25, r25` (two instructions)
- 16-bit compare → `cp r22, r24; cpc r23, r25` (two instructions)
- 16-bit register-to-register copy → `movw rd, rs` (one instruction
  but a register pair)
- 16-bit AND-with-constant → two `andi` (one per byte)

Stack these up inside a hot loop and the function balloons.  In our
case the `gf_log` helper compiles to 70 bytes of AVR code with an inner
loop of 16-bit ops, and a 256-call sweep takes 825,294 cycles.

## What the compiler *should* do

If `TruncInstCombine` admitted the outside-graph `icmp` user when it
can prove both sides fit the narrow type, the graph collapses to i8.
The same function compiles to **48 bytes** (~31 % less) with a
single-instruction 8-bit `cp r18, r24` compare in the inner loop, and
the cycle count drops to **595,773** (~28 % less).

## Why the bail exists

This is the bit you'll need to articulate carefully.  The bail is
*conservative-correct*.  Here's the subtle part:

The trunc graph proves the in-graph value is being *projected* down to
the narrow type for the trunc's own purposes.  But that projection is
just discarding the high bits at the trunc.  It does NOT prove the
high bits are zero at the *outside-graph* user.

Concretely: imagine

```llvm
%t = add i16 %x, 1                      ; in graph
%r = trunc i16 %t to i8                 ; the trunc that roots the graph
%c = icmp ult i16 %t, 10                ; outside-graph user
```

The graph would narrow `%t` to an `i8 add`.  That's correct for
`%r` — truncating to i8 is the same as adding at i8 and reading.

But the outside-graph `%c = icmp ult i16 %t, 10` observes the *wide*
`%t`.  If `%x = 260`, then `%t` at i16 = 261, and `%c = (261 < 10)` is
**false**.  If you naively narrow `%c` to `icmp ult i8 (i8 %t), 10`,
the narrowed compare is `(5 < 10)` = **true**.  Different result.

So narrowing the outside icmp is *unsound in general*.  The pass
correctly refuses.

## Why the bail is *too* conservative

In the K&R-pattern case, the in-graph value is *also* provably narrow.
The C source-level `uint8_t` shows up in the IR as `(x & 0xFF)` masks
near the boundary; `KnownBits` can read these and prove the in-graph
value's high bits are zero.  When that holds, narrowing the outside
icmp IS sound because the wide and narrow values agree on every
reachable runtime value.

The pass already doesn't have to *do* the narrowing if it can't
prove this.  It just needs to *check* and admit the case when it can.

## The proposed fix direction

Three pieces, all standard middle-end machinery:

1. **Predicate gate.**  Equality (`eq`/`ne`) and unsigned predicates
   are always value-preserving when both sides fit the narrow type.
   Signed predicates are trickier because the sign bit flips at the
   narrow boundary — restrict to operands fitting `NarrowBits − 1`
   (so the narrow-width sign bit stays clear).

2. **Fit-bits check on both operands.**  Use `computeKnownBits` on
   *both* the in-graph value and the outside operand.  Constants and
   single-use variables both work.  This is the load-bearing safety
   gate.

3. **Rewrite step.**  When admitted, replace the outside icmp with
   `icmp <pred> (trunc lhs to NarrowTy), (trunc rhs to NarrowTy)` in
   `ReduceExpressionGraph`, before the phi-erase loop.

A parallel admission for `(and X, Const)` outside-graph users where
`Const` fits the narrow type is also sound — the mask discards high
bits unconditionally, so the rewrite is safe regardless of the
in-graph KnownBits.

That's it.  No new analyses, no IR-level changes outside the pass, no
target-specific code.

## Why file this against AVR specifically

The bail is target-independent middle-end code.  The bug fires on
any target.  But on wide-native targets (x86, ARM) the cost
difference between i16 and i8 compares is small or zero after
isel — the missed opt doesn't show up as a visible size/speed delta.
On AVR (8-bit registers, distinct 16-bit and 8-bit instruction
families, `movw` and `cp + cpc` patterns visible in the codegen) the
delta is concrete and quantifiable.

AVR is the right framing because it makes the bug *observable* with
standard tools (`avr-size`, `avr-objdump`, simavr cycle count).  A
Z80 framing would say the same things but require explaining the Z80
backend; the AVR backend is in-tree and reviewers don't need
context.

## The pattern is common, not contrived

The reducer is `gf_log` from public-domain AES-256 (Ilya O. Levin,
literatecode.com, 2007-2009).  It's the K&R-style version of the
canonical Galois-field logarithm helper — appears verbatim or near-
verbatim in many 1980s-2000s embedded-C cryptographic libraries.
Same loop shape appears in CRC table computation, byte-level
protocol parsers, and any embedded routine that walks a `uint8_t`
range with an early-exit check.

If you want to gesture at the generality without dragging in a long
list, "C int-promotion of `uint8_t` arithmetic" covers most of it.

## How to structure your write-up

(Suggested skeleton — feel free to ignore.)

1. **One-paragraph framing.**  AVR target, K&R uint8_t pattern, the
   bail at `getBestTruncatedType`, size + cycle delta numbers.

2. **The reducer.**  Verbatim C, build command, what to look at
   (`avr-size`, `avr-objdump`).

3. **Observed vs expected.**  AVR codegen excerpts side by side.  IR
   excerpts side by side.  Numbers in a table.

4. **Cause + soundness.**  Walk the maintainer through *why* the
   bail exists (the soundness reason — the in-graph projection vs the
   outside observation) and then *why* it's too strict for this
   pattern (KnownBits can prove safety).

5. **Direction.**  Predicate gate + KnownBits gate on both operands +
   rewrite step.  Not a patch.

6. **Notes for reviewers.**  Why AVR specifically; cross-target
   benefit; offer to share our out-of-tree witnesses if they want
   them.

## What the appendix should contain (the artefacts I produced)

These go after the body or as linked attachments — they're the
empirical backing, not the framing.

- **`avr-gflog-missed-opt.c`** — the standalone single-file reducer
  (~32 lines C).  Build command, observed vs expected size in the
  comment header.
- **`avr-gflog-runtime.c`** — the simavr Timer1 cycle harness used to
  measure the 825,294 vs 595,773 cycle figures.  Useful if a
  reviewer wants to run the cycle measurement themselves.
- **Cycle measurement table.**  Numbers, methodology, what counts as
  the "expected" baseline.
- **IR diff** (the `i16 phi` blocker / `i8 phi` after).  This is
  arguably load-bearing enough to keep in the main body rather than
  the appendix; your call.
- **Codegen excerpts.**  16-bit `cp + cpc` and `movw` vs 8-bit `cp`.
  Same call: appendix or body, depending on how compressed you want
  the body.
- **The reference to our out-of-tree sound implementations** — fork
  commits `fa1606f34c6b` (sound `#160`) and `c4f52eb17a76` (sound
  `#165`), plus the 304-line lit suite at
  `trunc-narrow-icmp-graph-side-soundness.ll`.  Position as
  "available on request" rather than "look at what we did."
- **The upstream-verification record** — that we checked the source
  on `llvm/llvm-project/main` (still has the bail), the open PR list
  (zero touching this file), open issues (only `#202112`, our own
  argument-leaf bug filed previously).  Establishes the bug is
  unfixed and unaddressed-in-flight, so the maintainer knows they're
  not duplicating work.

## What to read carefully before writing

These are the parts I'm least certain of in my framing — read them
and tell me if any feel off:

1. **The soundness reason for the bail.**  I described it as
   "narrowing the icmp is unsound in general because the wide value
   may have set high bits at the outside observation point."  That's
   true but it's possible to express it more crisply if you have a
   different mental model.  My phrasing leans on the worked example
   (the `%x = 260` walkthrough) to do the heavy lifting.

2. **The `NarrowBits − 1` thing for signed predicates.**  This is
   the most fiddly bit of the proposal.  If you'd rather scope v1 to
   eq/ne + unsigned only and drop signed entirely, the report
   becomes simpler and the maintainer can ask "what about signed?"
   in a follow-up.  Lower surface area, easier first ask.

3. **The "both operands fit" framing.**  Constants are easy.
   Variable operands need `hasOneUse()` so the narrow trunc inserted
   at the icmp site doesn't leave the wide value live in parallel.
   That detail is in my draft but not in this explanation; you can
   skip it for the first pass and let the maintainer surface it.

4. **The provenance line.**  "Public-domain AES-256 by Ilya O. Levin
   (literatecode.com, 2007-2009)" — important because (a) it
   establishes the source isn't contrived; (b) it forecloses
   "is this even portable C?" objections.  Worth including.

5. **The "available on request" framing for the out-of-tree
   artefacts.**  Lower-friction than dumping diffs into the issue
   body and lower-key than "look at what we did."  I used this
   framing because reviewers vary in how they react to "we have an
   out-of-tree implementation."  Adjust to your judgement on the
   specific maintainer.

## What to ask me if anything's unclear

- Why does the bail exist?  (Section "Why the bail exists" above —
  the worked `%x = 260` example.)
- Why does `KnownBits` close the soundness hole?  (Section "Why the
  bail is *too* conservative" — the C source-level `uint8_t` shows up
  as `(x & 0xFF)` masks the analysis can read.)
- How sure are we the bug is target-independent middle-end?  (The
  bail is in `lib/Transforms/AggressiveInstCombine/`, which runs
  before any backend.  The target only affects how *visible* the
  miss is in codegen.)
- Why not file as an RFC instead?  (Concrete reducer + concrete
  numbers → an issue is the right venue.  RFCs are for direction
  discussions where the bug is broad or the fix shape is contested.
  We have a sharp bug with sharp numbers.)

# Source-level workarounds for bug 4 — what the smallest change is

**Captured 2026-06-15** while preparing the upstream filing.  Variant
source at `tasks/upstream-5bug/gflog-variants.c`; build/measure on
both fork main (bug 4 fix) and baseline (TruncInstCombine reverted to
`05d44629e717`).

## Eight source-level variants tested

| V | Change vs original | Size (with bug 4) | Size (stock, baseline) | Δ |
|---|---|---|---|---|
| **v0** | original K&R (`uint8_t gf_log(x) uint8_t x; { ... if (atb == x) ...; if (z & 0x80) ...; }`) | 48 B | **70 B** | the bug |
| **v1** | ANSI prototype only (`uint8_t gf_log(uint8_t x)`) | 48 B | **62 B** | partial — fixes icmp side only |
| **v2** | K&R + cast in icmp (`if (atb == (uint8_t)x)`) | 48 B | 70 B | no change vs v0 |
| **v3** | K&R + local copy (`uint8_t xb = x; ... if (atb == xb)`) | 48 B | 70 B | no change vs v0 |
| **v4** | ANSI + sign-bit form (`if ((int8_t)z < 0)` instead of `if (z & 0x80)`) | 48 B | **48 B** | **fully unblocks** |
| **v5** | ANSI + branchless materialize (`m = (z & 0x80) ? 0x1b : 0; atb = (atb<<1)^m^z;`) | 48 B | 66 B | partial — fixes neither cleanly |
| **v6** | prototype + K&R definition body (`uint8_t gf_log_v6(uint8_t); uint8_t gf_log_v6(x) uint8_t x; { ... }`) | 48 B | **62 B** | matches v1 — prototype carries the type info, K&R body is fine |
| **v7** | prototype + K&R body + sign-bit form | 48 B | **48 B** | matches v4 — fully unblocks |

## Conclusion

**There is no single-line workaround that unblocks the narrowing on
stock LLVM.**  Both outside-graph user shapes (the loop-exit icmp AND
the bit-test and-mask) need to be addressed at the source for the
optimization to fire on its own:

1. The `if (atb == x)` icmp's outside-graph wide operand is unblocked
   by **either ANSI prototype OR a prototype declaration in scope
   before the K&R definition** (parameter `x` arrives as i8, no i16
   carriage at the call site).
2. The `if (z & 0x80)` and-mask outside-graph user is unblocked by
   **rewriting as sign-bit comparison** `if ((int8_t)z < 0)`, which
   InstCombine narrows directly (no `and i16 %z, 128` shape survives).

**Two equivalent "minimal fix" source forms** (both reach 48 B on
stock LLVM):

- **v4** — ANSI prototype + sign-bit form.  Full ANSI conversion.
- **v7** — ANSI prototype declaration + K&R definition body + sign-bit
  form.  Keeps the K&R definition syntax for code-style consistency
  with the original (and avoids touching the function definition's
  surface form), but the prototype carries the type info that matters.
  Clang emits an informational `-Wknr-promoted-parameter` warning
  about historical compatibility but accepts the form and produces
  the same IR.

**v1 / v6 (prototype only) saves 8 B (62 vs 70)** by unblocking just
the icmp side.  The remaining 14 B are tied up in the i16 carriage that
the `& 0x80` and-mask forces.

**v2 (cast in icmp) and v3 (local copy) achieve nothing.**  InstCombine
doesn't fold the cast / local before TruncInstCombine runs; the IR
shape that reaches the pass is byte-identical to v0.

## Why this matters for the upstream report

Two implications:

1. **Documents that "just use a different cast" doesn't work.**  When the
   maintainer asks "isn't this just a programmer error easily fixed at
   the source?", the answer is concrete: only one specific pair of
   source-level changes (ANSI + sign-bit) closes the gap, and that pair
   is unobvious without tracing the IR.  Most embedded C programmers
   would reach for `(uint8_t)x` or a local copy first — neither works.

2. **Strengthens the "compiler should fix this" argument.**  The optimization
   the bug 4 fix performs is mechanical IR-level work; the equivalent
   source-level work requires the programmer to anticipate two specific
   IR shapes (the outside-graph icmp and the outside-graph and-mask)
   and rewrite both.  Compiler infrastructure exists precisely to
   relieve programmers of this kind of micro-anticipation.

The variants table above is useful as a footnote to the upstream
report — concrete evidence that the bug isn't just a "use better C"
problem.

## IR shape per variant on baseline (stock LLVM)

**v0 (the bug):**

```llvm
%5 = phi i16 [ 1, %1 ], [ %16, %8 ]   ; i16 phi — root of trunc graph
%6 = and i16 %5, 255
%7 = icmp eq i16 %6, %2               ; outside-graph icmp user (blocks)
%11 = and i16 %5, 128                 ; outside-graph and-mask user (blocks)
%12 = icmp eq i16 %11, 0
```

**v1 (ANSI alone — icmp narrowed, but and-mask still i16):**

```llvm
%4 = phi i16 [ 1, %1 ], [ %14, %7 ]   ; STILL i16 phi
%5 = trunc i16 %4 to i8
%6 = icmp eq i8 %0, %5                ; ✓ i8 icmp (% 0 is i8 ANSI param)
%9 = and i16 %4, 128                  ; ✗ still i16 outside-graph and-mask
%10 = icmp eq i16 %9, 0
```

**v4 (ANSI + sign-bit form — fully narrow):**

```llvm
%4 = phi i8 [ 1, %1 ], [ %11, %6 ]    ; ✓ i8 phi
%5 = icmp eq i8 %4, %0                ; ✓ i8 icmp
%8 = icmp slt i8 %4, 0                ; ✓ i8 sign-bit test — no and-mask shape
%10 = select i1 %8, i8 %9, i8 %7
```

The `(int8_t)z < 0` source idiom lowers to `icmp slt i8 %z, 0` —
which doesn't introduce an `and` operation at all.  The trunc graph
no longer has any outside-graph user, so InstCombine narrows
trivially.

## Summary in one sentence

The smallest source change that makes the bug disappear is "use an
ANSI `uint8_t` prototype AND replace `if (z & 0x80)` with `if ((int8_t)z < 0)`"
— neither half is sufficient alone, and the more obvious workarounds
(cast `(uint8_t)x` in the comparison, copy `x` to a local `uint8_t`)
don't help at all because InstCombine doesn't pre-fold them before
TruncInstCombine sees the IR.

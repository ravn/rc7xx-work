(FILED as llvm/llvm-project#202112 on 2026-06-07; staging copy ravn/llvm-z80#218 closed. This file is the as-filed record.)

Title: [AggressiveInstCombine] TruncInstCombine cannot narrow any expression that reaches a function Argument

I am currently working on replacing firmware and "bios" on an old Z80 machine with modern versions in C23 on a yet unsubmitted z80 backend.  On the Z80 16-bit ints are much more expensive than 8-bit, and code space in my use case is at a premium.  I have therefore spent quite some time looking for suboptimal code generation spacewise with the help of Claude Code, which has uncovered a few corner cases.

This is the first upstream bug I try to file here.   I would appreciate gentle help in getting it right if for any reason this is not satisfactory.

In this process it was found that the "can we do the whole calculation in 8-bit" didn't work if it included a function argument declared not to be 8-bit (like in the K&R source I was using as a test case).

```c
typedef unsigned char uint8_t;
uint8_t rotl(x) uint8_t x;          /* default argument promotion -> int */
{ return (x << 1) | (x >> 7); }
```

Claude suggests that this is because TruncInstCombine::buildTruncExpressionGraph() does not consider Arguments to be acceptable Instructions for this, so the narrowing is then not even considered:

https://github.com/llvm/llvm-project/blob/de59f9ed12db9d47ad41ad44d54ec604ef8841cb/llvm/lib/Transforms/AggressiveInstCombine/TruncInstCombine.cpp#L95-L105

The snippet shows how constants are processed.  The suggestion is that Arguments are treated similarly in something looking like:

```cpp
    auto *I = dyn_cast<Instruction>(Curr);
    if (!I) {
      // Function arguments (and other non-instruction values that are not
      // Constants) can appear as operands in the expression graph.  Treat
      // them as leaves — they'll be explicitly truncated at narrowing time
      // in getReducedOperand.  Without this, expressions rooted at function
      // parameters (e.g., K&R-style u8 parameters that get int-promoted at
      // the ABI boundary on small-int targets) can never be narrowed back
      // to their natural width.
      if (isa<Argument>(Curr)) {
        Worklist.pop_back();
        continue;
      }
      return false;
    }
```

We carry this as a local patch.

---

The deeper explanation below was written by Claude Code (claims verified against llvm-project `de59f9ed`); I have reviewed it and include it for completeness.

---

TruncInstCombine narrows `trunc(iN expr)` graphs to the destination width when the analysis proves it safe. Its expression walker ([`buildTruncExpressionGraph`](https://github.com/llvm/llvm-project/blob/de59f9ed12db9d47ad41ad44d54ec604ef8841cb/llvm/lib/Transforms/AggressiveInstCombine/TruncInstCombine.cpp#L87-L110)) accepts `Instruction` and `Constant` nodes; a function `Argument` is neither, so the walk aborts. Note the rejection happens while *building* the graph — before the min-bitwidth analysis ever runs — so it is not a safety conclusion; the safety machinery is simply never consulted.

The K&R function above lowers (clang -O1) to:

```llvm
define zeroext i8 @rotl(i16 noundef %x) {
  %m = and i16 %x, 255
  %s = shl nuw nsw i16 %m, 1
  %r = lshr i16 %m, 7
  %o = or disjoint i16 %s, %r
  %t = trunc i16 %o to i8
  ret i8 %t
}
```

Repro: `opt -passes=aggressive-instcombine -S` on current main returns this IR unchanged, although everything is computable in i8 (the `and 255` proves the value fits). The expected result is i8 shifts/or fronted by a single `trunc i16 %x to i8`.

The parameter is precisely the trigger: give the same function an ANSI prototype (`uint8_t rotl(uint8_t x)`) and the value enters the expression through a `zext` — an Instruction — and TruncInstCombine narrows it today. Likewise if `%x` came from a load.

An `Argument` imposes no width requirement of its own (the existing min-bitwidth analysis is driven by the instructions), so treating it as a leaf — analogous to the existing `Constant` handling, with one explicit `trunc` of the argument materialized at function entry — appears sufficient.

The real-world function the test case was reduced from is the inverse S-box of Ilya O. Levin's byte-oriented AES-256 implementation (literatecode.com, ISC-style license), in its legacy K&R form:

```c
uint8_t rj_sb_inv(x)
uint8_t x;
{
    uint8_t y, sb;

    y = x ^ 0x63;
    sb = y = (y<<1)|(y>>7);
    y = (y<<2)|(y>>6); sb ^= y; y = (y<<3)|(y>>5); sb ^= y;

    return gf_mulinv(sb);
}
```

Every operation chains off the promoted parameter, so the entire body is stuck at i16. Measured on the Z80 backend: **147 B** for this K&R form vs **16 B** for the ANSI-prototype equivalent (~9x), pure 16-bit shift/mask/or traffic standing in for single-byte rotates. With the Argument-leaf patch it drops to 31 B; the remaining gap is a separate rotate-idiom-recognition issue on the already-narrowed IR, not this bug. The same shape appears in any legacy K&R C compiled for a 16-bit-int target.

The repro is target-independent.

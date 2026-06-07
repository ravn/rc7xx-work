(For llvm/llvm-project. Staged for iteration as ravn/llvm-z80#218 — this file mirrors the issue body; strip the staging banner when filing upstream.)

Title: [AggressiveInstCombine] TruncInstCombine cannot narrow any expression that reaches a function Argument

> **Staging copy** — iteration draft for an llvm/llvm-project filing. This fork already carries the fix (#158, commit a5d49e9); the bug is live upstream (verified on de59f9ed). Once the text is right, this moves to llvm/llvm-project.

---

I am currently working on replacing firmware and "bios" on an old Z80 machine with modern versions in C23 on a yet unsubmitted z80 backend.  On the Z80 16-bit ints are much more expensive than 8-bit, and code space in my use case is at a premium.  I have therefore spent quite some time looking for suboptimal code generation spacewise with the help of Claude Code, which has uncovered a few corner cases.

This is the first upstream bug I try to file here.   I would appreciate gentle help in getting it right if for any reason this is not satisfactory.

In this process it was found that the "can we do the whole calculation in 8-bit" didn't work if it included a method argument declared not to be 8-bit (like in the K&R source I was using as a test case).

```c
typedef unsigned char uint8_t;
uint8_t rotl(x) uint8_t x;          /* default argument promotion -> int */
{ return (x << 1) | (x >> 7); }
```

Claude suggests that this is because TruncInstCombine::buildTruncExpressionGraph() does not consider Arguments to be acceptable Instructions for this, so the narrowing is then not even considered.

```c
    if (isa<Constant>(Curr)) {
      Worklist.pop_back();
      continue;
    }

    auto *I = dyn_cast<Instruction>(Curr);
    if (!I)
      return false;

```

The code snippet includes how constants are processed.  The suggestion is that Arguments are treated similarly in something looking like:

```c
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




The rest from here is the rather wordy explanation Clade gave me .  I have left it in here for completeness sake.

---
---
---

TruncInstCombine narrows `trunc(iN expr)` graphs to the destination width when the analysis proves it safe. Its expression walker ([`buildTruncExpressionGraph`](https://github.com/llvm/llvm-project/blob/de59f9ed12db9d47ad41ad44d54ec604ef8841cb/llvm/lib/Transforms/AggressiveInstCombine/TruncInstCombine.cpp#L87-L110)) accepts `Instruction` and `Constant` nodes; a function `Argument` is neither, so the walk aborts:

```cpp
auto *I = dyn_cast<Instruction>(Curr);
if (!I)
  return false;   // bails when the graph reaches an Argument
```

Consequence: any otherwise-narrowable expression is left at the wide type if one of its leaves is a function parameter. Note this rejection happens in graph *construction* — before the min-bitwidth analysis ever runs — so it is not a safety conclusion; the safety machinery is simply never consulted.

Source shape (C on a 16-bit-int target; the K&R declaration promotes the parameter type to `int` itself):

```c
typedef unsigned char uint8_t;
uint8_t rotl(x) uint8_t x;          /* default argument promotion -> int */
{ return (x << 1) | (x >> 7); }
```

which clang -O1 lowers to:

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

Repro: `opt -passes=aggressive-instcombine -S` on current main returns this IR unchanged.

Everything here is computable in i8 (the `and 255` proves the value fits), so the expected result is i8 shifts/or fronted by a single `trunc i16 %x to i8`. The function parameter is precisely the trigger: give the same function an ANSI prototype (`uint8_t rotl(uint8_t x)`) and the value enters the expression through a `zext` — an Instruction — and TruncInstCombine narrows it today. Likewise if `%x` came from a load.

On an out-of-tree 8-bit backend we measured a real AES-256 rotate helper at 4.7x the code size of its ANSI-prototype equivalent purely from this — the 16-bit shift/mask/or dance vs a native 8-bit rotate. The same shape appears in any legacy K&R C compiled for a 16-bit-int target.

An `Argument` imposes no width requirement of its own (the existing min-bitwidth analysis is driven by the instructions), so treating it as a leaf — analogous to the existing `Constant` handling, with one explicit `trunc` of the argument materialized at function entry — appears sufficient; we carry that as a local patch.

Found while developing an out-of-tree Z80 backend; the repro is target-independent.

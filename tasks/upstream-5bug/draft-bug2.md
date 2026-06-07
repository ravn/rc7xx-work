(For llvm/llvm-project. Staged for iteration as ravn/llvm-z80#218 — this file mirrors the issue body; strip the staging banner when filing upstream.)

Title: [AggressiveInstCombine] TruncInstCombine cannot narrow any expression that reaches a function Argument

> **Staging copy** — iteration draft for an llvm/llvm-project filing. This fork already carries the fix (#158, commit a5d49e9); the bug is live upstream (verified on de59f9ed). Once the text is right, this moves to llvm/llvm-project.

---

TruncInstCombine narrows `trunc(iN expr)` graphs to the destination width when the analysis proves it safe. Its expression walker ([`buildTruncExpressionGraph`](https://github.com/llvm/llvm-project/blob/de59f9ed12db9d47ad41ad44d54ec604ef8841cb/llvm/lib/Transforms/AggressiveInstCombine/TruncInstCombine.cpp#L87-L110)) accepts `Instruction` and `Constant` nodes; a function `Argument` is neither, so the walk aborts:

```cpp
auto *I = dyn_cast<Instruction>(Curr);
if (!I)
  return false;   // bails when the graph reaches an Argument
```

Consequence: any otherwise-narrowable expression is left at the wide type if one of its leaves is a function parameter. Note this rejection happens in graph *construction* — before the min-bitwidth analysis ever runs — so it is not a safety conclusion; the safety machinery is simply never consulted.

Minimal source shape (C on a 16-bit-int target; the K&R declaration promotes the parameter type to `int` itself):

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

The real-world function this was reduced from — the inverse S-box of Ilya O. Levin's byte-oriented AES-256 implementation (literatecode.com, ISC-style license), in its legacy K&R form:

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

Every operation chains off the promoted parameter, so the entire body is stuck at i16. Measured on our 8-bit target: **147 B** for this K&R form vs **16 B** for the ANSI-prototype equivalent (~9x), pure 16-bit shift/mask/or traffic standing in for single-byte rotates. With the Argument-leaf fix it drops to 31 B; the remaining gap is a separate rotate-idiom-recognition issue on the already-narrowed IR, not this bug. The same shape appears in any legacy K&R C compiled for a 16-bit-int target.

An `Argument` imposes no width requirement of its own (the existing min-bitwidth analysis is driven by the instructions), so treating it as a leaf — analogous to the existing `Constant` handling, with one explicit `trunc` of the argument materialized at function entry — appears sufficient; we carry that as a local patch.

Found while developing an out-of-tree Z80 backend; the repro is target-independent.

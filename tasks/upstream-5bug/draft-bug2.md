(For llvm/llvm-project. AWAITING per-filing go-ahead. User may prepend own framing.)

Title: AggressiveInstCombine: TruncInstCombine cannot narrow any expression that reaches a function Argument

TruncInstCombine narrows `trunc(iN expr)` graphs to the destination width when the analysis proves it safe. Its expression walker (`buildTruncExpressionGraph`) accepts `Instruction` and `Constant` nodes; a function `Argument` is neither, so the walk aborts:

    auto *I = dyn_cast<Instruction>(Curr);
    if (!I)
      return false;   // bails when the graph reaches an Argument

Consequence: any otherwise-narrowable expression is left at the wide type if one of its leaves is a function parameter.

Repro (`opt -passes=aggressive-instcombine -S`, current main -- output is identical to input):

    define zeroext i8 @rotl_u8(i16 noundef %x) {
      %m = and i16 %x, 255
      %s = shl nuw nsw i16 %m, 1
      %r = lshr i16 %m, 7
      %o = or disjoint i16 %s, %r
      %t = trunc i16 %o to i8
      ret i8 %t
    }

Everything here is computable in i8 (the `and 255` proves the value fits), so the expected result is i8 shifts/or fronted by a single `trunc i16 %x to i8`. If `%x` were produced by a load or any instruction instead of being a parameter, TruncInstCombine narrows this today.

This shape is what C integer promotion produces for sub-int parameters on 16-bit-int targets (K&R declarations make it unconditional: the parameter type IS int). On an out-of-tree 8-bit backend we measured a real AES-256 rotate helper at 4.7x the code size of its ANSI-prototype equivalent purely from this -- the 16-bit shift/mask/or dance vs a native 8-bit rotate.

An `Argument` imposes no width requirement of its own (the existing min-bitwidth analysis is driven by the instructions), so treating it as a leaf -- analogous to the existing `Constant` handling, with one explicit `trunc` of the argument materialized at function entry -- appears sufficient; we carry that as a local patch.

Found while developing an out-of-tree Z80 backend; the repro is target-independent.

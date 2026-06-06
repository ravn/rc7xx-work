(For llvm/llvm-project. AWAITING per-filing go-ahead. User may prepend own framing. Missed-optimization framing, not a miscompile.)

Title: AggressiveInstCombine: TruncInstCombine abandons narrowing entirely when any in-graph value has an outside user, even a trivially-rewritable one

TruncInstCombine requires the whole expression graph feeding a `trunc` to be free of outside users (rule 4 in the file header); the only exception is a ZExt/SExt whose operand is already the destination type (TruncInstCombine.cpp, current main):

    for (auto *U : I->users())
      if (auto *UI = dyn_cast<Instruction>(U))
        if (UI != CurrentTruncInst && !InstInfoMap.count(UI)) {
          if (!IsExtInst)
            return nullptr;   // any other outside user kills the narrowing
          ...

The bail is all-or-nothing: one outside user anywhere in the graph and the entire expression stays wide, including for outside users that could be locally rewritten without changing the graph's computed values.

Repro (`opt -passes=aggressive-instcombine -S`, current main — output is identical to input; `%add` stays i32 in both):

    define i16 @icmp_nonconst_outside_user(i32 %x, i32 %y) {
      %add = add i32 %x, 1
      %t = trunc i32 %add to i16
      %ym = and i32 %y, 255
      %c = icmp ult i32 %add, %ym       ; outside user; %ym provably fits i16
      %sel = select i1 %c, i16 %t, i16 0
      ret i16 %sel
    }

    @g = global i32 0
    define i16 @and_mask_outside_user(i32 %x) {
      %add = add i32 %x, 1
      %t = trunc i32 %add to i16
      %and = and i32 %add, 15           ; outside user; mask fits i16
      store i32 %and, ptr @g
      ret i16 %t
    }

Both adds are narrowable to i16, and each outside user is width-compatible:

- (a) `icmp` where the other operand is a constant fitting the narrow type, or (as here) provable narrow via KnownBits — rewrite the compare to the narrow width (both operands truncated; unsigned predicates and equality are value-preserving when both sides fit).
- (b) `and` with a constant mask fitting the narrow type — compute narrow, `zext` for the outside use.

Expected: `add i16` fronted by `trunc i32 %x to i16`, with the icmp narrowed in (a) and the `and` rewritten to narrow-and + `zext` in (b).

Motivation: C integer promotion plants this shape pervasively on targets where `int` is wider than the natural register (8/16-bit microcontrollers): a `uint8_t` loop body promotes to `int`, the trunc appears at the store/return, and a single bound-check or mask escaping the graph forfeits the entire narrowing. On an out-of-tree Z80 backend we carry local patches admitting (a) and (b); the day they landed, an AES-256 S-box log-table helper went from 153 B to 28 B (5.4x) and the whole 13-configuration corpus shrank 26-129 B per build with ~4x fewer cycles on the hot path — the helper's loop is exactly `while (a != x) { ... if (logv > 255) logv -= 255; }`, case (a).

Found while developing an out-of-tree Z80 backend; the repro is target-independent.

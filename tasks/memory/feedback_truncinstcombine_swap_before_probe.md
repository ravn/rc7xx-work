---
name: truncinstcombine-swap-before-probe
description: When injecting a synthetic trunc root for TruncInstCombine, modify the IR users to point at the new value BEFORE calling getBestTruncatedType — otherwise the multi-use guard bails on the original outside-graph user
metadata:
  type: feedback
  originSessionId: b20efbb1-10f2-452a-bfa2-432a9ba5a6a3
---

When extending `TruncInstCombine` with a new synthetic-root pattern
(and-mask sink #163, call-arg peek #162 path 2, future variants), the
ordering matters:

**Wrong**: probe first, then swap.
```cpp
Tr = trunc V to iM;   // V now has 2 users: the original consumer + Tr
CurrentTruncInst = Tr;
if (Type *T = getBestTruncatedType()) {
  // ...                                    // BAILS — V is multi-use:
  //                                        // outside-graph user = the
  //                                        // original consumer.
}
```

**Right**: swap first, then probe.
```cpp
Tr = trunc V to iM;
Zx = zext Tr to OrigTy;
Consumer->setUseOfV(Zx);                    // V now has 1 user: Tr.
CurrentTruncInst = Tr;
if (Type *T = getBestTruncatedType()) {
  ReduceExpressionGraph(T);                 // narrows chain feeding V.
} else {
  // Rollback: restore Consumer's V, erase Zx and Tr.
  Consumer->setUseOfV(V);
  Zx->eraseFromParent();
  Tr->eraseFromParent();
}
```

**Why:** `getBestTruncatedType`'s outside-graph-users check iterates
each in-graph instruction's users and bails if any user is outside
the InstInfoMap and isn't a zext/sext leaf (eliminable) or #160 icmp
(rewritable).  The original consumer of `V` is outside-graph at probe
time unless we swap it first.

**How to apply:** Any new synthetic trunc-root injection needs the
swap-before-probe ordering, plus a rollback path that undoes the swap
when probing fails.  Caught session 72 when implementing #162 path 2;
the initial draft probed first, observed "no narrowing" on the rj_sb_inv
repro, traced to the multi-use bail.  See
`llvm/lib/Transforms/AggressiveInstCombine/TruncInstCombine.cpp` phase
3 in `519aaaec4817`.

Related: [[reference_z80_tool_paths]],
[[feedback_zeroext_is_abi_not_source]] (different but adjacent
narrowing-correctness concern).

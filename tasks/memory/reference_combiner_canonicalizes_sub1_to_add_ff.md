---
name: reference-combiner-canonicalizes-sub1-to-add-ff
description: GlobalISel combiner turns `x - 1` into G_ADD(x, 0xFF) for i8; fold on the 8-bit constant VALUE, not the opcode
metadata:
  type: reference
---

The GlobalISel pre-legalizer combiner canonicalizes `G_SUB(x, C)` into
`G_ADD(x, -C)` for small constants. On 8-bit types this means `counter--`
in C arrives at instruction selection as:

```
%r = G_ADD %v, G_CONSTANT i8 -1   ; -1 == 0xFF
```

NOT as `G_SUB %v, G_CONSTANT i8 1`.

### How to apply

When writing a selector fold that matches `load / +-1 / store` (INC/DEC
(HL)) or any similar near-identity-arith pattern, key the match off the
**8-bit constant value**, not the G_ADD/G_SUB opcode alone:

```cpp
unsigned V = CDef->getOperand(1).getCImm()->getZExtValue() & 0xFF;
if      (V == 1)    delta = +1;
else if (V == 0xFF) delta = -1;
else                return nullptr;
```

The four cases collapse to a signed delta:

| Arith opcode | Constant (mod 256) | Effective delta |
|---|---|---|
| G_ADD | 0x01 | +1 → INC |
| G_ADD | 0xFF | −1 → DEC |
| G_SUB | 0x01 | −1 → DEC |
| G_SUB | 0xFF | +1 → INC |

For G_ADD (commutative), probe both operand positions for the constant.
For G_SUB (non-commutative), the constant can only live on the RHS, and
the delta flips sign vs the G_ADD case.

### Where this bit us

First INC/DEC (HL) fold cut (ravn/llvm-z80 #403, commit 27e26d5
2026-10-10): matched only G_ADD(x, 1) and G_SUB(x, 1). Smoke test showed
`counter++` folded to `inc (hl)` ✓ but `counter--` emitted
`ld a; dec a; ld` ✗. One build cycle to rewrite the match on constant
value and recover `dec (hl)`.

### Related

[[reference_memory_fold_pseudo_template]] — the broader fold recipe this
rule plugs into. Any future near-identity-arith fold (±2 via INC INC /
DEC DEC, +N via ADD A,n fold, etc.) must apply the same signed-delta
reasoning.

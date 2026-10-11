---
name: reference-fixed-stack-fi-is-negative
description: Fixed-stack frame indices (incoming stack args) are NEGATIVE in LLVM MIR; `FI >= 0` filters miss them
metadata:
  type: reference
---

In LLVM MachineFunction, frame indices split into two ranges:
- **Local spill slots / allocas**: FI >= 0 (0, 1, 2, …)
- **Fixed-stack objects** (incoming args passed on the stack, callee-saved spill slots): FI **< 0** (−1, −2, …, shown as `fi#-1` in MIR dumps)

Both are legitimate frame indices. A filter like `if (FI >= 0)` only
catches *local* spill slots and silently lets fixed-stack frames through.

### Fallout seen in this repo

The initial OR (HL) fold (commit `bf69d2a`) used
`getFILoad(FoldReg).FI >= 0` to exclude frame-indexed loads from the
tryORIndirectFold path (frames should take the dedicated IX-indexed
fold instead). The check passed fixed-stack arg loads through → the
fold routed them via `LEA_IX_FI + op (HL)`, a size regression over the
direct `LD r,(IX+d)` arg load. First surfaced when XOR8_IND (same code
path, extended coverage) tripped `acc-regclass.ll`'s `chain` test
(ravn/llvm-z80 commit 27e26d5, 2026-10-10).

### How to check correctly

Don't branch on the FI number — check the address-def opcode:

```cpp
Register LAddrReg = LoadMI->getOperand(1).getReg();
if (MachineInstr *AddrDef = MRI.getVRegDef(LAddrReg)) {
  if (AddrDef->getOpcode() == TargetOpcode::G_FRAME_INDEX)
    return false;  // any FI, positive or negative
  if (AddrDef->getOpcode() == TargetOpcode::G_PTR_ADD) {
    MachineInstr *BaseDef = MRI.getVRegDef(AddrDef->getOperand(1).getReg());
    if (BaseDef && BaseDef->getOpcode() == TargetOpcode::G_FRAME_INDEX)
      return false;  // FI + const offset
  }
}
```

### How to apply

- Any new memory-fold pseudo (see [[reference_memory_fold_pseudo_template]])
  that intends to exclude frame-indexed loads MUST check the G_FRAME_INDEX
  address def directly, not the sign of the FI index.
- When reviewing existing selector folds that use `getFILoad(…).FI >= 0`
  or `>= 0` on any raw FI, treat it as a bug candidate and verify fixed
  stack args don't slip through.
- Running `llc -stop-after=instruction-select` and looking for
  `LEA_IX_FI` feeding an unexpected op (HL) in the dump is the
  fastest way to spot the slip.

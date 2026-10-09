---
name: reference_memory_fold_pseudo_template
description: Template for folding G_LOAD/G_STORE into one-byte op-with-memory Z80 instructions (CP (HL), LD A,(nn), etc.) via pseudo + AccPseudos
metadata:
  type: reference
---

Pattern established 2026-10-09 for `COMPARE8_IND` (CP (HL)) and
`LOAD8_ABS`/`STORE8_ABS` (LD A,(nn) / LD (nn),A) folds. Use this template
when adding further memory-fold opcodes (OR/AND/XOR/ADD/SUB (HL),
indexed variants, etc. — see `[[ravn/llvm-z80 #402]]`).

## Four files to touch

**1. `Z80RegisterInfo.td`** — add a single-register class if the real
instruction has a hard register constraint:
```
def GR16_HL : Z80Reg16Class<(add HL)>;   // CP (HL) requires HL
```

**2. `Z80InstrInfo.td`** — add a `Z80Pseudo` with Ac wrapper for the A
operand and the constrained class for the address:
```
def COMPARE8_IND : Z80Pseudo<(outs), (ins Ac:$lhs, GR16_HL:$addr)> {
  let mayLoad = true;
}
let mayLoad = true, mayStore = false in {
  def LOAD8_ABS : Z80Pseudo<(outs Ac:$dst), (ins i16imm:$addr)>;
}
```

**3. `Z80InstrInfo.cpp`** — two entries:
  - `AccPseudos[]` table (around line 576) maps pseudo → real opcode:
    `{Z80::LOAD8_ABS, Z80::LD_A_nnind, AccPseudo::Operand}`
  - `getInstSizeInBytes` size case (around line 1941):
    `case Z80::COMPARE8_IND: return 1;` (not needed if the real opcode
    is already size-accurate for the Ac-wrapped form)
  - If no post-RA expansion exists via AccPseudo, add it to
    `expandPostRAPseudo` (as done for `COMPARE8_IND` → `CP_HLind`)

**4. `Z80InstructionSelector.cpp`** — fold in the G_LOAD / G_STORE path
or at the operation site. For `COMPARE8_IND` the fold lives inside the
G_ICMP handler's `emitCP` / `emitEqualityTest` lambdas. For `LOAD8_ABS`
it lives in the G_LOAD case, gated on `getGlobalAddr()` + 8-bit +
`!hasSM83()`.

## Correctness invariants

- The fold must verify the G_LOAD has `MRI.hasOneNonDBGUse()` — otherwise
  it leaves a dead store or re-loads the value.
- `RDef->eraseFromParent()` only after `RBI.constrainGenericRegister()`
  succeeded (else we corrupt MIR on failure path).
- Add lit tests pinning the new sequence AND verifying ELF/SDCC format
  still produces the old sequence where applicable.

## Measured yields (autoload-in-c, 2026-10-09)

- `COMPARE8_IND`: −5 B (small — most compare sites were already
  eliminating spill via other codegen; main win was eliminating IX
  frames in `compare_6bytes`).
- `LOAD8_ABS`/`STORE8_ABS`: −29 B (28 BC-indirect + 10 DE-indirect load
  patterns collapsed 1 B each).

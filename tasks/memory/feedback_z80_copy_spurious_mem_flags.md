---
name: Z80 register copies have spurious mayLoad/mayStore flags
description: Z80 GISel register-to-register copy opcodes (LD_D_A, LD_A_D, all 1-byte register moves derived from Inst8) carry mayLoad=1 AND mayStore=1 set by TableGen's conservative defaults despite touching no memory.  Any peephole using these flags as "may alias memory" will misfire and bail on plain register copies.  Use !MI.memoperands_empty() instead.
type: feedback
originSessionId: 90f5a17f-7f0a-47da-8820-66f3b9c19063
---
**Rule:** When writing a peephole in `Z80LateOptimization.cpp`
(or any Z80 post-RA pass) that needs to detect "this intervening
instruction may touch memory", do NOT use `MI.mayLoad()` or
`MI.mayStore()`.  Use:

```cpp
if (!MI.memoperands_empty()) {
  // actual memory access
}
```

**Why:**
- Z80 TableGen `Inst8` and related classes don't explicitly set
  `let mayLoad = 0; let mayStore = 0;`, so TableGen defaults them
  conservatively to `1`.
- Pure register-to-register copies like `LD_D_A` show
  `mayLoad=1, mayStore=1` even though they touch no memory.
- A real memory-accessing instruction in the GISel pipeline carries
  a `MachineMemOperand` (MMO) attached.  Pure register ops have no
  MMOs.  `memoperands_empty()` is the honest test.

**Caveat:** A few opcodes might have inadvertently empty MMO lists
even when they should touch memory (e.g. an in-line-asm string).
For tight peepholes you can additionally check opcode whitelists.
For broad "did this instruction obviously touch memory" filtering,
MMO-based check is correct.

**Tracked in:** ravn/llvm-z80#154 (TableGen audit + fix the
underlying spurious flags).  Until that lands, use the workaround
in every new peephole.

**Symptom this rule catches:**
Session 68 (2026-05-13), #152.  Initial peephole used
`OpIt->mayLoad() || OpIt->mayStore()` to bail on intervening
memory access.  Bailed on every plain `LD_D_A` (the very witness
the peephole was supposed to handle).  Caught with a tracing
`errs()`, switched to `memoperands_empty()`, peephole then fired
correctly.  Cost: one rebuild cycle.

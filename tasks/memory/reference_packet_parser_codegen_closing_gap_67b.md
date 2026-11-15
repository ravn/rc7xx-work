---
name: reference_packet_parser_codegen_closing_gap_67b
description: Complete blueprint and lessons from closing the codegen gap from 118B down to 67B (compliant C minimum) on packet-parser benchmark
type: reference
---

# Complete Blueprint: Closing the Codegen Gap on Z80 (118 B -> 67 B)

**Date:** 2026-11-16  
**Target:** `zlfn/llvm-z80` (branch `work/packet-parser-codegen`)  
**Benchmark:** `packet-parser.c` (`parse_packet_c`)  
**Result:** **67 bytes text, 0 bytes `.bss`** (matches the absolute theoretical minimum for compliant C: 63 B hand-crafted assembly + 4 B standard ABI `push ix / pop ix`).

---

## 1. Overview of the Progression

| Phase | Transformation | Size (-Os) | .bss | Key Breakthrough |
| :--- | :--- | :--- | :--- | :--- |
| **Upstream `main`** | Baseline | 118 B | 4 B | Spill to static RAM, accumulator clobbered, 65 B loop |
| **Upstream `reimpl`** | Better allocation | 101 B | 1 B | Still spilling to `.bss`, no in-place RMW |
| **Fase 1** | Un-reserve `IX` for pointers when `!hasFP` | 89 B | 1 B | `IX` allocatable, `SET8_IND`/`INC8_IND` lowered to `(ix+0)` |
| **Fase 2** | MachineIR Store-Phi Sinking | 78 B | 1 B | In-place CISC RMW recreated in predecessor blocks |
| **Fase 3** | Loop-invariant accumulator hoisting | 76 B | 0 B | Match counter in `E`, `delim` in `A`, `.bss` eliminated |
| **Peepholes** | Push/pop DE elision & scratch fold | 73 B | 0 B | Eliminated redundant register saves |
| **Fase 5** | Loop latch rotation & `BReg` for DJNZ | 74 B (O3: 77 B) | 0 B | Hardware `djnz` inner loop (16 B inner loop body) |
| **Fase 6** | Hoist `ADD HL, DE` before reloads | 72 B (O3: 75 B) | 0 B | Elided `push bc / pop bc` around IX reload in preheader |
| **Fase 7** | Fold `(HL)` memory load to `A` | 71 B (O3: 74 B) | 0 B | Eliminated redundant intermediate copy |
| **Fase 8** | Preheader reload & `ADD HL, DE` hoist | **67 B** | **0 B** | Single sequential stack frame traversal with `inc hl` |
| **Optimal C** | Theoretical limit with ABI `push/pop ix` | **67 B** | **0 B** | Exactly matched by compiler! |
| **Pure Assembly** | No callee-saved registers | 63 B | 0 B | Programmør udelader `push/pop ix` (4 B) |

---

## 2. The 5 Root-Cause Bottlenecks and How Each is Solved

### Bottleneck 1: Index Register `IX` Reserving
* **Problem:** In upstream, `IX` was unconditionally reserved (`isReserved(IX) = true`) as a dedicated frame pointer, even in functions without a frame pointer (`!hasFP`). This starved the register allocator of a 16-bit pointer register, forcing `flags` to the stack and preventing CISC in-place memory operations (`set 7, (ix+0)` and `inc (ix+0)`).
* **Fixes required:**
  1. Un-reserve `IX` in `Z80RegisterInfo::getReservedRegs`:
     `if (!hasFP(MF) && !STI.hasSM83()) Reserved.reset(Z80::IX);`
  2. Fix `getLargestLegalSuperClass` in `Z80RegisterInfo.cpp` to use `RC->hasSuperClassEq(&Z80::GR16RegClass)`. TableGen's `hasSuperClass` is strict, so without `Eq`, `GR16` fell through to `Any16`, incorrectly assigning `IX` to non-pointer 16-bit values and crashing when subregisters (`ixl`) were used.
  3. In `Z80InstructionSelector.cpp`, lower 16-bit frame index loads to `RELOAD_ANY16` so stack-passed pointers can be loaded into `IX`.
  4. Expand `SET8_IND`, `RES8_IND`, `INC8_IND`, `DEC8_IND` address operand from `GR16_HL` to `HLI` in `Z80InstrInfo.td`, emitting `(ix+0)`.

### Bottleneck 2: Generic InstCombine Store-Merging vs CISC RMW
* **Problem:** Generic LLVM `InstCombine` merges stores to identical addresses across branches into a single store in `if.end`, fed by a `phi [or ..., inc ...]`. On RISC this is good; on CISC Z80 it destroys the pattern for `set 7, (ix+0)` (4 bytes) and `inc (ix+0)` (3 bytes), forcing intermediate values through accumulator `A`, clobbering `A`, and emitting separate load and store sequences.
* **Fix:** In `Z80StorePhiSink` (runs in `addPreLegalizeMachineIR`), identify `G_STORE` where the value is a `G_PHI` whose incoming values are RMW operations on the same address. Duplicate the store into each predecessor block. This recreates discrete load-modify-store trees in each branch that `Z80InstructionSelector` matches to `SET8_IND` and `INC8_IND`.

### Bottleneck 3: Accumulator Eviction & Loss of Loop Invariant
* **Problem:** When `A` was clobbered by the merged store, loop invariants like `delim` could not stay in `A` across iterations. The compiler reloaded `delim` from the stack on every iteration (`push hl; ld hl, 5; add hl, sp; ld a, (hl); pop hl; cp (hl)`). Furthermore, register pressure forced local accumulators (`matches`) into a 1-byte static frame (`.bss`), emitting slow 9-byte static memory read-modify-writes.
* **Fix:**
  - With in-place `(ix+0)` RMW restoring `A`, `delim` can be pinned to `A` in the loop preheader.
  - In `Z80PreEmitPeephole.cpp`, `hoistLoopInvariantAccLoad` detects when `cp (hl)` compares against an invariant register that is never clobbered in the loop, and moves the setup to the preheader.
  - This frees up general registers, allowing `matches` to live in `E`, completely eliminating the static `.bss` frame (0 bytes `.bss`).

### Bottleneck 4: Loop Inversion & Loss of Hardware `DJNZ`
* **Problem:** Generic `MachineBlockPlacement` prioritizes loop back-edge fallthrough, placing the loop latch *before* the loop header and exiting with a conditional branch on zero (`jr z, exit`). Because hardware `djnz` only branches taken on non-zero, this inverted layout prevented `djnz` and added a 2-byte preheader trampoline jump. Furthermore, Greedy RA often allocated `B` to other variables, leaving the loop counter with `C` or `D`.
* **Fix:**
  1. Define `def BReg : Z80Reg8Class<(add B)>;` in `Z80RegisterInfo.td`.
  2. Implement `Z80SplitDjnzCounters` before regalloc to constrain countdown loop counters to `BReg`.
  3. Implement `rotateInvertedLoops` in `Z80BranchCleanup.cpp` to rotate inverted loops so the preheader falls through to the loop header and the latch branches backwards with `djnz`.

### Bottleneck 5: Split Argument Reloads across Dominating Predecessors
* **Problem:** Generic `MachineSink` sank stack argument reloads (`delim`, `flags`) into `for.body.lr.ph` because they were only used in the loop, leaving `len` in `%if.end` (where `len == 0` was checked). This forced PrologEpilogInserter (PEI) to emit two separate `add hl, sp` traversals with separate `push/pop hl` saves (11 B in `%if.end` + 17 B in `%for.body.lr.ph` = 28 B).
* **Fix:**
  1. Implement `hoistPreheaderReloadsIntoPredecessor` in `Z80PushPopSpills.cpp` (before PEI). If a loop preheader with single predecessor `Pred != MF.front()` has `%fixed-stack` reloads and `Pred` already reloads from `%fixed-stack`, hoist the reloads into `Pred` adjacent to `Pred`'s existing reloads.
  2. Simultaneously hoist `ADD_HL_rr` (`add hl, de`) to the start of `Pred`. This kills `DE` early, allowing PEI to use `DE` as the temporary pair for loading `IX` without spilling `BC` (`push bc / pop bc` eliminated).
  3. `Z80PreEmitPeephole`'s `reuseLDHLAddress` automatically coalesces all 4 stack arguments into a single `add hl, sp` with sequential `inc hl`.
  4. Guard against emptying the preheader completely (`HoistCount < NonTermCount`) to preserve loop block placement and `djnz`.

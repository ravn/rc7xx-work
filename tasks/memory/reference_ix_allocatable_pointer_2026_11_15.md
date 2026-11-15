---
name: reference_ix_allocatable_pointer_2026_11_15
description: Rules and mechanisms for un-reserving IX for pointers, stack argument lowering, getLargestLegalSuperClass fix, and InstCombine store-merging on CISC RMW
type: reference
---

# Allocatable IX for Pointers & In-Place CISC Operations (2026-11-15)

## 1. Context & Prior Attempts
Historically (see `project_ix_caller_saved_after_12.md`), un-reserving IX caused verifier crashes or size regressions. Three root causes in LLVM Z80 prevented IX from working cleanly as an allocatable pointer register:

1. **`getLargestLegalSuperClass` inflated `GR16` to `Any16`:**
   In `Z80RegisterInfo.cpp`, `getLargestLegalSuperClass` called `RC->hasSuperClass(&Z80::GR16RegClass)`. In TableGen/LLVM, `hasSuperClass()` checks for *proper* (strict) subclasses. Because `GR16` is not a proper subclass of itself, `GR16` fell through to `Any16`.
   - Result: Greedy Register Allocator treated any general 16-bit integer as eligible for `Any16` (`IX`/`IY`), assigning `IX` to variables whose 8-bit subregisters were later extracted (`$b = COPY renamable $ixl`). Because `IXL`/`IXH` are reserved, MachineVerifier aborted with `isRenamable set on reserved register ($ixl)`.
   - **Fix:** Use `RC->hasSuperClassEq(&Z80::GR16RegClass)`. Now `GR16` stays `GR16`. Only virtual registers explicitly in `Any16` or `HLI` (such as pointers) can be assigned `IX`.

2. **Stack argument reloads hardcoded `RELOAD_GR16`:**
   In `Z80InstructionSelector.cpp`, loading a 16-bit value from a frame index (`G_FRAME_INDEX`) was lowered to `Z80::RELOAD_GR16`.
   - Result: Pointer arguments passed on the stack were forced into `GR16` (`BC`, `DE`, `HL`), entirely preventing them from ever living in `IX`.
   - **Fix:** Lower 16-bit frame index loads to `Z80::RELOAD_ANY16`. Greedy RA can now allocate stack-passed pointers directly into `IX`.

3. **In-place memory RMW instructions lacked `IX` lowering:**
   `SET8_IND`, `RES8_IND`, `INC8_IND`, `DEC8_IND` had their address operand constrained to `GR16_HL`.
   - **Fix:** Change address operand to register class `HLI` in `Z80InstrInfo.td` and `Z80InstructionSelector.cpp`. In `Z80InstrInfo.cpp`, expand pseudo-instructions with address `IX` to `SET_b_IXd`, `RES_b_IXd`, `INC_IXd`, `DEC_IXd` with displacement `+0`.

## 2. Un-reserving Condition
`IX` is unreserved in `Z80RegisterInfo::getReservedRegs`:
```cpp
if (!hasFP(MF) && !STI.hasSM83())
  Reserved.reset(Z80::IX);
```
When a function does not use a frame pointer (the vast majority of leaf and static-frame functions), `IX` is free for register allocation.

## 3. InstCombine Store-Merging vs CISC RMW
When compiling C code such as:
```c
if (cond)
    *flags |= 0x80;
else
    (*flags)++;
```
Generic LLVM `InstCombine` merges stores to identical addresses into a single store in `if.end`:
```llvm
%val = load i8, ptr %flags
...
%storemerge = phi i8 [ %val.or, %then ], [ %val.inc, %else ]
store i8 %storemerge, ptr %flags
```
- **Consequence for CISC (Z80):** This optimization is beneficial for RISC targets with single-byte load/store instructions, but harmful on Z80. It destroys the pattern for `set 7, (ix+0)` (2 bytes) and `inc (ix+0)` (2 bytes), forcing values through accumulator `A`, clobbering `A`, and emitting separate load and store sequences.
- **Solution:** In MachineIR (e.g. `Z80PreLegalizerCombiner`), sink and duplicate `G_STORE` with `G_PHI` operand back into predecessor blocks when the incoming values are RMW operations on the same address.

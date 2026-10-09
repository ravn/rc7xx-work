---
name: reference_shadow_isr_feature
description: +shadow-isr compiler feature — ISR uses EXX/EX AF,AF' for context save instead of IX-frame + PUSH/POP; reduces ISR overhead ~37 B per ISR
metadata:
  type: reference
---

## Feature: `+shadow-isr`

Compiler feature implemented 2026-10-09 (commit 883ff9c on `autoload-2kb-recovery-20261009`).

**What it does:** When `__interrupt` functions are compiled with `+shadow-isr`, BC/DE/HL
are saved via `EXX` and AF via `EX AF,AF'` instead of explicit `PUSH/POP`. Only IY
needs an explicit `PUSH/POP` (Z80 has no shadow IY). IX frame pointer is never emitted.

**Overhead before (current default):**
`PUSH IX` + `LD IX,$0` + `ADD IX,SP` + alloca + `PUSH AF/BC/DE/HL/IY` = ~27 B prologue,
~12 B epilogue = ~39 B overhead per ISR.

**Overhead after (+shadow-isr):**
`EXX` (1) + `EX AF,AF'` (1) + `PUSH IY` (2) + `POP IY` (2) + `EX AF,AF'` (1) + `EXX` (1) = 8 B total.

**How to enable (in Makefile):**
```makefile
-Xclang -target-feature -Xclang +shadow-isr
```

**Safety condition:** Only safe when main code NEVER executes `EXX`. Specifically:
- `autoload-in-c`: safe (no integer division, no inline `exx`)
- `rcbios`, `cpnos-in-c`: NOT safe — integer division legalizer uses EXX via shadow register bank

**Implementation:**
- `Z80CallingConv.td`: `Z80_Interrupt_Shadow_CSR = (add AF, BC, DE, HL, IY)` — RA treats
  AF/BC/DE/HL as callee-saved so it doesn't insert its own PUSH/POP for them
- `Z80FrameLowering::assignCalleeSavedSpillSlots`: marks AF/BC/DE/HL with `setRestored(false)`,
  no stack slot created for them
- `Z80FrameLowering::spillCalleeSavedRegisters`: emits EXX + EX AF,AF' before PUSH IY
- `Z80FrameLowering::restoreCalleeSavedRegisters`: POP IY, then EX AF,AF' + EXX
- `Z80FrameLowering::hasFPImpl`: always false for shadow-isr ISRs (no IX frame)

**Lit test:** `llvm/test/CodeGen/Z80/shadow-isr.ll`

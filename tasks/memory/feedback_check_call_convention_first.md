# On crazy/garbage results, ALWAYS check the calling convention FIRST

**User directive (2026-08-10):** "ved syge resultater ALTID check call convention
først" — when a value comes back *insane* (garbage ints, word-swapped longs,
scrambled pointers, non-deterministic junk, a function returning the wrong field),
the FIRST hypothesis to test is an **ABI / calling-convention mismatch**, before
suspecting the algorithm, the emulator, memory corruption, or a "race".

## Why this is the right first move here

The `llvm-z80` clang backend and z88dk's classic clib disagree on argument/return
conventions in many places, and the symptom is almost always *garbage*, not a
crash. This has bitten us repeatedly — it is a whole class, not a one-off:

- **ferror/feof under llvmz80** (FIXED 2026-08-10): plain `int ferror(FILE*)` decl fell
  outside the `__z88dk_fastcall` bridge under `__STDC_ABI_ONLY`; clang passed the
  FILE\* in a register, the hand-asm entry `pop`ped it off the stack -> returned stale
  caller bytes (1123 / 1139 / all-1s). Fix = drop the `#ifndef __STDC_ABI_ONLY` guard
  so the fastcall decl + redirect macro apply unconditionally (stdio.h, z88dk commit
  703bccfa53). Guard: `test/clang/runtime_fileio_ferror_feof`.
- **bdos() pointer-arg scramble** — #279/#52 (`reference_llvmz80_bdos_pointer_arg_scramble.md`).
- **32-bit `long` return word-swapped** — #51 (`reference_llvmz80_32bit_return_swap.md`):
  `clock()` delivered `ticks<<16`; HL/DE low/high disagreement.
- **`__z88dk_callee`/`__smallc` push-order + arg-width class** —
  `z88dk_z88dk_callee_llvmz80_abi_class.md`: clang's push order is *opposite* the
  classic worker and it narrows `uint8_t` stack args to 1 byte -> silent scramble.
- **HL<->DE 16-bit return class** — #50/#31.

## The check (do this before anything else)

1. Compile with `-S` and read the actual **push order, arg register/stack slot,
   and return register (HL vs DE)** at the call site AND at the callee entry.
2. Compare against the classic clib worker's convention (stack-arg `pop de/pop hl`
   vs fastcall register). A mismatch there IS the bug — stop looking elsewhere.
3. Confirm with a differential oracle (sccz80 as the correct reference); garbage on
   llvmz80 + correct on sccz80 is the ABI-mismatch fingerprint.

**Familiarity is not certainty:** even when it "looks like" a race or emulator bug,
the ABI check is cheap and is empirically the cause the vast majority of the time in
this workspace. Rule it out FIRST.

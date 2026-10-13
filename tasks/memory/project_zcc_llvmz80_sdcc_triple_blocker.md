---
name: project_zcc_llvmz80_sdcc_triple_blocker
description: Why zcc+llvmz80 is blocked on sdcc triple — requires elf2rel/runtime-2-libsdcc from fork owner
metadata:
  type: project
---

zcc+llvmz80 integration is **blocked** until the fork owner merges the elf2rel and runtime-2-libsdcc branches into upstream/main (2026-10-13).

## Current state

**llvm-z80 upstream/main** (as of 2026-10-13) knows only `Triple::SDCC` as a Z80 environment. `Triple::Z88DK` was in the archived `archive/z88dk-env-20261013` branch but conflicts with the libcall table refactor (#107).

**zcc triple**: must use `--target=z80-unknown-none-sdcc` because z88dk triple is not in upstream/main's `Triple::EnvironmentType` enum.

**Why sdcc triple + sdasz80 doesn't work:**
- clang with sdcc triple outputs SDCC-format assembly (`.area`, `.globl`, `#` immediates)
- z88dk's CRT files (`cpm_crt0.asm` etc.) are in z88dk-z80asm syntax → cannot be assembled by sdasz80
- sdldz80 expects SDCC `.rel` objects and `.lib` libraries → incompatible with z88dk's library format

**WIP commit**: `ravn/z88dk` `0633c22cb5` — routes CC_LLVMZ80 through sdasz80/sdldz80 in configure_compiler(), skips MODULE/LINE and BuildAsmLine flags. Assembly of user code works; CRT assembly fails.

## Three paths to resolution

1. **Wait for fork owner** — merge `elf2rel-2-sdcconv` + `runtime-2-libsdcc` into upstream/main. clang → ELF → elf2rel converts to .rel → sdld links with SDCC stdlib. No CRT format issue.

2. **Restore z88dk triple** — cherry-pick z88dk environment from archive. Requires resolving conflicts with libcall table refactor (#107 files: Z80LegalizerInfo.cpp, Z80InstructionSelector.cpp etc.). 

3. **Rewrite CRT in SDCC format** — convert all cpm_crt0.asm etc. to SDCC syntax. Substantial work, likely unnecessary once elf2rel lands.

**Recommended**: wait for path 1 (fork owner's work).

## Key lesson

`configure_assembler()` is called BEFORE `configure_compiler()` sets `compiler_type`. Assembler override must go inside `configure_compiler()` after `compiler_type = CC_LLVMZ80` is set.

**Why:** `1195: configure_assembler();` runs before `1196: configure_compiler();`, and `compiler_type` is only set at line 3736 inside `configure_compiler()`.

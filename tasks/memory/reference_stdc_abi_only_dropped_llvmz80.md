# `__STDC_ABI_ONLY` dropped for llvmz80 (ravn/z88dk#55)

**Status:** implemented on branch `fix/llvmz80-drop-stdc-abi-only` (commit 67bc26cee3, pushed, no PR yet). Full `test/clang` suite 61 PASS / 0 FAIL with the gate off.

## What the gate was
`include/sys/compiler.h` classic path defined `__STDC_ABI_ONLY` for `__clang__ | __CLANG | __XCC`, which hid every classic-header `#ifndef __STDC_ABI_ONLY` block — the sccz80 `_callee` (callee-clean) and `_fastcall` byte-optimized variants — forcing llvmz80 onto the plain `__ZPROTO`/`__smallc` workers.

## Why it could be dropped (post #279)
After ravn/llvm-z80#279 (`__smallc`→z80_smallc, `__z88dk_callee`→z80_callee land correctly), the combined `__smallc __z88dk_callee` path works end-to-end for the **146 pure-`.asm`** classic callee workers (itoa/ltoa/strtol/… verified green). Dropping the gate makes llvmz80 use the smaller `_callee`/`_fastcall` variants → code-size win.

## The change
Gate is now `#if !defined(__LLVMZ80)` inside the `__clang__ | __CLANG | __XCC` block, so **ez80 (`__XCC`) still gets `__STDC_ABI_ONLY`**; only llvmz80 drops it.

## Three blockers fixed when dropping it
1. **`ctype.h` `__preserves_regs`** — a builtin keyword in sccz80/SDCC but NOT clang. Added a no-op `#define __preserves_regs(x...)` for `__clang__ | __XCC` in `sys/compiler.h`. Without it the fastcall decls fail to parse ("expected function body after function declarator").
2. **`strerror`** (`string.h`) — the `#ifndef` branch declared the sccz80-historical `char *s` signature (references rodata `__rodata_error_strings_head`/table absent from the llvmz80 lib). Reordered so the correct `int errnum` `__LLVMZ80` branch wins regardless of the gate.
3. **`fputs`/`fputc`** (`stdio.h`) — excluded from their `_callee` redirect for llvmz80 (routed to caller-clean `__smallc` `_fputs`/`_fputc`), mirroring existing `fclose`/`fflush` handling.

## KEY LESSON: sccz80 `.c`-`#asm` callee hybrids are NOT genuinely callee-clean
`fputs_callee.c` and `fputc_callee.c` are the **only two** classic `_callee` workers written as sccz80 C functions with a `#asm` body (vs pure `.asm`). They are NOT callee-clean the way clang's `z80_callee` assumes, so exposing them drifts SP → the program restarts in a loop (double/looping output; e.g. `remove[ok]` printed repeatedly). Diagnostic: `find libsrc/classic -name '*_callee.c'` → exactly 2; `-name '*_callee.asm'` → 146. **Pure-`.asm` callee workers are safe; `.c`-`#asm` hybrids are not.** When exposing any sccz80 optimized variant to clang, check whether the worker is `.c` (hybrid) or `.asm`.

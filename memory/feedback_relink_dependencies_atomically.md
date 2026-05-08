---
name: When a C symbol is referenced via --defsym across linker stages, ship the Makefile + script changes in the same commit
description: Hard rule — adding a new cross-stage symbol means updating the linker script that defines it AND the Makefile rule that injects it AND the C declaration; missing any one leaves the next build with cryptic ld errors
type: feedback
originSessionId: de6f9865-d9ee-4776-abd2-c579088d6b91
---
HARD RULE — multi-stage linking pipelines (cpnos-rom's relocator
links against payload.elf via `--defsym=NAME=$(llvm-nm payload.elf
| awk ...)`) have a four-way coupling that's easy to break:

1. **C declaration** in the source file (`extern uint8_t foo[]`)
2. **Linker-script symbol** in `payload.ld` (`__foo = .;`)
3. **Makefile awk extraction** to pull the address out of payload.elf
4. **Makefile defsym injection** into the relocator link

Adding any new cross-stage symbol means updating ALL FOUR.  Missing
any one fails the build at link time, often with cryptic underscore-
prefix errors (Z80 ABI prepends `_` so a C symbol `__foo` becomes
linker symbol `___foo` — three underscores — and the defsym MUST
match the linker spelling, not the C spelling).

**Hit this 2026-05-07** when polypascal-test ran for the first time
on the BSS-clearing relocator: `ld.lld: error: undefined symbol:
___scratch_bss_start`.  Took two iterations to fix:
- iteration 1: added the awk extractions but forgot the defsyms
- iteration 2: had to fix the underscore count (used `__scratch_bss_start`
  instead of `___scratch_bss_start`)

**How to apply:**
- When adding a cross-stage `extern X[]` declaration in C, search the
  Makefile for the existing pattern (e.g., `_cpnos_cold_entry`,
  `_bios_boot`, `__stack_top`) and add a parallel set of awk +
  defsym lines in the SAME commit.
- Verify the underscore count: C symbol `_X` → linker symbol `__X`
  (one underscore added by Z80 ABI); C symbol `__X` → linker symbol
  `___X` (three underscores total).
- Run a clean build (`make clean && make`) before committing — the
  cached relocator.elf would not detect the missing defsym if only
  the .o files were stale.
- Cross-reference: the `--defsym` injection can be discovered by
  grepping `defsym=` in the Makefile.

**Why this matters:** these errors look like a bug in the new C
code, but are actually a bug in the build infrastructure that didn't
get co-updated.  Misidentifying the cause leads to chasing the C
side instead of the Makefile.

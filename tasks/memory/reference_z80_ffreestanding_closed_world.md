---
name: reference-z80-ffreestanding-closed-world
description: -ffreestanding sets the "Freestanding" module flag that Z80NonReentrant uses for closed-world proof — no fork-local switch needed
metadata:
  type: reference
---

For self-contained CP/M / firmware / bare-metal Z80 programs, pass **`-ffreestanding`** on the clang command line. It:

- Sets `LangOpts.Freestanding = true` in clang.
- Emits `!"Freestanding", i32 1` as an LLVM module flag (`CodeGenModule.cpp:1407-1408`).
- Is read by `Z80NonReentrant.isFreestandingModule()` (`llvm/lib/Target/Z80/Z80NonReentrant.cpp:65-72`).
- Enables the closed-world proof so single-node SCCs (externally-visible functions that call externals) get the `"nonreentrant"` attribute.
- Combined with `+static-frame` target-feature, this triggers direct BSS addressing (`ld (__sfrend_f+off),reg`, 3B ~20T) instead of SP-relative (`ld hl,off; add hl,sp; ld (hl),reg`, 6B ~40T).

**Measured effect** (e-benchmark, dcc/tests/e.c):
- `clang -O3` open-world (default): 4104 B / 23.16M T-states
- `clang -O3 -ffreestanding`: **3011 B / 16.85M T-states** (33.6% faster than dcc; 4% faster than historic 2026-07-14 peak)

**How to apply:** any Z80 build that isn't linking against a hosted C library (i.e. every real Z80 program) should already pass `-ffreestanding`. By the C standard, this sets `__STDC_HOSTED__ == 0`. If you find code where the freestanding assumption would break (some hidden runtime callback into module symbols), the default open-world analysis is the correct fallback.

**Why:** `Z80NonReentrant` has to be conservative under open-world separate-compilation: a function calling an external declaration could theoretically be re-entered via a cross-TU cycle. `-ffreestanding` is the standard signal that no such cross-TU cycle exists.

**Do NOT** use `-z80-closed-world` — that fork-local switch was removed 2026-09-16 (llvm-z80 commit `cf2fb412`) in favor of the standard flag. Same effect, universal convention.

**Related tests:** `llvm/test/CodeGen/Z80/static-frames-freestanding.ll`, `issue-132-bss-spill-cross-mbb.ll` (both use `!"Freestanding"` module flag in IR to drive the closed-world path in lit).

**Anti-pattern:** filing a bug for \"missing static-frame promotion\" without first checking whether the target's IR carries the `Freestanding` flag. Half the perf gap for open-world builds is the correct behavior of the safety gate, not a compiler regression.

---
name: Compiler is not trusted
description: HARD RULE — ravn/llvm-z80 is unfinished; on any suspected bug, inspect generated Z80 asm before blaming source code or hardware
type: feedback
originSessionId: 9adba288-d140-4e53-8e2b-2f1cfaedce42
---
HARD RULE: do not assume the compiler is correct.  When debugging any suspected bug, always inspect the generated Z80 assembly for the relevant function(s) before concluding the cause is in C source, runtime library, hardware, or peripherals.

**Why:** ravn/llvm-z80 is a preliminary backend (see `project_z80_backend_unfinished.md`).  Sessions 32, 33, 35, 41, 42, 44, 47 all included codegen miscompiles that masqueraded as application bugs — #74 (cross-pair PUSH/POP), #82 (BSS-spill orphan reload), #120 (sext-from-icmp), and others.  Default trust in the compiler costs hours per incident; default skepticism + an asm read costs minutes.

**How to apply:**
- Suspected bug in autoload-in-c / rcbios-in-c / cpnos-rom: build the per-source `.s` (or disassemble the `.bin`) for the function on the failure path BEFORE forming a hypothesis.
- "It works on SDCC but breaks on clang" / "size is identical but behavior differs": diff the asm.
- Stack corruption / wrong register on entry / wrong flags after a compare: candidate is regalloc / cross-pair / late-opt peephole.  Check before debugging the C.
- When the asm read shows a miscompile: file in ravn/llvm-z80 with a minimal lit reproducer + XFAIL test (per `feedback_compiler_bug_test.md`).
- Related but distinct: `feedback_verify_codegen.md` (multi-compiler same-size-different-behavior).  This rule is broader — applies to any single-compiler suspected bug.

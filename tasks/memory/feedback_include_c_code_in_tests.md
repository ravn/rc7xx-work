---
name: include-c-code-in-tests
description: HARD — Tests in PRs must include C code: (1) human-readable C reproducer in comments at the top of .ll/.mir tests, and (2) an executable C test (in test-runner) whenever it makes sense to catch runtime regressions.
type: feedback
originDate: 2026-09-20
---

**User directives (2026-09-20):**

> "husk dette fremover, pr's skal have c kode med til tests"
> "fakta: jeg vil gerne have c tests også når det giver mening for at fange regessioner"

**Why this exists:**
Backend tests in LLVM are written in `.ll` (LLVM IR) or `.mir` (Machine IR) because `llc` requires them. However:
1. For human readers (maintainers and ourselves), IR alone obscures the high-level C construct and bug trigger.
2. An IR or FileCheck pattern test checks codegen structure at a specific compiler pass, but does NOT execute the code. A real executable C test under the emulator (`test-runner`) exercises the entire toolchain (Clang frontend -> LLVM backend -> LLD linker -> runtime library / callee register contract) and catches regressions that slip past pattern checks.

**How to apply:**
Whenever adding or modifying tests for a PR:
1. **Comment in IR tests:** Always include a top-level comment block in `.ll` / `.mir` files showing the original failing C reproducer and equivalent C function.
2. **Executable C test when sensible:** When a bug involves runtime behavior, calling conventions, callee register state, or runtime library interactions, add a matching executable `.c` test in `z80-utils/test-runner/testcases/clang/` to catch regressions end-to-end under CI (`runtime-tests`).

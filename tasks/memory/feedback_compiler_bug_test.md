---
name: Always write a lit test for every compiler bug found
description: Every llvm-z80 or SDCC codegen bug must produce a corresponding lit test (XFAIL initially), committed with the bug report
type: feedback
originSessionId: 57254a72-8bad-4840-ab6e-f5fbc35df805
---
When a codegen bug in clang/llvm-z80 is discovered during this project's
BIOS/PROM work:

1. Minimize the C source that triggers the bad codegen into a lit test.
2. Add the test to `llvm-z80/llvm/test/CodeGen/Z80/` (or appropriate
   subfolder) with a filename that describes the bug (e.g., `lshr-rrca.ll`,
   `partial-fold-byte-ptr.ll`).
3. Mark it `XFAIL: *` if the bug is not yet fixed, or write the `CHECK`
   lines for the correct expected output if fixing immediately.
4. Commit the test alongside the issue file or the fix PR.

**Why:** Without a regression test, every future LLVM rebase risks
silently reintroducing the bug. A lit test ensures the failure
surfaces immediately at the next `llvm-lit` run.

**How to apply:** Whenever you find a codegen anomaly (bloated output,
wrong register allocation, missed peephole), don't just file the issue —
write the lit test first, use it as the body of the issue description,
then attempt the fix. The test also serves as the issue's reproduction
case.

**Scope:** Applies to llvm-z80 primarily, but if you find an SDCC bug
too, file it as an issue in ravn/z88dk (never upstream) with a C
minimizer attached. SDCC doesn't have lit; a shell-level reproduction
suffices for SDCC.

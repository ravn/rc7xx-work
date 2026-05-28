---
name: Add ravn/hitech as third compiler submodule
description: Pending future task — add https://github.com/ravn/hitech as a third Z80 C compiler under /Users/ravn/z80/ alongside llvm-z80 and z88dk
type: project
originSessionId: 986bb359-738f-4014-bfb2-add9f26e34f5
---
Pending TODO recorded 2026-05-02: add `https://github.com/ravn/hitech`
as a third compiler submodule in the `/Users/ravn/z80/` workspace,
sitting alongside `llvm-z80/` (clang) and `z88dk/` (sdcc/sccz80).

**Why:** broadens the C-compiler comparison set beyond clang vs SDCC.
HiTech is a historically significant Z80 compiler; having it
available enables three-way code-density and codegen-quality
benchmarking on rcbios/cpnos-rom/PROM workloads.

**How to apply:** when the user signals readiness, add as a git
submodule (likely under `/Users/ravn/z80/hitech/`).  Then update
CLAUDE.md's "Workspace Layout" section to list it, and consider
whether the per-function size baseline tracker (Phase A.1 of the
2026-05-02 code-density plan) should also accept HiTech-built
binaries.

Not yet started; user said "to do later".  This memory exists so
future sessions don't lose the request.

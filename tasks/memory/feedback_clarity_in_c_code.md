---
name: Clarity in C code is very important
description: Across all rc700-gensmedet C work, prefer readable call shapes and visible side-effects over macro-tricks; restated 2026-05-05 during cpnos-rom dual-compile port
type: feedback
originSessionId: de6f9865-d9ee-4776-abd2-c579088d6b91
---
HARD RULE: When designing dual-compiler / multi-target abstractions in
the rc700-gensmedet C sources, prioritize *call-site clarity* over
compiler-internal cleverness.

**Why:** This is shared, long-lived embedded C that will be read by the
user (and by Claude across many sessions) far more often than it is
edited.  Restated by the user 2026-05-05 during the cpnos-rom dual-
compile port, in the same turn that introduced the third-compiler (HiTech)
direction — i.e. it's load-bearing for how the dual+/triple compile
abstraction is structured.

**How to apply:**
- Prefer `_port_out(PORT_X, val)` over DEFPORT-generated `port_out(x, val)`
  if the function-call shape is just as portable (it is for clang +
  inline-asm helper for SDCC).
- Compiler-specific glue lives in `hal.h` / `intrinsic.h`; never let
  `#ifdef __SDCC` leak into business logic in .c files.
- A C source that compiles under three compilers should *read* the same
  under all three.  Don't ask the reader to mentally trace through which
  expansion fires.
- Keep call-site syntax consistent for compile-time and runtime ports
  (same function, same argument shape).
- When in doubt: if removing the macro indirection makes the code less
  flexible but more readable, prefer the readable form and document
  the tradeoff at the macro definition.
- Function-call overhead (17-20 T-states for an extra port helper)
  is acceptable on boot/init paths to keep the source clear.  For
  hot-path code, measure first.
- DEFPORT-style codegen-in-macro should be reserved for cases where
  the alternative (function call) is *unworkable*, not merely slower.

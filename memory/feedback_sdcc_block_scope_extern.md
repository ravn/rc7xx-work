---
name: feedback-sdcc-block-scope-extern
description: "SDCC z88dk drops function-scope `extern` declarations; use file-scope only"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6bb2377c-77ab-4014-8339-b92776bcffc5
---

When declaring an `extern` for a cross-translation-unit C function
that gets compiled by SDCC (z88dk), the declaration MUST live at
file scope, not inside a function body.

**Why:** SDCC's z88dk back-end silently fails to emit the matching
`GLOBAL <symbol>` directive into the generated `.asm` when the
extern is at block scope.  The `.asm` references the symbol via
`call _foo` without declaring it as imported, and z80asm fails the
assemble step with `undefined symbol: _foo`.  Clang Z80 accepts
block-scope externs and produces a correctly-relocatable .o, so the
bug only surfaces under SDCC.

Worse, the error can be MASKED by stale `.o` files in `sdcc/` that
make won't rebuild (if the .c source change leaves the .o still
"newer" than its prerequisite chain) -- the build appears to
succeed using last week's objects, and the resulting slave runs
pre-change code that fails in puzzling ways at runtime.  Cost
several hours of debugging a "SNIOS protocol stall" that turned out
to be stale code.  Filed at https://github.com/ravn/z88dk/issues/7.

**How to apply:** when adding a cross-TU function call in any C
file that compiles under SDCC z88dk, declare the extern at the top
of the .c file (outside any function body), not inline at the call
site.  When debugging "SDCC behaviour differs from clang", check
generated .asm for missing GLOBAL/EXTERN lines around the
suspect call.  When the slave's banner timestamp / git hash is
older than the source you just edited, suspect stale .o files
FIRST -- delete and rebuild before deeper investigation.

Related: [[feedback-compiler-not-trusted]] (always inspect
generated z80 asm), [[feedback-verify-codegen]] (multi-compiler
parity matters).

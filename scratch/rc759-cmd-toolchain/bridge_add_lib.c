/* DR C-compiled callee for the Watcom->DR C ABI bridge proof.
   K&R C89 (DR C 1.11 is pre-ANSI): old-style params, no prototypes.
   Compiled by DR C in its default LARGE model -> emits a FAR routine
   (retf) reading stack args at [bp+6]/[bp+8], returning in AX. This is
   the exact convention a Watcom -ml `#pragma aux ... far` call targets. */
add(a, b) int a, b; { return a + b; }

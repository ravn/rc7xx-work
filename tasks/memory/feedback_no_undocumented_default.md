---
name: No undocumented instructions by default
description: Never use undocumented Z80 instructions without +undocumented flag
type: feedback
---

Never use undocumented Z80 instructions (IXH/IXL/IYH/IYL LD, SLL, etc.) unless the user has requested +undocumented. Some Z80 clones don't support them.

**Why:** User rejected a fix that used undocumented LD for IX/IY copies without the flag. The fix was correct for real Z80 but wrong as a general solution.

**How to apply:** When fixing codegen bugs involving IX/IY register copies, do not switch from PUSH/POP to undocumented LD without `+undocumented`. Instead, fix the SP-relative offset tracking or avoid IX/IY sub-register allocation.

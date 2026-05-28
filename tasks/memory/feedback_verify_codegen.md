---
name: Verify generated code, not just size
description: For multi-compiler portable code (especially inline asm), check disassembly for each compiler — size unchanged ≠ behavior unchanged
type: feedback
---

When writing C code that targets both clang and SDCC (for the Z80 PROM/BIOS),
**always verify the generated assembly for each compiler**, not just the binary size.

**Why:** Compilers can produce broken code that links fine and has reasonable
size. In session 12, I added `static inline __naked` SDCC helpers that SDCC
inlined by pasting the asm body — including the `ret` — into the caller. The
caller (`sio_wr5`) returned after the first OUT, missing the second. Binary size
was unchanged. The user caught this by reading `bios.c.lis` themselves.

**How to apply:** After modifying any function intended to compile under both
clang and SDCC, run `make -C clang` AND `make -C sdcc`, then look at:
- `rcbios-in-c/bios.lis` (clang disassembly via objdump)
- `rcbios-in-c/sdcc/*.c.lis` or similar (SDCC source listing with embedded asm)

For inline asm specifically, watch for:
- `static inline __naked` — broken combo: SDCC pastes the asm body including
  the `ret`, terminating the caller early. Use plain `static __naked` instead
  (function is called via CALL, no inlining).
- `__naked` functions calling other functions — the called function expects a
  proper stack frame, the naked one might not have one.
- Early `ret` instructions in inlined helpers — same issue as above.

**Quick check after compile:** SDCC issues warning 221 for `inline function 'X'
is __naked` — heed it. If I see this warning, that function is silently
miscompiled.

**Better still:** if both clang and SDCC support a pure-C macro form (e.g.,
`#define port_out_rt(p,v) (*(volatile __io uint8_t *)(p) = (v))`), prefer that
over inline asm. Pure C is harder to mis-compile and easier to verify.

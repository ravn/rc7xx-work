---
name: reference_llvmz80_double_reverse_suspects
description: Two more z88dk headers use the same reversed-param __LLVMZ80 workaround as the bdos #52 bug (broken by #279); likely broken, need verification-driven fixes
metadata:
  type: reference
---

The bdos() bug ([[reference_llvmz80_bdos_pointer_arg_scramble]], ravn/z88dk#52)
was a `#if defined(__LLVMZ80)` branch that declared a REVERSED-parameter shim +
swapping macro, correct only while `__smallc` == sdcccall(0) (right-to-left).
**#279 redefined `__smallc` as `z80_smallc` (left-to-right)**, double-reversing
it. Fix: drop the reversal (natural order == classic layout).

**Two more headers use the identical pattern and are almost certainly broken
the same way** (found 2026-08-08 answering "are there more?"):

1. **`z88dk/include/arch/z80.h:146` — `z80_outp`**
   `extern void __z80_outp_llvmz80(uint16_t data,uint16_t port) __asm__("z80_outp_callee") __smallc __z88dk_callee;`
   `#define z80_outp(a,b) __z80_outp_llvmz80(b,a)`  (classic: `z80_outp(uint16_t port,uint8_t data)`)

2. **`z88dk/include/video/sem702.h:82` — `sem702_loadglyph`**
   `extern void __sem702_loadglyph_llvmz80(unsigned int nlines,const unsigned char *lines,unsigned int ch) __asm__("sem702_loadglyph") __smallc;`
   `#define sem702_loadglyph(a,b,c) __sem702_loadglyph_llvmz80(c,b,a)`  (classic: `(unsigned char ch,const unsigned char*lines,unsigned char nlines)`)

**Why NOT blind-fixed (unlike bdos):** these also do WIDTH widening (narrow
`uint8_t`/`char` -> `uint16_t`/`int`) because clang pushes narrow args
differently than sccz80, AND the `z80_outp_callee` worker reads `data` from a
**1-byte slot** (`dec sp; pop hl`). Order + width + the worker's slot layout are
coupled, and this is the SILENT-wrong-output class (no crash). bdos was
trivially runtime-verifiable (VER=34); these are not testable in ntvcm.

**Verification vehicles for the fix:**
- `sem702_loadglyph`: the existing **sem702-flip-test** (rc700-gensmedet) on MAME
  `rc702sem702` (SEM702 chargen, ports 0xD1/D2/D3) exercises it end-to-end.
  Run it against a fresh clang build; if the glyphs are wrong, it's broken.
- `z80_outp`: needs a targeted test (a port whose OUT is observable, or MAME
  port trace).

**Proposed fix (same as bdos, guided by the worker):** natural (classic) param
order under `__LLVMZ80`, keeping only the clang-necessary width widening, and
confirm the generated stack layout matches what the classic worker pops. Verify
per function via the vehicles above before committing (silent-corruption risk).

NOT yet fixed — tracked task.

# z88dk __z88dk_callee ABI mismatch class under -compiler=llvmz80

Found 2026 (rc700-gensmedet sem702-flip-test session). Two distinct, compounding
bugs affecting hand-written classic-sccz80 `.asm` stack workers (functions
declared `__smallc __z88dk_callee`) when called from clang under
`-compiler=llvmz80`:

1. **Push-order mismatch.** clang's `sdcccall(0)` pushes stack args with the
   FIRST-declared C parameter ending up TOPMOST of stack. Many classic workers
   (written against sccz80's own natural call-site order) instead expect the
   LAST-declared parameter topmost. Confirmed via `clang -S` vs classic `zcc -S`
   comparison for both `bdos(func,arg)` and `z80_outp(port,data)`.
   - `bdos(2,'H')` silently executed BDOS function 72 with argument 2 instead
     of function 2 with argument 'H' -- surfaced as "Unsupported BDOS call
     72/69/76/76/79/87/79/82/76/68/13/10" (ASCII "HELLO WORLD").

2. **Stack-slot width mismatch (independent bug, only some functions).**
   Classic sccz80 always reserves a full 2-byte stack slot per argument, even
   for `uint8_t`. clang narrows a `uint8_t` parameter to a 1-byte push
   (`push af; inc sp`), so the worker's fixed 2-byte `pop` under-reads/over-reads
   and corrupts the stack -> hang. Reproduced with `z80_outp(uint16_t,uint8_t)`:
   z88dk-ticks ran the full tick budget (hang) with `uint8_t data`; widening
   the low-level reversed prototype's parameter to `uint16_t` fixed it
   (18337 ticks, matching classic's 18334).

**Fix pattern (established, matches existing fread/fseek precedent):** under
`#if defined(__LLVMZ80)`, bind the macro to a NEW low-level prototype with (a)
reversed C parameter order and (b) all narrow (<16-bit) params widened to
their natural register width, bound via `__asm__("original_worker_symbol")
__smallc __z88dk_callee` to the SAME underlying `.asm` symbol -- no assembly
changes needed. See `z88dk/include/cpm.h` (`bdos`/`bdosh`) and
`z88dk/include/arch/z80.h` (`z80_outp`), commit 68a3462825.

**Scope of remaining risk:** ~1500 other `__z88dk_callee` declarations exist
across z88dk headers (string.h, stdio.h, stdlib.h, math.h, arch/*.h, etc.).
Only `bdos`/`bdosh`/`z80_outp`/`sem702_loadglyph` have been audited and fixed
so far. Any other multi-arg `__z88dk_callee` OR `__smallc` function reached via
`-compiler=llvmz80` should be assumed unverified until individually checked with
the same `-S` push-order + width comparison, since the register/stack layout
differs per function signature (this is NOT a single global backend bug -- each
function needs its own reversed/widened prototype).

**CRITICAL follow-up (sem702_loadglyph, 2026-08-02, commit af7776f043):** the
bug class also affects plain `__smallc` functions (caller-cleans), not just
`__z88dk_callee` -- because the push-order + width issues are properties of
sdcccall(0) stack layout, and `__smallc` IS sdcccall(0). MORE IMPORTANTLY:
adding the `__smallc` annotation ALONE is NECESSARY BUT NOT SUFFICIENT. For
sem702_loadglyph the earlier fix added only `__smallc`, which stopped the
immediate stack-desync hang but left the args SCRAMBLED (ch<->nlines swapped +
1-byte-vs-2-byte narrowing) -- the program ran to completion but wrote garbage
to the SEM702 chargen, so the visible output was silently wrong (semigraphics
text rendered as noise) with no hang and no crash. Lesson: after annotating a
classic worker `__smallc` for clang, ALWAYS also verify push order AND arg width
via `-S` (or an end-to-end output check) -- "it no longer hangs" does NOT mean
"the args arrive correctly." A MAME I/O port-write trace (or z88dk-ticks BDOS
trace) is the reliable end-to-end oracle.

## SUPERSEDED (2026-08-08): __smallc now = z80_smallc, so DROP the reversal

ravn/llvm-z80#279 landed a real `z80_smallc` calling convention (left-to-right
push, caller-clean) and #282 composed `z80_smallc + z80_callee` = cc133.
`<sys/compiler.h>` now maps `__smallc -> __attribute__((z80_smallc))` and
`__z88dk_callee -> __attribute__((z80_callee))` on the llvmz80 path. z80_smallc's
push ORDER is byte-for-byte the classic sccz80 __smallc order (first-declared
param DEEPEST), which is exactly what the classic workers read.

Consequence: the REVERSED-order `__*_llvmz80` bridges written for the OLD
`__smallc == sdcccall(0)` era became DOUBLE reversals under z80_smallc and were
therefore BROKEN (args swapped again). cpm.h bdos/bdosh was fixed to natural
order in ravn/z88dk#52. The last two reversed bridges -- `z80_outp` (arch/z80.h)
and `sem702_loadglyph` (video/sem702.h) -- were cleaned up 2026-08-08: reversal
removed, natural param order restored.

CAVEAT that persists: z80_smallc fixes ORDER but NOT WIDTH. clang still narrows
a `uint8_t`/`unsigned char` arg to a 1-byte push (`ld a,x; push af; inc sp`)
under z80_smallc, while the classic sccz80 worker reads a fixed 2-byte slot per
arg. So narrow (<16-bit) params passed to a classic worker MUST still be WIDENED
to `unsigned int`/`uint16_t` in the llvmz80-branch prototype. Verified via
`clang --target=z80 -S`: a widened arg emits `ld hl,x; push hl` (2-byte slot);
a char arg emits the 1-byte `push af; inc sp` form. Net current recipe for a
multi-arg classic worker under llvmz80: NATURAL order + widen narrow params
(no reversal, no __asm__ rename since the public symbol already matches).

## 2026-08-08 (cont.): also found+fixed malloc.h realloc (same double-reversal)

Auditing for OTHER remnants of the pre-#279 reversal, found `include/malloc.h`
`realloc` broken in BOTH the non-__STDC_ABI_ONLY path and the
`__STDC_ABI_ONLY && __LLVMZ80` path: `#define realloc(a,b) realloc_callee(b,a)`
(one path also declared realloc_callee with reversed params). The swap was
written for the old sdcccall(0) "1st arg on top" regime; under z80_smallc it is
a double reversal. realloc_callee.asm does `pop bc`(=size, topmost) then
`ex (sp),hl`(hl=p, deeper) and asm_realloc wants hl=p/bc=size -- so it needs p
pushed DEEPEST, i.e. NATURAL order under z80_smallc. Verified broken->fixed via
`clang --target=z80 -S`: swap put size in hl / p in bc; natural
`realloc_callee(a,b)` puts p deepest -> hl=p, bc=size. Fixed both to natural
order (calloc_callee(a,b) was already order-immune via commutative multiply).

Audit result: the only reversed __asm__ bridges were z80_outp + sem702_loadglyph
(fixed); the only wrong arg-SWAP macro was malloc.h realloc (fixed); bdos/bdosh
already fixed in ravn/z88dk#52. bdscio.h `movmem->memcpy` and aztecc.h
`fcbinit->setfcb` swaps are legitimate API-dialect order remaps (BDS C / Aztec
C), NOT calling-convention workarounds. NOT exhaustively audited: the ~1500
other multi-arg __smallc/__z88dk_callee decls -- natural-order decls are
correct-by-construction under z80_smallc, so residual risk is limited to (a) any
NARROW (char/uint8_t) param reached from clang [needs widening, per z80_outp],
which must be checked per-function when first called from a clang program.

## 2026-08-08 sweep numbers (definitive reversal audit)

Reversal class: FULLY SWEPT -- grep for arg-swap macros mapping to *_callee/
*_worker and for reversed __asm__ bridges finds ZERO remaining after fixing
z80_outp, sem702_loadglyph, malloc.h realloc (bdos/bdosh done in #52).
movmem->memcpy and fcbinit->setfcb are API-dialect remaps, not CC bugs.

Width class (latent, per-function-when-called): in classic include/ (excluding
_DEVELOPMENT), stack-passing (__smallc/__z88dk_callee, NOT __z88dk_fastcall)
declarations that take a narrow char/uint8_t param number ~779 (of which ~378
are multi-arg).  These are order-correct by construction under z80_smallc but
clang narrows their char args to 1-byte pushes vs the classic worker's 2-byte
slot, so each needs its char params widened to int WHEN first called from a
clang program (verify per-function with `clang --target=z80 -S`).  Not batch-
fixable safely -- most are never reached from clang, and each needs its own asm
check.  __z88dk_fastcall char params are register-passed and need no widening.

## stdcbench is NOT a runtime oracle for the realloc swap (2026-08-08)

stdcbench MODULES=all prints "STDCBENCH OK" (score 480) under BOTH the old
(swapped) and new (natural) realloc.h -- the .com binaries DIFFER (header
change is compiled in) but the result is identical. Reason: c90lib's only
realloc call is `Safe_realloc` in c90lib-htab.c:133, reached only when a
peephole var key exceeds `DEFAULT_HTAB_SIZE` (=32). Keys come from
`keyForVar()` parsing `%N` var numbers in the peephole rules, which stay
<=~12. So the realloc GROWTH path is compiled but NEVER EXECUTED -> stdcbench
cannot discriminate the ABI swap. "Green looks too easy" fired here.

Discriminating oracle = standalone grow test (rtest.c): malloc(16), fill,
realloc(p,200), verify first 16 bytes survive + write the 200-byte region,
run under ntvcm. Needs `#pragma define CRT_STACK_SIZE=2048` so the classic
crt defines `_heap` (crt_section.inc:74). Red-green VERIFIED 2026-08-08:
  - OLD committed malloc.h (reversed decl + realloc_callee(b,a) swap): REALLOC NULL
  - FIXED malloc.h (natural realloc_callee(a,b)):                       REALLOC OK
Ground truth: realloc_callee.asm does `pop hl`(retaddr) `pop bc`(=topmost arg)
`ex (sp),hl`(hl=deepest arg); asm_realloc wants hl=p, bc=size -> p must be
pushed DEEPEST = natural left-to-right z80_smallc order. Swap put size in hl,
p in bc -> MAHeapRealloc on a bogus block -> NULL.

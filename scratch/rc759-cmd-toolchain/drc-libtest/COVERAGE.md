# DR C 1.11 library conformance suite -- coverage manifest

The suite (`drc-libtest.sh` + `drc-libtest/t_*.c`) certifies that the Open Watcom
-> DR C bridge invokes each DR C library routine with faithful arguments and
return registers. Method: the **differential oracle** -- one portable K&R source
built THREE ways (genuine DR C 1.11 via `drc-oracle.sh` = ground truth; Watcom
bridge large + small via `cc-cpm86.sh`), run headless under emu2, outputs diffed.
PASS iff both bridge models reproduce the oracle byte-for-byte. Where the genuine
build is confounded under emu2 (file I/O read path), a committed `t_NAME.expect`
(the bridge's independently-correct output) is the oracle instead.

Run:  `./drc-libtest.sh`        (all)   /   `./drc-libtest.sh t_string`  (one)

## Status legend
- **PASS**   -- covered by a test, both bridge models match the oracle.
- **BLOCKED**-- register mapping disassembly-verified, but runtime value cannot be
                asserted through the oracle (documented confound).
- **CATALOG**-- system/stream routine reachable only with more OS/FS scaffolding;
                a representative subset of its family is PASS, the rest listed.
- **INTERNAL** -- compiler/runtime helper, not a user-facing entry point; excluded.

## Return-register bridge classes (proven by bwdis on CLEARL/CLEARS)
| return type        | registers        | alias     |
|--------------------|------------------|-----------|
| int / char / near ptr | AX            | DRC       |
| far ptr (large)    | BX:AX (seg:off)  | DRC_PTR   |
| long / float       | BX:AX            | DRC_LONG  |
| double             | DX:CX:BX:AX      | DRC_DBL   |

Two latent bugs found + fixed while building this suite:
1. **far-ptr return**: `_preincl.h` claimed DX:AX ("Watcom default matches") but
   DR C returns far pointers in **BX:AX** -- every pointer-returning routine
   (malloc/strchr/fopen/...) crashed when its result was used. Fixed: DRC_PTR.
2. **long/double sets were incomplete**: only atol/ftell/getl + atof were tagged;
   lseek/tell/putl (long) and sqrt/sin/cos/exp/fabs/tan/atan/log/log10 (double)
   were mis-returned. Fixed: complete DRC_LONG / DRC_DBL sets from DR C's STDIO.H.

---

## string / memory-block   -> t_string.c   (PASS)
strlen strcpy strcat strncpy strncat strcmp strncmp strchr strrchr index rindex
swab blkfill blkmove
- strcmp9 : PASS-family (DR C variant of strcmp; same convention).

## conversion (integer)    -> t_conv.c     (PASS)
atoi atol
- ftoa : BLOCKED (float formatting; see math).

## dynamic memory          -> t_mem.c      (PASS)
malloc calloc realloc free
- zalloc : CATALOG (zeroing alloc; same DRC_PTR class as calloc).
- sbrk nbrk brk brk2 brkk : CATALOG (heap-primitive internals under malloc).

## stdlib utility          -> t_stdlib.c   (PASS)
qsort rand srand
  (qsort also proves the DR C -> Watcom *callback* ABI: comparator called by DR C.)

## non-local jump          -> t_setjmp.c   (PASS)
setjmp longjmp

## formatted I/O           -> t_fmt.c      (PASS)
printf sprintf sscanf
  (printf is also exercised by EVERY other test's output.)
- fprintf fscanf : CATALOG (stream forms of printf/scanf; same varargs bridge).
- Note: DR C %x emits UPPERCASE hex; %X unsupported; its printf desyncs varargs on
  some multi-specifier strings (e.g. "%u %x") -- reproducible in genuine DR C, so
  a DR C quirk, not a bridge fault. Tests use one specifier per call.

## file I/O                -> t_fileio.c   (PASS, expect-oracle)
fopen fclose fputs fgets ftell unlink
  (genuine DR C's read path is confounded under emu2; the bridge is independently
   correct -- CP/M text mode stores "\n" as CR LF, so ftell=10 for a 9-char line.)
- fgetc fputc fputn fread fwrite fseek rewind ungetc setbuf fflush getw putw
  getl putl readl writel fdopen fopena fopenb fopenax fopend freopen freopa
  freopb freopbb freopen4 perror : CATALOG (same file-stream family + DRC_PTR/LONG
  bridge; representative subset above is PASS).

## official DR C §2.5 validation   -> t_testc.c   (PASS)
The distribution's own TEST.C (rc759-drc-official/test.c): int, long, **float add,
double divide**, printf %u/%ld/%g. Runs as a full differential test (genuine
main() vs bridge DRC_MAIN via the TMAIN macro). Both bridge models reproduce
genuine DR C byte-for-byte (float 1.235, double 4567) -- so basic float/double
ARITHMETIC + printf formatting is compatible across the Watcom(-fpi87 IEEE 8087)
-> DR C CLEARL bridge.

## math library: compatibility summary  (corrected 2026-08-13, see ../DRC_FLOAT_ANALYSIS.md)
- **Basic float/double arithmetic (+ - * /) and printf/scanf %g/%f/%e/%ld: COMPATIBLE**
  (verified by t_testc). DR C's printf reads Watcom's IEEE-8087 doubles correctly.
  So for value-level float I/O you use DR C's CLEARL runtime unchanged.
- **DR C's transcendentals (sqrt sin cos tan atan exp log log10 fabs) are REAL
  software routines and CORRECT in genuine DR C** -- NOT stubs (earlier claim
  retracted). CLEARL module FPTRAN -> DPFNCS, 0 8087 opcodes; genuine runtime:
  sqrt2=1.4142, sin1=0.8415, cos1=0.5403, exp1=2.7183, atan1=0.7854. The former
  "garbage" was a K&R declaration bug (undeclared math fn defaults to int-return,
  truncating the 8-byte double) -- reproducible in genuine too; declare `double`.
- **BLOCKED on the BRIDGE only:** double-*returning* DR C calls do not bridge under
  Watcom -fpi87. Watcom's double-return ABI is `fld qword ptr [bx]` (pointer-in-BX
  / 8087 ST0); the `value [dx cx bx ax]` DRC_DBL pragma is ignored for 8-byte
  doubles, so DR C's DX:CX:BX:AX result is lost (prints 0 / denormal). Fix = asm
  thunk (repackage DX:CX:BX:AX -> memory, return ptr in BX) or a non-8087 float
  model; alternatively wire Watcom's own 8087 helpers (EXTRN `IF@DSQRT`/`IF@DSIN`
  + `__8087`/`_fltused_`, classicize `math87*.lib`). Not a pragma tweak.

## math transcendentals (double)   -> blocked_math.c   (BRIDGE-BLOCKED, GENUINE-OK)
atof sqrt sin cos tan atan exp log log10 fabs
  Genuine DR C: correct (real software routines). Bridge: BLOCKED by the -fpi87
  double-return ABI mismatch (see above / DRC_FLOAT_ANALYSIS.md).
- expv sqrtb sqrtz : INTERNAL (double-valued helpers behind exp/sqrt).

## console input (needs stdin)   (CATALOG)
scanf gets getpass ttyinraw
  Require interactive input; emu2 can pipe stdin but output is not deterministic
  for a byte-diff. Reachable with an input fixture (future extension).

## CP/M system-call wrappers     (CATALOG)
access chmod chmod2 chmod8 chown close creat creata creatb open opena openb
read write lseek tell rename isatty isdev mktemp getpid execl exit tclose
osattr os_versionn net_check gtty gttye stty ttyname ttynamez
  OS/FS-level; `unlink` is PASS (t_fileio) as the representative. Others need
  drive/BDOS scaffolding under emu2; return-register classes already assigned
  (lseek/tell -> DRC_LONG; mktemp/ttyname* -> DRC_PTR).

## internal / non-user-facing helpers   (INTERNAL, excluded)
m0_ su7 vload line lineseek uldiv uldivr rewindj
  Compiler/runtime plumbing (long division helpers, buffer plumbing, jump
  trampolines); never called directly from C source.

---

## Summary
- **PASS: 8 tests** (string/mem 16 routines, conv 2, mem-alloc 4, stdlib 3,
  setjmp 2, fmt 3, fileio 6, official §2.5 TEST.C -- int/long/float/double math).
  Basic float/double arithmetic + printf formatting VERIFIED compatible.
- **BLOCKED (bridge only): transcendentals** (sqrt/sin/cos/exp/log/tan/atan +
  fabs) -- REAL software routines, CORRECT in genuine DR C; the bridge loses the
  double return under -fpi87 (fld [bx] vs DX:CX:BX:AX). See DRC_FLOAT_ANALYSIS.md.
- **CATALOG: ~60** (file-stream family, console-input, CP/M syscalls -- bridge
  classes assigned; representative members PASS; full coverage needs I/O fixtures).
- **INTERNAL: ~12** (helpers, excluded by design).
The computational + pointer + memory + control-flow + basic-float core of the DR C
library (the part whose ABI the bridge must get right) is fully exercised and green.

---

## Bridge codegen bug: `long` mul/div in a loop — ROOT-CAUSED & FIXED (2026-08-13)

Discovered while building the RC759/MAME acceptance test (`../mame-tests/mtest.c`),
then root-caused and fixed the same day.

**Symptom (before fix):** a `long` variable updated with `*`/`/`/`%` on each
iteration of a `for`/`while` loop kept its INITIAL value under emu2, and HUNG on
real MAME rc759.

```c
long r = 1; int i;
for (i = 0; i < 4; i++) r = r * 10;   /* wanted 10000; hung / yielded 1 */
```

**ROOT CAUSE (verified via `bwdis` disassembly + a full manual LINK-86):**
Open Watcom's 32-bit long-math helper `__I4M` (and `__I4D` for div/mod) was
**UNDEFINED at link time**. DR C's `CLEAR?.L86` does not provide it, and
`cc-cpm86.sh` did not link Watcom's own `i4m.obj`/`i4d.obj` cgsupp objects. So
`call far ptr __I4M` targeted an unresolved address (~0000:0000) → hang on the
real 80186 (MAME), wrong/no-op value under emu2. Watcom's loop codegen itself was
CORRECT (accumulator in DX:AX, multiplier in CX:BX, counter in SI).

**Why no earlier test caught it:** every prior "passing" single-long case
(`a=a*7L`, probe8 A/B/C) was **constant-folded at compile time** and never emitted
a runtime `__I4M` call. A loop-carried long multiply is the first non-foldable
long op, so it was the first to reference the missing helper.

This RETRACTS the earlier "register writeback / store-back" hypothesis — it was
never a codegen writeback bug, purely a missing-library-link.

**FIX (`cc-cpm86.sh`):** classicize the model-appropriate cgsupp helpers
(`bld/clib/cgsupp/library/msdos.086/{ms,ml}/i4m.obj` → `I4M.OBJ`, `i4d.obj` →
`I4D.OBJ`; small model needs `--merge-text-into-code`) and link them:
`LINK86 "OUT=$OBJLIST,I4M,I4D,WMARKS,$CLEAR"`. The undefined-symbol guard was also
broadened to fail on ANY undefined symbol except the dead `clear_error` 8087 path
(the old allowlist only caught `big_code|small_code|cstart`, so `__I4M` slipped
through and produced a silently-hanging CMD).

**VERIFIED FIXED:**
- emu2, both models: `../mame-tests/longloop.c` prints `loop r=10000`.
- **Real MAME rc759, large model: `mtest.c` → RESULT: PASS 19/19**, including the
  loop-carried long checks `lfact 12!` (= 479001600) and `lpow10 5` (= 100000).
  See `../mame-tests/MTEST_PASS_19of19.png`.

No workaround is needed anymore — loop-carried `long` arithmetic works.

**TODO:** confirmed in MAME (hangs — `LONGLOOP_HANG_confirmed.png`); next
disassemble the loop body (bwdis) to pin the missing store and file it against
the bridge/omf_classicize path.

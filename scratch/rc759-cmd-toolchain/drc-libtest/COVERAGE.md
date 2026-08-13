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

## math library: compatibility summary
- **Basic float/double arithmetic (+ - * /) and printf/scanf %g/%f/%e/%ld: COMPATIBLE**
  (verified by t_testc). DR C's printf reads Watcom's IEEE-8087 doubles correctly.
  So for value-level float I/O you use DR C's CLEARL runtime unchanged.
- **Transcendentals (sqrt sin cos tan atan exp log log10 pow): use WATCOM'S, not
  DR C's.** DR C's default CLEARL provides only *nofloat stubs* for these (they
  return garbage even in a pure genuine build; real DR C math needs a separate FP
  library not present on the v1.11 disk). Watcom -fpi87 supplies them, but only as
  external helpers: with proper ANSI prototypes + `#pragma intrinsic`, fabs/sqrt
  inline to 8087 ops while sin/cos/exp/log/tan/atan/pow emit calls to Watcom's
  8087 helper library (EXTRN `IF@DSQRT`/`IF@DSIN`/... + `__8087`, `_fltused_`).
  Those helpers would need to be linked into the CMD (Watcom-OMF -> classicize, or
  provide equivalents) -- not yet wired up. Tracked in blocked_float.c.

## math transcendentals (double)   -> blocked_float.c   (BLOCKED)
atof sqrt sin cos tan atan exp log log10 fabs
  DRC_DBL register mapping disassembly-verified; runtime BLOCKED (nofloat stubs,
  see above). Route these to Watcom's math, not DR C's.
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
- **BLOCKED: transcendentals** (sqrt/sin/cos/exp/log/tan/atan + atof/ftoa) --
  DR C's are nofloat stubs; route to Watcom's math (register mapping verified).
- **CATALOG: ~60** (file-stream family, console-input, CP/M syscalls -- bridge
  classes assigned; representative members PASS; full coverage needs I/O fixtures).
- **INTERNAL: ~12** (helpers, excluded by design).
The computational + pointer + memory + control-flow + basic-float core of the DR C
library (the part whose ABI the bridge must get right) is fully exercised and green.

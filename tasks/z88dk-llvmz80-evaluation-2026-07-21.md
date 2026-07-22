# ravn/llvm-z80 as a z88dk backend: evaluation (2026-07-21)

This document summarises the current state of `zcc +cpm -compiler=llvmz80` —
what works, what does not, and how it compares to the two other common Z80
compilers (zsdcc and dcc) on code quality.  It is written for z88dk maintainers
and contributors who want to understand the integration gap and decide which
areas to prioritise.

---

## 1. Status summary

`zcc +cpm -compiler=llvmz80` produces correct, runnable CP/M binaries for
integer-only programs and for programs that use IEEE-754 `double` arithmetic
(via the separate softfloat runtime; see §6).  The z88dk clib bridge is
substantially complete for the surfaces a typical CP/M program touches; the
remaining gaps are narrow and known.

### What works today (tested under ntvcm and/or MAME)

| Category | Status |
|----------|--------|
| `string.h` — memset/memcpy/memmove/memcmp/memchr | Bridged, ntvcm-verified |
| `string.h` — strcpy/strncpy/strcat/strncat/strcmp/strncmp | Bridged, ntvcm-verified |
| `string.h` — strchr/strrchr/strstr/strspn/strcspn/strtok | Bridged, ntvcm-verified |
| `string.h` — strlen/strnlen/strcasecmp/strncasecmp | Bridged, ntvcm-verified |
| `string.h` — strupr/strlwr/strrev/strstrip/strrstrip (z88dk ext.) | Bridged, ntvcm-verified |
| `string.h` — strdup | Links and runs |
| `ctype.h` — isalpha/isdigit/isalnum/isspace/isupper/islower/toupper/tolower/isprint/ispunct/iscntrl | Works, ntvcm-verified |
| `stdlib.h` — atoi/atol | Works |
| `stdlib.h` — strtol/strtoul | Bridged, ntvcm-verified |
| `stdlib.h` — itoa/ltoa/ultoa | **Bridged 2026-07-21**, ntvcm-verified |
| `stdlib.h` — abs/labs/rand/srand | Works, ntvcm-verified |
| `stdlib.h` — malloc/calloc/realloc/free | Works, ntvcm-verified |
| `stdlib.h` — qsort | Works with `__smallc` comparator, ntvcm-verified |
| `stdlib.h` — exit | Works |
| `stdio.h` FILE\* layer (fopen/fread/fwrite/fgets/fputs/fseek/ftell/rewind/feof/ferror/fclose/fflush/remove/rename/printf/fprintf/sprintf/snprintf/puts/putchar/getchar) | 27/27 link, MAME-verified |
| `stdio.h` — scanf/fscanf/sscanf | Links and runs |
| `printf`/`scanf` family — return value (count) | **Fixed** (ravn/z88dk#31, ntvcm-verified) |
| `vfprintf`/`vsnprintf`/`vsscanf` | Fixed (same root cause) |
| `time.h` — time/clock | Links (CP/M stubs) |
| `double` arithmetic (+/-/\*/÷/compare/conversions) | Works via softfloat |
| `(double)int` / `__floatsidf` | **Fixed** 2026-07-21 (ravn/llvm-z80#273) |
| POSIX fd-layer (open/read/write/close) | No-op stubs — intentional, same as sccz80/sdcc |

### Known gaps (documented, link fails)

| Function | Gap type | Reason |
|----------|----------|--------|
| `string.h` — `strerror` | **Fixed 2026-07-21** | `__strerror_table.asm` provides `__rodata_error_strings_head` + classic errno strings (1-16) |
| `stdlib.h` — `bsearch` | CLASSIC_DESIGN (XFAIL) | Standard `bsearch(key,base,nmemb,size,compar)` requires `midpoint*size` (a 16-bit multiply per iteration). Classic clib deliberately avoids this with `l_bsearch(key,base,n,cmp)` — a 2-byte-element-only variant that uses a bit-shift instead (2005 design choice, documented in `Lbsearch.asm`). Newlib target has the full 5-arg version via `l_mulu_16_16x16`. Documented XFAIL test: `z88dk/test/clang/xfail_bsearch.{c,sh}`. |
| `stdio.h` — `tmpfile` | CLASSIC_DESIGN (XFAIL) | CP/M has no temp-file primitives; `tmpfile()` is deliberately absent from `+cpm` stdio.h across all compilers. Documented XFAIL test: `z88dk/test/clang/xfail_tmpfile.{c,sh}`. |
| `stdio.h` — `vprintf`/`vsnprintf` | **Works** | `vprintf` is a macro → `vfprintf` (bridged); `vsnprintf` is bridged (`__LLVMZ80` `__smallc`).  Both verified: `vprintf("%d %s",…)`→`7 ok`, `vsnprintf`→`ret=3 [3-4]`.  Earlier survey `LINK_ERROR` was a bad probe (macro / uninit va_list), now fixed. |
| `math.h` — sqrt/sin/cos/exp/log/atan/pow/fabs/floor/ceil | NO_LIBM | Berkeley SoftFloat provides f64 arithmetic but not transcendental functions |
| User-supplied variadic functions with `va_start` | **Fixed** | ravn/z88dk `bb914a18` defers to `__builtin_va_start`; `vsum(3,10,20,30)=60` verified (ravn/llvm-z80#270 closed) |
| `printf("%f")` | **Fixed 2026-07-22** | nanoprintf-backed printf family in `llvmz80-softfloat/src/npf_printf.c`, packaged in `softfloat_cpm_z80.lib`.  `__llvmz80_printf/fprintf/sprintf/snprintf` give correct IEEE-754 `%f` (and all specifiers) — byte-identical to glibc (`tests/ft_printf`).  Unblocked by fixing a clang-z80 jump-table off-by-one that made nanoprintf's `%x` fail (`llvm-z80/tasks/bug-jumptable-upper-bound-offbyone.md`).  Stock z88dk `printf` still formats math48, so route via the shim for `double` output. |

---

## 2. Calling convention

clang-z80 uses `sdcccall(1)` by default (register passing: arg1→HL, arg2→DE,
return in DE for 16-bit / A for 8-bit).  This differs from both sccz80
(`__smallc`, all-stack) and classic sdcc.  The bridge layer in
`libsrc/l/llvmz80/` and the `__ZPROTO` macro in `include/sys/proto.h` handle
the translation transparently for bridged functions.

Key conventions for anyone writing a new bridge:

- **16-bit return**: must land in **DE** (not HL); bridge ends `ex de,hl / ret`.
- **Stacked-arg cleanup**: callee-cleans for `int`/`ptr` return; caller-cleans
  for `long` return.  Getting this backwards silently corrupts SP.
- **Variadic functions** (`printf` etc.): must be declared `__smallc` (i.e.
  `sdcccall(0)`) so clang reads the return value from HL; the `__vasmallc`
  macro now expands to `__smallc` under `__LLVMZ80` (ravn/z88dk#31 fix).
- **`__z88dk_fastcall` and `__z88dk_callee`**: are no-ops for llvmz80; do not
  rely on them for clang-specific fast-call behaviour.

Full reference: `libsrc/l/llvmz80/CALLING_CONVENTION.md`.

---

## 3. Classic library vs new library — why the bridge layer exists

z88dk ships two distinct library architectures that serve different compiler
and target combinations:

**Classic clib** (`+cpm`, `+zx`, etc.) is the original z88dk library, compiled
once per CPU target and stored as pre-built object archives (`z80_crt0.lib`,
`cpm_clib.lib`).  It is what `zcc +cpm` links, regardless of compiler.  The
classic clib was designed for **sccz80** (z88dk's own compiler) whose functions
receive all arguments from the stack (`__smallc` / `sdcccall(0)` convention)
and return 16-bit results in HL.

**New library** (newlib, `+embedded`, `+cpm` with `-clib=new`) is a separate
architecture built differently per compiler sub-variant.  It is not discussed
further here; llvmz80 currently only targets the classic clib.

### The ABI gap and how the bridge layer closes it

llvmz80 (clang-z80) uses `sdcccall(1)` by default: the first two 16-bit
arguments arrive in HL and DE, further arguments are stacked, and 16-bit
results land in DE, not HL.  The classic clib workers expect the **opposite**:
all arguments on the stack, result in HL.

Without adaptation, calling, say, `strcpy(dst, src)` from clang-compiled code
would pass `dst` in HL and `src` in DE, but the classic `_strcpy` worker would
read both from the stack and find only the saved return address — producing
garbage or a hang.

Three mechanisms close this gap transparently:

1. **`__ZPROTO` macros** (`include/sys/proto.h`).  For 2- and 3-argument
   functions the header declares a reversed-argument low-level entry point
   (`__strcpy`, `__itoa`) and wraps it in an `always_inline` forwarder that
   reorders the arguments.  clang sees a normal declaration; the low-level
   symbol becomes `___strcpy` / `___itoa` in the object file.

2. **Register-ABI bridge stubs** (`libsrc/l/llvmz80/*.asm`).  Hand-written
   assembly adapters export the `___X` names, reorder or stack-massage the
   incoming register arguments, call the underlying classic worker
   (`asm_strcpy`, `asm_itoa`, …), and return the result in DE.  These stubs
   are assembled into `z80_crt0.lib` at library build time.

3. **`_fastcall` variants**.  Single-argument classic functions (strlen, atoi,
   toupper, …) already have a `_fastcall` variant that reads the argument from
   HL — exactly where llvmz80 places it.  The header simply `#define`s the
   plain name to the fastcall variant under `__LLVMZ80`, requiring no asm stub.

### Consequence for the "Known gaps" table

A function **links** only if all three of the following hold:
(a) its header declares it correctly for llvmz80 (via `__ZPROTO` or a
`__LLVMZ80`-guarded `#define`),
(b) the required bridge stub or fastcall worker is present in `z80_crt0.lib` or
`cpm_clib.lib`, and
(c) any internal helpers the stub calls (e.g. `asm_itoa`, `l_divs_16_16x16`)
are also present.

`strerror` fails condition (c) — the error-string table
`__rodata_error_strings_head` is absent from the CP/M classic clib build.
`bsearch` and `tmpfile` fail condition (a) — they are not declared in z88dk's
CP/M `stdlib.h`.  The entire `math.h` transcendental family fails condition (b)
— Berkeley SoftFloat provides arithmetic but not sin/cos/sqrt/exp/log.

---

## 4. Code quality versus zsdcc

On production Z80 firmware (RC702 CP/M BIOS, two PROMs), llvmz80 consistently
produces **smaller** code than zsdcc:

| Target | llvmz80 | zsdcc | delta |
|--------|---------|-------|-------|
| CP/M BIOS (rcbios-in-c) | 5 462 B | 6 091 B | **−629 B (−10.3 %)** |
| Boot PROM / autoload (1-stage loader) | 1 643 B / 2 048 B cap | 4 KB (MAME-only) | — |
| CP/NOS slave PROM (cpnos-in-c) | 2 014 B / 2 048 B cap | 2 151 B | **−137 B (−6.4 %)** |

The wins are systematic and come from the middle-end optimiser (clang can
constant-fold, inline, and DCE across translation units) rather than from a
single trick.  zsdcc typically wins only on individual tight loops that dcc's
codegen was hand-tuned for (see §5 below).

---

## 5. Code quality versus dcc — the DCC benchmark suite

dcc (gloveboxes/dcc, github.com/gloveboxes/dcc) is a C89 compiler targeting
CP/M 2.2 on Z80.  It generates `.MAC` assembly, uses a dedicated peephole
optimizer (`dccpeep`), and ships a hand-written Z80 runtime (`DCCRTL.MAC`).
The four benchmark programs (`sieve`, `e`, `ttt`, `tm`) ship with its test
suite and are a useful ceiling to measure against because the compiler's
peephole pass + runtime are hand-tuned for CP/M Z80.

All measurements use `zcc +cpm -compiler=llvmz80 -O2` (best opt level for each
benchmark) and `z88dk-ticks` (cycle-accurate Z80 emulation) for fairness.

| Benchmark | llvmz80 | dcc | ratio | best opt level |
|-----------|---------|-----|-------|----------------|
| **sieve** (Eratosthenes, pointer-walk) | 27 464 244 | 27 979 152 | **0.98× — clang WINS** | `-O2` |
| **e** (`int a[]`, e-digits) | 30 455 092 | 25 381 975 | 1.20× slower | `-O2` |
| **e** (`uint8_t a[]`) | 28 959 111 | 25 381 975 | **1.14× slower** | `-O2` |
| **ttt** (minimax game tree) | 7 604 026 | 6 346 956 | 1.20× slower | `-O3` |
| **tm** (malloc stress-test) | 272 275 536 | 79 435 464 | 3.4× slower | any |

**tm** is allocator-bound: dcc links its own specialised allocator tuned for
this workload, while z88dk supplies a general-purpose heap.  tm is not a
meaningful compiler-quality signal; it measures the runtime library, not the
codegen.

### Why sieve wins

The `Z80LoopInstrFormPrep` pass (ravn/llvm-z80#250) rewrites integer-IV array
loops into pointer-walk form (`ld hl,base; add hl,stride` once → pointer PHI
with `add hl,prime` per iteration).  This exactly matches dcc's hand-generated
pointer walk and closes the gap entirely at `-O2`.

### Why `e` is 1.14–1.20× slower

The root cause is **type width**, not the algorithm.  dcc treats the
accumulator array `a[]` as byte-sized (regardless of the C `int` declaration)
because the digit values fit in `uint8_t`; clang correctly respects the
declared `int` width.

Changing the source to `uint8_t a[DIGITS_TO_FIND]` reduces the gap from 1.20×
to 1.14× (measured).  The remaining 3.6M T-state gap is almost entirely
**BSS round-trips for the loop-carried scalars `n`, `x`, and `x/n`**: because
`___divhi3` clobbers all three GP register pairs, clang spills these to BSS
before the call and reloads after, while dcc keeps them in the IX frame and
uses 8-bit loop counter register `C`.  Eliminating those round-trips via
PUSH/POP would close most of the residual gap but is not yet implemented.

### Why ttt is 1.20× slower

At `-O3`, LLVM unrolls the fixed-trip inner `for (p=0;p<9;p++)` loop inside
the recursive `MinMax` function, which is the only significant lever.  The
residual 1.20× gap is IX-frame recursive-call overhead (same M2 class as `e`).
No Z80-specific backend change is needed for ttt; the recommendation is simply
to use `-O3` for recursion-heavy code with small fixed-count inner loops.

---

## 6. Floating-point runtime — libm status

clang lowers every `double` operation to IEEE-754 compiler-rt libcalls
(`__adddf3`, `__muldf3`, `__floatsidf`, etc.).  z88dk's classic clib uses its
own 48-bit MBF/math48 format, which is **incompatible** with IEEE-754 `double`.
The ravn/llvm-z80 project therefore ships a separate archive:

```
softfloat_cpm_z80.lib    # Berkeley SoftFloat f64 + compiler-rt shims + i64 runtime
```

Auto-linked via the env var `LLVMZ80RTLIB` (no `.lib` suffix).  Integer-only
programs that never touch `double` link byte-identically with or without the
archive set.

### Why `printf("%f")` needs nanoprintf, not z88dk's own float printf

This is the crux of the `double`-output story and worth spelling out for z88dk
maintainers, because the intuitive fix ("just enable float printf") does not
work.

**The two float formats are incompatible at the byte level.**  clang-z80
lowers `double` to **IEEE-754 binary64** (8 bytes) — the format LLVM's
compiler-rt and the C standard mandate.  z88dk's classic clib float printf
(`__printf_handle_f` → `__dtoa__` → `asm_fpclassify`/`__dtoa_base10`, enabled by
linking a `--math*` library) is built for z88dk's **math48** (or math32)
software float.  When a clang-compiled `printf("%f", x)` reaches z88dk's float
handler, the handler reads the 8 IEEE bytes as if they were math48 and prints
garbage (`printf("%.2f", 3.14)` → `val=f`).  So z88dk's own printf **cannot** be
reused for clang's doubles; something that decodes IEEE-754 is required.

**Writing an IEEE-754 `dtoa` in Z80 assembly was rejected.**  A correct
double→decimal conversion (rounding, denormals, shortest/fixed digit
generation) is a large, subtle routine — exactly what z88dk's math libraries
already are, but for the wrong format.  Adding an IEEE variant into z88dk's
shared classic printf would also mean surgery in core code used by every target
and compiler, plus link-order/override plumbing (the classic clib is built once
and shared; float format is selected at the user's link via `CLIB_*_FLOATS`
constants).  High risk for a single compiler's benefit.

**nanoprintf (0BSD/Unlicense) is the right adapter.**  It ships a self-contained
IEEE-754-reading `ftoa` in pure C that decodes the raw double bits directly,
with no dependency on z88dk's math libraries.  It was validated byte-identical
to glibc across 50 `%f` cases (`llvmz80-softfloat/tests/ft_fmt`).  Because it
also formats every other specifier (`%d/%s/%x/%c/%o/%u/…`), a single
nanoprintf-backed printf covers the whole family consistently instead of
patching only `%f`.  The shim (`llvmz80-softfloat/src/npf_printf.c`) reuses
z88dk's own console/`FILE*` output (`putchar` for the console, `fputc` for real
streams) and only replaces the *formatting*; it is packaged as a library module
in `softfloat_cpm_z80.lib`, so a program pays for it only if it references
`__llvmz80_printf`/`fprintf`/`sprintf`/`snprintf`.

**A prerequisite backend fix fell out of this.**  nanoprintf's conversion parser
tripped a real clang-z80 codegen bug — a jump-table upper-bound off-by-one that
routed the maximum case value (`'x'`, the highest conversion char) to the
default block at `-O1+`, so `%x` silently failed.  Root-caused and fixed in the
backend (`Z80LateOptimization`'s `cp` narrowing used `cp Range` instead of
`cp Range+1`); it also corrected a latent miscompile in the production RC702
BIOS (`_specc`'s `erase_to_eos` escape).  See
`llvm-z80/tasks/bug-jumptable-upper-bound-offbyone.md`.

In short: **nanoprintf is the bridge between clang's IEEE-754 `double` and a
correct decimal string, without touching z88dk's math48-based core printf.**

### Transcendental functions (sin, cos, sqrt, exp, log, atan) — closed as known gap

**No libm, not planned.**  Berkeley SoftFloat provides the four basic
arithmetic operations and all conversions but no mathematical functions.
`math.h` symbols (`sqrt`, `sin`, `cos`, `exp`, `log`, `atan`, `pow`, `fabs`,
`floor`, `ceil`) will produce a link error for all three compilers; this is a
fundamental gap in the `+cpm` classic clib, not specific to llvmz80.

Porting a transcendental library to IEEE-754 `double` on Z80 (e.g. a
Berkeley-SoftFloat-based libm or a fixed-point approximation) is a
substantial standalone project.  Whetstone is therefore not feasible.
This gap is closed as **WONT_FIX_NOW**; revisit only if a production
workload requires trigonometric or exponential functions.

### Dhrystone

Dhrystone is **integer-only** and uses no floating-point arithmetic.  It links
and runs correctly under `zcc +cpm -compiler=llvmz80` today.  Its binary fits
comfortably within the CP/M TPA (Transient Program Area, ≈54 KB on a standard
64 KB system).

### Whetstone

Whetstone uses `double` arithmetic and calls transcendental functions
(`sin`, `cos`, `sqrt`, `exp`, `log`, `atan`).  It cannot run today under
`-compiler=llvmz80` for two independent reasons:

1. **Missing libm**: the transcendental functions are not in `softfloat_cpm_z80.lib`.
2. **Binary size**: even if libm were supplied, the Berkeley SoftFloat runtime
   is large enough (≈8–12 KB of code) that a Whetstone binary with z88dk
   runtime, the softfloat closure, and a libm closure would exceed the CP/M TPA.

Dhrystone is the appropriate integer-only benchmark for now; Whetstone is
blocked on (1) a libm port to Berkeley-SoftFloat double semantics and (2)
verifying the resulting binary fits in TPA.

---

## 7. Pragmatic recommendations

| Area | Recommendation |
|------|----------------|
| New CP/M program, integer-only | `zcc +cpm -compiler=llvmz80 -O2` is a good choice; printf/scanf/malloc/stdio all work |
| New CP/M program, `double` arithmetic | Set `LLVMZ80RTLIB`; avoid transcendental functions until libm is ported |
| Code size vs zsdcc | Prefer llvmz80; it is 6–10 % smaller on non-trivial programs |
| Speed vs dcc | sieve-shaped pointer-walk loops: llvmz80 wins; BSS-heavy scalar loops with function calls: llvmz80 lags |
| Writing a new clib bridge | Follow CALLING_CONVENTION.md; prefer `__smallc __asm__("worker")` annotation over hand-asm trampolines |
| Whetstone | Not feasible today; track ravn/llvm-z80 libm work |
| Dhrystone | Works today |

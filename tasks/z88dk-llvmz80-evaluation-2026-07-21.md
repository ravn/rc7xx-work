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
(via the separate softfloat runtime; see §4).  The z88dk clib bridge is
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
| `string.h` — `strerror` | LINK_ERROR | Missing error-string table `__rodata_error_strings_head` in z80 CP/M clib |
| `stdlib.h` — `bsearch` | NOT_DECLARED | Not declared in z88dk CP/M `stdlib.h` (use `qsort` + linear search) |
| `stdio.h` — `tmpfile` | NOT_DECLARED | Not in z88dk CP/M `stdio.h`; no temp files on CP/M |
| `stdio.h` — `vprintf` | LINK_ERROR | Needs `<stdarg.h>` va_list; the bridge exists but variadic entry is `vfprintf` |
| `math.h` — sqrt/sin/cos/exp/log/atan/pow/fabs/floor/ceil | NO_LIBM | Berkeley SoftFloat provides f64 arithmetic but not transcendental functions |
| User-supplied variadic functions with `va_start` | BROKEN | ravn/llvm-z80#270 — affects nanoprintf's own `va_start`; z88dk's v\* forwarding unaffected |
| `printf("%f")` | NO_FORMAT | Needs separate nanoprintf closure (`build_fmt.sh`); z88dk `printf` cannot format `double` |

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

## 3. Code quality versus zsdcc

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
codegen was hand-tuned for (see §4 below).

---

## 4. Code quality versus dcc — the DCC benchmark suite

dcc (Dave Dunfield's C compiler, 1986) was designed specifically for CP/M Z80
and produces hand-quality code for the four standard benchmarks.  This makes it
a useful ceiling to measure against.

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

## 5. Floating-point runtime — libm status

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

### Transcendental functions (sin, cos, sqrt, exp, log, atan)

**Not yet supplied.**  Berkeley SoftFloat provides the four basic operations
and conversions but not the mathematical functions.  A program that calls these
— including the Whetstone benchmark — will fail to link unless a compatible
`libm` is added.

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

## 6. Pragmatic recommendations

| Area | Recommendation |
|------|----------------|
| New CP/M program, integer-only | `zcc +cpm -compiler=llvmz80 -O2` is a good choice; printf/scanf/malloc/stdio all work |
| New CP/M program, `double` arithmetic | Set `LLVMZ80RTLIB`; avoid transcendental functions until libm is ported |
| Code size vs zsdcc | Prefer llvmz80; it is 6–10 % smaller on non-trivial programs |
| Speed vs dcc | sieve-shaped pointer-walk loops: llvmz80 wins; BSS-heavy scalar loops with function calls: llvmz80 lags |
| Writing a new clib bridge | Follow CALLING_CONVENTION.md; prefer `__smallc __asm__("worker")` annotation over hand-asm trampolines |
| Whetstone | Not feasible today; track ravn/llvm-z80 libm work |
| Dhrystone | Works today |

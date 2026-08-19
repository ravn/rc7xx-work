# Decision: owcc CP/M-86 benchmarks use owcc STANDARD runtime only — NO custom seams

**Date:** 2026-08-19. Standing decision by @ravn during the benchmark rewrite.

## The rule

All CP/M-86 benchmarks (and any owcc `-bcpm86` program) MUST build against the
**owcc standard runtime only**: `owcc -bcpm86` supplies `cstartcpm.obj` + the
standard `lib286/cpm86/clibs.lib`. There are to be **NO custom port seams** —
neither in a support library nor in the individual test sources:

- **Forbidden as build inputs:** `crt0`/`crt0sm.asm`, `cominit.c`, `stdioshim.c`,
  `lowlevel.c`, `stubs.c`, `errnoptr.c` — the whole hand-written runtime that
  `build-whetstone.sh`/`build-float.sh` used with their bespoke `wcc`+`wlink`
  builds. owcc's `cstartcpm.obj` already walks the XI/YI init/fini tables
  (`__InitRtns`/`__InitFiles`/`__full_io_exit`), so the manual `__setEFGfmt()`
  call and the seam objects are unnecessary and must not be linked.
- **Test sources stay plain C:** each benchmark is ordinary C compiled with
  `owcc -bcpm86 ...`; no `#include` of port shims, no port `.c`/`.asm` companions.

## Float support = ONE reusable library `cpm-soft-float.lib`

The only extra input a float-using benchmark may add is the single reusable
archive **`cpm-soft-float.lib`** (the name @ravn chose). It contains ONLY genuine
Watcom clib objects (no seams):

- `setefg`, `seterrno`, `rtcntrl`, `iobaddr`, `istable` (compiled from
  `bld/clib/{streamio,startup,char}/c/*.c` with `-bt=dos -0 -ms -zastd=c99 -zl -x`)
- `fpsoftstub.obj` (chip markers `__8087`/`__real87`/... = 0, from
  `watcom-cpm86-libc/port/fpsoftstub.asm` — the ONE allowed port asm, it is a pure
  "no-8087" constant table, not a runtime seam)
- `fltused.obj` copied from `bld/clib/startup/library/msdos.086/ms/fltused.obj`
  (resolves the compiler-emitted `_fltused_` marker; owcc `-msoft-float` otherwise
  auto-references a nonexistent cpm86 `maths.lib` → only a W1008 warning, harmless)
- all modules of the four **msdos.086** clib component libs merged in
  (`clib/{cgsupp,fpu,math,convert}/library/msdos.086/ms/clibs.lib`) — these carry
  `_EFG_Format_` / `__cnvs2d_` (the real %e/%f/%g formatter + strtod)
- all modules of **math286.lib** merged in (archive of
  `bld/mathlib/library/msdos.286/ms/*.obj`) — transcendentals + `efgfmt.c` +
  `strtod.c` + 80-bit `__LDcvt`. These are software-float, INT-21h-free, and
  contain no 286-only opcodes (they run on the RC759's 80186; keep the
  `assert_no_286`/`assert_no_8087` gates).

**Builder (canonical):** `contrib/ravn/mk-cpm-soft-float-lib.sh` produces
`contrib/ravn/cpm-soft-float.lib` (~280 KB). It sources `cpm86-clib/env.sh`,
compiles the support objects with the stock clib flags
(`-bt=dos -0 -ms -zastd=c99 -zl -x`), and builds a FRESH archive (member order
matters — an incremental `wlib +cominit` at the end breaks single-pass
resolution of setefg's `_EFG_Format_`/`__cnvs2d_` refs).

**THE key mechanism — the `__CommonInit` / `-DCOMMONINIT_EFG` override:** owcc's
standard startup `bld/clib/_cpm/a/cstartcpm.asm` calls `__CommonInit_`
(`bld/clib/_cpm/c/cominit.c`), which installs the real EFG formatter
(`__setEFGfmt()`) ONLY when compiled with `-DCOMMONINIT_EFG`. The stock
`clibs.lib` ships the no-EFG build, so a bare float printf emits NOTHING (the
noefgfmt stub stays). `cpm-soft-float.lib` therefore includes a `cominit.obj`
rebuilt WITH `-DCOMMONINIT_EFG`; being an explicit library it wins the
`__CommonInit_` resolution over the stock clibs.lib copy, and is pulled in ONLY
when a program links this library — so non-float programs keep the lean no-EFG
init. (The genuinely standard alternative — convert cstartcpm to the
`__InitRtns` XI/YI init-table walk so `AXIN(__setEFGfmt)` in `fltused.obj` fires
conditionally on `_fltused_` — was rejected for now: the installed cpm86
`clibs.lib` has no `__InitRtns`, so it would need rebuilding the canonical
runtime with `initrtns.obj`+`xiyi.obj`. `__InitFiles` IS already
`AXIN`-registered at `bld/clib/streamio/c/iob.c:57`, so that path is viable
later.)

Link a float benchmark with just:
`owcc -bcpm86 -mcmodel=s -msoft-float -O2 prog.c cpm-soft-float.lib -o PROG.CMD`
(`-msoft-float` = wcc `-fpc`; never `-fpi`/`-fpi87` — RC759 has no 8087).

**VERIFIED 2026-08-19 (Unicorn, full-speed):** `printf("%6.1f",3.5*2.0)` -> `   7.0`;
`%12.4e` of `sqrt(2.0)` -> `1.4142e+00`; `%8.5f` of `sin(1.0)` -> `0.84147`
(transcendental libm + %e/%f formatter all resolve on pure owcc standard runtime
+ this one library, zero port seams).

## Why (rationale from @ravn)

The bespoke crt0 + seam route was a proof-of-concept. The production posture is
that `owcc -bcpm86` is a real, native target; benchmarks must exercise that exact
standard path so the numbers reflect what a normal owcc user gets, and so there is
a single float closure to maintain instead of per-benchmark seam soup.

## Migration status (2026)

DONE + verified on owcc standard runtime:
- `contrib/ravn/bench.sh` (Dhrystone) -- MATCHes DR C oracle; O2 = 0.63x insns.
  `-DREG=register` matches the baseline's register-attribute self-report.
- `contrib/ravn/bench-mandel.sh` -- glyphs byte-identical to DR C oracle
  (only `\r\n` vs bare `\n` differs; user: line breaks don't matter for now).
- `cpm-soft-float.lib` + `mk-cpm-soft-float-lib.sh` -- %f/%e + sqrt/sin verified.
- `cpm86run_unicorn.py` -- block/virtual-clock hook gated behind counting so
  plain runs are full native speed ("unicorn skal koere fuld hastighed").

PARKED (user: "gem stdcbench for nu"):
- `watcom-cpm86-libc/build-stdcbench.sh` -- still the seam+wlink path. No
  baseline.json oracle; scored via emu2 (absent here). A faithful owcc rewrite
  needs a port + deterministic-scoring decision first. Banner added in-file.

OUT OF SCOPE (not a Watcom+DR-LINK-86 benchmark):
- `aztec-libc/scripts/build-mandel.sh` -- intentional cross-ABI experiment
  (Watcom wcc code linked against Aztec C's clib, run under emu2). Rewriting it
  to owcc would destroy its purpose.

OPEN (awaiting @ravn): rename `contrib/ravn/owc-drc/` (now that the DR-C-bridge
glue is dead) -- working name `bench-src/`; mixes tracked sources + untracked
fetched trees (dhry21/, stdcbench/src) + glue whose keep-vs-delete needs review.

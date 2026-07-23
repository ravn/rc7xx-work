# Plan: is it realistic to support newlib (`-clib=sdcc_ix/iy`) in llvmz80?

**Date:** 2026-07-22.  Follows `tasks/newlib-cpm-llvmz80-evaluation-2026-07-22.md`.
Question posed: is proper newlib support for clang-z80 realistic, and if so, what
is the plan?

## Verdict: REALISTIC — and much closer than the first evaluation implied

The deeper investigation overturned the "fragile sdcc-ABI coincidence" framing.
newlib works with clang-z80 because **clang-z80 already has first-class support
for the z88dk calling conventions** — this is our own prior work, not luck:

- `clang/include/clang/Basic/Specifiers.h` defines `CC_Z80SDCCCall0`,
  `CC_Z80FastCall`, `CC_Z80Callee` (+ default `sdcccall(1)`).
- `Attr.td` spellings `sdcccall`, `z80_fastcall`, `z80_callee`; lowering in
  `llvm/lib/Target/Z80/Z80CallLowering.cpp`.
- `include/sys/compiler.h` maps the z88dk keywords to those attributes for
  llvmz80: `__smallc→sdcccall(0)`, `__z88dk_callee→z80_callee`,
  `__z88dk_fastcall→z80_fastcall` (commit `bd115a7f60`), plus the variadic-return
  `__smallc` fix (ravn/z88dk#31, commit `21ff17f8b3`).

newlib is **designed multi-compiler** around exactly these conventions: every
public function is annotated `__SMALLC`/`__z88dk_callee`/`__z88dk_fastcall`/
`__preserves_regs(...)`, and provides `_callee`/`_fastcall` entry variants.  When
zcc drives clang it preprocesses with **`z88dk-ucpp -D__SDCC -D__SDCC_IX`** (the
sdcc masquerade), so newlib headers annotate each call with the right convention
and clang-z80 honors it.

### Empirical proof (all run in ntvcm, native macOS clang-z80)

| Case | Convention exercised | Result |
|------|----------------------|--------|
| `strlen` | `_fastcall` (arg in HL) | ✓ len=6 |
| `qsort(base,n,sz,cmp)` + callback | **`_callee`, 4 args, callee-clean, cross-ABI call into clang cmp** | ✓ `1 2 3 5 8 9` (disasm confirms all-stack push, no caller cleanup) |
| `printf`/`sprintf` | variadic `__smallc`, return in HL | ✓ incl. correct return values (native — no bridge) |
| `malloc`/`free`, `atoi`, str* | mixed | ✓ |
| `double` program (`3.0*2.0+1.5`) | clang IEEE libcalls + softfloat archive | ✓ links & runs (r=7); coexists with newlib |
| `-clib=sdcc_iy` full smoke | IY-reserved variant | ✓ all pass |
| Code size (hello) | — | **3289 B vs 7233 B classic (−55 %)** |

The `_callee` case is the decisive one: it proves the callee-clean convention is
applied correctly end-to-end, not bypassed.

### Bonus: the classic `ex de,hl` bridge layer disappears entirely

A second, independent argument for newlib.  The classic clib path
(`-clib=default`) needs a hand-written adapter layer, `libsrc/l/llvmz80/*.asm`
(`_fflush_fastcall`, `__itoa`, `__divhi3`, …), because its workers were built for
sccz80: arguments on the stack and 16-bit results returned in **HL**, while clang
passes arg1/arg2 in HL/DE and expects a 16-bit return in **DE**.  Every such call
therefore routes through a bridge object that reshuffles the args and ends
`ex de,hl / ret` to move HL→DE (and, per `fflush`, to fix stack-cleanup
mismatches).  These bridges exist precisely because the classic clib has *no*
`_fastcall`/`_callee` variant to route to.

newlib **ships native `_fastcall`/`_callee` entry variants** for every function,
built to the sdcc ABI that clang-z80 implements directly (`z80_fastcall`,
`z80_callee`, `sdcccall(0/1)`).  So clang calls the newlib entry with a matching
convention and the return register already agrees — no adapter, no ABI
`ex de,hl`.  Measured: **0 `ex de,hl` in the entire newlib smoke build**
(strcpy/strcat/strlen/malloc/free/snprintf/printf/atoi), and `strlen` even
tail-calls (`jp _strlen_fastcall`).  This is the same reason printf/sprintf
return values are correct *natively* on newlib, whereas classic needed the #31
fix.

Consequence for maintenance: the `libsrc/l/llvmz80/` bridge layer — a body of
hand-written, per-function Z80 asm that must be kept in lock-step with the
classic clib — is **not needed on the newlib path at all**.  (Caveat: clang may
still emit `ex de,hl` as ordinary intra-expression register shuffling; what goes
away is the *ABI-adapter* `ex de,hl` and the bridge objects themselves.)

## What is NOT yet done (the actual work)

1. **No sanctioned `cpm.cfg` route.**  Today you must abuse
   `-clib=sdcc_ix -compiler=llvmz80` (its config line forces `-compiler=sdcc`;
   the user override wins by argument order — undocumented, unsupported).  Need a
   clean variant, e.g. `-clib=newlib_ix` / `-clib=newlib_iy` with
   `-compiler=llvmz80`, or teach `-clib=new` to select the sdcc-ABI lib + llvmz80
   ABI when the compiler is llvmz80.

2. **Two divergent `sys/compiler.h`.**  Classic `include/sys/compiler.h` carries
   the llvmz80 keyword→attribute mapping; newlib
   `include/_DEVELOPMENT/common/sys/compiler.h` *strips* them under `__clang__`
   (commit `4720883486` made `__preserves_regs` a no-op just to parse).  It works
   today only because the ucpp `__SDCC` masquerade avoids the `__clang__` branch.
   This is accidental and brittle: the newlib compiler.h needs an **intentional
   llvmz80 path** mirroring the classic mapping, so the behavior is guaranteed,
   not a side effect of which `-D` ucpp happens to pass.

3. **`__preserves_regs` is a no-op for clang (201 sites) — the deepest risk.**
   newlib functions declare which registers they preserve; sdcc trusts that to
   keep live values in a preserved reg across a call.  For clang the macro is
   stripped, so clang falls back to its own convention's callee-saved set.  If a
   newlib worker preserves *fewer* registers than clang assumes, clang keeps a
   live value in a reg the worker clobbers → silent corruption.  Must verify
   clang-z80's callee-saved assumptions are a subset of what every pulled newlib
   worker actually preserves, or teach clang to honor `__preserves_regs`
   (a real per-call clobber set).  Smoke tests haven't hit it; a broad sweep
   might.

4. **`double`/`%f`.**  Arithmetic links (softfloat), but `printf("%f")` needs the
   same nanoprintf route we built for classic, re-plumbed against newlib's
   `FILE*`.  There is also a `types 'double' not supported. Assuming 'float'`
   warning from the newlib layer to run down (does clang still emit true IEEE
   binary64, or is something narrowing to 32-bit?).

5. **Variant choice: sdcc_ix vs sdcc_iy.**  clang-z80 reserves IY by default, so
   **sdcc_iy (IY-reserved) is the more principled match** — no risk of a newlib
   worker holding a value in IY that clang also uses.  sdcc_ix works in the smoke
   set but leaves IY in play on the newlib side.  Recommend standardizing on
   sdcc_iy and proving it.

6. **crt0 / startup.**  newlib `cpm_crt.asm.m4` assembles and runs, but validate
   stdio init, heap/`sbrk`, `atexit`, and `main` return path under clang codegen.

7. **`__attribute__((...))` breaks on the newlib preprocessing path.**  Found
   2026-07-22: any `__attribute__((noinline))` / GNU attribute makes the newlib
   build fail with `syntax error: token -> '(' ; column 15` (from the z88dk-ucpp
   `-D__SDCC` stage), even with normal includes — this is the real reason
   `runtime_intdiv` skips, not `__smallc`.  The *classic* path accepts the same
   attribute once a header is included.  Root cause is the divergent newlib
   `_DEVELOPMENT/common/sys/compiler.h` llvmz80 handling (same as #2/Phase C).
   This is broader than one test: a large class of real C won't compile until
   fixed.

8. **FILE\* I/O does not link on the newlib CP/M target.**  Found 2026-07-22:
   `fopen`/`fgets`/… fail at link with `undefined symbol: asm_target_open_p1 /
   asm_target_open_p2` (`newlib/fcntl/z80/asm_vopen.asm`) — the CP/M target-open
   primitives are not in the linked lib set.  The whole FILE\* layer (which
   *works* and is MAME-verified on classic) is currently unavailable on newlib
   until the right target lib/objects are pulled.  Needs investigation (missing
   `-l`, or the newlib cpm target isn't fully wired for this build).

9. **Zero test coverage in CI.**  Nothing exercises the newlib path; today's
   evidence is ad-hoc (now partly captured by the `TEST_CLIB=sdcc_iy` run of
   `test/clang`, but with 7 skips for the gaps above).

### Confirmed WORKING on newlib (2026-07-22 probes)
str/mem, malloc/calloc/free, atoi/strtol, printf/sprintf incl. **return values**
(native, no bridge), vaarg, fastcall ABI, and — cleanly, source avoiding the
broken tokens — **`bsearch` with a function-pointer callback** (the `_callee`
convention + cross-ABI callback end-to-end: `found=11 idx=5`).  `long` divmod
would work too but is blocked only by the `__attribute__` gap (#7), not by the
32-bit ABI.

## Phased plan

**Phase A — Decide scope & variant (cheap, do first).**
- Confirm sdcc_iy as the target variant (rerun the smoke + qsort/callback suite
  under `-clib=sdcc_iy`; already green once).  Pick ix vs iy definitively.
- Decide product shape: dedicated `-clib=newlib_iy` cfg line vs extending `new`.

**Phase B — ABI conformance sweep (the real correctness gate).**
- Build a test matrix hitting each convention class: `_fastcall` (1 arg),
  `_callee` (2–5 args incl. the sort/search family), variadic (`printf`/`scanf`
  return values), 32-bit args/returns (`long`), struct-by-value, function-pointer
  callbacks in both directions.
- **`__preserves_regs` audit**: for the functions the suite pulls, diff the
  registers each newlib worker actually preserves (from its `.asm`) against
  clang-z80's callee-saved set for that convention.  Any worker that preserves
  less than clang assumes is a bug class → either avoid, bridge, or make clang
  honor `__preserves_regs`.
- Run everything in ntvcm; a green sweep here is the go/no-go.

**Phase C — Header intent + cfg plumbing.**
- Give newlib `_DEVELOPMENT/common/sys/compiler.h` an explicit, documented
  llvmz80 branch (mirror the classic mapping) so the conventions are honored by
  design, not via the `__SDCC` masquerade side effect.
- Add the sanctioned `cpm.cfg` CLIB line(s) pairing newlib with
  `-compiler=llvmz80`.
- Confirm `LLVMZ80RTLIB` softfloat auto-link works in the newlib link order.

**Phase D — float/%f.**
- Resolve the `double→float` warning; confirm true IEEE binary64.
- Port the nanoprintf `%f` route to newlib `FILE*` (or document `%f` as a newlib
  gap, as classic did before the shim).

**Phase E — CI + docs.**
- Add a `z88dk/test/clang-newlib/` suite (mirror `test/clang/run_all.sh`) wired
  into the workspace aggregator `tasks/tools/run-all-tests.sh`.
- Update the eval doc + CALLING_CONVENTION.md with the supported newlib path.

## Recommendation

**Realistic, and the payoff is real (−55 % code size + native printf return
values).**  But it is a genuine multi-phase effort whose correctness gate is the
`__preserves_regs`/callee-saved audit (Phase B), not the plumbing.  It is **not
on the critical path** for the four finishing-firmware components (rcbios,
autoload, CP/NET, cpnos), which use classic/freestanding builds.

Suggested disposition: **do Phase A + Phase B now** (low cost, and Phase B either
green-lights everything or exposes the one class of latent bug that matters); gate
Phases C–E on a green Phase B and an actual consumer who wants the size win.
Standardize on **sdcc_iy**.  Keep classic (`-clib=default`) as the supported path
meanwhile.

## Phase A + B execution (2026-07-23)

**Phase A — DONE. Variant = sdcc_iy, smoke green.**  `run_matrix.sh classic
sdcc_iy` (LLVMZ80EXE build-macos, ntvcm): classic **22 PASS / 0 FAIL / 1 SKIP
(softfloat lib absent) / 2 XFAIL**; sdcc_iy **15 PASS / 0 FAIL / 9 SKIP / 1
XFAIL**.  The 9 sdcc_iy skips are the documented Phase B/C/D gaps.

**Plan correction to item #5 (sdcc_iy vs sdcc_ix).**  `cpm.cfg` line 23 shows the
`sdcc_iy` CLIB line links the **`sdcc_ix` archive** (`-L…/lib/sdcc_ix`, `-lcpm`)
and merely adds `--reserve-regs-iy` to *user*-code compilation.  There is only one
prebuilt newlib worker archive (sdcc_ix).  So choosing sdcc_iy does NOT yield an
IY-clean worker set — it gives IY-reserved user code linked against the same
IY-permitting workers.  This is still the right choice for clang (clang reserves
IY too, and the CALL opcode already lists IY in its clobber set), but the
*rationale* in #5 ("no newlib worker holds a value in IY") is wrong; the real
reason is user-side IY reservation matching clang's.

**Phase B — `__preserves_regs`/callee-saved audit: GO (for the exercised
surface).**  The audit collapses to a single register:

- clang-z80's only callee-saved GPR is **IX** (`Z80_CSR = (add IX)`); IY is
  *reserved* (never allocated); the CALL opcode's TableGen `Defs = [A, BC, DE,
  HL, IY, FLAGS]` means clang already assumes A/BC/DE/HL/IY are clobbered by any
  call.  A worker preserving *fewer* GPRs than it declares therefore cannot
  corrupt clang — clang keeps a live value across a call **only in IX**.  The
  entire risk is: does any *public* newlib entry point clang links clobber IX
  without restoring it?
- Method: built a representative binary (printf/malloc/atoi/ultoa/strtol,
  `-clib=sdcc_iy`), took the 134 linked modules from the `.map`, intersected with
  IX-touching `.asm` (44 modules), classified push/pop-ix balance.
- Result: **no public entry leaks IX.**  `_printf` = `push ix / call asm_printf /
  pop ix / ret`.  `_fflush_fastcall` = `push hl / ex (sp),ix / call / pop ix /
  ret` (the z88dk idiom: saves caller IX to stack *while* loading the FILE\* arg
  into IX).  Newlib's internal stdio/fcntl helpers hold `FILE*`/`FDSTRUCT*` in IX
  across `l_jpix`/`ex (sp),ix` fall-through chains, but those chains are entered
  only from within newlib and are always bracketed by the public shim's
  save/restore.  sdcc-compiled workers preserve IX by frame-pointer discipline.
- Caveat: this proves the **stdio/malloc/string/atoi** surface the matrix pulls.
  A full go/no-go still wants the same map-intersect audit run over a wider draw
  (long divmod, qsort/bsearch `_callee`, struct-by-value, FILE\*) once the Phase C
  compiler.h gap unblocks those tests from linking.  No IX-leak class found so
  far; empirical 15/15 PASS agrees.

## Phase C execution (2026-07-23) — DONE (core), one new gap found

**Landed the sanctioned clang newlib route + the header intent fix.**

1. **`sys/compiler.h` `__LLVMZ80` branch** (both `_DEVELOPMENT/proto` and
   `_DEVELOPMENT/common`): the `#if __clang__ | __CLANG` block now maps, under
   `__LLVMZ80` only, `__smallc → __attribute__((sdcccall(0)))`,
   `__z88dk_callee → z80_callee`, `__z88dk_fastcall → z80_fastcall`,
   `__vasmallc → __smallc`.  Gated on `__LLVMZ80` (not bare `__clang__`) so the
   ez80-clang oracle keeps the no-op mapping (`[[reference_clang_double_duty_ez80_llvmz80]]`).

2. **`cpm.cfg` `newlib_ix` / `newlib_iy` CLIB lines**: same sdcc_ix worker
   archive as sdcc_iy, but `-compiler=llvmz80` instead of `-compiler=sdcc`.  This
   is the real fix for the ucpp choke (#7): with `-compiler=llvmz80` there is NO
   `z88dk-ucpp -D__SDCC` pass — clang's own `-E` (with `-D__CLANG -D__LLVMZ80`)
   preprocesses the `_DEVELOPMENT` headers, so `__smallc`/`__attribute__((...))`
   sources compile.  (The sdcc_iy line forces `-compiler=sdcc`, which is what
   dragged in the ucpp pass that chokes on the `__smallc` keyword.)  No
   `--reserve-regs-iy`: clang reserves IY by default, so newlib_iy/newlib_ix
   differ only in marker.

**Validated (ntvcm, `-clib=newlib_iy`):** `runtime_attr` (#7 CLOSED),
`runtime_stdmisc`, `runtime_strerror`, `nontrivial_demo`, `runtime_vaarg` all now
PASS; a minimal `__smallc` qsort comparator sorts correctly
(`1 2 3 4 5 7 8 9`) — proving the sdcccall(0)/callee-clean cross-ABI callback is
correct end-to-end.  Matrix `classic newlib_iy`: **classic 22 PASS / 0 FAIL;
newlib_iy 18 PASS / 0 FAIL / 6 SKIP / 1 XFAIL** (was sdcc_iy 15 PASS / 9 SKIP —
strict improvement).  Harness: `run_matrix.sh` default → `classic newlib_iy`;
`run_all.sh` `newlib_skip_reason` made variant-aware (sanctioned newlib_* skips
only genuine gaps; unsupported sdcc_* keeps the broad source-feature skip set).
Also fixed a pre-existing `runtime_strerror.sh` harness bug (`$WORK/rt` →
`$WORK/rt.com`, matching the other tests; classic happened to produce a runnable
`rt`, newlib `-create-app` produces `rt.com` + a 0-byte `rt`).

**NEW GAP found — corrects the plan's "bridge disappears entirely" claim.**  The
*ABI-adapter* `ex de,hl` bridge does disappear on newlib, BUT clang still emits
gcc-style **integer helper libcalls** for runtime 16/32-bit mul/div/mod —
`__mulhi3`, `__umodhi3`, `__divsi3`, `__modsi3`, `__divmodsi4`,
`__udivmodsi4` — and **newlib has none of them**.  On classic they come from
`libsrc/l/llvmz80/__divhi3.asm` + `__divsi3.asm`, which are tied to classic-clib
build context (`config_private.inc` + `l_divs_32_32x32` / `l_mulu_16_16x16`
cores) and are NOT linkable into a `-nostdlib` newlib build.  This blocks
`runtime_qsort` (LCG mul/mod), `runtime_intdiv` (32-bit divmod), and
`runtime_long` (32-bit div/mod) on newlib_iy (all now SKIP with the accurate
"integer-helper gap" reason).  Note `runtime_long` PASSES on sdcc_iy only because
the `-D__SDCC` ucpp path routes long arithmetic to symbols that DO exist in the
newlib sdcc archive.  **This is the next blocker** — a distinct integer-runtime
provisioning task (provide self-contained `__mulhi3`/`__divsi3`/… for the newlib
route, or a newlib-context build of the llvmz80 integer bridge).  See
[[reference_newlib_integer_helper_gap]].

**Still open (unchanged):** FILE\* link (`asm_target_open_p1/p2`, plan #8);
`%f`/softfloat (`LLVMZ80RTLIB` auto-link is compiler-driven so it applies to
newlib_iy identically to classic, but the softfloat `.lib` must be built to run
`%f` — mechanism confirmed, not re-run here).

## Repro (current unsupported form)

```sh
export LLVMZ80EXE=.../build-macos/bin/clang ZCCCFG=.../z88dk/lib/config
export PATH=.../z88dk/bin:.../ntvcm:$PATH
zcc +cpm -clib=sdcc_iy -compiler=llvmz80 -O2 -create-app -o h hello.c && ntvcm h.com
```

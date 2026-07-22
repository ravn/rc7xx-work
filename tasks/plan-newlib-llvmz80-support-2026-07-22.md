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

7. **Zero test coverage in CI.**  Nothing exercises the newlib path; today's
   evidence is ad-hoc.

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

## Repro (current unsupported form)

```sh
export LLVMZ80EXE=.../build-macos/bin/clang ZCCCFG=.../z88dk/lib/config
export PATH=.../z88dk/bin:.../ntvcm:$PATH
zcc +cpm -clib=sdcc_iy -compiler=llvmz80 -O2 -create-app -o h hello.c && ntvcm h.com
```

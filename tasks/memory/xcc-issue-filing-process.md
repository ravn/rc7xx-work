---
name: xcc-issue-filing-process
description: How to reproduce, reduce, red-green validate, and file xcc (retro-vault/xyz) compiler bugs — repo facts, toolchain paths, test conventions, and the exact workflow that worked for PR #2
metadata:
  type: reference
---

# Filing xcc (XYZ Suite) compiler bugs — complete process

`xcc` is the Z80 C compiler in **retro-vault/xyz** (a ZX-Spectrum-48k OS +
toolchain monorepo, owner `tomaz stih`). We run it as the 5th oracle in the
compiler-comparison-corpus sweep. First bug filed this way: **retro-vault/xyz#2**
(global-pointer static-initializer dropped). Follow this end-to-end next time.

## Hard facts about the target repo (verified 2026-07-06)

- **Issues are DISABLED** on retro-vault/xyz (`gh issue create` → "repository has
  disabled issues"). **File bugs as a PR** whose body doubles as the bug report.
- We have **READ** permission only → must **fork** to `ravn/xyz` and PR from a
  branch there against `retro-vault/xyz:main`.
- Repo is large (~35k files): `x/` (toolchain: xcc/xas/xld/xar/xobjcopy/xgdb/xemu),
  `y/` (YOS), `z/` (GUI), plus `archive/`. A `--depth 1` clone is fine.
- License MIT, © tomaz stih. Default branch `main`.
- User rule: **cannot file upstream issues about sdcccall 0/1 discrepancies**
  (see feedback_no_upstream_sdcccall_discrepancies.md) — that's a separate,
  non-fileable class from genuine xcc codegen bugs like #2.

## Toolchain locations (macbook; sonnyboy sed-rewrites the prefix)

- xcc binary release: `/Users/ravn/z80/xyz-eval/xcc-current/bin/{xcc,xld,xemu,...}`
  (staged by `rc700-gensmedet/tasks/compiler-comparison-corpus/setup_xcc.sh`,
  which `gh release download`s from retro-vault/xyz).
- `xcc -S <opt> f.c -o f.s` emits SDCC-dialect asm — **the primary root-cause
  tool** (works with the binary release; no libc/link needed).
- Opt knobs: `-O0` (default), `-O1` peephole, `-O2`, `-O3` (experimental),
  `-Of` speed, `-Os` size. `--platform=emu --oformat=binary` builds a raw image;
  `xemu --run --load-bin a.bin --max-steps N` runs it and reports the exit code.
- **BETA GOTCHA:** libc is NOT auto-linked in the binary release, so `printf`
  fails to link (`xld: error: unresolved symbol '_printf'`). Prefer
  **return-code / memory-sentinel** reproducers over printf ones. (Their full
  source build links libc fine, so printf-based repros still work in their CI.)

## Reproduction / reduction harness (what worked)

To run an xcc program and read results without libc, wrap the `.rel` as a CP/M
`.COM` at 0x0100 with a tiny page-zero warm-boot + BDOS stub, then run in
z88dk-ticks (`$Z88DK/bin/z88dk-ticks`, `$Z88DK=/Users/ravn/z80/z88dk`):
`ticks -pc 100 -end 0 -counter 200000000 -output out.ram img` stops when PC
hits 0x0000 (main returned → warm boot). Read a sentinel the program writes to
a fixed RAM address (we used 0xC000, 16-bit LE words) from `out.ram`. Link line:
`xld --mode=sdcc -nostartfiles -T $XLIB/linker-cpm3.lk $XLIB/crt0-cpm3.rel
main.rel $XLIB/libc.a $XLIB/libruntime.a $XLIB/libcpm3.a --oformat=binary -o m.com`
(explicit lib list = the beta workaround; `$XLIB=xcc-current/z80/lib`).
This is exactly `build_xcc_corpus.sh`'s model — reuse it.

Reduction method that worked for #2: bisect by isolating each construct into a
standalone TU and probing intermediate values via the sentinel. Watch for the
tell that adding/removing volatile writes changes behavior → register-alloc /
liveness class (that was the *fannkuch* hang; still unroot-caused). The clean,
minimal bug (#2) fell out as a side observation: a global pointer sentinel read
back 0 while a global int read back correctly.

## Red-green validation (MANDATORY, per user's testing rules)

1. **RED via asm** (toolchain-independent, always runnable): show the wrong
   emission with `xcc -S` at EVERY opt level. For #2:
   `_g_iptr: .ds 2` (dropped init) vs `_g_int: .dw 4660` (correct). Confirm the
   use is a real memory load (`ld hl,(_g_iptr)`), not const-folded — else the
   bug isn't observable and the check could pass at -O.
2. **RED at runtime**: run the sentinel repro under xcc → wrong value / nonzero
   exit.
3. **GREEN reference**: compile the IDENTICAL source with a conforming compiler
   and show correct result. Two oracles we used:
   - z88dk zsdcc (`zcc +cpm -compiler=sdcc -O2 f.c -o z`) run in ticks.
   - **Docker gcc GREEN oracle** (portable, no Z80 toolchain — put this in the
     repro header + PR body so the maintainer can verify in one command):
     `docker run --rm -v "$PWD":/w -w /w gcc:13 sh -c 'gcc -w -O2 <path>.c -o /tmp/t && /tmp/t; echo exit=$?'`
     (`-w` silences the 64-bit pointer-size warning; the property under test —
     a global pointer initialized to a constant reads back that constant — is
     standard C, so any conforming compiler returns 0).

## Where the test goes — repo test conventions (verified by reading the runner)

- Active suite: `x/tests/tests/c23/cases/**/test.cfg`, run by the `xemutest`
  C++ runner (`x/tests/tools/xemutest`), driven by `x/tests/run_tests.sh`.
  `discover_tests()` **recursively** finds any dir containing `test.cfg`
  (main.cpp ~820) — no central manifest to edit.
- `test.cfg` keys the runner understands: `id, component, summary, tag, alias,
  legacypath, source, compilerarg, hostarg, command, commandarg, workdir,
  expectcompile(success|failure), hostgolden, stderr[not]contains,
  asm[not]contains, stdin, stdout, expectexit, maxsteps, timeoutseconds,
  origin, pc, sp, platform, floatpresent, debugsymbols, matrixopt, matrixfloat,
  stdin*port, stdoutport, assertreg, assertmem, assertvar`.
  - `kind = run` verifies program exit vs `expectexit` (default 0) and/or
    stdout; `kind = compile` verifies `expectcompile`.
  - Exec tests self-check via `x/tests/tests/c23/xcc/data/exec/include/xcc_exec_test.h`
    macros `XCC_CHECK_EQ_INT_ID(id, actual, expected)` etc. → `main` returns 0
    on pass, the failing id otherwise. Sources live in
    `x/tests/tests/c23/xcc/data/exec/**`, cases reference them via `source = ...`.
    A sibling `.levels` file (O0/O1/O2/O3/Of/Os) pins opt coverage.
- **There is NO xfail / skip / ignore / known-fail / quarantine mechanism.**
  Tags only feed `--filter` (substring match on id/alias/tag/path/component);
  they do NOT gate whether a test runs. A discovered failing `cases/` test just
  reports `FAIL`. (Confirmed by reading main.cpp + repo-wide grep.)
- **"Red but ignored" convention = `x/tests/repro/`** — standalone documented
  miscompile reproducers that live OUTSIDE `cases/`, so `discover_tests()` never
  runs them (they don't break the suite). Precedent: `long_bigframe_miscompile.c`
  (header comment: symptom / build / run / expected / actual). **This is where a
  known-failing bug repro belongs** unless/until the maintainer wants it gated.
  #2 used this: `x/tests/repro/global_pointer_init_miscompile.c`.
- CI: only `.github/workflows/release.yml` exists — **no CI runs the tests**, so
  a repro/ file is purely documentary until a maintainer wires it in.

## Exact filing workflow (repeat this)

1. `gh repo fork retro-vault/xyz --clone=false`; `git clone --depth 1
   https://github.com/ravn/xyz.git xyz-fork`.
2. `git checkout -b <topic>`; add the repro under `x/tests/repro/<name>.c`
   (self-checking, return-code based, header documents symptom + asm evidence +
   xcc build/run + the docker GREEN command). **No fix** unless asked (user rule:
   file bugs, not fixes; maintainer decides the fix).
3. Verify RED (`xcc -S` + runtime) and GREEN (docker gcc) end-to-end BEFORE
   pushing — never assert an unconfirmed mechanism/count (user's upstream
   diligence rule).
4. Commit (include `Co-authored-by: Copilot`), push to the fork branch.
5. Since issues are disabled: `gh pr create --repo retro-vault/xyz --base main
   --head ravn:<topic> --title ... --body-file body.md`. Write the PR body as
   **long flowing lines** (GitHub hard-wraps single newlines) with: summary,
   current vs expected, root-cause asm evidence, what the PR adds, how to
   reproduce, GREEN oracle.
6. Get explicit per-filing go-ahead first (feedback_explain_before_filing) — but
   note issues against ravn's OWN repos need no permission; retro-vault/xyz is
   third-party so it DOES need go-ahead. The user gave it for #2.

## Still-open xcc work (not yet filed)

- **fannkuch miscompile**: `fannkuchredux(7)` never returns under xcc (infinite
  loop), all opt levels. Each construct works in isolation; adding/removing
  volatile writes flips termination → register-alloc/liveness class. NOT reduced
  to a one-liner, NOT filed. Would need reading the full-function -O0 asm.

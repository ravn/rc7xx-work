# Bring the local z88dk integration up to upstream

Execution is proceeding in an isolated worktree. Test and build scripts use
temporary directories under `/Users/ravn/z80/scratch/tmp`, as authorised by
the user; set `TMPDIR` there for all commands that need temporary files.

## Verified endpoints

- Local HEAD: `680664d950741a45a4a34dec159330eb04a1207e`.
- Fetched upstream master: `02ce61be8d51f271f6d133b88698fba1954af2c2`.
- Merge base: `687c8e22e92ad71dd10c5ffcefcb344dfe4b7a0f`.
- Local-only history: 20 commits. Upstream-only history: 116 commits.
- `git cherry` marks all 20 as non-equivalent patches. This does not mean
  all 20 still provide unique functionality.
- Dirty state: run_minimal.sh executable mode and generated files in
  ext/regex. Preserve these separately rather than absorbing them blindly.

The current built z88dk integration passes against clean LLVM-Z80 PR #112
at `042a1d7`: 30 runtime executions and 24 memory emission checks pass.
This is a useful control, not validation of freshly rebuilt latest z88dk.
The existing zcc binary's version banner does not identify its exact source.

## Analysis of all 20 local commits

| Commit | Contribution | Disposition on latest upstream |
|---|---|---|
| afb5a8f248 | Smoke test updated for smallc default | Keep intent in consolidated tests. |
| 55b1497529 | Minimal runner and varargs tests updated for new ABI | Keep tests. Correct outdated variadic commentary only after checking the actual ABI. |
| 126ec36e55 | Enable ZPROTO, route qsort/bsearch to bare entries, force ixiy, disable builtins | Keep header behavior. Do not replay obsolete driver workarounds. |
| e17111d8fc | Re-enable builtins and explain sort/search routing | Preserve builtin behavior and routing rationale. |
| cdaffea299 | Restrict forced ixiy to targets offering it | Drop: later commit removes the ixiy override altogether. |
| 64adcdafb1 | Broaden header ABI tests | Keep effective final tests rather than historical intermediate file. |
| 9ceed2a1b5 | Remove redundant printf pragma | Preserve final test state. No independent production patch needed. |
| 27abd6a450 | Memory runtime tests | Keep. |
| 6d46905fab | 32-bit integer runtime tests | Keep. |
| 5954e965e7 | 8/16-bit integer runtime tests | Keep. |
| ac4ad6ecb9 | String library runtime tests | Keep. |
| 40fe78e9ad | Document missing 64-bit test coverage | Review against final multiply test. Do not assume all 64-bit operations are covered. |
| 7bfb518fba | Header and synthesized memory-operation tests | Keep both paths distinct. |
| 90ee57c3f7 | Memory codegen checks | Keep intent. Broad old/new symbol alternatives need contract-based review. |
| 6a6c038c36 | Canonical master test runner | Keep portable intent. Required missing scripts must not silently count as success. |
| 7c32d43846 | Replace ntvcm dependency with z88dk-ticks | Keep. Rebuild ticks from the new source. |
| 09036dd3a3 | qsort/bsearch callback hardening | Keep. |
| a561d15208 | Link compiler-rt supplement instead of forcing ixiy | Keep requirement. Review discovery, compile-only use and linking order. |
| dcab3c0087 | Document symbol arguments in ticks help | Do not reapply blindly: upstream 3d5f81ff5a implements the same feature description. |
| 680664d950 | Multiply runtime coverage | Keep. It passes on clean #112 without the local compiler patches. |

The functional local net delta from the merge base is:

1. `include/sys/compiler.h`: LLVMZ80 keeps native attributes and enables
   ZPROTO by not defining STDC_ABI_ONLY for this frontend.
2. `include/stdlib.h`: qsort/bsearch use explicit bare assembly names for
   the smallc library entries and their callback thunks.
3. `src/zcc/zcc.c`: discover and link z80_z88dk_rt.lib.
4. Test additions and updates.
5. Ticks help text, now semantically represented upstream.

The initial forced ixiy and blanket no-builtin flags are absent from the
final local driver delta. Replaying intermediate commits can temporarily
restore incorrect behavior and create unnecessary conflict resolution.
Prefer the final minimal changes above, with traced provenance.

## Relevant upstream overlap

The upstream change `3d5f81ff5a` documents ticks symbol-name options.
It is not patch-equivalent according to git cherry, so semantic comparison
is necessary. Keep upstream's modern ticks implementation and help.

The upstream driver change `a11376a6f5` preserves spaces in input filenames.
Another driver change, `ca2e00ba34`, changes debug temporary-name handling.
Preserve both. Add space-containing path coverage for the integration.

Ticks has new Lua I/O, timer and model facilities. Build dependencies differ
from the old tree. Do not transplant the old ticks file or binary.
Inspect current build manifests before restoring or installing dependencies.

Newlib has IX-preservation updates, including `85a7d780cf`, `26bd6f140a`
and `ac3c9583ff`. They are relevant to later newlib validation but do not
establish classic CP/M ABI compatibility. Other target changes should remain
upstream's, not become a reason for a broad header rewrite.

The upstream tree already has LLVMZ80 support beneath these 20 commits.
We are updating an existing integration, not adding the backend from scratch.

## Risks that require checks, not assumed fixes

- Supplement discovery currently uses environment variables for its compiler
  path fallback. Verify configured compiler names and PATH-based selection.
- An explicitly supplied invalid supplement directory falls back to the
  compiler-derived directory. Decide whether that matches intended semantics
  before changing it.
- Discovery currently happens early in zcc. Verify preprocess-only and
  compile-only behavior and whether they should require the runtime archive.
- The variable called linker_linklib_first does not by itself prove correct
  archive ordering. Inspect the actual link command and selected symbols.
- R2L macros can select header wrappers, even though ordinary compiler C calls
  use smallc. Do not remove them globally.
- Existing codegen tests accept multiple runtime names. Determine which are
  intentional under #112 before tightening assertions.
- A passing multiply fixture on clean #112 does not establish a need for the
  four local compiler commits. Keep the #112+#114 investigation separate.

## Update sequence

### 1. Preserve and measure the existing state

Record local refs, dirty files and artifact hashes. Keep the passing
clean-#112 integration log at scratch/tmp/z88dk-pr112-tests-20261101.log.
Read current z88dk AGENTS and the applicable build/library/style skills.
Create an isolated update worktree based on the pinned upstream revision.
Do not reset, switch or clean the existing development tree.

Gate: upstream base is exact and existing work is preserved.

### 2. Reconstruct the small integration delta

Apply the final compiler.h and stdlib.h behavior and supplement support in
small coherent units. Bring over the final integration tests.
Do not copy entire upstream files or replay all 20 commits indiscriminately.
Drop obsolete ixiy/no-builtin transitions and the duplicate ticks help patch.
Keep upstream changes when resolving overlap.

Gate: minimal reviewed diff with explicit provenance for retained behavior.

### 3. Build coherent latest-z88dk artifacts

Use the isolated tree's documented build targets and ccache where applicable.
Build the required host tools and classic CP/M library products from that
same source. Keep LLVM-Z80 fixed at the already verified clean #112 compiler
and supplement for this comparison.

Check real compiler, assembler, CRT/library and ticks paths. Capture hashes,
versions and actual commands. Do not allow configuration to point into the
old z88dk tree. Use generated artifacts from the new tree, not copied archives.

Gate: an end-to-end source/path provenance record, including libraries.

### 4. Validate the update

Run the existing three integration groups: all 30 runtime executions and
24 memory codegen checks must execute, not silently skip.
Compare with the old-tree baseline. For differences, first compare generated
assembly, linked symbols and artifacts, then localize the changed layer.

Add focused driver tests where existing tests omit supplement discovery,
paths with spaces or compile-only behavior. Any production fix requires a
test observed to fail before its implementation.

Run relevant existing driver/header/library regressions for touched behavior.
Use SDCC and sccz80 as positive controls where header changes can affect them.
Expand to O3/Oz and va_list-to-library boundaries before delivery.
Keep newlib and other target validation explicitly separate.

Gate: verified latest-z88dk integration, no accidental old-tree dependencies.

### 5. Integrate and publish only after authorization

Review the final upstream-relative diff, tests and remaining limitations.
Commit/push only when requested. Do not force-update an existing remote
development branch as an incidental part of this update.
Follow z88dk's subject-only/no-attribution commit convention.
Update the workspace reference separately without staging unrelated work.

External submissions require explicit current authorization. Package a fresh
minimal patch rather than resurrecting the withdrawn old bridge submissions.

## Relationship to the compiler plan

This update is a distinct axis from LLVM-Z80 #112+#114.
First hold the compiler fixed and change z88dk. Then hold the new z88dk
fixed and test the compiler combination. Changing both simultaneously
would recreate the source/artefact ambiguity that invalidated the earlier
bug attribution.

No implementation or new upstream correctness claim is made by this plan.

## Execution evidence (2026-11-01)

- The canonical `AGENTS.md` matches the workspace copy. The z88dk root
  instructions and relevant compiler, library, CP/M, and tool skills were
  read before build work.
- The original tree remains at `680664d950741a45a4a34dec159330eb04a1207e`;
  its dirty state remains `? ext/regex` and modified
  `test/llvmz80/run_minimal.sh`.
- Worktree `/Users/ravn/z80/z88dk-update-20261101` is detached at
  `02ce61be8d51f271f6d133b88698fba1954af2c2`.
- Applied only the final local integration delta to
  `include/sys/compiler.h`, `include/stdlib.h`, and `src/zcc/zcc.c`. The
  upstream driver changes for filenames with spaces and debug temporary
  naming remain intact; the duplicate ticks-help change was not transplanted.
- Copied the 15 final `test/llvmz80` files from local HEAD and added
  `zcc_supplement.sh`. It tests explicit paths containing spaces,
  compiler-prefix discovery, fallback from an invalid override, `-c`, and
  `-E`. Runtime tests cover O0, O2, Os, O3, and Oz.
- Existing baseline log `scratch/tmp/z88dk-pr112-tests-20261101.log` records
  30 runtime passes, 24 memory-emission passes, and 3 passing scripts with no
  skips.
- The fixed control compiler hash is
  `5f197c53a380cd9de2130613cdf80f9eba54eb0cb8226a2eb194f288af3eb4a4`.
  Its matching runtime archive hash is
  `bae7119baba9989ef358977c3dd4ebbf7baf6595cf71cbd1dbc0ec24f922bc82`.
- Root `make all` completed with exit 0 using the update worktree's `bin` on
  `PATH`, its `lib/config` as `ZCCCFG`, and
  `TMPDIR=/Users/ravn/z80/scratch/tmp`. `ccache` was not on `PATH`, so the
  build used the configured compiler directly. The updated `zcc`, assembler,
  and ticks binaries resolve inside the new worktree. Final SHA-256:
  `bin/zcc` `1e8a76cf01c43dce3fc630cd47e2aca1521bd8054b2945fd279f0c4c74c7f6ad`,
  `bin/z88dk-z80asm` `382d321a4985c4e60a4d6e51752b7c54b6a542563391fd8b02f0da0ffdd4d112`,
  `bin/z88dk-ticks` `48bac08bf2a80d3af00e79d4120ba066a96d555dd6f07c651248c7fd9c9b868a`.
- Built `cpm_clib.lib`, `z80_crt0.lib`, and `math32.lib` from the new
  worktree and installed the generated copies at the configured library
  paths. The generated object-directory issue was handled without source
  changes by cleaning/building `time` and `sound-ay` before the aggregate
  CP/M library target. Source and installed-copy hashes match:
  `cpm_clib.lib` `680285720587a3bd7eaa8f5555b83d32468bbab06abcd180b8b40396c0d42bd6`,
  `z80_crt0.lib` `98c81c137cb8195fc8c99c598c6027fd7905a74286af91790f4383d32645860f`,
  `math32.lib` `5fb819c690223752c4945dfdf7c42208b8014fe70b79b32763b01fa689f5bc55`.
- Library build sequence in the worktree: clean/build `time` and `sound-ay`,
  then run `make -C /Users/ravn/z80/z88dk-update-20261101/libsrc -j1 cpm_clib.lib`
  and `make -C /Users/ravn/z80/z88dk-update-20261101/libsrc -j1 z80_crt0.lib`.
  Build only the Z80 math32 output using the same worktree's
  `libsrc/math/float/math32` Makefile, then run
  `make -C /Users/ravn/z80/z88dk-update-20261101/libsrc install`. Detailed
  command output is preserved under `scratch/tmp/z88dk-update-*-20261101.log`.
- A captured `zcc -v` link command shows the compiler include path under the
  update worktree and link order
  `-lz80_z88dk_rt -lcpm_clib -lz80_crt0`; the supplement resolves under the
  fixed compiler prefix, not the old z88dk tree. See
  `scratch/tmp/z88dk-zcc-provenance-20261101.log`.
- Before the source delta, the focused supplement test failed because the
  verbose link command lacked the supplement `-L` and `-l` options. The
  pre-change runtime suite also failed at `header_abi.c:353` with
  `undefined symbol: ___z80_memset_builtin`. After the changes,
  `scratch/tmp/z88dk-update-final-run-all-20261101.log` records 4/4 scripts
  passing, 50/50 runtime executions across five optimization levels, 24/24
  memory-emission checks, and 0 skips. The supplement test additionally runs
  three `header_abi` binaries using the spaced override, compiler-path
  discovery, and invalid-override fallback; all pass. Its `-c` and `-E`
  checks also pass. Separate counterfactual runs with pinned upstream headers
  reproduced the header failures: upstream `stdlib.h` made the qsort oracle
  return 30, and upstream `sys/compiler.h` made `header_abi` return 10.
- The sccz80 header/ABI positive control passed (`ALL PASS`, `X`). SDCC
  control could not run: no SDCC executable is available, the documented
  `z88dk:2.4` image is absent, and `docker pull` failed because the Docker
  daemon is unavailable at its socket.
- The planned `vsnprintf`-through-`va_list` boundary was reduced and
  investigated rather than excluded. Repro:
  `scratch/tmp/z88dk-va-list-boundary-20261101/repro.c`. For
  `format(out, "%d:%s", 42, "ok")`, the independent expected result is return
  value 5 and buffer `"42:ok"` (the paired ordinary `snprintf` control returns
  5 and writes exactly that string). Before the header adaptation, both the
  old tree at `680664d950741a45a4a34dec159330eb04a1207e` and the update tree
  at `02ce61be8d51f271f6d133b88698fba1954af2c2`, using the same fixed #112
  compiler and matching LLVM runtime supplement (each with its own CP/M
  libraries), produced `vsnprintf=0,''; snprintf=5,'42:ok'` at O0 and O2;
  each probe exited 2. Old/new generated assembly was byte-identical, as
  were the two trees' `_vsnprintf.asm` sources. The full `cpm_clib.lib`
  artifacts differ (old SHA-256 `6e8a6aaf...`, update SHA-256
  `68028572...`), so cross-tree equality is not treated as an isolated
  library-binary comparison; the new-tree pre-adaptation red run and
  byte-identical relevant assembly source independently establish the
  integration failure. Logs:
  `scratch/tmp/z88dk-va-list-boundary-20261101/old-llvmz80-O0-paired.log`,
  `old-llvmz80-O2-paired.log`, `new-llvmz80-O0-paired.log`, and
  `new-llvmz80-O2-paired.log`.
- Direct-prototype alternative checked: declaring the builtin spelling
  `vsnprintf` with `__attribute__((sdcccall(0)))` (even with
  `__asm__("_vsnprintf")`) emits Clang's
  `warning: sdcccall(0) calling convention is not supported on builtin
  function [-Wignored-attributes]`; the IR call has no `z80_sdcccall0`, and
  the program fails at runtime. A correctly typed `sdcccall(0)` function
  pointer to that declaration also fails type checking because Clang's
  builtin type remains default-convention. With
  `-fno-builtin-vsnprintf`, the direct declaration and pointer type do work
  (runtime pass and `z80_sdcccall0` IR), but that requires a global compiler
  option. The LLVMZ80-only private identifier/assembly-name alias avoids
  changing compiler flags while preserving the public API spelling. Evidence:
  `scratch/tmp/z88dk-va-list-boundary-20261101/direct-only-default.log`,
  `direct-asmdefault.log`, `direct-only-no-builtin.log`, and
  `direct-no-builtin.log`. The integration regression now covers direct and
  function-pointer calls; the latter's emitted call is `z80_sdcccall0`
  (`final-caller/varargs.ll`, around the `format_indirect` body).
- The review also found the adjacent `vfprintf`/`vprintf` boundary. Before
  adapting `vfprintf`, both entrypoints independently failed in old and new
  trees at O0 (build success, runtime exit 1), with no expected output:
  `scratch/tmp/z88dk-va-list-boundary-20261101/{old,new}-api{1,2}.log`.
  A direct `sdcccall(0)` redeclaration also hits the builtin ignored-attribute
  diagnostic. A scratch private `_vfprintf` alias with `sdcccall(0)` passes
  for both `vfprintf` and the `vprintf` macro, producing `42:okPASS`; see
  `new-vfprintf-alias1.log` and `new-vfprintf-alias2.log`. The library
  `_vfprintf.asm` reads `FILE *` from `SP+2`, matching that call convention.
  Added the same narrowly guarded LLVMZ80 alias in `include/stdio.h`; the
  `vprintf` macro expands through it. The varargs runtime test now checks
  both return counts and exact emitted text.
- Adjacent `vsprintf` is a macro over `vsnprintf`: it failed against the old
  header but passed with the updated `vsnprintf` adapter. The test now checks
  `vsprintf` result and bytes. For bounded behavior, ordinary `snprintf` was
  run independently as the libc-semantics control: for format `%d:%s`,
  arguments `(42,"ok")`, both old and update trees returned 5 with `n=3`,
  wrote `42\\0`, and preserved the following sentinel; for `n=0`, both
  returned 5 and left the destination unchanged (`old-api5.log`,
  `new-api5.log`). The corresponding `vsnprintf` checks now assert the same
  output/count behavior in `varargs.c`. This distinguishes ABI adaptation
  from the library's truncation semantics.
- The expanded `varargs.c` failed before the `vfprintf` alias (build exit 0,
  runtime exit 11):
  `scratch/tmp/z88dk-va-list-boundary-20261101/expanded-red.log`. After both
  aliases and the focused direct/indirect, vfprintf/vprintf/vsprintf, small
  `n`, and zero `n` assertions, the full suite passes:
  `scratch/tmp/z88dk-update-va-list-review-final-run-all-20261101.log` records
  4/4 scripts, 50/50 runtime executions across O0/O2/Os/O3/Oz, 24/24 codegen
  checks, and 0 skips. The sccz80 `header_abi.c` positive control passes
  (`ALL PASS`, `X`; see
  `scratch/tmp/z88dk-va-list-boundary-20261101/sccz80-header-review-run.log`).
  SDCC remains untested because no host executable or available Docker
  daemon/image exists. sccz80's distinct `stdarg.h` convention was not
  conflated with the LLVMZ80 test.
- Standalone paired demonstration:
  `scratch/tmp/z88dk-va-list-boundary-20261101/vsnprintf-abi-demo.c` declares
  two distinct identifiers, both linked to `_vsnprintf`, one with the default
  convention and one with explicit `sdcccall(0)`. With the same compiler and
  library, the run log shows the default call returning 0 with empty text and
  six zero bytes, while the corrected call returns 5 with `42:ok` and bytes
  `34 32 3a 6f 6b 00`; the independent expected line is printed first.
  Exact environment, compile command, and output:
  `scratch/tmp/z88dk-va-list-boundary-20261101/vsnprintf-abi-demo.log`.
  This demonstrates this specific `_vsnprintf` ABI boundary only; it is not
  evidence about unrelated builtins or whole-program reachability.
- `git diff --check` and shell syntax checks pass. The original z88dk
  worktree retains its prior dirty state. No commit, push, or PR was made.
  Review-only production diff is preserved at
  `scratch/tmp/z88dk-va-list-boundary-20261101/final-stdio-abi.diff`;
  test changes relative to local HEAD `680664d` are at
  `scratch/tmp/z88dk-va-list-boundary-20261101/final-review-tests.diff`.

The LLVM-Z80 z88dk update axis, including the formerly failing
`va_list`-to-library boundaries and bounded-output cases, is validated by
the recorded regression and full-suite runs. SDCC positive-control coverage
remains blocked by the unavailable Docker daemon/image; no compiler or
newlib changes were made. Separate firmware prerequisite, not addressed by
this update (parent-verified): PR112 `IntrinsicsZ80.td` declares DI/EI/HALT/
NOP LLVM intrinsics with `IntrNoMem` and `IntrHasSideEffects` but no
`ClangBuiltin`; `git grep __builtin_z80_di/ei` in clang at `da06bcd8` finds
no declarations. Builtin/header commits `ea3d638fdac8` and `2883cdd8bb73`
and candidate lowering commit `01c80da67276` are on a different lineage
(`01c80da67276` is not an ancestor of PR112 or `da06bcd8`). Therefore these
clean-#112 z88dk tests do not validate firmware that depends on
`__builtin_z80_*`. No builtin implementation was added here.

## Dedicated stdio branch preparation (2026-11-01)

- Branch `fix/llvmz80-vsnprintf-pr112`, worktree
  `/Users/ravn/z80/z88dk-vsnprintf-pr112`, starts at upstream
  `02ce61be8d51f271f6d133b88698fba1954af2c2`. No commits were made.
- Only `include/stdio.h` and `test/llvmz80/varargs.c` differ from that base.
  The header groups the reviewed LLVMZ80-only private aliases for
  `_vsnprintf` and `_vfprintf` under one guard. The existing upstream
  varargs, va_copy, C23 and repeated direct-call tests remain intact.
  Added cases cover a correctly typed indirect call, truncation, zero size,
  vsprintf, vfprintf and vprintf. Memory streams capture the stream output
  so the unchanged upstream runner still expects only `ALL PASS`.
- `_vfprintf` is included because its independently observed failure uses
  the same builtin-name/convention boundary. Old/new `api1` and `api2`
  logs above show runtime exit 1 before adaptation. Their alias controls
  return 5 and emit `42:ok`. No other stdio entrypoints were changed.
- This branch does not contain the broader driver, compiler.h or stdlib.h
  update. Validation uses the previously rebuilt update-tree tools,
  configuration, CP/M libraries and matching LLVM runtime supplement.
  `-I/Users/ravn/z80/z88dk-vsnprintf-pr112/include` selects the branch
  headers before the configured update-tree system include directory.
  Compiler source revision:
  `042a1d72651c110a73defde6e1256fd53ab3a1a8` (clean #112).
- Reproducible command script:
  `scratch/tmp/z88dk-va-list-boundary-20261101/run-dedicated-branch.sh`.
  With the upstream stdio header, the unmodified upstream fixture builds
  but returns 2 at O0/O2/Os/O3/Oz (`branch-baseline.log`). The additive
  regression fails compilation at all five levels before the fix because
  the function-pointer convention does not match (`branch-red.log`).
  After the header fix, all five builds and executions return 0 with exact
  `ALL PASS` output (`branch-green.log`, individual build/output logs).
- `branch-headers.log` shows stdarg.h, stdio.h and string.h coming from the
  dedicated branch. `branch-caller.ll` contains the indirect
  `call z80_sdcccall0` and direct `_vsnprintf`/`_vfprintf` calls.
  `branch-green-O0-build.log` records the actual include, CRT and archive
  paths. The sccz80 header control with the branch include directory passes
  (`branch-sccz80-build.log`, `branch-sccz80-output.log`).
- This is focused branch validation, not a claim that pristine upstream
  has all broader integration prerequisites or passes the update suite.
  SDCC remains unavailable. Original and update worktrees are preserved.
  Final diff checks pass. No commit, push or PR was made.

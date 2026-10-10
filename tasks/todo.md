# Z80 Code Density Optimization Todo

## Same-source c863c55 autoload codegen comparison (2026-10-10)

- [x] Rebuild the exact archived `c863c55` autoload source with current
  compiler `d6658ad`, retaining the historical build flags and recording
  tool/dependency revisions. The temporary address-space-2 patch is isolated;
  the current PROM exceeds the production cap, so a widened-cap inspection ELF
  is clearly marked non-production.
- [x] Preserve the current-compiler ELF, source-annotated listing, raw and
  compressed payloads beside the pre-PR-40 artifacts.
- [x] Compare listing/code-size outputs and document observed differences
  without assigning unverified causes in
  `scratch/pre-pr40-firmware-archive/reproductions/autoload-c863c55/COMPARISON.md`.

## Attributing c863c55 autoload size delta (2026-10-10)

- [x] Compare the old `+static-stack` and new `+static-frame` pipelines as
  distinct mechanisms; do not infer equivalence from feature names.
- [x] Trace the largest matched-function size deltas through emitted
  instructions and compiler behavior, marking semantic/measurement caveats.
- [x] Record verified causes and remaining hypotheses in the comparison report;
  do not implement a codegen change during this attribution pass.

## Measuring static-frame eligibility impact (2026-10-10)

- [x] Confirm a candidate function has no self-recursion, indirect entry, or
  interrupt-context caller before asserting `no-recurse`.
- [x] Produce a matched baseline/diagnostic object for that function with only
  the analysis assertion changed; record code-size delta and limits.
- [x] Do not treat a per-function isolated result as a full PROM/compressed-size
  attribution or as a production-safe change.
- [x] Repeat the `check_sysfile` diagnostic as a complete same-source inspection
  image with the exact baseline banner and current `+static-frame` options.
- [x] Preserve the raw/compressed counterfactual, verify its ZX0 roundtrip,
  remove the temporary backend patch, and rebuild the unpatched compiler tools.
- [x] Run a pass-only FDC probe to distinguish whole-module eligibility from
  extracted-function size estimates.
- [x] Confirm from historical/current listings that several bodies now
  emitted as helpers were present inside historical `_main_relocated`.
- [x] Measure matched machine-outliner enabled/disabled full-image builds,
  preserve both outputs, and verify their ZX0 roundtrips.
- [x] Measure actual helper inlining using a matched IR-to-image control:
  forced inline saves 16 B raw / 12 B compressed; verify both ZX0 round-trips
  and document why the source `always_inline` probe alone did not inline.
- [x] Reconcile the complete +292 B raw `.text` growth by symbol/region:
  helper extraction nets −117 B, the boot-path changes +155 B, and remaining
  pre-table symbols +214 B; record the separate +40 B post-table region.
- [x] Make matched-routine code size and generated instruction structure the
  primary comparison; retain ZX0 as a secondary whole-image metric.
- [x] Bound the remaining +174 B compressed gap after the `check_sysfile`
  counterfactual. ZX0 encodes one continuous payload, so this structural
  comparison does not claim a unique per-function or causal attribution.

## Full pre-PR-40 compiler on c863c55 autoload source (2026-10-09)

- [x] Create isolated compiler and firmware worktrees at the exact requested
  revisions; preserve existing checkouts and firmware artifacts.
- [x] Build the complete pre-PR-40 compiler/toolchain using the configured
  ccache, recording actual cache deltas and monitoring free disk.
- [x] Initial attempt with `199178...` failed in GlobalISel on the port
  `G_STORE`; later verified this revision was already post-merge and lacked
  the address-space-2 mapping, so this was not the correct historical control.
- [x] Record revisions, commands, ccache totals, the intermediate-tree failure,
  and its correction in
  `rc700-gensmedet/autoload-in-c/tasks/codegen-regression-vs-c863c55.md`.
- [x] Keep the exact-source attempt unmodified; do not adapt port I/O.

## Correct pre-merge compiler endpoint for c863c55 (2026-10-09)

- [x] Verify that the failed `199178...` tree lacks `AS_IO` and the selector
  mapping, while `48c1b4b^1` contains both.
- [x] Tag the corrected compiler revision as local annotated tag
  `compiler-pre-pr40` at `d52e23342de460f4512a52fe8e0941b50bc2d526`
  (2026-09-05; first parent of merge `48c1b4b`).
- [x] Build the full compiler/toolchain (3418/3418 steps). Ccache was
  configured and the cache warm, but recorded 0 hits / 2794 misses.
- [x] Build the exact `c863c55` PROM without source adaptation. It emitted
  `IN A,(4)` / `OUT (5),A`; PROM 2034 B, raw `.text` 3393 B, ZX0 1915 B.
  The ZX0 roundtrip matched the raw `.text` byte-for-byte.
- [x] Update the report with the corrected endpoint and supersede the
  intermediate-tree failure as an invalid port-I/O control.
- [x] Remove the verified-clean disposable worktrees/build after preserving
  the PROM, listing, raw/compressed payloads, and build logs under
  `scratch/premerge-c863c55/`.

## Pre-PR-40 firmware source/build archive (2026-10-10)

- [x] Anchor the three production component sources to the firmware repository
  snapshot `2951f96` from 2026-09-05, before compiler merge `48c1b4b`.
- [x] Collect exact source trees and pre-existing tracked artifacts for
  autoload-in-c, rcbios-in-c, and cpnos-in-c in
  `scratch/pre-pr40-firmware-archive/source-snapshot/`.
- [x] Build each component with the tagged pre-PR-40 compiler and preserve
  objects, ELF files, listings, maps/symbols, compressed payloads, and final
  binaries under `scratch/pre-pr40-firmware-archive/generated/`.
- [x] Include the separate c863c55 autoload source and input/output evidence
  under `scratch/pre-pr40-firmware-archive/reproductions/autoload-c863c55/`
  without conflating it with the 2026-09-05 source snapshot.
- [x] Write the manifest with revisions, commands, artifact sizes/hashes, and
  verification limits; compare both exported source trees to Git, verify the
  generated artifacts, record ccache results, and remove temporary worktrees.

## Parallel pre-PR #40 codegen comparison (2026-10-09)

- [x] Build pre-PR-40 `llc` at `1991786426b42cb678bcd2c38daf10bd853d0f25`
  in an isolated worktree/build. The historical `clang` target was not built:
  1454 Ninja edges remained and only about 5 GB was free.
- [x] Rebuild/verify the current compiler and compare the feature-neutral
  current-source IR through both backends; record PROM, raw `.text`, and ZX0
  sizes. The pre-PR-40 backend produced a 2461 B PROM vs 2190 B current-neutral.
- [x] Record revisions, backend flags, roundtrip results, cumulative ccache
  status, and the limits/caveat of this backend-only comparison in
  `rc700-gensmedet/autoload-in-c/tasks/codegen-regression-vs-c863c55.md`.

## Symbol encoding PR isolation and review updates (2026-10-08)

- [x] Extracted "Brik 1" symbol mangling from large PR into clean upstream PR #84.
- [x] Switched mangling prefix from 'L' to '_' to prevent LLVM MC temporary
  suppression of EXTERN directives on external dotted symbols.
- [x] Adopted idiomatic StringRef::split with SmallVector<StringRef, 4> and
  raw_svector_ostream per code review from the fork owner.
- [x] Kept source code comments concise (1-2 lines); dropped redundant comment
  in Z80MCAsmInfo.
- [x] PR #62: removed benchmark script file per review; verified tests and force-pushed.
- [x] Upstream issues tracked on llvm-z80:
  - #85: C_LINE debug directives for z80asm
  - #86: Target triple z80-unknown-none-z88dk and default sdcccall(0)
  - #87: z88dk runtime helper interfaces (EXX 32-bit registers, math32, fcmp flags)
- [x] All 135 Z80 lit tests pass locally.


- [x] Review source state, remote parity and the written plan against evidence.
  LLVM source is clean; tracked z80-utils matches upstream/main.
  z88dk source is clean after the human's 78033cf4c4 driver cleanup.
- [x] Correct stale ABI/bridge/test-path documentation and record the
  session summary in tasks/handoff/2026-10-04-native-math32.md.
  Preserve unrelated rules, build configuration, projects and artifacts.
- [x] Assess issue need: no unresolved integration failure observed.
  Missing pkg-config and stale generated dependencies were local build
  blockers, resolved without a source fix; no issue filed.
- [x] Commit and push scoped documentation and compiler/z88dk pointers;
  ensure child commits are on origin first, then publish the workspace.
  Check post-push remote parity and CI.
  Published z88dk 73ffe423a3 and workspace summary dcd87d0;
  LLVM 210143489a25 was already on origin. z88dk CI run 37219170554
  passed; no workflow runs returned for the compiler/workspace branches.

Closure supersedes historical "no commit/push" checkpoint notes below:
LLVM changes through 210143489a25 and z88dk changes through 9be09aaf2c
were already published on explicit user authorization. The current zcc
cleanup is the human's 78033cf4c4; this closure publishes it, rather than
recreating or amending that commit. General builtin-ABI experiments and
standalone runner work remain preserved separately, not part of this PR.

## Refreshing native toolchains (2026-10-04)

- [x] Fetch llvm-z80 and z88dk; current feature branches match origin
  (both HEAD...origin comparisons are 0/0). Preserve local zcc edits.
- [x] Rebuild LLVM asserts clang, llc, lld, opt and FileCheck.
- [x] Rebuild z88dk binaries and install CP/M/classic/math32 libraries.
  Built SVG with SDK libxml flags because pkg-config is missing.
  Removed eight stale generated crt0 dependency files referencing the
  deleted l/llvmz80.lst, then completed build.sh -p cpm without cleaning.
- [x] Verify refreshed artifacts: 145 backend lit PASS; runtime 426 PASS,
  6 SKIP, zero FAIL/FATAL; all 15 llvmz80 integration scripts PASS,
  including math32 arithmetic, conversions, comparisons and C_LINE.
  Evidence: scratch/tmp/toolchains-refresh-{llvm,z88dk-final,lit,runtime,
  integration}.log. No source edits, commits or pushes for this refresh.

## Centralizing ordinary runtime calls (2026-10-04)

Goal: centralize operation -> symbol + calling convention for ordinary
helpers, preserving emitted code and runtime behavior. Prefer LLVM's existing
RTLIB implementation/availability/CC machinery; do not add parallel bespoke
tables or change Clang's target-default handling.

- [x] Inventory ordinary helpers in Z80LegalizerInfo.cpp: i32 fallback
  multiply/divide/remainder/divmod, f32 arithmetic and i32/f32 conversions.
  Record current name bytes (including no-mangle marker), CC and applicability
  for bare Z80, Z80/z88dk, SM83 and SM83/z88dk. Preserve fast-math variants.
  Existing fallbacks are behavior baselines, not proof the runtime supplies
  every symbol; do not introduce new support claims.
- [x] Trace existing RTLIB selection and Z80 system-library definitions in
  RuntimeLibcalls.td/RuntimeLibcallsImpl.td and SystemLibraries.td.
  Use existing implementations where correct; add only required z88dk
  implementations and scoped availability/CC rules. Verify name lifetime,
  exact assembler spelling and helper signatures, especially divmod's pointer.
  The verified TableGen mechanism supports target predicates, LibcallsWithCC
  and DefaultLibcallCallingConv; choose the smallest scoped configuration.
- [x] Capture pre-change assembly and runtime results. Extend CI-gated lit
  coverage for all affected operations and target profiles, including explicit
  smallc/sdcccall(1) callers whose runtime calls must retain the runtime ABI.
  Check exact symbols, stack argument order/cleanup and return registers.
  Use existing runtime fixtures and independent expected values. New missing
  coverage must pass the baseline; this is a behavior-preserving refactor,
  not a bug fix requiring deliberately failing behavior tests.
- [x] Configure runtime lookup and replace repeated name/CC ternaries with
  a shared RTLIB-based call helper. Keep operand preparation and result
  handling unchanged. Preserve existing unsupported-call error propagation.
  Do not globally change all z88dk runtime CCs without checking exceptions.
- [x] Verify generated lookup results and TableGen tests; rebuild clang, llc,
  lld, opt and FileCheck in build-macos-asserts with ccache. Compare before/after
  assembly for affected fixtures; run frontend/backend lit and runtime gates
  using the unchanged upstream runner. Recheck diff for unrelated formatting.
- [x] Assess the final PR delta: accept only if repeated policy is removed
  without greater unrelated machinery or behavior shifts. Record evidence.
  No commit, push or PR update without renewed authorization.

Out of scope: EXX integer worker protocol, register-bank/IX preservation,
FCMP NaN/classification/predicate logic, direct asm_mem* workers, test-runner
changes and runtime-library fixes. Leave custom f32 min/max handling unchanged
unless inventory proves it is an ordinary helper covered by existing RTLIB.
Before implementation, commit the existing literal-name cleanup separately
per user direction. Pre-commit validation: 145 backend lit PASS; unchanged
upstream runner: 426 runtime PASS, 6 SKIP, no FAIL/FATAL. This checkpoint
contains only the cleanup, not the runtime-lookup refactor; no push requested.

Implementation notes: system-library definitions live in RuntimeLibcalls.td,
not a separate SystemLibraries.td. TableGen rejects octal string escapes, so
the central names omit the no-mangle byte; one Z80 helper adds it through
MachineFunction::createExternalSymbolName for stable storage. The two profiles
replace only the listed ordinary calls. Min/max remain out of scope.
Integer helpers reuse existing RTLIB implementations; only math32 names and
the existing compiler-rt fast variants need new entries. One shared helper
is the deliberate deviation from the plain RTLIB createLibcall overload:
it preserves z88dk's no-mangle marker without generic TableGen changes.
Argument/result construction and divmod's byte-aligned remainder slot stay
unchanged. Unsupported lookup returns UnableToLegalize, as the RTLIB overload
does. No EXX, FCMP, memory-worker, min/max or runner edits were made.
Baseline: four target-profile assembly snapshots, profile/ABI lit coverage,
426 runtime PASS and 6 SKIP; math32 arithmetic and conversion scripts PASS.

Additional requested scope: move external z80asm tests into z88dk integration.
Only z80asm-c-line-e2e.test invokes external tools; the other matching tests
use llc/FileCheck only. Relocated to test/llvmz80/z80asm_c_line_e2e.sh, with
shared environment discovery and isolated workspace temp files; direct run
checks Hello World execution and C_LINE entries for lines 4 and 5.

Final evidence (2026-10-04): 163 lit PASS (Z80 backend, five frontend ABI
fixtures and all RuntimeLibcallEmitter tests); eight before/after assembly
snapshots byte-identical across bare/z88dk Z80/SM83 profiles. Upstream runner:
426 PASS, 6 SKIP, zero FAIL/FATAL. Existing z88dk math32 arithmetic/conversion
value tests and relocated C_LINE map/execution test PASS with final tools.
No tracked z80-utils difference from upstream/main. Diff reviewed for scope
and whitespace; only changed call expressions were realigned. The central
policy adds 48 net TableGen lines and removes 3 net legalizer lines; no
generic emitter/API changes or duplicate integer implementations. New backend
coverage is included by the existing build-and-lit CI directory target;
TableGen coverage was run locally. No commit or push of this refactor.

Follow-up RTLIB consumer check: affected scalar operations are custom before
generic GlobalISel libcalls; vector arithmetic scalarizes into that path and
saturating conversions lower into it. Observed exact math32 call spelling on
Z80/SM83 at O0/O2; added permanent lit coverage for both alternate paths.
Other GlobalISel name consumers use memory, atomic or stack-protector calls,
not changed math32 entries. PreISel's named calls are Objective-C; LTO collects
names without emitting calls. declare-runtime-libcalls creates declarations,
not calls (observed sdcccall0 math32 declaration). This is not proof of arbitrary
hand-written IR calls to unprefixed math32 declarations, which are ordinary
program calls rather than compiler-generated helpers. No production fix needed.

## Separating test-runner changes (2026-10-04)

- [x] Preserve timeout, emulator cleanup and failed-link rejection on an
  independent branch from `upstream/main`.
- [x] Restore all tracked `z80-utils` files in the compiler branch to upstream;
  remove its timeout CI argument and the workspace wrapper argument.
- [x] Verify upstream-runner identity and compiler runtime behavior; validate
  the standalone runner without depending on new compiler lit tests.
- [x] Do not create a runner PR; user narrowed scope to trimming the current PR.
  Runner branch: `test-runner-hardening-20261004`, based on `upstream/main`
  (`24afb830878c`), worktree `scratch/llvm-test-runner-20261004`.
  Scope: README, emulator, CLI, REL linker and runtime CI; no compiler-only
  lit-path additions. CI installs SDCC and runs the unit tests.
  Compiler branch has no tracked `z80-utils` difference from upstream.
  Validation: 150 lit PASS; upstream-runner runtime 426 PASS, 6 SKIP,
  no FAIL/FATAL. Standalone runner: seven unit tests PASS, six CLI runtime
  cells PASS. The linker test fails with upstream's ignored exit status.
  The macOS cleanup test also fails on the exact upstream runner and is
  excluded from local standalone validation, not modified by this split.
  Draft body: `scratch/tmp/test-runner-hardening-pr-20261004.txt`.
  Publication cancelled by user: "du skal ikke lave runner pr, lige nu
  trimmer vi bare denne her". Runner changes are preserved locally only.
  No commits, pushes or new PR; remote compiler PR remains unchanged.

## Isolated target-ABI experiment (2026-10-04)

- [x] Create `experiment-z88dk-target-abi-20261004` at exactly
  `cdf7fbabe8000fa55f056e64ceb42b1e6f0d868f` in
  `scratch/llvm-z88dk-target-abi-20261004`.
- [x] Build the unmodified experiment baseline and observe the new test fail.
- [x] Apply only the target override, add CI coverage and adjust affected
  return-register expectations; no general builtin/default-flag patches.
- [x] Build and validate the experiment itself, including no-flag runtime.
  Per user direction, switched the main llvm-z80 checkout to this branch
  and reused build-macos-asserts with verified ccache. Prior tracked changes
  and ABI tests are preserved in the named stash
  "Preserve pending general ABI work before target-only experiment 20261004".
  The spare worktree is detached at the requested base.
  Baseline regression failed; after the six-line target override,
  148 frontend/codegen lit tests and all six no-flag CP/M runtime cells pass.
  ASTContext.cpp is unchanged from cdf7fbabe800. No commits or pushes.

## z88dk target ABI (2026-10-04)

- [x] Observe no-flag z88dk ordinary/builtin ABI regressions failing.
- [x] Set the Z88DK environment's target convention to sdcccall(0);
  preserve bare Z80 and explicit program-default overrides.
- [x] Verify frontend, emitted assembly and no-flag runtime behavior.
  153 frontend/codegen lit tests pass. z88dk integer returns now use HL;
  bare Z80 still uses DE. The six varargs/header runtime cells pass with
  the zcc default-convention flag removed before invoking clang.
  Explicit sdcccall(1) overrides ordinary functions and library builtins;
  main retains its pre-existing CC_C entry-point exception.
  Six cross-TU builtin runtime controls also pass. No commit or push.

## General library builtin calling convention (2026-10-04)

- [x] Capture a failing non-Z80 builtin-alias test on the existing compiler.
- [x] Replace the Z80/default0 special case with the existing command-line
  calling-convention resolver, preserving its variadic restrictions.
- [x] Rebuild and verify generic/Z80 frontend, lit and runtime coverage.
  Six focused lit tests pass; the generic test covers fastcall, stdcall,
  vectorcall and no flag, plus variadic fallback and explicit attributes.
  Default0 cross-TU runtime passes at all six optimization levels.
  Minimal z88dk smoke and six runtime cells pass. No commit or push.

## Minimizing z88dk integration (2026-10-04)

Commit authorization received: "commit". Local commits:
- Compiler builtin ABI correction/tests/CI: `60abe413da58`.
- z88dk attribute mapping: `8351f7527c`; builtin varargs: `3de629493d`.
- wcmatch invocation: `907b927f78`; calloc alias: `a228e307f2`.
- Minimal driver/runtime tests: `6bf4fb40c3`; TMPDIR: `1bc6512706`.
The z88dk worktree remains on `minimal-llvmz80-20261004`; the main z88dk
checkout/pin is unchanged. Compiler and minimal integration targeted gates
were rerun before committing and passed. No pushes, merges or PRs.
Unrelated benchmark changes remain uncommitted.

Implemented in the isolated upstream worktree. Keep sdcccall(0) as the program
default and use existing runtime entries without new bridges. Start from
upstream headers, not the accumulated local workarounds. Attribute and
prototype exceptions must be justified by actual compile/link/runtime evidence.
Hard constraint: `__ZPROTO*` macros must match upstream exactly. Restore
`sys/proto.h` to the chosen upstream version; no LLVM-Z80 macro branch,
rewrites or replacement macros. Compatibility must be established without
changing those definitions.
Primary acceptance criterion: minimize source divergence from upstream.
Do not retain local workarounds merely because they currently pass tests.
Prepare small, single-purpose changes with their directly related tests and
documentation. Keep independent fixes separate from LLVM-Z80 integration;
avoid broad comment rewrites or formatting churn.
Suggested change boundaries, adjusted only by observed dependencies:
- Restore upstream prototypes/macros and remove dependent local-only uses.
- Remove obsolete per-header ABI workarounds in independently verified groups.
- Reduce compiler identification/attribute glue to demonstrated necessities.
- Keep any required stdarg adaptation as a separate, minimal change.
- Separate unrelated build/tooling fixes and accidental source differences.
Do not combine these with compiler experiments or benchmark additions.
Actual commits/pushes still require authorization; this records the desired
patch structure, not permission to commit.

Execution evidence (2026-10-04):
- Fresh baseline: all 14 integration scripts pass at `e3b080b0ad`.
  Log: `scratch/tmp/minimal-z88dk-baseline-20261004.log`.
- Worktree: `scratch/z88dk-minimal-20261004`, branch
  `minimal-llvmz80-20261004`, upstream base `e67ef86a93`.
  Compiler: `68ec61b0a209`, assertions build. No commits or pushes.
- Driver smoke fails on upstream with "Unknown compiler type: llvmz80".
  The minimal driver passes default0, override and emitted-IR checks.
  Driver-only patch: `scratch/tmp/minimal-zcc-driver-only.patch`.
  TMPDIR support is carried separately for workspace-local test artefacts.
- `sys/proto.h` remains byte-identical to upstream. Current header delta is
  six lines of LLVM-Z80 attribute mapping in `sys/compiler.h` and a small
  builtin varargs branch in `stdarg.h`. Other headers remain upstream.
- Isolated varargs repro: sum(3,10,20,30) returned 10 with upstream stdarg,
  then 60 with builtin stdarg. This test uses -fno-builtin as a control.
- Installed z80_crt0.lib was contaminated: ___strcmp was at offset 9,
  whereas upstream source aliases it to offset 0. Freshly built upstream
  Z80/CPM/math32 archives now live only in the worktree. Fresh ___strcmp
  is offset 0. Repeated source-level wrapper test yields compare=1, sum=60.
  Earlier installed-archive results are not upstream compatibility evidence.
- With fresh archives and -fno-builtin control: FILE*, fd-write, float compare
  strict/fast, conversions, libm and printf formatting tests pass.
  Arithmetic fails only sub.zero: 0x80000000 versus expected 0x00000000.
  The same failure occurs with the reference integration headers against the
  fresh library. It is not evidence of a regression from header minimisation.
- Default0 still loses ABI in printf("ALL PASS\n") -> puts optimisation:
  generated puts call has default C/register CC and emits garbage.
  -fno-builtin preserves sdcccall0 printf and prints ALL PASS.
  Small repro and IR: `scratch/tmp/minimal-zcc-inspect/console*`.
  Do not add -fno-builtin to production as a silent workaround.
- Upstream stdlib's wcmatch macro invocation expands *wildname as an argument
  in its clang branch and fails type checking. Macro definitions are unchanged.
  The existing callback fixture also uses the local-only __z88dk_callback token.
  Need a plain default0 callback fixture, not restoration of that workaround.
  Full results: `scratch/tmp/minimal-z88dk-fresh-tests/`.
  Compiler builtin ABI correction is outside the currently approved scope.
- Subsequent scope-limited trial retains two explicit console ABIs in
  stdio.h and fixes only the malformed wcmatch invocation in stdlib.h.
  No `__ZPROTO*` definition has changed.
  New fixtures are `test/llvmz80/{varargs,header_abi}.c` and `run_minimal.sh`
  in the isolated worktree. They are uncommitted drafts, not passing gates.
- The broader varargs forwarding fixture exposed the same systemic problem:
  an unannotated vsnprintf declaration emits default C/register CC, despite
  default0. IR: `scratch/tmp/minimal-zcc-inspect/varargs-red.ll`.
  `clang/lib/Sema/SemaDecl.cpp:3907-3911` inherits the old declaration's CC
  when the new declaration has no explicit CC attribute. Explicitly attributed
  z88dk declarations have separate handling immediately below that branch.
  This explains why default0 does not replace all old builtin annotations.
  Stop adding per-function workarounds. Resolving the compiler scope is needed
  before the minimal patch can be considered complete.
- Scope approval was requested through the interaction tool, but the user
  was unavailable. No compiler changes were made. Execution is paused at
  that boundary, with the fresh math32 signed-zero failure separately recorded.

Final evidence after the user's instruction to continue autonomously:
- Corrected `ASTContext::GetBuiltinType` for Z80 default0 library builtins,
  including explicit __builtin_ aliases. Six added implementation lines.
  No changes to the backend runtime or to other targets/default1.
  Frontend IR test failed before the change and passes after it.
  Cross-TU runtime fixture failed at all six optimisation levels without
  the correction, then passed all six with it (expected 0x00D9).
  Tests: `clang/test/CodeGen/z80-default-calling-conv-builtins.c`,
  `llvm/test/CodeGen/Z80/default0-builtin-call.ll`, and
  `z80-utils/test-runner/testcases/clang/test_74_default_cc_builtins.c`.
  The frontend test is explicitly wired into the existing compiler CI job.
- Final header delta: `sys/compiler.h` (6 added lines of attribute mapping),
  `stdarg.h` (builtin varargs, including C23), and `stdlib.h` (one corrected
  malformed wcmatch invocation). All eight other previously changed headers,
  including `sys/proto.h`, are byte-identical to upstream.
- Expanded allocation test initially failed to link ___calloc. Added that
  standard clang alias at the existing calloc worker address, not a bridge.
  The archive member remains 12 code bytes; all three names are offset 0.
  `malloc.h` remains unchanged. calloc/realloc now pass the value tests.
- Negative control without the attribute mapping fails at runtime.
  Restoring the six lines passes again. Varargs and declaration regressions
  have corresponding red/green evidence.
- Persistent minimal test target: `make -C test llvmz80` in the worktree.
  Driver smoke/override and six C23 runtime cells pass (O0, O2, Os).
  Runtime coverage: va_start/va_arg/va_copy, C23 one-argument va_start,
  vsnprintf forwarding, qsort/bsearch callbacks, malloc/free/calloc/realloc,
  strcmp/strlen, smallc+callee, fastcall, wcmatch and setjmp/longjmp.
  Calls repeat 100 times. No -fno-builtin workaround remains.
- The same header fixture also passes under sccz80 with the fresh library.
  Actual z80_outp assembly with the unchanged uint8_t prototype pushes two
  bytes for both constant and dynamic data; no arch/z80.h exception needed.
- Final compiler suites: 444 PASS, 6 SKIP, no failures; lit 156 PASS.
  SDCC cross-compiler ABI 174 PASS. Five focused frontend tests pass.
  The original integration suite remains 14/14 PASS after the compiler fix.
- Fresh upstream functional fixtures pass for FILE*, fd-write, strict/fast
  float comparisons, conversions, libm and printf formatting. Full arithmetic
  still has the separately reproduced negative-zero baseline discrepancy.
  Direct cm32_sdcc_fssub(4,4) yields 0x80000000. This change set does not
  modify math32 or weaken the existing arithmetic expectation.
- Driver and independent TMPDIR source patches are separated in
  `scratch/tmp/minimal-zcc-{driver,tmpdir}-only.patch`; reverse-apply checks
  pass against the worktree. TMPDIR has a separate passing test target.
  The math32 dependency fix is not imported. No benchmark work is included.
- Final review: diff/whitespace checks pass, original branch preserved,
  no new wrappers or bridges, ZPROTO definitions unchanged.
  Changes remain uncommitted. No pushes, merges or PRs were made.
  Commit units: compiler builtin correction; driver/test infrastructure;
  attribute mapping; varargs; wcmatch invocation; calloc alias; TMPDIR.
  Build artifacts and evidence remain inside the workspace.
- Logs: `scratch/tmp/minimal-final-gate.log`, `minimal-compiler-final-suite.log`,
  `minimal-final-sdcc.log`, `minimal-final-frontend.log`,
  `default0-builtins-runtime-red.log`, `minimal-z88dk-fixed-compiler/`.
  The C99 attempt exposed the existing driver's fixed gnu23 preprocessing:
  -Cg-std alone does not change header selection. This is documented rather
  than expanded into a separate driver-language refactor.

1. [x] Capture a fresh baseline on z88dk `e3b080b0ad` and the current
   assertion-enabled compiler. Record SHAs, all integration results and
   selected emitted calls. No missing-tool SKIP counts as a PASS.
   Inventory the delta against upstream `e67ef86a93`, separating integration,
   independent fixes, tests and obsolete comments.
2. [x] Create a fresh local integration branch/worktree from upstream's
   default branch (`upstream/master`, verified locally; no upstream/main).
   Pin the chosen upstream SHA. Preserve the existing integration branch,
   untracked files and unrelated workspace/compiler changes.
   Bring in only the llvmz80 driver path and sdcccall(0) default initially.
   Reuse existing regression fixtures as an external workspace-local harness
   before selecting tests for the new patch series. Keep build outputs and
   installed tools isolated so old local changes cannot mask missing pieces.
   Capture compile/link failures and runtime differences before adding glue.
   Do not cherry-pick the broad historical integration commits wholesale.
3. [x] Keep `sys/proto.h` byte-for-byte at the chosen upstream version.
   Establish compatibility with its unchanged `__ZPROTO*` definitions.
   Capture which upstream branches are selected and their emitted symbols,
   argument order and ABIs; do not assume default0 alone makes them correct.
   Evaluate necessary compiler/preprocessor integration separately, without
   adding bridges or modifying the macros. If this requires a compiler
   change outside the current scope, report the blocker before proceeding.
   Keep any necessary attribute mapping confined to `sys/compiler.h`.
4. [x] Test remaining headers individually from their upstream versions.
   Retain an exception only with a reproducer failing without it and passing
   with it. Cover stdarg builtins, FILE* cleanup, setjmp/longjmp, narrow
   smallc stack slots and math32 declarations. Remove duplicate fallback
   branches, local `__ZPROTO3N` uses (restore upstream `__ZPROTO3`), redundant
   default0 callback/varargs annotations
   where safe, and stale bridge/register-ABI comments.
   Check both header include orders and explicit sdcccall1 program override:
   library declarations must still describe the fixed library ABI.
5. [x] Separate unrelated deltas from the minimal integration patch.
   Identify `errno.h`'s ERANGE/ANGE discrepancy against the chosen upstream
   baseline. Keep the math32 archive-dependency fix and zcc TMPDIR fix as
   separately identified work; do not discard their regression protection.
   Keep the llvmz80 driver, native runtime selection and relevant tests.
6. [x] Verify the reduced patch with all integration scripts and focused
   runtime fixtures: varargs/vfprintf, FILE*, allocation, strings, qsort and
   bsearch callbacks, setjmp/longjmp, mixed fastcall/callee/smallc calls and
   math32 values. Use independent expected values, real library calls and
   repeated calls to detect stack drift. Confirm each retained exception
   has a negative control and preserve non-LLVM compiler behavior with
   available upstream tests.
7. [x] Review the final upstream diff and report retained changes, removed
   changes, independent fixes, exact results and any uncovered gaps.
   Verify `sys/proto.h` is byte-identical to the chosen upstream version.
   Explicitly verify every item above. The subsequent continuation instruction
   included the necessary compiler builtin correction. No new bridges,
   commits, pushes, merges or PRs are part of this implementation segment.

## zcc llvmz80 default ABI (2026-10-04)

- [x] Default the llvmz80 compilation command to sdcccall0 before user
  `-Cg` flags, retaining an explicit sdcccall1 override.
- [x] Observe the smoke regression fail before the change; rebuild zcc.
  Verify real emitted IR for default0 and explicit1 and option ordering.
  All 14 active integration scripts pass with the new default.
  Mixed-ABI assembly/runtime spot check passes 1000 iterations under both
  defaults; commit/push authorized. Historical benchmark no-flag controls
  measured zcc's former default1; reruns of those harnesses must account
  for the new zcc default0 rather than expecting no-flag to match A.

## Whetstone/Dhrystone ABI comparison (2026-10-04)

- [x] Measure baseline/A/B/C at Os/O2 on the experiment compiler.
  All 16 cells pass correctness and completion checks; no-flag equals A.
  Whetstone: LOOP=10, II=1, math32; Dhrystone: 20,000 runs.
  Preserve Whetstone's module-6 loop and P3 calls in all cells.
- [x] Record sizes/cycles and fixed annotation policy in
  `llvm-z80/z80-utils/benchmarks/default-cc/RESULTS.md`.
  Raw evidence: `scratch/tmp/default-cc-whet-dhry-final-isolated.json`.
  180-second subprocess timeout and 500-million-cycle cap; neither hit.
  No compiler changes, commits or pushes in this extension.

## Calling-convention A/B plan (2026-10-04)

- [x] Write `tasks/plan-default-calling-convention-ab-20261004.md`.
- [x] Create `experiment-default-cc-ab-20261004` in llvm-z80 from
  `cdf7fbabe800`, without switching checkout during the ongoing build.
- [x] Implement driver/cc1 options and ABI fixtures; run final 32-cell matrix.
  Report: `llvm-z80/z80-utils/benchmarks/default-cc/RESULTS.md`.
  Final gates: clang 438 PASS / 6 SKIP; lit 155 PASS; SDCC ABI 174 PASS;
  z88dk 14/14 PASS. Two broader Rust unit-test failures remain documented.
  Work remains on the experiment branch; commit/push authorized below.

## LLVM-Z80 squash rebuild and tests (2026-10-04)

**Corrected run:** The first run below built upstream/main without the squash.
After updating local main to origin/main, `cdf7fbabe800` was rebuilt with
ccache/assertions (clang, llc, lld, opt, FileCheck and inspection tools).
Clang's version confirms that SHA. Runtime: 426 PASS, 6 SM83-only SKIP;
SDCC ABI: 174 PASS; lit: 154 PASS; active z88dk suite: all 14 scripts PASS.
Logs: `scratch/tmp/squash-{compiler,sdcc,z88dk}-tests.log`.
The earlier 11 target-triple failures do not occur with the squash build.

1. [x] Reconfigure `build-macos-asserts` using `Z80.cmake`,
   `LLVM_CCACHE_BUILD=ON`, assertions and the CommandLineTools environment.
   Verify ccache in actual Ninja compiler commands; rebuild clang, llc, lld,
   opt, FileCheck and assembler/object inspection tools at `24afb830878c`.
2. [x] Run compiler runtime and lit suites with the rebuilt tools.
   Clang runtime: 426 PASS, 0 FAIL, 6 SKIP (SM83-only inline asm on Z80).
   SDCC cross-compiler ABI runtime: 174 PASS, 0 FAIL, 0 SKIP.
   Runner lit: 141 PASS; additional Z80 Clang lit selection: 11 PASS.
   Logs: `scratch/tmp/rebuild-20261004-{compiler-tests,sdcc-tests,clang-lit}.log`.
3. [x] Run all 14 active z88dk integration scripts.
   3 PASS, 11 FAIL: every failing script reports that the compiler rejects
   `z80-unknown-none-z88dk` as an invalid target triple.
   No integration fix was made; rebuilding and measuring the failure set
   were the requested scope. The integration is not green.

## CP/M test-file isolation (2026-10-03)

1. [x] Identify producers by filename and payload in preserved test history.
   `ravn-main:test/clang/issue22_stdio_abi.c` writes `hello\n` to A.DAT;
   `issue23_fcntl_write.c` writes XYZ to WP.DAT. Both wrappers lack a cwd change.
2. [x] Demonstrate missing cwd isolation with a failing harness regression.
   `runtime_workdir.sh` failed on `runtime_float` before the cwd change.
3. [x] Restore these file-I/O fixtures on the active integration branch,
   isolate all active runtime wrappers, and verify cleanup on success/failure.
   Nine wrappers passed the injected success/build-failure/runtime-failure
   matrix. Both restored file-I/O fixtures also passed under real ntvcm.
4. [x] Run the real file-I/O tests and active suite; remove the four known
   leftover DAT artifacts after verifying their contents.
   All 14 scripts passed. The four leftovers matched their exact 128-byte
   payloads/padding before removal; the final suite recreated none of them
   and leaked no temporary directories.

## Plan: Genintegrer llvmz80-backend oven på upstream/master (2026-10-03)

**Mål:** gøre det eksisterende z88dk-arbejde for direkte `zcc
-compiler=llvmz80` brugbart oven på den nye upstream-baserede `master` med
mindst mulig overlap og uden at genindføre forkens gamle zpragma-scanner.

**Afgrænsning:** Bevar `ravn-main` urørt som historisk reference. Arbejd på en
ny lokal gren fra `master` (= `upstream/master`). Medtag kun ændringer, der
kræves for zcc/llvmz80-driveren, dens ABI/runtime-integration og tests/docs.
Uafhængige RC700- og øvrige forkændringer kommer ikke automatisk med.

1. [x] Færdiggør inventaret af backend-deltaet: zcc-driveren, ABI-headers,
   math32-arkivafhængigheder og målrettede tests/docs er nødvendige; upstreams
   zpragma og uafhængige RC700-/forkændringer er ikke. Hele `ravn-main` har 87
   patch-unike commits mod upstream, så en blind merge eller rebase ville
   trække uvedkommende arbejde med.
2. [x] Opret `reintegrate-llvmz80-on-upstream-20261003` fra præcis
   `upstream/master` (`e67ef86a93`); `master` og `ravn-main` står urørte.
3. [x] Port de relevante tests under `test/llvmz80`: zcc-target/TMPDIR,
   upstream-scannerdiagnostik, callback-ABI, math32 arithmetic/conversions/
   compares/libm, printf-autoformat og arkivafhængigheder.
4. [x] Port driver- og ABI-headerændringerne samt math32-arkivafhængighederne.
   Float-path bruger eksisterende math32-indgange med `--math32`; ingen nye
   llvmz80-broer eller scannerændringer blev indført.
5. [x] Bekræft de oprindelige baseline-fejl for TMPDIR/backendvalg og
   arkivafhængigheder. Kør derefter `make -C test llvmz80`: alle 11 tests
   bestod, herunder runtime-tests under ntvcm.
6. [x] Gennemgå ændringsomfanget. Upstreams scanner/Makefile er urørt; den
   dedikerede teststi er `make -C test llvmz80` og indgår ikke i standard-
   `test`-target. z88dk-koden er lokalt committet som `495db0b18a`; dette
   workspace-commit registrerer testarbejdet og submodule-pinnen. Ingen push.

**Bekræftet udgangspunkt:** `native-llvmz80-runtime-20261003` indeholder syv
arbejdskommits oven på den bevarede gamle master samt den seneste zpragma-
adoption. De syv dækker native math32, testflytning, NaN-test, symbol- og
printf-ABI-regressioner, testværktøjsopdagelse og runtime-verifikation.
Grundintegrationen (`-compiler=llvmz80`, ABI-headers, CRT/runtime og den
oprindelige testsuite) ligger allerede i den gamle fork-baseline, ikke i de
syv commits. Upstream har sin egen zpragma-scanner, `Makefile`-testtarget og
scanner-unit-tests; de skal beholdes. `runtime_printf_autoformat` findes
allerede under `test/llvmz80` på featuregrenen. `autoformat_nonliteral_note`
findes på den gamle gren og skal genafprøves mod upstream-scanneren før
eventuel portering.

## Replacing fork zpragma scanner with upstream (2026-10-03)

1. [x] Establish current behavior: fork scanner 67/67, llvmz80 printf
   autoformat PASS, and nonliteral diagnostic PASS. Upstream scanner also
   passes its 67-case unit test before adoption.
2. [x] Replace only `src/zpragma/zpragma.c` with `upstream/master`; retain
   zcc's llvmz80 `-autoformat` routing.
3. [x] Rebuild upstream zpragma into scratch and run both integration
   regressions against that binary; both PASS. Source and Makefile match
   `upstream/master`, `zcc.c` is unchanged, scratch outputs removed.

## Math32 test placement (2026-10-03)

1. [x] Place the llvmz80/math32 runtime, archive-dependency, target-triple,
   callback, and autoformat tests with their fixtures in `z88dk/test/llvmz80`.
2. [x] Add a dedicated runner and `make -C test llvmz80` entry point. The
   suite is intentionally separate from the default upstream tests.
3. [x] Document tool discovery and the test entry point; verify shell syntax
   and run all 11 discovered tests successfully. No benchmark scripts were
   added to this dedicated regression suite.

## Implementeringsplan: z88dk 2.5 math32 uden llvmz80-broer (2026-10-03)

**Mål:** verificere og færdiggøre `z80-unknown-none-z88dk`'s direkte brug af
z88dk math32 i den lokale 2.5-udviklingslinje. Ældre z88dk-versioner er
udtrykkeligt uden for scope. Brug `--math32` eksplicit i kommandoer og tests.

**Fast integrationskontrakt:** backend emitterer direkte kald til eksisterende
`cm32_sdcc_*`-indgange med `Z80_SDCCCall0`. De eksisterende runtime-adaptere i
math32 er tilladte; ingen nye wrapper-/bridge-symboler, filer eller arkiver må
tilføjes i llvm-z80 eller z88dk. Hvis en eksisterende entry mangler, stop og
registrér gap'et i stedet for at skabe en adapter.

1. [x] Registrerede revisions/dirty-state og byggede fire eksisterende
   baseline-programmer før ændring. De gemte pre-change `.COM`-filer passerede
   alle med `ntvcm -m:50`: float, fconv, libm og fcmp gav `ALL PASS`.
2. [x] Verbose zcc-link viser, at den direkte `--math32`-vej vælger
   `-lmath32` for +cpm/llvmz80 på den aktuelle z88dk-linje. Emit assembly
   kalder direkte `cm32_sdcc_*` for arithmetic/conversion/compare og de
   eksisterende `*_fastcall`-indgange til math32 libm.
3. [x] Opdatér alle relevante `test/clang` runtime-, smoke- og benchmark-
   invokationer til `--math32`, herunder `runtime_float.sh`,
   `runtime_fconv.sh`, `runtime_libm.sh`, compare-tests, `issue81_target_triple`
   og math32-vs-compiler-rt scripts. Fjern gamle float-bridge-påstande,
   bridge-afhængigheder og manuelle `-L/-lmath32`-valg.
4. [x] Udvidede arithmetic-oraklet med NaN/Inf i begge operandpositioner og
   ugyldige operationer. Math32-dokumentationen angiver canonical qNaN;
   denormaler understøttes ikke, og ingen ny denormal-semantik er antaget.
5. [x] Første special-value-kørsel gav 13 failures, fordi linkeren brugte det
   ignorerede `lib/clibs/math32.lib` fra 11. august, mens math32-assemblykilderne
   var fra 27. september. Math32-kernen blev genbygget fra aktuelle kilder;
   samme float-assembly genlinket mod det nye arkiv gav `ALL PASS`. Friske
   relinks af fconv, libm og strict/fast fcmp gav også `ALL PASS`. Ved
   genverifikation af printf-autoformat manglede `__stdio_printf_sign_0` i
   det installerede `cpm_clib.lib` fra 11. august. Genbygning af CP/M-arkivet
   fra de aktuelle kilder og genkørsel af den officielle zcc-test gav
   `PASS: stock printf("%f") auto-selects classic converters (no #pragma)`.
   zcc's hardcodede `/tmp`-stier blev i testværktøjet omdirigeret til
   `scratch/tmp`; ingen compiler- eller runtime-kilde blev ændret.
   Den manglende afhængighedsgraf blev også rettet: alle 13 math32-arkiver
   sporer nu de assembly- og `.lst`-inputs, deres recipe assemblerer. Den nye
   `test/clang/math32_archive_deps.sh` fejlede før Makefile-rettelsen og
   passerer nu for samtlige arkivvarianter; `make -W` genbyggede det primære
   math32-arkiv fra den simuleret ændrede assemblykilde. Den installerede
   `lib/clibs/math32.lib` blev synkroniseret byte-identisk med outputtet, og
   printf-autoformat runtime-testen blev genkørt og bestod igen.
6. [x] Ingen backend-mapping blev ændret; derfor ingen ny lit-test nødvendig.
7. [x] Opdaterede math32-testbeskrivelser og `--math32`-recipes.
   Historiske bridge-designnoter forbliver eksplicit historiske. Ingen commit,
   push eller PR.

## Removing implicit z88dk no-NaN contract (2026-10-03)

- [x] Observe lit and actual math32 comparison regressions fail before edits.
  Lit fails; 20 NaN input combinations fail, finite controls pass.
- [x] Preserve NaN semantics using existing classification entries only;
  retain the explicit nnan path and unchanged default-target behavior.
- [x] Rebuild assertion tools and verify all predicate shapes, NaN operands
  in either position, finite controls, and explicit nnan controls.
  Backend/MC/frontend lit: 150 PASS; runtime matrix O0/O2/O3/Oz PASS;
  no-honor-nans/fast-math finite controls PASS. Existing comparison,
  arithmetic and conversion scripts PASS.
- [x] Update current runtime integration documentation.

## Bounded emulation and utils investigation (2026-10-03)

- [x] Linked-list cause proven by independent direct/stale/rebuilt artifact
  comparison: stale elf2rel emitted _BSS, placing the pool at zero.
  Rebuilt unchanged converters restore 000F; all six link statuses were zero.
  Evidence: scratch/tmp/linked-list-analysis-20261003/analysis.txt.
- [x] Minimal strcmp C repro links before conversion, fails afterwards.
  Relocation at offset 0x7 changes from _strcmp to _strcmp__sdcc in rel2elf.
  Unconditional renaming predates current integration (7de40b8e5e19).
  Both test_66 linker errors share that missing symbol; REL additionally
  reports duplicate _memcmp/_strncmp across native and SDCC runtime archives.
- [x] Stop old full-suite runs that used 900-second emulator deadlines.
- [x] Observe 30-second policy regression fail at 900 seconds; reduce both
  emulator paths to 30 seconds and join output readers after kill/reap.
- [x] Actual JP 0 loop times out in both paths; positive halt/value control
  passes. Combined regression run completes in 30.01 seconds.
- [x] Observe failed REL link accepted with existing IHX, then reject nonzero
  status with diagnostics before emulation. Actual missing-symbol test passes.
- [x] Minimal strcmp conversion changes undefined `_strcmp` to
  `_strcmp__sdcc`; native runtime defines only `_strcmp`.
- [x] Guarded test_66 now reports two link FATALs, not emulator timeout.
- [x] Full utils Z80 finishes: 409 PASS, 0 FAIL, 2 FATAL, 7 SKIP.

Newlib and SDCC SM83 are outside the requested scope. Total suite duration
is not bounded by the per-emulator deadline. The original full/torture run
and subsequent broad runtime run were stopped; no complete full-suite PASS.
All new timeout/linker tests pass. Existing cleanup unit test
`keeps_dirs_owned_by_a_live_process` fails both parallel and serial;
no change to that unrelated implementation.

Commit/push subsequently authorized. Pre-commit recheck: Clang runtime
426 PASS / 6 SKIP, curated lit 153 PASS; Rust 5 PASS with the independently
observed existing cleanup failure explicitly filtered out.

Issue candidates, not filed:

- rel2elf unconditionally changes LLVM roundtrip symbols to __sdcc;
  native-runtime linking then fails. Minimal original-vs-roundtrip link and
  symbol/relocation output prove this. Existing #359 concerns a different
  archive-linking cause, not this renaming.
- macOS cleanup considers live processes dead: owner_is_running checks
  /proc/<pid> only; its own live-process unit test fails. This threatens
  concurrent runs by allowing active temporary directories to be deleted.
  No new implementation proposed or applied.

Duplicate searches in ravn/llvm-z80 and llvm-z80/llvm-z80 returned no matching
issue for either candidate; search absence is not proof of no duplicate.
Linked-list required only rebuilding stale converters, not a source fix.
No new issue proposed for the two mitigated runner failures in this commit.

Push encountered new origin commit c69f039b4fd7 registering the frontend
triple test. Merged --no-ff; observed lit fail on remaining stale fcmp,
conversion and double-add compiler-rt checks. Updated only Z88DK expectations
to the independently runtime-tested native math32 entries. All five frontend
RUN lines now pass; post-merge runtime 426 PASS / 6 SKIP and lit 154 PASS.

## Length-encoded z88dk symbols (2026-10-03)

- [x] Observe new lit regression fail and actual C link fail with duplicate
  `_test_counter` before changing the compiler.
- [x] Length-encode dotted names after LLVM prefixes; leave undotted names
  and non-z88dk output unchanged. Update existing checks and integration docs.
- [x] Cover references, definitions, aliases, private strings, empty parts,
  underscores, digits, multi-digit lengths and ordinary C controls in lit.
- [x] Rebuild assertions clang/llc/lld/opt/FileCheck; 145 Z80 codegen lit PASS.
- [x] Run C collision regression at O2/O3/Oz and complete z88dk suite:
  72 PASS, 0 FAIL, 0 SKIP, 1 existing tmpfile XFAIL.

Guarantee covers ordinary C symbols, not explicit user asm names.
Commit subsequently requested; no push requested.

## Removing synthesized-libcall CC stamping (2026-10-03)

- [x] Observe convention-preservation regression fail before removal.
- [x] Remove Z88DK-specific BuildLibCalls stamping without touching header ABI
  or direct native runtime calls; update integration decision.
- [x] Rebuild assertions tools; 144 codegen lit PASS and z88dk C no-fold/value
  regression PASS at O2/O3/Oz.

Existing C declarations and calls now retain C convention after InstCombine.
Non-C header calls remain blocked from printf-to-puts simplification.
No commit or push requested.

Pre-commit analysis (user subsequently requested commit): compiler default
launcher gives 426 runtime PASS, 0 FAIL, 6 SKIP; curated lit 152 PASS.
z88dk suite gives 71 PASS, 0 FAIL, 0 SKIP, 1 XFAIL.
An initial erroneous `run-llvmz80-tests.sh test` invocation selected a different
suite and reported 29 cross-compiler link failures; the documented no-argument
clang/lit entry point was then used successfully. No claim that the cross-
compiler suite passes. Remaining PR findings are outside this commit scope.

## C printf-to-puts regression (2026-10-03)

Final location per clarified user request: `z88dk/test/clang/runtime_printf_puts.c`
and `.sh`. The script selects `-compiler=llvmz80` explicitly and checks one
puts/one retained printf call plus exact runtime output at O2/O3/Oz, all PASS.
The format is constant, the result unused and the argument a dynamic pointer;
no builtin-disabling flags. The provisional LLVM-only test was removed.

Isolated-pass investigation: real header-generated input and output saved in
`scratch/tmp/printf-puts-real-{input,instcombine}.ll`. printf uses
z80_sdcccall0, puts uses cc129; InstCombine preserves printf. A C-convention
printf control with an already-correct cc129 puts declaration folds to cc129
puts. The block is `SimplifyLibCalls.cpp:4350` -> compatibility check in
`TargetLibraryInfo.cpp:66-95`, whose accepted cases exclude Z80 conventions.
User chose to retain this conservative ABI gate for initial integration.
The separate shared-declaration mutation repro remains valid.

Added `z88dk/test/clang/runtime_printf_puts.c` and `.sh`: real stdio headers,
direct puts followed by printf("%s\n", dynamic pointer), exact output and
one-puts/one-printf codegen assertions at O2/O3/Oz; all three levels PASS.
Initially tested for folding and observed RED; user clarified that different
calling conventions must block this optimization for now.
TLI's calling-convention compatibility check rejects the header's non-C ABI,
so the hand-authored C-convention IR repro does not demonstrate this folding
on the ordinary header path. No compiler fix made; the regression now protects
the intentional absence of this optimization and both runtime ABIs.

## Remaining review investigation (2026-10-03)

- [x] Reproduce frontend stale expectations and verify missing registration.
- [x] Reproduce symbol collision from ordinary C: global `example_counter`
  versus function-local static `example.counter`.
- [x] Observe dynamic ORD/UNO compile to constants on Z88DK without nnan;
  default-target controls call `__unordsf2`.
- [x] Reproduce e2e exit-0 SKIP with all three prerequisites present and valid
  LLVMZ80EXE, but no PATH clang.
- [x] Observe scope IDs change from 3 to 4 to 5 within one lexical block;
  downstream variable-visibility effects remain unverified.
- [x] Reproduce shared libcall declaration convention mismatch with isolated
  instcombine: pre-existing puts call stays C, declaration/new call become
  cc129. Codegen passes one pointer in HL and the other on the stack.
  New-declaration and default-target controls behave consistently;
  runtime impact and natural Clang-source reproduction were not tested.

Investigation only; C_LINE validation remains the sole pending compiler fix.

## C_LINE raw-string validation (2026-10-03)

- [x] Observe failing lit regression before implementation.
- [x] Reject quotes, LF and CR with explicit diagnostics in C_LINE operands;
  preserve raw backslashes and valid UTF-8, with ELF/line-zero controls.
- [x] Verify a real C filename diagnostic and full Z80 codegen suite:
  quoted filename fails with debug emission but compiles without it;
  all 144 codegen lit tests pass.

No escaping or z80asm parser changes; no commits or pushes requested.

## Cleanup: shared test setup and stale comments (2026-10-03)

- [x] Observe a failing discovery test before changing `test_env.sh`.
- [x] Centralize benchmark toolchain discovery; prefer assertions build,
  preserve compiler/build overrides and reject invalid explicit selections.
- [x] Update stale bridge/EXX/status comments without changing compiler ABI,
  C_LINE scope, symbol rewriting or finite-only policy.
- [x] Verify discovery controls, both triple-test prefixes and the complete
  z88dk suite: 70 PASS, 0 FAIL, 0 SKIP, 1 XFAIL (tmpfile), 125 seconds.

New `test_env_test.sh` uses fake tools to check discovery independently of
installed compilers. No build directories deleted; no commits or pushes.

## Review: cumulative native-runtime changes (2026-10-03)

- [x] Review llvm-z80 `main...HEAD`: ownership, target gating, ABI machinery,
  reuse and unnecessary special cases.
- [x] Review z88dk `master...HEAD` (its default branch) and workspace
  `main...HEAD`: test oracles, duplicated setup and stale documentation.
- [x] Report substantiated findings separately from optional cleanup;
  locate the existing C_LINE scope format in source.

Read-only implementation review; no compiler/runtime edits, commits or pushes.

Runtime review: no new adapters; production diff only removes the compare
object from `llvmz80.lst`. Toolchain discovery is duplicated in the two
benchmarks and omits the assertions build in the newly tracked `test_env.sh`.
The benchmark harness is tracked in the workspace, not the z88dk repository;
both benchmark headers still reference the removed `MATH32_BRIDGE.md`.
The integer fixtures cover distinct failure modes and should remain separate.
C_LINE's packed scope format is emitted in sccz80 `codegen.c:5412` and parsed
in ticks `syms.c:37-55`; no wiki claim was made.

Compiler review: native-call helpers and EXX/IX dependencies are justified;
no new runtime wrappers. Private-symbol `.` -> `_` rewriting is non-injective:
`@.str.1` and `@.str_1` both become `L__str_1`, independently reproduced with
assertions llc (exit 1: symbol already defined). LLVM C_LINE uses source line
as a lexical-block proxy, unlike sccz80's block counter; downstream variable
scope effects were not tested. Finite-only FCMP remains an unenforced target
assumption, not standard unrestricted NaN semantics. Some test/status comments
and e2e compiler discovery need cleanup. No implementation fixes made.

## Implementation: native z88dk runtime (2026-10-03)

- [x] Ret i16 quotient/remainder efter observerede røde lit/runtime-tests.
- [x] Integrer direkte i32-kerner med eksplicit EXX-liveness og IX-preservation;
  verificer small/fast-kerner med stackdata ved O0/O2/O3/Oz.
- [x] Bevar z88dk-headernes builtin calling conventions i frontend;
  verificer default-target-kontrol og bevaret builtin constant-folding.
- [x] Opdater begge benchmarks uden nye adaptere eller ændret måleprincip.
- [x] Dæk den resterende i8 Oz-sti med eksisterende native div/rem-kerne.
- [x] Forklar survey-timeout med måling: 91 builds tager 62,3s mod hardkodet
  60s. Ret watchdog-budget/rapportering uden ændrede oracle-forventninger.
- [x] Verificer begge root-launchers samlet efter sidste ændring:
  llvm-z80 426 runtime PASS/0 FAIL/6 SKIP og 151 lit PASS/0 FAIL;
  z88dk 69 PASS/0 FAIL/0 SKIP/1 XFAIL (tmpfile).

Lokalt committed efter brugerens anmodning:
llvm-z80 `8af124e7fab0`, z88dk `63a1cf7193`.
Ingen pushes, merges eller filings. Ingen nye bridges/wrappere.

Review: resultatregistre, EXX-afhængigheder, IX-preservation og frontendens
target-afgrænsning gennemgået; ingen yderligere bevist korrekthedsfejl fundet.
NaN/SM83 og surveyens LINK_ERROR-resultater er ikke dækket af runtime-beviset.

## Undersøgelse: z88dk suite FAILs (2026-10-03)

- [x] Reproducer de 13 FAILs med assertions-clang og gem fulde logs i scratch/tmp.
- [x] Reducer link-, integer- og stdio-symptomer til minimale reproer; følg faktisk IR/asm.
- [x] Adskil beviste årsager fra hypoteser og registrer resultater i integrationsplanen.
- [x] Udvid qsort-testcasen med uafhængig fixed-data callback-ABI-check;
  bevis positive og negative kontroller uden at skjule LCG-fejlen.

13 FAILs klassificeret: 7 builtin-ABI, 2 i16 quotient/remainder, 2 manglende
i32-integration og 2 forældede benchmarks. Qsort-callbacken passer både faktisk
stack/retur-ABI og fixed-data runtime-kontrol; LCG-inputdata fejler uden qsort.
Se `llvm-z80/tasks/plan-z88dk-native-runtime-2026-10.md` sektion 8.

Ingen nye bridges/wrappers, ændringer af eksisterende forventninger eller
compiler-fixes som del af denne undersøgelse.

## Plan: Systematisk genindførelse af tabte optimeringer (Z80 Code Density) (2026-09-14)

**Mål:** Lukke det resterende overskud på **143 bytes** i RC702 autoload-firmwaren (`INIT_SEM702=1` med skærmfont) så den fysiske 2048-byte grænse på 2716 EPROM (IC66) overholdes, ved systematisk at genindføre de optimeringer fra `ravn/llvm-z80`, der faldt ud ved upstream PR #40 / PR #296 merget (`cbaa9835043a`).

### Nuværende status & opnåede gevinster:
- **Baseline før genindførelse:** Rå `.text` = 3879 B; komprimeret PROM = 2366 B (+318 B over 2048 B).
- **1. Direct Global Addressing i ISel (`37f696f38ee5`):** `LD A,(nn)` / `LD (nn),A` direkte for globale symboler. Sparer 3 B pr. adgang. Resultat: `.text` -194 B, PROM -125 B.
- **2. Comparison Narrowing i ISel (`ce20d2bdf6b2`):** Snævring af 16-bit zext/sext sammenligninger til 8-bit `cp`. `_check_sysfile` alene faldt fra 98 B til 45 B. Resultat: PROM -47 B.
- **3. Peephole #116/#117 (`f93cacb36c02`):** i16 EQ/NE byte-XOR -> `AND A; SBC HL,rr` (3 B vs 6 B). Un-XFAIL'ede `issue-117-i16-eq-ne-neither-hl.mir`.
- **4. In-Memory INC/DEC (`354d14db1273`):** `LD A,(addr); INC/DEC A; LD (addr),A` -> `LD HL,addr; INC/DEC (HL)` (4 B vs 7 B). Resultat: `.text` -3 B, PROM -3 B.
- **5. Consecutive Stores #85 (`74b2f251529f`):** Folds >= 3 på hinanden følgende stores til en `LD HL,addr; LD (HL),n; INC HL...` pointer-kæde (sparer 4-6+ B). Testet i `store-chain-walk.ll`.
- **6. CP (HL) / SUB (HL) Load Fusion (`b86e19774a85`):** Fold single-use `G_LOAD` ind i `CP (HL)` og `SUB (HL)` i `emitFusedCompareAndBranch` og `G_ICMP`. Inkluderer `isHLPreferred` så pointere med HL-affinitet bevares i HL, hvilket frigør `B` til hardware `DJNZ` i `compare_6bytes` og `check_sysfile`. Resultat: `.text` -11 B (3425 -> 3414 B), payload 1950 B, PROM total 2069 B (21 B over 2048 B loftet).
- **Status nu (PARKERET 2026-09-16):** Rå `.text` = **3414 B**; komprimeret PROM = **2069 B** (21 B over 2048 B loftet). Samlet genvundet: **-465 B rå kode, -297 B komprimeret**. Lit: 249 PASS, 61 XFAIL, 0 FAIL. MAME boot & QR oracle: PASS.
- **Tilknyttede issues:**
  - `rc700-gensmedet#130`: `autoload-in-c: clang PROM build overflows 2048-byte EPROM ceiling by 21 bytes (2069 / 2048 B)`
  - `llvm-z80#331`: `Dynamic SP stack frame allocated for callee-saved scratch instead of direct PUSH/POP in non-static-frame functions` (Class 2 regression, ~19 B i `_fdc_read_result`)
  - `llvm-z80#332`: `-Oz miscompile: dynamic-SP-frame stack-argument read at wrong offset` (afsløret af `test_33_string_ops.c`)
  - `llvm-z80#333`: `G_ZEXT(G_LOAD i1) in 8-bit comparison blocks CP (HL) memory fold` (afsløret i `rom.c` `_floppy_legacy_boot`)

### Prioriteret eksekveringsplan for resterende optimeringer:

1. **Peephole #18 / #206 (Konstant-genbrug på tværs af alle GR8-registre)**
   - *Princip:* Når et 8-bit register (A, B, C, D, E, H, L) i en basisblok allerede holder en konstant `n`, erstattes en senere `LD r, n` (2 B, 7 T) med `LD r, r'` (1 B, 4 T).
   - *Test:* `llvm/test/CodeGen/Z80/issue-206-const-reuse-non-a.mir` er p.t. XFAIL. Fjern XFAIL, verificér at testen passerer efter genindførelse.
   - *Forventet gevinst:* 1 byte pr. forekomst.

2. **In-Memory Bit Set/Reset (`SET b,(HL)` / `RES b,(HL)`) (Issue #147)**
   - *Princip:* Mønstre `mem |= (1<<b)` eller `mem &= ~(1<<b)` foldes til `LD HL,addr; SET/RES b,(HL)` frem for `LD A,(addr); OR/AND; LD (addr),A` (sparer 3 bytes).
   - *Test:* `llvm/test/CodeGen/Z80/issue-147-set-res-mem.ll`.

3. **DJNZ-løkke transformationer (#185 / #221 / #92)**
   - *Princip:* Udnyt Z80's hardware-løkkeinstruktion `DJNZ` (2 B, 13/8 T) i stedet for `DEC B; JR NZ` (3 B, 16/11 T) eller `DEC A; LD B,A; JR NZ`.
   - *Inderste løkke prioritering (afgørende):*
     - Da Z80 kun har ét `B`-register, er det altafgørende, at den *inderste* løkke vinder `B` (højeste trip count / mest eksekveringstid).
     - Implementeres via `getRegAllocationHints`:
       - **Self-back-edge (inderste løkke):** Positivt hint om `B`.
       - **Latch til anden blok (ydre løkke):** Anti-hint for `B` (foretræk `D, E, H, L, C`), så `B` aldrig stjæles af den ydre løkke.
   - *Peephole:* `DEC B; JR NZ -> DJNZ` og `DEC A; LD B,A; JR NZ -> DJNZ` i `Z80PreEmitPeephole.cpp` (med liveness-guard på `FLAGS`).
   - *Test:* `llvm/test/CodeGen/Z80/djnz.ll`, `issue-92-nested-djnz.ll` og `issue-185-djnz-b-clobber.ll`.

4. **BSS-spill til PUSH/POP konvertering (Issue #74 / BSS-spill suite)**
   - *Princip:* I `+static-frame`/`+static-stack` gemmes registre i midlertidige statiske BSS-adresser: `LD (sym), HL; ...; LD HL, (sym)` (2 * 3 = 6 B). Når stakken er tilgængelig og uforstyrret, kan dette erstattes af `PUSH HL; ...; POP HL` (1 + 1 = 2 B), hvilket sparer 4 B pr. spill.
   - *Test:* `issue-74-bss-spill-no-call.ll` og tilhørende MIR-tests.

5. **Tail-call optimering (`CALL nn; RET` -> `JP nn`)**
   - *Princip:* Erstat `CALL nn; RET` (3 B + 1 B = 4 B) med `JP nn` (3 B). Sparer 1 B og 17 T-states.
   - *Krav:* Skal scopes så eksisterende lit-tests med eksplicitte `call; ret` forventninger ikke fejler (f.eks. ved at aktivere det specifikt under `-Oz` eller `-min-size` eller opdatere lit-tjek hvor semantikken er identisk).

---


**Observed state.** `issue-267-jr-out-of-range-textual.ll` currently fails
because its `CHECK-NOT: jr z,.LBB0_22` matches a short, in-range branch. The
same current object output contains a real far `jp nc`, and
`Z80InstrInfo::getInstSizeInBytes()` still accounts for the variable-shift
pseudos that caused the original #267 failure. The old test's label-specific
negative checks therefore do not prove an active range failure.

1. Capture the exact `.s`, object disassembly, and strict external-assembler
   result from the real `sf_fix` repro. Assemble through the same
   syntax-normalizing zcc/bridge path used in production: raw current llc
   output is not z80asm syntax on its own. Record each checked branch's byte
   displacement, not merely its label spelling.
2. Dump MIR immediately after `BranchRelaxation` and after every later
   branch-producing pass. Compare the reported pseudo sizes with the final
   expanded byte spans, including all post-relaxation expansion paths.
3. Audit the complete set of post-relaxation expansions against
   `getInstSizeInBytes()`, using the former drift-guard inventory as a
   checklist. Treat a missing/incorrect size as a separate candidate only
   when it demonstrably causes an out-of-range final branch.
4. Reclassify `issue-267-jr-out-of-range-textual.ll` under the PR #40 test
   drift tracker if all current textual branches are in range. Retain a
   range-sensitive regression oracle only when it proves a real out-of-range
   textual branch and is accepted by the external z80 assembler.
5. If step 1-3 finds a real out-of-range textual branch, produce a separate
   bug analysis with the responsible pass, exact MIR delta, and external
   assembler failure before selecting any repair.

## CP/M-86 Info-ZIP ZIP divergence (2026-08-25)

**PLAN for the way forward:** `infozip-cpm86-builds/PLAN_zip_deflate_mame_2026-08-25.md`
(goal: full-deflate ZIP.CMD valid on real MAME rc759). Current blocker =
deflate divergence, tracked as ravn/infozip-cpm86-builds#5. Fallback
(small-model STORE-only ZIP.CMD) already works on MAME.

- [x] Rebuilt the instrumented large-model ZIP and ran the same 3960-byte
  `POEM.TXT` input under emu2 and CCP/M/MAME.
- [x] Confirmed both runtimes' first input read is identical: 3960 bytes,
  followed by EOF; sampled input bytes at offsets 0/1000/2000/3000/3959 match.
- [x] Confirmed forcing `FOPW`/`FOPW_TMP` to binary does not fix the runtime
  failure. emu2 produces a 333-byte archive; CCP/M reaches
  `s=350, actual=349` and reports the compressed-size logic error.
- [ ] Isolate the zlib/runtime-state divergence before writing a fix or
  treating the binary-mode test as a runtime regression test. Next useful
  control: build the `CPM86_STORE_ONLY` ZIP and compare STORE-mode output on
  both runtimes; if STORE agrees, the fault is confined to deflate/zlib state.
- [x] STORE-only control completed: the same `POEM.TXT` archive passes under
  both emu2 and CCP/M/MAME. The failure is therefore confined to the
  deflate/zlib path or its large-model runtime state, not the common output
  FILE*/BDOS path.
- [x] Strengthened the BDOS 128 oracle (`test/memtest128.c`) with variable
  and partial-grant requests (`min<max`) plus full-block write/read checks.
  Real MAME reports `pass=4 fail=0`, and independent RAM-dump verification
  (`verify_memtest128_dump.py`) confirms all expected patterns.
- [ ] Continue ZIP runtime work from `zipcopy` failure: `window allocation`
  no longer reproduces after the BDOS fix; current blocker is temporary-archive
  write on the packed turnkey image (space/layout on A:), not fn128 contract.
- [x] **emu2 MCB pool now honours CPM86_TPA_KB at runtime, not just load time**
  (2026-08-25, `emu2-cpm86` commit `fe9dfb9`). Root cause of "emu2 never OOMs
  like MAME": `dos.c init_dos()` sized the whole free-memory pool ONCE at
  startup (~640 KB), independent of the loader's TPA cap — runtime BDOS-128
  calls (farheap `_fmalloc`) could always find room. Fixed by peeking
  `cpm86_detect()` before `mcb_init()` and shrinking the WHOLE arena to
  `CPM86_TPA_KB` for CP/M-86 programs. New `-m <kb>` CLI option (precedence:
  CLI > `CPM86_TPA_KB` env > 210 KB default) lets you dial the emulated TPA.
  **Calibrated: `-m 190` reproduces MAME's exact `Out of memory (window
  allocation)` message byte-for-byte**; default 210 instead fails one
  allocation later (`hash table allocation`). `memtest128`/`farheap_smalltest`
  regressions re-verified PASS on MAME + emu2 after the fix.

## NEXT SESSION TODO — complete CP/M-86 test coverage (user directive 2026-08-18)

- [ ] **Complete test coverage for the CP/M-86 port.** Current state (see
  the 2026-08-18 entries below): `build-owtests.sh` (Watcom's own
  `float01-04`) and `build-streamio.sh` (Watcom's own `iotest.c`) both
  PASS, on both emu2 and real MAME rc759. Still not run/covered this
  session: `build-diskio.sh` (661 round-trip checks, referenced as
  passing in `KNOWN_ISSUES.md` but not re-verified this session),
  `build-fscanf.sh` (672 checks), `build-cpp.sh` (C++ layer), the
  `handleio`/`file` clibtest groups (`chsize`/`dup2`/`umask` gaps listed
  in `KNOWN_ISSUES.md` #3 as still-blocked), `build-stdcbench.sh`,
  `build-whetstone.sh`. Re-verify all of these on sonnyboy (host-agnostic
  path patterns now established — see `build-owtests.sh`/
  `build-streamio.sh`'s `uname`-derived `PLAT` detection) and, where
  feasible, cross-check on real MAME rc759 using the harness in
  `reference_rc759_mame_sonnyboy_headless.md`. Then revisit whether/how
  to wire a `t_runcpm86` platform into Watcom's own `bld/clibtest/
  master.mif` (deferred this session — full clibtest coverage needs BDOS
  disk I/O the `cpm86run_unicorn.py` runner still doesn't implement, so
  MAME-only execution is the realistic path).

## NEXT SESSION START HERE (2026-08-18)

- [x] **Build the FULL Open Watcom toolchain** (not just bootstrap) — DONE
  2026-08-18. `./build.sh` (with real `dosbox` installed + `OWDOSBOX=dosbox`,
  needed for the WGML doc/browser-help stage) succeeded completely; the
  install/consolidation stage is `./build.sh rel` (separate from `build`),
  populating `rel/binl/` with the real `wcc`/`wcc386`/`wasm`/`wlink`/`wpp`/
  `wlib` and `rel/lib286/cpm86/` with the CP/M-86 clib. Verified by building
  `HELLO.CMD` with `PATH=rel/binl:$PATH`. Full details + gotchas:
  `tasks/memory/reference_openwatcom_full_build_linux.md`.
- [x] **Run Watcom's own correctness test suite against linux386** — DONE
  2026-08-18 with fixed `PATH`/`WATCOM`/`INCLUDE` (all pointing at
  `rel/binl`, `rel/h`). `wasmtest` + `ctest` fully PASS. CI's own recipe
  (`ci/buildx.sh` `"tests")`) runs each suite dir with `builder -i test`
  (ignore-errors, unlike my first plain `builder test` which aborted the
  whole run at the first `f77test` failure) — matches; f77test itself has
  a few pre-existing Fortran-frontend failures (1 `wfc` segfault + 2 real
  "branch outside control structure" diagnostics), unrelated to our work.
  `plustest`/`clibtest`/`mathtest` not run standalone (would need the
  same `-i` treatment); not pursued further — not relevant to CP/M-86.
- [x] **cpm86 as a tested platform: investigated + real progress** —
  2026-08-18. `cpm86` is absent from every Watcom test-suite platform
  table (`master.mif`s) and from `.github`/`ci/` entirely — genuinely
  needs new work, not something to "find and run". BUT: confirmed via git
  log that the rich CP/M-86 clib port (`contrib/ravn/watcom-cpm86-libc/`)
  is NOT lost — it's fully in git history/working tree AND was promoted
  to `bld/clib/_cpm/` as a first-class standard-build target
  (`bld/clib/builder.ctl` lines 45-50); today's `./build.sh rel` already
  produced a genuine 1123-module `rel/lib286/cpm86/clibs.lib` from it.
  Host-agnostic-ized (osxa64->uname-derived PLAT, matching
  `cpm86-clib/env.sh`'s pattern) two of the `watcom-cpm86-libc/*.sh`
  scripts:
    - `build-owtests.sh` — runs Watcom's OWN unmodified `float01..04.c`
      regression tests (`bld/ctest/positive/source/`) on CP/M-86.
      **ALL 4 PASS on Linux** via `contrib/ravn/cpm86run_unicorn.py`
      (needed a venv: `contrib/ravn/.venv-cpm86run`, `pip install
      unicorn` — system Python is externally-managed, see
      `reference_host_sonnyboy.md`).
    - `build-streamio.sh` — runs Watcom's OWN unmodified
      `bld/clibtest/streamio/c/iotest.c` (disk FILE* + console). Needs
      real disk I/O, which `cpm86run_unicorn.py`'s BDOS layer does NOT
      implement (console-only) — uses `emu2`
      (`/home/ravn/z80/emu2-cpm86/emu2`) instead. Compiles+links clean,
      but **FAILS at runtime**: `fgetc(fpr) != EOF` at iotest.c:577
      (a flush-related case), "Bad file number". Per
      `tasks/memory/MEMORY.md` this test passed before (commit
      `53aa9d29de`, macOS) — since `emu2` is under active development
      by the user to match the MAME CCP/M-86 oracle, this could be an
      `emu2` regression rather than a real clib bug; **needs a MAME
      cross-check to disambiguate**, not yet done.
  **MAME cross-check DONE 2026-08-18: CONFIRMED REAL BUG, not an emu2
  regression.** Stood up the full rc759 MAME harness from scratch on
  sonnyboy (none of it existed here before):
    - MAME's `rc759` driver + ROMs were ALREADY present/verified
      (`./mame -rompath roms -verifyroms rc759` -> good) — no rebuild
      needed. ROM source already documented at
      `mame/src/mame/regnecentralen/README.md:68-98`
      (`http://www.hampa.ch/pce/rom/rc759/`, URLs re-verified live).
    - No turnkey autostart disk existed on this host; booted a plain DDHF
      CCP/M-86 system disk instead (Bits:30002654 "CDOS systemdisk",
      `scratch/rc759-cmd-toolchain/ddhf-cache/`) via natkeyboard-injected
      `A` + `IOTEST`, headless (`SDL_VIDEODRIVER=dummy`, `-video soft` —
      `-video bgfx` fails under the dummy driver).
    - **Diskdef bug avoided while doing this**: `scratch/rc759-cmd-toolchain/
      diskdefs`'s `rc759-drc` entry still had the WRONG `maxdir 96/os 2.2`
      (the 2026-08-17 bug documented in
      `reference_rc759_official_drc_disk.md` — a `cpmcp` write with that
      geometry corrupts the real 512-entry directory, root cause of the
      ravn/mame-rc702-rc759-rc750#25 disk corruption). Used the canonical fixed `drc-rc759`
      (`maxdir 512, os 3`, `open-watcom-v2/contrib/ravn/owc-drc/diskdefs`)
      for the actual write instead, then FIXED `rc759-drc`'s content
      in-place in `scratch/rc759-cmd-toolchain/diskdefs` to match (same
      name, correct geometry) so other callers of that name are no longer
      a corruption risk. `scripts/rc759_make_mandel_b.sh` still uses the
      old name against a freshly-`mkfs`'d (not pre-populated) image — lower
      risk but not yet fixed; flagged, not yet done.
    - Result: `IOTEST.CMD` on real MAME rc759 hits the IDENTICAL failure at
      the identical line: `***WARNING*** Condition failed in (flushes) /
      fgetc(fpr) != EOF, line 577. / strerror(errno): Bad file number`.
      Same on both emu2 and cycle-accurate MAME -> genuine bug in
      `contrib/ravn/watcom-cpm86-libc/port/diskio.c`'s flush/reopen
      handling (or a real gap the streamio oracle catches), not an
      emulator fidelity gap.
  **FIXED 2026-08-18** (commit `3f815e6c53`, open-watcom-v2): root cause
  was that a pure-reader handle's OWN `BD_READRAND` is unreliable once a
  DIFFERENT still-open handle on the same file has written past what the
  CP/M directory (only synced at `F_CLOSE`) reflects — it can report
  "unwritten" OR, worse, SUCCEED but return STALE data, silently
  clobbering the correct copy already cached in the shared `dma[]` buffer
  from the writer's own write (this was the actual trap: an earlier
  in-session fix attempt routed the reader through the writer's FCB but
  then let a LATER read fall back to the reader's own FCB again, which is
  what produced the stale-clobber). `load_record()` in `port/diskio.c` now
  routes a pure reader ENTIRELY through the writer's FCB/cache, never its
  own, whenever an open writer exists for the same file. Verified PASS
  under BOTH `emu2` (`Tests completed (unzip).`) AND real MAME rc759
  (`A>IOTEST` -> `Tests completed (unzip).`, no warnings) — confirms it's
  a genuine fix, not an emulator-specific workaround. `float01-04`
  (`build-owtests.sh`) re-verified still green after the change.
  Next: consider wiring `t_runcpm86` into `bld/clibtest/master.mif` proper
  (scope TBD — full clibtest needs BDOS disk coverage the unicorn runner
  still lacks; MAME-only path now proven viable via the natkeyboard-
  injection harness in `reference_rc759_mame_sonnyboy_headless.md`).

## Current (2026-06-24, dcc-corpus three-compiler oracle)

- [x] **CP/M three-compiler oracle built** — `llvm-z80/z80-utils/compiler-zoo/cpm_zoo.py`
  compares dcc / clang / clangp / zsdcc over the dcc test corpus (raw codegen
  size + T-states + consensus verdict). clang CP/M runtime in `llvm-z80/z80-utils/cpm/`
  (crt0 + minimal libc + argc/argv tail parsing). Refs #35.
- [x] **clangp `+static-stack` recursion-gated** — `is_recursive()` (IR call-graph
  cycle check) drops static-stack on recursive tests; implements memory rule
  `feedback_static_stack_nonrecursive_only`. nqueens DIFF→AGREE.
- [x] **clangp `-disable-lsr` dropped** — confirmed stale (#232/#234); was the sole
  cause of clangp regressing vs clang (tqsort −38% speed). clangp now ties-or-beats
  clang everywhere.
- [x] **B17 — FIXED 2026-06-24** multi-byte `sbc a,a` carry-materialization.
  Root-caused (ISel models inter-limb carry as GR8; pseudo expansion round-trips
  via `sbc a,a;and 1` / `rrca`; AVR keeps it in CF -> Z80-backend gap, not a
  generic bug). New post-RA `Z80FuseCarryChain` pass threads carry in the flag
  for add/sub chains with a dead terminal carry. add32 −5 instr, i64 add −11;
  production byte-identical; lit 173+6, runtime 872 PASS, new lit + `test_224`.
  Writeup `llvm-z80/tasks/b17-fuse-carry-chain-2026-06-24.md`. NOT committed yet.
  Follow-up candidates (not done): fuse chains whose terminal carry IS observed
  (needs an `ADC_HL_rr_CI` flag-in/capture-out pseudo); the i32 `==0`/`<`
  comparison-boolean `sbc a,a` is a SEPARATE shape, still open.
- [ ] **IndVarSimplify SCEV closed-form → multiply libcall** (triangle n·(n+1)/2
  emits `mulsi3`/`muldi3`). Generic (AVR confirmed), NOT the size driver here, so
  low priority. Candidate for llvm/llvm-project — needs minimal repro + explicit
  go-ahead (`feedback_explain_before_filing`) before any upstream post.

## Earlier (2026-06-21, Z80 TTI modelling investigation)

Active queue, in priority order:

- [x] **Z80 TTI modelling holes 2026-06-21 — sweep CLOSED**
  (`llvm-z80/tasks/session-2026-06-21-z80-tti-modelling-investigation.md`).
  All five empirically tested:
  - [x] **#227** `getCmpSelInstrCost` — VERIFIED INERT (lit suite + synthetic + predictable-branch all byte-identical).  Held open at fork.
  - [x] **#228** `getCallInstrCost` — VERIFIED INERT (lit suite + call-heavy synthetic).  Held open at fork.
  - [x] **#229** `getIntImmCost` family — VERIFIED INERT (ConstantHoisting fires, regalloc dematerializes via `isReMaterializable`).  Held open at fork.
  - [x] **#230** `isLegalICmpImmediate` — VERIFIED INERT (LSR consumer is decline-only; GISel doesn't reach SDAG consumers).  Held open at fork.
  - [x] **#231** `Z80NarrowIV` predicate — pass doesn't exist; cpnos pain hypothetical.  Speculative-future at fork.
  Conclusion: cost-model fixes correct as model statements but downstream Z80-specific machinery already produces the right shapes.

- [ ] **Inverse analysis: Z80 machinery that would be better modelled (2026-06-21 continuation)**
  - [x] **#232 CLOSED WONT-FIX (2026-06-21)** Empirical A/B showed LSR is locally good (raw −1 B autoload / +2 B cpnos) but ZX0 compresses the LSR'd output worse (+13 B both). Outside TTI's expressive power — same class as #184. Writeup: `llvm-z80/tasks/issue232-lsr-sledgehammer-investigation-2026-06-21.md`.
  - [ ] **#234** (NEW from #232 investigation) Remove stale `-mllvm -disable-lsr` from rcbios Makefile — verified byte-identical no-op (5462 B both, instruction-level identical disassembly).  Tiny chore.
  - [ ] **#115 PARKED 2026-06-21** — user pivot to "3-pair set right for LDIR/DJNZ" first.  Examination complete: ~21 B recoverable (autoload 6 + rcbios 15), design sketch ready (HLReg/DEReg per BCReg precedent), full pickup runbook in `llvm-z80/tasks/issue115-iy-unreserve-investigation-2026-06-21.md`.  Implementation gated on the 3-pair-set pivot resolving.
  - [ ] **#233** Cleanup: fix mis-labelled "Vectorizer-only hooks" comment at `Z80TargetTransformInfo.cpp:38-44`.  Tiny chore; carry findings from #227-#230 into the comment.

- [ ] **Upstream 5-bug filings** — drafts 2/3/4/5 complete in `tasks/upstream-5bug/`,
  repros verified on llvm-project `de59f9ed`; each AWAITING per-filing user go-ahead
  (`feedback_explain_before_filing`). Bug 1 rerouted to ravn/llvm-z80#217.
- [ ] **ravn/llvm-z80#217** — Z80LoopIdiomFill violates `hasDedicatedExits()` caller
  contract; regression at HEAD. Fix plan (in issue): `formDedicatedExitBlocks` in the
  pass + revert the generic LoopUtils divergence + clang-shaped lit test.
- [ ] **Upstream packaging track** (after filings): #180 peephole-audit reviewability
  (~3-5 genuine stand-ins), #186 U-LLVM queue. Per session #74: only high-value
  compiler work remaining.
- [x] **PR #17 retraction cleanup COMPLETE** (verified 2026-06-07): fork issues
  #18-#25 closed/withdrawn, #176 closed, #26 + PR #27 remain (correctly scoped).
- PARKED: cpnos work awaits physical parallel cable (`project_cpnos_parked_awaiting_parallel_cable`).
- [x] **Investigate GDB-over-physical-RC702** (2026-06-17 → 2026-06-17 — first-pass done,
  see `rc700-gensmedet/tasks/gdb-z80-stub-findings-2026-06-19.md`).  Built z80-elf-gdb 17.2 in Docker; verified it reads
  our clang DWARF5 ELF (resolves `_bios_hw_init`, `_specc`, `_isr_crt` to addresses + 12
  source files).  MAME-gdbstub wire is already proven via `gdb_trace.py` (raw RSP) and
  `z88dk-gdb` (in our z88dk:2.4 Docker image).  Physical-hardware path: **Pi/Pico bus
  bridge** (recommended) — same hardware unblocks the parked INIR work.  Pre-existing
  scaffolding: `rcbios-in-c/run_mame.sh -g`, `gdb_trace.py`, `gdb_bgstar.py`.

Stale-item corrections to the sections below: #205 CLOSED (session 76, pattern-fill
intrinsic), #194 CLOSED (session 73s-cont2). #203 forward-scan restructure and the
~56 FATALs triage remain open, low priority.

## After session 73s cont. (differential oracles + #136/#202/#204, 2026-05-27)

DONE this session (all committed + pushed):
- [x] **#202 CLOSED** — cross-block BSS-spill->PUSH/POP dropped a loop-carried store-back;
  unified the loop-carried guard across all 4 spill peepholes.
- [x] **#204 CLOSED** — address-taken slot's store wrongly converted to PUSH (found by the
  native oracle); unified the address-taken guard across all 4 peepholes.
- [x] **#136 CLOSED** — "38 mystery O1 fixtures" root-caused (5-line repro, opt-bisect ->
  Z80LoopIdiomFill overlapping memcpy mis-inlined by InstCombine at -O1) and fixed with a
  one-line `volatile`. Production byte-identical; regression test_176.
- [x] **Two differential oracles built** (`test-runner -diff-opt`, `-native-oracle`) — now
  at a CLEAN baseline (0 DIFFOPT/0 NATIVE) in default + static-stack configs. SKIP-IF gained
  `+feature` support; test_36 skipped under +static-stack.
- [x] rc700#100 CLOSED (autoload banner check). IX un-reserve investigated + reverted; #12
  write-up filed.

OPEN / next:
- [ ] **#203 — unify the remaining spill-peephole guards** (orphan-access, cross-block
  UsedElsewhere [has #155 dominator relaxation], SP-write, stack-depth). The 2 *drifted*
  guards (loop-carried, address-taken) are unified; these are structurally embedded in each
  peephole's scan loop -> behavior-sensitive, not yet drifted into a bug. Lower priority.
- [ ] **#205 — non-UB representation for the LDIR-fill** (Z80LoopIdiomFill currently emits a
  volatile *overlapping* memcpy = UB-in-IR, un-exploited). K=1 -> memset (but a naive switch
  regressed -Oz across test_90/91 -- investigate first); K>1 -> target intrinsic / memset.pattern.
- [ ] **CI differential gate — PARKED** (user: not now). Design in
  `llvm-z80/tasks/ci-test-runner-differential-gate-PARKED.md`. Run locally meanwhile.
- [ ] **Triage the ~56 test-runner FATALs** (gates a clean exit-code CI gate): 50 = "no
  register value in emulator output" (huge test_90/91 fixtures at O0 -- emulator can't
  extract a result; harness/limit issue), 6 = test_48_dynamic_alloca missing `alloca.h`
  (test-setup; alloca under +static-stack is dubious anyway). Test-infra, not codegen.

## Open after session 73s (#198 + verifier triage, 2026-05-26)

- [ ] **#194 — surgical live-in fix for the cross-block #60 `LD A,r` removal.**
  Z80LateOptimization.cpp ~3874 removes a redundant cross-block `LD A,r` but leaves
  the using block's live-ins stale (gf_log `ADD_A_A` reads undefined `$a`). Benign at
  runtime. Blanket `fullyRecomputeLiveIns` is REJECTED (+2 B cpnos via aes_ar_cpy
  block-placement). Open path: path-limited recompute (def block .. reload block).
  Byte-neutrality plausible (the +2 B was aes_ar_cpy, not gf_log) — measure before
  committing. Verify: gf_log -verify clean, cpnos size unchanged, cpnos boot, lit,
  test-runner A/B.
- [x] **#201 — create-time GR16NoIR chokepoint — DONE 2026-05-26.** Constrained all 8
  GR16NoIR pseudos' operands to GR16NoIR at ISel; "Illegal virtual register" verifier
  class -> 0. Density default-config-favorable (cpnos 2036->2033, autoload 0, BIOS +1).
  Oracle green (lit 118+5, test-runner default byte-identical, cpnos boot PASS).
  Caveat: test_54_O0_ss FAIL->FATAL under +static-stack (pre-existing #192-class O0,
  non-production). Merged + closed.
- [ ] **Remaining -verify gates (#197) -- 2 of 4 cleared (2026-05-26):**
  DONE: illegal-vreg (#201 chokepoint), multiple-vreg-defs (tied INC16 fresh-dst --
  also fixed test_38_sort_search O1 miscompile). REMAINING: #194 (undefined-physreg
  liveins, ~74 -- delicate, multi-block recompute; blanket rejected +2B) and #200
  (SPILL_GR16 array/offset operand count, ~22 -- cosmetic, frame-lowering). Clear both
  -> flip the test-runner `-verify` flag to a blocking CI lane.
- [ ] **#200 — SPILL_GR16 array/offset operand-count cleanup** (cosmetic): model the
  2-operand resolved form to match the 3-operand declaration, or split the pseudo.
- [ ] **#197 — flip the test-runner `-verify` flag (landed) to a blocking CI gate**
  once #112/#189 + #194 + #200 clear (backend verify-clean at -O2).
- [ ] **#38 — IX/IY MIR cost model** (per-value shuttle-vs-spill). The big code-density
  lever; un-reserve IX/IY by default. Independent of the above; fresh focused session.

## IY un-reserve ("#38" lever) — MEASURED 2026-05-26, size-win / small-speed-cost

- [x] **Un-reserve IY gated on size-opt -- DONE + LANDED (2026-05-26).** Shipped:
  (1) BSS-spill->PUSH/POP SP-write guard (Z80LateOptimization) -- fixes the blocker
  AND a pre-existing latent miscompile (test_58_O0_ss +static-stack, #192-class),
  with an MIR regression test; (2) z80IsIYAllocatable(MF) = flag || (hasOptSize &&
  staticStack), threaded through getReservedRegs/getLargestLegalSuperClass/
  Z80NarrowNoIndex. Result: ~33 B production win at -Oz (cpnos 2033->2027, autoload
  1483->1478, BIOS 5920->5897), 0 undoc IY ops, gate precise (-O2 0 IY / -Oz 65),
  lit 119+5, test-runner default byte-identical + static-stack improved, cpnos boot
  PASS, autoload boots to A>. Speed reserved for -O2/-O3 (+0.11% IY-access cost).
  FLAG-gated history below kept for reference.
- [ ] **(superseded -- now DONE above) earlier blocked attempt:** Built a shared `z80IsIYAllocatable(MF)` =
  `Z80UnreserveIY || (hasOptSize && staticStack)`, threaded through getReservedRegs,
  getLargestLegalSuperClass, and Z80NarrowNoIndex. Gate works precisely: aes256
  -O2+ss = 0 IY operands (speed path untouched), -Oz+ss = 74; default (non-ss) suite
  byte-identical; production banks the win at -Oz with NO flag (cpnos 2025, autoload
  1478 comp, BIOS 5897 -- ~35 B). lit 118+5.
  **BLOCKER:** test-runner -static-stack caught a NEW miscompile -- test_58_fixed_point
  **Os_ss/Oz_ss** return 0x0037 vs 0x003F. test_58 uses NO IY itself, so it is a
  side-effect of the GR16NoIR-discipline machinery (Z80NarrowNoIndex / the
  getLargestLegalSuperClass no-widen) being activated at Os/Oz -- machinery that was
  only ever exercised under the off-by-default flag and has a latent bug (likely
  Z80NarrowNoIndex over-narrowing a vreg, or the no-widen reducing coalescing into a
  bad spill; matches the drill's "applied bluntly -> net-harmful" warning, and the
  "any vreg feeding COPY %x.sub_lo/.sub_hi" residual). REVERTED per no-commit-on-
  miscompile; production clang restored (test_58 Os/Oz pass again).
  **Next:** diagnose the test_58 Os/Oz miscompile under z80IsIYAllocatable (which vreg
  Z80NarrowNoIndex/the no-widen mishandles), fix, then re-run the gate + full oracle.
  Mechanism + ~35 B win are proven; only this residual correctness bug blocks the flip.
- [ ] **Do the same IX un-reserve analysis as IY (TO DO LATER, user 2026-05-26).**
  IX is the frame pointer when not +static-stack; under +static-stack it can be freed
  (hasFP=false had a parked runtime bug, #12). Measure size/speed of un-reserving IX
  the same way (per-function byte deltas + AES tstate), same size-vs-speed gating.
- [ ] **autoload `make mame` clang banner check is stale (found 2026-05-26).**
  EXPECT_BANNER for clang = "RC700 CL" (Makefile line 124) but the actual clang
  banner is "RC700 ROA375 CL", so the substring match always FAILs even though the
  autoload boots correctly to CP/M A>. Fix EXPECT to "RC700 ROA375 CL" (or match on
  "CL"). Codegen-independent; surfaced verifying the IY size-gate.
- [ ] **Look at the O0+static-stack hang later (user 2026-05-26).** NOTE: the
  test_54 hang context changed -- #201's chokepoint caused it; the IY size-gate
  keeps O0 reserved so it does not trigger there. Re-check whether it still occurs.
- [ ] **(orig) Look at the O0+static-stack hang later (user 2026-05-26).** test_54_unsigned_
  compare_O0_ss went FAIL->FATAL (timeout) under #201 + +static-stack -- a pre-existing
  #192-class O0 failure changing manifestation (wrong-value -> hang). Non-production
  (O0); production opt levels unaffected. Understand why it now hangs.

## Backlog (reinvestigate later)

- [ ] **Reinvestigate whether the EXX shadow register bank could be useful** (2026-05-26).
  EXX swaps BC/DE/HL with a second hidden copy (the shadow bank) in 1 byte. Prior
  work parked it: the shadow bank is a *context switch*, not addressable extra
  registers (EXX swaps all three pairs at once, so you can't hold a live value in
  one pair and reach the shadow of another) — see ravn/llvm-z80 **#7** and the
  modelled candidate in `llvm-z80/tasks/exx-candidate-analysis.md` (**#114**, the
  `_specc` shape: a u16 outer counter spilled across an inner no-CALL loop) +
  lit fixture `llvm/test/CodeGen/Z80/issue-114-exx-bracket-candidate.ll`.
  Why revisit now: the IX/IY un-reserve work (#189/#27/#112, session-73ab) made the
  "extra register pair vs memory spill" economics concrete (a register that costs a
  few bytes to reach can still beat a 3-byte BSS spill). The same lens applies to an
  **EXX bracket** — `EXX; <inner region where BC/DE/HL are dead-then-restored>; EXX`
  — which would give the inner region 3 fresh pairs for free *if* the bracket
  boundaries can be proven safe (all of BC/DE/HL dead across the swap, no CALL, no
  interrupt-shared state). Open questions to settle: (a) can the compiler identify
  such brackets reliably (the `_specc` outer-counter-across-inner-loop shape is the
  prototype)? (b) does it beat the current BSS-spill on size/speed? (c) interaction
  with `+shadow-regs` (currently only wired for ISR save/restore, "not yet functional
  for spill reduction"). Start from a measured drill on the #114 fixture, not theory.

  **REINVESTIGATED 2026-05-26 (measured drill on the #114 fixture, current llc):**
  Verdict — legitimate candidate, NOT fundamentally dead, but modest payoff and gated
  on a zero-sum tradeoff. Findings:
  - The fixture's spill shape still reproduces; the locked-in lit test passes.
  - **The EXX bracket sidesteps the original killer** (#7 finding "shadow not
    addressable / no encoding"): the bracketed inner region uses the MAIN bank
    registers normally (fully encodable); the shadow just invisibly holds the parked
    value across the region. So the encoding blocker does NOT apply to the bracket.
  - **Payoff is Tier-1 only (~6 B + 2 B BSS per qualifying loop).** Measured the inner
    loop: it already uses A+BC+DE+HL and BSS-spills `dp` every iteration because it
    wants a *4th* pair. EXX swaps all 3 pairs wholesale — it cannot hand the inner loop
    a 4th, so it does NOT eliminate the per-inner-iteration spill (my initial hope; the
    measurement refuted it). The only win is replacing the per-*outer*-iteration
    `ld (nn),bc … ld bc,(nn)` (8 B) with `EXX … EXX` (2 B).
  - **Hard blocker: shadow single-owner conflict with `+shadow-regs` ISR save/restore.**
    Calling conv `Z80_Interrupt_EXX_CSR` already makes ISRs save the interrupted context
    via EXX into the shadow bank. An ISR firing mid-bracket swaps the parked value into
    the main bank and clobbers it -> corruption on bracket-exit. The two uses are
    MUTUALLY EXCLUSIVE; only one owner of the shadow bank per build. All production
    firmware (autoload, BIOS, cpnos) has ISRs, so adopting EXX brackets means GIVING UP
    the 2 B ISR save (a real, shipped win) in exchange.
  - **Recommendation: keep parked.** Pursue only if a measured count shows many
    qualifying loops in a byte-critical target (cpnos PROM1) AND that target can cede
    the shadow bank from its ISRs. Lower priority than **#38** (IX/IY MIR cost model),
    which addresses the dominant BSS-spill bloat far more generally and without the
    single-owner tradeoff. The #114 fixture + this verdict stay as the durable record.

## Status: IX/IY reverted to reserved — CLANG BEATS SDCC

SDCC: 1910B | Clang: 1767B | Clang is 143B smaller (-7.5%)
BIOS: SDCC 5797B | Clang 5843B (+46B, +0.8% — was +64B before #66 fix)

## Session 13 (issue #66 — redundant BSS reloads, -18B BIOS)

Two waste patterns eliminated in `Z80LateOptimization.cpp`:
1. New peephole collapses `LD A,r ; PUSH AF ; LD A,r ; LD (addr),A ; POP AF`
   into `LD A,r ; LD (addr),A` (4 instances × 3B = 12B).
2. BSS load forwarding extended from MCSymbol-only to also track GlobalValue
   operands (C globals), with volatile-access guard. Eliminates store-then-
   reload of globals (2 instances × 3B = 6B).

Verified: 49/49 lit tests pass; BIOS shrinks 5861→5843B exactly as predicted;
no PROM regression. Submodule SHA bumped in superproject.

### Session 13 follow-ups (housekeeping)

* Combined this machine's local session-12 BIOS work with origin's session-12
  PROM work via `--no-ff` merges in both `llvm-z80` and the superproject
  (the two sides had been developed in parallel and were diverged on
  CLAUDE.md, `Z80LateOptimization.cpp`, and the test files).
* Brought `rc700-gensmedet` onto `main` (was sitting on `feature/iobyte`,
  7 commits ahead of `main` since session 10) via `--no-ff` merge.
* Brought `z88dk` onto its primary `master` branch (was in detached HEAD
  at `120cd6ec87`, equal to `origin/master` but with stale local `master`).
* New doc `rcbios-in-c/docs/serial_motherboard_uart.md` — how to use a
  native PC motherboard 16550 COM port instead of the FTDI USB-serial
  cable (same wiring; only `RC700_PORT=/dev/ttyS0` and `dialout` group
  need to change). Sibling to existing `serial_cable_wiring.md`.
* Parked todo in `rc700-gensmedet/tasks/todo.md`: investigate using an
  RP2040 / Arduino as a server for the Z80-PIO Channel A parallel port —
  same use case as the serial cable but with much higher throughput.

### Open: lit-test reproducibility on this Linux machine — issue #69 (to file)

> **Note:** issue #69 is *not yet filed* — `gh` is unauthenticated on this
> machine. A ready-to-paste draft for `ravn/llvm-z80` issue #69 is below
> under "Issue draft for #69".

Three lit tests failed on this machine but pass on the user's other
machine *at the same llvm-z80 SHA*:

1. `branch.ll`, `fib.ll`, `narrow-add-cmp.ll` — failed because at -O0 the
   functions sit right at the JR ±127-byte range edge; this machine's build
   produces them slightly larger so branch relaxation widens `jr` to `jp`
   and the `; CHECK: jr <cond>,` lines stop matching. **Mitigated** in
   `4f9d7b6` by relaxing the CHECK lines to `j{{[rp]}}`. Removes the
   fragility on every machine forever.
2. After merging origin, three *different* tests (`loop-counter-narrow.ll`,
   `bss-self-clear.ll`, `store-via-hl.ll`) fail in the same direction —
   this machine isn't picking up loop-counter narrowing / BSS-clear /
   store-via-HL peepholes that the other machine is. These are **not**
   relaxable; they show a real codegen difference at the same SHA.

Both observations point to a build-environment-dependent codegen
difference. Suspected causes (untested, see issue #69):

* `LLVM_ENABLE_ASSERTIONS` — this machine is built with assertions
  *off*. Toggling it via `cmake -DLLVM_ENABLE_ASSERTIONS=ON … && ninja`
  did not change the output, but ninja did not actually do a clean
  rebuild (only ~75 of ~3600 .o files recompiled, and `llc --version`
  still says `Optimized build.` with no assertions tag). A real test
  needs `rm -rf build && cmake … && ninja clang`, ~1.5 h on this box.
* Host C++ compiler version (this machine's GCC vs the other machine's
  Clang) producing slightly different LLVM binaries that pick different
  but deterministic choices in size-edge passes.
* Some other Release-build flag interacting with peephole ordering.

The session-12 BIOS/PROM end-to-end results are *not* affected — BIOS
builds at exactly the predicted size on both machines. The fragility
is confined to a handful of CHECK lines around size-edge peepholes.

#### Issue draft for #69

```
Title: Lit tests fail on Linux Release-no-asserts build at SHAs that pass on developer machine

At llvm-z80 main SHA 8f1e1d5 (and earlier 8f1e1d5's ancestors back at
least to 8896f598 "session 12: fix #58 JP→JR"), three lit tests fail
on a stock Linux Release build with assertions OFF, but pass on the
primary developer machine:

  LLVM :: CodeGen/Z80/loop-counter-narrow.ll
  LLVM :: CodeGen/Z80/bss-self-clear.ll
  LLVM :: CodeGen/Z80/store-via-hl.ll

These are *real* codegen differences, not test fragility. Example —
loop-counter-narrow.ll expects:

  ld   a,e
  cp   #7

but on the failing machine the function emits

  push af
  push af
  ld   de,#_buf
  ld   bc,#7
.LBB0_1:
  ld   l,c
  ld   h,b
  ld   a,l
  or   a
  jr   z,.LBB0_3
  …

i.e. the loop-counter narrowing peephole is not firing at all.

A separate, related fragility was found and fixed in 4f9d7b6:
branch.ll, fib.ll, and narrow-add-cmp.ll matched a literal `jr <cond>,`
on functions that sit at the JR ±127-byte range edge. The CHECK lines
were relaxed to `j{{[rp]}}` so either form is accepted, removing the
fragility.

Build environment on failing machine:
  - Ubuntu / Linux 6.17.0-20-generic
  - cmake from clang/cmake/caches/Z80.cmake (Release, no assertions)
  - LLVM_ENABLE_ASSERTIONS=OFF
  - Host compiler: GCC 15
  - llc --version reports: "Optimized build."

Suspected causes (untested):
  1. LLVM_ENABLE_ASSERTIONS=ON on the developer machine, gating
     code that has side effects on optimization decisions.
  2. Host C++ compiler difference (GCC vs Clang) producing slightly
     different LLVM binaries that pick different deterministic
     branches in size-edge passes.
  3. Some Release-build flag (LTO, PGO, NDEBUG-only paths) interacting
     with peephole ordering.

Reproduction:
  cd llvm-z80
  rm -rf build
  cmake -C clang/cmake/caches/Z80.cmake -G Ninja -S llvm -B build
  ninja -C build clang
  build/bin/llvm-lit llvm/test/CodeGen/Z80/

Expected: 50/50 pass.
Actual on this machine: 47/50 pass; the three above fail.

To investigate: clean rebuild with LLVM_ENABLE_ASSERTIONS=ON from
scratch (not just `cmake -DLLVM_ENABLE_ASSERTIONS=ON build` which
ninja does not propagate to all .o files). If that fixes it, the
peepholes have an assertion-side-effect bug. If not, swap the host
C++ compiler and rebuild.

End-to-end correctness is not affected: BIOS and PROM build to the
expected sizes on both machines.
```

## Completed

- [x] Phase 1: Direct global+offset addressing (-234B, 2352→2118)
  - `LD A,(sym+off)` instead of `LD rr,addr; LD A,(rr)`
  - Cascading: fewer spills → IX removal fires more
  - All 40 lit tests pass, MAME boot PASS

- [x] Comparison narrowing: i16 icmp through zext/sext → i8 (-12B, 2118→2106)
  - LLVM InstCombine widens i8 compares to i16 via zext/sext
  - ISel now looks through extensions for EQ/NE/unsigned/signed predicates
  - Applied in both materialized G_ICMP and fused compare-and-branch
  - All 40 lit tests pass, MAME boot PASS

- [x] **hasFP=false regalloc bug** (-72B, 2106→2034, FIXED)
  - **Root cause:** IX constant propagation peephole in Z80LateOptimization
    treated INC IX inside a loop body as a one-time adjustment (+1) to the
    initial LD IX,0. Replaced `PUSH IX; POP HL` (actual counter) with
    `LD HL,1` (constant), creating an infinite loop in `fdc_write_full_cmd`.
  - **Bisection:** Automated binary search over 25 non-ISR functions found
    `fdc_write_full_cmd` as the sole culprit in 6 rounds.
  - **Fix:** Check for back-edges (loop membership) in the INC/DEC IX handler.
    If the block containing INC/DEC IX has a successor with number <= itself,
    mark IX as non-constant to prevent folding.
  - **Files changed:** Z80LateOptimization.cpp (loop check), Z80FrameLowering.cpp
    (removed staticStack guard)
  - **Test:** ix-loop-const-prop.ll, all 41 lit tests pass, MAME boot PASS

## Remaining (prioritized)

- [x] Loop index→pointer conversion (-76B, 2025→1949)
  - Root cause was **Z80IndexIV pass**, not SROA. The pass converted
    pointer-increment GEPs (`gep ptr, 1` → INC HL, 1B) into base+index
    GEPs (`gep base, index` → LD HL,base; ADD HL,BC, 4+B).
  - Fix: skip Z80IndexIV when +static-stack is active (locals in BSS,
    not IX-relative, so IX+d indexed addressing has no benefit).
  - TODO: investigate whether Z80IndexIV helps non-static-stack code
    where IX+d indexed addressing is available.
  - Files changed: Z80IndexIV.cpp (static-stack guard)
  - All 42 lit tests pass, MAME boot PASS

- [x] PUSH/POP instead of BSS spills across CALLs (-8B, 2033→2025)
  - Post-RA peephole: LD (bss),A; CALL; LD A,(bss) → PUSH AF; CALL; POP AF
  - Conservative: only single store/single load pairs (multi-load re-PUSH
    caused stack interaction bugs between nested converted functions)
  - 2 instances fired: fdc_write_full_cmd, main_relocated
  - Multi-load pattern (fdc_seek, fdc_select: 2+ loads) deferred — needs
    investigation of stack depth interaction when multiple callers/callees
    are converted simultaneously
  - GR16 variant (PUSH HL/DE/BC) also supported but no instances in PROM

- [x] ~~OR (HL) / AND (HL) fusion~~ — not worth it, only 3 SDCC instances,
  clang's direct addressing is equivalent. Closed #12.

- [x] MAME boot test to verify PROM correctness (2026-03-27, SW1711-I8.imd)

- [x] Interleaved C source in clang listing (make clang_src_lis)

- [x] Investigate `clang -Weverything -c` on PROM sources — DONE: -Weverything default, zero warnings
- [x] ~~Experiment with HI-Tech C~~ — parked, not pursuing

## Remaining (prioritized)

- [x] Signed 16-bit comparison bloat (ravn/llvm-z80#19) — FIXED: -38B
  - `icmp sgt i16 X, 0` (and SLE X, 0) now uses branchless algorithm:
    non-negative mask (RLCA; SBC A,A; CPL) AND non-zero test (OR hi,lo)
  - Fused branch: 12B (was 34B). Materialized: 14B (was 30B).
  - Avoids the JP PO/JP P MBB split entirely — no MBB splitting needed.
  - PROM: 1944B → 1906B (-38B). Now 6B SMALLER than SDCC (1912B).

- [x] Multi-value BSS spill across CALL (ravn/llvm-z80#20) — partial: -5B
  - Fixed LIFO safety bug: PUSH/POP depth tracking prevents stack corruption
    when multiple spills convert in the same MBB
  - Fixed dangling PUSH bug: flags check moved before store replacement
  - Enabled multi-load re-PUSH: POP+PUSH after each load except last
  - Fired: fdc_select_drive_cylinder_head (2 loads, 5B), fdc_seek (2 loads,
    5B but gc'd — function inlined), main_relocated (1 load, 4B, pre-existing)
  - Net new savings: 5B (1949→1944)
  - Remaining unconverted: cross-MBB spills (wait_fdc_ready, verify_seek_result),
    cross-register (fdc_get_result_bytes: store BC, load HL)

- [x] +static-stack incorrect code in large functions (ravn/llvm-z80#29) — FIXED
  - Root cause: SPILL_IMM8 expansion in static-stack BSS mode clobbered A register
    without saving it. The pseudo has no implicit-def of A (correct for IX-indexed
    LD (IX+d),n expansion), but the BSS path uses LD A,imm; LD (addr),A.
  - Fix: check isRegLiveAt(A) and PUSH AF/POP AF when A is live, matching SPILL_GR8.
  - File: Z80RegisterInfo.cpp (eliminateFrameIndex, static-stack SPILL_IMM8 handler)
  - Edge-case tests: 25/25 pass (was 14/25), all 43 lit tests pass
  - Also expanded test generator with 4 inline test categories (31 total)

- [x] Multi-compiler comparison framework (compiler-zoo)
  - Python + Makefile framework comparing clang vs z88dk zsdcc
  - Uses PROM flags: +static-stack, +shadow-regs, -disable-lsr (clang);
    --allow-unsafe-read, --sdcccall 1, --max-allocs-per-node 1M (zsdcc)
  - Fair size comparison: CRT excluded from both compilers
  - T-states measurement via z88dk-ticks
  - Assembly listings with debug info (clang: -g + objdump -S, zsdcc: --fverbose-asm)
  - 10 benchmark programs from existing test suite
  - Results: clang wins 7/10 on size, zsdcc wins on 32/64-bit arithmetic
  - Found 4 clang correctness failures in large benchmarks (ravn/llvm-z80#30)
  - 3 distinct bugs identified:
    - Bug A: static-stack volatile spill/reload mismatch (PUSH vs BSS load)
    - Bug B: 32-bit arithmetic codegen (CRC-32 produces wrong result, not static-stack specific)
    - Bug C: infinite loop in string ops without static-stack
  - 4 zsdcc correctness failures too (div/mod, string ops)
  - Renamed edgecase-testing → test-gen, added --categories flag (31 cat files)
  - --full flag for including _cat_*.c files in comparison
  - Portable NOINLINE macro for cross-compiler category files
  - Fixed compare.py: z88dk-ticks -trace now pipes through tail -20 (prevented disk fill)
  - Fixed compare.py: z88dk:v2.4 → z88dk:2.4 tag

- [x] Build llvm-z80 clang natively on macOS (eliminate Docker for compilation)
- [ ] Get CLion remote development working for this project
- [x] Recalibrate DELAY_T for -Oz (or make delay() timing-independent) — DONE: delay_ms() macro + DELAY_T=16
- [ ] Build z88dk locally on macOS (eliminate Docker for SDCC builds)
- [ ] Simplify BIOS jump table IFDEF logic (REL14/REL20/HARDDISK conditional JP entries)
- [x] Clang PROM missing NMI handler (RETN) at 0x0066 — DONE: .nmi section in linker script
- [x] PROM delay() should take milliseconds — DONE: delay_ms(), z80_delay_ms() for SDCC
- [ ] Investigate how much code can be shared between autoload PROM and BIOS
- [ ] Investigate clang-only features (C17/C23, attributes) that could improve Z80 codegen
- [ ] Investigate if compare_6bytes could use CPI for more compact codegen
- [ ] Legacy boot reads to INTVEC_ADDR (0x7000) — assumes exactly 0x7000 bytes from disk. May be a latent bug if disk content differs
- [x] Investigate `clang -Weverything -c` on PROM sources — DONE: -Weverything default, zero warnings
- [x] ~~Experiment with HI-Tech C~~ — parked, not pursuing
- [ ] Per-pair 16-bit copy cost in register allocator (ravn/llvm-z80#27)
- [ ] Tail call blocked by PUSH in IY copy (prom1_if_present: PUSH DE; POP IY;
  CALL __call_iy; RET — HasPush check falsely blocks, 1B)
- [ ] `__attribute__((noreturn))` prevents tail-call JP optimization — start() calling
  noreturn main_relocated() emits CALL instead of JP, wasting 2 bytes (return addr push).
  Workaround: omit noreturn from declaration visible to caller.
- [ ] SDCC peephole rules not found at link time — `-custom-copt-rules=sdcc/peephole.def`
  fails because link step does `cd sdcc &&` making the relative path wrong

- [x] Boot banner missing (ravn/llvm-z80#51) — **FIXED** (asm BSS clear)
  - Root cause: +static-stack BSS self-clobber in relocate_bios()
  - Compiler stored p+1 pointer to BSS, then *p=0 zeroed the low byte
  - memcpy destination became $EB00 instead of $EB69, zeroing .rodata
  - Fix: inline asm BSS clear (no compiler locals → no BSS overlap)
  - Sentinel word (0x1842) added to linker script to catch future bugs
  - Bisected to commit 1fa0b125 (#45 direct addressing changed codegen)

- [x] SPILL_GR16/RELOAD_GR16 reject Anyi16 class (ravn/llvm-z80#52) — **FIXED**
  - getLargestLegalSuperClass returned Anyi16 (includes SP), spill pseudos
    only accepted GR16. Fixed by widening pseudos + restricting superclass.
  - Lit test: spill-regclass.ll

- [ ] +static-stack allocates trivially-constant locals to BSS (ravn/llvm-z80#53)
  - All locals go to BSS regardless of register pressure
  - SDCC only spills when needed — smarter approach

- [ ] Large function codegen incorrect without +undocumented (ravn/llvm-z80#38)
  - Original trigger (IX/IY allocation) fixed by reserving IX/IY
  - Banner manifestation (#51) was actually BSS self-clobber, not regalloc
  - May still have residual issues in other large functions

## Issues filed (ravn/llvm-z80)
- ravn/llvm-z80#19 — Signed 16-bit comparison bloat — **CLOSED** (branchless SGT X,0)
- ravn/llvm-z80#20 — BSS spill across CALL (~33B remaining: 5 functions)
- ravn/llvm-z80#21 — Redundant 16-bit loads for port I/O — **CLOSED** (source fix + peephole)
- ravn/llvm-z80#22 — 8→16 bit promotion in byte comparisons — **CLOSED** (narrow add+cmp through zext, -19B)
- ravn/llvm-z80#23 — Null ISR shadow-reg overhead (~4B)
- ravn/llvm-z80#24 — Missed RRCA/RET C conditional return — **CLOSED** (-6B)
- ravn/llvm-z80#25 — fdc_seek inlining bloat (~21B)
- ravn/llvm-z80#26 — IX callee-save transfer wastes bytes vs PUSH/POP — **CLOSED** (-4B)
- ravn/llvm-z80#15 — Loop index→pointer conversion — FIXED (Z80IndexIV disabled)
- ravn/llvm-z80#16 — PUSH/POP instead of IX-indexed spills (~8B remaining, was ~40B pre-optimization)
- ravn/llvm-z80#12 — OR/AND (HL) memory operand fusion (~10B)
- ravn/llvm-z80#17 — hasFP=false regalloc bug — FIXED
- ravn/llvm-z80#18 — Known-value register copy optimization
- ravn/llvm-z80#7 — DJNZ, LDIR, CPIR, CP (HL) (~7B from DJNZ in PROM)
- ravn/llvm-z80#27 — Per-pair 16-bit register copy cost (structural)
- ravn/llvm-z80#28 — O0 code generation failures in large functions
- ravn/llvm-z80#29 — +static-stack incorrect code in large functions — **CLOSED** (SPILL_IMM8 missing A save)
- ravn/llvm-z80#30 — Incorrect code in benchmarks: umbrella for #31, #32, #33
- ravn/llvm-z80#31 — Static-stack volatile spill via PUSH, reload from stale BSS
- ravn/llvm-z80#32 — 32-bit CRC-32: PUSH/POP IX copies corrupt SP-relative offsets (root cause found, fix reverted)
- ravn/llvm-z80#34 — Crash: passing i32 as function argument
- ravn/llvm-z80#33 — bench_string infinite loop without +static-stack
- ravn/llvm-z80#37 — Undocumented LD A,IYH emitted without +undocumented — **CLOSED** (SEXT16/SEXT_GR8/ZEXT_GR8 expansion fix)
- ravn/llvm-z80#38 — Large function codegen incorrect without +undocumented (layout-sensitive)
- ravn/llvm-z80#39 — IX constant propagation removes setup when +undocumented sub-reg reads present — **CLOSED** (IXH/IXL use detection fix)
- ravn/llvm-z80#51 — Boot banner missing (BSS self-clobber) — **FIXED** (asm BSS clear in boot_entry.c)
- ravn/llvm-z80#52 — SPILL_GR16/RELOAD_GR16 reject Anyi16 — **FIXED** (widen pseudos + restrict superclass)
- ravn/llvm-z80#53 — +static-stack allocates trivially-constant locals to BSS
- ravn/llvm-z80#54 — Fall-through JP elimination (6B)
- ravn/llvm-z80#55 — ADD HL,DE commutativity peephole — **CLOSED** (-6B)
- ravn/llvm-z80#56 — Shift-left-7 strength reduction — **CLOSED** (RRCA+AND, -4B)
- ravn/llvm-z80#57 — Comparison reversal peephole — **CLOSED** (-2B, post-RA)
- ravn/llvm-z80#58 — JP where JR suffices / branch relaxation — **CLOSED** (-4B, JP→JR in LateOpt)
- ravn/llvm-z80#59 — 16-bit loop counter where 8-bit suffices — **FIXED** (-2B, comparison only)
- ravn/llvm-z80#60 — Redundant LD A,reg when A unchanged — peephole implemented, 0B in PROM (cross-block)
- ravn/llvm-z80#62 — IV narrowing for loop counter register pair (4B)
- ravn/llvm-z80#61 — In-memory DEC (HL) / INC (HL) peephole — **CLOSED** (-6B)

## Parked (investigated, not worth pursuing now)

- [x] BIT n,A branch fusion — investigated, AND+JR patterns already efficient
  (same size as BIT+JR). The `xor $80; cp $40` pattern is a range check,
  not a single-bit test. PostRACompareMerge correctly handles redundant OR A.

- [x] 8→16-bit comparison promotion — this IS happening but the root cause
  is the loop index→pointer problem (Phase 2), not type legalization.
  The comparisons themselves are i8, but the loop counter and pointer
  arithmetic are i16 because of index-based GEP.

- [x] Known-value register copy / duplicate LD rr,imm (ravn/llvm-z80#18)
  - 0 instances in current PROM (eliminated by hasFP=false + direct addressing)
  - Revisit when working on rcbios-in-c (priority 2 test case)

## Metrics

| Date | SDCC | Clang | Gap | Change |
|------|------|-------|-----|--------|
| 2026-03-26 | 1912 | 2352 | 440 (23%) | baseline (post-merge) |
| 2026-03-27 | 1912 | 2118 | 206 (11%) | Phase 1: direct addressing |
| 2026-03-27 | 1912 | 2106 | 194 (10%) | Narrow i16 cmp through zext/sext |
| 2026-03-27 | 1912 | 2034 | 122 (6%) | hasFP=false: IX constant prop loop fix |
| 2026-03-27 | 1912 | 2033 | 121 (6%) | OR A; LD r,0 → LD r,A peephole |
| 2026-03-27 | 1912 | 2025 | 113 (6%) | BSS spill → PUSH/POP across CALLs |
| 2026-03-27 | 1912 | 1949 | 37 (1.9%) | Disable Z80IndexIV for +static-stack |
| 2026-03-27 | 1912 | 1944 | 32 (1.7%) | Multi-load BSS spill→PUSH/POP + LIFO fix |
| 2026-03-28 | 1910 | 1906 | -6 (-0.3%) | Branchless SGT X,0 optimization (#19) |
| 2026-03-28 | 1910 | 1893 | -17 (-0.9%) | DMA macro fix + high-byte peephole (#21) |
| 2026-03-28 | 1910 | 1874 | -36 (-1.9%) | Narrow add+cmp through zext to 8-bit (#22) |
| 2026-03-28 | 1910 | 1870 | -40 (-2.1%) | IX callee-save transfer → PUSH/POP (#26) |
| 2026-03-28 | 1910 | 1864 | -46 (-2.4%) | Branch-to-RET + RRCA/RLCA peepholes (#24) |
| 2026-03-28 | 1910 | 1872 | -38 (-2.0%) | COPY16_PUSHPOP pseudo for IX/IY copies (#32) |
| 2026-03-31 | 1910 | 1876 | -34 (-1.8%) | +undocumented, IX sub-reg const-prop (#37/#39) |
| 2026-03-31 | 1910 | 1853 | -57 (-3.0%) | Revert IX/IY allocation (#38), reserve both |
| 2026-04-01 | 1910 | 1842 | -68 (-3.6%) | #45 const-addr LD, #46 ptrtoint fold, #47 linker wrap |
| 2026-04-02 | 1910 | 1842 | -68 (-3.6%) | Fix #51 BSS self-clobber, #52 spill class. BIOS 5709B |
| 2026-04-02 | 1910 | 1842 | -68 (-3.6%) | Merge memcpy_z80 scroll, BIOS 5742B. TYPE 4.7% faster |
| 2026-04-02 | 1910 | 1842 | -68 (-3.6%) | CLion integration: __z80__ guards, MAME run configs |
| 2026-04-03 | 1910 | 1802 | -108 (-5.7%) | Native macOS build, delay_ms(), -Oz, dead code GC |
| 2026-04-03 | 1910 | 1791 | -119 (-6.2%) | Static inlining: fdc_seek, display_banner_and_start_crt |
| 2026-04-06 | 1910 | 1791 | -119 (-6.2%) | Gap analysis: 8 new issues (#54-#61), ~37B potential |
| 2026-04-06 | 1910 | 1789 | -121 (-6.3%) | Fix #59: narrow 16-bit loop compare to 8-bit CP (-2B) |
| 2026-04-06 | 1910 | 1785 | -125 (-6.5%) | Fix #56: SHL 7 via RRCA+AND (-4B) |
| 2026-04-06 | 1910 | 1779 | -131 (-6.9%) | Fix #55: ADD HL,DE commutativity (-6B) |
| 2026-04-06 | 1910 | 1777 | -133 (-7.0%) | Fix #57: comparison reversal peephole (-2B) |
| 2026-04-06 | 1910 | 1771 | -139 (-7.3%) | Fix #61: in-memory INC/DEC (HL) peephole (-6B) |
| 2026-04-06 | 1910 | 1767 | -143 (-7.5%) | Fix #58: JP→JR branch shortening (-4B), #60 peephole (0B) |

## Rejected: DMA-assisted screen scrolling

~~Am9517A memory-to-memory DMA for screen scroll~~ — **infeasible**: RC702 PCB DMA
channel wiring does not support memory-to-memory mode (ch0+ch1 are hardwired to
HD and floppy DREQ lines respectively, cannot be repurposed).

## Todo: Unified BIOS source across compilers

- Currently bios.c and other BIOS sources have several `#ifdef __clang__`
  / `#ifdef __SDCC` blocks for things like:
    - sio_wr5/sio_rd1 (clang uses port_out_rt, SDCC uses noinline split)
    - relocate_bios memcpy (clang uses __builtin_memcpy)
    - ISR helpers (clang uses bios_shims.s wrappers, SDCC uses inline asm)
- Goal: keep bios.c, bios_hw_init.c, boot_entry.c as pure portable C with
  no per-compiler `#ifdef`. Move all compiler-specific differences into
  per-compiler files (e.g., clang/bios_compat.h, sdcc/bios_compat.h)
  loaded via `-include` or via the Makefile.
- Builds on the "unified port I/O API" todo.
- Future work, not priority

## Todo: Inline ISR routines in clang to avoid wrapper CALL overhead

- Currently clang ISRs use a wrapper function (e.g., `isr_crt_wrapper`)
  defined in `bios_shims.s` that does register save/restore in assembly,
  then `call`s the C function `isr_crt`.
- This adds CALL overhead per interrupt: 3 bytes + 17 T-states for call,
  3 bytes + 10 T-states for ret.
- Investigate whether clang can inline the C ISR body directly into the
  wrapper, or use `__attribute__((interrupt))` directly so the C function
  IS the entry point (with proper register save/restore generated).
- Z80 backend supports `__attribute__((interrupt))` — check if it generates
  the right prologue/epilogue for IM2 ISRs that need to switch stacks.
- Future work, not priority

## Todo: Full debug info in SDCC BIOS build

- Currently SDCC produces `bios.lis` that's just the section layout asm,
  not a full instruction-level disassembly with source line annotations.
- The user found `bios.c.lis` in some other location with proper listing,
  but it isn't generated by the standard `make -C sdcc` flow.
- Investigate z88dk/SDCC flags to produce a complete listing showing
  source-line ↔ generated asm correlation, similar to what `clang -g +
  llvm-objdump -dS` provides.
- This would help debug compiler issues and verify codegen across compilers.
- Future work, not priority

## Todo: Unified port I/O API across compilers

- Currently port I/O for runtime addresses works only in clang (via
  the `__io` address_space(2) mechanism + #44 fix → OUT (C),A).
- SDCC has no clean pure-C way to do runtime port I/O — `__sfr` requires
  constant addresses. Inline asm helpers can't be `static inline __naked`
  without SDCC pasting the `ret` and breaking the caller (cf. session 12
  bug in sio_wr5).
- Code that needs runtime port selection (e.g., sio_wr5 picking SIO
  channel A or B) currently needs `#ifdef __clang__` per-compiler paths.
- Goal: design a `port_in_rt(p)` / `port_out_rt(p, v)` abstraction that
  works in both compilers in pure C, OR settle on a portable inline asm
  pattern that doesn't trip the SDCC inliner.
- Future work, not priority

## Todo: Comprehensive BIOS test suite via MAME

- Build a comprehensive test case exercising all CP/M BIOS jump table
  entries (BOOT, WBOOT, CONST, CONIN, CONOUT, LIST, PUNCH, READER, HOME,
  SELDSK, SETTRK, SETSEC, SETDMA, READ, WRITE, LISTST, SECTRAN)
- Run automated via MAME with deterministic assertions on results
- Cover edge cases: disk sector wrap, multi-track operations, console
  control characters, status polling
- Ideally generates pass/fail report like the autoload-in-c MAME boot test
- Future work, not priority

## Todo: PROM legacy ID-COMAL disk support

- Make the PROM work with legacy id-comal disks
- Need to investigate the id-comal disk format and what changes are needed
  in fdc_detect_sector_size_and_density / disk format tables
- Future work, not priority

## Todo: QR code on RC700 screen

- Display a QR code on the RC700 CRT using semigraphic characters (2×3 block mosaic)
- The RC700 character ROM includes semigraphic characters that divide each cell into a 2×3 grid of pixels
- Each semigraphic character encodes 6 "pixels" per cell, giving ~160×72 effective resolution on 80×24
- Need: QR code generator (C, must fit in PROM or CP/M .COM), semigraphic character mapping
- This is a future/fun project, not priority

## Todo: z88dk

- Add +cpmdisk support for RC700 to z88dk
- Add semigraphics character rendering support for RC700 to z88dk

## Todo: CONOUT speed

- [x] #50: memcpy_z80 — 16xLDI Duff's device for scroll() (MERGED)
  - 20% faster per-byte (16T vs 21T), 4.7% end-to-end on TYPE FILEX.PRN
  - Cycle test: 170.9M → 162.8M cycles

- Hardware scroll via split-DMA (from ROA375 PROM analysis):
  The original asm PROM uses **zero-copy hardware scrolling**:
  - Display buffer at DSPSTR (0xF800) treated as circular buffer
  - SCROLLOFSET variable tracks where visible screen starts
  - Ch2 (high priority): DMA from DSPSTR+S to end (2000-S bytes)
  - Ch3 (low priority): DMA from DSPSTR for wrap-around (S bytes)
  - 8275 CRT requests 2000 chars/frame; ch2 serves tail, ch3 serves head
  - Scroll = update SCROLLOFSET (one word write) — no memory copy at all
  - Requires ch2 number < ch3 number (Am9517A priority: lower ch = higher)
  - The C BIOS currently copies 1920 bytes per scroll (memcpy_z80)
  - Implementing this in C would eliminate scroll CPU cost entirely
  - Complications: insert_line/delete_line need to modify the circular
    buffer correctly; clear_screen resets offset to 0; cursor addressing
    must account for the offset
  - DMA channel assignments are now configurable (feature/dma-channel-config)

- DMA-assisted memory-to-memory scroll (alternative approach):
  - Am9517A memory-to-memory mode: ch0 (source) + ch1 (dest), software request
  - No DREQ lines needed — triggered by writing to request register (port 0xF9)
  - Would still copy memory but via DMA instead of CPU (frees CPU during copy)
  - Requires ch0+ch1 free during scroll (no concurrent disk I/O — safe in CONOUT)
  - Less benefit than hardware scroll but simpler to implement

## BIOS size gap analysis (session 12, 2026-04-06/07)

**Clang 5861B vs SDCC 5797B (+64B, +1.1%)**
Started at 5952B (+155B, +2.7%). Reduced by 91B through compiler + source fixes.

### Current per-function gap (post-fixes)

Clang larger (+395B total across these functions):

| Function | Clang | SDCC | Gap | Root cause |
|---|---|---|---|---|
| sec_rw | 287 | 115 | **+172** | BSS round-trips, struct access, 16-bit on 8-bit |
| bg_clear_from | 279 | 209 | **+70** | BSS round-tripping, register allocation |
| rwoper | 262 | 203 | **+59** | Duplicated sector-offset calc, BSS round-trip |
| bios_list_body | 70 | 33 | **+37** | |
| bios_conin | 90 | 73 | +17 | |
| bios_const | 42 | 28 | +14 | |

Clang smaller (-164B total): terminal group (-44), bios_hw_init (-42),
isr_pio_kbd (-23), isr_sio_a_rx (-23), isr_crt (-16), bios_seldsk_c (-10).

### Compiler fixes applied in session 12

| # | Fix | Savings |
|---|-----|---------|
| 62 | Constant fold G_PTR_ADD(GV, const) → LD rr,sym+off | -12B |
| 63 | SUB/AND/OR/XOR (HL) memory operand fusion | -15B |
| 64 | INC/DEC (HL) peephole: handle RET + fallthrough | -3B |
| 65a | DJNZ peephole: DEC A; LD B,A; [OR A;] JR NZ | -0B (no eligible BIOS loops) |
| 65b | G_UADDO/G_USUBO legal for i8 (prevent 8→16 widening) | -0B (BIOS loops use explicit cmp) |
| 68 | Prefer cascaded branches over jump tables for ≤7 cases | **-46B** |

### Source-level fixes applied in session 12

| Change | Savings |
|--------|---------|
| `cursorxy()` → static inline (11 call sites) | -11B |
| `hstsec`, `sekhst` word → byte | -3B |
| `serial_conout` timeout word → byte | -1B |
| `fdc_result` loop → pointer-based countdown | -0B |

### Remaining open issues

| # | Issue | Est. impact | Notes |
|---|-------|-------------|-------|
| ~~66~~ | ~~BSS static-stack SP-relative access~~ | ~~~30B~~ | **FIXED** session 12: SP-relative pattern + redundant PUSH AF/POP AF + global store-reload forwarding. BIOS 5861→5843B (-18B). |
| 67 | sec_rw 2.5x SDCC | ~50B | Compound of BSS reloads, missing idioms, regalloc |
| — | Register allocation pressure | ~30B | Clang spills more conservatively than SDCC |

The remaining 46B gap is now dominated by sec_rw (+172B) partially offset
by clang wins elsewhere (-164B − the -18B from #66).

## Todo: CLion debugger via MAME gdbstub

**Done (session #9):**
- [x] CLion fully indexes BIOS via `__z80__` guards (HOST_TEST removed)
- [x] .clangd: `-xc -std=c99 -Iclang -DMSIZE=56` + warning suppressions
- [x] 6 persistent run configurations in .idea/runConfigurations/
- [x] MAME GDB Stub run config (`run_mame.sh -g`)
- [x] Port I/O stubs use volatile (CLion doesn't assume constant zero)
- [x] bios_sources EXCLUDE_FROM_ALL (Build All doesn't try host compile)

**Remaining:**
- [ ] Build z80-elf-gdb from binutils-gdb for source-level debugging
  - `./configure --target=z80-unknown-elf` + `make all-gdb`
  - CLion Remote GDB Server: z80-elf-gdb + bios.elf + localhost:23946
- [ ] Fallback: enhance gdb_trace.py with pyelftools DWARF source mapping

## Todo: MAME DMA port assignment from emulated code

Currently MAME's RC702 driver hardcodes the DMA channel-to-device wiring
(which DREQ/DACK lines connect to which peripheral). Investigate whether
the emulated Z80 code can configure this dynamically instead:
- Can the Am9517A DMA mode register writes in MAME's 8237 emulation be
  observed to infer which channel is used for what?
- Does MAME's rc702.cpp wire DREQ/DACK lines at machine config time?
  If so, can this be made software-configurable?
- The RC702 hardware has fixed PCB traces for DREQ routing — the software
  can't change which peripheral triggers which DMA channel. But MAME
  emulation doesn't need to follow this constraint.
- Goal: allow the BIOS C code to use different channel assignments without
  also modifying the MAME driver source.

## Todo: MAME DMA port assignment from emulated code

Currently MAME's RC702 driver hardcodes the DMA channel-to-device wiring
(which DREQ/DACK lines connect to which peripheral). Investigate whether
the emulated Z80 code can configure this dynamically instead:
- Can the Am9517A DMA mode register writes in MAME's 8237 emulation be
  observed to infer which channel is used for what?
- Does MAME's rc702.cpp wire DREQ/DACK lines at machine config time?
  If so, can this be made software-configurable?
- The RC702 hardware has fixed PCB traces for DREQ routing — the software
  can't change which peripheral triggers which DMA channel. But MAME
  emulation doesn't need to follow this constraint.
- Goal: allow the BIOS C code to use different channel assignments without
  also modifying the MAME driver source.

## Todo: Sync MAME port map with BIOS port definitions

The MAME RC702 driver (`rc702.cpp`) hardcodes I/O port addresses in its
`io_map()` function (e.g. CRT at 0x00, FDC at 0x04, DMA at 0xF0). These
must match the `PORT_*` constants in `hal.h`. Currently they're maintained
independently — changing a port in one place requires manually updating
the other.

Investigate:
- Can MAME's rc702.cpp read port assignments from a shared header or
  generated file that's also used by the BIOS build?
- Or: generate the MAME io_map() fragment from hal.h at build time
  (e.g. a Python script that parses #define PORT_* and emits C++ map calls)
- Or: have the MAME driver read port assignments from the PROM binary
  itself (a configuration table embedded in the ROM)
- Note: DMA channel assignments (DMA_CH_*) affect which DREQ/DACK lines
  connect to which peripheral in MAME — this is separate from port addresses
  but also needs to stay in sync

## Todo: 26th status line via DMA split

Investigate using the ch2/ch3 DMA split to display a 26th status line
sourced from a separate memory region, without the 8275's 25-row limit:

- The 8275 CRT controller can be programmed for 26 rows instead of 25
- The DMA split (ch2 tail, ch3 head) could point ch3 at a status buffer
  located outside the 2000-byte display area at 0xF800
- The status line buffer must NOT overlap with the work area (0xFFD0+)
  or BSS variables
- Possible location: below display memory (e.g. 0xF750, 80 bytes)
  or in a gap between BIOS BSS end and the display buffer
- Content: drive letter, user number, current track, free space, etc.
- The circular scroll approach already uses the ch2/ch3 split — the
  status line would be a third segment. Check if this is feasible
  with only two DMA channels, or if the status line replaces the
  wrap-around (meaning the scroll buffer shrinks to 1920 bytes +
  80-byte status line = 2000 bytes, no wrap needed)
- Alternative: use the 8275's built-in "end of screen" row with a
  fixed DMA source address (simpler but may require 8275-specific setup)

## Todo: Circular display buffer via DMA split (zero-copy scroll)

The ROA375 PROM already does this — investigate implementing it in the C BIOS:

- Display buffer at DSPSTR (0xF800) is a 2000-byte circular buffer
- SCROLLOFSET tracks where the visible screen starts (0..1999)
- Ch2 (high priority): DMA from DSPSTR+S to end of buffer (2000-S bytes)
- Ch3 (low priority): DMA from DSPSTR for wrap-around (S bytes)
- Scroll up = add 80 to SCROLLOFSET (mod 2000) — no memory copy
- The isr_crt() already reprograms ch2/ch3 every frame at 50Hz
- Just needs to compute the split addresses from SCROLLOFSET

Impact on CONOUT:
- scroll(): set SCROLLOFSET += 80, memset new bottom row — no memcpy
- displ(): screen[locad] must account for circular offset
- insert_line/delete_line: need to work within circular buffer
- clear_screen(): reset SCROLLOFSET = 0, memset entire buffer
- cursor addressing: locad = (cury + curx + SCROLLOFSET) % 2000

Prerequisite: remove BGSTAR (background semigraphics overlay) support.
BGSTAR maintains a parallel 250-byte bitmap that shadows display memory
and must be scrolled in sync. With a circular buffer, keeping BGSTAR
in sync adds complexity for no practical benefit — BGSTAR is an RC702
demo feature, not used by any CP/M application.

Estimated speedup: eliminates 1920-byte copy entirely (currently 31950T
with memcpy_z80, would become ~100T for offset update + 80-byte memset).
That's ~99.7% reduction in scroll CPU cost.

## Todo: Build variants — compatible and fast

Two BIOS variants from the same source, each in its own output directory:

- `clang/` — compatible: all features (BGSTAR, memcpy scroll), drop-in
  replacement for original BIOS, 100% feature parity
- `clang-fast/` — optimized: circular DMA scroll, no BGSTAR, tuned for
  interactive terminal use (editing, compiling, TYPE)
- Same for SDCC: `sdcc/` and `sdcc-fast/`

Implementation:
- `VARIANT ?= compatible` (default) in Makefile
- `make bios` → `clang/bios.cim` (compatible)
- `make bios VARIANT=fast` → `clang-fast/bios.cim`
- Fast variant adds `-DFAST_SCROLL` to CFLAGS
- Source uses `#ifdef FAST_SCROLL` to select circular buffer vs memcpy
- Each variant directory has its own sub-Makefile (or shared with extra flags)
- MAME targets respect VARIANT: `make mame-maxi VARIANT=fast`

## Reference: z88dk-dis

Linear Z80 disassembler in z88dk Docker image. Reads `.map` files for symbol labels.
Usage: `z88dk-dis -mz80 -o 0x0000 -x sdcc/bios.map sdcc/bios.cim`
Limitation: no data/code distinction — disassembles everything as instructions.
The SDCC `.lis` files and `llvm-objdump -d` for clang are better for routine analysis.
Useful for quick spot-checks of specific address ranges in raw `.cim` binaries.

## Reference: Getting T-states from compiler output

### SDCC (via z88dk)
Add `-Cs"--fverbose-asm"` to ZFLAGS. This makes sdcc annotate each
instruction with its T-state count in the `.c.asm` intermediate file.
The `.c.asm` files are generated during compilation but may be cleaned
by z88dk. To preserve them, add `--list` to the final link step or
compile with `-S` to get assembly only.

Example: `zcc ... -Cs"--fverbose-asm" -S bios.c -o bios.c.asm`

### Clang (LLVM-Z80)
The clang Z80 backend does not emit T-state annotations.
Use the Z80 instruction timing table:
- LD r,r: 4T | LD r,n: 7T | LD r,(HL): 7T | LD (HL),r: 7T
- LD rr,nn: 10T | LD (nn),A: 13T | LD A,(nn): 13T
- OUT (n),A: 11T | IN A,(n): 11T | OUT (C),r: 12T
- LDIR: 21T/byte (16T last) | LDI: 16T
- PUSH: 11T | POP: 10T | CALL: 17T | RET: 10T
- JR: 12T (taken) / 7T (not taken) | JP: 10T

### z88dk-ticks
For measuring actual T-states of a code path, use z88dk-ticks
emulator with `-end` at the target address. See TICKS.md in
z80-utils/test-gen/.

## Reference: isr_crt timing analysis

The CRT display refresh ISR runs at 50Hz (every 20ms). Timing from
clang bios.lis instruction analysis:

| Section | T-states | Notes |
|---------|----------|-------|
| CRT status read | 11T | acknowledge interrupt |
| DMA ch2/ch3 mask | 36T | mask both channels |
| Clear byte pointer | 15T | |
| Ch2 addr + word count | 58T | DSPSTR=0xF800, 2000 bytes |
| Ch3 word count | 26T | zero (no attributes) |
| DMA ch2/ch3 unmask | 36T | enable transfer |
| **DMA subtotal** | **~198T** | |
| Wrapper (SP save, EXX) | ~40T | isr_crt_wrapper overhead |
| Cursor update (if dirty) | ~60T | 3 port writes |
| Timer/blanking logic | ~80T | clktim, screen blank |
| **Total per invocation** | **~320-380T** | |
| **Per second (50Hz)** | **~16,000-19,000T** | ~0.4-0.5% CPU at 4MHz |

With FAST_SCROLL (circular buffer): the DMA section grows by ~40T for
computing split addresses from SCROLLOFSET (negate, add, two address
sets instead of one fixed). Total ~360-420T per invocation. Negligible
difference — the ISR cost is dominated by the port I/O, not arithmetic.

## Todo: Make CONFI.COM settings configurable in BIOS source

Currently the CONFI.COM configuration block (128 bytes at disk Track 0
offset 0x80) controls serial port settings, cursor size/blink, keyboard
mapping, and other hardware parameters. The BIOS copies this block to
CFG_ADDR (0xD500) at cold boot and reads fields from there at runtime.

The defaults are hardcoded in boot_confi.c as a binary blob. Make these
human-readable and configurable:

- Map the full 128-byte ConfiBlock layout (which bytes control what)
- Define named constants/struct fields for each setting
- SIO configuration: baud rate, data bits, parity, stop bits, handshaking
- CRT cursor: size (underline/block), blink rate, visibility
- Keyboard: repeat rate, click, national character set selection
- DMA mode values for each channel
- Any other hardware parameters controlled by CONFI.COM

Goal: change a #define in the BIOS source instead of running CONFI.COM
on the target machine. The ConfiBlock struct in bios.h already has some
field definitions — extend it to cover all 128 bytes with documented fields.

## Todo: Remove unnecessary type casts in bios.c

Several variables store addresses as `word` instead of proper pointer types,
requiring casts at every use. Changing them to pointers removes casts and
improves type safety:

- `dskad` (word → byte *): DMA buffer address, flows into flp_dma_setup()
- `dmaadr` (word → byte *): CP/M DMA address, used in memcpy for sector I/O
- FSPA struct initializers: `(DPB *)&dpb0`, `(byte *)tran0` — align field types
- `(byte *)&rstab` at line 315 — use proper fdc_result_block pointer

Ripple: dskad/dmaadr changes affect flp_dma_setup (port writes take low/high
bytes), memcpy calls, and hstbuf indexing. Not trivial but straightforward.

## Todo: 26-line display with status line (feature/26-line-status)

Plan complete. Implementation in 3 phases:

- [ ] Phase 1: CRT26 flag + DMA split (ch2: 2000B display, ch3: 80B status from BSS)
  - Modify PAR2 in bios_hw_init.c (SUB 0x3F for 26 rows)
  - Add hal_dma_atr_addr macro to hal.h
  - Update isr_crt: program ch3 address+wc for status buffer
  - Add CRT26 build flag to Makefiles
  - MAME: should work without driver changes (8275 recompute_parameters)
- [ ] Phase 2: Status line driver (callback-based, clock display)
- [ ] Phase 3: Interactive status line (SystemRequest key menu)

See: rcbios-in-c/tasks/26-line-status.md

## Todo: Serial transfer to physical RC700

- [x] Serial transfer pipeline working (2026-04-05)
  - Linux + pyserial + RTS/CTS + per-line flush: reliable at 38400 baud
  - BIOS-only hex (363 records, ~24s) via MLOAD+BDOSCCP.COM workflow
  - 16-bit checksum validator, drain-to-empty RTS flow control
- [x] RTS flow control: drain buffer to empty before re-asserting (59 vs 5300 CTS drops)
- [x] macOS FTDI: confirmed broken tcdrain() — use Linux for transfers
- [ ] IOBYTE support in BIOS for remote console via serial
- [ ] Investigate 115200 baud (SIO WR4 clock mode change)
- [ ] Build proper FTDI↔RC700 cable (see rcbios-in-c/docs/serial_cable_wiring.md)
- [ ] macOS: investigate pyftdi for direct FTDI USB control (bypass kernel driver)
- [ ] Investigate serial communication optimization (Z80 struggles with per-character interrupts at 38400)
- [ ] Investigate switch vs if-then-else codegen for Z80 (IOBYTE dispatch adds 240B, may be reducible)
- [ ] Investigate if a PC with traditional RS-232 serial port works with current cable
  - The FTDI needs rtscts=True + per-line flush() on Linux
  - A real 16550 UART handles CTS in hardware natively — may just work with crtscts
  - Check if the mini adapter pinout is compatible with a PC DB-9 COM port

## Future / Fun

- [ ] Fast storage peripheral for RC700 — two approaches under investigation

  **Option A: Parallel port (PIO-A, DB-25) — simpler, no internal mods**
  - Z80 PIO byte mode: 8 data bits + hardware handshake (ASTB/ARDY), ~100-200 KB/s
  - Needs 5V-capable MCU (or Pico + 74HCT245/74LVC245 level shifters)
  - Protocol: command byte → LBA address → 128-byte sector transfer, PIO handshake paces each byte
  - MCU provides SD card storage, responds to READ_SECTOR/WRITE_SECTOR commands
  - CP/M side: custom block driver replacing or supplementing FDC
  - Reference projects:
    - **ParPortProp** (N8VEM/RetroBrew) — Propeller on Z80 PIO, provides SD+serial+keyboard
    - **Amstrad Symbiface** — external peripheral via PIO, IDE/CF storage
    - **Commodore sd2iec** — excellent command/response protocol design over parallel-like bus
    - **PC parallel ZIP/Jaz** (EPST/Shuttle protocol) — multiplexing over limited parallel interface
  - Hardware candidates: Pico + level shifters ($10 BOM), STM32F103 Blue Pill (5V tolerant inputs), Arduino Mega (native 5V)

  **Option B: Z80 bus via J8 connector — faster, full bus access**
  - J8 exposes complete Z80 bus (address, data, control signals)
  - Needs 5V-capable device responding within Z80 bus timing (IORQ/MREQ, WAIT)
  - Could appear as native I/O-mapped device, no PIO overhead
  - Reference projects:
    - **RC2014 CompactFlash** — CF in IDE mode, direct I/O port access (simplest)
    - **Z80-MBC2** — ATmega32A on Z80 bus with active WAIT generation, SD storage
    - **PropIO v2** — Propeller on bus, 5V tolerant, 8 cogs handle timing without WAIT
    - **RomWBW** — CP/M BIOS framework with drivers for IDE/CF/SD/PropIO
    - **NABU-LIB/CloudCP/M** — RP2040 on Z80 bus via 74LVC245 transceivers, PIO state machines
    - **Teensy-Z80** designs — Teensy + bus transceivers monitoring IORQ/RD/WR
  - Hardware candidates: FPGA (iCE40 + level shifters), RP2040 + bus transceiver, 5V-tolerant MCU
- [ ] QR code generator using semi-graphics (block characters for Z80 terminal output)
- [ ] Initialize custom character generator ROM (SEM702) from BIOS
  - Character generator defined in roa375/PHE358A.MAC
  - Some BIOS versions reprogram it at boot for custom character sets
- [ ] Prepare PROM1 (ROA327) binary for SEM702 character generator loader
  - load_chargen in autoload PROM expects a properly prepared PROM1 at 0x2000
  - Need to build/extract the correct ROM image with the right font data and bit order
- [ ] Printer support in the MAME rc702 driver so printer output is captured to a file
  - Purpose: capture LST:/printer output somewhere when SIO-B is NOT being used to drive
    debug I/O (currently SIO-B doubles as the debug/console channel; a real printer sink
    frees it and lets us verify programs that print)
  - Likely a printer/paper-tape device wired to the printer port, with a `-bitbN file` sink

## Plan: rc7xx-work#8 — Watcom-native float/double on CP/M-86 (RC759, no 8087)

### Goal & oracle (first priority = Watcom's OWN tests)
Prove Open Watcom's UNCHANGED float/double path runs on CP/M-86 through our thin
Layer-2 seam, using **Watcom's own float regression tests** (bld/ctest/positive/
source/float01–04.c, self-checking via fail.h/_PASS — an independent, Watcom-
authored oracle) as the primary proof. Whetstone is bonus only.

### Verified findings (KNOWN, this session)
- Watcom 8086 float == the 8087 EMULATOR. `-fpi`/`-fpc` both emit real 8087 ESC
  opcodes (fld/fadd/fmul/fstp, FWAIT-prefixed 0x9B). There is NO pure-integer
  softfloat in the 8086 clib. `fpuemu/i86/asm/emu8087.asm` is the pure-software
  interpreter (0 native 8087 opcodes) that executes the trapped ops.
- Dispatch: the ESC opcodes carry emulator FIXUP records. wlink (with emulation)
  rewrites FWAIT+ESC → INT 0x38–0x3D targeting emulator entries (FIARQQ/FISRQQ/
  FIDRQQ/FIWRQQ/FICRQQ/FIERQQ/FJ*RQQ, published by initemu.asm).
- Vector install is DOS-coupled: initemu.asm `xchg_vects` uses INT 21h (fn 35h/25h
  get/set-vector). **INT 21h is fatal here** — must be reseamed to a direct IVT
  poke (INT n vector lives at physical 0x0000:n*4; 0x38→0x00E0 … 0x3D→0x00F4; no
  clash with BDOS INT 0xE0 whose vector is at 0xE0*4=0x380).
- %f/%g needs the REAL formatter (setefg.c/dsetefg + mathlib efgfmt.c/ldcvt.c),
  pulled by the `_fltused` reference; the integer-only builds used the noefgfmt stub.
- Transcendentals (sqrt/sin/cos/exp/log/atan) live in mathlib/{a,c}; the -fpc
  interface symbols are IF@DSIN/IF@DSQRT/… .

### Make-or-break spike (do FIRST, cheap)
S0. Link a minimal `-fpi` float program as `format cpm86` with emu8087 + initemu
    (minus DOS init) and confirm the linked .CMD contains INT 0x38–0x3D (i.e. wlink
    cpm86 actually performs the emulator FWAIT→INT conversion) and NOT raw ESC.
    - If wlink cpm86 IGNORES emulator fixups → fall back: force `-fpc` calls +
      provide a non-ESC software FD library, OR patch fixups post-link. Re-plan.
    - Also confirm INT 0x38–0x3D vectors are free/writable under emu2 AND MAME
      rc759 (Concurrent CP/M-86) — spike a tiny vector-poke+trigger.

### Implementation steps (after spike is green)
1. **Emulator link closure** (fp-emu-link): compile fpuemu/i86 emu8087 + support
   (flda/fldd/fsld/normdw/… as pulled) for 8086; resolve the FIARQQ/FI*RQQ entry
   symbols. Empirical undefined-symbol loop (as in the stdio milestone).
2. **CP/M-86 emulator-init seam** (fp-vec-seam): new `port/emu87cpm.asm` (or .c)
   that installs the INT 0x38–0x3D vectors by writing the IVT directly (segment
   0, offset n*4 = emu entry), replacing initemu's INT-21h xchg_vects. Called from
   crt0/`__InitFiles`-analogue before first float op. Zero INT 21h.
3. **mathlib closure** (fp-mathlib): sqrt/sin/cos/exp/log/atan + real %f path
   (setefg/efgfmt/ldcvt + _uatof/_ustrtod if scanf-side needed). Resolve IF@DSIN
   etc. Keep -fpi so they route through the emulator too.
4. **Relink Watcom's own tests** (fp-owtests): compile float01–04.c with
   `-Dmain=owfloat_main` + a scbport-style driver that calls each, prints a single
   `FLOATtest: PASS`/`FAIL line N` marker (via the proven printf), returns count.
   Build script mirrors build-stdio.sh; purity gate asserts INT21h==0, INTE0h>0.
5. **Run-verify**: emu2 (expect zero `failure on line` output → PASS) + MAME rc759
   cross-check (mame_done score = error count, expect 0). Byte-oracle = the tests'
   own self-checks; independent of our seam by construction.
6. **Bonus** (fp-whet): double Whetstone driver with known-value oracle (T=0.499975
   etc.) for an RC759-comparable float score vs DR C.
7. **Docs**: README float section + memory note; mark #3 "retired on the Watcom
   route" and update #8 acceptance boxes when green.

### Risks
- R1 (highest): wlink cpm86 may not emulate fixups → spike S0 gates everything.
- R2: INT 0x38–0x3D may be reserved by Concurrent CP/M-86 XIOS → may need a
  different free vector range; the emulator INT numbers are compiler/linker-fixed,
  so a clash forces a post-link fixup remap. Verify in S0.
- R3: emulator may reference a DOS control-word/init symbol beyond xchg_vects
  (__dos87emucall/__8087cw) — audit initemu/dosinit; provide CP/M stubs.
- R4: emu2's own float handling — must confirm emu2 does NOT silently provide an
  8087 (would make emu2 PASS while real HW fails). MAME rc759 is the true oracle.

## TODO (later): exploit 80186 instructions for codegen (rc7xx-work, Watcom CP/M-86)
The RC759 CPU is an 80186, so the whole toolchain currently building with `-0`
(pure 8086) leaves the 80186's extra real-mode instructions on the table. Build
the retargeted Watcom clib + user code with `-1` (186/286 integer set: shift/rotate
by immediate, IMUL r,imm, PUSH imm, PUSHA/POPA, ENTER/LEAVE, BOUND, INS/OUTS) to
improve density/speed on compute-heavy code — e.g. the Mandelbrot / fixed-point
inner loops. Verify on cycle-accurate MAME rc759 and confirm the purity gate stays
green. (Raised 2026-08-15 while confirming that Watcom's prebuilt msdos.286 math
objects use 0 286-protected-mode opcodes and thus already run on the 80186.)

## TODO: Diagnose CCP/M versus emu2 ZIP divergence (2026-08-24)

**Status: completed.** CCP/M-86 on real RC759 MAME is the
authoritative oracle; emu2 is a differential/debugging oracle only.

1. **Freeze the current evidence.** Record the exact ZIP binary, CMD header,
   linker map, disk images, MAME binary, emu2 commit, command line, and complete
   outputs already produced. Do not regenerate artifacts in this phase.
2. **Define one minimal repro.** Use one input file and one command that fails
   under CCP/M but succeeds under emu2. Keep the ZIP binary, command tail,
   disk geometry, and input bytes identical; use fresh copies for each run.
3. **Locate the first divergence.** Determine whether CCP/M rejects the CMD
   before `main`, whether startup reaches `main` and fails in far-heap/BDOS,
   or whether ZIP writes a malformed archive. Capture the CCP/M error text,
   a completion signal or crash address, and guest RAM/loader state where
   possible.
4. **Cross-check independently.** For any archive produced, verify it with the
   host `unzip -t` and Python `zipfile`, and compare the input/output bytes.
   Compare emu2 and MAME only after the independent host oracle passes.
5. **Test hypotheses one variable at a time.** Candidate classes are CMD
   header/loader reservation, G_MIN/G_MAX far-heap accounting, large-model
   segment pointers, BDOS FCB/DMA semantics, and ZIP's own deflate path. Change
   only one variable per run and preserve every result.
6. **Only after confirmation, fix at the owning layer.** First add a regression
   test that fails on the confirmed bug; then make the smallest fix, rerun the
   CCP/M oracle and emu2, and update the ZIP plan/memory notes with the verified
   root cause. No upstream issue or commit is part of this diagnosis phase.

Initial result was withdrawn after fresh CCP/M runs reproduced the same
post-deflate mismatch despite binary output mode. The binary-mode test is
therefore only a source guard until the runtime cause is proven.

### Re-plan after failed verification (2026-08-24)

The preceding result is withdrawn as unconfirmed: fresh CCP/M runs still
produce `s=318, actual=319`. The value pair proves only that ZIP's compressor
count and `bytes_this_entry` diverge; it does not prove CRLF conversion.

1. Freeze the failing binary, disk, input bytes, MAME command, and snapshot.
2. Add one diagnostic at the owning seam that records each `bfwrite()` call's
   requested count, `fwrite()` return, mode, and cumulative entry count. Make
   the diagnostic visible in the guest screenshot or a guest disk log.
3. Run a four-case matrix without changing the libc: `-0`/STORE versus
   deflate, input with and without LF, and output to a fresh archive. This
   separates compressor accounting from FILE*/BDOS behavior.
4. Independently compare `fwrite()` return values with `ftell()` and the BDOS
   random-record calls. Identify the first call where the cumulative count
   changes by one.
5. Only then write a regression test for that exact seam, confirm it fails on
   the frozen binary, and make one owning-layer fix.
6. Re-run CCP/M, emu2, and host `unzip`/Python byte checks. Remove diagnostic
   code and update the reference note only after all three oracles agree.

---

## Plan: z88dk + llvm-z80 — bryde igennem post-PR#40 (2026-09-24)

**Mål (bruger 2026-09-24):** få z88dk til at virke korrekt med llvm-z80 som
backend. Fokus lige nu: lande det store upstream-arbejde (`llvm-z80/llvm-z80`
PR #40 "z88dk calling conventions + llvmz80-23.1.0-r1", merged 2026-09-08)
solidt igennem hele stakken (llvm-z80 -> z88dk zcc/bridges -> RC700-firmware).

### Overblik (fund fra denne session)

1. **`upstream-all-prs`** (ravn/llvm-z80) er den gren brugeren mente: den er
   bygget oven på `llvm-z80/llvm-z80`s (zlfns) EGEN historik (merge-base helt
   tilbage til LLVM's `cvs2svn`-rod), med alle indsendte/mergede PR'er
   (#41-48, #346, #357, #267, #359 osv.) lagt ind, som om de allerede var
   accepteret der. Den er 39 commits foran, men 1157 bagud ift. `main` (fordi
   `main` er den langt mere aktive ravn-arbejdsgren rebaseret på fuld LLVM
   monorepo). Brug den til at se "hvad ville zlfns upstream se ud som hvis alt
   blev taget ind" — ikke som base for videre arbejde.

2. **PR #40-mergen (2026-09-08) var stor og gav massivt fallout**, dokumenteret
   i `llvm-z80/tasks/plan-pr40-fallout-recovery-2026-09-10.md` (R1-R5) og
   `analysis-autoload-over-2kb-after-pr40-2026-09-16.md` (Class 1/2
   kodedensitet). Status pr. seneste commits (21/9):
   - R1 (memset.pattern legalisering) — genskabt.
   - R2 (Z80-builtins/intrinsics ulegaliserede — PRODUKTIONSKRITISK, ramte
     rcbios' `__builtin_z80_*`) — genskabt (#42/#4 virker igen ifølge
     CLAUDE.md "Working LLVM-Z80 features").
   - R3 (`-z80-unreserve-iy` omdøbt) — håndteret.
   - R4 ("Found 2 machine code errors" i64/i128/arith-i32) — root cause
     fundet (static-frame inert), fix landet, se seneste workspace-commit
     `d333fdc`.
   - R5 (26 lit-CHECK-drift) — løbende oprydning i commits frem til 21/9
     (XFAIL-triage, C-source blocks til regressionstests, MachineCSE
     genaktiveret).
   - Class 1 (static-frame inert, +975 B på autoload) — RECOVERED.
   - Class 2 (regalloc spilder call-krydsende loop-værdier til SP-frame i
     stedet for callee-saved push/pop) — delvist genskabt (Fase 2b landet,
     Fase 2c falsificeret, #331 lukket 17/9). Autoload-PROM er derfor
     midlertidigt sat til 4 KB cap i stedet for 2 KB (se
     `tasks/memory/project_rc702_2kb_prom_hard_limit.md`).

3. **z88dk-siden havde SIN EGEN fallout** fra samme merge: seneste 3 commits
   på `z88dk` master er `e55cbbf4b1` "restore zcc ABI glue",
   `0ebc2e4c12` "correct byte division bridge ABI", merged via
   `fix/llvmz80-zcc-abi-recovery` (2026-09-19/20). Dvs. calling-convention-
   ændringerne i llvm-z80 PR #40 brækkede zcc's bro-lag (ABI-antagelser om
   register-placering af returværdier m.v.), og det er kun DELVIST
   genoprettet.

4. **KRITISK GAP — ingen CI-verifikation af noget af dette:**
   - `llvm-z80` GitHub Actions (`z80-ci.yml`) har IKKE kørt på en `push` til
     `main` siden **2026-06-06**. De nyeste `workflow_dispatch`-kørsler
     (12/13. juli) står stadig som "queued" 1700+ timer senere — reelt i
     stykker/aldrig eksekveret. Hverken PR #40-mergen (8/9) eller de 10+
     dages fallout-recovery (10-21/9) er nogensinde kørt gennem CI.
   - Lokal build (`llvm-z80/build/`) er fra **2026-06-29** — ældre end PR
     #40-mergen. `llvm-lit` crasher direkte (`lit.cfg.py` bruger
     `config.osx_xcrun` som CMake-cachen ikke satte) — build-config er
     forældet ift. kildekoden. **Der findes ingen frisk, grøn build at måle
     "164 PASS + 6 XFAIL"-påstanden i CLAUDE.md imod lige nu.**
   - `z88dk`s `build-mingw-on-ubuntu`-CI **FEJLER** på seneste master-commit
     (`4ed62bd`, "pass -Cg-mdouble=32 in whetstone and runtime_libm",
     2026-09-20).

### Konklusion

CLAUDE.md's headline ("clang beats SDCC... cheap levers exhausted") er
formentlig forældet allerede fra FØR PR #40. Alt arbejde siden 8/9 er
ubekræftet af nogen automatiseret gate. "At bryde igennem" betyder konkret:
få en frisk build, en grøn lit-suite, en grøn z88dk-CI, og en re-målt
produktions-baseline — i den rækkefølge, fordi hvert trin er en forudsætning
for det næste.

### Handlingsplan (rækkefølge betyder noget)

**Trin 0 — Reproducerbar build (blocker for alt andet)**
- Frisk `cmake -C clang/cmake/caches/Z80.cmake -G Ninja -S llvm -B build-linux`
  + `ninja -C build-linux clang llc llvm-lit` på sonnyboy (Linux — undgår
  `osx_xcrun`-grenen helt).
- Verificer `llvm-lit` kan parse config uden crash.

**Trin 1 — llvm-z80: mål ægte lit/test-runner-baseline**
- `build-linux/bin/llvm-lit llvm/test/CodeGen/Z80/ -j$(nproc)` — notér reelt
  PASS/XFAIL/FAIL, sammenlign med de 164+6 og med fallout-planens
  189/64/32-baseline.
- `cargo run` (test-runner, O1/O2/Os) — notér FATAL-tal, sammenlign med
  fallout-planens 68 FATAL.
- Skriv resultatet i en ny `tasks/session-<dato>-post-pr40-ci-baseline.md`
  (ikke gæt — mål).

**Trin 2 — Genopliv CI**
- Undersøg hvorfor `z80-ci.yml` push-trigger ikke har kørt siden 6/6:
  workflow-fil ændret util af sync med branch-beskyttelse? Runner-kø
  proppet? `gh workflow view z80-ci.yml` + `gh api` for trigger-historik.
- Ryd de fastlåste "queued" `workflow_dispatch`-kørsler (annullér, de blokerer
  intet reelt men er støj).
- Få en grøn `push`-kørsel på `main` HEAD, eller dokumentér roden til hvorfor
  ikke, som et separat issue.

**Trin 3 — z88dk: fix build-mingw-on-ubuntu-fejlen**
- `gh run view` på den fejlende kørsel (`35492945026`) for fejllog.
- Sandsynlig kobling til samme ABI-/mdouble-arbejde som
  `fix/llvmz80-zcc-abi-recovery` — tjek om det er en direkte fortsættelse
  af samme regression eller noget nyt i `-Cg-mdouble=32`-committen.
- `test/clang/run_all.sh` lokalt mod frisk llvm-z80-build fra Trin 0, for at
  få et reelt pass-tal for zcc+llvmz80-stien (ikke kun mingw-buildet, som
  bare compilerer selve z88dk-værktøjerne, ikke kører target-tests).

**Trin 4 — Produktions-genmåling**
- Rebuild rcbios, autoload-in-c, cpnos-in-c, CP/NET med frisk clang fra
  Trin 0. Sammenlign med CLAUDE.md's opgivne tal (BIOS 5462 B, autoload
  1643 B, cpnos 2014 B) — disse tal er højst sandsynligt forældede
  (fra før PR #40 og Class 2-regressionen).
- MAME boot-gate på alle fire produktionskomponenter.
- Afgør om autoload-in-c's midlertidige 4 KB-cap kan sættes tilbage til
  2 KB nu, eller om Class 2-residualen (+23-39 B) stadig blokerer.

**Trin 5 — Opdater CLAUDE.md + memory med de reelle, friske tal**
- Kun efter Trin 1-4 er kørt og målt — ingen gæt.

### Ikke del af denne plan (bevidst udeladt)
- Selve `merge-upstream-2026-09-05`-planen (12.046 nye upstream-commits) —
  IKKE startet, og separat fra PR #40-arbejdet. Vurderes efter Trin 0-5 er
  landet, ikke før.
- Nye z88dk-ABI-huller (fopen/fread-familien m.v. fra
  `z88dk-submission-gap-2026-07-16.md`) — den analyse er fra FØR PR #40 og
  skal genkøres efter Trin 3, ikke stoles på as-is.

### Trin 6 (tilføjet 2026-09-24, bruger-ønske) — Docker-image: z88dk + llvm-z80 samlet

**Mål:** et Docker-image der ruller frisk z88dk (fuldt bygget) + frisk llvm-z80
(clang/llc/lld) sammen, sådan at `zcc +cpm -compiler=llvmz80` virker out-of-the-box
uden `LLVMZ80EXE`-pege-håndarbejde. Erstatter/supplerer det eksisterende
`z88dk:2.4`-image (som kun er SDCC/klassisk sccz80-vejen).

Forudsætninger (skal være grønne/målte først, jf. Trin 0-5 ovenfor):
- Trin 0: frisk llvm-z80-build eksisterer og er verificeret.
- Trin 3: z88dk's egen build er grøn igen (mingw-CI-fejlen + evt. flere,
  jf. build-forsøg 2026-09-24: `testsuite`-fejl på `Issue_1466_float16.opt`
  blokerer `make all` fordi `testsuite` er et hårdt prerequisite af `all` i
  top-level Makefile — bygget uden om ved at target'e `$(BINS)` direkte og
  udelade `testsuite`; #1466 float16-div/invf-codegen-diff bør registreres
  som separat issue, ikke ignoreres stiltiende).

Byggeplan (skitse, udfyldes når Trin 0/3 er grønne):
1. Multi-stage Dockerfile: stage 1 bygger llvm-z80 (cmake Z80.cmake + ninja
   clang/llc/lld), stage 2 bygger z88dk mod det llvm-z80-image (`LLVMZ80EXE`
   sat til stage-1-clangen), stage 3 (runtime) kopierer kun de færdige
   binaries+libs ind, ikke build-værktøj/kildetræer (image-størrelse).
2. Verificer i imaget: `zcc +cpm -compiler=llvmz80 -O2 hello.c -o hello.com`
   + kør resultatet i ntvcm/MAME fra selve CI'en (ikke kun "kompilerer uden
   fejl").
3. Tag/navngivning: følg samme mønster som `z88dk:2.4` (pinnet, ikke
   `latest`) — nyt tag, fx `z88dk-llvmz80:<dato eller llvm-z80-sha>`.
4. Placer Dockerfile/build-script i `z88dk/` (dev-fork) eller en ny
   `docker/`-mappe i workspace-roden — afgør med bruger når vi når hertil.
5. Dokumentér i `rc700-gensmedet/docs/` (parallelt med
   `z88dk_docker_rebuild.md` for det eksisterende SDCC-image) + opdater
   CLAUDE.md's "z88dk RETIRED" note til at nævne det nye llvmz80-image.

**Ikke startet endnu** — kræver Trin 0/3 grønne først, ellers bager vi en
kendt-brudt tilstand ind i imaget.

### Status opdatering 2026-09-24/25 — Trin 0-1 DONE, Trin 3 delvist

Fuld session-detalje: `llvm-z80/tasks/session-2026-09-24-25-z88dk-integration-baseline.md`.

**Trin 0 (frisk build):** DONE. `llvm-z80/build-linux/` virker. ccache
tilføjet til `Z80.cmake`. Ekstra worktree `llvm-z80-worktrees/upstream-main/`
på ren `upstream/main` — build IKKE færdig ved sessionsafslutning, fortsæt her.
Fund: `origin/main` indeholder 100% af `upstream/main` (0 bagud, 1177 foran).

**Trin 1 (lit-baseline):** DONE, bedre end forventet: 278 PASS + 5 XPASS
(forældede XFAIL, ikke fjernet endnu) + 1 XFAIL, **0 FAIL** af 284. PR#40-
recovery er reelt landet på compiler-siden.

**Trin 3 (z88dk-verifikation):** delvist. Fandt og rettede (committed +
pushet) en case-sensitivity-bug i `z88dk/test/clang/*.sh` der gjorde suiten
næsten ubrugelig på Linux (4/66 -> 48/66 PASS). De 15 resterende fejl er
alle undersøgt og er **z88dk-side** (math32 fsdiv-algoritme, klassisk-clib
%f-printf, kendt stdio-regression #54, test-harness-timeout) —
**0 llvm-z80 backend-bugs fundet**.

**Trin 2, 4, 5, 6:** ikke startet/afventer stadig (Trin 6 Docker-image
afventer eksplicit brugergrønt lys, jf. tidligere "vent"-besked).

Sidegevinster: `emu2-cpm86` og `dcc` .gitmodules rettet til de rigtige
forks (`johnsonjh/emu2-cpm86` var forkert antaget `dmsc/emu2`; `ravn/dcc`
var forkert `davidly/dcc`); `open-watcom-v2` fuldt build+Mandelbrot-testet;
`ntvcm` bygget (var manglende) — **husk: `ntvcm`, ikke `emu2` (CP/M-86/x86),
til klassiske Z80 CP/M `.com`-binaries**.

### 2026-10-04 — Fix Linux z88dk tests and build compiler-rt benchmark objects

1. Fix all test scripts that run lowercase `.com` paths although zcc emits
   uppercase `.COM`; baseline repro captured in `scratch/tmp/case-baseline.log`.
2. Build the six generic Z80 compiler-rt objects required by the two
   math32-vs-compiler-rt benchmark scripts into the expected build directory.
3. Run all affected tests, both benchmarks, and the full z88dk integration
   suite; preserve unrelated worktree/submodule changes.

**Status (2026-10-04):** the 12 Linux `.COM` path tests pass; `ninja
Z80Runtime` succeeds; both math32/compiler-rt benchmarks pass. The timing
benchmark caps math32 `ticks_cpm.py` runs at 25M cycles (verified with a
forced 100k-cycle cutoff) and gives compiler-rt `z88dk-ticks` runs a 10-second
wall-clock timeout (verified by forcing a 1 ms timeout). Its separate 500M
cycle limit allows the measured 254.5M-cycle compiler-rt divide to complete.
The full suite reports 72 PASS, 1 XFAIL, and 1 FAIL: `runtime_float.sh` reports
15 float-value mismatches. That remaining runtime test is not modified by the
Linux path or benchmark fixes and remains unresolved.

**Follow-up:** the `math32.lib` used by zcc was dated 2026-09-25, while
`f32_fsdiv.asm` and `d32_fsadd.asm` in the checked-out z88dk source were dated
2026-10-04. Rebuild the math32 archive from the current branch, rerun the
runtime float test and full integration suite, and only edit the test/compiler
if the mismatch persists with current runtime objects.

### 2026-10-04 — Merge active llvm-z80 and z88dk branches

1. Verify updated llvm-z80 backend build, Z80 lit tests, and value tests.
2. Run the updated z88dk llvmz80 integration tests with the rebuilt compiler.
3. Create non-fast-forward merge commits from the active feature branches into
   `origin/main` (llvm-z80) and `origin/master` (z88dk); push only after checks.

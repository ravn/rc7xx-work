# Plan: LLVM-Z80 calling-convention A/B

## Goal and scope

Measure calling-convention effects in the same LLVM-Z80 compiler, rather
than attributing differences between compilers to their ABIs.

Work branch: `experiment-default-cc-ab-20261004`, created at
`cdf7fbabe800` (origin/main's z88dk native-runtime squash).
The branch is checked out; implementation and measurements are local.
Implementation and local measurements were authorized by "start" on
2026-10-04. No merge, push or external response is authorized.

The maintainer's roughly 2% claim is an unverified hypothesis for this
compiler, not an expected test result.

## Verified starting points

- `clang/include/clang/Options/Options.td:9047` already defines
  `-fdefault-calling-conv=`, but not Z80 values.
- `clang/lib/AST/ASTContext.cpp:13480` selects the default function-type
  convention using LangOptions.
- `clang/lib/Frontend/CompilerInvocation.cpp:684` validates target-specific
  default-convention choices.
- `clang/lib/Basic/Targets/Z80.cpp` accepts explicit SDCCCall0, SmallC,
  callee combinations and Z88dkFastCall.

These are extension points, not proof that adding option values alone
fully implements the feature. Driver forwarding, redeclarations, callbacks,
varargs and runtime calls must be traced before editing.

## Experiment cells

| Cell | Program functions | Library/runtime boundary |
|---|---|---|
| A | Default sdcccall(1) | Existing explicitly specified conventions |
| B | Default sdcccall(0) | Same as A |
| C | B plus selected fastcall/callee annotations | Same as A |

A/B isolates the default-convention change. A/C measures the combination
suggested in z88dk/z88dk#3033, including annotation policy. Report B/C too,
so the annotation effect is visible.

Keep optimization flags, source, float model, libraries and tool versions
fixed within each comparison. All program translation units use the same
default. Preserve library prototypes, compiler-generated libcalls and
startup/callback contracts; never reinterpret a prebuilt library's ABI.

## Execution plan

1. [x] Finish the current main build and validate its compiler, ABI and
   active z88dk integration suites. Record actual fail/skip sets, compiler
   SHA and artifact identities. Prior measurements of `24afb830878c` were
   without the squash and are not this experiment's baseline.
2. [x] Switch to the experiment branch after the build finishes. Capture
   an unmodified baseline before changing code. Inventory existing z88dk
   benchmarks (including BENCH_MATRIX), correctness oracles and available
   cycle-counting tools before choosing the bounded initial corpus.
   Select both call-heavy microbenchmarks and representative programs;
   do not select only examples favorable to register passing.
   Evidence: cdf7fbabe800 assertions build, clang 426 PASS / 6 SM83 skips,
   SDCC ABI 174 PASS, lit 154 PASS, z88dk 14 PASS. Baseline at Os/O2 for
   callbench (indirect calls), queenbench (recursion), sortbench and sieve
   captured in `scratch/tmp/default-cc-baseline.json`. All eight cells passed
   native clang, ntvcm and ticks; the prefixed-opcode cycle control was 63.
   Existing ticks CP/M shim is available; existing benchmark matrix compares
   different compilers and cannot itself isolate calling-convention effects.
3. [x] Define the option contract: implemented values
   `-fdefault-calling-conv=sdcccall0` and `sdcccall1`, with no flag preserving
   current behavior. Support the actual clang driver, not just cc1.
   Initially target C on Z80. Reject unsupported targets clearly; specify
   and test any C++ limitation rather than silently changing method ABIs.
   Explicit attributes must override the default. Trace composition with
   `__z88dk_callee`, variadic handling, main/startup and callback types.
4. [x] Add tests before implementation and observe the unsupported option
   fail. Cover definitions/declarations/calls, function-pointer typedefs and
   indirect calls, cross-TU calls, redeclaration conflicts, explicit
   sdcccall(0)/(1), SmallC, fastcall and callee overrides/compositions,
   varargs, no-argument functions, narrow/wide returns and structs.
   Use frontend IR checks and backend FileCheck sequences where needed.
   Check the baseline/no-flag and explicit sdcccall1 outputs agree.
   Any test commit requires explicit commit authorization.
5. [x] Implement the default in function-type construction via the existing
   Clang infrastructure, with driver forwarding and target diagnostics.
   Do not rewrite only backend call instructions, infer external ABIs or
   add bridges. Pin generated runtime and library calls so their conventions
   do not accidentally follow the experimental program default.
6. [x] Rebuild clang, llc, lld, opt and FileCheck with ccache/assertions.
   Run targeted tests and runtime fixtures under both choices. Runtime
   fixtures must independently detect argument order, return-register and
   stack-cleanup errors, including repeated calls and indirect/cross-TU
   calls. Run full compiler lit/runtime and z88dk integration suites.
7. [x] Run A and B with identical sources at fixed optimization levels
   (initially Os and O2). Include a no-flag versus explicit-sdcccall1 control.
   Prevent test workloads from being folded away; check which calls survive
   optimization and report inlining/LTO policy. Include separate translation
   units where needed to retain real calls without artificial differences
   between cells.
8. [x] Define and document C's annotation policy before seeing its scores.
   Fastcall is not a universal default: use it only for supported
   single-argument functions; consider callee cleanup for eligible
   non-variadic functions. Apply consistent declarations and callback types,
   retain source-level work/results, and disclose manual annotations.
   Measure C with the same corpus and flags, not a separately tuned workload.
9. [x] Report size and cycles only for correctness-passing cells.
   Size: total code + read-only data + initialized data, final artifact size,
   and BSS separately; use identical linking and identify archive members.
   Cycles: fixed input/work count and consistent measurement boundaries,
   using a verified instruction-cycle oracle (not unvalidated ntvcm cycle
   totals or host wall-clock time). Verify timing setup with hand-countable
   instructions. Runtime output must match independent expected values,
   not merely agree across all variants.
10. [x] Review every plan item against evidence and report per-program
    absolute sizes/cycles and deltas, controls, failures and limitations.
    Separate ABI effects from whole-compiler comparisons. Do not generalize
    an aggregate percentage beyond the measured corpus, flags and policy.
    No change of production default, merge, push or GitHub posting.

## Execution evidence

Implemented driver/cc1 values with C/Z80-only diagnostics and explicit
attribute overrides. Red evidence: unsupported options before the change;
runtime returned 0x005A instead of 0x00D9 before preserving freestanding
main's startup ABI; default0/callee incorrectly emitted cc131 before the
composition fix, now cc132. Agent reports all five focused lit tests green.
New runtime fixtures cover cross-TU/indirect calls and return 0x00D9 at six
optimization levels each.

Final parent-run gates: clang 438 PASS / 6 SKIP, lit 155 PASS, SDCC ABI
174 PASS, z88dk 14/14 PASS. A broader Rust unit-test run has two failures
listed in the results; it is not represented as green or verified unrelated.

All 32 final measurement cells pass. Pre-change baseline, final no-flag and
explicit1 match byte hashes and cycles. C's annotation policy is fixed in
`llvm-z80/z80-utils/benchmarks/default-cc/run.py`; explicit callee composition
was corrected and all scores rerun. Result report:
`llvm-z80/z80-utils/benchmarks/default-cc/RESULTS.md`.
Raw evidence: `scratch/tmp/default-cc-final.json` and adjacent artifacts.
No limit was hit; commands have a timeout and cycle ceiling.

Scope limitations retained rather than silently expanded: the initial
corpus is four Z80 C workloads, normal inlining/no LTO; multi-TU coverage
is in runtime fixtures rather than separate benchmark TUs. No optimal
annotation search or general performance percentage is claimed.

## Completion criteria

- A real driver option produces matching caller/callee function types.
- Unannotated functions vary; explicit external/runtime ABIs remain fixed.
- Runtime correctness and baseline/no-op control pass before scoring.
- A/B and annotated C results are separately reproducible and documented.
- No unsupported calling-convention configuration succeeds silently.
- Work remains on the experiment branch; main keeps its production default.

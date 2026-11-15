# z88dk integration on the upstream LLVM-Z80 design

Status: analysis and implementation plan only. No compiler or library
changes, branch operations, commits, pushes or external submissions.

## Goal and boundaries

Produce a small, reviewable z88dk integration that follows the upstream
compiler's calling conventions, assembly dialect and runtime profiles.
Retain local additions only where an executable test demonstrates a gap.
Do not restore the old float bridge or hardcoded backend runtime routing.

The first deliverable is classic CP/M through `zcc +cpm -compiler=llvmz80`.
That target has existing integration tests. Newlib, other CPUs and bare-metal
firmware are separate expansion gates, not implied by a CP/M pass.
Existing unrelated worktree files must remain unchanged.

## Verified design and revision inventory

Inspected upstream PRs llvm-z80/llvm-z80#110 and
llvm-z80/llvm-z80#112, their descriptions and discussion, and fetched refs.
Both PRs remain open. Their runtime stack is not an ancestor of upstream
main. Main alone is therefore not a z88dk integration baseline.

| Component | Inspected revision |
|---|---|
| Upstream main | `d48307833b477a872afeca7dcbefaa6330aebf10` |
| Upstream z88dk runtime stack | `042a1d72651c110a73defde6e1256fd53ab3a1a8` |
| Local compiler source | `6de2c1b41bcd36601982810efced956e702a58bd` |
| Local z88dk source | `680664d950741a45a4a34dec159330eb04a1207e` |
| Installed compiler version string | `60e6a92b6f9810948b532ea3743564f3088892bc` |

The runtime stack is an ancestor of local compiler HEAD. Four local
commits add multiply narrowing, helper declarations, routing and tests.
They are not four wholly independent integration requirements.
Later main changes include register-class cleanup, COPY handling,
epilogues, scheduling and a migration from the Rust runner to `z80-test`.
Generic LLVM also changed RuntimeLibcalls table infrastructure.
Those changes make a future rebase substantive. No conflict resolution
or successful rebase has been attempted.

The upstream design specifies:

- Ordinary C uses smallc in the z88dk environment. Main and variadic
  functions use sdcccall(0). Attribute composition is centralized in
  `clang/lib/Basic/Z80CallingConv.cpp`.
- Integer operations call z88dk cores using dedicated runtime conventions.
  Sixteen-bit operands use HL/DE. Thirty-two-bit operations use both register
  banks and preserve IX. Quotient/remainder and multiply-high results have
  distinct result routing.
- Floating operations use sccz80 `l_f32_*` entries. Float comparisons can
  return their branch result in carry. Libm uses math32's double names.
- `z80_z88dk_rt.lib` supplies helpers that the native library does not cover.
  Its C library functions are excluded. It is not the retired float bridge.
- Runtime names and calling conventions come from RuntimeLibcalls tables.
  Assembly defaults to z88dk syntax under the z88dk triple.

## Existing integration: keep, audit, or remove

| Area | Evidence | Planned treatment |
|---|---|---|
| zcc driver | `z88dk/src/zcc/zcc.c:3757-3790` selects the z88dk triple and gnu23 | Keep. Verify actual commands, optimisation override and emitted assembly. |
| Supplement discovery | `z88dk/src/zcc/zcc.c:1118-1168` probes and links the supplement | Keep the requirement. Verify path precedence, installed-tree behavior and link order. |
| Header ABI | `z88dk/include/sys/compiler.h:30-80` enables attributes and ZPROTO machinery | Audit per declaration and selected library entry. Do not remove R2L just because ordinary C is smallc. |
| Variadic support | Classic stdarg uses compiler builtins for LLVMZ80 | Keep. Verify transfer of va_list to library v-functions, not only local va_arg. |
| Callback routing | Existing header_abi tests exercise qsort and bsearch | Keep tests. Check both direct and indirect calls and signed comparator results. |
| Header families | Development compiler/stdarg headers differ from classic | Treat newlib as a separate gate. Do not copy classic changes blindly. |
| Memory helpers | Emission checks accept both historical and current names | Tighten only after the chosen runtime contract is proven. Supplement mem-builtins may remain intentional. |
| Multiply additions | Local source and ravn/llvm-z80#420 cover narrowing/helpers | Revalidate before retaining. Do not equate widened-result multiplication with high-half-only routing. |
| Old submissions | z88dk/z88dk#3149, #3153 and #3151 were withdrawn | Use only as history. Their old flags and bridge design are not the new patch specification. |

The earlier handoff at `tasks/HANDOFF_2026-10-14.md` explains why R2L
selected header entry points rather than determining compiler push order.
It also records an ixiy workaround that later commits removed.
It is historical evidence, not the current build recipe.

The comments in `test/llvmz80/varargs.c` still describe smallc variadics
and an untested vsnprintf incompatibility. Upstream explicitly gives
variadic functions sdcccall(0). Reproduce the boundary before accepting
or rewriting that comment. A non-variadic v-function has its own ABI.

## Baseline run on 2026-11-01

Ran, without source changes:

```sh
LLVMZ80EXE=/Users/ravn/z80/llvm-z80/build-macos-asserts/bin/clang \
  sh z88dk/test/llvmz80/run_all.sh
```

Result: 2 runner groups PASS, 1 FAIL, 0 SKIP. Temporary-directory and
backend-smoke groups passed. At O0, varargs, header_abi, math32,
runtime_memory, runtime_arith32 and runtime_arith16 passed.
The next test, runtime_mul_libcalls, failed during compilation:

```text
unable to legalize instruction:
%40:_(s32) = G_MUL %36:_, %39:_ (in function: main)
```

The actual command contained `-O2 -O0`, so the final optimisation override
was O0. Subsequent tests and O2/Os iterations did not execute.
No complete-suite pass is claimed.

The installed compiler reports a different revision from source HEAD.
This proves an artifact/source mismatch, not which source patch is missing
from the artifact. Rebuilding is required before diagnosing current code.

| Baseline artifact | SHA-256 |
|---|---|
| clang | `c5def72d48be620d06fc4c7a116ceac55d0faeeda51644f3c307db8ff72a78ef` |
| zcc | `18d8ed2823797d86f58101e86bf72374bee70f2bcb7839ddb1f85d1a5ee7e2e6` |
| z88dk-ticks | `9179d7e322d5071e669bdb493c28270a6d444ae8f9162911a399b4675da893d0` |
| z80_z88dk_rt.lib | `6c9faf337ef3aed298d94e3cc00c3d213f6cf4ac5c5c91269c3c9a500cf4e71a` |

## Implementation sequence and gates

### 1. Establish a coherent control build

Record clean/dirty status and exact refs without staging unrelated work.
Build the selected existing compiler source and its supplement together,
using the documented toolchain/cache setup and verified ccache settings.
Verify z88dk binaries correspond to the source used for testing.
Record versions, hashes, runtime archive symbols and actual zcc commands.
Re-run the existing suite and preserve its complete failure set.

Gate: coherent compiler, llvm-mc, assembler, library and runner artifacts.
If multiply still fails, reduce it to the smallest emitted IR/codegen case.
Compare pure runtime-stack and local-patch builds before attributing cause.
Do not file the observed stale-artifact crash upstream as a confirmed bug.

### 2. Pin the upstream integration contract

Start a dedicated branch from the upstream runtime stack, not from main.
Use current local work as evidence, not an alternative ABI specification.
Classify each local change as already upstream, necessary tested addition,
obsolete workaround or unrelated work. Reapply only necessary additions
above upstream decisions. Do not merge competing designs as equals.

The runtime stack currently predates main's newer infrastructure.
First obtain a passing control on that exact stack.
Then assess its integration with newer main separately. Prefer an updated
upstream stack when available. Do not silently invent a competing rebase
of the upstream PR series.

Gate: a small explicit delta, with no duplicate runtime implementation.

### 3. Test and adapt classic header boundaries

Use small concrete tests for ordinary C, main, variadics, smallc,
sdcccall(0/1), fastcall and callee-cleanup compositions.
Use distinct argument values and mixed widths to expose reversal,
truncation and cleanup errors. Exercise repeated calls and callbacks.
Include pointers, 8/16/32-bit results and a struct-return boundary.

For each relevant header declaration, inspect preprocessed declarations,
IR convention, assembly symbol, selected archive entry and runtime result.
Disable builtin folding or use indirect calls where needed to ensure the
test crosses the library boundary. Keep separate tests for intentionally
compiler-synthesized libcalls.

Add a focused va_list-to-vsnprintf test with multiple distinct values.
Audit ZPROTO, bare/underscore symbols, qsort/bsearch callback conventions
and their required preservation rules. Do not globally rewrite macros.

Gate: tests with independent expected values prove each changed boundary.
Any fix requires an observed failing test before fix code.
Leave other clang-shaped frontends and SDCC/sccz80 behavior unchanged.

### 4. Close runtime and archive coverage

Exercise signed/unsigned integer operations at 8/16/32/64 bits.
Prioritize widening multiply, high-half multiply, division/remainder,
fused divmod, signed boundaries and register-bank preservation.
Check all result bits rather than truncating outputs for convenience.
Use defined C operations and independently calculated expected values.

Exercise float arithmetic, comparisons, conversions and representative
libm calls through native entries. Separate ordinary finite values from
NaN, infinity and subnormal limitations. Upstream's limitations refer to
z88dk 2.4 and are not automatically verified for our current tree.
Test signed-byte strcmp/memcmp behavior with bytes above 127 separately.

Check backend memory fallbacks, overlap direction, zero length and return
pointers. Verify supplement membership, duplicate-symbol exclusion,
installation path and link order using the real archive and link artifact.
Do not replace intentional compiler-rt mem-builtins merely to fit a test.

Gate: correct values and required codegen, not just successful links.

### 5. Integrate upstream test infrastructure

After choosing a baseline that includes the test migration, configure
the external `z80-test` project and inspect generated lit configurations.
Use `check-z80` and targeted llvm-lit selectors first.
Preserve existing useful runtime fixtures during migration.

Upstream main documents ELF/SDCC formats in its new runner.
Do not assume that proves zcc/CP-M integration or includes the open PR's
z88dk configuration. Keep the CP/M z88dk-ticks suite as a distinct gate.
Determine which CI jobs actually run each added test.
Fail or explicitly report required-suite skips.

Gate: compiler lit/runtime tests and zcc integration both execute.
Use O0/O2/Os initially, then O3/Oz before delivery.
Run existing z88dk regression checks for touched driver/header behavior.
No firmware merge is authorized here. Any later compiler merge must also
run the production behavior gates required by the workspace agreements.

### 6. Package a fresh upstream submission

Separate necessary driver, header and test changes into reviewable units.
Document the prerequisite open LLVM-Z80 PRs and supported z88dk version.
Remove obsolete compatibility flags and bridges only when proven unused.
Include reproducible commands and actual pass/fail/skip results.

Gate: the reviewed patch follows the upstream design and passes both
compiler and library boundary tests. Commit/push or external PR filing
requires explicit user authorization. No upstream issue is warranted
from the artifact-mismatched baseline alone.

## Existing tools to use

- Clang `-E`, `-S -emit-llvm`, `-###`, and generated assembly expose
  declaration, convention and command-line choices.
- llc pass output and `-verify-machineinstrs` expose legalization and
  register-preservation requirements.
- FileCheck pins calling sequences and symbol routing.
- z88dk-z80nm, archive inspection and link maps identify actual entry points.
- z88dk-ticks executes the classic CP/M boundary tests with a timeout.
- Upstream `check-z80` supplies compiler/runtime and torture gates once
  the selected baseline includes the migration.

No new benchmark framework, bridge library or alternate emulator is needed.
Performance comparison comes after correctness, with a captured control.

## Completion criteria

The integration follows the upstream ABI and runtime design.
Exact compiler/library revisions and required dependencies are documented.
No stale artifact or silent required-test skip supports a success claim.
Changed library boundaries have independent runtime oracles and codegen checks.
Other compiler frontends retain their intended behavior.
The final delta is small enough to explain and submit without old workarounds.

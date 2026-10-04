---
name: feedback_rebuild_all_z80_tools
description: After changing llvm/lib/Target/Z80/, rebuild clang AND llc AND lld — the Z80 codegen lib is embedded in all three, and LTO tests + PROM links go through ld.lld. Rebuilding a subset = stale-binary chase.
metadata:
  type: feedback
---

**HARD rule.** After ANY edit under `llvm-z80/llvm/lib/Target/Z80/` (or any
backend library compiled into `LLVMZ80CodeGen`), rebuild **all** tools via:

```bash
make toolchain
```
from workspace root, or explicitly:
```bash
ninja -C <build-dir> clang llc lld llvm-nm llvm-objcopy llvm-objdump opt FileCheck
```

**NEVER build a subset — not even "just this once to save build time."** That
optimization is always net-negative (it caused the 2026-07-08 incident below AND
a 2026-09-11 repeat: rebuilt `clang llc`, then rcbios `-flto` linked with a stale
`ld.lld` still carrying the pre-fix Z80DanglingDebugCleanup → LTO crash). If a
backend file changed, run `make toolchain` (or default `ninja`) — full stop. Citing this
rule in a commit's `Rules-checked:` is not compliance; running the aggregate is.

**Why.** `LLVMZ80CodeGen` is statically linked into `clang`, `llc`, AND
`lld`. Different tests invoke different tools:
- `llc` — standalone codegen lit tests.
- `clang` — non-LTO `.c` compiles.
- **`ld.lld`** — **LTO codegen** (`-flto` compiles emit bitcode; the backend
  runs at link time inside lld) AND the RC700 PROM builds, which call
  `bin/ld.lld` directly for the final link.
- **`llvm-nm`** — **runtime oracle test-runner** (`z80-test-runner` inspects
  the compiled ELF with `llvm-nm` to locate `_halt` and `_exitcode`; if `llvm-nm`
  is missing or stale, 100% of runtime tests fail).
- **`opt` + `FileCheck`** — IR transform passes and lit test verification.

Naming a subset (`ninja ... clang llc`) leaves `ld.lld` STALE.  A stale
`ld.lld` silently runs the OLD legalizer on the LTO path, so `-flto` builds
(rcbios uses `-flto`) and any LTO codegen test use pre-change code.

**The 2026-07-08 incident (the reason this rule exists).** After adding the
memmove direction fold + end-pointer cancellation, I rebuilt `clang llc` only.
`llc` folded correctly, but rcbios (`-flto`, links via `ld.lld`) emitted
`__memmove_rt` instead of inline `LDDR`.  I spent hours diagnosing a phantom
"LTO backend differs from llc" discrepancy — capturing post-LTO IR, MIR before
legalizer (identical!), testing opt levels — when the real cause was my own
un-rebuilt `ld.lld`.  Rebuilding `lld` made LTO fold immediately.  Diagnostic
prints confirmed BOTH paths reach `Dir=LDDR` once the binaries match.

**Discipline:** before "test with the new compiler", ask *which tool does this
test invoke?* and confirm it was in the last `ninja` target list.  LTO /
PROM / `-flto` ⇒ `ld.lld`.  When in doubt, build all three.

**Extended rule for LLVM core lib edits (2026-09-25):** If a commit touches
`llvm/lib/Transforms/Utils/BuildLibCalls.cpp`, `llvm/lib/Analysis/TargetLibraryInfo.cpp`,
or other core libs, ALSO rebuild `opt`:
```
ninja -C build-macos-asserts opt FileCheck
```
Without this, `opt` crashes or silently uses stale code (2026-09-30 incident:
stale `opt` made `infer-data-layout.ll` appear to fail after zlfn's
`TargetDataLayout.cpp` change was in-tree but `opt` was not yet rebuilt).
The lesson: `ninja -C build-macos-asserts` (build all) is always safer than a subset.

**Use `build-macos-asserts` for all testing and firmware builds** (updated 2026-09-30).
Assertions catch IR/MIR invariant violations early.

See also: [[feedback_ccache_llvm_build]] (cmake reconfiguration + ccache).

Related: [[feedback_revalidate_historical_compiler_claims]] (stale-rebuild
trap), [[feedback_verify_matrix_before_theory]] (contradictory result =
suspect stale state first).

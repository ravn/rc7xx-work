---
name: feedback_rebuild_all_z80_tools
description: After changing llvm/lib/Target/Z80/, rebuild clang AND llc AND lld — the Z80 codegen lib is embedded in all three, and LTO tests + PROM links go through ld.lld. Rebuilding a subset = stale-binary chase.
metadata:
  type: feedback
---

**HARD rule.** After ANY edit under `llvm-z80/llvm/lib/Target/Z80/` (or any
backend library compiled into `LLVMZ80CodeGen`), rebuild **all three** tools:

```
ninja -C build-macos clang llc lld
```

(or just `ninja -C build-macos` — default builds everything).

**Why.** `LLVMZ80CodeGen` is statically linked into `clang`, `llc`, AND
`lld`.  Different tests invoke different tools:
- `llc` — standalone codegen lit tests.
- `clang` — non-LTO `.c` compiles.
- **`ld.lld`** — **LTO codegen** (`-flto` compiles emit bitcode; the backend
  runs at link time inside lld) AND the RC700 PROM builds, which call
  `build-macos/bin/ld.lld` directly for the final link.

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

Related: [[feedback_revalidate_historical_compiler_claims]] (stale-rebuild
trap), [[feedback_verify_matrix_before_theory]] (contradictory result =
suspect stale state first).

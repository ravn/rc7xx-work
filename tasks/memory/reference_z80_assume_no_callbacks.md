---
name: reference-z80-assume-no-callbacks
description: -z80-assume-no-callbacks flag enables static frames for externally-linked entry points (main) without -ffreestanding; implemented 2026-10-01 in Z80TargetMachine.
metadata:
  type: reference
---

## Flag

`-mllvm -z80-assume-no-callbacks` (passed via zcc as `-Cg-mllvm -Cg-z80-assume-no-callbacks`)

## What it does

Tells Z80NonReentrant that no external code will call back into this module
via function pointers. Switches `CallsExternalNode` from open-world
(`→ ExternalCallingNode → all externally-callable functions`) to closed-world
(only address-taken functions), identical to `-ffreestanding`'s effect on
Z80NonReentrant — but WITHOUT changing language semantics or suppressing
hosted-C builtins.

**Why this matters:** Without the flag, `main` is in a multi-node SCC with
`ExternalCallingNode` (via `main → external call → CallsExternalNode →
ExternalCallingNode → main`). That cycle prevents `doesNotRecurse` and thus
`nonreentrant`, so `main` keeps its IX-based stack frame even with
`+static-frame`.

## vs -ffreestanding

Both produce identical Z80NonReentrant behaviour. Difference:
- `-ffreestanding`: module-wide language mode change; suppresses libc builtins,
  changes `__STDC_HOSTED__`. Correct for firmware.
- `-z80-assume-no-callbacks`: codegen-only; hosted stdlib still works. Correct
  for standalone CP/M programs.

## Implementation

`Z80TargetMachine.cpp`: `cl::opt<bool> AssumeNoCallbacksOpt("z80-assume-no-callbacks")`
+ `bool Z80TargetMachine::assumeNoCallbacks()`.

`Z80NonReentrant.cpp` line ~220: condition extended to
`isFreestandingModule(M) || hasEntryPointAnnotations(M) || TM.assumeNoCallbacks()`.

Lit test: `llvm/test/CodeGen/Z80/nonreentrant-assume-no-callbacks.ll`

## Usage with zcc

```bash
zcc +cpm -compiler=llvmz80 -O2 \
  -Cg-Xclang -Cg-target-feature -Cg-Xclang -Cg+static-frame \
  -Cg-mllvm -Cg-z80-assume-no-callbacks \
  -o prog prog.c
```

## Related

[[reference_z80_ffreestanding_closed_world]] — same pass effect, different
language-mode implications.

`z80-entry-point` fn attribute (in Z80NonReentrant.cpp) — per-function
alternative; marks individual functions as context roots with no external
re-entry. Upstream issue: ravn/llvm-z80#394.

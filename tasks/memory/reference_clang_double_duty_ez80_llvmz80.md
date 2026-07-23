---
name: clang serves double duty (ez80clang + llvmz80) in z88dk
description: Both z88dk clang backends define __clang__, so header logic must gate on __LLVMZ80, never bare __clang__
type: reference
---

**Fact (user 2026-07-23):** in the z88dk world, "clang" does **double duty** —
it drives BOTH backends:
- **ez80clang** = CE-Programming's SelectionDAG eZ80 LLVM fork (CEdev), used here
  only as a code-quality comparison oracle (see [[reference_ez80clang_oracle]]).
- **llvmz80** = ravn/llvm-z80, our GlobalISel z80-native backend.

Both present to the C preprocessor as `__clang__` (they are clang forks).

**Consequence for header/config work (Phase C of the newlib plan and any
`sys/compiler.h` edit):** any z88dk header branch intended for llvmz80 MUST be
gated on **`__LLVMZ80`**, never on bare `__clang__` — a `__clang__` branch also
fires under ez80clang and can break the oracle build (or silently mis-map
calling-convention keywords). This is exactly the trap the newlib
`_DEVELOPMENT/common/sys/compiler.h` fell into: it strips the z88dk keyword
mappings under `__clang__`, which happens to be masked today only by the
`-D__SDCC` ucpp masquerade. The correct fix is an explicit `__LLVMZ80` path.

See [[reference_z88dk_clang_register_abi]] and
[[plan-newlib-llvmz80-support-2026-07-22]] (Phase C).

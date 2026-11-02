---
name: project_port_io_builtins_dropped_2026-11-02
description: llvm-z80 main (pin da06bcd8) has no __builtin_z80_*, <intrinsic.h>, z80_critical or AS_IO lowering; firmware headers still use them; user chose z88dk port I/O; issue #421
metadata:
  type: project
---

**State (verified 2026-11-02, sonnyboy):** the pinned `llvm-z80` `da06bcd8acc2` (= `ravn/llvm-z80` `origin/main`) does NOT contain `__builtin_z80_di/ei/halt/nop/im2/set_i/in/out`, the shipped `<intrinsic.h>`, `__attribute__((z80_critical))`, or the `address_space(2)` (`AS_IO`) lowering. The commits that had them (`ea3d638` #42, `2883cdd` "Ship <intrinsic.h>…", `01c80da` "Wire __builtin_z80_* CodeGen lowering") are not ancestors of main; they live only on feature branches (`origin/pr-366…370`, `pr-asm-format-z80asm`, …). Upstream-PR head #112 (`042a1d72`, llvm-z80/llvm-z80) is an ancestor of the pin and lacks them too.

**Cause (user's belief, not documented anywhere):** lost when the user restarted the branch to make #112 work with z88dk (`archive/z88dk-env-20261013` also lacks them). Related: the fork owner was doubtful about the `AS_IO` approach; ravn/llvm-z80#387 / PR #388 cover it.

**Decision (user 2026-11-02):** do NOT restore builtins / `AS_IO`. Port I/O comes from z88dk's functions (`inp`/`outp`, folding to raw asm). `CLAUDE.md` line "Compiler intrinsics/attributes" corrected accordingly.

**Consequence — firmware does not build with current main clang** (`use of unknown builtin '__builtin_z80_di'` etc.). Still calling builtins: `autoload-in-c/rom.h` (port_in/out), `autoload-in-c/clang/intrinsic.h`, `rcbios-in-c/hal.h`, `rcbios-in-c/clang/intrinsic.h`, `cpnos-in-c/src/hal.h`, `cpnos-in-c/compiler/compat.h`. OPEN: adapt these six headers (inline asm or z88dk routines behind the existing macros), then verify size + MAME boot via Makefile targets.

**What still exists:** `llvm.z80.in/out` intrinsics (IR/llc only; lit `port-io-any-register.ll`). From C they are reachable via an unsupported asm-label trick (`u8 f(u8) __asm__("llvm.z80.in");`) — do not build on it. They always select `LD C,n` + `IN/OUT (C),r` (4 B) even for constant ports; filed as ravn/llvm-z80#421 (also: `IN_A_n`/`OUT_n_A` lost `Defs/Uses=[A]` vs `ea3d638`; `IN A,(n)` drives A on A15–A8, `(C)` forms drive B).

**Test status of #112-head clang (2026-11-01):** lit `CodeGen/Z80` 147/147; cargo runtime 426 pass / 0 fail / 6 skip (SM83 inline-asm test, `SKIP-IF: z80` by design).

**Why:** user decides what goes upstream; builtins/`AS_IO` were judged not worth the owner's doubt once z88dk had port I/O functions.

**How to apply:** do not suggest restoring builtins or `AS_IO`; if a firmware build fails with unknown `__builtin_z80_*`, the fix is in the six headers, not the compiler. For the `llvm.z80.in/out` size issue, point to #421. Refer to the fork owner only as "the fork owner" (see the never-mention rule in MEMORY.md §2). Related: [[feedback_ccache_llvm_build]], [[reference_host_sonnyboy]].

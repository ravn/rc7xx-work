---
name: feedback_peephole_safety_guards
description: Z80LateOptimization peepholes that erase/move/convert instructions need complete liveness + slot-aliasing + iterator guards
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 90439589-e8b2-4e34-94a8-798e56731341
---

When adding/editing a `Z80LateOptimization.cpp` peephole that **erases, moves, or converts** instructions, it must guard against ALL of: (1) **value liveness** — a register being overwritten/reused must be dead, OR its value preserved (use the shared sound primitive `isRegDeadAfter`, or `computeRegisterLiveness`); (2) **slot aliasing** — a BSS/stack slot read **indirectly** (via a pointer into the frame, e.g. arrays/&local) or via a **loop-carried reload** (read at the loop top, before the store) is invisible to a forward, direct-load-only, same-register-class scan; (3) **iterator safety** — `MBB.erase` + `--MII` dangles when the erased/next instruction is itself erased; anchor resumption to an un-erased inserted instruction instead.

**Why:** session 73s shipped 5 fixes (#14, #192, #193, #195×2) that were all this one bug family — the `COPY16_PUSHPOP` IX/IY-transfer and `BSS-spill→PUSH/POP` peepholes mutating without a complete check (dropped loop-carried IY copy; relocated `LD r,A` into a region reading r; dangling `--MII` segfault; dropped a loop-carried slot store-back; dropped an address-taken slot store). Each silently miscompiled or crashed under `+static-stack` (production config).

**How to apply:** before shipping a peephole, ask "what reads this register/slot that my scan doesn't see — indirectly, before the store, in another block, in another register class, across a loop back-edge?" Validate with the full oracle (test-runner + `cargo run -- clang -static-stack` + AES + cpnos polypascal MAME boot + lit). See [[feedback_root_cause_over_peephole]], [[feedback_z80_copy_spurious_mem_flags]]; audit `llvm-z80/tasks/session73s-late-opt-liveness-audit.md`.

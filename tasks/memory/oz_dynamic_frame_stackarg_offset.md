---
name: oz_dynamic_frame_stackarg_offset
description: Pre-existing -Oz miscompile — dynamic-SP-frame reads a stack argument at the wrong offset when the prologue adds an extra allocation; production (+static-frame) is safe.
metadata:
  type: feedback
---

At **-Oz in dynamic-SP-frame mode** (no `+static-frame`/`+static-stack`), a
function taking a **stack argument** can read it at the wrong stack offset: the
-Oz prologue emits an extra `push` (frame allocation) whose 2 bytes are NOT added
to the fixed-stack-object offset, so e.g. `len` is read from the return-address
slot. Detector: `test_33_string_ops.c` @ -Oz (returns 0x0008 vs 0x000F; isolated
to `my_strrev`). Pre-existing (predates the #326-#331 density peepholes — git A/B).

**Why it matters / how to apply:** **production firmware is SAFE** — autoload,
rcbios, cpnos all build `+static-frame`, verified: `my_strrev` recompiled with the
exact autoload flags reads the arg at the correct offset and returns 0x000F. Do
NOT treat test_33_Oz as a regression or a production blocker; it is a known
dynamic-frame-only bug. If a future target drops `+static-frame` and passes stack
args, re-open. Full analysis:
`llvm-z80/tasks/oz-dynamic-frame-stackarg-offset-2026-09-16.md`. Related historical
stack-arg-offset class in llvm-z80 CLAUDE.md (SPILL_GR16 direct-BSS, hasFP=false).

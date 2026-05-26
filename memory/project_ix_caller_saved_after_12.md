---
name: project_ix_caller_saved_after_12
description: "Revisit caller-saved IX (the only IX size win) AFTER ravn/llvm-z80#12 frame-pointer elimination lands"
metadata: 
  node_type: memory
  type: project
  originSessionId: 90439589-e8b2-4e34-94a8-798e56731341
---

Making IX an allocatable register is a **size regression** in the current
(callee-saved) ABI — every config tested (blanket un-reserve, greedy
`getCSRCost` cost model) is worse than keeping IX reserved; the cost model
bottoms out at +18 B on BIOS from pure allocation perturbation. Measured
session-ix (2026-05-26), all reverted.

The ONLY winning path is making IX **caller-saved** (drop from `Z80_CSR` +
`getCallPreservedMask`, force `hasFP=false`): firmware cpnos −8 B, BIOS −1 B,
verify-clean. But program-wide it broke 526/1044 `-static-stack` tests with
`ld.lld: undefined symbol __sfrend_X` — forcing `hasFP=false` on stack-arg /
alloca functions breaks static-stack frame-symbol emission. **That gap IS
ravn/llvm-z80#12.** The firmware survives only because it has ZERO
frame-pointer functions.

**How to apply:** when #12 (SP-relative frame objects so `hasFP=false` works for
stack-arg functions) is fixed, flip IX to caller-saved and re-measure — expect
the −8/−1 wins or better. User explicitly asked to "come back to this after
#12." Full write-up: `llvm-z80/tasks/issue12-ix-unreserve-measurement-2026-05-26.md`
and the ravn/llvm-z80#12 issue comment. IX stays reserved until then.

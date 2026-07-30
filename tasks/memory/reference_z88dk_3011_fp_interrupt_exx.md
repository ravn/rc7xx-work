---
name: reference_z88dk_3011_fp_interrupt_exx
description: z88dk#3011 open Q — RC700 FP-under-interrupt crash root cause is shadow-register (EXX) collision; math48/genmath use the alt set as scratch
metadata:
  type: reference
---

**z88dk/z88dk#3011 open question (suborb, 2026-07-13):** on RC700 the stock z88dk
floating-point routines crash "during interrupts"; switching to the 8080 math
library works. Root-cause finding (parked draft reply, not yet posted — needs
user's own voice per [[feedback_explain_before_filing]]):

- z88dk's Z80 FP libs use the **shadow register set** (`EXX` / `EX AF,AF'`) as
  scratch: `libsrc/math/float/math48` uses `EXX` **367×**, `genmath` 21×. So an
  in-flight FP computation holds live mid-values in the alternate registers.
- Any interrupt handler that also touches the shadow set (without a full
  save/restore) will corrupt an interrupted FP op. The 8080 math lib never uses
  Z80 shadow regs → immune, which matches the symptom exactly.
- Concrete collision source on our side: our clang-built RC700 firmware
  **deliberately** uses `EXX` in ISRs (`+shadow-regs` EXX save/restore). The
  forum reporter reviewed their BIOS and thought it does NOT use the alt set — so
  for a pure-z88dk RC700 build the collision would be a different IM2/RST handler.
- **Honest confirmation test:** wrap the FP call in `DI`/`EI`; if the crash
  disappears with interrupts off around the call, the shadow-register collision
  is proven. (Symptom is verified; cause stays a hypothesis until DI/EI test —
  [[feedback_state_certainty]].)

Draft reply text lives only in the 2026-07-28 session; post only after user
approves wording. Related: [[reference_z88dk_direction_classic_not_newlib]].

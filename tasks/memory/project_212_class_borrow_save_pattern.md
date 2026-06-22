---
name: project-212-class-borrow-save-pattern
description: Audit pattern for #212-class verifier bugs — overbroad HL save before address-computation borrow. Recurring shape across the Z80 backend; multiple sites still latent.
metadata:
  type: project
---

The bug pattern that #210, #212, and the related sites (#236, #237, #238, #239) all share is structurally the same:

```cpp
// Decide whether to save HL across an address-computation borrow that
// clobbers HL.
bool NeedSaveHL = LiveRegs.contains(Z80::H) || LiveRegs.contains(Z80::L);
if (NeedSaveHL)
  BuildMI(MBB, MI, DL, get(Z80::PUSH_HL));   // reads $hl as a UNIT
```

**Why it's wrong**: `PUSH_HL` reads `$hl` as a register pair. If one half is live with a real value and the other is undef (which fastregalloc CAN arrange), the OR-of-halves check says "save," but the PUSH reads partial-undef and trips `-verify-machineinstrs`.

**Why:** The standard "save HL if either half is live" is the natural-looking gate but it conflates "I need to preserve the live half" with "I have a fully-defined HL to push." The Z80 PUSH instruction is pair-only — there is no way to push just H or just L. So when one half is dead, the save bracket is needed for the live half but the pair PUSH would read undef on the dead half.

**How to apply:** Whenever you see `if (HLLive) PUSH_HL` in a new expander or pseudo-expansion path, check whether the code accounts for the dead-other-half case. The canonical fix is:

```cpp
if (NeedSaveHL) {
  if (!HLive)  // H half is dead
    BuildMI(MBB, MI, DL, get(TargetOpcode::IMPLICIT_DEF), Z80::H);
  if (!LLive)
    BuildMI(MBB, MI, DL, get(TargetOpcode::IMPLICIT_DEF), Z80::L);
  BuildMI(MBB, MI, DL, get(Z80::PUSH_HL));
}
```

For GR8 SPILL/RELOAD where one half is the source/destination, the source half is already in A (spill) or about to be overwritten (reload), so only the SIBLING needs IMPLICIT_DEF — see `expandSpillGR8SPRelative` / `expandReloadGR8SPRelative` in `llvm-z80/llvm/lib/Target/Z80/Z80RegisterInfo.cpp` for the worked example.

**Known sites** (filed 2026-06-22):
- `Z80RegisterInfo.cpp`: SP-relative GR8 spill/reload (FIXED #210), large-offset GR8 spill/reload (FIXED #212 + symmetry follow-up), SPILL_GR16 isKill case (#236 latent), ADD_HL_FI/SUB_HL_FI large-offset (#237 latent), adjCallStackUpClobbersReg sync invariant (#238 supporting).
- `Z80InstrInfo.cpp`: ZEXT/SEXT_GR8_GR16 IX/IY paths, SPILL/RELOAD_GR16 IX/IY paths, SEXT16 IX/IY path, `copyPhysReg` SP→BC|DE + GR8↔IXH/IXL/IYH/IYL — **ALL FIXED 2026-06-23** (#239 fully closed; 9 lit tests, 164 PASS+6 XFAIL).

**Why latent matters less than it sounds**: production targets (`-Oz`/`-Os`/`-O2` +static-stack) never reach these arrangements — verified by `verify-production.sh` staying clean. The failures only surface at `-O0` where fastregalloc places undef physregs in patterns that the optimizer would have eliminated. So these are correctness-for-O0 + future-proofing, not production-shipping bugs.

**Related rule**: When auditing pseudo-expansion code that uses HL/IX/IY borrow, also check whether the corresponding `PUSH_AF` (for FLAGS preservation) uses `emitFlagPreservingPushAF` — the #209-fix that marks the `$a` read undef when A is dead. Same family of "save pair to preserve part of it, but the read trips verifier" bugs.

See also [[feedback_explain_before_filing]] (the predecessor to today's #212 close — the previous attempt patched wrong sites). The lesson is to do empirical bisection (which specific MI emits the failing instruction?) before trusting an issue body's classification of the cause.

---
name: project_pce_rc759_vs_mame_accuracy
description: Two-oracle split (user, 2026-08-18) — MAME is the oracle for CCP/M-86 *software* behavior (vs. lighter emulators emu2/Unicorn); PCE is the oracle for RC759 *hardware* emulation (vs. MAME's own rc759 driver). Not a blanket "PCE beats MAME" claim.
metadata:
  type: project
---

**User statements, 2026-08-18:**
1. "pce er så vidt jeg ved god nok til at kunne køre piccoline software
   korrekt. Det er mame ikke endnu" — PCE (Hampa Hug's independent RC759
   emulator, `src/arch/rc759/` — video.c/fdc.c/rtc.c/keyboard.c/speaker.c/
   nvm.c/parport.c) is, to the user's knowledge, already good enough to run
   Piccoline software correctly; MAME's `rc759` driver is NOT there yet.
2. Clarification/precision pass: **"mame er orakel på ccp/m-86 opførsel i
   forhold til emulatorer som emu2 og unicorn. pce er orakel på rc759
   hardware emulering."** — i.e. this is a two-axis split, not a single
   "PCE > MAME" ranking:
   - **MAME = oracle for CCP/M-86 *software/OS-level* behavior**, when
     compared against the lighter functional emulators (emu2, the Unicorn
     runner) — MAME wins that comparison because it's cycle-accurate
     hardware emulation vs. functional-only shims.
   - **PCE = oracle for RC759 *hardware* emulation specifically**, when
     compared against MAME's own `rc759` driver — PCE wins THAT comparison
     because MAME's rc759 driver is still maturing (i82730 cursor/cmdq
     quirks, col-80 fix, keyboard-mapping work all found bugs in it).

So: MAME still outranks emu2/Unicorn for CP/M-86-level correctness checks.
It's specifically MAME's *rc759 hardware driver* that PCE outranks.

**Why this matters:** many existing memory entries assert "MAME rc759 is the
true/authoritative oracle" for RC759 work (`reference_cpm86_interrupt_vector_install.md`,
`reference_watcom_cpm86_softfloat_fpc.md`, `reference_watcom_cpm86_whetstone_libm.md`,
`reference_watcom_cpm86_diskio.md`). That framing predates this correction and
was based on MAME being cycle-accurate hardware emulation vs. emu2's
functional-only DOS/CP/M-86 emulation — it never directly compared MAME
against PCE's RC759-specific implementation. The known MAME rc759 issues this
session's context already carries (i82730 cursor/cmdq quirks, col-80 fix,
keyboard-mapping work — `tasks/rc759-i82730-cursor-and-cmdq-2026-08-17.md`,
`tasks/rc759-firmware-keymap-2026-08-18.md`) are consistent with MAME still
maturing on this specific machine.

**How to apply:**
- Do NOT treat "MAME rc759" as automatically ground-truth going forward
  without caveat — for RC759-specific behavior (video/i82730, disk timing,
  keyboard), PCE may currently be the better reference, per the user.
- When a MAME rc759 result looks surprising or contradicts firmware
  expectations, cross-check against PCE/rc759 before concluding the firmware
  (or the compiler output) is wrong — it may be a MAME driver gap.
- Real hardware is still the ultimate ground truth when available; PCE and
  MAME are both proxies, but PCE is (per the user) presently the stronger
  proxy specifically for RC759.
- Building/using PCE/rc759 as an active differential-testing tool (not just
  a reference) was proposed to the user but not yet acted on as of this
  memory's creation — check session state before assuming it's set up.

Related: `[[reference_rc759_mame_sonnyboy_headless]]`, `[[reference_mame_regnecentralen_rc75x_imd]]`.

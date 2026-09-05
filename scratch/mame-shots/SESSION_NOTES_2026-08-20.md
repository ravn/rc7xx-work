# RC759 i82730 session — 2026-08-20

## Outcome
- **Root-caused** the ~15-min idle "top rows -> garbage + status line vanishes" bug on
  the RC759 (PICCOLINE) CCP/M-86 config menu. Filed as **ravn/mame-rc702-rc759-rc750#28** (authoritative
  record: analysis, garbage screenshot, command-level trace, resume-here handoff).
- **Mechanism (verified):** deterministic flip at emulated t=941.104s / frame 58816.
  The guest issues `LD CUR POS` (cmd 0x09) every frame; `execute_command()` re-latches
  `m_list_switch` from bit7 of `[cbp+2]` on EVERY command (i82730.cpp:306). At the flip
  one such command carries list_switch=1, so `row_update` reads list1 base (cbp+10/12)
  instead of list0 (cbp+6/8): sptr 0x0185b0 -> 0x00faa2 = garbage. No MODE SET / LOAD
  CBP; geometry + statptr (cbp+34/36=0x00f9f0) unchanged. Pressing any key clears it in
  ~1s (verified vs a no-key control that persists ~19s). Consistent with a CCP/M idle
  screensaver writing list-1.
- **Falsified:** stack overflow, IRQ pileup, guest VRAM/font corruption, stale bitmap,
  blink self-heal.
- **Leading unconfirmed cause of garbage-vs-blank:** MAME i82730 parses but never
  APPLIES char/field attributes (invisible/blink/reverse/underline, i82730.cpp:247-269 —
  no read sites in render), so an attribute-blanked screensaver list renders raw codes.

## Merge (this session)
- Merged **rc759-i82730-cursor -> master** (`--no-ff`, merge commit 147ecff) in the mame
  submodule and pushed to origin/master (e9301672d7d..147ecfff065). 12 tested RC759/RC750
  fixes; fully subsumes rc759-fdc-dma-fix. Build-verified (SDL regnecentralen target).
- Kept branch `rc759-i82730-cursor` (not deleted) — still referenced by the open #28
  investigation. Delete when #28 closes.

## Diagnostics (re-usable)
- `i82730_diagnostics.patch` — temp C++ instrumentation (CMD/FRAMESIG/ROW0CHG loggers).
  Reapply on mame master with: `cd /Users/ravn/z80/mame && git apply <patch>`.
- `flip_key.lua` (keypress-wake test), `flip_ctrl.lua` (no-key control), `dump_cbp.lua`
  (CBP structure dump).

## Resume-here
1. Decode list-1 datastream bytes at t>941 (during garbage) to confirm attribute-blanked
   screensaver.
2. Confirm why the status line blanks with statptr unchanged.
3. Implement + verify the fix (apply parsed char/field attributes in row_update) vs
   datasheet + real hardware.

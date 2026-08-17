---
description: RC759 Piccoline i82730 CRT display facts and fixes (MAME regnecentralen subtarget) — screen timing, load_row semantics, colors, geometry — plus the DDHF cache inventory of original RC759 disk images.
---

# RC759 i82730 CRT display (MAME) + DDHF original-image inventory

Work done 2026-08-17 on branch `rc759-i82730-cursor` in `/Users/ravn/z80/mame`
(pushed to origin `ravn/mame`, NOT merged, no PR). The i82730 device is used
ONLY by rc750/rc759 (only `rc75x.h` includes `i82730.h`) — compis moved off it,
so device-level changes carry no compis regression risk.

## Build

`cd /Users/ravn/z80/mame && make SUBTARGET=regnecentralen REGENIE=1 SOURCES=src/mame/regnecentralen/rc759.cpp OSD=sdl -j 10`
→ binary `./regnecentralen`, ~4s incremental. `rc75x.cpp` compiles via the
rc759.cpp SOURCES filter.

## Screen: 62.5 Hz standard screen (NOT 73 Hz)

**User (operated the hardware):** the RC759 Piccoline used the STANDARD screen
(~62.5 Hz / ~19.5 kHz); the better 73 Hz / 22 kHz screen was the RC750
**Partner's**, only later back-ported to the Piccoline. So rc759 defaults to the
62.5 Hz screen. Set the 82730 char clock = 62.5 × 47 × 312 = **916'500 Hz**
(`rc75x.cpp` `I82730(config, m_txt, 916'500, m_maincpu)` + matching `set_raw`).
Measured result: frame_period 16.000 ms, refresh 62.5000 Hz (screen 560×261).
The screen VBLANK drives `tmrin0_w` → the firmware's 16 ms system tick is now
correct (was 11.7 ms at the old wrong 85.24 Hz from clock 1'250'000).
PARTNER Programmers Guide documents standard tick = 16 ms (62.5 Hz), 73 Hz option
= 13.7 ms. Commit `50dd4fa7a2f`.

## load_row: consume EXACTLY MAX DMA COUNT words per row

`i82730_device::load_row()` must store exactly `m_max_dma_count` char words per
row, checking the count BEFORE each read (do not use an (N+1)th read as the stop
signal). Firmware uses BOTH list layouts (measured, max_dma=80):
- `auto_line_feed = 0` (konfig menu): each row is a separate 80-word string with
  NO trailing EOL command (`reason=dma-exhaust`); all 80 must be stored (the 80th
  = screen column 79 = right menu border) then load next string ptr from the list.
- `auto_line_feed = 1` (boot console): the string is CONTINUOUS across rows;
  over-reading even one word per row skips a char and shifts every following row
  left, splitting words like "READING CONFIGURATION FILE = KDEF.SYS" over two
  lines.
An earlier post-decrement fix (that fixed the menu's column 79) regressed the
boot console this way; the fix is exact-count consumption in BOTH modes.
`dscmd_repeat` uses the same check-then-store-then-decrement accounting.
Commit `20070a869ce`.

## Other display fixes (same branch)

- Column 79 + top gap (`8e66ebd7e4e`): visarea vertical expressed in content
  coords (`vfldstrt - vsyncstp` .. ), text hugs top; screen 560×291 → 560×260.
- Colors/pitch (`ace2bb71860`): amber (#FFB000) text, dark-amber bg
  `rgb_t(0x1a,0x12,0x00)` (P3 glass never fully black), fixed `i*7` cell pitch,
  width clamp >7→7 (cursor on empty cell mis-measured 15 → double-wide block).
- Font word (rc75x.cpp txt_update_row): high 7 bits [15..9] = pixels (bit15
  leftmost), bit8 separator, low byte = unary width guard; `on = BIT(gfx,15-p)`.
- Cursor = reverse-video the cell (device owns cursor pos/blink). Cursor at the
  A> prompt renders correctly (col 2).

## Open i82730 issues (ravn/mame, filed not fixed — hardware values not guessed)

- **#24** cursor blinks ~2× too fast even at 62.5 Hz: `cursor_visible()` formula
  `((frame_number()/cursor_blink)&1)==0` ignores `DUTY CYC CURSOR` and
  `FRAME INT COUNT`; measured mode-block word38=0x4701 (duty_cyc_cursor=4,
  cursor_blink=7, frame_int_count=1). The preliminary 82730 datasheet OCR
  (linked in rc759.cpp) lists these fields but NOT the blink-rate formula.
- **#23** soft scroll (blød rulning) not emulated: SL SCROLL START(0x84)/END(0x85)
  datastream cmds stubbed. Config via NVM byte18 4MSB / ESC 244.
- **#22** hardware cursor rendering; **#25** SDIR.CMD shows bad data on levee
  image — **INVESTIGATED: not a MAME bug** (see below); **#26** are any DDHF
  RC759 images configured for four consoles; **#20** RC759 outstanding-bugs
  umbrella.
- Warm-reset artifacts (cursor default pos, first bootloader line misplaced):
  `device_reset()` is minimal — doesn't clear m_cursor, display-list/row state,
  or m_bitmap → stale artifacts on warm reset (F3). Diagnosed, not fixed.

## DDHF original RC759 disk images (workspace cache)

In `scratch/rc759-cmd-toolchain/ddhf-cache/bits/` (fetch via `fetch-ddhf.sh`;
extract IMD via `imd2raw.py in.imd out.raw`, then cpmtools with `./diskdefs`
`-f rc759-drc`). ALWAYS search the whole workspace before re-fetching.
- **30005869.bin** — IMD, DR C v1.11 compiler disk (the DR C oracle;
  see reference_rc759_official_drc_disk.md).
- **30004107.bin** — ZIP/BagIt, **SW1400_r3.1** = RC759 CCP/M system software,
  **4-disk set** (data/disk1..4.imd). Original DDHF image.
- **30004229.bin** — ZIP/BagIt, **SW1400_r3.1a** (newer revision), same 4-disk
  layout. Original DDHF image.
- **30002664 / 30002725** — CCP/M May84 / Oct83, NOT IMD (RC750 container,
  imd2raw can't read).
- **30002839** — RC759 container (starts `RC75...`).

The SW1400 4-disk sets (disk1.imd = boot/system) are the pristine originals to
run SDIR.CMD / check four-console config against (#25, #26). MAME rc759 boots
raw images; convert IMD→raw first.

## SDIR bad-data investigation (#25) — VERDICT: not a MAME bug

Ran SDIR on the original DDHF SW1400_r3.1a disk1 vs the levee.img dev image via
the SAME rc759 i82730 path. Original renders perfectly clean (70 files, aligned
columns); levee shows garbage filenames in the lower half (hoekSOeRW!, hnAe50z...).
Two independent oracles (pixel differential + host-side `cpmtools cpmls`, which
never touches MAME) agree the difference is on-disk content, so the garbage is
NOT an i82730 rendering/emulation defect. Verdict + before/after screenshots
posted to ravn/mame#25.

RETRACTED a premature "un-zeroed directory" cause: dumping the FIRST 8 KB dir
block of BOTH images shows an identical 65 status-0x20/0x21 entries (normal CCP/M
disk label + timestamp/SFCB records) and clean user-0..15 file entries in both.

## SDIR #25 ROOT CAUSE CONFIRMED — wrong cpmtools diskdef (maxdir 256 vs 512)

The RC759 CCP/M-86 directory holds **512 entries**, not 256 (SDIR trailer:
"Used/Max Dir Entries For Drive A: nnn/512"). 512×32 = 16 KB = TWO 8 KB dir
blocks (8 blocks of 2048); CP/M-3 style, so every 4th slot is a datestamp SFCB
(0x21) in BOTH blocks. The cpmtools diskdef `drc-rc759` had **maxdir 256** (only
block 0). Two consequences, both reproduced byte-for-byte:
1. cpmtools is BLIND to entries 256-511 → `cpmls` reported a clean 64-file list
   while the real BDOS/SDIR walks all 512 and shows the garbage in block 1
   (the 64-vs-99 discrepancy).
2. maxdir 256 reserves only 4 dir blocks instead of 8, so `cpmcp` writes file
   DATA over the real directory's 2nd block. A/B proof on a pristine copy: one
   `cpmcp` with maxdir 256 turned block1 from {E5:192, SFCB:64} into
   {file:62, E5:144, SFCB:48, other:2} (SFCBs destroyed); the SAME cpmcp with
   **maxdir 512** left block1 byte-identical to the untouched original.
Original DDHF disks (SW1400 CCP/M + raw DR C 30002664/30002725) all carry a
clean 512-entry dir with SFCBs in block1; levee.img/mandel.img were built with
the maxdir-256 tooling and have corrupt block1 garbage. **FIX: maxdir 512** in
the diskdef — applied to scratch/rc759-pce/images/diskdefs AND the Open Watcom
submodule contrib/ravn/owc-drc/diskdefs. Already-built dev images (levee/mandel)
are corrupt; rebuild from a pristine original with the fixed diskdef. NOT a MAME
bug (i82730 rendered the on-disk garbage faithfully); #25 CLOSED not-a-MAME-bug.

### Reaching the CCP/M console past the turnkey PICCOLINE menu (KEY technique)
The SW1400 originals boot to a turnkey "Installations- og Konfigureringsmenu"
(the menu IS the shell). ESC only navigates submenus. To exit to the TMP
(CCP/M console): press **Ctrl-Æ**, then answer **j** to "Ok at vende tilbage
til TMP ? (j/n)". Status line flips "Dynamisk MENU" -> "Dynamisk Tmp0" and an
A> prompt appears. natkeyboard:post CANNOT send Ctrl-combos (filters control
codes); drive the ioport directly in lua instead — both Ctrl (LCONTROL,
mask 0x2000) and Æ (KEYCODE_COLON, mask 0x0400) live in the kbd device's
**row_1** port:
```lua
for tag,p in pairs(manager.machine.ioport.ports) do
  if tag:find("row_1") then
    for _,f in pairs(p.fields) do
      if f.mask==0x0400 or f.mask==0x2000 then f:set_value(1) end  -- press
    end
  end
end   -- ~50 frames later set_value(0) to release, then natkeyboard:post("j")
```
levee.img boots straight to A> (Concurrent CP/M-86 3.1, "System med 1 konsol"),
no menu — post "SDIR\13" directly.

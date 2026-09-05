---
name: reference_rc759_mame_sonnyboy_headless
description: How to boot MAME rc759 headless on sonnyboy (Linux) and run a CP/M-86 .CMD via natkeyboard injection, when the macOS turnkey autostart disk (mandel.img) isn't available on this host.
metadata:
  type: reference
---

2026-08-18, sonnyboy. Companion to `[[reference_rc759_mame_c_verification]]`
(macOS, turnkey-disk-based) — this is the from-scratch path when the turnkey
`scratch/rc759-pce/images/mandel.img` doesn't exist on the host.

## What was already present on sonnyboy (no setup needed)

- `mame/mame` (single combined binary, not `regnecentralend`/`regnecentralen`
  subtarget binaries) already has the `rc759` driver compiled in, AND the 4
  ROM files were already at `mame/roms/rc759/` and verify clean:
  `./mame -rompath roms -verifyroms rc759` -> "romset rc759 is good".
- ROM source (if ever needed again): already documented at
  `mame/src/mame/regnecentralen/README.md` lines 68-98 —
  `http://www.hampa.ch/pce/rom/rc759/{rc759-1-2.1,rc759-1-5.1,rc759-2-4.0,rc759-2-5.1}.rom`.

## What was missing: the turnkey autostart disk

`scratch/rc759-pce/images/mandel.img` (CCP/M-86 turnkey disk that autoboots
via `startup.0` -> `menu imenu`) only exists on the macbook. Building an
equivalent from scratch (interactively configuring CCP/M-86 autostart) was
not attempted — instead, booted a **plain** DDHF system disk and drove it
via keystroke injection, which works fine and is simpler:

- Any 1,261,568-byte DDHF "BINARY" rc759 disk works via `-flop1`. Used
  **Bits:30002654 "CDOS systemdisk"** (`scratch/rc759-cmd-toolchain/
  ddhf-cache/bits/30002654.bin`, fetch via `fetch-ddhf.sh 30002654` if not
  cached) — boots to a real `A>` CP/M prompt. (Bits:30002664 "DR C May 84"
  does NOT work as a *boot* disk — floppy loader reports "DISKETTE NOT
  FORMATTED"; it's an application/toolkit disk, not a system disk, despite
  the DR-C-related name. Don't reuse it as `-flop1` boot media.)
- Copy the target `.CMD` onto a COPY of that disk with cpmtools BEFORE
  boot, using the CORRECT diskdef (see the diskdef-bug warning below):
  `cpmcp -f drc-rc759 <copy>.img <path>/PROG.cmd 0:prog.cmd`
  (run from `open-watcom-v2/contrib/ravn/owc-drc/`, which holds the
  canonical fixed `diskdefs`).

## Headless boot + keystroke injection

```bash
cd mame
mkdir -p snap/rc759 nvram/rc759
rm -f snap/rc759/*.png nvram/rc759/nvram
SDL_VIDEODRIVER=dummy ./mame rc759 -bios 0 -skip_gameinfo -rompath roms \
  -flop1 <copy>.img -autoboot_script <script>.lua \
  -seconds_to_run 290 -nothrottle -sound none -video soft -window -nomax
```

Gotchas found the hard way:
- **`-video bgfx` (the default in other scripts) FAILS under
  `SDL_VIDEODRIVER=dummy`** ("Error getting SDL window info" / "BGFX
  library initialization failed"). Use `-video soft` instead — works fine
  headless.
- No `regnecentralend`/`regnecentralen` subtarget binary here, only the
  full `mame` combined binary — adjust any script that hardcodes the
  subtarget name.
- Boot is slow and multi-stage: PICCOLINE bootloader menu (`SELECT
  LOADMEDIUM:`) -> self-test screen -> floppy loader -> CP/M `A>` prompt.
  Each stage takes real emulated seconds; a keystroke sent too early (e.g.
  before `A>` actually appears) is silently swallowed/lost with no error.
  Empirically, `A> ` appears around **~115 emulated seconds** in after
  sending `A\n` to select drive A at the bootloader menu (at ~500%+
  emulation speed on this host, that's roughly 25-40s real time, but pace
  by `m.time.seconds`, not wall clock).
- Lua pattern that works (`natkeyboard:post` timed off `m.time.seconds`,
  periodic snapshots to see progress without guessing):
  ```lua
  local sent1, sent2, last_snap = false, false, -100
  emu.register_periodic(function()
    local m = manager.machine
    local t = m.time.seconds
    if not sent1 and t > 3   then m.natkeyboard:post("A\n");      sent1 = true end
    if not sent2 and t > 115 then m.natkeyboard:post("PROGNAME\n"); sent2 = true end
    if t - last_snap >= 6 then m.video:snapshot(); last_snap = t end
  end)
  ```
- Result appears directly on the CP/M console (read it from the snapshot
  PNG) — no need for a `mame_done`/OUT-0x2FE done-signal harness for a
  one-shot manual check like this (that machinery is for automated
  pass/fail gating, still the right tool for a repeatable test).

## Diskdef bug — READ BEFORE ANY cpmcp WRITE to a real archive disk

`[[reference_rc759_official_drc_disk]]` documents a real corruption bug: the
STALE diskdef name `rc759-drc` (as it existed in
`scratch/rc759-cmd-toolchain/diskdefs` before 2026-08-18) used `maxdir 96,
os 2.2`, but the real RC759 CCP/M-86 directory is 512 entries / os 3. A
`cpmcp` WRITE with the wrong (too-small) maxdir reserves too few directory
blocks and overwrites real file data in the 2nd directory block — this is
the root cause of a prior disk-corruption incident (ravn/mame-rc702-rc759-rc750#25). FIXED
2026-08-18: `scratch/rc759-cmd-toolchain/diskdefs`'s `rc759-drc` entry now
has the correct geometry (content matches the canonical
`open-watcom-v2/contrib/ravn/owc-drc/diskdefs`'s `drc-rc759`, name kept
different for back-compat). **Before any future `cpmcp` WRITE to a real
DDHF archive disk copy, verify whichever diskdef/name you're about to use
has `maxdir 512, os 3`** — `scripts/rc759_make_mandel_b.sh` still uses the
old `rc759-drc` name against a freshly-`mkfs`'d (not pre-populated) image,
which is lower-risk but not yet audited/fixed.

## Result achieved

`contrib/ravn/watcom-cpm86-libc/build-streamio/iotest.cmd` (Watcom's own
UNCHANGED `bld/clibtest/streamio/c/iotest.c`) run on real MAME rc759 hits
the IDENTICAL failure as under `emu2`: `***WARNING*** Condition failed in
(flushes) / fgetc(fpr) != EOF, line 577. / strerror(errno): Bad file
number`. Confirms this is a REAL bug in
`contrib/ravn/watcom-cpm86-libc/port/diskio.c`'s flush/reopen handling (or
a real gap the streamio oracle catches) — NOT an `emu2` fidelity
regression. Root-cause not yet done.

Related: `[[reference_rc759_mame_c_verification]]`,
`[[reference_rc759_official_drc_disk]]`, `[[reference_host_sonnyboy]]`.

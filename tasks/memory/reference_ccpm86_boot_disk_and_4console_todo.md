---
name: reference_ccpm86_boot_disk_and_4console_todo
description: Genuine CCP/M-86 boot disk (not CDOS) is the default A: for both rc759_boot_pce.sh and rc759_boot_cpm.sh, AND is already a working 4-console system out of the box — the "needs installing" assumption below was WRONG, corrected 2026-08-18.
metadata:
  type: project
---

## CORRECTION 2026-08-18: this disk already boots as a 4-console CCP/M-86 system

The "no 4-console disk exists yet, needs installing" note below is **WRONG**.
Booting `sw1400-r3.1a-disk1.img` under MAME (`floptool flopconvert rc759 mfi`
first) and pressing `A` at the PICCOLINE bootloader menu reaches, a few
seconds later, the real XIOS banner:

```
PICCOLINE XIOS version 3.1   Januar 1987
  384 K bytes hovedlager
  6 Mhz CPU
  2 Diskettestation(er)
  2 Databuffer(e)
  1 Katalogbuffer(e)
  261 K bytes brugerlager
Concurrent CP/M-86 3.1
Copyright (C) 1983, Digital Research
System med 4 konsoller
Start Kommando: menu imenu
```

**"System med 4 konsoller" is already printed at every boot** — this disk
*is* a ready 4-console CCP/M-86 system, not merely an installer that can
build one. It just auto-starts an installation/configuration MENU utility
(`menu imenu`, from `0:startup.0`) instead of dropping to `A>` directly.
384 K total RAM / 261 K user-available RAM is also visible right here at
boot, confirmed against MAME driver source (`rc759.cpp`: RAM is hardcoded
384K, not configurable).

**To boot straight to a command / run a program without touching the
interactive menu system:** `0:startup.0` on the disk is a **plain text**
CP/M command file (128-byte record, `"menu imenu\r\n"` + 0x1A padding) —
overwrite it with cpmtools (`cpmrm` then `cpmcp`, can't overwrite in
place) to whatever command you actually want, e.g. `"b:prog\r\n"`. Do
this on a FRESH COPY of the cached image, never the cached original. This
is far more reliable than trying to time `natkeyboard` keystrokes through
the interactive installer menu tree (which has confirmation prompts —
`ESC` then `J` for "ja" — and many nested submenus that are easy to
mis-navigate blind). `open-watcom-v2/contrib/ravn/watcom-cpm86-libc/
build-farheap.sh`'s MAME verification pass used exactly this technique.

Everything below this correction (the disk identity, TODO framing) is
kept for history but the "not done yet" framing is stale.

---

2026-08-18. User distinguished CDOS from CCP/M-86 (CDOS is a later,
different successor OS) and asked that both RC759 boot wrapper scripts use a
genuine CCP/M-86 disk.

**Source:** Bits:30004229 "SW1400 CCP/M-86 Distributionsdiskette 3.1a"
(BAGIT zip wrapping 4 IMD disks). `disk1.imd` converted to raw with the
existing `scratch/rc759-cmd-toolchain/imd2raw.py` → cached at
`scratch/rc759-cmd-toolchain/ddhf-cache/derived/sw1400-r3.1a-disk1.img`
(1,261,568 B, matches `rc759-drc` diskdef geometry exactly). Boots (verified
under PCE) to the real "Installations- og Konfigureringsmenu, PICCOLINE
Version 3.1" — genuine CCP/M-86, not CDOS. Now the default `A_DISK` in both
`scripts/rc759_boot_pce.sh` and `scripts/rc759_boot_cpm.sh` (was previously
a broken/CDOS default in each — see those scripts' own header comments for
the full story).

**TODO, deferred by the user ("hvis vi ikke har en sådan i arkiverne, er det
en todo til senere"):** this distribution disk is an *installer*, not a
ready-to-boot system — its own on-disk strings show it supports building
either a 1-console or a **4-console** system:
```
Installer normal systemdiskette  - 1 konsol
Installer normal systemdiskette  - 4 konsoller
```
(also COMAL80-flavored 1/4-console variants, and separate `dd75xh*.sys` vs
`dd75xh*1.sys` driver pairs that likely correspond to the two configs). No
pre-built 4-console CCP/M-86 boot disk exists anywhere in the cached
archives yet. Producing one means actually running this installer's
"Installation af system" → 4-console path through to completion and saving
the resulting disk — not yet done. Until then, both boot scripts boot the
plain, un-installed distribution disk (1-console-equivalent, installer menu
first).

**How to apply:** if a task needs a genuine multi-console CCP/M-86 test rig
(e.g. testing CP/NET or multi-user firmware paths), this is the blocker —
either run the 4-console install interactively first (PCE, with real X11
keyboard per `[[reference_pce_rc759_headless_automation]]`), or check
whether a later disk in the datamuseum catalogue already ships pre-installed.

Related: `[[reference_pce_rc759_headless_automation]]`,
`rc700-gensmedet/docs/DATAMUSEUM_RC759_ARTIFACTS.md`.

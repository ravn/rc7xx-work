---
name: reference_rc7xx_mame_boot_disks
description: Which disk image boots which regnecentralen MAME machine (rc702/rc750/rc759) — the machines take INCOMPATIBLE floppy formats, so a disk for one will NOT boot another.
metadata:
  type: reference
---

2026-09-04, macbook. Verified by headless boot + snapshot after building
`regnecentralend` (SUBTARGET=regnecentralen). Each machine takes a DIFFERENT
floppy format — using the wrong machine's disk gets you the boot-ROM/bootloader
but never an OS.

## Per-machine verified boot disk (all in `~/Downloads` or workspace `scratch/`)

| Machine | Disk | Boots to |
|---|---|---|
| `rc702` | `~/Downloads/SW1711-I8.imd` (8") | CP/M 2.2 → `A>` |
| `rc702mini` | `~/Downloads/CPM_med_COMAL80.imd` (5.25") | CP/M + COMAL80 |
| `rc750` | `~/Downloads/SW1500_2.0.imd` (**Partner**) | CCP/M-86 2.0, RC750 XIOS v1.0, 512 KB / 2 disk |
| `rc759` | `scratch/rc759-pce/images/sw1400_r31a_d1.img` (**Piccoline**, SW1400 r3.1a) | CCP/M-86 3.1 install/konfig menu |

## The trap I fell into (2026-09-04)

**`SW1500_2.0.imd` and `SW1542_RcSkak_r3.1.imd` are RC750/Partner disks.** Feeding
`SW1500` to `rc759` shows the `PICCOLINE BOOTLOADER 2.1` menu then
**"DISKETTE NOT FORMATTED"** — that is rc759 correctly REJECTING a Partner-format
disk, NOT a driver bug. Piccoline (school 16-bit) and Partner (business 16-bit)
are siblings with incompatible diskette formats. The README's rc759 example
still uses `SW1500` and only reaches that bootloader menu.

## Boot-check recipe (headless, snapshots)

- rc702/rc750: run ~33 s, snapshot; boots fast. `scratch/boot_snap.lua`.
- rc759: floppy boot is SLOW; post `A\n` via natkeyboard at t>4 to pick DRIVE A,
  run `-seconds_to_run 305`, snapshot every 20 s, read a LATE frame.
  `scratch/boot_snap_rc759.lua`. (See also `[[reference_rc759_mame_c_verification]]`
  — turnkey disks autoboot ~t175-290.)
- Common flags: `-skip_gameinfo -nothrottle -video none -sound none`
  `-autoboot_script <lua>`. Snapshots land in `mame/snap/<machine>/`.
  `-video none` still renders snapshots fine.

Related: `[[project_rc750_partner_boot_bringup]]`,
`[[feedback_verify_machine_specific_before_concluding]]`.

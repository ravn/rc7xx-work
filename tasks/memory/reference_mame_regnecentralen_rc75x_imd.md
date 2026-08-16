# MAME regnecentralen: rc75x shared base, IMD-is-writable, blank-disk=MFI

2026-08-16, rc7xx-work. Verified while adding the RC750 Partner driver and a
writable B: drive to the rc702 launcher.

## RC759/RC750 share a base class rc75x_state
- `mame/src/mame/regnecentralen/rc75x.h` + `rc75x.cpp` hold the common core:
  Intel 80186 + 8259A PIC + 8255 PPI + 82730 CRT + MM58167 RTC + bank-switched
  256x4 NVM + SN76489A + HLE keyboard, plus `add_common_devices(config)`.
- `rc759.cpp` (Piccoline: WD2797/cassette/iSBX/Centronics) and `rc750.cpp`
  (Partner: WD1797=FD1797 + Intel 8274 SIO, SCSI/8087 TODO) BOTH derive
  independently from rc75x_state — rc750 is NOT a subclass of rc759.
- rc750 is MACHINE_NOT_WORKING: no Partner ROM dump exists (not on
  hampa.ch/pce, only rc759 is), and the PARTNER Programmer's Guide Appendix B
  (I/O map) is an OCR-blank scan, so Partner-specific ports are provisional.
- Each driver carries a hardware-overview header comment from its guide (saved
  in rc700-gensmedet/docs/PICCOLINE_* and PARTNER_*).

## Build gotchas (SUBTARGET=regnecentralen)
- Adding/removing a .cpp in the folder needs `REGENIE=1` once, else the new
  file is not compiled. SOURCES must list the new file(s).
- SUBTARGET build REQUIRES a SOURCES= filter (no bare subtarget definition).
- Stale-archive: if an already-built .o (e.g. rc702.o from an earlier build) is
  older than libmame_regnecentralen.a, adding it to SOURCES won't re-archive it
  -> undefined-symbol link error. Fix: `touch` that .cpp to force recompile.
- Build cmd: `make SUBTARGET=regnecentralen REGENIE=1 DEBUG=1 SOURCES="src/mame/regnecentralen/rc702.cpp,.../rc75x.cpp,.../rc759.cpp,.../rc750.cpp" TOOLS=1 SYMLEVEL=3 SYMBOLS=1 OSD=sdl -j 10`.

## IMD is read/write in this MAME build (corrects old lore)
- `imd_format::supports_save()` returns true and `save()` is fully implemented
  (`src/lib/formats/imd_dsk.cpp:709,981`). So MAME writes guest changes back to
  the .imd on exit — A: (SW1711-I8.imd) edits persist. The "IMD is read-only in
  MAME" assumption is WRONG here (may have been true for older/upstream MAME).

## A blank/empty writable floppy must be MFI, not IMD
- IMD can only store already-formatted tracks; `save()` refuses a disk with no
  formatted tracks, and `floptool flopcreate imd u8dsdd` yields an unloadable
  "Unknown format" file. A raw zero-filled .img also fails ("Unable to identify
  image file format").
- Use MFI: `floptool flopcreate mfi u8dsdd <out>.mfi` makes a blank, writable
  8" DS/DD image that rc702 loads; format it once from within CP/M and the
  change persists in the MFI. (floptool ships with a TOOLS=1 build.)
- Launcher: `scripts/rc702_boot_cpm.sh` (top-level repo) mounts A: SW1711 IMD +
  an empty MFI B:.

## rc759 boot: separate release/debug binaries -> stale-binary trap
- MAME builds two independent binaries with separate object trees:
  `mame/regnecentralen` (release) and `mame/regnecentralend` (debug, `d`
  suffix = DEBUG=1). `make`-ing one does NOT rebuild the other.
- The WD2797 "LOST DATA blocking program load" fix is commit 59b21dc:
  `src/devices/cpu/i86/i186.h` services DREQ immediately in `drq0_w` (the
  i80186 internal DMA was servicing bytes one CPU-step deferred, missing the
  ~16us/byte WD2797 window -> S_LOST poisons the whole sector), plus rc759.cpp
  seeds a known-good NVRAM (boot medium 'A') + 384K RAM map.
- TRAP: a `regnecentralen` built BEFORE the fix still passes `-validate rc759`
  (validation only checks machine-config validity, not codegen), so a launcher
  that picks the *first* validating binary silently runs the stale one and
  reproduces LOST DATA. `scripts/rc759_boot_cpm.sh` now picks the NEWEST
  validating binary by mtime. When in doubt, rebuild.
- Boot oracle: with the fix, `mame/regnecentralen rc759 -flop1 <native-rc759
  .img>` boots mandel.img to the "PICCOLINE Installations- og
  konfigureringsmenu Version 2.3" with 0 LOST / 0 RNF.
- rc759 disks are 5.25" DS-HD in the `rc759` wd177x format (77 cyl x 2 x 8 x
  1024 = 1,261,568 B). Watcom boot image: scratch/rc759-pce/images/mandel.img
  (native rc759, NOT PCE .pfdc). DDHF catalogue of native rc759 disks:
  rc700-gensmedet/docs/DATAMUSEUM_RC759_ARTIFACTS.md.

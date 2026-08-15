# Watcom OWN disk FILE\* path on CP/M-86 via an FCB random-record seam — PROVEN

2026-08-15, milestone #10 / **rc7xx-work#7 disk half** (the console-write half
landed as milestone #3). `build-diskio.sh` + `test/disktest.c` run Open Watcom's
**UNCHANGED** buffered FILE\* layer — `fopen`/`fclose`/`fwrite`/`fputs`/`fprintf`/
`fread`/`fgets`/`fgetc`/`fseek`/`ftell`/`remove` — against **real CP/M-86 disk
files** under emu2. Self-checking oracle: 511 `VERIFY`s → `DISKIO: PASS`, purity
`INT21h=0 · BDOS=15`. All 8 build scripts stay green (no regression).

## The one seam: `port/diskio.c`

SUPERSEDES `stdioshim.c` in this build (owns the same console `__qwrite`/`isatty`)
and adds the five low-level primitives `fopen` bottoms out into — `_sopen` /
`__qread` / `__qwrite` / `__close` / `__lseek` — plus `lseek` / `_tell` /
`remove` / `unlink`, all over CP/M-86 **FCB random-record BDOS** (INT 0E0h).

- **Record model does the work.** CP/M has no byte-granular length (128-byte
  records only), so use `READ RANDOM` fn 33 / `WRITE RANDOM` fn 34: `record =
  pos>>7`, `offset = pos&127`. An unwritten record reads back as EOF (BDOS AL=1
  unwritten / 4 past-EOF) → fill the work buffer with `Ctrl-Z` (0x1A); a
  partial last record keeps a `Ctrl-Z` tail on disk = CP/M text-EOF **for free**.
  Text read stops at first `Ctrl-Z`; binary does not. **Byte-exact length is
  tracked LOCALLY** in `dfile_t.len` (seeded at open, extended by every
  `__qwrite`), so `SEEK_END`/`ftell` are byte-exact for the whole life of an
  open handle on any CP/M — a 200-byte binary write reports 200, not 256.
  The old bug: `SEEK_END` used FILESIZE (fn 35) and rounded up to a record.
- **DMA:** set BOTH fn 51 SETDMASEG (DX=DS via `mov ax,ds`) and fn 26 SETDMA
  (DX=&dma) before each random op; don't trust the load-time default DMA base.
- **FCB (36 B):** [0]drive(0=default,1=A) [1..8]name [9..11]type [12]ex [13]s1
  [14]s2 [15]rc [16..31]alloc [32]cr [33..35]r0/r1/r2 random record LE. OPEN
  (15)/MAKE (22) return 0xFF on fail; CLOSE 16, DELETE 19, FILESIZE 35.

## Link-closure gotchas (why fseek/ftell/fopen needed extra help)

- **fseek/ftell call the PUBLIC `lseek()`/`_tell()`, NOT `__lseek`.** The stock
  `lseek.c`/`tell.c` drag in the whole per-handle iomode table
  (`__GetIOMode`/`__SetIOMode`/`__handle_check`/`__NFiles`) this minimal seam
  omits, so `diskio.c` provides its OWN thin `lseek`/`_tell` routing straight to
  `__lseek` (`_tell(h)` == `lseek(h,0,SEEK_CUR)`).
- **fopen chain:** `fopen`→`_fsopen`→`__allocfp`+`__doopen`(static in fopen.c)→
  `_sopen`. Link objects: `fopen.obj fclose.obj allocfp.obj freefp.obj`.
  Read path: `fgetc.obj` (has `__filbuf`/`__fill_buffer`→`__qread`) `fgets.obj
  fread.obj feof.obj`. Data globals: `comtflag.obj` (`_commode=0`),
  `textmode.obj` (`_fmode=O_TEXT`).
- **Unreachable TTY-branch stubs** (disk streams never take `fp->_flag&_ISTTY`):
  `fgetc`'s fill calls `__flushall(_ISTTY)` + `getche()`; `fopen` lowercases its
  mode char via `tolower()`. Stubbed in `port/stubs.c` **guarded by
  `-DDISKIO_LSEEK`** so the other builds' `stubs.obj` stays byte-identical.
  `-DDISKIO_LSEEK` also excludes the stub `__lseek` (diskio.c owns the real one).
- **errno:** `stubs.c` owns the `int errno` global; `port/errnoptr.c` supplies
  `__get_errno_ptr()` (=&errno) — link BOTH; do NOT re-define `__get_errno_ptr`
  in stubs.c (duplicate with errnoptr.obj in the owtests/whetstone builds).

## The eventual gold-standard oracle (documented next step)

Watcom ships its own self-checking stream-I/O regression tests — the disk
analogue of `float01–04`: `bld/clibtest/streamio/c/iotest.c` (full FILE\*),
`bld/clibtest/handleio/c/iotest.c` (low-level open/read/write/lseek), and
`bld/clibtest/file/c/filetest.c`. Each needs a few more seam primitives than a
v1 round-trip before it can run byte-for-byte unchanged: streamio/iotest uses
`tmpfile`/`tmpnam`/`fscanf`/`fopen("CON")`; handleio uses `chsize`/`dup`/
`filelength`/`eof`; filetest uses `rename`/`access`/`chmod`/`stat`/`utime`.
`test/disktest.c` is the focused v1 gate; graduating to Watcom's own iotest.c is
the recommended follow-up.

## SEEK_END byte-exact length + runtime LRBC (fork 5e2e3509bd, 2026-08-15)

- **Within-session `SEEK_END` is byte-exact everywhere** via local `dfile_t.len`
  tracking. Fixed the record-rounding bug (200-byte binary → 256).
- **Runtime OS-capability probe:** `os_has_lrbc()` caches BDOS fn 12 (S_BDOSVER);
  version low byte ≥ 0x30 = CP/M 3+ / **CCP/M-86** (the RC759's OS) exposes the
  **Last Record Byte Count (LRBC)** for exact binary length; plain CP/M-86 (2.2)
  does not. Decided AT RUNTIME — same binary, right path per OS. `_sopen`
  pre-sets FCB+32=0xFF before OPEN, captures the LRBC the OS writes back
  (`dfile_t.open_lrbc`), decodes exact len = `(records-1)*128 + (lrbc?lrbc:128)`.
- **HONEST GAPS (see `KNOWN_ISSUES.md`):** (a) LRBC read path is smoke-tested
  under emu2 ONLY — **emu2 is NOT authoritative for LRBC; MAME/RC759 is** — no
  MAME confirmation yet. (b) Our write path does NOT persist an LRBC on close,
  so a binary file WE wrote reopens record-rounded even on CCP/M-86; a write-side
  LRBC protocol is unimplemented. (c) FCB+32 is shared by CR and LRBC — cleared
  to 0 after capture for the random-record I/O that follows.
- `KNOWN_ISSUES.md` (new) is the requested honest bug/gap/limit/UNVERIFIED list.
- Oracle now 511 self-checks, purity `INT21h=0 · BDOS=15` (fn 12 added).

## MAME-verified on real RC759 / Concurrent CP/M-86 3.1 (2026-08-15)

`mame-tests/disk-mame.sh` runs `disktest.cmd` on the REAL rc759 under MAME —
the authoritative oracle (emu2 is only a smoke test). **All 511 checks PASS on
the metal**; the screen boots **Concurrent CP/M-86 3.1** and shows `DISKIO:
PASS (511 tests, 0 failures)`. Since the OS reports 3.1, `os_has_lrbc()` is
TRUE there, so the LRBC/version-gated path executes on the real target.

**How the result crosses the emulator boundary — new `mame_out()` primitive**
(added to `mame-tests/mamedone.h`, additive; the old byte-packed `mame_done()`
is untouched): the old convention squeezes pass+fail into one byte each, which
cannot hold a 511 test count. Instead the guest STREAMS a small record as a
sequence of 16-bit words on the undecoded port 0x2FE — tag `0xD15C`, full
`tests`, `failures`, end sentinel `0xE0F0`. `disk_done.lua` collects the words
in program order (single CPU = deterministic) and interprets them on the
sentinel. This carries full 16-bit fields with NO guest-memory or
mid-instruction register reads (which may be unsynced), so it is robust on real
hardware. Verified: `DISK-DONE tag=0xD15C tests=511 failures=0 words=4`.
Files: `disktest.c` `#ifdef MAME_DONE` block; `build-diskio.sh` gains
`DISKIO_EXTRA`/`DISKIO_NORUN` (build the -DMAME_DONE .cmd, skip emu2 run).
STILL emu2-only: the foreign-LRBC decode value (KNOWN_ISSUES #1).

**Fallback branch (plain CP/M-86, no LRBC) — how to verify.** The record-rounded
fallback (`os_has_lrbc()` false, version < 0x30) is NOT exercised on rc759 (it
reports 3.1). **Do NOT modify rc759 to downgrade its version** (user directive
2026-08-15). To test it on a real oracle, use a *different* 8086 MAME machine
that boots plain CP/M-86: DEC Rainbow 100 (`rainbow`), Apricot PC/Xi/F
(`apricot`/`apricotf`), Victor 9000 / Sirius 1 (`victor9k`), or IBM PC
(`ibm5150`). Caveats: our `regnecentralend` build has ONLY rc702/rc703/rc759
compiled in (none of those others), so a full upstream MAME build + that
machine's ROMs + a bootable CP/M-86 floppy image are needed. NOTE: Olivetti M20
is Z8000-based, NOT 8086 — our code will not run there.

**ibm5150 CP/M-86 1.0 oracle — WORKING (2026-08-15).** The plain-CP/M-86
fallback branch (`os_has_lrbc()` false) now has a real MAME oracle: IBM PC 5150
booting DRI CP/M-86 **Version 1.0** (pre-CP/M-3, so LRBC genuinely absent — no
need to force any flag). Added to our `regnecentralend` build (SOURCES gained
`pc/ibmpc.cpp`). Assets under `mame/roms/ibm5150/` (BIOS rev3 1501476.u33 +
CGA font 5788005.u33 + BASIC 5000019-23) and `mame/roms/kb_pcxt83/4584751.m1`;
boot disk = MAME softlist `cpm8610` (raw cpm86.img sha1 f4074a4b…, installed as
`mame/roms/ibm5150/cpm8610.zip`).

Fast-boot recipe (~12 emulated s / ~2 s wall, vs ~110 s with stock 640K RAM —
the 5150 POST memory test is the whole delay, only a blinking cursor until it
finishes):
```
cd mame
./regnecentralend ibm5150 cpm8610 -kbd pcxt -isa4 "" -ramsize 128K \
  -skip_gameinfo -window -nomaximize \
  -autoboot_script <mame-tests>/ram128_boot.lua -nothrottle
```
Gotchas learned: default keyboard `keytronic_pc3270` needs undumped 14166.bin →
use `-kbd pcxt` (good dump). Default `-isa4` hdc needs wdbios.rom → drop with
`-isa4 ""`. `-skip_gameinfo` removes ONE of the two startup screens (the red
warning screen still needs a click unless auto-dismissed). ALWAYS run
`-window` (never headless/-video none) — user watches live. `ram128_boot.lua`
sets motherboard DSW1 "Extra RAM size" DIP to 0x02 (64K expansion → 128K total)
so POST tests only 128K and matches `-ramsize 128K` (else 201 memory error).
CP/M-86 reports "Memory (Kb): 064" TPA which is plenty for disktest.

TODO (harness port, not yet done): disktest needs (a) disktest.cmd on a WRITABLE
CP/M-86 disk (softlist A: is read-only) — needs a cpmtools diskdef for the 160K
IBM-PC CP/M-86 format, and (b) autorun — CP/M-86 1.0 has no turnkey/AUTOEXEC, so
inject keystrokes via lua after `A>` appears. Port 0x2FE io-write-tap in
disk_done.lua should work unchanged on ibm5150 (tap sees the bus cycle even if
COM2 also decodes it; use `-isa2 ""` to be safe).

## ibm5150 CP/M-86 1.0 oracle — PARKED 2026-08-15 (ravn/open-watcom-v2#17)

Goal: verify the `os_has_lrbc()==false` fallback (KNOWN_ISSUES #1) on a genuinely
pre-CP/M-3 target, which RC759/Concurrent CP/M-86 3.1 cannot reach. Harness is
complete and reproducible; BLOCKED on program load. Full writeup + repro in
issue #17. Key corrections to the fast-boot note above:

- DO NOT use the 128K fast-boot DIP recipe for disktest — it gives a 64K TPA and
  `MEMORY NOT AVAILABLE`. Boot at full 640K (default DIPs already = 64K base +
  576K extra); accept the ~110 emulated-second POST.
- ROOT CAUSE of `MEMORY NOT AVAILABLE`: CP/M-86 1.0 self-caps its TPA at 128 KB
  regardless of installed RAM. MAME provides 640K and the IBM POST records it
  correctly (BIOS word `0040:0013` phys 0x413 = 640 => 0x0280, verified via lua),
  but the CP/M-86 1.0 sign-on always reports "Memory (Kb): 128" — the cap is in
  this image's BIOS memory map, not MAME, not fixable via -ramsize/DIPs.
- disktest.cmd CMD header decoded: grp0 CODE 923 para (14768B), grp1 DATA 1460
  para (23360B), fixed min==max (compact/large model, no elasticity), ~37KB
  total. Suspected the two-group fixed-size layout is what CP/M-86 1.0's simple
  loader can't place in its 128K managed region. NEXT: try `wcl86 -ms` small
  single-group model, or run stock STAT.CMD through the harness to prove it.
- WARNING-CLICK FIX: put `skip_warnings 1` + `skip_gameinfo 1` in `mame/ui.ini`
  (skip_warnings is a UI option, NOT a CLI flag; `-skip_warnings` errors out).
  This removes the imperfect-emulation click entirely.
- Verified known-good boot image = MAME softlist `cpm8610` sha1
  f4074a4b2f5826faa893869b163461a8808d13ef (NOT the WinWorld IMD fb070e9f…).
- cpmtools file *removal* corrupts the cpm8610 boot (breaks CPM.SYS contiguous
  load); add-only is safe → pristine A: + separate stripped B: layout.
- CP/M-86 source (if BIOS memory-table patch ever needed): https://www.cpm.z80.de/source.html
- Harness drivers: scratch/rc759-cmd-toolchain/mame-tests/{run_and_dump,ibm_disk_inject,dump_screen}.lua
  Disks: scratch/cpm86-ibm5150/harness/{diskA,diskB}.img + diskdefs.

## GAP #3 progress (clibtest oracle seam) — 2026 session

Landed in port/diskio.c, all emu2-verified via test/disktest.c (DISKIO: PASS
543 tests, 0 failures; purity INT21h=0):
- Low-level POSIX handleio subset: open/creat/read/write/close/lseek/tell/
  filelength/eof. Thin wrappers over the existing _sopen/__qread/__qwrite/
  __close/__lseek seam; byte-exact WITHIN a single open handle (a reopened
  binary file still inherits the record-rounded len — KNOWN_ISSUES #1).
  Single-handle tests MUST open O_RDWR (read+write gates on readable+writable).
- rename(old,new): BDOS RENAME fn 23; old in FCB bytes 0..15, new in 16..31
  (drive byte at +16 = 0). Returns 0xFF -> ENOENT if old not found.
- tmpnam/tmpfile: "TMPnnnnn.$$$" names, uniqueness by open()-probe, auto-remove
  on fclose via Watcom's OWN _TMPFIL flag + __RmTmpFileFn hook (set the flag on
  fp and point the hook at a tiny registry-backed remover; fclose calls it
  AFTER __close). 16-bit unsigned: bound the name search by TMP_MAX (26^3), not
  a 32-bit literal, or wcc warns "comparison always 1" + risks a runaway loop.
- Build add-ons: memcmp.obj, rewind.obj, strcpy.obj now linked in build-diskio.sh.

Commits (LOCAL, open-watcom-v2): f6d09797c1 (low-level I/O + rename),
c06e12c0e1 (tmpnam/tmpfile).

Still open in GAP #3 (larger / DOS-semantic-heavy):
- streamio: fscanf (linkable — DOS-free scnf.c FILE* engine, just larger),
  fopen("CON") console-as-named-file.
- handleio faithfulness: chsize (sparse zero-fill), dup/dup2 (SHARED position ->
  needs handle->dfile refcount indirection), umask/chmod R/O enforcement,
  _hdopen/_os_handle.
- file group: access, chmod, stat, utime.

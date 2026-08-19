---
name: reference_cpm86_toolchain_linux_build
description: How to build the whole Open Watcom / CP/M-86 toolchain (wcc bootstrap, emu2-cpm86, cpmtools, MAME rc759) from scratch on Linux (sonnyboy), companion to the macOS-only reference_watcom_submodule_build_apple_silicon.md.
metadata:
  type: reference
---

**Verified 2026-08-16 on sonnyboy (Ubuntu, x86_64, GCC 15).** Everything below
was built fresh into the workspace with no `sudo`/system package installs — the
project convention (matches `[[reference_watcom_submodule_build_apple_silicon]]`,
which is CLANG/osxa64-specific and does NOT apply here).

## 1. Open Watcom bootstrap toolchain (bwcc/bwasm/bwlink)

Use `OWTOOLS=GCC` on Linux (the Apple note's `OWTOOLS=CLANG` workaround is for
Apple's clang-aliased-as-gcc problem, irrelevant here — real `gcc` is present).
Full release build (`clean.sh && build.sh`) is NOT needed for CP/M-86 work; the
**bootstrap boot stage** alone produces everything `build-cpm86.sh` needs:

```bash
cd open-watcom-v2
export OWROOT=$(pwd) OWTOOLS=GCC OWOBJDIR=binbuild OWBUILD_STAGE=boot
. ./cmnvars.sh
cd bld && sh "$OWROOT/ci/buildx.sh"
```

Output lands in `open-watcom-v2/build/binbuild/`: `bwcc`, `bwasm`, `bwlink`,
`bwdis`, `bwlib`, etc. (`b`-prefixed = bootstrap). Took a few minutes on a
16-core box; no FATAL/DOSBOX/WGML issue hit at this stage (that's a
release-build-only doc-build problem, see the Apple note).

## 2. Build + smoke-test CP/M-86 programs

Emit `.CMD` natively with the linker (`owcc -bcpm86` / `wl format cpm86`):

```bash
export PATH="$PWD/open-watcom-v2/build/binbuild:$PATH"
cd open-watcom-v2/contrib/ravn
wasm hello.asm && wl format cpm86 name HELLO.CMD file hello.obj
```

The old `build-cpm86.sh` (`wasm`/`wcc` → `wl format raw` → `bin2cmd.py`) and
`bin2cmd.py` itself were **RETIRED 2026-08-19** — the linker's native
`format cpm86` writer (`bld/wl/c/loadcpm86.c`) is now the single authoritative
`.CMD` header emitter. The prebuilt `HELLO.CMD`/`DHRY.CMD`/`BIGDATA.CMD`
artifacts remain as runnable references.

**`contrib/ravn/cpm86run.py`** (the repo's own hand-written mini 8086
interpreter) was DELETED 2026-08-16 per user directive ("den vil jeg ikke have,
slet den") — it was missing basic opcodes (0xE8 CALL near hit first; ALU-imm
group 0x80-0x83 next) and, being self-authored, was never a real independent
oracle anyway. **Use emu2-cpm86 + Unicorn instead** (below) — both are
maintained-elsewhere, so a PASS is evidence about the compiler, not about my
own interpreter.

## 3. emu2-cpm86 (the correct emu2 fork — NOT dmsc/emu2)

`cpm86-crossdev/src/fetch/buildemu2` clones **`dmsc/emu2`**, which has **zero**
CP/M-86 support (verified: no `cpm86`/`.CMD`/`cpm86_load` symbols anywhere in
its `loader.c`) — it silently mis-executes a `.CMD` as a raw DOS `.COM` and
crashes on the first non-DOS opcode. The CP/M-86 loader (BDOS via INT 0xE0,
`.CMD` header parsing, FCB bit-7 masking, auxiliary-group loading, BDOS 47
P_CHAIN) lives in a **separate fork**: `johnsonjh/emu2-cpm86`
(`ravn/emu2-cpm86` branch `cpm86-drc-headless` already merged into it, PR
description at `scratch/rc759-cmd-toolchain/emu2-patches/PR_DESCRIPTION.md`).

```bash
git clone https://github.com/johnsonjh/emu2-cpm86
cd emu2-cpm86 && make -j4
EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A ./emu2 HELLO.CMD
```

Verified 2026-08-16: HELLO/DHRY/BIGDATA all match the README's documented
expected output byte-for-byte (Dhrystone every "should be" line; BIGDATA
sum32/crc32/fletcher/ring-walk all MATCH).

## 4. cpmtools (real one — `lipro-cpm4l/cpmtools`, not z80pack's same-named dir)

`rc700-gensmedet/z80pack/cpmtools` is a false positive for a workspace search —
it's z80pack's own **guest-side** CP/M utility sources (r.asm/w.asm/bye.asm
etc., z80 assembly), NOT the host-side disk-image tool (cpmls/cpmcp/cpmrm/
mkfs.cpm) that `mkdisk-cpm86.sh` and the RC759 MAME-boot pipeline need.

```bash
git clone https://github.com/lipro-cpm4l/cpmtools
cd cpmtools
./configure      # do NOT pass --with-libdsk or --without-libdsk!
make -j4
```

**Gotcha:** `--without-libdsk` does NOT mean "skip the libdsk check" — autoconf
sets `LIBDSK=no` (a non-empty string) for `--without-*`, and the `configure.in`
libdsk check only guards on `test "$LIBDSK" != ""`, so passing *any*
`--with(out)-libdsk` flag at all triggers a fatal `libdsk.h` requirement. Just
run bare `./configure` (default `LIBDSK=""`) and it builds fine without libdsk.
This build reads `./diskdefs` from CWD only (`DISKDEFS` env is ignored — same
gotcha `scratch/rc759-cmd-toolchain/diskdefs` already documents); the package's
own `diskdefs` ships a built-in `rc75x` def (154 tracks × 8 × 1024B, block
2048, maxdir 512, boottrk 4, os 3) distinct from the scratch tree's
`rc759-drc` (maxdir 96, os 2.2) — confirm which one matches the actual disk
image before using either.

## 5. MAME rc759 driver, `SOURCES=`-filtered build

The old per-subtarget `regnecentralen.lua` is gone from current MAME (retired
upstream — drivers now register directly in `src/mame/mame.lst`); build with
the `SOURCES=` filter instead (same recipe `CLAUDE.md` already documents for
rc702):

```bash
cd mame
make OSD=sdl SOURCES=src/mame/regnecentralen/rc759.cpp REGENIE=1 -j$(nproc)
```

`SOURCES=` still compiles the **entire MAME core/frontend** (drivenum, UI,
emumem, imagedev, …) regardless of the filter — only the driver-specific
object files are limited. Expect a long build (tens of minutes even on 16
cores) the first time; safe to run in the background and tail the log.

## Still needed for full RC759 MAME boot verification (not yet done 2026-08-16)

- RC759 ROMs (`mame/roms/rc759/*.rom`, per `www.hampa.ch/pce/rom/rc759/`) —
  none present on this host yet.
- A bootable RC759 CP/M-86 disk image with a known-good diskdef (see gotcha
  above) — the macOS-side pipeline's pristine turnkey image
  `scratch/rc759-pce/images/mandel.img` does not exist on this host; must be
  rebuilt or fetched.
- `run-mame.sh`/`mtest.c`-style done-signal Lua harness paths are hardcoded to
  `/Users/ravn/z80/...` in the scratch scripts — need `/home/ravn/z80/...`
  substitution before reuse here.

Related: `[[reference_watcom_submodule_build_apple_silicon]]` (macOS/CLANG
variant), `[[reference_cpm86_crossdev_fork]]`, `[[reference_watcom_wlink_cpm86_format]]`.

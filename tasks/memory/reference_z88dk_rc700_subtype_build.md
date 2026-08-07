---
name: reference_z88dk_rc700_subtype_build
description: How to build the z88dk +cpm -subtype=rc700 target (incl. -compiler=llvmz80) — rc700.lib is not shipped and must be built; graphics = gencon 2x3 sextants
metadata:
  type: reference
---

**z88dk RC700 target = `+cpm -subtype=rc700`** (a subtype of `+cpm`, not a
standalone `+rc700`). Console writes directly to video RAM `0xF800` via
`generic_console` (NOT BDOS) → runtime needs **MAME rc702**, ntvcm shows nothing.

**Prerequisite: `rc700.lib` is a gitignored build artifact and is usually NOT
present in a fresh checkout** → `zcc ... -subtype=rc700` fails with
`file not found: rc700.lib`. Build it natively (see
[[reference_z88dk_lib_toolchain_native]]):
```
cd z88dk && export ZCCCFG=$PWD/lib/config/ PATH=$PWD/bin:$PATH
make -C libsrc TARGETS=rc700 -k -j$(sysctl -n hw.ncpu)   # builds libsrc/rc700.lib
make -C libsrc install                                    # copies *.lib -> lib/clibs/
```

**llvmz80 route works at parity with SDCC** (verified 2026-08-07, standing goal
[[project_z88dk_llvmz80_full_support_goal]]): once rc700.lib exists,
`zcc +cpm -subtype=rc700 -compiler=llvmz80 -O2 -create-app -Cz+cpmdisk -Cz-f
-Czrc700-8dd -Cz--container=imd -o prog prog.c` produces `.com`+`.imd`. A stdio
hello is byte-for-byte identical to the SDCC build **except one byte** in `_main`
(return 0 → `ld de` for clang sdcccall(1) vs `ld hl` for classic) because
llvmz80 reuses the classic clib via bridges. Disk MUST be explicit
(`-Cz+cpmdisk -f <fmt>`); the subtype line (cpm.cfg) no longer auto-generates a
disk. Formats: `rc700-jbox`, `rc700-5dd`, `rc700-8dd`, `rc700-8sd`, `rc703-qd`.
The emitted `.imd` is a DATA disk, not a bootable RC702 diskette (ravn/z88dk #36).

**Graphics = character semigraphics** (no bitmap). gencon 2x3-sextant model:
160x75 "pixels" over 80x25 cells, 64 glyffer in the chargen (ROA327 or a
RAM font via `rc700_loadfont`), read-modify-write per pixel. rc700-specific code
is only `libsrc/target/rc700/graphics/textpixl6.asm` (glyph-code map) +
`generic_console.asm`; the rest is shared gencon (`classic/gfx/gencon/pixel6.inc`,
`grafix.inc:485` sets `_GFX_MAXX=160 _GFX_MAXY=75`). Portable `<graphics.h>`
(plot/draw/circle/clg…) sits on top.

**Examples:** `z88dk/examples/rc700/{sine,mandelbrot,ball}.c` (+ README) — pure
integer so they build under both classic and llvmz80.

Gotcha: build each program from a scratch cwd (`cd $WORK && zcc …`) — zcc writes
intermediates in the cwd. Also, unquoted `$VAR` of a flag list does NOT
word-split in zsh; pass zcc flags literally or use a bash array.

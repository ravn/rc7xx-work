---
name: reference_cpm86_docker_workflow
description: Docker workflow for CP/M-86 toolchain -- build on sonnyboy, stream to Mac.
metadata:
  type: reference
---

## Images

| Image | Purpose |
|-------|---------|
| `open-watcom-cpm86:latest` | owcc + wlink for CP/M-86 (`owcc -bcpm86`) |
| `emu2-cpm86:latest` | emu2 CP/M-86 emulator with P_LOAD relocation |

Both are linux/amd64; run via emulation on Apple Silicon Mac.

## Build on sonnyboy

```sh
# Full OW build (takes ~30-60 min):
ssh sonnyboy.local 'cd /home/ravn/z80 && sh scripts/build_open_watcom.sh > /tmp/ow-build.log 2>&1'
# Package and stream to Mac (builds clib all models, then Docker):
ssh sonnyboy.local 'cd /home/ravn/z80 && sh scripts/build_open_watcom_docker.sh'
sh scripts/load_open_watcom_image.sh sonnyboy.local open-watcom-cpm86:latest

# emu2 (fast rebuild, <1 min):
ssh sonnyboy.local 'cd /home/ravn/z80 && sh scripts/build_emu2_docker.sh'
sh scripts/load_open_watcom_image.sh sonnyboy.local emu2-cpm86:latest
```

## Use on Mac

```sh
# Compile small model:
docker run --rm --platform linux/amd64 -v "$PWD":/work open-watcom-cpm86:latest \
    owcc -bcpm86 -O2 -o prog.cmd prog.c

# Compile medium model:
docker run --rm --platform linux/amd64 -v "$PWD":/work open-watcom-cpm86:latest \
    owcc -bcpm86 -mm -O2 -o prog.cmd prog.c   # -mm now works (fixed 2026-08-27)

# Run:
docker run --rm --platform linux/amd64 -v "$PWD":/work emu2-cpm86:latest emu2 prog.cmd

# With stdout redirect (CP/M-86 stdio, not host shell):
docker run --rm --platform linux/amd64 -v "$PWD":/work emu2-cpm86:latest \
    emu2 prog.cmd ">out.txt"
```

## Key facts

- `open-watcom-v2/bld/clib/_cpm/` — CP/M-86 clib sources
- `cstartcpm.asm` — crt0: reads base page 0x80, builds argv, calls `__CommonRedirect_`
- `diskio.c` — file I/O + `__apply_redirection` (`<` `>` `>>` handled, `|` not yet)
- `lowlevel.c` — near heap: `WC_ARENA_BYTES=36352` (issue #36 to make configurable)
- wlink fix (2026-08-27): BSS/STACK excluded from CMD file → 52 KB → 14 KB for Mandelbrot

## Clib in Docker image (as of 2026-08-28)

All four memory models are now built by `build_open_watcom_docker.sh` using Linux-x64
tools from `rel/binl64/` and installed into the image:

| Model | Library | Startup | Use for |
|-------|---------|---------|---------|
| Small (s) | clibs.lib | cstartcpm.obj | near code + near data |
| Medium (m) | clibm.lib | cstartmm.obj | far code + near data (>64KB code) |
| Compact (c) | clibc.lib | cstartcm.obj | near code + far data (UnZip DEFLATE) |
| Large (l) | clibl.lib | cstartlm.obj | far code + far data (Zip) |

`owcc -bcpm86 -mm` now correctly passes `-mm` to wcc (fixed 2026-08-27, owcc.c).

## emu2-cpm86 P_LOAD (as of 2026-08-28)

The `emu2-cpm86:latest` image includes P_LOAD load-time relocation (merged from
`pr/cpm86-p-load`). Regression gate: `tests/cpm86-reloc/run.sh` → FARMULTI + FARPTR PASS.

Key lesson for freestanding DATA-fixup tests: need begdata.asm (BEGDATA+STACK segments)
linked first + `-ms -zm` compilation. See open-watcom-v2 issue #42.

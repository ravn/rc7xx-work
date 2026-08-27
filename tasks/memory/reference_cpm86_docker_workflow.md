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
| `emu2-cpm86:latest` | emu2 CP/M-86 emulator |

Both are linux/amd64; run via emulation on Apple Silicon Mac.

## Build on sonnyboy

```sh
# Full OW build (takes ~30-60 min):
ssh sonnyboy.local 'cd /home/ravn/z80 && sh scripts/build_open_watcom.sh > /tmp/ow-build.log 2>&1'
# Package and stream to Mac:
ssh sonnyboy.local 'cd /home/ravn/z80 && sh scripts/build_open_watcom_docker.sh'
sh scripts/load_open_watcom_image.sh sonnyboy.local open-watcom-cpm86:latest

# emu2 (fast rebuild, <1 min):
ssh sonnyboy.local 'cd /home/ravn/z80 && sh scripts/build_emu2_docker.sh'
sh scripts/load_open_watcom_image.sh sonnyboy.local emu2-cpm86:latest
```

## Use on Mac

```sh
# Compile:
docker run --rm --platform linux/amd64 -v "$PWD":/work open-watcom-cpm86:latest \
    owcc -bcpm86 -O2 -o prog.cmd prog.c

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

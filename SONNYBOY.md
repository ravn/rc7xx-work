# SONNYBOY.md — Linux build host workflow

`sonnyboy` is the x86-64 Linux build host that produces the CP/M-86 Docker
images.  The Mac (Apple Silicon) cannot build them natively because:

- Open Watcom requires a Linux x86-64 host to produce Linux x86-64 binaries
  (the container runs as `linux/amd64`).
- emu2-cpm86 is a C program that cross-compiles fine but the Docker image
  must contain a Linux ELF binary.

The Mac hosts Docker Desktop (via emulation for `linux/amd64`) and does the
normal development work.  Sonnyboy only runs when images need rebuilding.

---

## Images produced

| Image | Purpose |
|-------|---------|
| `open-watcom-cpm86:latest` | owcc + wlink + full CP/M-86 clib (s/m/c/l models) |
| `emu2-cpm86:latest` | CP/M-86 emulator with P_LOAD load-time relocation |

---

## One-command rebuild (from the Mac)

```sh
# Build both images on sonnyboy and stream to local Docker:
sh scripts/rebuild_cpm86_images.sh

# Only rebuild emu2 (fast, <2 min total):
sh scripts/rebuild_cpm86_images.sh sonnyboy.local --emu2-only

# Only rebuild Open Watcom (slow first time, ~30-60 min):
sh scripts/rebuild_cpm86_images.sh sonnyboy.local --ow-only

# Different build host:
sh scripts/rebuild_cpm86_images.sh mybox.local
```

The script syncs the workspace on the build host, triggers the builds,
packages Docker images, and streams them to the local Docker via
`ssh docker save | docker load` (no registry needed).

---

## What `rebuild_cpm86_images.sh` does step by step

1. **Sync workspace** — `git pull --ff-only && git submodule update --init` on the host
2. **Build Open Watcom** — `scripts/build_open_watcom.sh` (incremental, only changed files rebuild)
3. **Package Open Watcom Docker** — `scripts/build_open_watcom_docker.sh`, which:
   - Builds the CP/M-86 C library for all four memory models (s/m/c/l) using the
     just-built Linux-x64 tools (`rel/binl64/wcc` etc.)
   - Installs libs into `rel/lib286/cpm86/`
   - Runs `docker build` with `rel/` as context → `open-watcom-cpm86:latest`
4. **Stream Open Watcom image** — `scripts/load_open_watcom_image.sh`
5. **Build emu2** — `scripts/build_emu2_docker.sh` (compiles the emu2 source, packages)
6. **Stream emu2 image** — `scripts/load_open_watcom_image.sh HOST emu2-cpm86:latest`

---

## Individual scripts

### `scripts/build_open_watcom.sh`
Builds the Open Watcom V2 toolchain from source on the current host.

```sh
# On sonnyboy:
cd ~/z80
sh scripts/build_open_watcom.sh > /tmp/ow-build.log 2>&1
```

- Detects Linux (GCC) vs macOS (Clang) automatically.
- Sets `OWDOCBUILD=0` and `OWDISTRBUILD=0` to skip docs/installers.
- Takes 30-60 min on first build; incremental rebuilds are fast.
- Output: `open-watcom-v2/rel/binl64/` (Linux x64 tools).

### `scripts/build_open_watcom_docker.sh`
Builds the CP/M-86 clib for all models, then packages the Docker image.

```sh
# On sonnyboy (after build_open_watcom.sh):
cd ~/z80
sh scripts/build_open_watcom_docker.sh
```

- Requires `rel/binl64/owcc` to exist (Linux build).
- Runs `build-lib.sh` for models s/m/c/l using `rel/binl64/wcc` etc.
- Installs to `rel/lib286/cpm86/`: `clibs.lib clibm.lib clibc.lib clibl.lib`
  + matching `cstart*.obj` + `libm*.lib`.
- Packages `rel/` as Docker context → `open-watcom-cpm86:latest`.

### `scripts/build_emu2_docker.sh`
Builds emu2-cpm86 and packages it as a Docker image.

```sh
# On sonnyboy:
cd ~/z80
sh scripts/build_emu2_docker.sh
```

- Runs `make` in `emu2-cpm86/` (the current branch = `pr/cpm86-memory`,
  which includes P_LOAD relocation).
- Packages the resulting binary → `emu2-cpm86:latest`.
- Fast: < 1 minute including Docker build.

### `scripts/load_open_watcom_image.sh`
Streams a Docker image from the build host to the local Docker.

```sh
# On the Mac, after the image is built on sonnyboy:
sh scripts/load_open_watcom_image.sh                              # open-watcom-cpm86:latest from sonnyboy.local
sh scripts/load_open_watcom_image.sh sonnyboy.local emu2-cpm86:latest
sh scripts/load_open_watcom_image.sh mybox.local open-watcom-cpm86:v2
```

Uses `ssh HOST docker save IMAGE | docker load` — no registry, no
intermediate file, works over any SSH connection.

### `scripts/setup-ubuntu.sh`
One-shot setup script for a fresh Ubuntu 24.04/26.04 host.

```sh
# On a fresh Ubuntu box:
bash scripts/setup-ubuntu.sh           # installs everything
bash scripts/setup-ubuntu.sh --no-mame   # skip MAME (~600 MB lighter)
```

Installs: build-essential, cmake, ninja, clang, lld, SDL2, Docker,
rustup, Node.js + Claude CLI, gh CLI. Re-runnable.

---

## When to rebuild

| Trigger | What to rebuild |
|---------|----------------|
| `open-watcom-v2` submodule bumped | `--ow-only` (compiler + clib) |
| `emu2-cpm86` branch updated | `--emu2-only` |
| Both submodules changed | Full `rebuild_cpm86_images.sh` |
| Clib sources changed (`port/*.c`, `port/*.asm`) | `--ow-only` |
| First time after cloning | Full rebuild |

---

## Initial setup on a new sonnyboy

```sh
# 1. Clone the workspace
git clone --recurse-submodules git@github.com:ravn/rc7xx-work.git ~/z80
cd ~/z80

# 2. Install all build dependencies
bash scripts/setup-ubuntu.sh

# 3. Open a new shell (group membership changes take effect)
# 4. Build everything (first time takes 30-60 min for Open Watcom)
sh scripts/build_open_watcom.sh
sh scripts/build_open_watcom_docker.sh
sh scripts/build_emu2_docker.sh

# Then stream to Mac from the Mac:
sh scripts/rebuild_cpm86_images.sh sonnyboy.local --ow-only   # already built; just stream
```

---

## Troubleshooting

**Build fails with "undefined reference"** — check `/tmp/ow-build.log` on
sonnyboy.  Common cause: missing apt package.  Re-run `setup-ubuntu.sh`.

**`docker save` fails** — the image might not exist on the host yet.  Run
`build_open_watcom_docker.sh` on the host first.

**`owcc` in the image reports wrong version** — the image was built before the
latest OW commit.  Run `rebuild_cpm86_images.sh --ow-only`.

**emu2 outputs wrong results** — the image may use an older branch.  Check
`git -C emu2-cpm86 log --oneline -3` on sonnyboy and compare with the Mac.
Re-run `rebuild_cpm86_images.sh --emu2-only`.

**Docker Desktop not running** — `scripts/load_open_watcom_image.sh` and
`rebuild_cpm86_images.sh` check for the local daemon and exit early with a
clear error.

---

## Booting MAME with custom disk images

Two consolidated scripts replace all the ad-hoc `rc759_make_*.sh` / `rc702_boot_cpm.sh`
recipes.  Both share the same interface and do a make-style freshness check on the
output MFI — files are only copied when the disk is older than its inputs.

### `scripts/rc759_run.sh` — RC759 Piccoline (CP/M-86, 8086)

```sh
# Boot with default B: (existing or blank):
sh scripts/rc759_run.sh

# Build a B: with UnZip + a zip archive, then boot:
sh scripts/rc759_run.sh infozip-cpm86-builds/out-cpm86/UNZIP.CMD test.zip:TEST.ZIP

# Rename on the way in (HOST_PATH:CPM_NAME):
sh scripts/rc759_run.sh build/myprog.cmd:MYPROG.CMD

# Force rebuild even if disk is fresh:
sh scripts/rc759_run.sh --force UNZIP.CMD

# Build disk but do not boot:
sh scripts/rc759_run.sh --no-boot --out /tmp/myb.mfi PROG.CMD data.zip:DATA.ZIP

# Use a pre-built MFI (skip the build step):
sh scripts/rc759_run.sh --disk mame/rc759_sw/B_mandel.mfi

# Headless CI run (60 s wall clock, no sound, throttled):
sh scripts/rc759_run.sh --seconds 60 --sound none PROG.CMD

# Override A: boot disk:
sh scripts/rc759_run.sh --a-disk /tmp/other-system.img PROG.CMD
```

### `scripts/rc702_run.sh` — RC702 (CP/M 2.2, Z80)

Same interface.  Defaults to `-nothrottle` (rc702 is fast enough).  The A: disk
(SW1711-I8.imd) is auto-fetched from rc700-gensmedet on first use.

```sh
sh scripts/rc702_run.sh                         # boot with default B:
sh scripts/rc702_run.sh BIOS.COM TEST.COM        # build disk + boot
sh scripts/rc702_run.sh --disk mame/rc702_sw/B_my.mfi   # use existing MFI
sh scripts/rc702_run.sh --throttle BIOS.COM      # throttled (interactive)
```

**Disk geometry reference:**

| Machine | Format | Geometry | cpmtools diskdef | MAME fmt |
|---------|--------|----------|-----------------|---------|
| rc759 | 5.25" DS-HD | 77cyl × 2h × 8s × 1024B = 1,261,568 B | `rc759-drc` | `rc759` |
| rc702 | 8" DS-DD | 77cyl × 2h × 15s × 512B = 1,184,640 B | `rc702-8dd` | `u8dsdd` |

---

## Quick-use examples (on the Mac after images are loaded)

```sh
# Compile a small-model CP/M-86 program:
docker run --rm --platform linux/amd64 -v "$PWD":/work open-watcom-cpm86:latest \
    owcc -bcpm86 -O2 -o prog.cmd prog.c

# Compile medium model (>64 KB code):
docker run --rm --platform linux/amd64 -v "$PWD":/work open-watcom-cpm86:latest \
    owcc -bcpm86 -mm -O2 -o prog.cmd prog.c

# Compile compact model (far data / UnZip DEFLATE):
docker run --rm --platform linux/amd64 -v "$PWD":/work open-watcom-cpm86:latest \
    owcc -bcpm86 -mc -O2 -o prog.cmd prog.c

# Run under emu2:
docker run --rm --platform linux/amd64 -v "$PWD":/work emu2-cpm86:latest \
    emu2 prog.cmd

# Run with I/O redirect (CP/M-86 shell syntax, not host shell):
docker run --rm --platform linux/amd64 -v "$PWD":/work emu2-cpm86:latest \
    emu2 prog.cmd ">out.txt" "<in.txt"
```

---
name: simavr-master-required
description: simavr distro packages (Ubuntu 24.04/25.04/26.04/rolling, Debian trixie/testing — all 1.6+dfsg-3) PREDATE the .mmcu console hook; must build master from source for the AVR cross-target oracle
type: reference
---
Survey 2026-06-07 (`docker run X apt-cache show simavr`):

- ubuntu:24.04 → 1.6+dfsg-3build2
- ubuntu:25.04 → 1.6+dfsg-3build2
- ubuntu:26.04 → 1.6+dfsg-3build2
- ubuntu:rolling → 1.6+dfsg-3build2
- debian:trixie → 1.6+dfsg-3+b3

All the same release.  Upstream simavr (github.com/buserror/simavr) has NOT tagged a release since 2017; the binaries in master have many features and bugfixes since then but aren't tagged, so Debian/Ubuntu can't repackage.  `apt install simavr` is therefore a DEAD END for the AVR cross-target oracle infrastructure — that path needs the `AVR_MCU_SIMAVR_CONSOLE` macro + `AVR_MMCU_TAG_SIMAVR_CONSOLE` parsing in `sim_elf.c`, both of which only exist on master.

**How to build master in Docker** (see `rc700-gensmedet/tasks/aes256-corpus/avr-oracle/Dockerfile.avr-tools` for the working file):
- ubuntu:24.04 base, `apt install git build-essential libelf-dev pkg-config`.
- `git clone --depth=1 https://github.com/buserror/simavr.git && make -C simavr/simavr RELEASE=1`.
- Don't use `make install DESTDIR=...` — the install target's layout is fragile.  Copy `run_avr` → `/usr/bin/simavr` and `obj-*-linux-*/libsimavr.so*` → `/usr/lib/` directly.
- Final stage: `apt install binutils-avr avr-libc gcc-avr libelf1` + copy artifacts + `ldconfig`.

**Native macbook simavr** (`/Users/ravn/z80/simavr/simavr/run_avr`): builds without libelf because macOS has no libelf.  Loads .hex only, no ELF.  Use the Docker simavr for ELF + console hookup.

Cross-link [[feedback_docker_shim_batch]] — the `simavr` shim in `~/.local/bin/` is fine for one-offs; build Makefiles should batch.

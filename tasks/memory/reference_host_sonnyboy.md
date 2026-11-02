---
name: reference_host_sonnyboy
description: Host facts for sonnyboy (second working host besides the macbook) — Ubuntu 26.04 x86_64, workspace /home/ravn/z80, headless, Claude Code installed locally, SSH key on GitHub since 2026-06-06.
metadata:
  type: reference
---

**sonnyboy** — direct working host since 2026-06-06 (previously only
reached remotely from the macbook).

* OS: Ubuntu 26.04 LTS, x86_64.
* Workspace root: `/home/ravn/z80` (NOT the macbook's `/Users/ravn/z80`
  — see the per-host table in [[feedback_no_home_search]]).
* **Headless** — no graphics for MAME windows; see
  [[feedback_host_no_graphics]] (SDL offscreen/dummy, snapshots OK).
* **CLion via JetBrains Remote Development** (2026-06-06): sonnyboy runs
  the headless CLion backend (`~/.cache/JetBrains/RemoteDev/dist/...`),
  user views from the macbook via Gateway.  `clion` CLI launcher is at
  `/snap/bin/clion`.  The Claude Code IDE plugin is installed in that
  backend (`/ide` connects).  So: full IDE available, but still NO
  display for MAME windows — the two facts coexist.
* Workspace top-level `CMakeLists.txt` is CLion-index-only (real builds
  are Makefiles/ninja) — keep its source lists current when subprojects
  move (cpnos-rom reference went stale 2026-05-17 -> fixed 2026-06-06).
* Claude Code: `~/.local/bin/claude` on system Node v22 (the
  "Option A" install path from the 2026-06-06 handoff).
* Upstream LLVM clone (user-handed path): `~/llvm-upstream/llvm-project/`
  — for reproducing generic-LLVM bugs on upstream HEAD.
* `z88dk-ticks`: built at `/home/ravn/z80/z88dk/src/ticks/z88dk-ticks`,
  symlinked into `~/.local/bin/` (2026-06-07) so the test-runner finds it
  on PATH without overrides.  Rebuild: `make -C z88dk/src/ticks`.
* GitHub: this machine's SSH public key added to the user's GitHub
  account 2026-06-06 — pushes work from here.  Global git rewrite
  `url.git@github.com:ravn/.insteadOf https://github.com/ravn/` makes
  all ravn/* remotes use SSH (a pre-existing opposite ssh->https
  rewrite was removed the same day).  `gh` CLI logged in as ravn
  (PAT, git protocol ssh) since 2026-06-06.
* **All Python packages must be installed in a venv** — the system Python
  is externally-managed (PEP 668); a bare `pip install` fails/refuses.
  Always `python3 -m venv <dir>` (or reuse an existing project venv) before
  installing anything, e.g. for `contrib/ravn/cpm86run_unicorn.py`'s
  `unicorn` dependency.
* macOS-only memory entries don't apply here (e.g.
  [[reference_macos_timeout]] — GNU timeout exists on sonnyboy;
  CLion-bundle tool paths in [[reference_build_binaries]] are
  macbook-specific).

Related: [[feedback_cross_machine_workflow]].

## Fresh-checkout native build recipe (2026-11-01, user-requested; CLAUDE.md otherwise prefers Docker for SDCC)

* apt deps: `bash scripts/setup-ubuntu.sh --no-docker` (now includes `PKGS_Z88DK`: re2c ragel dos2unix texinfo libxml2-dev libgmp-dev zlib1g-dev libboost-all-dev).
* `git pull` of the workspace is slow (mame submodule fetch); use `--no-recurse-submodules`, then `git submodule update --checkout -- <path>` per populated submodule. `ccache`, `dcc`, `z88dk-wiki` are intentionally empty here.
* z88dk needs its OWN nested submodules first: `git -C z88dk submodule update --init -- ext/UNIXem ext/Unity ext/optparse ext/regex ext/uthash` (else `uthash.h` not found). Then `make -j6` in `z88dk/`. zsdcc is separate: `PATH=$PWD/../scratch/bin:$PATH make BUILD_SDCC=1 BUILD_SDCC_HTTP=1 OCC=gcc CC=gcc CXX=g++ bin/z88dk-zsdcc` (downloads the source tarball over http from nightly.z88dk.org). `scratch/bin/{gcc,cc,g++,c++}` are symlinks to `/usr/bin/ccache`; `OCC="ccache gcc"` breaks SDCC configure (word-splitting) and a ccache wrapper script double-prefixes.
* LLVM: `make toolchain` (top-level Makefile now always passes the ccache launcher). Lit needs extra tools: `ninja count not split-file llvm-mc llvm-as llvm-dis llvm-config llvm-readobj llvm-readelf llvm-ar llvm-ranlib llvm-strip llvm-size`.
* Runtime tests: `cd z80-utils && BUILD_DIR=<abs build-linux> PATH=<z88dk>/bin:$PATH cargo run --release -- clang` (rustup stable pinned by `rust-toolchain.toml`).
* `gh` needs `gh auth login` once; git identity is global (`Thorbjørn Ravn Andersen <tra@ravnand.dk>`).

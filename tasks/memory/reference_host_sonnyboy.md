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

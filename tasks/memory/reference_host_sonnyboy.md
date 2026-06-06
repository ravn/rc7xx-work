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
* Claude Code: `~/.local/bin/claude` on system Node v22 (the
  "Option A" install path from the 2026-06-06 handoff).
* Upstream LLVM clone (user-handed path): `~/llvm-upstream/llvm-project/`
  — for reproducing generic-LLVM bugs on upstream HEAD.
* GitHub: this machine's SSH public key added to the user's GitHub
  account 2026-06-06 — pushes work from here.  Global git rewrite
  `url.git@github.com:ravn/.insteadOf https://github.com/ravn/` makes
  all ravn/* remotes use SSH (a pre-existing opposite ssh->https
  rewrite was removed the same day).  `gh` CLI NOT logged in — git
  operations work, but `gh issue`/`gh run` need `gh auth login` first.
* macOS-only memory entries don't apply here (e.g.
  [[reference_macos_timeout]] — GNU timeout exists on sonnyboy;
  CLion-bundle tool paths in [[reference_build_binaries]] are
  macbook-specific).

Related: [[feedback_cross_machine_workflow]].

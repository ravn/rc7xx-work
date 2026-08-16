---
name: cpm86-crossdev submodule = ravn's fork of tsupplis/cpm86-crossdev (not ravn's own)
description: The cpm86-crossdev submodule is a fork of the upstream tsupplis/cpm86-crossdev CP/M-86 cross-dev environment; records that it exists, its provenance, and what it provides.
metadata:
  type: reference
---

The **`cpm86-crossdev/`** submodule (path in rc7xx-work; url `git@github.com:ravn/cpm86-crossdev.git`,
branch `main`) is **`ravn/cpm86-crossdev`, a FORK of `tsupplis/cpm86-crossdev`**
(verified 2026-08-16 via `gh repo view --json parent`). It is an **upstream
project, NOT ravn's own** — so its contents came with the fork, not from ravn's
own work. Don't present anything inside it as ravn-authored.

What it provides (a CP/M-86 cross-development environment):
- `bin/` runner wrappers: `cpm86` (runs the DRI `cpm86.exe` under emu2), `emu2`,
  plus Aztec C (`aztec34_*`, `aztec42_*`) and DRI (`drc*`, `pcdev_*`) tool wrappers.
- `docs/manuals/` — incl. `DRI_C_Programming_86.{pdf,txt}` (the DR C 1.11 guide)
  and `DRI_C_86_SUMMARY.md` (see `[[reference_dri_cpm86_manuals_location]]`).
- diskdefs / images for cpmtools.

There is ALSO a second copy at `scratch/cpm86-tools/cpm86-crossdev/` (used by some
scratch build scripts, e.g. the pure-DR-C path); it is the same upstream tree.

ravn's OWN CP/M-86 material lives elsewhere — the Watcom cpm86 port + ravn-cached
manuals are under `open-watcom-v2/contrib/ravn/` (in `ravn/open-watcom-v2-ccpm86`,
also a fork, but `contrib/ravn/` is ravn's added namespace). Keep the provenance
line straight: cpm86-crossdev = tsupplis upstream; contrib/ravn = ravn's own.

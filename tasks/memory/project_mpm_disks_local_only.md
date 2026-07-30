---
name: project-mpm-disks-local-only
description: MP/M tailored disks are built into disks/local/ via `make mpm-disks`; disks/library/ is the frozen base and is never written
metadata:
  type: project
---

The RC702 slave scenario's MP/M disks are built as a reproducible delta on
top of a **frozen** committed base:

- **`cd cpnos-in-c && make mpm-disks`** regenerates ALL tailored disks into
  `z80pack/cpmsim/disks/local/` (gitignored): (1) `rebuild-mpm-sys.sh --install`
  -> `local/mpm-net2-1.dsk` (GENSYS MPM.SYS + patched SERVER.RSP), (2)
  `cpnos-disk-install` -> adds `RC700.NOS` (the CP/NOS slave netboot image =
  384 B locale prefix + stamped cpnos.sys; renamed from `CPNOS.IMG` 2026-07-27,
  FCB in `cpnos-in-c/src/init.c`), (3) `stage-drivei-tools` ->
  `local/mpm-net2-drivei.dsk` (PPAS/COMAL80/L80/M80/TODGET + PRIMES.PAS).
- **`disks/library/` is FROZEN** — the pristine MP/M II + CP/NET base, tracked
  in the z80pack submodule. No build/test step writes to it. The `mpm-net2`
  launcher prefers `disks/local/` over `disks/library/` for BOTH the boot disk
  and the drive I:/J: hard disks (falls back to library, then blank).

**Why:** two Makefile steps used to write straight into the git-tracked library
base (`cpnos-disk-install` staged the slave image; `stage-drivei-tools` pointed
`DRIVEI_DSK` at library), so ordinary test runs churned the committed disks and
served stale images to the slave. Closed 2026-07-28 (Phase 2 of the
first-class-disk-build task). `cpnos.img` was also stripped from the committed
library boot disk (base is now pure MP/M+CP/NET).

**How to apply:** never `cpmcp`/`cpmrm`/copy INTO `disks/library/*.dsk`; write
tailored disks to `disks/local/` only. To refresh disks, run `make mpm-disks`
(or the individual sub-targets). If a boot disk is missing, `cpnos-disk-install`
auto-runs `rebuild-mpm-sys.sh --install` rather than copying from library.
`cpnos-disk-install-with-locale` is the lone remaining library writer and is
PARKED (two-PROM slave only). Full flow doc:
`cpnet/REBUILDING_MPM_SYS.md`.

Related: [[feedback-cpnos-pio-netboot-no-autoboot]] (never restore local boot
disk from library — stale SERVER.RSP -> gettod ff), [[reference-mpm-sys-baked-via-gensys]]
(RSP edits inert until GENSYS regens MPM.SYS), [[project-cpnos-address-coupling-brittle]].

---
name: reference-mpm-sys-baked-via-gensys
description: MP/M II bakes every RSP/SPR (incl. SERVER.RSP, NETWRKIF.RSP) into MPM.SYS at GENSYS time; edits to .RSP files on disk are inert until MPM.SYS is regenerated and reinstalled on drive A:.
metadata:
  type: reference
---

MP/M II's `MPM.SYS` is a single ~42 KB file containing the relocated
load image of MPMLDR + LDRBIOS + BNKBDOS.SPR + BNKXDOS.SPR +
BNKXIOS.SPR + every RSP (ABORT, SCHED, SPOOL, MPMSTAT, SERVR0PR a.k.a.
SERVER.RSP, NtwrkIP0 a.k.a. NETWRKIF.RSP). GENSYS reads each module at
build time, relocates it to a chosen load address, and writes the
concatenated image to `MPM.SYS`. **Nothing at runtime ever reopens the
individual `.RSP`/`.SPR` files.** Once `MPM.SYS` exists, the per-module
files on disk are inert leftovers.

Practical consequence: in the rc700-gensmedet project's `mpm-net2`
launcher (`z80pack/cpmsim/mpm-net2`), the master boots from drive A:
(`mpm-net2-1.dsk`), which contains `MPM.SYS`. Drive D:
(`mpm-net2-2.dsk`) contains `gensys.com` plus current `.RSP`/`.SPR`
sources. Replacing `server.rsp` on drive D: alone has zero effect —
GENSYS must be re-run to bake the new copy into `MPM.SYS`, and the new
`MPM.SYS` then copied back onto drive A:.

Full procedure + diagnosis history + the GENSYS dialog skeleton lives
in `rc700-gensmedet/cpnet/REBUILDING_MPM_SYS.md`.

Related: [[feedback_fingerprint_build_after_two_no_change_edits]] —
this trap is the specific reason that rule exists.

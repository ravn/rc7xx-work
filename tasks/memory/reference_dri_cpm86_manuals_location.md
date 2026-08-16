---
name: DRI C Language Programmer's Guide for CP/M-86 (2nd ed. 1983)
description: Index of all cached CP/M-86-family manuals on disk (search here first, do NOT re-download). Includes the DR C 1.11 guide + Concurrent CP/M / CP/M-86 guides; notes provenance (ravn's contrib/ravn vs the tsupplis cpm86-crossdev fork).
type: reference
metadata:
  node_type: memory
  type: reference
---
The authoritative **Digital Research C Language Programmer's Guide for the
CP/M-86 Family**, Second Edition (October 1983), 189 pages, is already in the
workspace:

- **`cpm86-crossdev/docs/manuals/DRI_C_Programming_86.pdf`** (25 MB, PDF v1.5)
- **`cpm86-crossdev/docs/manuals/DRI_C_Programming_86.txt`** (extracted text)

md5 `41db570971cfc709cbc2c5f3a25fe0df`. Added 2026-08-12; lives in the
`cpm86-crossdev` submodule (so a workspace-root `git ls-files` won't show it as
tracked here — but the files are on disk). **Do NOT re-download it.**

Origin: Tim Olmstead Memorial CP/M Library, `cpm.z80.de/drilib.html` →
`manuals/DRI_C_Programming_86.pdf` (a cleaned OCR scan). This is the full guide
that the shorter release-notes we also have amend:
`scratch/rc759-cmd-toolchain/drc-oracle/read.me` (DR READ.ME File Notes, May
1984) and `.../drc86111/DRC.DOC` (Ken Mauro's CP/M-86 header-port notes).

Key facts from the guide/notes for the RC759 DR C 1.11 toolchain: only **small
and large** memory models are supported (`-c`/`-m` compact/medium removed);
**DR C defaults to large model** and calls externals FAR (hand-written asm
helpers such as putchar must be assembled `-ml` with `retf`, arg at `[bp+6]`);
with `-f`, float-returning functions must be declared `double`.

---

## Cached CP/M-86-family manuals — SEARCH HERE FIRST before re-downloading

All on-disk, verified 2026-08-16. AGENTS.md rule: search the whole workspace
before fetching any external asset. **Do NOT re-download any of these.** Each PDF
has a `.txt` extraction alongside (same basename).

**ravn's OWN cached manuals** live in `open-watcom-v2/contrib/ravn/` (inside
`ravn/open-watcom-v2-ccpm86`, ravn's fork — the `contrib/ravn/` namespace is
ravn's added material):

- **Concurrent CP/M Programmer's Reference Guide (DRI, Jan 1984, doc 1034-2023, 357p)**
  — DRI original; BDOS/XIOS/.CMD reference for the native Watcom cpm86 work.
  `open-watcom-v2/contrib/ravn/Concurrent_CPM_Programmers_Reference_Guide_Jan84.{pdf,txt}`.
  See `[[reference_concurrent_cpm_prog_ref_guide]]`. NOT the Siemens reprint.
- **Siemens Concurrent CP/M-86 Programmer's Reference Guide** (reprint of the above):
  `open-watcom-v2/contrib/ravn/Siemens_Concurrent_CPM-86_Programmers_Reference_Guide.{pdf,txt}`.
- **CP/M-86 Programmer's Guide (Jan 1983)**:
  `open-watcom-v2/contrib/ravn/CPM-86_Programmers_Guide_Jan83.{pdf,txt}`.
- **CP/M-86 System Guide (Jun 1983)** — BIOS/XIOS + IVT setup (see
  `[[reference_cpm86_interrupt_vector_install]]`):
  `open-watcom-v2/contrib/ravn/CPM-86_System_Guide_Jun83.{pdf,txt}`.

**In a NOT-ravn submodule** — the `cpm86-crossdev` submodule is `ravn/cpm86-crossdev`,
a **fork of `tsupplis/cpm86-crossdev`** (an upstream project, not ravn's own).
The DR C manual there came with that tree, so it is not part of ravn's own
contrib/ravn manual set:

- **DRI C Language Programmer's Guide (2nd ed, Oct 1983, 189p)** — the DR C 1.11
  language/library reference (details above):
  `cpm86-crossdev/docs/manuals/DRI_C_Programming_86.{pdf,txt}` +
  `DRI_C_86_SUMMARY.md` (ABI summary). It's on disk; do NOT re-download. If a
  ravn-owned copy is ever wanted, it would go in `open-watcom-v2/contrib/ravn/`.

(COMAL80 language manual is indexed separately: `[[reference_comal80_manual]]`.)

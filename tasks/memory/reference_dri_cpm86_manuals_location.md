---
name: DRI C Language Programmer's Guide for CP/M-86 (2nd ed. 1983)
description: The DR C 1.11 language/library reference PDF lives at cpm86-crossdev/docs/manuals/DRI_C_Programming_86.pdf
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

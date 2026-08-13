---
name: feedback_search_workspace_before_fetching
description: "HARD — before downloading/fetching any asset from the internet, search the WHOLE workspace by filename first"
metadata:
  node_type: memory
  type: feedback
---

HARD: Before fetching, downloading, or re-creating any external asset (manual,
PDF, dataset, tarball, reference file), FIRST search the **entire workspace
root** for it by filename — not just the subdirectory you happen to be working
in. Only go to the internet once a whole-workspace search comes up empty.

**Why:** 2026-08-13 — asked "do you have the DR C documentation?", I searched
only `scratch/rc759-cmd-toolchain/docs/` (where two *other* manuals lived),
concluded the DR C Programmer's Guide was missing, traced it online
(cpm.z80.de), and re-downloaded 25 MB. The identical file (md5 41db5709…) was
already in the repo at `cpm86-crossdev/docs/manuals/DRI_C_Programming_86.pdf`,
added the day before. The user caught it twice ("det så da ud som om den
allerede lå i projektet??", "vi fandt den i går!!"). A duplicate commit +
revert was pure waste.

**How to apply:** The moment a task is "find/fetch resource X," step 1 is a
workspace-wide filename search from the repo root, e.g.
`find /Users/ravn/z80 -iname '*DRI_C_Programming*'` or the glob/grep tools with
**no path restriction** (still inside the workspace — never widen outside it,
per the top-priority no-home-search rule). Search by distinctive filename
fragments AND, if that misses, by content. Assets often live in sibling
submodules (`cpm86-crossdev/`, `llvm-z80/`, `rc700-gensmedet/`), so a search
scoped to the current subtree will miss them. Only after that empty result do
you fetch from the network. Canonical home for CP/M-86 / DRI reference manuals:
`cpm86-crossdev/docs/manuals/` (see [[reference_dri_cpm86_manuals_location]]).

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

**Trigger also fires on AUTHORING, not just downloading.** 2026-08-14 — asked to
add an integer-Mandelbrot milestone test, I started *writing a new* `mandel.c`
(and had already re-fetched `az8634b.zip`) instead of searching first. The
project already had the canonical fixed-point 8.8 Mandelbrot in several forms:
`scratch/rc759-cmd-toolchain/mame-tests/mandel-mame.c` (+ `MANDEL-MAME.CMD` and
the reference screenshot `MANDEL_mame_rc759.png`), `scratch/.../mandel_cpm86.c`
(emu2 path), and the DR C oracle `open-watcom-v2/contrib/ravn/owc-drc/mandel-ow.c`.
The user caught it ("vi har allerede mandelbrot heltal i projektet",
"hvorfor kiggede du ikke selv først"). Root cause: I skipped the task-start
MEMORY.md scan (see [[feedback_check_memory_before_coding]]), so this rule never
loaded. **Before creating ANY new program, test, example, asset, or reference
file, first search the whole workspace for an existing one** — reuse/adapt it
rather than re-authoring. Existing test harnesses + their oracle screenshots are
especially costly to duplicate.

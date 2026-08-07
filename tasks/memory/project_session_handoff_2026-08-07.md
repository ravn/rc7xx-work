---
name: project_session_handoff_2026-08-07
description: Handoff after the 2026-08-07 mame-reconciliation + cpnos-qsort + bdos-fix session — what was done and the UNPUSHED commits across 4 repos to push next
metadata:
  type: project
---

Session 2026-08-07 (before a /clear). Everything below is COMMITTED locally;
**nothing pushed yet** — the user had not given a push go-ahead. Push order and
exact commits:

### Unpushed commits to push (4 repos)
- **mame** (`/Users/ravn/z80/mame`, branch `master`): 6 commits ahead of
  `origin/master` = the reconciliation ([[project_rc702_mame_fork_reconciled_2026-08-07]]).
  Top new one this session: `e9301672d7d` (RS232 38400 8N1 default). Also the
  backup branch `master-predev-2026-08-07` is already pushed. Push = **plain
  fast-forward** now (the earlier force-push already happened).
- **z88dk fork** (`/Users/ravn/z80/z88dk`, branch `fix/llvmz80-graphics-hl-return`):
  `b9e7e72b98` — cpm.h bdos() pointer-arg fix + `test/clang/issue52_bdos_ptr_abi.*`
  ([[reference_llvmz80_bdos_pointer_arg_scramble]], ravn/z88dk#52). Branch may
  have other pre-session unpushed work; check before pushing.
- **rc700-gensmedet**: my commits `636427f` (cpnos-qsort-test), `8e5b674`
  (147-swap seed + clang build target), `8195f62` (qsort live progress),
  `b703a1c` (polypascal lua S03 name). Plus ~9 OLDER unpushed commits from prior
  work sit underneath — a push takes them all. Uncommitted in the tree:
  harness-rebuilt BUILD ARTIFACTS (prom1-lineprog.bin/elf, init.*, *.lis, *.zx0)
  — churn, do NOT commit; and `docs/MAME_RC702.md` (NOT mine — copilot graphics
  work, leave it).
- **workspace** (`/Users/ravn/z80`): 4 memory commits (`74de4dd` `f629182`
  `afbc660` `560d1d5`) + this handoff. Submodule pointers (mame, z88dk,
  rc700-gensmedet) are dirty because of the subrepo commits above; commit the
  pointers only AFTER the subrepos are pushed (else the superrepo references
  commits not on any remote).

### What was accomplished
1. **mame fork reconciled** to post-#15805 upstream (PR merged) as 6 targeted
   commits; cpnos-polypascal-test PASSES; build needs `OSD=sdl` (SDL2) +
   `SOURCES=` must list pio_port files. See [[project_rc702_mame_fork_reconciled_2026-08-07]].
2. **New `cpnos-qsort-test`**: random-access disk quicksort (32x128B, in-place,
   F_READRAND/F_WRITERAND over CP/NET), worst-case 147-swap seed, live dot
   progress. PASSES under cpnos with BOTH toolchains (classic + clang/llvmz80).
3. **bdos() pointer-arg bug FIXED** (ravn/z88dk#52): #279 (__smallc→z80_smallc)
   broke cpm.h's reversed-param workaround; dropped the special-case. Guard added.
4. z88dk **wiki mirrored** to `/Users/ravn/z80/z88dk-wiki` (325 pages, shallow).

### Open items / filed issues
- **ravn/z88dk#52** bdos pointer-arg — FIXED (commit local, unpushed), commented.
- **ravn/z88dk#53** classic stdio `fopen("rb+")` mis-parsed read-only (`+` after
  `b` ignored in `_freopen1.c`); only `"r+b"` works. Also: `"r+b"` random
  write-back doesn't land (fflush is a stub) — CP/M reliable path is direct BDOS.
  NOT yet fixed — candidate next task.
- ntvcm was built at `/Users/ravn/z80/ntvcm/ntvcm` (clang++, no -static) for
  local CP/M verification; it is gitignored/untracked there.

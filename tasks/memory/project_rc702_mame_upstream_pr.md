---
name: project_rc702_mame_upstream_pr
description: RC702 driver upstream PR mamedev/mame#15805 — status and layout
metadata:
  type: project
---

**mamedev/mame PR #15805** — RC702/RC703 working driver with CP/M boot.
Status **MERGED** (confirmed 2026-08-07, "Systems promoted to working").
Upstream now carries rc702/rc702mini/rc702sem702/rc703, the driver-local
`src/mame/regnecentralen/pio_port/` slot (keyboard card), 560-col fix,
jbox palette, 2716/2732 jumper + prom1, sem702 RAM-chargen, 8275 PLL dot clock.

**Fork reconciled to post-merge upstream 2026-08-07** (see
[[project_rc702_mame_fork_reconciled_2026-08-07]]): `master` reset to
`upstream/master` + 5 targeted commits; old dev master preserved as branch
`master-predev-2026-08-07` (local + origin). Plan
`tasks/mame-post-pr-merge-plan-2026-08-06.md` was partly stale (its "fork-only
follow-ups" sem702/jumper were actually in the PR; ROM-hash/warning was already
reverted in the fork — both moot).

Status as of 2026-07-31 (pre-merge): OPEN, awaiting review (pmackinlay round 1).

- Branch: `upstream-rc702-clean` on `origin` (git@github.com:ravn/mame-rc702-rc759-rc750.git),
  built on mamedev base `8f21e978`. Local mame repo is on this branch.
- **Three commits** (each round kept separate — see [[feedback_preserve_reviewed_commit]]):
  1. `0a453825` — original reviewed commit (do NOT alter; reviewer comments anchor to it).
  2. `11947901` — round-1 follow-up: finders throughout, pio_port moved into the
     driver folder (`src/mame/regnecentralen/pio_port/`), SEM702-only handler install,
     sorted mame.lst, consolidated clock tree, comment reformatting.
  3. `89d9de1d` — round-2 fix: 8275 dot clock is a PLL output, not a crystal — so it
     is a plain derived frequency in the driver and was removed from the known-XTAL
     list; `src/emu/xtal.cpp` is now back to mamedev-original (net diff = 7 files, no
     core-file change).
  (Remote head at wrap-up: `89d9de1d`.)
- Four machines: rc702 (8" maxi), rc702mini (5.25"), rc703 (5.25" QD, own rob357),
  rc702sem702 (RAM chargen). Build clean, -validate passes on all four, rc702 boots to A>.
- Clock tree (documented in the driver header): 8 MHz `MAIN_XTAL` (CPU + CTC/SIO/PIO/DMA
  at /2, FDC 8/4 MHz); 19.6608 MHz `MEM_CLOCK` (baud = /32 = 0.6144 MHz, both real
  crystals); `DOT_CLOCK` = 11'640'000 (8275, /7) — a **plain int**, not an XTAL, because
  it is a PLL output locked to the 50 Hz field rate (reviewer flagged the XTAL form).
- **NOT in the PR** (local scratch, untracked in mame): `PR_rc702_DRAFT.md`,
  `src/mame/regnecentralen/rc702_boot_cpm.sh` (ROM-download helper — MAME upstream
  would not accept it). CP/NET / CP/NOS PIO (z80pio) work is deliberately deferred
  from upstream until physical-hardware verification.
- Next: wait for review; writing review-thread replies (with AI disclosure) is the
  user's task. To push updates, follow [[feedback_preserve_reviewed_commit]].

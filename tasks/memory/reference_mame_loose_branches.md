---
name: MAME submodule loose-branch inventory (2026-09-03)
description: Which local branches in the mame submodule hold real unmerged work vs stale/merged pointers. rc759+rc750 all merged to origin/master; the only genuinely loose work is the RC702 upstreaming line.
metadata:
  type: reference
---

Snapshot 2026-09-03 of `mame/` local branches vs `origin/master`
(`f6daedd6db8`, which now carries all rc759 graphics/screensaver + rc750
Partner selftest + 82730 mailbox-handshake work). Survey command:
`for b in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
git rev-list --left-right --count origin/master...$b; done`.

## Fully merged → stale pointers (ahead:0, cleanup candidates)
`rc759-82730-graphics`, `rc759-complete`, `rc759-fdc-dma-fix`,
`rc759-i82730-cursor`, `for-upstream-rc759-single`, `for-upstream-rc759-v2`,
`upstream-rc759-full`, `upstream-rc759-graphics`. All content is in
origin/master. Safe to delete once confirmed not needed for provenance.

## Genuinely unmerged work — RC702 upstreaming line (the real "loose" pool)
Prepared for an upstream PR to **mamedev/mame** (NOT our master):
- `upstream-rc702-v1` (+83): full RC702/RC703 driver + extensive docs/refinement.
- `upstream-rc702-clean` (+3): RC702 driver + clock consolidation (8275 dot clock = PLL output).
- `wip-rc702-review` (+2): RC702/RC703 CP/M-boot driver + pmackinlay review feedback.
These are the next real chunk to land if RC702 upstreaming is resumed.

## Not our feature work
- `rc759-upstream-pr` (+1, `028004c67f8`): squashed upstream-PR version of the
  rc759 graphics/screensaver fixes — content already on master as individual
  commits (git cherry shows `+` only because it is a squash, not new work).
- `backup-rc750-rom-font-text-2026-09-03` (+6): safety backup of the pre-rebase
  rc750 branch — superseded, work merged (f6daedd). Deletable.
- `rc759-full-upstream` / `rc759-squashed` (+416): mamedev/mame upstream tracking.
- `master-predev-2026-08-07` (+62), old `upstream-rc702-v1` base: stale old bases.

## Rule reminder
Feature branches merge into `master` with `--no-ff`; push origin only at merges.
The merged rc750 feature branch (`rc750-rom-font-text`) was deleted post-merge.
See `[[project_rc750_partner_boot_bringup]]`.

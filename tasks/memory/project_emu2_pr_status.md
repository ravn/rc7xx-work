---
name: project_emu2_pr_status
description: Status of emu2-cpm86 upstream PRs against johnsonjh/emu2-cpm86 -- parked awaiting upstream response.
metadata:
  type: project
---

Emu2 upstream PR work completed 2026-08-26. All ravn/emu2-cpm86 improvements filed as clean PRs against johnsonjh/emu2-cpm86. **Parked until upstream responds.**

| PR | Titel | Status |
|----|-------|--------|
| [#4](https://github.com/johnsonjh/emu2-cpm86/pull/4) | Entry-time scratch stack (SS≠DS) | open |
| [#5](https://github.com/johnsonjh/emu2-cpm86/pull/5) | DOS stdio flush after random write | open |
| [#6](https://github.com/johnsonjh/emu2-cpm86/pull/6) | EMU2_RAMDUMP | open |
| [#8](https://github.com/johnsonjh/emu2-cpm86/pull/8) | P_LOAD relocation + PL/M-86 register contract | open |
| [#10](https://github.com/johnsonjh/emu2-cpm86/pull/10) | Debug-dokumentation + EMU2_RAMDUMP entry | open |
| [#11](https://github.com/johnsonjh/emu2-cpm86/pull/11) | EMU2_CPMVER multi-user note | open |
| [#12](https://github.com/johnsonjh/emu2-cpm86/pull/12) | T_SECONDS (155) + T_SET (104) | open |
| [#13](https://github.com/johnsonjh/emu2-cpm86/pull/13) | Hukommelsesstyring: group alloc, TPA, M_ALLOC/M_FREE, MCB shrink, corruption fix, CPM86_POISON | open |

PRs #7 og #9 blev lukket utilsigtet (branch-sletning) og er erstattet af #12 og #13.

**How to apply:** Do not start new emu2 work until johnsonjh has reviewed. If upstream merges PRs, bump the `emu2-cpm86` submodule pin and rebase `local/cpm86` onto the new upstream.

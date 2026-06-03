---
name: MAME upstream routing — shared devices vs rc702 driver
description: Shared MAME devices (FDC/PIO) → upstream mamedev/mame; rc702 driver → ravn/mame fork. NEVER file in any MAME repo without explicit per-issue permission.
metadata:
  type: feedback
---

When a bug is in **shared MAME device code** (e.g. the FDC `upd765`, the `z80pio`),
the upstream target is **`mamedev/mame`**. Our **`src/mame/regnecentralen/rc702.cpp`**
driver stays in the **`ravn/mame`** fork.

**HARD (user directive, 2026-06-02): never file anything in any MAME repo
(`mamedev/mame` or `ravn/mame`) without explicit per-issue permission.** Draft and
analyse only; the user approves each filing. Same spirit as [[feedback_no_upstream_issues]].

**Why / lessons from the two rejected 2026-03 PRs** (`mamedev/mame#15031` Read Track ST1_ND,
`#15032` rc702 + FDC), recorded so we don't relearn them:
- **rc702 is NOT in upstream MAME** (the PR to add it was rejected) and the fork is a
  "derivative version" — MAME's bug template rejects both. An upstream device-bug repro
  **must** be on an existing upstream-supported machine that uses the device, on the
  **latest official MAME** — not via rc702/the fork.
- **Actually run it in MAME.** Reviewers explicitly distrusted changes "validated in code"
  but not emulator-tested.
- **Verify datasheet claims against the primary source** before citing (an AI-written,
  unproofread datasheet quote sank #15031). See [[feedback_state_certainty]].
- **Don't bundle a device fix with the rc702 driver** — keep them separate PRs/reports.
- Channel: decide per-bug (mametesters.org for user-facing bugs in releases; GitHub
  `bug-report.yml` for reproducible dev/accuracy issues).

**How to apply:** for shared-device MAME bugs, follow draft → user approves → file (never
unsolicited); build an admissible repro on an upstream machine + latest MAME first.
Full candidate analysis: `tasks/mame-upstream-fdc-findings-2026-06-02.md` (incl. the
empirical bug-B-breaks-roa375 A/B). Related: [[feedback_file_issues_in_forks]] (deps
default to ravn/* forks), [[project_ravn_mame_6]].

**Workspace caveat (don't re-investigate):** rc702 doesn't boot to `A>` in the
workspace `mame` checkout — it stalls after FDC density-detect. This is a stale-fork
issue (latest upstream MAME boots rc702 fine, user-confirmed 2026-06-02), NOT bug
A/B or codegen. Update the checkout (reapply local upd765 fixes after merge) to boot.

# MAME upstream µPD765 (FDC) bug-report candidates — findings 2026-06-02

## Goal & routing

Extend the curated-upstream-submission discipline (already used for `llvm-z80`)
to MAME, for **shared device code** — not the RC700 driver.

- **Shared MAME devices** (e.g. the FDC `upd765`, the `z80pio`) → upstream **`mamedev/mame`**.
- **`src/mame/regnecentralen/rc702.cpp`** (our driver) → stays in the **`ravn/mame-rc702-rc759-rc750`** fork.

**HARD constraint (user, 2026-06-02): never file anything in any MAME repo
without explicit per-issue permission.** Everything below is draft/analysis.

## The RC702 FDC

RC702 uses the **µPD765A** (`upd765a_device`, `src/devices/machine/upd765.{cpp,h}`).
The driver's FDC wiring (`rc702.cpp`) was checked and is deliberately correct —
not a source of upstream bugs:
- `set_floppy()` is *intentionally not called* (rc702.cpp:417-421); that legacy API
  force-binds one drive to all 4 `flopi` slots by design — drivers using connector
  subdevices (`fdc:0`) must avoid it. Not a device bug.
- `//m_fdc->dack_w ... pin not emulated` (rc702.cpp:410): `upd765` has **no `dack_w`
  pin at all** — a modeling simplification, no user-visible bug pinned to it.
- `eop_w`/`dack1_w` → `tc_w`, and `set_rate()` at reset: normal driver wiring.

## Two confirmed-live device bugs (both still in upstream `mamedev/mame` HEAD)

### A. Read Track sets spurious ST1 "No Data" (ND)
- **Where:** `read_track_continue()` — upstream `upd765.cpp:2346+`. Per sector it does
  `if(!sector_matches()) st1 |= ST1_ND; else st1 &= ~ST1_ND;`, so the **last** sector
  decides the final ST1. Affects any software that checks ST1 after Read Track.
- **Prior attempt:** **PR #15031 — closed, NOT merged** (rejected).
  - The (AI-written, unproofread) description **misquoted the datasheet**, claiming Read
    Track does not compare IDs. Maintainer **cracyc** corrected it: the NEC µPD765A sheet
    (dunfield 765.pdf) *does* describe an ID comparison in Read Track.
  - cracyc's real hint: *"the value should not be reset after each sector."*
  - The **correct, narrower** reading: the ST1 **ND bit definition** (datasheet p.17)
    says for Read Track ND = *"the starting sector cannot be found"* — distinct from
    Read Data's per-sector meaning, and **not** a per-sector re-evaluation.
- **Re-approach:** nuanced/contested but the maintainer is already engaged. Frame from
  the p.17 ND definition + the "don't reset per sector" point, with a clean repro.

### B. ST0 leaks the head bit after Seek/Recalibrate (regression)
- **Where:** `recalibrate_start()` (upstream `upd765.cpp:1735`) and `seek_start()`
  (upstream `upd765.cpp:1752`) both do `fi.st0 = command[1] & 7`, leaking the HD bit
  (bit 2) into the value returned by Sense Interrupt Status. The `& 7` at lines
  1876/1921/2166/2325/2544/2622 is **correct** (read/write/format carry a head). Only
  seek/recalibrate should mask `& 3` (unit select only).
- **Regression with a named culprit:** commit **`272ec75ca61`** ("upd765: reset st0 when
  starting a seek and fail if drive isn't ready") introduced the `& 7`.
- **Prior attempt:** buried in **PR #15032** ("rc702: refactor into working machine
  variants, fix FDC bugs") — **closed, NOT merged**. It bundled an *rc702 driver
  refactor* with the device fix; reviewers also flagged the changes were *"validated in
  code by Claude,"* not actually run in MAME.
- **Re-approach:** standalone, **cleanest of the two** — a regression with a culprit
  commit is the most persuasive report. Real HW returns unit-select only.

Our `ravn/mame-rc702-rc759-rc750` fork already carries both fixes locally (`& 3` at upd765.cpp:1696/1712;
Read Track ND logic neutered) and must reapply them after any upstream merge.

### Bonus (not FDC)
`ravn/mame-rc702-rc759-rc750#6` — the `z80pio` device drops IM2 IRQs when two slot devices share one PIO.
Shared-device upstream candidate, but it's the PIO, not the FDC; already a fork issue
(see `tasks/memory/project_ravn_mame_6.md`).

## Empirical verification (2026-06-02)

Built an FDC transaction logger — `autoload-in-c/mame_fdc_log.lua` + `make fdc-log`
— that taps the µPD765 I/O ports (passive write/read taps on 0x05 cmd/result,
0x04 MSR; never IO reads) and decodes every command + result, flagging the bug-A
and bug-B signatures. Evidence captured in `autoload-in-c/fdc-evidence/`.

**Bug B is confirmed to break the GENUINE roa375 boot ROM** (not just our C
rewrite). Method: built a buggy MAME by reverting the fork's fix (`& 3` → `& 7`),
ran the genuine `roa375.rom` (sha1 306af9…) on fixed vs buggy MAME with the same
disk:
- Fixed: seek-to-head-1 → `ST0=20` → roa375 **reads side 1** → banner `RC700`.
- Buggy: seek-to-head-1 → `ST0=24` → roa375 **skips side 1**, reads only side 0,
  and halts with **`** NO SYSTEM FILES **`**.

So the leaked head bit makes roa375 treat the disk as single-sided and fail to
boot. (A mid-investigation static-disassembly claim that "roa375 masks the head
bit with `and 0x23`, so it's tolerant" was **WRONG** — refuted by this A/B; the
real side-1-detection path rejects `ST0=24`. Lesson: verify emulation-accuracy
claims by running the real ROM, don't trust static reasoning about firmware
tolerance.)

**Bug A is NOT exercised by roa375 (or autoload-in-c).** Over a full boot trace
both use only Read Data (`06`/`46`) and Read ID (`0A`/`4A`) — zero Read Track. So
bug A's impact on roa375 is nil for this boot path; it affects only software that
issues Read Track + checks ST1 (the old TODO's "roa375 also uses Read Track" does
not hold here). Bug A remains a real device-accuracy bug, just not roa375-visible.

**Workspace-MAME caveat (do not re-investigate):** genuine roa375 (and
autoload-in-c) do not reach `A>` in the workspace `mame` checkout even with both
bugs fixed — they stall after density detection (last FDC cmd a `Specify [DF 28]`,
then silence). This is a **stale-fork-MAME issue**: the latest upstream MAME
sources boot rc702 fine (user-confirmed 2026-06-02). It is NOT bug A/B, not
roa375-specific, and not a rebuild artifact (the 17-May binary and a fresh rebuild
behave identically). To boot to `A>`, update the workspace `mame` to latest
sources (reapply the local upd765 fixes after the merge).

## What the rejections teach us — must-dos before any filing
1. **rc702 is NOT in upstream MAME** (the PR to add it, #15032, was rejected) and the fork
   is a "derivative version" — MAME's bug template rejects both. The repro **must** be on
   an existing **upstream-supported machine** that uses `upd765`, on **latest official
   MAME**. Untested candidate machines from the old draft: `cpc6128`, `qx10`.
2. **Actually run it in MAME** — reviewers explicitly distrusted code-only validation.
3. **Verify datasheet claims against the primary NEC source** before citing (this burned
   PR #15031). See `tasks/memory/feedback_state_certainty.md`.
4. **Keep the device fix separate from the rc702 driver.**
5. **Bug report vs PR: decide per-bug.** MAME's template prefers mametesters.org for
   user-facing bugs in releases, GitHub issues (`bug-report.yml`) for reproducible
   dev/accuracy issues.

## Next step
Bug B is demonstrated on the fork (harness + genuine-roa375 A/B above). The only
gap left for an *upstream filing* is an **admissible repro on an upstream-supported
machine** (rc702 isn't in upstream MAME): find a mainline `upd765` machine whose
software does Seek + Sense-Interrupt and observes ST0 (for B), or Read Track +
checks ST1 (for A) — old draft candidates `cpc6128`, `qx10`. Then draft → user
approves → file (never unsolicited).

## Cross-references
- Prior analysis: `rc700-gensmedet/rcbios/MAME_UPD765_READ_TRACK_ANALYSIS.md`,
  `rc700-gensmedet/rcbios/MAME_UPD765_PR_DRAFT.md`, `rc700-gensmedet/TODO_UPD765_READ_TRACK.md`
- Rejected PRs: `mamedev/mame#15031` (Read Track ND), `mamedev/mame#15032` (rc702 + FDC)
- Lessons already recorded: datasheet-citation discipline + AI-authorship disclosure
  (`rc700-gensmedet/tasks/lessons.md`, 2026-02-27/28)

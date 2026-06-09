# ravn/rc700-gensmedet open-issue re-evaluation — 2026-06-10

42 open issues at start of review.  Triaged against the current tree
(`rc700-gensmedet/main`), the parking notes (`cpnos-in-asm/PARKED.md`,
`cpnos-rom` directory **removed**), the four-firmware-component finishing
plan (`tasks/memory/project_finishing_firmware_components.md`), and the
existing `cpnet/finishing-checklist.md`.

**Methodology:** per HARD rule `feedback_revalidate_concern_not_filename`,
file-path drift does NOT close an issue — the *concern* must still apply
to the current production tree.  Verified each issue's claim against the
present code where the file path could have moved.  Recommendations are
**proposals only**; no `gh issue close` actions taken — that's a
hard-to-reverse operation the user owns.

## Headline

| Bucket | # | Action |
|---|---|---|
| A. Close — concern is dead (subsystem removed/parked, no analog in current code) | 6 | Close with one-line note |
| B. Close — self-marked obsolete | 1 | Close per issue body |
| C. Re-target — concern is live, file path drifted | 7 | Edit title/body to point at current file; keep open |
| D. Verify — claim references a path that's gone, unclear if concern survives | 8 | Spot-check current tree per issue; close or re-target |
| E. Keep — actively-live work | 15 | No action |
| F. Doc fix — actionable in this session | 1 | Fix and close |
| G. Hardware-gated | 2 | Keep open, label `awaiting-hardware` |
| H. Move to cpnos-in-c label / verify scope | 2 | Re-target if migration applies |

## A. Close — concern dead (subsystem gone)

Six issues describe `cpnos-rom/` files; the directory is gone and the
work was superseded by `cpnos-in-c` (production) per CLAUDE.md.  The
concerns either don't apply to `cpnos-in-c`'s very-different layout
(payload header, ZX0 compression, single PROM1) or apply differently.

- **#21** PCB530 4 KB PROM blocker (Issue BB) — `cpnos-rom` was the
  candidate; production is now `cpnos-in-c` PROM1-only line program
  (2030 B, single PROM, no 4 KB requirement).  Concern superseded.
- **#82** ZX0 payload compression for cpnos-rom — `cpnos-in-c` already
  ZX0-compresses its payload.  Done by another route.
- **#92** Maximize TPA by packing IVT + SCRATCH BSS — IVT location is
  pinned in `cpnos-in-c`'s memory map (memory rule
  `project_rc702_ivt_page_constraint`); this issue's framing is
  cpnos-rom-era.
- **#93** Unlock `-mllvm -disable-block-placement` for cpnos-rom — flag
  irrelevant once the subsystem is gone; no equivalent measurement
  exists for `cpnos-in-c`.
- **#95** Remaining ~60-100 B clang shrink in cpnos-rom — the shrink
  budget the issue chases doesn't translate to the cpnos-in-c
  PROM1-only line-program shape.  If there are non-backend shrink wins
  in cpnos-in-c, file fresh.
- **#90** DMA auto-refresh / eliminate isr_crt in cpnos-rom — auto-refresh
  is a cpnos-rom assumption.  `cpnos-in-c` doesn't carry `isr_crt` in
  the same role.

**Suggested close-comment template:**
> Closing — `cpnos-rom` is removed from the tree (2026-05-17 era;
> superseded by `cpnos-in-c` PROM1-only line program per CLAUDE.md).
> Concern is `cpnos-rom`-specific and doesn't have a direct analog in
> the current production layout.  Reopen with a fresh framing if the
> same pattern surfaces in `cpnos-in-c`.

## B. Close — self-marked obsolete

- **#25** "cpnos-rom: Lua PASS gate doesn't test CONIN (Issue E — now
  covered, close?)".  Title self-marks the resolution.  Close.

## C. Re-target — concern is live, path drifted

Seven issues describe a concern that the current tree still has, just
under a different file path.  Don't close — edit title/body to point at
the current file.

- **#17** LOGIN password hardcoded to "PASSWORD" — `cpnos-rom/netboot_mpm.c`
  is gone, **but** `grep -l PASSWORD cpnos-in-c/src/*.c` finds it in
  `init.c`.  Concern LIVE.  Re-target body to `cpnos-in-c/src/init.c`.
  (Security shape: secrets-in-source in a network slave.)
- **#36** RC700 terminal codes state machine — title says "reopen after
  BIOS_BASE expansion".  BIOS_BASE work has progressed (rcbios is
  finishing-checklist territory).  Re-target at current rcbios-in-c, or
  retire if subsumed by other work.
- **#48** cpnos-rom ISRs unconditionally EXX/EX AF,AF' — unsafe if slave
  code uses shadow regs.  The ISR-shadow-reg safety question is still
  relevant in cpnos-in-c (shadow regs are reserved by `+shadow-regs`).
  Re-target body at `cpnos-in-c/src/`.
- **#50** Why memcpy/memmove compile to large code at call sites —
  measured in cpnos-rom; the *clang codegen behaviour* is now under
  ravn/llvm-z80 with #205 (`Z80PatternFillRecognize`) covering the
  pattern-fill side and AVR-style i64 copy (`avr-style-wide-access`
  branch) covering the wide-copy side.  Likely already addressed;
  verify cpnos-in-c memcpy size at call sites and close if so.
- **#85** Collapse `_bios_*_shim` BC->HL bridges in cpnos-rom — shims
  may have migrated to cpnos-in-c's `bootstrap.s`/`hal.h`; spot-check.
- **#87** `enter_coldst` and near-orphan externs could be static
  (cpnos-rom) — same; check cpnos-in-c.
- **#7** Status line on row 26 via 8275 dual-DMA — title says "shelved,
  see tasks/status-line-26.md".  Shelved differs from closed; the
  writeup exists.  Either close as `won't-fix` referencing the
  writeup, OR keep open with `parked` label for future revisit.  My
  call: convert to `parked` label rather than close, so the writeup
  stays discoverable.

## D. Verify — file gone, concern unclear

Eight issues reference `netboot_server.py`, which has been removed from
the tree.  Likely succeeded by `cpnet/server.py` (current).  Each issue
needs a 5-line check: "does cpnet/server.py have this bug?"  If yes,
re-target; if no, close.

- **#18** `_seed_sub_file` default slave_id=0x70 stale (Issue Y).
- **#23** PIPNET.COM sends zeroed FCB on WRITE SEQ (Issue N).
- **#27** SEARCH FIRST preamble ambiguity stsf1 vs stsf2 (Issue J).
- **#28** Single-client SEARCH iterator state (Issue K).
- **#30** DIR entries single-extent only (Issue M).
- **#29** cpnos-rom tests: task notification != MAME exit (Issue L)
  — cpnos-rom tests are gone; the MAME-exit-on-task pattern may apply
  to the current test harness.  Verify.
- **#20** z80pack submodule `srcmpm/netwrkif-*.asm` CONIN bug (Issue
  AA) — verified: `z80pack/srcmpm/` directory does **not** exist
  (`ls z80pack/srcmpm/` empty).  Either renamed (find the current
  netwrkif source) or removed.  Likely closeable; verify the z80pack
  submodule's current CP/NET source location first.

## E. Keep — actively live

Fifteen issues describe current production-tree concerns:

- **#8, #9** MAME rc702mini (diag_port50, CBL936+CBL998 loopbacks).
  `rc702mini` is referenced in CLAUDE.md as the test target shape.
  Live tooling work.
- **#10** Create maxi 8" boot diskette of RC702 test v1.2 for physical
  machine.  Tied to the user's RC702 hardware testing path.
- **#33** Research: CP/NET clock / MP/M II time-of-day.  Open
  research question; no decay.
- **#37** cpnos-rom 8" DS/DD dual-drive local support — framed as
  cpnos-rom; if it applies to cpnos-in-c at all, the production
  topology is "diskless slave" (`project_cpnos_no_local_floppy`)
  which contradicts the issue.  Probably belongs in bucket A but
  needs the user's call.
- **#42** Detect stray Python `netboot_server` before trusting MP/M
  results — netboot_server is gone, but the *generic* "detect stray
  daemon" pattern applies to `cpnet/server.py` and similar.  Re-frame.
- **#44** cpnet-smoke needs manual Enter at MAME's keyboard —
  reproducible automation gap.
- **#45** Parallel M80-on-rcbios test deferred.
- **#52** cpnos-sub-test 'mac sysgen|load sysgen' times out at 60 s.
- **#53** tap.lua banner check looks at row 0 instead of row 1.
- **#54** transport_pio_recv_byte ring unusable for sustained streaming.
- **#55** harness hostsend/loopback/speed* broken after bitbanger
  refactor.
- **#78** Demo: SEM702 high-res graphics via runtime character generator
  updates.  Stretch goal.
- **#83** snios_c.c try_send_frame/try_recv_frame: refactor to remove
  SDCC IX-frame spills.  `snios_c.c` is in cpnos-in-c (live).
- **#84** snios: convert remaining JT + bridges from asm to C.  Live.
- **#89** Investigate LTO for cpnos-rom / rcbios-in-c.  cpnos-rom is
  gone; rcbios-in-c portion is live (BIOS is 5905 B; LTO could shave).
  Re-target at rcbios-in-c only.

## F. Doc fix — actionable this session

- **#101** CLAUDE.md IVT slot table is autoload-PROM-era; rcbios CTC
  base is 0x00 (display ISR at offset 0x04, not 0x14).  Targeted doc
  edit.  Fix and close in the same commit, no behavioral risk.

## G. Hardware-gated — keep open

- **#102** SEM702: identify chips on piggyback boards (physical photo
  needed).  Memory rule `project_sem702_request_chip_photo` reminds
  to ask when the RC702 is open.
- (Implicit: #10 — boot diskette, partly hardware-gated.)

## H. Move to cpnos-in-c label

- **#34** Toolchain: make cpnos-build monolith position-independent
  (SPR-relocatable) — cpnos-build is the asm-side build; cpnos-in-asm
  is PARKED.  If SPR-relocatable is still wanted for cpnos-in-c, the
  framing differs.  Verify scope.
- **#31, #32** cpnos-build M80/zmac SPR issues — same; tied to
  parked cpnos-in-asm.

## Cross-cutting observations

1. **Issue-label hygiene is zero.**  Every issue has `[-]` (no labels).
   Adding labels (`cpnos-rom-superseded`, `awaiting-hardware`,
   `harness`, `cpnos-in-c`, `parked`) would make future re-evaluations
   five minutes instead of an hour.
2. **The cpnos-rom directory removal happened without an issue-sweep.**
   This re-evaluation is the sweep — half the open issues describe
   files that don't exist anymore.
3. **The four-firmware-component finishing plan
   (`project_finishing_firmware_components`)** says rcbios + autoload-
   in-c + CP/NET + cpnos-in-c are the production deliverables.  Cross-
   checking: this issue list has nothing tagged for `autoload-in-c`
   (because autoload-in-c is in finishing territory and clean) and
   nothing tagged for `rcbios-in-c` explicitly (BIOS_BASE expansion
   work is implied in #36).  The bias of the list is toward
   harness/test/legacy-subsystem issues; the production firmware
   itself has little open debt.

## Recommended next steps

In priority order:

1. **Fix #101 immediately** (small, actionable, doc only).
2. **Bucket A close** (6 cpnos-rom-superseded issues) — one batch comment
   per issue, then close.  Closing is hard-to-reverse, so present
   batched for user approval before executing.
3. **Bucket B close** (#25) — self-marked.
4. **Bucket C re-target** (7 issues with live concerns but stale paths)
   — body edits, then re-evaluate priority of each.
5. **Bucket D verify** (8 netboot_server-era issues) — five-minute spot-
   check per issue; close or re-target.
6. **Add labels** to the remaining open set: `cpnos-in-c`, `harness`,
   `awaiting-hardware`, `compiler-debt`, `parked`.

After this sweep the open-issue count would drop from 42 to roughly
20-25, all describing live concerns against the current tree.  That's
the target.

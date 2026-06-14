# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## ⛔ TOP-PRIORITY HARD RULE — never search outside the workspace

**Before EVERY `find`, `ls`, `glob`, `grep`, `mdfind`, `locate`, or agent search: read the path.  If it does NOT start with `/Users/ravn/z80/` (macbook) or `/home/ravn/z80/` (sonnyboy), STOP.  Ask the user.  Do NOT run the command.**

This includes "parallel just in case" broad searches when a direct path lookup is also running — the broad search walks iCloud-synced directories and forces iCloud to download every offloaded file, costing real bandwidth and disk regardless of whether anyone reads the result.  Four documented incidents (2026-04-21, 2026-05-09, 2026-06-10, 2026-06-14) — see `tasks/memory/feedback_no_home_search.md` for full history.  Further violations are a session-ending failure of trust, not a recoverable mistake.

If a workspace-internal lookup returns nothing, the answer is **ask the user where the file lives**, never "search wider."

## Memory — read at session start

**Durable rules, preferences, and lessons live in `tasks/memory/` (index: `tasks/memory/MEMORY.md`). Read `tasks/memory/MEMORY.md` at the start of every session.** This was migrated out of `~/.claude/` on 2026-05-28 (per the "persistent notes in the project, never `~/.claude/`" rule), so the harness no longer auto-injects it — reading it is now a deliberate session-start step. To record a new durable note, add a file under `tasks/memory/` and a one-line index entry in `tasks/memory/MEMORY.md`; never write to `~/.claude/`.

## Project Goal

Optimize the Z80 backend of ravn/llvm-z80 (a GlobalISel-based LLVM fork) to match or beat SDCC code density. Test against RC700 PROM and BIOS sources in rc700-gensmedet.

**Long-term direction (user 2026-06-03):** the four RC702 firmware components — **rcbios, autoload-in-c, CP/NET, cpnos** — are the production deliverables that this compiler work serves. The goal is to bring all four to a **finished** state (no known bugs, clear docs, oracle coverage, sustainable headroom). All four currently *work*; "finished" is the next bar. Bias compiler/feature priorities toward items that measurably advance one of these four. See `tasks/memory/project_finishing_firmware_components.md`.

## Current State (sizes refreshed 2026-05-31)

**Headline:** clang beats SDCC on ALL production targets (autoload, cpnos, BIOS) and dominates the AES corpus. Cheap codegen + regalloc levers are exhausted (session #74 production-density drill: dominant residual waste is ISA-fundamental); the remaining high-value compiler work is upstream-submission packaging.

- autoload PROM (clang, ZX0-compressed): **1673 B / 2048 B (375 B free)** — measured 2026-06-08 with `-z80-enable-cse=false` default (was 1652 B; +21 B from CSE disable after pi miscompile found, see B15).  Banner: `RC700 ROA375 CL <date> <hash>/<user>`.  Hard-capped at 2 KB (no A11 bridge on user's hardware — memory rule `project_rc702_2kb_prom_hard_limit`).
- BIOS: clang **5890 B** vs SDCC **6091 B** (measured 2026-06-10; clang default now `-flto` per #89, −15 B from prior 5905 B baseline).  MAME boot verified (mame-test 77-track sweep ERR=0 on the LTO build, 2026-06-10).
- **cpnos-in-c PROM1-only line program** (production target): clang × {PIO+SIO} dual — compressed **2030 B / 2048 B (18 B free)** measured 2026-06-08 (+7 B from CSE disable); polypascal-test PASS on BOTH transports (pio-irq AND sio; the harness now sets the SW1 S03 DIP from `$TRANSPORT`).  SDCC: **2151 B** / 4 KB padded, MAME-only (needs PROMCFG=2, 2732 4 KB); polypascal-test PASS.  Build: `cd cpnos-in-c && make prom1-lineprog COMPILER={clang,sdcc}`.  Shared init.c / resident.c; compiler-specific cold-init via bootstrap.s (clang) vs bootstrap.asm (SDCC).
- cpnos-in-c resident (clang, PIO transport): **clang 2004 B / SDCC 2120 B** raw .payload non-padding.
- AES-256 corpus (rc700-gensmedet/tasks/aes256-corpus): `09_Oz_prod_like` clang **−22 % size, +51 % slower** vs zsdcc (2581 B / 18.21 M tstates vs SDCC 3323 B / 12.08 M, llvm-z80 main `21ef058` 2026-06-08).  Size win intact; speed regression is from the sound icmp-narrow gate revealing a deeper structural issue (CVP strips `AggressiveInstCombine` Phase 2's narrowness marker on Z80) — see `[[project_aes_kr_speed_gap_accepted]]` and `llvm-z80/tasks/session-2026-06-08-clang-vs-sdcc-speed-investigation.md`.  All 13 configs PASS verifier.  Off the critical path for the four finishing-firmware components; revisit triggers in the memory note.
- Z80 lit suite: **143 PASS + 4 XFAIL**, CI green.  Two-tier CI on llvm-z80 main: `build-and-lit` (lit) + `runtime-tests` (test-runner via z88dk-ticks); production verifier-clean enforced by `z80-utils/test-runner/scripts/verify-production.sh`.
- **Compiler intrinsics/attributes** (#42 + #4 closed): clang SHIPS `<intrinsic.h>` (resource dir) so the SAME rcbios source compiles under clang AND SDCC with no `-I`/`#ifdef`.  Builtins `__builtin_z80_di/ei/halt/nop/im2/set_i`; `__attribute__((z80_critical))` (analog of SDCC `__critical`) drives Z80FrameLowering DI/EI.
- **rcbios CP/NET SNIOS dual SIO+PIO** (session 73k): self-modifying JP-trampoline dispatch in NTWKIN reads SW1 bit 2 once; PIO impl = Mode 1 input + IRQ-driven 256 B SPSC ring at IVT slot 17.  Both BIOS variants verified end-to-end via `cpnet/polypascal_pio_test.sh` (clang 10.50 s, SDCC 10.71 s).
- **SW1 bit allocation** (all firmware components honor consistently): bit 0 (S01) console mode (rcbios + cpnos); bit 1 (S02) PROM1 lineprog enable (autoload); bit 2 (S03) CP/NET transport PIO/SIO (cpnos PROM1-only AND rcbios SNIOS).  Canonical doc: `rc700-gensmedet/docs/SW1_BIT_MAP.md`.  Migration note: post-73k SNIOS.SPR with default DIPs (S03 = On = 0) routes to PIO — SIO users must flip S03 to Off.
- IX/IY: reserved by default (un-reserve gated on regalloc cost-model work, #38).  #189/#27/#112 byte-decompose leaks FIXED (session 73ab): `getLargestLegalSuperClass` GR16NoIR gate + `Z80NarrowNoIndex` pre-RA pass eliminate undocumented IYH/IYL emission and the #189 miscompile under `-z80-unreserve-iy`; production byte-identical.  Residual Class C (`push/pop iy` density in wide-int/float) = cost-model tradeoff, not a blocker.  See `llvm-z80/tasks/issue112-189-iy-leak-taxonomy-2026-05-25.md`.
- SDCC autoload build: unblocked (copt-rules path fix); per-compiler size policy = clang 2 KB hard / SDCC 4 KB MAME-only.
- **MAME `rc702sem702` machine**: clone of `rc702` 8" with SEM702 RAM-backed chargen (2 KB RAM behind ports 0xD1/0xD2/0xD3, strict-latch model, ROA296 still serves alpha).  Use for SEM702-equipped-machine emulation; baseline `rc702` keeps ROA327.
- **MAME rc702 driver col-80 fix** (ravn/mame@035d29086bf): `set_size(560, ...)` so 80 cols × 7 px = 560 visible pixels.  Build with `make OSD=sdl SOURCES=src/mame/regnecentralen/rc702.cpp REGENIE=1`.
- **MAME video-capture pipeline** (`scripts/mame_capture.sh`): every MAME launch -aviwrite -> docker ffmpeg h264 MP4 -> `scratch/mame-videos/`, prune to last 50.
- **sem702-qr-test**: subproject `rc700-gensmedet/sem702-qr-test/` — CP/M .COM painting two QR codes via SEM702 sextants, snapshot-verified in MAME (`make run`).
- **Two-PROM build PARKED 2026-05-17** (user: "it is only the autoload+cpnos scenario that interests").  Sole production topology: autoload-in-c (ROA375) in PROM 0 + cpnos-in-c PROM1-only line program in PROM 1.  See `cpnos-in-c/tasks/TWO_PROM_PARKED.md`.
- **cpnos-in-asm PARKED 2026-05-17** (see `rc700-gensmedet/cpnos-in-asm/PARKED.md`); superseded by cpnos-in-c PROM1-only.  Source tree preserved; new feature work goes into cpnos-in-c.
- **cpnos PIO → INIR (#115 Steps 2+4) PARKED 2026-06-14** until user has physical RC702 + Pi/Pico bridge hardware ready (per memory rule `feedback_ring_shrink_inir_coupled` — ring-shrink and INIR are coupled, and INIR can't be MAME-verified due to cpnet_bridge timing).  Steps 0+1 STAY in main: autoinit-DMA isr_crt strip (9592c2d) + `pio_b_recv_block_body` scaffold (50cc0bf).  See `rc700-gensmedet/cpnos-in-c/tasks/PIO_INIR_PARKED.md` for the unparking trigger and what's not committed.

## Canonical Plan

Master: `llvm-z80/tasks/roadmap-to-maturity.md` (session 36).
Current overlay: `llvm-z80/tasks/plan-2026-05-03-structural.md` (session 42).
Strategic frame: bring `llvm-z80/llvm-z80` (active fork-of-record, owner @zlfn) to maturity collaboratively; eventual official LLVM upstream is long-term aspiration. Workspace mode → engagement mode (gated on substantial body of work).

**Phase status (refreshed 2026-06-06):** Phase 1 Foundation DONE; Phase 2 Correctness sweep DONE; Phase 3 Cluster A regalloc **complete** (#94/#98/#99/#89 closed 2026-05-04; #27 shipped session #74 as opt-in `-z80-idx-addr`).  Correctness gate **CLEARED** (session #77 verdict): every Tier II miscompile/crash closed; no open miscompiles remain.  Remaining pre-upstream work is **packaging, not fixing** — but note the session #77 PR-#17 retraction below: all upstream filings now require per-filing explanation + explicit go-ahead (`feedback_explain_before_filing`), and generic-LLVM bugs route to llvm/llvm-project, never the fork (`feedback_upstream_routing_two_targets`).

**Coherence map (2026-05-22):** `llvm-z80/tasks/upstream-coherence-map-2026-05-22.md` classifies every open issue + known shortcoming into 11 upstream-relevance tiers; single source of truth for "what gets upstreamed where."

**Execution plan (2026-05-22):** `llvm-z80/tasks/execution-plan-2026-05-22.md` — 4 parallel tracks (A: U-LLVM upstreaming, B: correctness, C: #180/#181 cleanup gates, D: codegen-win packaging).  Backlog tiers: `llvm-z80/tasks/unpark-2026-05-22.md`.  U-LLVM submission queue: #186.

**Known suboptimal codegen (living index, 2026-06-08):** `llvm-z80/tasks/known-suboptimal-codegen.md` — cross-session index of unresolved codegen patterns, classified by middle-end (M1–M4) vs backend (B1–B10), with status / impact / why-not-fixed / revisit triggers per entry.  When a new "should be better" pattern surfaces, add an entry; when fixed, move it out to the session writeup that closed it.

## Session History

Detailed session-by-session log lives in `rc700-gensmedet/tasks/timeline.md`. Per-session summaries in `llvm-z80/tasks/session*-summary.md` and `rc700-gensmedet/cpnos-rom/tasks/`. Most-recent sessions (condensed; follow the cited summary file for detail):

- **#77 RETRACTED 2026-06-05** — PR #17 closed by @zlfn ("can't merge code contributions that contributors can't explain themselves"). Misroute: 5 of 6 XFAIL tests were target-agnostic generic-LLVM bugs that belong at `llvm/llvm-project`, not `llvm-z80/llvm-z80`. Cleanup option D in progress: withdraw issues #18-#25 at the fork; PR #27 (test-runner) and Issue #26 stay (correctly scoped, PR merged). New rule [[feedback_explain_before_filing]]: explain root cause + get explicit per-filing "go ahead" before any upstream post. Memory rules rewritten.  5-bug re-filing queue state: `tasks/upstream-5bug/STATUS.md`.
- **#77 (2026-06-01)** — Upstream packaging, test+docs+CI only.  #158 CLOSED + fully packaged (generic AggressiveInstCombine lit test + Z80 witness + runtime fixture, CI-gated; K&R `rj_sb_inv` 147→31 B); #176 verified already-shipped (close it); filed #213 (residual rotate-idiom density) + #214 (`opt -mtriple=z80` datalayout-less crash).  Verdict: correctness gate cleared, remaining work = packaging.  Curated submission to llvm-z80/llvm-z80 executed (PR #17, issues #18–#27) — later retracted, see above.  `llvm-z80/tasks/session77-upstream-submission-2026-06-01.md`.
- **#76 (2026-05-31)** — #205 CLOSED: `llvm.z80.pattern.fill` intrinsic replaces UB-in-IR overlapping-memcpy, folding 3 bugs; ZX0 reclaim lesson (fewer uncompressed bytes can compress LARGER — measure the post-compression artifact); `runtime-tests` CI job added (test-runner now CI-gated, main-only); #197 production half DONE (verifier-clean at all shipping opt levels, CI-enforced), O0 residual split to #212.  `llvm-z80/tasks/session76-issue205-pattern-fill-2026-05-31.md`.
- **#150 CLOSED (2026-05-31, same-session continuation)** — i16 EQ/NE HighByteZero extracts A via `sub_lo`: cpnos −8 B (payload 2012, compressed 2023), BIOS +4 B accepted.  Harness gap found AND FIXED: `TRANSPORT=sio` never actually selected SIO (lua never set the SW1 S03 DIP; payload is one dual build) — `polypascal_test.lua` now sets `:DSW` from `$TRANSPORT`; both transports verified PASS.  clang-SIO was always correct, just never selected.
- **#75 (2026-05-30, #177 TTI completion)** — `isLegalAddImmediate`=|Imm|≤3 fixes LSR formula choice (AES −8/−124/−42 B at -Oz/-Os/-O2, faster everywhere, production byte-identical, default-ON); fixed pre-existing `opt -mtriple=z80` startup crash (PassNameParser collision); accurate-but-inert shift/cast costs gated behind default-off `-z80-experimental-tti-costs`.  Lit 143+4.  #184 CLOSED WONT-FIX with mechanism writeup (`llvm-z80/tasks/issue184-wontfix-mechanism-2026-05-30.md`).  `llvm-z80/tasks/session75-cost-model-completion-2026-05-30.md`.
- **#74 (2026-05-30, #27 SHIPPED + #180 re-audit)** — `LOAD_IDX8`/`STORE_IDX8` pseudos close the IY phase-ordering gap; flag `-z80-idx-addr` default OFF, production byte-identical, AES `09_Oz_prod_like` −136 B when enabled.  #172 A-pin PARKED (5 approaches all net-negative).  #180 tracker ~half stale (only ~3–5 genuine migrations, cleanliness-only).  Production-density regalloc drill TAPPED OUT: residual waste is ISA-fundamental; #178 targets patterns production lacks.  Upshot: only high-value remaining work is upstream packaging.  `llvm-z80/tasks/session74-iy-indexed-addr-180-audit-2026-05-30.md`.
- **#73s-cont3 (2026-05-27)** — #137 CLOSED (test-runner re-runs failures with `-iochar 1` to show WHICH CHECK failed); #210 CLOSED (SP-relative frame-spill borrow undef reads — filed root cause was wrong; 3 real defects fixed incl. per-register-unit liveness).  Production byte-identical.  Lit 129+5.
- **#73s-cont2 (2026-05-27)** — 4 verifier red-surface classes fixed (#200, #194, #209 ×2); the `EX DE,HL` one-way-copy undef-dest fix let the optimizer drop dead dest-defs → cpnos −6 B.  Two systemic families identified: stale-def-liveness vs don't-care-reads.  `llvm-z80/tasks/session73s-cont2-verifier-sweep-2026-05-27.md`.
- **#73s-cont (2026-05-27)** — 9 issues closed across closeout clusters 1+4+2; #42 `<intrinsic.h>` + privileged-instruction builtins; #4 `z80_critical`; #203 guard-unification steps 1-3 (−80 lines, behavior-preserving).  BIOS 5922→5897 B.  `llvm-z80/tasks/session73s-cont-WRAP-2026-05-27.md`.
- **#73ab (2026-05-26)** — #189/#27/#112 IX/IY byte-decompose leaks FIXED (`getLargestLegalSuperClass` GR16NoIR gate + `Z80NarrowNoIndex`); undocumented IYH/IYL emission eliminated suite-wide; production byte-identical.  `llvm-z80/tasks/issue112-189-iy-leak-taxonomy-2026-05-25.md`.
- **#73p Phase 2 (2026-05-22)** — #177 partial TTI hooks shipped; #173 PUSH/POP-rr reload peephole; #184 (peephole #148 fall-through safety) + #185 (DJNZ B-clobber safety) miscompiles fixed.  cpnos PROM1 2030→2028 B.
- **#73p Phase 1 (2026-05-21, clang DOMINATES SDCC on AES)** — #179 P1+P2 (`Z80ReorderTestDec` pass) + #128 (LICM/CSE disable): AES `09_Oz_prod_like` −27.8 % ts, −93 B → clang −11 % faster AND −23 % smaller than SDCC, all 13 configs faster.  Issues filed #173–#183 + z88dk#16/#17; new `compiler-comparison-corpus/`.  `llvm-z80/tasks/session73p-phase1-summary.md`.
- **#73p Phase 0 (2026-05-21)** — Three documented dead-ends (#172 A-pin still net negative; #166 remat impossible; #166 ADD16_tied both routes miscompile, reverted) + #173 filed.  `llvm-z80/tasks/session73p-summary.md`.
- **#73o (2026-05-21)** — #172 A-shuttle filed; `AReg` class + `Z80PinAluAccumulator` pass landed default-OFF (pins too aggressively without interference checks).  `llvm-z80/tasks/session73o-issue172-a-pin.md`.
- **#73n (2026-05-21)** — `Z80NarrowIV` IR pass (i16→i8 loop counters via SCEV) default ON; AES wins up to −148 B; trackers #169/#170/#171 for the guarded-around bugs.  `llvm-z80/tasks/session73n-issue77-peephole-investigation.md`.
- **#73m (2026-05-21)** — #168 CLOSED (SimplifyCFG `foldTwoEntryPHINode` cost-gated bailout, AES −16 B / −1.1 % ts); #167 logically closed; `Z80LoopRotate` stays default-off.  `llvm-z80/tasks/session73m-summary.md`.
- **#73e (2026-05-15..16)** — cpnos-in-asm phases 1..3d-γ end-to-end (CP/NET 1.2 INIT + frame parse, 5/5 MAME oracles, fake-master exchange 6/6 ACKs); 3 deep bugs fixed (8275 mid-frame DMA resync, cursor P4 bits, bank2h PROM-mirror).  Since PARKED.  Timeline "Session 73e".
- **#73b/c (2026-05-15)** — #115/#27 S3': `INC16`/`DEC16` `isAsCheapAsAMove`+`isReMaterializable` (AES 8/13 configs −25..−118 B, production neutral); `tasks/tools/llvm-snap.sh` + sccache (2.9–6.5× faster iteration).
- **#73 (2026-05-15)** — #165 CLOSED: TruncInstCombine outside-user allowlist extended; gf_log 153→28 B, AES tstates 4×.  `tasks/session73-truncinstcombine-outside-user-extensions.md`.
- **#57 (2026-05-10, #75 CLOSED)** — Plain-C SNDMSG/RCVMSG state machines; 17 SNIOS functions in `snios_c.c`; mid-frame busy-wait deviation fixed; 4-cell polypascal-test PASS at parity.
- **#56 (2026-05-10)** — `cpnos-rom/CPNET_WIRE_PROTOCOL.md` authored (cross-checked vs z80pack master + DRI reference).
- **#48-55 (2026-05-09 → 10)** — cpnos-rom SDCC port + shrink (2756→1874 B); clang NULL-pointer `__builtin_memcpy` miscompile caught + fixed (#81); SNIOS asm→C phases 1-4.
- **#47 (2026-05-06/07)** — cpnos-rom data-driven relocator (linker-emitted `__payload_header`).
- **#42 (2026-05-03)** — llvm-z80 Phase 2 admin pass; #89 two paths ruled out; #120 combiner migration ruled out.

For older sessions (#12-#46), see `rc700-gensmedet/tasks/timeline.md`.

## Workspace Layout

Workspace root is per-host: `/Users/ravn/z80/` (macbook), `/home/ravn/z80/` (sonnyboy).  Everything lives under one folder:
- `llvm-z80/` — LLVM/clang fork with Z80 backend (shallow clone of github.com/ravn/llvm-z80)
- `rc700-gensmedet/` — RC700 CP/M system sources (github.com/ravn/rc700-gensmedet)
  - `autoload-in-c/` — ROA375 boot PROM in C (production, PROM 0)
  - `rcbios-in-c/` — CP/M BIOS in C
  - `cpnos-in-c/` — CP/NOS slave PROM1-only line program (production, PROM 1)
  - `cpnos-rom/`, `cpnos-in-asm/` — parked predecessors of cpnos-in-c
- `z88dk/` — z88dk toolchain (github.com/z88dk/z88dk, shallow clone). Contains sdcc/sccz80 compilers, Docker build workflows.

The autoload Makefile references `LLVM_Z80` relative to this workspace (via `$(CURDIR)/../../llvm-z80`).

## Build Commands

### LLVM-Z80 compiler (in Docker)
```bash
cd llvm-z80
cmake -C clang/cmake/caches/Z80.cmake -G Ninja -S llvm -B build
ninja -C build          # full build
ninja -C build clang    # just clang
ninja -C build llc      # just llc
```
Docker build image: `llvm-z80-build` (ubuntu:24.04 + cmake/ninja/clang/lld/python3).

### PROM builds (in rc700-gensmedet/autoload-in-c/)
```bash
make rom_parts          # SDCC build (needs z88dk in ../z88dk)
make clang              # Clang build (needs Docker + llvm-z80/build/)
make clang_asm          # Show clang assembly output
make mame               # Build SDCC PROM + boot test in MAME
make clang_prom         # Build clang PROM + install to MAME/RC700
```

### Tests
```bash
# LLVM lit tests
build/bin/llvm-lit llvm/test/CodeGen/Z80/

# Integration tests (in z80-utils/test-runner/)
cargo run                   # Default (O1, O2, Os)
cargo run -- clang          # Clang C suite
cargo run -- bench          # Code size benchmark
```

## Architecture

The llvm-z80 backend uses **GlobalISel** (not SelectionDAG). Key files:
- `llvm/lib/Target/Z80/Z80InstructionSelector.cpp` — instruction selection patterns (largest)
- `llvm/lib/Target/Z80/Z80LateOptimization.cpp` — peephole optimizations (most modified)
- `llvm/lib/Target/Z80/Z80ExpandPseudo.cpp` — post-RA pseudo expansion
- `llvm/lib/Target/Z80/Z80CallLowering.cpp` — sdcccall(0/1) calling conventions
- `llvm/lib/Target/Z80/Z80LegalizerInfo.cpp` — GlobalISel legalization
- `llvm/lib/Target/Z80/Z80RegisterBankInfo.cpp` — register bank selection

The PROM build uses `--target=z80 -Os` with `+static-stack` (BSS locals) and `+shadow-regs` (EXX for ISRs), linked with `ld.lld` via a custom linker script.

## Code Density Gap Analysis (BIOS; per-function profile from 2026-05-02, headline refreshed 2026-05-30)

Clang BIOS = **5897 B**, SDCC BIOS = 6091 B (clang **−194 B** overall).
Session #74's instrumented drill concluded the remaining clang-side waste is **ISA-fundamental** (8-bit memory is A-only → BSS-via-A + A-shuttle moves are irreducible without #172-class machinery, all approaches so far net negative); cpnos is near-optimal.  The 2026-05-02 profile below is kept for the per-function shape:

| Cause                                | Impact                    | Status                                   |
| ------------------------------------ | ------------------------- | ---------------------------------------- |
| 1. BSS load/store traffic            | 30–48% of large functions | **dominant**; ISA-fundamental (see #74)  |
| 2. Excess reg-to-reg moves (regalloc) | 22–58 per large fn        | A-shuttle class, #172 parked             |
| 3. Flag re-derivation (`or a`, `cp`) | 5–15 per large fn         | #77 open; #93, #86 closed                |
| 4. IX frame overhead                 | ~0 B (`+static-stack`)    | obsolete on BIOS                         |
| 5. IY prefix overhead                | ~0 B (IY reserved)        | obsolete; #38 gates re-enabling          |
| 6. 8→16 bit promotion                | residual / case-by-case   | mostly closed (#86, narrow-via-zext)     |

Largest clang BIOS functions: `_specc` 676 B (208 BSS), `_bios_hw_init` 341 B, `_rwoper` 263 B (105 BSS), `_bg_clear_from` 262 B, `_sec_rw` 247 B, `_bios_seldsk_c` 199 B (66 BSS), `_bios_write_c` 170 B, `_isr_crt` 166 B (80 BSS, highest density), `_xyadd` 149 B (64 BSS), `_chktrk` 136 B.

cpnos hot functions (`_netboot_mpm`, `_relocate`, `_impl_conout`) carry less state and are close to optimum.

## Key Z80 Optimization Patterns (from SDCC)

- **DJNZ** for `do { } while(--n)` loops (2 bytes vs 4)
- **LDIR/LDDR** for memcpy/memset
- **CP (HL)** for direct memory compare (1 byte, no temp)
- **BIT n,A** for single-bit tests (vs XOR/CP sequences)
- **ADD HL,HL** for 16-bit left shift (1 byte)
- **EX DE,HL** for register swap (1 byte, but destroys both)
- **SBC A,A** to materialize carry as 0x00/0xFF

## C Language Standard

Sources use **C23 features that work in both clang and z88dk zsdcc 4.5.0**.

Working in both: `true`/`false` keywords, `nullptr`, `_Bool`, `_Static_assert`, `__typeof`/`typeof`, `0b` binary literals, designated initializers, for-loop declarations, `#embed`.

NOT working in zsdcc: `constexpr`, `[[attributes]]` (use `__attribute__`), digit separators (`1'000`), `typeof` in expressions (`typeof(x){42}`).

## Environment

- Docker available for SDCC, **no brew** (never use or suggest brew)
- Native LLVM-Z80 clang at `llvm-z80/build-macos/bin/` (`make toolchain`) on the macbook; see `tasks/memory/reference_z80_tool_paths.md` + `reference_host_sonnyboy.md` for per-host paths
- z88dk via Docker container (do not rebuild from source)
- CLion as IDE, command-line collaboration here
- MAME for hardware emulation testing
- Never create pull requests unless explicitly told to
- Always use `--no-ff` for git merges
- **Only push to origin at merges.** Commit locally freely; do NOT auto-push every commit. Push origin only at a merge point (feature branch → main, `--no-ff`) or when explicitly asked. (User directive 2026-05-28.)  Exception: the workspace repo itself is commit-pushed at the end of every working segment (cross-machine rule, 2026-06-06).
- **Keep GitHub Actions green.** After any merge/push, check the runs (`gh run list` / `gh run view`) and fix failures promptly; run lit/checks locally BEFORE committing so CI never goes red. Z80 backend CI = `.github/workflows/z80-ci.yml`. (User directive 2026-05-28.)

## Workflow

- Record all user prompts in `tasks/prompts.md`
- Think out loud — show reasoning process
- **Persistent memory lives in the project, never `~/.claude/`.** Durable notes/preferences/lessons/rules go in `tasks/memory/` (index `tasks/memory/MEMORY.md`); broad project/workflow rules also in `CLAUDE.md`. The harness offers a default file-memory dir under `~/.claude/.../memory/` (and its system prompt may tell you to use it) — **that default is OVERRIDDEN by this rule; do not write there.** Before recording ANY durable note, confirm the destination is inside this project. (Reinforced 2026-05-28: a preference was wrongly saved to `~/.claude/` because the harness default was followed without checking; the whole memory tree was migrated to `tasks/memory/` the same day.)
- Plan in `tasks/todo.md`, lessons in `tasks/lessons.md`
- Never apologize. Be concise and accurate.
- Enter plan mode for non-trivial tasks. Re-plan if things go sideways.
- Verify changes work (tests, MAME boot) before marking done.
- **Whenever you modify the compiler, always add a lit test showing it works.**
  Add to existing relevant test file or create a new one in `llvm/test/CodeGen/Z80/`.
  The lit test is the **CI-gated** proof (the `build-and-lit` job runs lit; the
  `runtime-tests` job runs the test-runner) — pin the generated instruction sequence
  with FileCheck even when the bug is most naturally a runtime one. If correctness is
  only observable at runtime (e.g. a buffer over-run), ALSO add a test-runner runtime
  fixture (`z80-utils/test-runner/testcases/clang/*.c`, `/* expect 0xNNNN */`, glob
  -discovered) — it complements, never replaces, the lit test.

## Known Bugs in llvm-z80

- hasFP=false has runtime bug (parked)

FIXED:
- `"hl"` (and `bc`/`de`/`af`/`ix`/`iy`/`sp`) bare inline-asm pair constraints used
  to crash IRTranslator ("unable to translate instruction: call"): LLVM's
  IR-level InlineAsm parser splits a bare multi-letter constraint into
  single-register *alternatives* (`hl`→h|l, 8-bit), which can't hold a 16-bit
  operand.  `Z80TargetInfo::convertConstraint` now rewrites a bare pair name to
  the braced form (`hl`→`{hl}`); bare and braced pair constraints both work.
  (clang/test/CodeGen/z80-inline-asm-pair-constraint.c)

## Working LLVM-Z80 features (use directly; no inline-asm workaround needed)

- `address_space(2)` for port I/O — fixed in `0ff2114c62a6` + `0d71a91b4e18`
  (ravn/llvm-z80 #1, #44).  `*(volatile __attribute__((address_space(2)))
  uint8_t *)0x10` lowers cleanly to `IN A,(0x10)` / `OUT (0x10),A`.

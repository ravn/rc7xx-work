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

## Current State (sizes refreshed 2026-06-23)

**Headline:** clang beats SDCC on ALL production targets (autoload, cpnos, BIOS) and dominates the AES corpus. Cheap codegen + regalloc levers are exhausted (session #74 production-density drill: dominant residual waste is ISA-fundamental); the remaining high-value compiler work is upstream-submission packaging.

- autoload PROM (clang, ZX0-compressed): **1643 B PROM / 2048 B cap (405 B free)** — 2026-07-01.  Boot gate PASS (`make floppy-boot-test` → `A>` on unpatched `SW1711-I8.imd`; `make sw1-test` PASS).  Recent 2026-07-01 work: (1) SIO-B temporary debug facility removed (ravn/rc700-gensmedet#118, +249 B); (2) display framebuffer moved 0x7A00 → **0x7830** (80×25 = 2000 B, ends at 0x8000, stays in the original lower 32 KB — the C rewrite is a 64 KB design, stack at 0xBFFF); (3) ZX0 decoder split around the 0x0066 NMI vector + banner moved into the payload (−20 B).  Full annotated memory map (ROM before / RAM after ZX0) in `autoload-in-c/BOOT_SEQUENCE.md`.  gdb-z80 stub findings (`rc700-gensmedet/tasks/gdb-z80-stub-findings-2026-06-19.md`, workspace-level Docker/build scratch removed 2026-07-05) parked as the "better debug path".  Banner: `RC700 ROA375 CL <date> <hash>/<user>`.  Hard-capped at 2 KB (no A11 bridge on user's hardware — memory rule `project_rc702_2kb_prom_hard_limit`).
- BIOS: clang **5462 B** vs SDCC **6091 B** (re-measured 2026-06-15; clang **−629 B**, ~10.3% smaller than SDCC).  Prior recorded baseline 5890 B at 2026-06-10; current size reflects accumulated llvm-z80 backend gains since that measurement.  MAME boot last verified 2026-06-10 (mame-test 77-track sweep ERR=0); re-verify after next code change.
- **cpnos-in-c PROM1-only line program** (production target): clang × {PIO+SIO} dual — **2014 B / 2048 B (34 B free)** re-measured 2026-06-28 (payload 1986 B raw / 1384 B ZX0, unchanged; was 2013 B / 35 B free on 2026-06-23 after #146/#206).  **PIO (pio-irq) is the verified/recommended transport** — polypascal-test runs the full PPAS primes to 29989 reliably (Makefile default `TRANSPORT ?= pio-irq`).  **SIO is PARKED 2026-07-07**: the SIO byte-path has a deterministic 50% mod-2 pass/fail alternation flake (`cpnos-in-c/tasks/KNOWN_ISSUE_polypascal_alternation_2026-07-07.md`).  A pre/post-merge MAME A/B proved the flake is intrinsic to SIO (identical PFPFPF on both MAME builds), not a MAME regression; PIO is 6/6 on both.  Both transports remain physically selectable via SW1 S03; SIO is just not the MAME-test path until root-caused.  SDCC: **2151 B** / 4 KB padded, MAME-only (needs PROMCFG=2, 2732 4 KB); polypascal-test PASS (PIO).  Build: `cd cpnos-in-c && make prom1-lineprog COMPILER={clang,sdcc}`.  Shared init.c / resident.c; compiler-specific cold-init via bootstrap.s (clang) vs bootstrap.asm (SDCC).
- cpnos-in-c resident (clang, PIO transport): **clang 2004 B / SDCC 2120 B** raw .payload non-padding.
- AES-256 corpus (rc700-gensmedet/tasks/aes256-corpus): `09_Oz_prod_like` clang **−22 % size, +51 % slower** vs zsdcc (2581 B / 18.21 M tstates vs SDCC 3323 B / 12.08 M, llvm-z80 main `21ef058` 2026-06-08).  Size win intact; speed regression is from the sound icmp-narrow gate revealing a deeper structural issue (CVP strips `AggressiveInstCombine` Phase 2's narrowness marker on Z80) — see `[[project_aes_kr_speed_gap_accepted]]` and `llvm-z80/tasks/session-2026-06-08-clang-vs-sdcc-speed-investigation.md`.  All 13 configs PASS verifier.  Off the critical path for the four finishing-firmware components; revisit triggers in the memory note.
- Z80 lit suite: **164 PASS + 6 XFAIL**, CI green.  Two-tier CI on llvm-z80 main: `build-and-lit` (lit) + `runtime-tests` (test-runner via z88dk-ticks); production verifier-clean enforced by `z80-utils/test-runner/scripts/verify-production.sh`.  #212 CLOSED 2026-06-22; #239 (all 8 partial-undef PUSH_HL sites in Z80InstrInfo.cpp) CLOSED 2026-06-23 — 9 new lit tests.
- **Compiler intrinsics/attributes** (#42 + #4 closed): clang SHIPS `<intrinsic.h>` (resource dir) so the SAME rcbios source compiles under clang AND SDCC with no `-I`/`#ifdef`.  Builtins `__builtin_z80_di/ei/halt/nop/im2/set_i`; `__attribute__((z80_critical))` (analog of SDCC `__critical`) drives Z80FrameLowering DI/EI.
- **rcbios CP/NET SNIOS dual SIO+PIO** (session 73k): self-modifying JP-trampoline dispatch in NTWKIN reads SW1 bit 2 once; PIO impl = Mode 1 input + IRQ-driven 256 B SPSC ring at IVT slot 17.  **polypascal-pio-test PASS 16 s** (2026-07-08): `cpnet/polypascal_pio_test.sh` — H: → PPAS → compile PRIMES.PAS → PRIMES.COM (native, BDOS-9 print) → TESTDONE.COM prints "RCBIOS PIO TEST DONE".  Two fixes required: (1) ravn/mame `2eb88cea` z80pio `check_interrupts` — `B.ius` must not block port B's own next interrupt (global `A.ius||B.ius` gate was wrong; B.ius stuck permanently after first Mode-0→Mode-1 flip → ISR never fired → deadlock); (2) `cpnet/snios.asm` `RECVBY_PIO` → `JP RECVBT_PIO` — 82 ms timeout instead of unbounded busy-wait (cpnos passed earlier because its `transport_pio_recv_byte` already had a timeout; rcbios deadlocked because `RECVBY_PIO` had none).  Also added `TX_RETRY_CNT`/`RX_RETRY_CNT` BSS counters + `ERRRTN` CONOUT reporting.  MAME bug upstream candidate: ravn/mame#13.
- **SW1 bit allocation** (all firmware components honor consistently): bit 0 (S01) console mode (rcbios + cpnos); bit 1 (S02) PROM1 lineprog enable (autoload); bit 2 (S03) CP/NET transport PIO/SIO (cpnos PROM1-only AND rcbios SNIOS).  Canonical doc: `rc700-gensmedet/docs/SW1_BIT_MAP.md`.  Migration note: post-73k SNIOS.SPR with default DIPs (S03 = On = 0) routes to PIO — SIO users must flip S03 to Off.
- IX/IY: reserved by default (un-reserve gated on regalloc cost-model work, #38).  #189/#27/#112 byte-decompose leaks FIXED (session 73ab): `getLargestLegalSuperClass` GR16NoIR gate + `Z80NarrowNoIndex` pre-RA pass eliminate undocumented IYH/IYL emission and the #189 miscompile under `-z80-unreserve-iy`; production byte-identical.  Residual Class C (`push/pop iy` density in wide-int/float) = cost-model tradeoff, not a blocker.  See `llvm-z80/tasks/issue112-189-iy-leak-taxonomy-2026-05-25.md`.  **Un-reserving IY is now worth ~0 on production (re-measured 2026-07-14, measure-all.sh clang 96394df: baseline vs `-z80-unreserve-iy` = BIOS 0, autoload -1 B, cpnos 0, AES -Oz 0, AES -O2 -123 B only).  The tiered #23 cost model + backend gains absorbed the old BIOS-23/autoload-11/cpnos-10/AES-145 win.  A GR16->cheap/index cost-tier split (#23 Phase 2) is therefore NOT data-justified and is PARKED — see `llvm-z80/tasks/plan-z80-cost-model-refinement-2026-06-08.md`.**
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

**Upstream filing queue (4 items staged for llvm/llvm-project):** `llvm-z80/tasks/upstream-filing-queue.md` — #224 (LiveVariables implicit-def, ready), #226 (TTI RFC, ready), #219 (TruncInstCombine, needs user intro), #225 (deleteDeadLoop, needs framing). All require per-filing go-ahead per `feedback_explain_before_filing`.

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

Clang BIOS = **5462 B** (2026-06-15), SDCC BIOS = 6091 B (clang **−629 B** overall, ~10.3% smaller).
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

**GCC builtins operate on 16-bit `int` here — never assume 32-bit.** On z80/z88dk
`int` is 16-bit, so `__builtin_clz`/`ctz`/`popcount`/`ffs` count over **16 bits**
(verified: `--target=z80 -S` ends `ld hl,16; sbc hl,de`), and `__builtin_*_overflow`
/ `__builtin_bswap` follow the 16-bit `int` width. Before relying on a width-sensitive
builtin in runtime/library code — or enabling a config flag that routes to one (e.g.
`-DSOFTFLOAT_BUILTIN_CLZ`) — verify the actual operand width in emitted asm. This exact
trap caused ravn/llvm-z80#273: `-DSOFTFLOAT_BUILTIN_CLZ` made `countLeadingZeros32`
a 16-bit count (off by 16), corrupting every `(double)int`. Fix (2026-07-21) was to
**width-match the builtin** in `opts-GCC.h` (`__builtin_clzl` for the 32-bit clz,
`__builtin_clz` for 16-bit, `__builtin_clzll` for 64-bit) + a `_Static_assert` on the
widths — NOT a backend change. (Dropping the flag entirely would pull the portable
`s_countLeadingZeros8.c`, whose 256-byte `.ascii` table the z88dk z80asm stage can't
parse, so keeping the flag with corrected defs is the working fix.) Corollary for
verification: a runtime closure is not verified until every public entry point runs at
least once AND its result is observed **losslessly** — the *sole* user of an internal
helper is the trap (int→double was the only user of `countLeadingZeros32`, and the one
test that touched it observed via a lossy `(long)` cast that hid the 2¹⁶ error;
arithmetic-only + truncating tests both missed it).

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
- **`(double)int` (`__floatsidf`) "miscompile" was NOT a backend bug** — ravn/llvm-z80#273.
  FIXED 2026-07-21. Root cause was our SoftFloat config, not clang-z80: `opts-GCC.h`
  under `-DSOFTFLOAT_BUILTIN_CLZ` defined `softfloat_countLeadingZeros32 =
  __builtin_clz`, but clang-z80 `int` is 16-bit so `__builtin_clz` counts 16 bits →
  `i32_to_f64` shiftDist 16 too small → `(double)5` → `131074.5`. The original
  "backend" diagnosis was misled by a host cross-check that used the same flag but,
  on a 32-bit-int host, `__builtin_clz` is a correct 32-bit clz (false exoneration).
  Fix = width-match the builtin (`__builtin_clzl` for the 32-bit clz) in
  `llvmz80-softfloat/vendor/.../opts-GCC.h` + `_Static_assert` on the widths. New
  int→double oracle `tests/ft_i2d.c`+`i2d_run.sh` (wired into `tests/run.sh`) — the
  old `ft_dbl` observed `__floatsidf` only through a lossy `(long)` cast and missed
  it. Full writeup: `llvmz80-softfloat/bugs/f64_int_to_double_miscompiled.{c,md}`.
  ravn/llvm-z80#273 to be closed as not-a-compiler-bug.
- **Textual `-S` emitted out-of-range `jr cc`** (FIXED 2026-07-20). BranchRelaxation
  under-counted function size because the variable-shift pseudos
  (`SHL8/16_VAR`, `LSHR8/16_VAR`, `ASHR8/16_VAR`, `ROTL8_VAR`, `ROTR8_VAR`) are
  `Z80Pseudo` (isPseudo=1) and hit `if (isPseudo) return 0` in
  `Z80InstrInfo::getInstSizeInBytes` — they actually expand (post-BranchRelaxation,
  in `Z80ExpandPseudo::expandVarShift`) to 7–11 B loops. The under-count left
  a `jr` really out of ±127 range; the object emitter silently relaxed it to
  `jp` but textual `.s` did not, and external z88dk z80asm rejected it. Fix: give
  the 8 VAR-shift pseudos their real expanded sizes in the IsSM83 size switch
  (Z80InstrInfo.cpp; same class as #266). Lit test
  `issue-267-jr-out-of-range-textual.ll` (XFAIL removed; asserts the 4 far
  branches are `jp`). Repro `llvmz80-softfloat/bugs/jr_out_of_range.c`.
  Filed: ravn/llvm-z80#267. **Systemic follow-up (FIXED 2026-07-21):** all ~14
  expanding `Z80Pseudo`s that were still sized 0 (guarded LDIR/LDDR/MEMSET,
  LOAD/STORE_IDX8, MUL8, S/U DIV8/MOD8, S/U ADD/SUBSAT8) now carry their real
  IsSM83-aware expanded sizes in getInstSizeInBytes AND are registered in
  `isInlineRuntimeSizedPseudo` so the #240 drift guard
  (`-z80-verify-inline-runtime-size`) validates them. New lit test
  `issue-267-pseudo-size-drift-guard.ll` (+ verify RUN lines added to
  `issue-27-iy-indexed-addr.ll` and `issue-105-ldir-guarded.ll`). See
  `tasks/memory/issue267_pseudo_undersize_class.md`.
  **Separate root cause of the fmt64@-O2 failure (FIXED 2026-07-21):** it was NOT
  a backend undercount but our own z88dk bridge `z88dk/lib/llvmz80/
  bridge_postproc.sh`, which had a perl workaround rewriting every conditional
  `jr cc`→`jp cc` (2B→3B). That +1B/site inflation ran AFTER clang's
  BranchRelaxation and grew the span of an enclosing unconditional `jr` clang had
  correctly left at ≤127B, tipping fmt64.c to 128 ($80). clang's Z80 backend
  already relaxes conditional jr itself, so the rewrite was redundant AND harmful;
  it was removed. The softfloat closure now builds clean at -O2 (the -O0
  `s_roundPackToF64` / -Os `fmt64.c` workarounds were removed) and #273's lossless
  int→double oracle (`tests/ft_i2d.c`) is GREEN at -O2.

FIXED (earlier):
- **sret return copied to wrong dest when value comes from an sret-returning
  call** — a function returning `double`/struct via sret whose return value is
  produced by another sret-returning call copied the callee's result to the
  first-arg slot `[ix+6]` instead of the sret pointer `[ix+4]` (with a=3.0 →
  write to 0x0000 warm-boot vector → hang). Fixed in `cf6c78afd775` ("Fix
  sret/arg frame offset by CSR in static-stack+FP"); `_f` now uses `ld
  l,(ix+4)` after `call _g`. Verified + issue closed 2026-07-20. Repro
  `llvmz80-softfloat/bugs/sret_dest_from_sret_call.c`. Filed: ravn/llvm-z80#268
  (CLOSED).
- **sret setup skipped for no-arg functions returning > 4 bytes** — a no-arg
  function returning `double`/`i64`/large struct never set up its hidden sret
  pointer (`Z80CallLowering::lowerFormalArguments` early-returned before the
  sret-demotion block) → legalizer crash / corrupt sret. Fix: also require
  `FLI.CanLowerReturn` in the early-return guard. Commit `74378e7a78cc`, lit test
  `llvm/test/CodeGen/Z80/sret-noarg-return.ll` (passes). Writeup:
  `llvmz80-softfloat/bugs/sret_noarg_return_FIXED.md`. Verified + issue closed
  2026-07-20. Filed: ravn/llvm-z80#274 (CLOSED).
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

## z88dk `+cpm -compiler=llvmz80` C standard-library status (survey 2026-07-17)

Making clang-z80 a first-class external z88dk backend. CP/M stdlib surface is
**largely complete and verified** (compiled + run under ntvcm/MAME); the bridge
layer lives in `z88dk/libsrc/l/llvmz80/` (ABI reference:
`CALLING_CONVENTION.md`).

**Works (bridged + tested):** `string.h` (str*/mem*), `ctype`, `stdlib`
(atoi/itoa/ltoa/strtol/strtoul/qsort/abs/labs/rand/getenv/setenv/getopt),
`malloc`/`calloc`/`realloc`/`free`, and the full `stdio` **FILE\*** layer
(fopen/fread/fwrite/fgets/fputs/fseek…, 16/16 MAME). Non-variadic classic-clib
calls convert the HL→DE 16-bit-return mismatch via the `__ZPROTO` bridges
(they end `ex de,hl / ret`).

**`double` runtime:** clang lowers `double` to compiler-rt soft-float libcalls
that z88dk's classic clib lacks (its floats are 48-bit math48 / MBF). The
Berkeley-SoftFloat closure is packaged as `softfloat_cpm_z80.lib`
(reproducible target `llvmz80-softfloat/tools/build_softfloat_lib.sh`) and
**auto-linked** by zcc when the config/env var **`LLVMZ80RTLIB`** points at it
(full path, no `.lib` suffix; env wins, like `LLVMZ80EXE`). It ships WITH the
clang binary (compiler-rt model), not inside z88dk. Being a `.lib` archive, an
integer-only program links byte-identically whether or not it is set.

**Known gaps / bugs (see also "Known Bugs in llvm-z80" above):**
- **Variadic stdio return value is garbage** (`printf`/`fprintf`/`sprintf`/
  `snprintf`/`scanf`/`fscanf`/`sscanf`). Output/parse are correct but the
  returned count is wrong (e.g. `sscanf(...)`→ -362 want 3). Root cause
  (verified from source + a control): the classic clib sdcc entry points return
  the int in **HL**, clang `sdcccall(1)` reads **DE**, and the printf family is
  NOT bridged (for clang `__vasmallc` is empty), so no `ex de,hl`. Fix needs a
  return-address-interposing trampoline, not a plain `__ZPROTO` bridge.
  Filed **ravn/z88dk#31**; writeup in `CALLING_CONVENTION.md` ("KNOWN GAP").
- **`(double)int` (`__floatsidf`)** — FIXED 2026-07-21 (ravn/llvm-z80#273 was
  mis-filed as a backend bug; real cause was our SoftFloat clz-width config, see
  "Known Bugs in llvm-z80" above). int→double now works at all opt levels.
- **`printf("%f")`** needs the separate nanoprintf closure (`build_fmt.sh`);
  z88dk's variadic `printf` cannot format `double` here.
- **`va_start`/`va_arg` in user variadic functions** — **FIXED** (ravn/z88dk `bb914a18`,
  2026-07-21): z88dk `<stdarg.h>` now defers to `__builtin_va_start` under
  `__LLVMZ80`; `vsum(3,10,20,30)=60` verified. ravn/llvm-z80#270 CLOSED.
- **POSIX fd-layer** (open/creat/read/write/close/lseek) resolves to no-op
  dummy stubs on classic `+cpm` for ALL compilers — by design, not a gap; real
  CP/M file I/O is the FILE\* layer.

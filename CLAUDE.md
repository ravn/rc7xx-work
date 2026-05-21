# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Goal

Optimize the Z80 backend of ravn/llvm-z80 (a GlobalISel-based LLVM fork) to match or beat SDCC code density. Test against RC700 PROM and BIOS sources in rc700-gensmedet.

## Current Sizes (2026-05-22, post-session-73p Phase 2: #177 partial ship + #184 filed)

**Phase 1 milestone:** AES corpus `09_Oz_prod_like` flipped from clang +23 % slower / −20 % smaller to **clang −11 % faster / −23 % smaller** vs SDCC.  All 13 AES configs now faster than SDCC (4.8–11 %); 4 of 13 also smaller.  Three codegen fixes landed: `#179 P1` (DEC+OR→SUB+JR_C reorder), `#179 P2` (ADD_A_A carry forwarding), and `#128` (LICM/CSE disable).  See `llvm-z80/tasks/session73p-phase1-summary.md`.

**Phase 2 outcome:** Two branches merged to main.

(a) `session-73p-phase2-issue177` (`541b687bbecc`): TTI hooks (Mul→Expensive, getCastInstrCost trunc/zext free + sext=2, prefersVectorizedAddressing=false).  Phase B bundle's i16=2 case filed as **ravn/llvm-z80#184**.

(b) `session-73p-issue173`: Z80LateOpt peephole for bare-store + 4-instr A-preserving reload → PUSH/POP rr.  Two-phase stack tracking handles nested matched-reload inside across-CALL push/pop brackets.

Production delta from Phase 2: cpnos PROM1 **2030 → 2028 B (−2 B; 20 B free under 2 KB cap)**.  AES `09_Oz_prod_like` **2574 → 2562 B (−12 B, ts −0.11%)**.  AES corpus 13/13 PASS, lit 106+3, wider oracle byte-identical, cpnos polypascal-test PASS at 51.11 s.



- autoload PROM (clang, ZX0-compressed): **1667 B / 2048 B (381 B free)** — unchanged through 73m.  Banner: `RC700 ROA375 CL <date> <hash>/<user>`.  Hard-capped at 2 KB (no A11 bridge on user's hardware -- memory rule `project_rc702_2kb_prom_hard_limit`).
- BIOS: clang **5925 B** vs SDCC **6091 B** (clang −166 B); SW1 bit-0 inversion fix landed (was bit=1 → JOINED; now bit=0 → JOINED matching MAME's "On" convention).
- cpnos-in-c resident (clang, PIO transport): **clang 2004 B / SDCC 2120 B** raw .payload non-padding (SDCC was 2196 B pre-session-73k; -76 B from the `__sfr __at` port-IO rewrite, commit `754b901`, closes ravn/z88dk#9).
- **cpnos-in-c PROM1-only line program (session 73m snapshot)**: BOTH clang and SDCC build, boot, pass `cpnos-polypascal-test`.
    * **clang × {PIO+SIO} dual:** **2028 B / 2048 B (20 B free)** at HEAD post-session-73p Phase 2 (TTI hooks + #173 peephole; -2 B vs 2030 B post-#168 baseline).  Production target.  polypascal-test PASS **51.11 s** (verified post #173 ship).
    * **SDCC × {PIO+SIO} dual:** **2151 B** / 4 KB padded (was 2207 B pre-session-73l-fix; -56 B / -2.5% from the K&R REGPARM-preserve patch applied to the local z88dk's zsdcc — shrinkage is from z88dk runtime library K&R functions, not cpnos source which is ANSI).  Needs PROMCFG=2 (2732 4 KB) in MAME.  polypascal-test PASS **49.09 s** (was 49.67 s).
    Build: `cd cpnos-in-c && make prom1-lineprog COMPILER={clang,sdcc}`.  Both paths share init.c / resident.c source; compiler-specific cold-init via bootstrap.s (clang asm) vs bootstrap.asm (SDCC asm).  Includes: pre-fill identity outcon + sentinel arm consolidated into `cpnos_cold_entry()` (portable C); locale tables (US-ASCII outcon from CONFI.COM + Danish inconv) installed from cpnos.img 384 B prefix at handoff.
- **rcbios CP/NET SNIOS dual SIO+PIO (session 73k)**: `cpnet/snios.asm` gains a PIO transport mirroring cpnos's `transport_pio.c`.  Self-modifying 3-byte JP-trampoline dispatch in NTWKIN reads SW1 bit 2 once and patches SENDBY/RECVBY/RECVBT in place.  PIO impl: direct Mode 1 input + IRQ-driven 256 B SPSC ring at IVT slot 17.  SNIOS code 673 → 1149 B; SPR file 1024 → 1664 B (12 sectors).  Both rcbios BIOS variants verified end-to-end via `cpnet/polypascal_pio_test.sh` — clang **10.50 s**, SDCC **10.71 s** (CPNETLDR → LOGIN → NETWORK H:=A: → H: → PPAS load from master via CP/NET PIO → PRIMES through 29989 → Q → H>).
- **impl_conout hot path** (late session 73j): branch chain reordered to `xflg / c>=0x20 / CR / LF / specc`.  Printable hot path drops from 5 tests to 2; measured ~15 us/char (~60 T-states) saved on PRIMES output stream.
- **SDCC autoload build unblocked** (session 73j late): copt-rules path fix + per-compiler size policy (clang 2 KB hard / SDCC 4 KB MAME-only).
- **PROM budget watch**: cpnos PROM1 at 18 B free (2030 / 2048 B unchanged through Phase 1).  cpnos doesn't have the gf_log/gf_alog patterns #179 targets, so the AES wins don't flow to cpnos.  Next compiler shrink lever queued: #173 (8-bit BSS spill peephole, ~3-4 h work, estimated 5-10 B cpnos shrink).
- **MAME `rc702sem702` machine**: clone of `rc702` 8" with SEM702 RAM-backed chargen (2 KB RAM behind ports 0xD1/0xD2/0xD3, strict-latch model, ROA296 still serves alpha).  Use for SEM702-equipped-machine emulation; baseline `rc702` keeps ROA327.
- **SW1 bit allocation** (all firmware components honor consistently): bit 0 (S01) console mode (rcbios + cpnos); bit 1 (S02) PROM1 lineprog enable (autoload); bit 2 (S03) **CP/NET transport PIO/SIO** — applies to BOTH cpnos PROM1-only AND rcbios SNIOS (extended 2026-05-19, session 73k).  Canonical doc: `rc700-gensmedet/docs/SW1_BIT_MAP.md`.  Migration note: pre-73k rcbios SNIOS ignored bit 2 (SIO-only); post-73k SNIOS.SPR with default DIPs (bit 2 = On = 0) routes to PIO transport — SIO users must flip S03 to Off.
- AES-256 corpus (rc700-gensmedet/tasks/aes256-corpus): `09_Oz_prod_like` clang **2574 B / 10.75 M ts** vs zsdcc 3323 B / 12.08 M ts (clang −22 % size, **−11 % faster** on production target).  `01_baseline_Oz` clang **3703 B** (post-#128 LICM/CSE disable, −281 B vs Phase-0).  All 13 configs PASS verifier; all 13 faster than SDCC by 4.8–11 %.  See `llvm-z80/tasks/session73p-phase1-summary.md`.
- cpnos-in-c 4-cell test matrix (compiler × transport): cpnos-polypascal-test PASS at HEAD (clang two-PROM; sole tested path).  Two-PROM now PARKED -- see `cpnos-in-c/tasks/TWO_PROM_PARKED.md`.
- **Two-PROM build PARKED 2026-05-17** (user direction: "it is only the autoload+cpnos scenario that interests").  Sole production topology: autoload-in-c (ROA375) in PROM 0 + cpnos-in-c PROM1-only line program in PROM 1.  SDCC two-PROM is link-broken (`_get_img_base` undefined in sdcc/init.o) -- not fixing, parked.
- **MAME rc702 driver col-80 fix** (ravn/mame@035d29086bf): `set_size(560, ...)` so 80 cols × 7 px = 560 visible pixels.  Was clipping rightmost ~2 chars on every row.  Affects both live MAME view and `-aviwrite` captures.  Build with `make OSD=sdl SOURCES=src/mame/regnecentralen/rc702.cpp REGENIE=1`.
- **MAME video-capture pipeline** (`scripts/mame_capture.sh`): every MAME launch -aviwrite -> docker ffmpeg h264 MP4 (pad 904×590 with rgb(0xC0,0x60,0x00) bezel) -> `scratch/mame-videos/`, prune to last 50.  Typical 50-s run = ~160 KB.
- IX/IY: reserved (un-reserve gated on Phase 3 regalloc cost-model work, see #38)
- Z80 lit suite: **106 PASS + 3 XFAIL (109 total)**, CI green
- **cpnos-in-asm: PARKED 2026-05-17** (superseded by cpnos-in-c PROM1-only)
- **sem702-qr-test**: new subproject `rc700-gensmedet/sem702-qr-test/` -- CP/M .COM that paints two QR codes (1× + 2× scale) of `https://github.com/ravn` side-by-side via SEM702 sextants, snapshot-verified in MAME (`make run`).
- **cpnos-in-asm: PARKED 2026-05-17** (see `rc700-gensmedet/cpnos-in-asm/PARKED.md`).  Superseded by cpnos-in-c PROM1-only.  Last functional state: 1566 / 2048 B PROM1, PolyPascal + CONOTEST PASS, 15 of 18 RC700 text-mode CONOUT codes (graphics-mode 0x14/0x15/0x16 missing on both variants).  Source tree preserved; new feature work goes into cpnos-in-c.
- AES-256 corpus (rc700-gensmedet/tasks/aes256-corpus): `09_Oz_prod_like` clang **2574 B / 10.75 M ts** vs zsdcc 3323 B / 12.08 M ts (clang −22 % size, **−11 % faster** on production target).  `01_baseline_Oz` clang **3703 B** (post-#128 LICM/CSE disable, −281 B vs Phase-0).  All 13 configs PASS verifier; all 13 faster than SDCC by 4.8–11 %.  See `llvm-z80/tasks/session73p-phase1-summary.md`.
- cpnos-in-c 4-cell test matrix (compiler × transport): all PASS at HEAD
- IX/IY: reserved (un-reserve gated on Phase 3 regalloc cost-model work, see #38)
- Z80 lit suite: **106 PASS + 3 XFAIL (109 total)**, CI green

## Canonical Plan

Master: `llvm-z80/tasks/roadmap-to-maturity.md` (session 36).
Current overlay: `llvm-z80/tasks/plan-2026-05-03-structural.md` (session 42).
Strategic frame: bring `llvm-z80/llvm-z80` (active fork-of-record, owner @zlfn) to maturity collaboratively; eventual official LLVM upstream is long-term aspiration. Workspace mode → engagement mode (gated on substantial body of work).

**Phase status (session 42):** Phase 1 Foundation **DONE**; Phase 2 Correctness sweep **DONE** (#28, #36, #63, #81 fixed; #38 reclassified to Phase 3); Phase 3 Cluster A regalloc 3 of 5 closed (#94, #98, #99); #89 + #27 remain as multi-session investigations expected to subsume #38. Engagement-mode gate is **one cluster away**.

## Session History

Detailed session-by-session log lives in `rc700-gensmedet/tasks/timeline.md`. Per-session summaries in `llvm-z80/tasks/session*-summary.md` and `rc700-gensmedet/cpnos-rom/tasks/`. Most-recent sessions:

- **#73p Phase 1 (2026-05-21, clang DOMINATES SDCC on AES)** — Three codegen fixes landed: (1) **#179 P1** new `Z80ReorderTestDec` pre-RA MIR pass rewrites the post-ISel `LD_A_R; DEC_A; LD_<r2>_A; LD_A_R; OR_A; JR_Z` redundant-reload pattern to `LD_A_R; SUB_n 1; LD_<r2>_A; JR_C` (commit `4f5562c99228`).  AES 09_Oz_prod_like −5.1 % tstates.  (2) **#179 P2** extends same pass for `ADD_A_A; LD_<r2>_A; LD_A_R; RLCA; JR_C/NC` bit-7 test pattern, dropping the redundant `LD_A_R; RLCA` (commit `6820930cc156`).  **Additional −23.9 % AES tstates — this is where production target flipped to dominate SDCC.**  (3) **#128 closed** by `Z80PassConfig` disablePass(EarlyMachineLICMID + MachineLICMID + MachineCSELegacyID) globally (commit `7d5b4e5ea86c`).  Default `-Oz` −281 B AES.  AES `09_Oz_prod_like`: 14 887 472 → 10 749 186 ts (−27.8 %); 2667 → 2574 B (−93 B).  **vs SDCC: clang now −11 % faster AND −23 % smaller.**  All 13 configs PASS verifier; all 13 faster than SDCC by 4.8–11 %.  Decision E full oracle preserved: lit 106+3, AES 13/13, test-runner 681/46/56/207 baseline, cpnos PROM1 byte-identical.  New wider-oracle corpus `rc700-gensmedet/tasks/compiler-comparison-corpus/` (sieve/fannkuch/pi, mirrors AES corpus pattern); surfaced #182 (LLVM ScalarEvolution crash) within minutes of building.  Issues filed Phase 1: #173, #174 (closed), #175, #176, #177, #178, #179 (closed), #180, #181, #182, #183, plus ravn/z88dk#16, #17.  Closed by Phase 1 work: #128, #145, #167, #174, #179.  See `llvm-z80/tasks/session73p-phase1-summary.md`.
- **#73p Phase 0 (2026-05-21, three documented dead-ends + #173 filed)** — Three drills, each landing as honest negative results: (1) **#172 A-pin** scope tightened to per-MBB single-candidate; segfault from 73o gone, pin=on still net negative (+24-81 B); default stays OFF (commit `862321520547`, merged via `cd7bdf7e3a3a`).  (2) **#166 ADD_HL_rr remat** ruled impossible — pseudo has no SSA output (HL implicit physreg def), `isReMaterializable` silently ignored; AES corpus byte-identical with the flag set (commit `34b1732266c4`).  (3) **#166 ADD16_tied wire-up at G_PTR_ADD** two routes both miscompile — `$dst` GR16 hits a BC/DE-fallback HL clobber undeclared, `$dst` HLI (fallback removed) still produces a 173/990 test-runner FAIL via unisolated tied-operand regalloc bug; both routes reverted with in-place diagnosis comment (commit `8400050dd2bf`).  New issue **ravn/llvm-z80#173** filed: 8-bit BSS spill via A is 6 B per cycle (`push af; ld a,r; ld (nn),a; pop af`); PUSH/POP-rr peephole + mixed-mode BSS estimated 100-200 B AES yield, highest-yield open lever.  Net codegen change zero; value oracle preserved (lit 104+3, AES 13/13, test-runner baseline).  See `llvm-z80/tasks/session73p-summary.md`.
- **#73o (2026-05-21, #172 filed + structural pass landed default-off)** — Drilled the 8-bit ALU accumulator A-shuttle, the dominant residual SDCC speed gap on AES (~5 pp of the 18.9 % gap).  Hint attempt via `getRegAllocationHints` fires correctly but greedy regalloc ignores it (confirms the existing `Z80RegisterInfo.cpp:1891` note that hints don't move greedy on this path).  Structural attempt: new `AReg` single-register class + new pre-RA `Z80PinAluAccumulator` pass mirroring `Z80SplitDjnzCounters`.  Works in isolation (`gf_alog_mini` XOR chain pinned in A) but pins too aggressively without interference checks -- AES `05_Oz_static_stack` segfaults during regalloc, `01_baseline_Oz` regresses +261 B / +3.8 % ts.  Default OFF.  Filed **ravn/llvm-z80#172** with the MIR pattern, the negative hint result, and four fix paths.  Commit `2c4627c80ef1` lands the infrastructure (AReg class + pass + pipeline hook); default-on flip needs a liveness-aware selector (MachineLoopInfo + LiveIntervals + PHI chain walk).  See `llvm-z80/tasks/session73o-issue172-a-pin.md`.
- **#73n (2026-05-21, #77 fix path 1 lands)** — `Z80NarrowIV` IR pass narrows i16 loop counters to i8 when SCEV proves range fits in [0, 255].  Targets the dominant AES inner-loop shape `register uint8_t i = 16; while (i--) buf[i] = f(buf[i])` where SROA widens the counter to i16 because `buf[i]` needs an i16 GEP index.  Two conservative guards: legacy-PM placement AFTER `TargetPassConfig::addIRPasses` (LSR runs first, narrows second) and single-phi-header gate (skip when loop header has > 1 phi).  Default ON, commit `bbcc6f6047c3` (merge to main).  AES 13/13 PASS; `09_Oz_prod_like` **−12 B**, `07_Oz_no_lsr` **−148 B / −0.84 % tstates**, `10_Oz_no_licm_cse_lsr` **−22 B**, others unchanged.  Production tstate regression check: 09_prod_like +0.04 % (noise band), no real regressions.  Three open issues stay as fix-later trackers: **#169** (LSR + backend miscompile, worked around by after-LSR placement), **#170** (test_94 parallel-phi silent miscompile, worked around by single-phi guard), **#171** (test_96 IY-spill timeout, same guard).  See `llvm-z80/tasks/session73n-issue77-peephole-investigation.md`.
- **#73m (2026-05-21, #168 CLOSED, #167 logically closed)** — SimplifyCFG `foldTwoEntryPHINode` cost-gated bailout (`Cost > TCC_Free` when `getPredictableBranchThreshold().isZero()`).  12 lines, commit `cd2a2ace8754`.  AES 09_Oz_prod_like clang 2695 → **2679 B** (−16 B), tstates 15.05M → 14.88M (−1.1%).  cpnos clang PROM1 2025 → **2030 B** (18 B free under 2 KB hard cap).  Every `xor 27` in AES hot paths now branched.  **Are clang as fast as SDCC?** No — still −19% (clang 14.88M vs SDCC 12.08M ts); residual gap is regalloc A-register churn, not pattern recognition.  Per-iter decomposition posted on #167.  Also: `Z80LoopRotate` CALL-skip + min-trip-count(≥8) guards (commit `5118ca7b97b7`); attempted default-on flip but AES `01_baseline_Oz` regressed +11% ts (size recovered, speed didn't, root cause not isolated).  Default stays off; cleaner alternative for #77 is a post-RA peephole, comment posted on #77.  `experiment-cpnos-prom-4k` merged back to main, `CPNOS_PROM1_CAP` reverted to 2048 B.  See `llvm-z80/tasks/session73m-summary.md`.
- **#73e (2026-05-15..16)** — cpnos-in-asm phases 1..3d-γ end-to-end.  Pure Z80 asm CP/NOS slave boots through autoload's PROM1 signature, brings up display+SIO, emits a full CP/NET 1.2 INIT frame on SIO-A with ENQ/wait-ACK handshake, parses master-initiated frames via recv_cpnet_frame (HCS+CKS validated, ACK/NAK per spec).  5 of 5 MAME oracles green; bidirectional exchange against a Python fake master passes 6/6 ACKs.  Three deep bugs caught + fixed during the run: mid-frame DMA reprogram needing 8275 STOP/PRESET/START to resync to row 0; non-blinking block cursor needing P4 bits 5-4 = 10 (not 4-3 as I first assumed -- MAME's i8275 reads bits 5-4); rx_frame_buf at 0x2800 was in MAME's bank2h PROM-mirror region, NOT plain RAM -- moved to 0x3000 and writes started sticking.  Memory rules `feedback_rc702_bank2h_mirror.md` + `feedback_zmac_local_label_scope.md` filed.  Five follow-on tasks queued (#67..#71).  PROM1 at 550 / 2048 B (1498 B free); autoload PROM0 at 1846 / 2048 B (202 B free).  See `rc700-gensmedet/tasks/timeline.md` "Session 73e".
- **#73b/c (2026-05-15)** — llvm-z80 **#115/#27 S3'** committed (`006ba9607dd1`): `INC16` / `DEC16` marked `isAsCheapAsAMove` + `isReMaterializable`.  AES corpus 8 of 13 configs improved (−25 to −118 B); production targets (autoload, cpnos, BIOS) byte-neutral.  Lit 104+2, test-runner 685/42/56/207, AES verifier all PASS.  Follow-up #166 (ADD_HL_rr / LD_HL_a16 remat) filed.  Build infrastructure: `tasks/tools/llvm-snap.sh` snapshot helper + sccache wired into cmake (2.9–6.5× faster iteration on backend-pass changes).  See `tasks/session73b-s3prime-prod-impact-analysis.md`.
- **#73 (2026-05-15, #165 CLOSED)** — TruncInstCombine outside-user allowlist extended: icmp non-const + and-mask paths.  gf_log 153 → 28 B (−125 / 5.4×); AES corpus all 13 configs improved (−26 to −129 B); tstates 65M → 15M (4×).  See `tasks/session73-truncinstcombine-outside-user-extensions.md`.
- **#57 (2026-05-10, #75 CLOSED)** — Plain-C SNDMSG/RCVMSG state machines landed. Final 6 phases of #75: 17 SNIOS functions in `snios_c.c`; asm reduced to 24 B JT + 2× 5 B BC→HL bridges. Mid-frame busy-wait deviation FIXED in C (timeout-bearing recv per DRI). +426 B clang / +306 B SDCC; fits in 2K PROMs after single-line `payload.ld` SCRATCH relocation (0xF500→0xEB00). 4-cell polypascal-test all PASS at parity. Filed #82 (ZX0 compression, parked) + #83 (IX-frame refactor, parked). Branch `phase-5-6-test-config` merged --no-ff (commit `fe609fc`).
- **#56 (2026-05-10)** — `cpnos-rom/CPNET_WIRE_PROTOCOL.md` authored: authoritative wire-protocol spec cross-checked against z80pack mpm-net2 master `netwrkif-0.asm`, DRI reference, and current slave. Surfaced one slave deviation (mid-frame busy-wait) and clarified FNC=0xFF / 0xFE proxy-only handling. Recorded CP/NOS-is-diskless invariant after user clarification.
- **#48-55 (2026-05-09 → 10)** — cpnos-rom SDCC port + shrink: bring-up complete (Phase 48 cfgtbl bug found), TRANSPORT=sio validated (#66), cold-init→PROM-only (Phase 50, −577 B), SDCC resident shrink 2756→1874 B over 51A-D (multiple ifdef collapses, structural fixes), clang silent miscompile from `__builtin_memcpy` through NULL pointer caught + fixed (#81). SNIOS asm→C migration phases 1-4 (15 functions ported byte-neutrally before #75 Phase 5+6 above).
- **#47 (2026-05-06/07)** — cpnos-rom data-driven relocator (header-prefixed payload). Replaced four-way `--defsym` coupling with linker-emitted `__payload_header`.
- **#42 (2026-05-03)** — llvm-z80 Phase 2 admin pass; #89 two paths ruled out; #120 combiner migration ruled out (peephole #26 stays).

For older sessions (#12-#46), see `rc700-gensmedet/tasks/timeline.md`.

## Workspace Layout (`/Users/ravn/z80/`)

Everything lives under one folder:
- `llvm-z80/` — LLVM/clang fork with Z80 backend (shallow clone of github.com/ravn/llvm-z80)
- `rc700-gensmedet/` — RC700 CP/M system sources (github.com/ravn/rc700-gensmedet)
  - `autoload-in-c/` — Primary test case: ROA375 boot PROM in C (priority 1)
  - `rcbios-in-c/` — Secondary test case: CP/M BIOS in C (priority 2)
  - `cpnos-rom/` — CP/NOS slave PROM (dual-compile clang+SDCC; primary current testbed)
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

## Code Density Gap Analysis (BIOS, remeasured 2026-05-02)

Clang BIOS = **5920 B**, SDCC BIOS = 6123 B (clang **−203 B** overall).
Per-function profile shows where remaining shrink budget hides:

| Cause                                | Impact                    | Status                                   |
| ------------------------------------ | ------------------------- | ---------------------------------------- |
| 1. BSS load/store traffic            | 30–48% of large functions | **dominant**; #20, #15, #100 open        |
| 2. Excess reg-to-reg moves (regalloc) | 22–58 per large fn        | #94 / #98 / #89 / #95 cluster open       |
| 3. Flag re-derivation (`or a`, `cp`) | 5–15 per large fn         | #77 open; #93, #86 closed                |
| 4. IX frame overhead                 | ~0 B (`+static-stack`)    | **obsolete on BIOS**; #12, #40 small     |
| 5. IY prefix overhead                | ~0 B (IY reserved)        | **obsolete**; #38 gates re-enabling      |
| 6. 8→16 bit promotion                | residual / case-by-case   | mostly closed (#86, narrow-via-zext)     |

Largest clang BIOS functions: `_specc` 676 B (208 BSS), `_bios_hw_init` 341 B, `_rwoper` 263 B (105 BSS), `_bg_clear_from` 262 B, `_sec_rw` 247 B, `_bios_seldsk_c` 199 B (66 BSS), `_bios_write_c` 170 B, `_isr_crt` 166 B (80 BSS, highest density), `_xyadd` 149 B (64 BSS), `_chktrk` 136 B.

cpnos-rom hot functions (`_netboot_mpm` 224 B, `_relocate` 115 B, `_impl_conout` 87 B) carry less state and are close to optimum.

Conclusion: **BSS spill traffic + regalloc churn** account for almost all remaining clang bloat in BIOS. Historical IX/IY-overhead and 8→16 promotion items are no longer active gaps; #38 (IY un-reserve) and #12/#40 (IX as frame ptr) are parked side issues.

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
- Native LLVM-Z80 clang at `llvm-z80/build-macos/bin/` (`make toolchain`)
- z88dk via Docker container (do not rebuild from source)
- CLion as IDE, command-line collaboration here
- MAME for hardware emulation testing
- Never create pull requests unless explicitly told to
- Always use `--no-ff` for git merges

## Workflow

- Record all user prompts in `tasks/prompts.md`
- Think out loud — show reasoning process
- All persistent notes stored in project (`tasks/`, `CLAUDE.md`), never in `~/.claude/`
- Plan in `tasks/todo.md`, lessons in `tasks/lessons.md`
- Never apologize. Be concise and accurate.
- Enter plan mode for non-trivial tasks. Re-plan if things go sideways.
- Verify changes work (tests, MAME boot) before marking done.
- **Whenever you modify the compiler, always add a lit test showing it works.**
  Add to existing relevant test file or create a new one in `llvm/test/CodeGen/Z80/`.

## Known Bugs in llvm-z80

- `"hl"` inline asm constraint crashes IRTranslator
- hasFP=false has runtime bug (parked)

## Working LLVM-Z80 features (use directly; no inline-asm workaround needed)

- `address_space(2)` for port I/O — fixed in `0ff2114c62a6` + `0d71a91b4e18`
  (ravn/llvm-z80 #1, #44).  `*(volatile __attribute__((address_space(2)))
  uint8_t *)0x10` lowers cleanly to `IN A,(0x10)` / `OUT (0x10),A`.

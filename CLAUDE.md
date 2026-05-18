# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Goal

Optimize the Z80 backend of ravn/llvm-z80 (a GlobalISel-based LLVM fork) to match or beat SDCC code density. Test against RC700 PROM and BIOS sources in rc700-gensmedet.

## Current Sizes (2026-05-19, post-session-73k: rcbios CP/NET PIO + cpnos __sfr port-IO + dual-compiler polypascal green)

- autoload PROM (clang, ZX0-compressed): **1667 B / 2048 B (381 B free)** — unchanged through 73k.  Banner: `RC700 ROA375 CL <date> <hash>/<user>`.  Hard-capped at 2 KB (no A11 bridge on user's hardware -- memory rule `project_rc702_2kb_prom_hard_limit`).
- BIOS: clang **5925 B** vs SDCC **6091 B** (clang −166 B); SW1 bit-0 inversion fix landed (was bit=1 → JOINED; now bit=0 → JOINED matching MAME's "On" convention).
- cpnos-in-c resident (clang, PIO transport): **clang 2004 B / SDCC 2120 B** raw .payload non-padding (SDCC was 2196 B pre-session-73k; -76 B from the `__sfr __at` port-IO rewrite, commit `754b901`, closes ravn/z88dk#9).
- **cpnos-in-c PROM1-only line program (session 73k snapshot)**: BOTH clang and SDCC build, boot, pass `cpnos-polypascal-test`.
    * **clang × {PIO+SIO} dual:** 2027 B / 2048 B (21 B free), fits a physical 2 KB PROM1 socket.  Production target.  polypascal-test PASS **51.33 s**.
    * **SDCC × {PIO+SIO} dual:** **2207 B** / 4 KB padded (was 2246 B pre-`__sfr`; -39 B post-ZX0).  Needs PROMCFG=2 (2732 4 KB) in MAME.  polypascal-test PASS **49.67 s**.
    Build: `cd cpnos-in-c && make prom1-lineprog COMPILER={clang,sdcc}`.  Both paths share init.c / resident.c source; compiler-specific cold-init via bootstrap.s (clang asm) vs bootstrap.asm (SDCC asm).  Includes: pre-fill identity outcon + sentinel arm consolidated into `cpnos_cold_entry()` (portable C); locale tables (US-ASCII outcon from CONFI.COM + Danish inconv) installed from cpnos.img 384 B prefix at handoff.
- **rcbios CP/NET SNIOS dual SIO+PIO (session 73k)**: `cpnet/snios.asm` gains a PIO transport mirroring cpnos's `transport_pio.c`.  Self-modifying 3-byte JP-trampoline dispatch in NTWKIN reads SW1 bit 2 once and patches SENDBY/RECVBY/RECVBT in place.  PIO impl: direct Mode 1 input + IRQ-driven 256 B SPSC ring at IVT slot 17.  SNIOS code 673 → 1149 B; SPR file 1024 → 1664 B (12 sectors).  Both rcbios BIOS variants verified end-to-end via `cpnet/polypascal_pio_test.sh` — clang **10.50 s**, SDCC **10.71 s** (CPNETLDR → LOGIN → NETWORK H:=A: → H: → PPAS load from master via CP/NET PIO → PRIMES through 29989 → Q → H>).
- **impl_conout hot path** (late session 73j): branch chain reordered to `xflg / c>=0x20 / CR / LF / specc`.  Printable hot path drops from 5 tests to 2; measured ~15 us/char (~60 T-states) saved on PRIMES output stream.
- **SDCC autoload build unblocked** (session 73j late): copt-rules path fix + per-compiler size policy (clang 2 KB hard / SDCC 4 KB MAME-only).
- **PROM budget watch**: PROM1 at 48 B free (improved from 30 B post-shrink-investigation branch).  Any further cpnos growth still tight -- 2 KB cap is hard.
- **MAME `rc702sem702` machine**: clone of `rc702` 8" with SEM702 RAM-backed chargen (2 KB RAM behind ports 0xD1/0xD2/0xD3, strict-latch model, ROA296 still serves alpha).  Use for SEM702-equipped-machine emulation; baseline `rc702` keeps ROA327.
- **SW1 bit allocation** (all firmware components honor consistently): bit 0 (S01) console mode (rcbios + cpnos); bit 1 (S02) PROM1 lineprog enable (autoload); bit 2 (S03) **CP/NET transport PIO/SIO** — applies to BOTH cpnos PROM1-only AND rcbios SNIOS (extended 2026-05-19, session 73k).  Canonical doc: `rc700-gensmedet/docs/SW1_BIT_MAP.md`.  Migration note: pre-73k rcbios SNIOS ignored bit 2 (SIO-only); post-73k SNIOS.SPR with default DIPs (bit 2 = On = 0) routes to PIO transport — SIO users must flip S03 to Off.
- AES-256 corpus (rc700-gensmedet/tasks/aes256-corpus): `09_Oz_prod_like` clang **2695 B** vs zsdcc 3604 B (clang ahead by 909 B); `01_baseline_Oz` clang 4111 B (post-S3' −94 B).  See `llvm-z80/tasks/session73b-s3prime-prod-impact-analysis.md`.
- cpnos-in-c 4-cell test matrix (compiler × transport): cpnos-polypascal-test PASS at HEAD (clang two-PROM; sole tested path).  Two-PROM now PARKED -- see `cpnos-in-c/tasks/TWO_PROM_PARKED.md`.
- **Two-PROM build PARKED 2026-05-17** (user direction: "it is only the autoload+cpnos scenario that interests").  Sole production topology: autoload-in-c (ROA375) in PROM 0 + cpnos-in-c PROM1-only line program in PROM 1.  SDCC two-PROM is link-broken (`_get_img_base` undefined in sdcc/init.o) -- not fixing, parked.
- **MAME rc702 driver col-80 fix** (ravn/mame@035d29086bf): `set_size(560, ...)` so 80 cols × 7 px = 560 visible pixels.  Was clipping rightmost ~2 chars on every row.  Affects both live MAME view and `-aviwrite` captures.  Build with `make OSD=sdl SOURCES=src/mame/regnecentralen/rc702.cpp REGENIE=1`.
- **MAME video-capture pipeline** (`scripts/mame_capture.sh`): every MAME launch -aviwrite -> docker ffmpeg h264 MP4 (pad 904×590 with rgb(0xC0,0x60,0x00) bezel) -> `scratch/mame-videos/`, prune to last 50.  Typical 50-s run = ~160 KB.
- IX/IY: reserved (un-reserve gated on Phase 3 regalloc cost-model work, see #38)
- Z80 lit suite: **104 PASS + 2 XFAIL (106 total)**, CI green
- **cpnos-in-asm: PARKED 2026-05-17** (superseded by cpnos-in-c PROM1-only)
- **sem702-qr-test**: new subproject `rc700-gensmedet/sem702-qr-test/` -- CP/M .COM that paints two QR codes (1× + 2× scale) of `https://github.com/ravn` side-by-side via SEM702 sextants, snapshot-verified in MAME (`make run`).
- **cpnos-in-asm: PARKED 2026-05-17** (see `rc700-gensmedet/cpnos-in-asm/PARKED.md`).  Superseded by cpnos-in-c PROM1-only.  Last functional state: 1566 / 2048 B PROM1, PolyPascal + CONOTEST PASS, 15 of 18 RC700 text-mode CONOUT codes (graphics-mode 0x14/0x15/0x16 missing on both variants).  Source tree preserved; new feature work goes into cpnos-in-c.
- AES-256 corpus (rc700-gensmedet/tasks/aes256-corpus): `09_Oz_prod_like` clang **2695 B** vs zsdcc 3604 B (clang ahead by 909 B); `01_baseline_Oz` clang 4111 B (post-S3' −94 B).  See `llvm-z80/tasks/session73b-s3prime-prod-impact-analysis.md`.
- cpnos-in-c 4-cell test matrix (compiler × transport): all PASS at HEAD
- IX/IY: reserved (un-reserve gated on Phase 3 regalloc cost-model work, see #38)
- Z80 lit suite: **104 PASS + 2 XFAIL (106 total)**, CI green

## Canonical Plan

Master: `llvm-z80/tasks/roadmap-to-maturity.md` (session 36).
Current overlay: `llvm-z80/tasks/plan-2026-05-03-structural.md` (session 42).
Strategic frame: bring `llvm-z80/llvm-z80` (active fork-of-record, owner @zlfn) to maturity collaboratively; eventual official LLVM upstream is long-term aspiration. Workspace mode → engagement mode (gated on substantial body of work).

**Phase status (session 42):** Phase 1 Foundation **DONE**; Phase 2 Correctness sweep **DONE** (#28, #36, #63, #81 fixed; #38 reclassified to Phase 3); Phase 3 Cluster A regalloc 3 of 5 closed (#94, #98, #99); #89 + #27 remain as multi-session investigations expected to subsume #38. Engagement-mode gate is **one cluster away**.

## Session History

Detailed session-by-session log lives in `rc700-gensmedet/tasks/timeline.md`. Per-session summaries in `llvm-z80/tasks/session*-summary.md` and `rc700-gensmedet/cpnos-rom/tasks/`. Most-recent sessions:

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

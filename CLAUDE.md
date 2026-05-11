# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Goal

Optimize the Z80 backend of ravn/llvm-z80 (a GlobalISel-based LLVM fork) to match or beat SDCC code density. Test against RC700 PROM and BIOS sources in rc700-gensmedet.

## Current Sizes (2026-05-10 late)

- autoload PROM: clang **1756 B** vs SDCC 1910 B; clang `-g` variant 1861 B (#123)
- BIOS: clang **5961 B** vs SDCC 6123 B (clang −162 B)
- cpnos-rom resident (post-#75 + session-58 z80_preserves_regs): **clang 1928 B / SDCC 2068 B** in 2K PROMs (no expansion). SNIOS body now plain C (17 functions in `snios_c.c`); asm reduced to 24 B JT + 2×5 B BC→HL bridges. Session 58 added clang `z80_preserves_regs` end-to-end (#131 caller + frontend + #133 layer 1 callee-side) saving 36 B clang resident on `xport_send_byte` callers.
- cpnos-rom 4-cell test matrix (compiler × transport): all PASS at HEAD
- IX/IY: reserved (un-reserve gated on Phase 3 regalloc cost-model work, see #38)
- Z80 lit suite: **90/90 (89 PASS + 1 XFAIL #99)**, CI green

## Canonical Plan

Master: `llvm-z80/tasks/roadmap-to-maturity.md` (session 36).
Current overlay: `llvm-z80/tasks/plan-2026-05-03-structural.md` (session 42).
Strategic frame: bring `llvm-z80/llvm-z80` (active fork-of-record, owner @zlfn) to maturity collaboratively; eventual official LLVM upstream is long-term aspiration. Workspace mode → engagement mode (gated on substantial body of work).

**Phase status (session 42):** Phase 1 Foundation **DONE**; Phase 2 Correctness sweep **DONE** (#28, #36, #63, #81 fixed; #38 reclassified to Phase 3); Phase 3 Cluster A regalloc 3 of 5 closed (#94, #98, #99); #89 + #27 remain as multi-session investigations expected to subsume #38. Engagement-mode gate is **one cluster away**.

## Session History

Detailed session-by-session log lives in `rc700-gensmedet/tasks/timeline.md`. Per-session summaries in `llvm-z80/tasks/session*-summary.md` and `rc700-gensmedet/cpnos-rom/tasks/`. Most-recent sessions:

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

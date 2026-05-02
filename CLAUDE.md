# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Goal

Optimize the Z80 backend of ravn/llvm-z80 (a GlobalISel-based LLVM fork) to match or beat SDCC code density. Test against RC700 PROM and BIOS sources in rc700-gensmedet.

Current: Clang 1756 bytes vs SDCC 1910 bytes (-8.1%) for the autoload PROM. **BIOS: Clang 5920B vs SDCC 6123B (clang 203B smaller)** as of 2026-05-02 end of session #36. cpnos-rom payload 1708B. (IX/IY reverted to reserved — allocation was incomplete, #38.) Z80 lit suite: **77/78 (77 PASS + 1 XFAIL #99)**. 28 issues open at end of session 36 (filed #101).

**Canonical plan:** `llvm-z80/tasks/roadmap-to-maturity.md` (872 lines, written session 36) — supersedes ad-hoc plans.  Strategic frame: bring `llvm-z80/llvm-z80` (active fork-of-record, owner @zlfn) to maturity via collaborative work; eventual official LLVM upstream is long-term aspiration.  Workspace mode (current) → engagement mode (gated on substantial body of work) split.  Phase 1 (Foundation) is the next active phase.

Session #36 (2026-05-02 evening): no codegen changes — strategic reframe + research + upstream sync.  4 parallel research agents: backend-area audit (~80% production-ready, 79 files / 27K LOC), upstream LLVM Z80 status (no Z80 in llvm/llvm-project; jacobly0 archived; llvm-z80/llvm-z80 active under @zlfn), peer-target precedent (DJNZ-as-primary was wrong; ARM uses post-RA fusion via ConstantIslandPass; Z80's pseudo+peephole is aligned), open-issue triage (27 open, 5 correctness, 22 pessimization, 6 clusters).  Master plan `tasks/roadmap-to-maturity.md` lays out 9-phase execution, 13-23 calendar weeks part-time.  Upstream sync: merged llvm-z80/llvm-z80:main (~3782 commits, 1 Z80-source change: zlfn's Combiner API fix); build clean; lit 77 PASS + 1 XFAIL; sizes byte-exact (5920 / 1708).  Filed ravn/llvm-z80#101 (missing `override` markers on Z80TargetTransformInfo.h post-merge).  See `llvm-z80/tasks/session36-summary.md`.

Session #35 (2026-05-02): closed ravn/llvm-z80#97 (BC ping-pong in single-BB self-loops).  New post-RA peephole in `Z80LateOptimization.cpp` (~250 LOC) handles three pred shapes (`LD C,L; LD B,H` from HL param, `LD HL,nn N; LD BC,nn N` constant in both, `LD BC,nn N` only) crossed with two body orderings (anchor-first vs anchor-last).  Filed #99 (i16-counter sub-case where counter and pointer compete for HL — needs regalloc-level swap, parked) and #100 (rotation-around-CALL forces BSS spills: rcbios +33 B, cpnos-rom +4 B with rotation on; now the gate on #77a default-on).  `Z80LoopRotate` stays default-off pending #100.  Sizes unchanged from session 33 baseline (peephole still fires on Case 1 hand-written shapes; PROM0 non-padding -1 B).  See `llvm-z80/tasks/session35-summary.md`.

Session #33 (2026-05-02): regalloc cluster + BSS-spill family.  rcbios 5967→**5920 B** (-47 B); cpnos-rom payload 1730→**1708 B** (-22 B); Z80 lit 73/73 → 75/75.  Closed #92 (nested-loop DJNZ direction; getRegAllocationHints requires self-back-edge), #74 (PUSH/POP for short-lived 16-bit spills, no-CALL + cross-pair), #53, #37, #39.  Branch `z80-regalloc-cluster`.

Session #34 (2026-05-02): source-cleanup audit + Z80LoopRotate (gated off) + #97/#98 investigation.  No size win; landed `Z80LoopRotate` pass + filed #96, #97, #98 with thorough investigations and lit tests (77/77 = 76 PASS + 1 XFAIL).

Session #32 (2026-05-01/02): cluster 2 (DJNZ + LDIR family) + adjacent peepholes -- 8 issues fixed (#78, #88, #64, #91, #82, #76, #93, #86), 5 filed (#91 fixed same session, #92, #93 fixed same session, #94, #95), 15 retroactively closed.  rcbios BIOS 5998→5967B (-31B); cpnos-rom payload 1738→1730B (-8B); Z80 lit 65/66+1 XFAIL → 73/73.  Highlights: #88 new IR pass `Z80LoopIdiomFill` for K-byte (1-4 incl. jump-table) constant-trip pattern fills → seed+LDIR; #82 BSS-spill peephole orphan-reload bug fixed (XFAIL → PASS); #76 LD A,(HL); LD r,A → LD r,(HL); #93 carry-roundtrip elimination (11→3 B per countdown loop body); #86 u8 switch range-check 16→8 bit (saves 4 B per switch).  See rc700-gensmedet/tasks/timeline.md Phase 32 and llvm-z80/tasks/issue-status-2026-05-02.md.

Session #12: PROM fixes #58 (JP→JR), #60 peephole, cross-block OR A, #62 dead HL copy, LD (nn),A→LD (HL),A peephole — PROM 1771→1756B (-15B). BIOS fixes #62-#68 (7 compiler fixes), DJNZ peephole, #66 BSS reload fix, #53 relocate_bios rewrite (clean C with __builtin_memcpy + BSS-clear-first ordering), check_no_bss_in_relocate.py test — BIOS 5952→5826B (-126B). Native macOS build replaces Docker for compilation.

Session #18 (2026-04-18): Serial speed investigation. CTC-to-SIO shared clock confirmed (no split TX/RX). Z80-SIO/2 has NO DPLL/BRG (those are SCC features). SDLC mode with CTC clock at x1 is the fast path -- 250 kbaud bidirectional, ~28 KB/s (7x current). DMA channel assignments corrected (ch0=J8 external, ch3=display not free). J8 bus expansion documented. MAME rc702.cpp fixed: z80dart->z80sio (ravn/mame#3).

Sessions #20-21 (2026-04-18): SDLC TX validated on physical RC702 (SIO-A, CTC timer mode). DDT deploy path (`ddt_deploy.py`) replaces PIP+MLOAD. Host capture via FT2232D async bit-bang (`sdlc_capture.c` + `sdlc_receiver.py` with DPLL decoder). FT2232D caps at ~200 kHz bit-bang -- too slow for 250 kbaud capture. CTC CLK on PCB530 is NOT 4 MHz as MAME models (observed ~5 MHz, needs scope). Decoder logic verified correct via synthetic tests (`test_sdlc_decoder.py`); real captures show flag structure but zero CRC-OK frames -- likely RS-232 transceiver signal integrity issue on cheap adapter. Next HW step: FT2232H adapter (USB-COM232-PLUS2 from Farnell/Newark EU). Board identified as PCB530 (MIC702 variant). DB-25 pinout documented -- no TxC/RxC pins on MIC702/703, so sync RX from host is impossible without cable mod (TX-only SDLC viable).

Session #23 (2026-04-19/20): SIO async flow-control bug fixed.  `list_lpt`, `bios_punch_body`, `serial_conout` each rewrote WR5/WR1 per byte, clobbering the RX ISR's RTS-deassert and defeating RX flow control on sustained bidirectional traffic (RX overruns observed on 1024-byte test, 26% byte loss).  `readi()` now arms both SIOs and runs before banner.  SIO-B got symmetric RTS flow control.  MAME rc702.cpp `rs232b_defaults` FLOW_CONTROL 0x00→0x01 so null_modem honors RTS-B.  New `make sio-echo-test`: 4096-byte bidirectional BIOS-direct echo on both SIOs, passes clean.  BIOS size 6013→6002B.  See rcbios-in-c/tasks/session23-sio-flow-control.md.

Session #16 (2026-04-15/16): type-correctness sweep in BIOS sources. `dskad` word→byte* (-35B clang — fixed partial-constant-fold bloat), `dmaadr` word→byte*, FSPA/DPH const-correct (6 casts removed), bios_seldsk_c returns DPH*. `BUFF` renamed to `BDOS_DMAADDR`, `CCP_BASE` now typed as pointer. Both SIOs default to 38400 ×1 (prep for 76800/115200 on real HW — MAME Z80-DART ×1 receive fails at >38400, filed ravn/mame#2). `siob-baud` test harness auto-extracts BSS addrs from bios.elf. New llvm-z80 fix: #71 SRL A→RRCA when followed by AND mask (-13B clang). SDCC const-pointer codegen inefficiency filed as ravn/z88dk#2.

## Workspace Layout (`/Users/ravn/z80/`)

Everything lives under one folder:
- `llvm-z80/` — LLVM/clang fork with Z80 backend (shallow clone of github.com/ravn/llvm-z80)
- `rc700-gensmedet/` — RC700 CP/M system sources (github.com/ravn/rc700-gensmedet)
  - `autoload-in-c/` — Primary test case: ROA375 boot PROM in C (priority 1)
  - `rcbios-in-c/` — Secondary test case: CP/M BIOS in C (priority 2)
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
Per-function profile of the largest clang BIOS functions shows where
clang's bytes still cluster — not "clang vs SDCC overhead", but
"where the remaining shrink budget hides":

| Cause                                | Impact                    | Status                                   |
| ------------------------------------ | ------------------------- | ---------------------------------------- |
| 1. BSS load/store traffic            | 30–48% of large functions | **dominant**; #20, #15, #100 open        |
| 2. Excess reg-to-reg moves (regalloc) | 22–58 per large fn        | #94 / #98 / #89 / #95 cluster open       |
| 3. Flag re-derivation (`or a`, `cp`) | 5–15 per large fn         | #77 open; #93, #86 closed                |
| 4. IX frame overhead                 | ~0 B (`+static-stack`)    | **obsolete on BIOS**; #12, #40 small     |
| 5. IY prefix overhead                | ~0 B (IY reserved)        | **obsolete**; #38 gates re-enabling      |
| 6. 8→16 bit promotion                | residual / case-by-case   | mostly closed (#86, narrow-via-zext)     |

Largest clang BIOS functions (excludes `_conv_tables` / boot data):

| Function          | Bytes | BSS-access | Reg-reg | Notes                          |
| ----------------- | ----: | ---------: | ------: | ------------------------------ |
| `_specc`          |  676  | 208 (31%)  | 58      | display char dispatch          |
| `_bios_hw_init`   |  341  |   —        |  —      | port-init sequence (data-like) |
| `_rwoper`         |  263  | 105 (40%)  | 35      | floppy block/deblock           |
| `_bg_clear_from`  |  262  |   —        |  —      | display fill                   |
| `_sec_rw`         |  247  |   —        |  —      | sector r/w                     |
| `_bios_seldsk_c`  |  199  |  66 (33%)  | 28      | disk-table lookup              |
| `_bios_write_c`   |  170  |   —        |  —      | floppy write entry             |
| `_isr_crt`        |  166  |  80 (48%)  |  6      | CRT ISR (highest BSS density)  |
| `_xyadd`          |  149  |  64 (43%)  | 22      | coordinate calc                |
| `_chktrk`         |  136  |   —        |  —      | multi-density track dispatch   |

cpnos-rom hot functions (`_netboot_mpm` 224 B, `_relocate` 115 B,
`_impl_conout` 87 B) show single-digit BSS-access bytes — they carry
much less state than BIOS and are already close to optimum.

Conclusion: **BSS spill traffic + regalloc churn** account for almost
all remaining clang bloat in BIOS.  The historical IX/IY-overhead and
8→16 promotion items in this section's prior version are no longer
active gaps; #38 (IY un-reserve) and #12/#40 (IX as frame ptr) are
parked side issues.

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
When refactoring, prefer these over older C99/C11 equivalents.

Tested and working in both compilers:
- `true`, `false` as keywords (no stdbool.h needed)
- `nullptr`
- `_Bool`, `_Static_assert`
- `__typeof` / `typeof`
- `0b` binary literals
- designated initializers (`{.x = 42}`)
- for-loop declarations (`for (int i = 0; ...)`)
- `#embed`

**NOT working in zsdcc** (do not use in shared sources):
- `constexpr`
- `[[attributes]]` (use `__attribute__` instead)
- digit separators (`1'000` or `1_000`)
- `typeof` in expressions (`typeof(x){42}`)

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

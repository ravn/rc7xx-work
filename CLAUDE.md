# CLAUDE.md

Guidance for Claude Code when working in this repository.

## ⛔ TOP-PRIORITY HARD RULE — never search outside the workspace

**Before EVERY `find`, `ls`, `glob`, `grep`, `mdfind`, `locate`, or agent search: read the path. If it does NOT start with `/Users/ravn/z80/` (macbook) or `/home/ravn/z80/` (sonnyboy), STOP. Ask the user. Do NOT run the command.**

This includes "parallel just in case" broad searches — they walk iCloud-synced dirs and force-download every offloaded file, costing real bandwidth/disk regardless of whether anyone reads the result. Four documented incidents (2026-04-21/05-09/06-10/06-14) — see `tasks/memory/feedback_no_home_search.md`. Further violations are a session-ending failure of trust. If a workspace-internal lookup returns nothing, **ask the user where the file lives** — never "search wider."

## Memory — read at session start

**Durable rules, preferences, and lessons live in `tasks/memory/` (index: `tasks/memory/MEMORY.md`). Read `MEMORY.md` at the start of every session** (migrated out of `~/.claude/` 2026-05-28, so it is no longer auto-injected). To record a durable note: add a file under `tasks/memory/` + a one-line index entry in `MEMORY.md`. **Never write to `~/.claude/`** — that harness default is OVERRIDDEN.

## Project Goal

Optimize the Z80 backend of ravn/llvm-z80 (a GlobalISel LLVM fork) to match/beat SDCC code density. Test against RC700 PROM/BIOS sources in rc700-gensmedet.

**Direction (user 2026-06-03):** the four RC702 firmware components — **rcbios, autoload-in-c, CP/NET, cpnos** — are the production deliverables this compiler work serves. All four *work*; the goal is to bring them to **finished** (no known bugs, clear docs, oracle coverage, headroom). Bias priorities toward items that advance one of these four. See `tasks/memory/project_finishing_firmware_components.md`.

## Current State (headline)

clang beats SDCC on all production targets and dominates the AES corpus. Cheap codegen/regalloc levers are exhausted (dominant residual waste is ISA-fundamental); remaining high-value compiler work is upstream-submission packaging.

Sizes (refreshed dates noted; re-verify MAME boot after any code change):
- **autoload PROM** (clang, ZX0): 1643 B / 2048 B cap (405 B free, 2026-07-01). Boot gate PASS. **Hard-capped at 2 KB** (no A11 bridge on user's HW — `project_rc702_2kb_prom_hard_limit`). Memory map in `autoload-in-c/BOOT_SEQUENCE.md`.
- **BIOS**: clang 5462 B vs SDCC 6091 B (−629 B / ~10.3%, 2026-06-15).
- **cpnos-in-c PROM1-only line program**: clang {PIO+SIO} dual 2014 B / 2048 B (34 B free, 2026-06-28). **PIO (pio-irq) is the verified/recommended transport** (Makefile default). **SIO PARKED 2026-07-07** — deterministic mod-2 pass/fail flake, intrinsic to SIO not MAME (`cpnos-in-c/tasks/KNOWN_ISSUE_polypascal_alternation_2026-07-07.md`). SDCC 2151 B / 4 KB MAME-only. Build: `cd cpnos-in-c && make prom1-lineprog COMPILER={clang,sdcc}`.
- **AES-256 corpus** (`rc700-gensmedet/tasks/aes256-corpus`): `09_Oz_prod_like` clang −22% size / +51% slower vs zsdcc. Size win intact; speed gap accepted, off critical path — `[[project_aes_kr_speed_gap_accepted]]`.
- **Z80 lit suite**: 164 PASS + 6 XFAIL, CI green. Two-tier CI: `build-and-lit` + `runtime-tests`; production verifier-clean via `z80-utils/test-runner/scripts/verify-production.sh`.

Durable facts:
- **Compiler intrinsics/attributes** (#42/#4): clang ships `<intrinsic.h>` so the same rcbios source compiles under clang AND SDCC with no `-I`/`#ifdef`. Builtins `__builtin_z80_di/ei/halt/nop/im2/set_i`; `__attribute__((z80_critical))` drives Z80FrameLowering DI/EI.
- **SW1 bit allocation** (canonical: `rc700-gensmedet/docs/SW1_BIT_MAP.md`): bit 0 (S01) console mode (rcbios+cpnos); bit 1 (S02) PROM1 lineprog enable (autoload); bit 2 (S03) CP/NET transport PIO/SIO (cpnos + rcbios SNIOS). Default DIPs (S03=On=0) route to PIO.
- **rcbios CP/NET SNIOS dual SIO+PIO**: polypascal-pio-test PASS (`cpnet/polypascal_pio_test.sh`). MAME z80pio fix in ravn/mame `2eb88cea` (upstream candidate ravn/mame#13).
- **IX/IY reserved by default** (un-reserve gated on cost-model work #38). Byte-decompose leaks #189/#27/#112 FIXED (`llvm-z80/tasks/issue112-189-iy-leak-taxonomy-2026-05-25.md`). Un-reserving IY is worth ~0 on production (re-measured 2026-07-14); #23 Phase 2 cost-tier split PARKED (`llvm-z80/tasks/plan-z80-cost-model-refinement-2026-06-08.md`).
- **MAME**: `rc702sem702` machine = rc702 clone with SEM702 RAM-backed chargen (ports 0xD1/D2/D3). rc702 col-80 fix `set_size(560,...)` (ravn/mame@035d29086bf). Video capture via `scripts/mame_capture.sh` → `scratch/mame-videos/`.
- **PARKED**: two-PROM build (2026-05-17), cpnos-in-asm (2026-05-17, superseded by cpnos-in-c), cpnos PIO→INIR #115 (2026-06-14, needs physical HW — `cpnos-in-c/tasks/PIO_INIR_PARKED.md`). Sole production topology: autoload-in-c (ROA375, PROM 0) + cpnos-in-c PROM1-only (PROM 1).

## Canonical Plan

- Master roadmap: `llvm-z80/tasks/roadmap-to-maturity.md`; overlay `llvm-z80/tasks/plan-2026-05-03-structural.md`.
- Strategic frame: bring `llvm-z80/llvm-z80` (active fork-of-record, owner @zlfn) to maturity collaboratively; official LLVM upstream is long-term.
- **Phase status**: Foundation + Correctness sweep DONE; Cluster A regalloc complete. **Correctness gate CLEARED** — no open miscompiles. Remaining pre-upstream work is **packaging, not fixing**.
- **Upstream filing queue** (staged for llvm/llvm-project): `llvm-z80/tasks/upstream-filing-queue.md`. All filings require per-filing explanation + explicit go-ahead (`feedback_explain_before_filing`); generic-LLVM bugs route to llvm/llvm-project, never the fork (`feedback_upstream_routing_two_targets`).
- **Indexes**: coherence map `llvm-z80/tasks/upstream-coherence-map-2026-05-22.md`; execution plan `llvm-z80/tasks/execution-plan-2026-05-22.md`; known-suboptimal-codegen index `llvm-z80/tasks/known-suboptimal-codegen.md` (add an entry when a new "should be better" pattern surfaces).

## Session History

Detailed session-by-session log: `rc700-gensmedet/tasks/timeline.md`. Per-session summaries: `llvm-z80/tasks/session*-summary.md` and `rc700-gensmedet/cpnos-rom/tasks/`. Notable: **#77 upstream PR #17 RETRACTED 2026-06-05** (@zlfn: contributors must explain their contributions) — spawned `feedback_explain_before_filing` + the two-target routing rule.

## Workspace Layout

Root is per-host (`/Users/ravn/z80/` macbook, `/home/ravn/z80/` sonnyboy):
- `llvm-z80/` — LLVM/clang fork with Z80 backend (github.com/ravn/llvm-z80)
- `rc700-gensmedet/` — RC700 CP/M system sources (github.com/ravn/rc700-gensmedet)
  - `autoload-in-c/` — ROA375 boot PROM in C (production, PROM 0)
  - `rcbios-in-c/` — CP/M BIOS in C
  - `cpnos-in-c/` — CP/NOS slave PROM1-only line program (production, PROM 1)
  - `cpnos-rom/`, `cpnos-in-asm/` — parked predecessors
  - `z88dk/` — **NOT the fork.** Pinned prebuilt toolchain (downloads official z88dk 2.4 macOS release, symlinks bin/lib/include) tracked inside rc700-gensmedet. Gives builds a stable stock `zcc`/`zsdcc`/`z80asm`.
- `z88dk/` — the **development fork** (github.com/ravn/z88dk, own repo). All bridge/newlib/clang-integration work (`libsrc/l/llvmz80/`, `include/_DEVELOPMENT/`). Built from source. Distinct from the prebuilt one above.

The autoload Makefile references `LLVM_Z80` via `$(CURDIR)/../../llvm-z80`.

## Build Commands

### LLVM-Z80 compiler (Docker image `llvm-z80-build`)
```bash
cd llvm-z80
cmake -C clang/cmake/caches/Z80.cmake -G Ninja -S llvm -B build
ninja -C build          # full  (or: clang / llc)
```

### PROM builds (in rc700-gensmedet/autoload-in-c/)
```bash
make rom_parts          # SDCC build (needs z88dk in ../z88dk)
make clang              # Clang build (needs Docker + llvm-z80/build/)
make clang_asm          # Show clang assembly
make mame               # SDCC PROM + boot test in MAME
make clang_prom         # Clang PROM + install to MAME/RC700
```

### Tests
```bash
build/bin/llvm-lit llvm/test/CodeGen/Z80/          # LLVM lit
cargo run                  # test-runner default (O1,O2,Os); also: clang / bench
```

## Architecture

GlobalISel backend (not SelectionDAG). Key files:
- `Z80InstructionSelector.cpp` — instruction selection (largest)
- `Z80LateOptimization.cpp` — peephole opts (most modified)
- `Z80ExpandPseudo.cpp` — post-RA pseudo expansion
- `Z80CallLowering.cpp` — sdcccall(0/1) calling conventions
- `Z80LegalizerInfo.cpp` — legalization; `Z80RegisterBankInfo.cpp` — reg bank selection

PROM build: `--target=z80 -Os` with `+static-stack` (BSS locals) + `+shadow-regs` (EXX for ISRs), linked with `ld.lld` via custom linker script.

## Code Density (BIOS)

clang BIOS 5462 B vs SDCC 6091 B. Remaining clang waste is **ISA-fundamental** (8-bit memory is A-only → BSS-via-A + A-shuttle moves irreducible without #172-class machinery; all approaches so far net negative). cpnos is near-optimal. Dominant cause: BSS load/store traffic (30–48% of large functions). Full per-function profile: `rc700-gensmedet/tasks/timeline.md`.

## Key Z80 Optimization Patterns (from SDCC)

- **DJNZ** for `do {} while(--n)` (2 B vs 4) · **LDIR/LDDR** for memcpy/memset
- **CP (HL)** direct memory compare · **BIT n,A** single-bit test
- **ADD HL,HL** 16-bit left shift · **EX DE,HL** register swap (destroys both)
- **SBC A,A** to materialize carry as 0x00/0xFF

## C Language Standard

Sources use **C23 features that work in both clang and z88dk zsdcc 4.5.0**.
- Works in both: `true`/`false`, `nullptr`, `_Bool`, `_Static_assert`, `__typeof`/`typeof`, `0b` literals, designated initializers, for-loop decls, `#embed`.
- NOT in zsdcc: `constexpr`, `[[attributes]]` (use `__attribute__`), digit separators, `typeof` in expressions.

**How `-std` is set on the clang path (three routes):**
- **Production firmware drives clang directly** (`--target=z80 ... -std=c23`) — authoritative, already C23.
- **`zcc +cpm -compiler=llvmz80`**: hardcodes `-std` in `src/zcc/zcc.c`; **default `gnu23`** (2026-08-06). Override per build with `-Cg-std=<std>` (clang honours the LAST `-std`). Also auto-injects `-mllvm -z80-float-sdcccall0` so 32-bit-`double` (float32-math32, ravn/llvm-z80#277) libcalls use the sdcccall(0) ABI bridging to z88dk math32 (`[[project_double_is_float32_retire_softfloat]]`, `[[feedback_use_math32_flag]]`).
- **Bare `clang --target=z80`** (no `-std`): default `gnu17`, lacks C23 keywords.

**GCC builtins operate on 16-bit `int` here — never assume 32-bit.** `__builtin_clz`/`ctz`/`popcount`/`ffs` count over **16 bits**; `__builtin_*_overflow`/`bswap` follow 16-bit `int`. Before relying on a width-sensitive builtin (or a flag routing to one), verify operand width in emitted asm. This caused ravn/llvm-z80#273 (`-DSOFTFLOAT_BUILTIN_CLZ` → 16-bit clz → every `(double)int` corrupt); fixed by width-matching the builtin (`__builtin_clzl` for 32-bit clz) in `opts-GCC.h`, NOT a backend change. Corollary: a runtime closure isn't verified until every entry point runs AND its result is observed **losslessly** (a lossy `(long)` cast hid the 2¹⁶ error).

## Environment

- Docker for SDCC. **No brew** — never use or suggest it.
- Native LLVM-Z80 clang at `llvm-z80/build-macos/bin/` (`make toolchain`) on macbook; per-host paths in `tasks/memory/reference_z80_tool_paths.md` + `reference_host_sonnyboy.md`.
- z88dk via Docker (do not rebuild from source). CLion as IDE. MAME for HW emulation.
- **Never create pull requests unless explicitly told.**
- **Always `--no-ff` for git merges.**
- **Only push to origin at merges.** Commit locally freely; push only at merge points (feature→main, `--no-ff`) or when asked. Exception: the workspace repo is commit-pushed at the end of every working segment (cross-machine rule).
- **Keep GitHub Actions green.** Run lit/checks locally BEFORE committing; after any merge/push check `gh run list`/`view` and fix failures promptly. Z80 CI = `.github/workflows/z80-ci.yml`.

## Workflow

- Record all user prompts in `tasks/prompts.md`. Plan in `tasks/todo.md`, lessons in `tasks/lessons.md`.
- Think out loud. Never apologize. Be concise and accurate.
- Enter plan mode for non-trivial tasks; re-plan if things go sideways. Verify changes (tests, MAME boot) before marking done.
- **Persistent memory lives in the project, never `~/.claude/`** — confirm the destination is inside this project before recording any durable note.
- **Whenever you modify the compiler, always add a lit test** (in `llvm/test/CodeGen/Z80/`) pinning the instruction sequence with FileCheck — it is the CI-gated proof. If correctness is only observable at runtime, ALSO add a test-runner fixture (`z80-utils/test-runner/testcases/clang/*.c`, `/* expect 0xNNNN */`) — it complements, never replaces, the lit test.

## Known Bugs in llvm-z80

- **hasFP=false has a runtime bug** (parked).

Recently fixed (full writeups in the cited files; kept as pointers):
- `(double)int` / `__floatsisf` was NOT a backend bug — it was a SoftFloat clz-width config issue (ravn/llvm-z80#273, FIXED 2026-07-21). See C Language Standard above. (The former `llvmz80-softfloat/` tree that hosted the writeup has since been retired, ravn/z88dk#44.)
- Textual `-S` out-of-range `jr cc` — VAR-shift & other expanding `Z80Pseudo`s sized 0 in `getInstSizeInBytes` (ravn/llvm-z80#267, FIXED 2026-07-20/21). Systemic class + drift guard `-z80-verify-inline-runtime-size`; see `tasks/memory/issue267_pseudo_undersize_class.md`. (A separate fmt64@-O2 failure was our z88dk `bridge_postproc.sh` `jr→jp` rewrite, removed.)
- sret copied to wrong dest from an sret-returning call (`cf6c78afd775`, ravn/llvm-z80#268 CLOSED); sret setup skipped for no-arg >4-byte returns (`74378e7a78cc`, #274 CLOSED).
- Bare pair inline-asm constraints (`"hl"` etc.) crashed IRTranslator — `Z80TargetInfo::convertConstraint` rewrites to braced form.

## Working LLVM-Z80 features (use directly)

- `address_space(2)` for port I/O (ravn/llvm-z80 #1/#44): `*(volatile __attribute__((address_space(2))) uint8_t *)0x10` → `IN A,(0x10)` / `OUT (0x10),A`.

## z88dk `+cpm -compiler=llvmz80` stdlib status (2026-07-17)

CP/M stdlib surface is largely complete and verified (compiled + run under ntvcm/MAME); bridge layer in `z88dk/libsrc/l/llvmz80/` (ABI: `CALLING_CONVENTION.md`).

- **Works:** `string.h`, `ctype`, `stdlib` (atoi/itoa/strtol/qsort/rand/getenv/getopt…), `malloc` family, full `stdio` **FILE\*** layer (16/16 MAME). Non-variadic classic-clib calls bridge the HL→DE 16-bit-return mismatch via `__ZPROTO`.
- **`double`/`float` runtime:** on z80 `double`==`float`==`long double`==32-bit IEEE-754 binary32 (#277), so clang emits only single-precision (`sf`) soft-float libcalls, never `df`. These are resolved by the auto-linked `llvmz80_fmath.lib` math32 bridge (pass `--math32`); no env var. The old 64-bit Berkeley-SoftFloat closure (`softfloat_cpm_z80.lib`/`LLVMZ80RTLIB`, tree `llvmz80-softfloat/`) is **RETIRED** (ravn/z88dk#44, `[[project_double_is_float32_retire_softfloat]]`).
- **Fixed:** variadic stdio return value (z88dk header, ravn/z88dk#31); `va_start`/`va_arg` in user functions (ravn/z88dk `bb914a18`, #270); `printf("%f")` on newlib with `-D__LLVMZ80_IEEE_PRINTF` (ravn/z88dk#35, see `tasks/memory/reference_llvmz80_newlib_ieee_printf_fix.md`).
- **WONTFIX / out of scope:** disk FILE\* on newlib (ravn/z88dk#34 — CP/M newlib ships no file-open driver; classic is the forward direction). POSIX fd-layer (open/read/write…) resolves to no-op stubs on classic `+cpm` by design — real CP/M file I/O is the FILE\* layer under classic.

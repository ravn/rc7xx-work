# PROJECT.md — This workspace (Z80 / RC700)

Project-specific companion to `AGENTS.md` (which holds the portable, cross-project
working agreements). Claude Code also reads `CLAUDE.md` (workspace root +
`llvm-z80/`), which carries the **live, detailed** status — sizes, session history,
the current plan. Those numbers move; this file holds only the stable must-knows and
points to `CLAUDE.md` for the rest.

**Goal:** optimize the Z80 backend of `ravn/llvm-z80` (a GlobalISel LLVM fork) to
match or beat SDCC code density, validated against RC700 firmware (autoload PROM,
CP/M BIOS, CP/NOS) booted in MAME.

## Layout (one workspace, separate git repos)

- `llvm-z80/` — LLVM/clang fork with the Z80 GlobalISel backend.
- `rc700-gensmedet/` — RC700 CP/M system sources (autoload PROM, BIOS, cpnos).
- `z88dk/` — z88dk toolchain (SDCC/sccz80) for the reference build, via Docker.

## Hard constraints (violating these breaks the build or the hardware)

- **2 KB PROM cap.** The user's RC702 has no A11 bridge: PROM0 and PROM1 are each
  hard-capped at 2048 B. Never propose "use a 2732 / close A11" as a workaround.
- **No `brew`.** Docker for missing CLI tools; native `clang`/`llc` live in
  `llvm-z80/build-macos/bin`; `cmake`/`ninja` come from the CLion app bundle.
- **The compiler is experimental and unfinished.** On any suspected miscompile,
  inspect the generated Z80 asm *before* blaming the source, runtime, or hardware.
- **Production config is `+static-stack`** (BSS locals, non-reentrant). Test changes
  in that config, not just the default.
- **Issues go in `ravn/*` forks only** (llvm-z80, mame, z88dk, …), never upstream
  LLVM. Every compiler bug found gets an XFAIL lit test.
- **Dual-compiler parity:** rcbios/shared C changes must build with **both** z88dk
  (zsdcc) and clang before commit. Source uses a **C23 subset** that works in both
  (true/false/nullptr/typeof/0b/designated-init; *not* constexpr/`[[attr]]`/digit
  separators).
- **MAME:** build with `OSD=sdl` (not sdl3); launch **windowed (`-window`)**; add
  `-nothrottle` for unattended runs; never read I/O ports from Lua (use
  `install_read_tap`).

## Workflow conventions

- **Merges use `--no-ff`.** Don't push without an explicit request. Branch off the
  default branch before committing.
- Record prompts in `tasks/prompts.md`; append meaningful changes to
  `rc700-gensmedet/tasks/timeline.md` (tag Easy/Medium/Hard/Painful); plans in
  `tasks/todo.md`; lessons in `tasks/lessons.md`. **All persistent notes live in the
  repo**, never in `~/.claude/`.
- After a Z80 backend change, build **`ninja clang llc` together** (llc alone leaves
  the clang symlink stale); add a lit test under `llvm/test/CodeGen/Z80/`.
- Favor upstream fixes (GISel combiner, regalloc cost model, MIR DCE) over post-RA
  peepholes; question prior design decisions rather than band-aiding an immature
  backend.

## Build & test quick reference

```bash
# Compiler (Docker; image llvm-z80-build)
cd llvm-z80 && cmake -C clang/cmake/caches/Z80.cmake -G Ninja -S llvm -B build
ninja -C build clang llc

# Lit
build/bin/llvm-lit llvm/test/CodeGen/Z80/

# Integration (needs z88dk-ticks on PATH)
cd z80-utils/test-runner
cargo run                    # default O1/O2/Os
cargo run -- clang           # clang C suite
cargo run -- clang -static-stack   # production config (exposes the #192 bug class)
cargo run -- bench           # clang-vs-SDCC size benchmark

# PROM + MAME boot
cd ../../rc700-gensmedet/autoload-in-c && make clang_prom && make mame
```

## Key backend files

- `llvm/lib/Target/Z80/Z80InstructionSelector.cpp` — GlobalISel selection (largest).
- `llvm/lib/Target/Z80/Z80LateOptimization.cpp` — post-RA peepholes (most modified;
  any peephole that erases/moves/converts instructions needs complete liveness +
  slot-aliasing + iterator guards).
- `Z80ExpandPseudo.cpp`, `Z80CallLowering.cpp`, `Z80LegalizerInfo.cpp`,
  `Z80RegisterBankInfo.cpp`.

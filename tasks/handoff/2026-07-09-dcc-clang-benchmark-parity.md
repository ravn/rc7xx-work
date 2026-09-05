# Handoff: dcc-vs-clang benchmark parity work (2026-07-09)

**Session author:** GitHub Copilot (Claude Opus 4.8) on behalf of @ravn.
**Pick up with:** GitHub Copilot CLI. Read this file, then
`llvm-z80/tasks/plan-2026-07-09-beat-dcc-benchmarks.md` for the full plan.

---

## One-line status

Investigated why clang is slower than dcc on the 4 `dcc/tests/` benchmarks,
root-caused each, wrote a phased plan to make clang FASTER. **No codegen change
started yet** — next action is Phase A (sieve pointer strength reduction). All
measurement infrastructure is built and working.

---

## What was DONE this session (all committed + pushed to ravn/llvm-z80 main)

1. **Closed ravn/llvm-z80#253** (elf2rel BSS bug) — fix was already in main
   (`284afd1ab88b`), posted closing comment + closed the issue.
2. **Commented on ravn/llvm-z80#183** (libc benchmarks) — session-78 stub
   progress note.
3. **Fixed `cpm_crt0_sdcc.asm`** (commit `dd90c4fe9eb0`): added
   `.globl s__BSS`/`l__BSS` for native sdasz80, and `.area _DATA` before
   `.area _BSS` so the linker lays out CODE→DATA→BSS. Without this, `tm.COM`
   ballooned to 51 KB (BSS gap) and `ttt.COM` lost its initialized globals
   (wrong output). Rebuilt `cpm_crt0_sdcc.rel`.
4. **Re-ran the dcc-vs-clang comparison** with fixed elf2rel + CRT0
   (commit `6aebe4ed445e` writeup:
   `llvm-z80/tasks/session-2026-07-09-dcc-clang-comparison.md`).
5. **Added B25** to `known-suboptimal-codegen.md` (commit `473bc7106636`):
   `-O1`/`-O2` are SLOWER than `-Os` on Z80 integer loops (loop rotation adds
   BSS spills). **Always use `-Os` for Z80.**
6. **Wrote the plan** `plan-2026-07-09-beat-dcc-benchmarks.md` (committing now).

## Toolchain changes made this session (host state, NOT in git)

- `~/.local/bin/sdldz80` and `~/.local/bin/makebin` shims repointed from Docker
  to native arm64 binaries at `/Users/ravn/z80/z88dk/src/sdcc-build/bin/`
  (Docker fallback kept as commented lines). Docker is NOT running; native tools
  work fine for CP/M linking.
- `elf2rel` rebuilt from current source (`cargo build --release -p elf2rel` in
  `llvm-z80/z80-utils/`) and installed to `~/.local/bin/elf2rel`. The old binary
  was from 2026-07-05, before the #253 BSS fix. **If you rebuild elf2rel, copy it
  to `~/.local/bin/elf2rel` again.**

---

## Current measurements (ntvcm full-speed cycles, 2026-07-09)

| program | dcc        | clang -Os        | gap   | dominant cost |
|---------|------------|------------------|-------|---------------|
| sieve   | 18,180,494 | 26,251,719 (1.44×) | +44%  | inner-loop pointer strength reduction |
| e       | 20,923,181 | 28,152,176 (1.35×) | +35%  | 16-bit divide/modulo runtime helpers |
| ttt     |  4,751,136 |  6,677,394 (1.41×) | +41%  | tiny helpers not inlined at -Os |
| tm      | 49,501,528 |180,149,702 (3.64×) | +264% | ad-hoc malloc O(n) best-fit scan (stub, not codegen) |

Sizes (bytes, clang -Os vs dcc): sieve 1964 vs 1920 (+2%), e 2345 vs 2304 (+2%),
ttt 2792 vs 3456 (−19%), tm 3455 vs 4224 (−18%). clang already WINS on size for
ttt/tm.

---

## Root causes (verified this session — see plan for full detail)

- **sieve** (VERIFIED via ntvcm `-g` PC profile): the kill-multiples inner loop
  is **55% of runtime** (14.55M / 26.25M cyc; PC 354–372 executed 149,990×).
  clang = 97 T-states/iter (reloads `ld hl,_flags` base + `ld hl,8191` limit
  every iteration, shuttles index bc↔hl). dcc = ~39 T-states/iter (pointer-walk:
  hl=live pointer, de=stride, bc=end pointer, all loaded once).
  **If matched: sieve → ~17.5M, BEATS dcc.** GOAL IS ACHIEVABLE.
- The existing opt-in `Z80LoopInstrFormPrep` pass
  (`-mllvm -z80-loop-instr-form-prep`, #250) is INCOMPLETE — enabling it makes
  sieve SLOWER (29.68M) because it only reduces the store pointer, still
  reloading stride + end-pointer every iteration. Verified this session.
- **e**: 16-bit `x%n` AND `x/n` in the inner loop = two runtime-helper calls
  where dcc does one divmod (#244).
- **ttt**: at -O3 (inlines the 9 `posNfunc` helpers) ttt is 1.18× vs 1.41× at
  -Os — ~⅓ of the gap is un-inlined call overhead.
- **tm**: `heap.c` malloc O(n) best-fit scan, ~22% of instructions (session 78).
  Stub-quality, NOT a codegen gap. **Open question for user: pursue tm or
  document as allocator-bound?** (See plan bottom.)

---

## NEXT ACTION: Phase A — sieve pointer strength reduction

Goal: make the sieve inner loop pointer-walk like dcc (drop 97T → ≤45T/iter →
sieve beats dcc). Three approaches sketched in the plan (§Phase A):
- A1: fix/extend `Z80LoopInstrFormPrep` to also hoist end-pointer + stride and
  rewrite the exit test to a pointer compare, then gate on register pressure.
- A2 (preferred if feasible): steer LLVM's generic LSR cost model via Z80 TTI so
  it prefers the pointer-walk formula. Upstreamable.
- A3: late-MIR peephole recognizing the `ld hl,GV; add hl,rr` in-loop reload.

Key files:
- `llvm/lib/Target/Z80/Z80LoopInstrFormPrep.cpp` (existing pass)
- `llvm/lib/Target/Z80/Z80TargetTransformInfo.cpp` (TTI cost hooks — LSR steering)
- `llvm/lib/Target/Z80/Z80TargetMachine.cpp` (pass registration/ordering)

Validate with the ntvcm `-g` profile (inner loop must drop to ≤45T) + full
timing table. Gate: production triplet (rcbios/cpnos/autoload) byte-identical or
better, lit green (`llvm-lit llvm/test/CodeGen/Z80/`), runtime suite green.
Ship a lit test pinning the tightened loop + a runtime fixture. Per
`feedback_no_commit_first_version`: value oracle required before commit.

---

## How to reproduce the benchmark comparison

Scripts persisted at `/Users/ravn/z80/scratch/dcc-clang-bench/` (NOT git-tracked;
`/tmp` copies may be wiped):

- `build_one.sh <name> <opt> <outdir> [extra clang flags]` — builds one
  benchmark (name ∈ {sieve,e,ttt,tm}), prints size + cycles. Handles the stub
  modules each benchmark needs and the .COM extraction. NOTE: it references
  `/tmp/dcc_clang_compare/extract_com_size.py` — either recreate that path or
  edit the `EXT=` line to point at
  `/Users/ravn/z80/scratch/dcc-clang-bench/extract_com_size.py`.
- `extract_com_size.py <map>` — computes .COM byte count from an sdldz80 map
  (s__DATA+l__DATA-0x100, else s__BSS-0x100, else CODE end).
- `build_compare.sh` — builds all 4 at Os/O1/O2/O3.
- `timing_full.sh` — full timing table vs dcc (expects builds in
  `/tmp/dcc_clang_compare2/{Os,O1,O2,O3}/`).

Toolchain:
- clang: `/Users/ravn/z80/llvm-z80/build-macos/bin/clang`
- rebuild after backend edit: `ninja -C build-macos clang llc lld` (all three,
  per memory rule `feedback_rebuild_all_z80_tools`). ninja at
  `/Applications/CLion.app/Contents/bin/ninja/mac/aarch64/ninja`.
- elf2rel / sdldz80 / makebin: `~/.local/bin/` (see toolchain changes above).
- ntvcm: `/Users/ravn/z80/ntvcm/ntvcm -p <file>.COM` (–p prints cycle count;
  ntvcm may run at full speed per user — no `-s:` throttle needed).
- ntvcm PC profile: `ntvcm -p -g:<out>.csv <file>.COM` → CSV of pc,count,asm.
- dcc reference binaries: `/Users/ravn/z80/dcc/build/{SIEVE,E,TTT,TM}.COM`
  (built with dccpeep; rebuild via `cd /Users/ravn/z80/dcc && bash m.sh` then
  `./ma.sh <test>`). dcc assembly: `/Users/ravn/z80/dcc/build/*.MAC`.
- benchmark C sources: `/Users/ravn/z80/dcc/tests/{sieve,e,ttt,tm}.c`.

Build pipeline per program (from build_one.sh):
```
clang --target=z80 -Os -ffreestanding -nostdlibinc \
      -isystem compiler-rt/lib/builtins/z80/include \
      -ffunction-sections -fdata-sections -c prog.c -o prog.o
elf2rel prog.o prog.rel
sdldz80 -m -i -b _CODE=0x0100 out cpm_crt0_sdcc.rel prog.rel [stub.rel...] \
        -k build-macos/lib/z80 -l z80_rt
makebin -s 65536 out.ihx out_full.bin
dd if=out_full.bin of=PROG.COM bs=1 skip=256 count=$(extract_com_size.py out.map)
```
Stub modules per program: sieve→printf; e→printf; ttt→misc,printf;
tm→heap,misc,printf (all in `compiler-rt/lib/builtins/z80/`).

---

## Gotchas / lessons this session

- `/tmp` on this host had a create-file sync glitch (a tool-created file read
  back as 0 bytes). Write scratch scripts under `/Users/ravn/z80/scratch/`
  instead of `/tmp`.
- The terminal mangles multi-line heredocs when it has leftover state. Use the
  file-creation tool for scripts, not terminal heredocs.
- ntvcm cycle-count parse: grep line `Z80  cycles:` and take the LAST field
  (`awk '/Z80.*cycles:/{gsub(/,/,"",$NF); print $NF}'`) — a naive
  `grep -o '[0-9,]*'` matches the "80" in "Z80".
- `.COM` size extraction MUST account for section order CODE→DATA→BSS; the
  extract_com_size.py handles it. If initialized globals exist, file ends at
  s__DATA+l__DATA; else at s__BSS.

---

## Repo state at handoff

- **ravn/llvm-z80 main**: all committed + pushed through `6aebe4ed445e` plus the
  plan file (committing with this handoff). Lit 182+5, runtime 906/0 (from prior
  session; not re-run this session — no codegen change made).
- **ravn/rc700-gensmedet**: incidental build-artifact changes only
  (prom.clang.lis, text_compressed.zx0, cpnos error.log) — NOT this session's
  work, left uncommitted. Timeline updated with this session (committing).
- Open issues verified correct earlier this session (see the issue-audit at
  session start): 51 open in llvm-z80, 21 in rc700-gensmedet, 10 in ravn/mame-rc702-rc759-rc750,
  8 in ravn/z88dk. Nothing stale.



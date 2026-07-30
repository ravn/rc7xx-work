
## Session 2026-07-09 — dcc-vs-clang benchmark parity: investigate + plan

**Outcome:** Clean dcc-vs-clang comparison (size + timing) with fixed tooling;
root-caused all 4 benchmark gaps; wrote a phased plan to make clang FASTER than
dcc. No codegen change made — investigate-and-plan session.

### Issue housekeeping (session start)
- Closed ravn/llvm-z80#253 (elf2rel BSS bug; fix already in main `284afd1ab88b`).
- Commented on ravn/llvm-z80#183 (libc benchmarks; session-78 stub progress).
- Audited all open issues across ravn/{llvm-z80,rc700-gensmedet,mame,z88dk} —
  nothing stale.

### Tooling fixes (prerequisites for a valid comparison)
- Rebuilt `elf2rel` from current source (old binary predated the #253 BSS fix).
- Fixed `cpm_crt0_sdcc.asm` (llvm-z80 `dd90c4fe9eb0`): `.globl s__BSS`/`l__BSS`
  for native sdasz80 + `.area _DATA` before `.area _BSS` (CODE→DATA→BSS order).
  Without it, `tm.COM` ballooned 51 KB and `ttt.COM` lost initialized globals.
- Repointed `~/.local/bin/{sdldz80,makebin}` shims to native arm64 binaries
  (no Docker needed).

### Results (ntvcm full-speed cycles)
| program | dcc | clang -Os | gap |
|---------|-----|-----------|-----|
| sieve | 18.18M | 26.25M | +44% |
| e | 20.92M | 28.15M | +35% |
| ttt | 4.75M | 6.68M | +41% |
| tm | 49.50M | 180.15M | +264% |

Sizes: clang already WINS on ttt (−19%) and tm (−18%); +2% on sieve/e.

### Root causes (verified)
- **sieve**: inner loop (55% of runtime, ntvcm -g profile) reloads base+limit
  constants every iteration; 97 T-states/iter vs dcc's ~39 pointer-walk.
  Achievable: sieve → ~17.5M, BEATS dcc. The opt-in `Z80LoopInstrFormPrep`
  (#250) is incomplete — enabling it makes sieve slower.
- **e**: 16-bit divide+modulo runtime helpers, two calls where dcc does one
  divmod (#244).
- **ttt**: tiny helpers un-inlined at -Os (call overhead; -O3 closes ⅓ of gap).
- **tm**: ad-hoc `heap.c` malloc O(n) scan — stub quality, not codegen.

### B25 known-suboptimal entry
`-O1`/`-O2` are SLOWER than `-Os` on Z80 integer loops (loop rotation adds BSS
spills). Always use `-Os` for Z80.

### Deliverables
- Plan: `llvm-z80/tasks/plan-2026-07-09-beat-dcc-benchmarks.md`
- Comparison writeup: `llvm-z80/tasks/session-2026-07-09-dcc-clang-comparison.md`
- Handoff: `tasks/handoff/2026-07-09-dcc-clang-benchmark-parity.md`
- Bench scripts: `scratch/dcc-clang-bench/`

### Next action
Phase A — sieve pointer strength reduction (make the inner loop pointer-walk
like dcc). See plan §Phase A. Open question for user: pursue tm (allocator-bound,
stub work) or document as not-a-codegen-metric.


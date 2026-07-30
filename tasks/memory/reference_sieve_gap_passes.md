# Sieve-gap passes: Z80SinkColdLoopIV + Z80PinLoopPointer (opt-in, default OFF)

**Date:** 2026-07-09. **Repo:** `llvm-z80`. **Trackers:** ravn/llvm-z80 #256 (M3), #250 (M5), #251 (HLReg).

Two backend passes were authored to close the `sieve` benchmark gap vs dcc
(clang +18 % T-states at -Os). Both are gated behind `cl::opt` flags, **default
OFF**, so the production pipeline is byte-identical (verified: pass absent from
default `-debug-pass=Structure`; default sieve asm unchanged). Do NOT
re-implement these — they exist.

## Z80SinkColdLoopIV — `-z80-sink-cold-loop-iv`  (M3, the SCAN loop)

Post-LSR IR FunctionPass. Undoes LSR's strength-reduction of cold-only IVs
(sieve `prime=2*i+3`, `k_start=3*i+3` used only in the ~2%-taken `if(flags[i])`
branch) that LSR hoists into scan-loop IVs advanced every iteration → BSS spill.
RAUWs the cold seed-IV phis to a recompute at the cold NCD (inserted at
`getFirstInsertionPt()`, NOT `getTerminator()` — a use may live in the NCD block,
e.g. the guard's icmp), deletes the dead phi + latch step-add.
**Measured: sieve −2.3 %, E/TTT/TM ±0 %, all correct.** Clean non-regressing
partial win. Only −2.3 % because the scan loop is ~26 % of exec; the KILL loop
(M5) is the dominant ~65 %. Red-green lit `sink-cold-loop-iv.ll`.
Generic angle: the hoist is block-frequency-blind LSR `AddRecCost` (same 8
`%lsr.iv` on z80/x86_64/avr), only hurts register-starved targets → eventual
upstream candidate (needs explain+go-ahead per `feedback_explain_before_filing`).

## Z80PinLoopPointer — `-z80-pin-loop-pointer` + `HLReg` class  (M5, the KILL loop)

Pins an innermost pointer-walk IV to HL (`def HLReg : Z80Reg16Class<(add HL)>;`,
the BCReg sister). Kill loop becomes optimal in isolation (18→11 instr) BUT
**net-regresses sieve +1.4M T-states**: the scan loop regresses +1.31M (whole-
function regalloc cascade — HL pin + prep pointer-inits + IY spill land in the
hot scan path). On Z80's 3 pairs the enclosing loop pays for the inner loop's
registers. Stays opt-in until a register-pressure-aware M5 variant exists.
NOTE: `HLReg` is exactly the sister class #251 asked for, but is NOT yet wired to
#251's `bench_word_fill.c` single-loop case.

## Default-on decision

RESERVED for the user (not taken). Needs broader corpus validation + production
byte-identical confirmation. Full data: `llvm-z80/tasks/session-2026-07-09-sink-cold-loop-iv.md`.
Bench oracle: `scratch/dcc-clang-bench/ticks_cpm.py` (needs `-w 4` for TM +
`sys.exit(0)`); build via `build_compare.sh`.

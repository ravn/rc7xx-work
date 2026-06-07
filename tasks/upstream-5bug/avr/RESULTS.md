# AVR re-evaluation of upstream-candidate bugs — 2026-06-07 v3

**Revised after user push-back: my earlier STRENGTHENED claim for #164 didn't
survive realistic test shapes.  Honest verdict matrix below.**

Refresh of `../avr-triage-2026-06-07.md`, now combining the original 5-bug
queue with the Tier-I U-LLVM items from ravn/llvm-z80#186, and with the AVR
runtime value oracle (simavr) on top of the earlier instruction-count
comparison.

Toolchain: `llvm-z80/build-macos/bin/{clang,llc}` — since 2026-06-07 this
build targets Z80;SM83;AVR;MSP430.  AVR runtime via `simavr` master in the
`avr-tools` Docker image (distro 1.6 too old for `.mmcu` console hook).
**Caveat**: AVR codegen on macbook runs through the llvm-z80 middle-end
fork, not pristine upstream.

Per-bug test cases checked in alongside this file; `make bugN-test` or
`make bugN-codegen` reproduces.  `make all` runs every runtime-side test.

## Verdict matrix

| # | Origin | Test case | AVR result | Verdict |
|---|---|---|---|---|
| **Bug 2** | TruncInstCombine Argument-leaf<br>(FILED llvm/llvm-project#202112) | `bug2_argument_leaf.c` | Codegen: K&R 20 vs ANSI 3 (pristine upstream). Runtime: PASS on all 6 inputs. | **STRENGTHENED + RUNTIME-CONFIRMED.**  Only clearly upstreamable item. |
| **Bug 3 / #168** | SimplifyCFG foldTwoEntryPHINode no-PGO | `bug3_twoentry_phi.ll` | Micro: branch=select=5 instr.  5x scale: branch=select=11 instr.  Z80 5x: branch 17, select 19. | **WEAKENED.**  AVR equalizes at multiple scales.  Z80's select lowering is the cost source. |
| **Bug 4 / #163 / #165** | TruncInstCombine outside-user bail | `bug4_outside_user.c` | Codegen: gf_log K&R ≈ ANSI (~24 instr each). Runtime: PASS on 8 inputs. | **WEAKENED.**  AVR equalizes at gf_log scale; Z80 5.4× cost not reproduced. |
| **Bug 5** | InstCombine memcpy→illegal-int fold | `bug5_memcpy_illegal.c` | At -Oz/-Os: AVR copy8 = 4 instr (call memcpy, unaffected by fold).  At -O2/-O3: AVR copy8 = 27 instr (fold fires + inline byte traffic).  Z80 -Oz: inline LDIR regardless (cpnos #87). | **OBSERVABLE ON AVR AT -O2+, NOT AT -Oz.**  Consistency argument (`InstCombine.shouldChangeType` gates `isLegalInteger`; this fold doesn't) holds.  At size-critical opt levels — which is the case that motivated cpnos #87 — AVR isn't affected. |
| **Bug 1 / #182** | deleteDeadLoop SSA malform | `bug182_scev_crash.c` | AVR doesn't crash (no Z80LoopIdiomFill trigger). | **NOT UPSTREAM-INDEPENDENT.**  Track via ravn/llvm-z80#217. |
| **#164** | TruncInstCombine zext re-insertion cost model | `bug164_zext_reinsertion.ll` | Worst-case synthetic (4 explicit zexts, trivial chain): AVR +15%, Z80 +38%.  **Realistic shape (1 shared zext, real chain work): AVR −7%, Z80 −13% — narrowing WINS on both.** | **RETRACTED FROM STRENGTHENED → WEAKENED to TTI-cost-gate framing.**  Synthetic worst case isn't what TruncInstCombine produces.  Z80 production regressions (AES +188 to +532 B with #163 sink) come from 3-pair register pressure across many sites, not from intrinsic per-shape zext cost.  AVR's 32 GPR absorbs per-site cost.  Without a clang A/B toggle on the fork's #163 extension, can't measure cumulative AVR delta — but per-shape evidence does NOT support standalone upstream filing. |
| **#128** | MachineLICM/MachineCSE pessimization | `bug128_licm_cse.ll` | AVR: identical with/without LICM+CSE (synthetic).  Z80 production: −141 B (−16.2 %) with both off. | **WEAKENED to TTI cost-gate framing.**  Same shape as #164 conclusion. |
| **#179** | MachineScheduler reload-after-test | `bug179_test_then_dec.ll` | AVR 8 instr (`cpi` test-first, then `dec`); Z80 12 instr (reload pattern). | **WEAKENED to Z80-only trigger.**  AVR's non-modifying `cpi` + 32 GPR sidestep the pattern entirely. |

## Honest summary

Only **Bug 2** has clean upstream-filing prospect (and it's already filed at
llvm/llvm-project#202112).  Everything else either:

1. Doesn't manifest on AVR at the size opts that matter to us (Bug 5),
2. Equalizes on AVR backend (Bugs 3, 4),
3. Has a real Z80 production cost but no clean cross-target evidence
   (#164, #128, #179), or
4. Folds into another tracker (#182 → #217).

The "TTI cost-gate" family (#164, #128, possibly #179) could collectively
ship as a single upstream proposal: "Add TTI hooks for register-pressure-
and-zext-cost-aware decisions in mid-end optimization passes."  But it'd be
a design proposal, not a bug filing, and AVR is a negative-control example
(the passes are correct on AVR), not a sufferer.

## Recommended action

1. **Bug 2**: nothing to do.  Watch llvm/llvm-project#202112 for response.
2. **Everything else**: hold off filing as standalone upstream bugs.  If we
   pursue the TTI cost-gate story, write it up as a design RFC with the
   AVR / Z80 measurements as evidence.  Otherwise keep as fork knowledge.

## Methodology note (the user push-back lesson)

Synthetic test shapes can MASSIVELY overstate the bug if not anchored to
what the relevant pass actually produces.  For #164, my first pass
hand-wrote 4 explicit `zext i8 to i16` per use — exactly the shape that
makes narrowing look bad.  Real TruncInstCombine emits ONE shared zext at
the boundary, plus the optimizer's CSE / InstCombine consolidates the rest.
The right test is: does TruncInstCombine, given its actual output, produce
a net regression on AVR?  Without a clang A/B toggle, the answer has to
come from production measurement, not synthetic IR.

Pin this discipline going forward: **AVR cross-target evidence has to come
from shapes the relevant pass would actually produce, not from worst-case
synthetic IR**.  Otherwise the evaluation is unfalsifiable.

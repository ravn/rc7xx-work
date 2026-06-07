# AVR re-evaluation of upstream-candidate bugs — 2026-06-07 v2

Refresh of `../avr-triage-2026-06-07.md`, now combining the original 5-bug
queue with the Tier-I U-LLVM items from ravn/llvm-z80#186, and with the AVR
runtime value oracle (simavr) on top of the earlier instruction-count
comparison.

Toolchain: `llvm-z80/build-macos/bin/{clang,llc}` — since 2026-06-07 this
build targets Z80;SM83;AVR;MSP430.  AVR runtime via `simavr` master in the
`avr-tools` Docker image (distro 1.6 too old for `.mmcu` console hook).
**Caveat**: AVR codegen on macbook runs through the llvm-z80 middle-end fork,
not pristine upstream — for pure-upstream evidence use sonnyboy's
`~/llvm-upstream/llvm-project` build or hand unnarrowed IR to
`llc -mtriple=avr`.

Per-bug test cases checked in alongside this file; `make bugN-test` or
`make bugN-codegen` reproduces.  `make all` runs every runtime-side test.

## Verdict matrix

| # | Origin | Test case here | AVR codegen | AVR runtime | Verdict |
|---|---|---|---|---|---|
| **Bug 2** | TruncInstCombine Argument-leaf<br>(FILED llvm/llvm-project#202112) | `bug2_argument_leaf.c` | K&R 20 instr vs ANSI 3 — STRENGTHENED (pristine upstream) | PASS — all 6 inputs identical | **STRENGTHENED + RUNTIME-CONFIRMED.**  Filing strengthens; AVR is in-tree victim AND behaviorally consistent. |
| **Bug 3 / #168** | SimplifyCFG foldTwoEntryPHINode no-PGO | `bug3_twoentry_phi.ll` | branch_form ≡ select_form (5 instr each) | — (codegen-only) | **WEAKENED.**  AVR's backend equalizes select and branch; Z80's expensive select lowering is the real culprit. |
| **Bug 4 / #163 / #165** | TruncInstCombine outside-user bail | `bug4_outside_user.c` | gf_log K&R ≈ ANSI (~24 instr each) | PASS — all 8 inputs identical | **WEAKENED.**  AVR equalizes at gf_log scale (Z80: 5.4× K&R vs ANSI cost).  Fork-relevant. |
| **Bug 5** | InstCombine memcpy→illegal-int fold | `bug5_memcpy_illegal.c` | `call memcpy` regardless of fold | PASS — 8 bytes correctly copied | **WEAKENED on cost.**  AVR doesn't inline small memcpys.  Consistency argument (InstCombine's own shouldChangeType gates on isLegalInteger) still holds. |
| **Bug 1 / #182** | deleteDeadLoop SSA malform | `bug182_scev_crash.c` | AVR doesn't crash | — | **NOT UPSTREAM-INDEPENDENT.**  Trigger needs Z80LoopIdiomFill.  Real fix at ravn/llvm-z80#217. |
| **#164** | TruncInstCombine zext re-insertion cost model | `bug164_zext_reinsertion.ll` | AVR: wide 34, narrow 39 (+15 %); Z80: wide 21, narrow 29 (+38 %) | — (codegen-only) | **STRENGTHENED.**  Both AVR and Z80 pay; Z80 pays more.  Cross-target evidence supports upstream filing as "generic mid-end cost gap on targets with non-zero zext cost." |
| **#128** | MachineLICM/MachineCSE pessimization | `bug128_licm_cse.ll` | AVR: identical with/without LICM+CSE (synthetic); Z80 production: −141 B (−16.2 %) with both off | — | **WEAKENED to target-aware-cost-gate framing.**  AVR's 32 GPR absorbs hoists.  Filing should be "target-aware cost gate for tiny-register-file targets", not "LICM is broken." |
| **#179** | MachineScheduler reload-after-test | `bug179_test_then_dec.ll` | AVR 8 instr (`cpi` test-first, then `dec`); Z80 12 instr (`ld c,a; dec a; ld d,a; ld a,c; ...`) | — | **WEAKENED to Z80-only trigger.**  AVR's `cpi` doesn't clobber + 32 GPR = no reload pattern.  Generic upstream framing ("MachineScheduler shouldn't synthesize fake dependencies via implicit-register chains") possible but Z80 is dominant beneficiary. |

## Reading

The pattern from the first AVR triage holds and is now stronger:

> A mature byte-oriented backend (AVR, 32 GPR, native byte ALU) recovers raw
> WIDTH costs during legalization, but it cannot recover missed IDIOMS — the
> K&R rotate stays unrecognized at i16, so its cost survives.

**New from this pass**:

- **#164 is the surprise upstream candidate.**  AVR also regresses from
  TruncInstCombine narrowing under zext re-insertion pressure (+15 %).
  The bug isn't "Z80 doesn't have enough registers" — it's "any target with
  non-zero zext cost wants the cost model."  This is the most credible
  upstream filing in the queue right now.
- **Bug 2 is the only fully clean upstream win** so far filed.  Runtime
  confirms the fix is behaviorally neutral on AVR.
- **#179 has a generic dressing** but is empirically Z80-only.  Filing would
  need very careful framing to avoid the session-#77 retraction pattern.
- **#128 is a target-aware gating story**, not a bug.  Filing would be a
  TTI hook proposal.
- Bugs 3, 4, 5 are essentially fork-only despite generic-mid-end framing —
  the AVR backend equalizes their codegen-shape costs, leaving Z80 as the
  sole beneficiary in practice.

## Suggested action set

Ordered by expected upstream-acceptance prospect:

1. **Bug 2** (#202112): nothing to do — watch the upstream issue, respond to
   maintainer feedback.  Add runtime datum to the issue if asked.
2. **#164**: strongest fresh candidate.  Draft an upstream-style proposal
   (cost-model TTI hook for zext re-insertion).  Use the cross-target
   AVR+Z80 measurement as supporting evidence.
3. **#179** (if ever): frame as "MachineScheduler implicit-register-chain
   pseudo-dependency", not as "Z80-specific reload-after-test".
4. **#128** (if ever): frame as "MachineLICM/MachineCSE TTI cost gate for
   tiny-register-file targets", AVR as the negative-control evidence (the
   pass is correct on AVR).
5. **Bugs 3, 4, 5**: don't file upstream as standalone correctness/perf
   bugs.  Fold #163/#165 (Bug 4 micro) and #168 (Bug 3) into the same
   eventual upstream submission story as #164 if it ships (they're all
   TruncInstCombine/SimplifyCFG missed-narrowing/folding cost issues).
6. **#182 / Bug 1**: not a separate item.  Track ravn/llvm-z80#217.

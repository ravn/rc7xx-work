---
name: feedback-revalidate-historical-compiler-claims
description: HARD rule — before acting on any historical claim about compiler performance (size, speed, miscompile, "this pass pessimizes"), re-validate on a CURRENT clean rebuild.  AND — equally important — re-validate EVERY ROUND of measurement you take that informs a decision, not just the initial historical one.  Heuristics and replacement code can introduce their own measurement noise; cascading revalidation catches this.
metadata:
  type: feedback
---

**HARD: before acting on any historical claim about compiler performance
(size, speed, miscompile, "this pass pessimizes target X"), re-validate
on a CURRENT clean rebuild.  Match against the documented numbers; if
they differ, the current measurement wins.**

**Why:**  Two independent failure modes converge on the same risk:

  1. **Stale rebuild.**  The llvm-z80 build chain has had incidents
     where flag changes didn't trigger full rebuild of affected .o
     files.  A measurement that recorded "feature X costs +73 B" may
     have been against a partially-stale clang where feature X wasn't
     even active in the linked binary.

  2. **The backend moves.**  Z80 sees several sessions per week of
     regalloc, ISel, TTI, and peephole work.  A pass that genuinely
     pessimized in 2026-05 may genuinely help in 2026-06 because
     regalloc gained IY-allocatable, GR8 reorder for DJNZ, IX
     callee-saved, etc.  Same C in, different MIR out, different
     pressure profile, different cost.

  Concrete incident (2026-06-08): for two months the Z80 backend
  shipped a global `disablePass(MachineLICM + EarlyMachineLICM +
  MachineCSE)` workaround in Z80PassConfig, justified by recorded
  measurements at `tasks/aes256-corpus/task3_licm_ab.sh` showing LICM/
  CSE pessimized AES at -Oz (+34 B .text, +144 B bin) and miscompiled
  at -O2 (#198, MachineCSE verifier FAIL).  Re-measuring on current
  HEAD with the workaround LIFTED produced: -Oz LICM+CSE = -13 B text,
  -8.9% tstates, PASS; -O2 LICM+CSE = -118 B text, -119 B bin, -9.2%
  tstates, PASS.  Both opt levels now help, the miscompile no longer
  reproduces, and the workaround is costing ~9% AES speedup.  The
  recorded measurement had become wrong; the workaround was acting
  on a snapshot from before that point.

**How to apply:**

  1. When considering a code change motivated by a historical
     measurement (commit message claim, CLAUDE.md note, comment in
     code, prior session writeup), FIND the script/command that
     generated the original numbers.

  2. RE-RUN it on a clean rebuild (`ninja -t clean` + `ninja clang
     llc llvm-nm llvm-objcopy lld`, then re-measure).  Targeted
     incremental rebuilds are USUALLY correct but not always — for
     decision-affecting measurements, prefer clean.

  3. Compare to the documented numbers.  If they match: confidence
     in the historical claim is restored, decide normally.  If they
     differ: the current numbers win; the historical claim is
     stale.  Either backend movement or a stale-rebuild incident
     caused it.

  4. UPDATE the documentation (CLAUDE.md, code comments, memory
     notes, scripts' comment blocks) with the new measurement and
     the date.  Don't leave the old numbers in place — they
     mislead future-you.

  5. If the change is in production code (e.g. removing a
     `disablePass`), get the user's verdict before landing — the
     full clean rebuild + matching numbers establishes
     trustworthiness; the human still owns the production decision.

  6. **CASCADING REVALIDATION** — after re-validating the historical
     claim and writing replacement code (heuristic, fix, refactor)
     to act on the corrected understanding, that NEW code's
     measurements need the same scrutiny.  Specifically: ANY
     measurement that depends on YOUR new code is suspect until
     re-validated against a version that doesn't have the new code.
     A heuristic's correctness can't be inferred from its own
     output — the only honest test is "does removing my heuristic
     give the same result the heuristic claims to produce, or
     different?"  If different, the heuristic is doing more (or
     less) than its stated logic.

**Cascading-revalidation incident** (2026-06-08, same session as the
initial revalidation above): after retiring the `disablePass`
workaround, I added a `Z80InstrInfo::shouldHoist` heuristic claiming
to "limit autoload's LICM regression to +18 B / recover cpnos's -7 B
win".  Three commits later, a "did I really rebuild" sanity check
revealed the heuristic had a presence-cost side effect — at
threshold=99 (effectively unbounded, should be a no-op) it produced
the SAME +25 B autoload growth as threshold=0 (effectively always-
refuse).  So the heuristic was changing codegen even when its stated
logic should not have.  Reverting the heuristic entirely produced
the SIMPLER result: autoload +25 B / cpnos -15 B / AES -118 B at -O2,
all matching the original "no heuristic" measurement.  The
intermediate heuristic-on numbers (-18 B autoload / -7 B cpnos) were
ARTIFACTS, not real engineering wins.

The mistake: I trusted the heuristic's own measurements to validate
the heuristic.  Should have run a CONTROL CELL where the heuristic
code was present but functionally a no-op (e.g. `if (true) return
default;`) — if THAT control gave the same numbers as the no-override
state, the heuristic's "win" cells would have been provably
artifacts.  Apply this control pattern any time the new code is
acting as a measurement instrument on the system it's modifying.

This rule is cross-listed in §1 (always-on for any task that touches a
historical claim) and §8 (test/debug discipline).

Related:
  - [[feedback_revalidate_concern_not_filename]] — file moved /
    workaround in place ≠ resolved; verify the symptom in CURRENT
    source.  This rule is its compiler-performance cousin.
  - [[feedback_proper_fixes_immature_backend]] — question prior
    design decisions, including my own past code.
  - [[feedback_baseline_before_implementing]] — capture control
    measurement on UNMODIFIED system first.
  - [[feedback_check_memory_before_coding]] — scan memory at task
    start; this rule fires on any task that quotes a historical
    perf number.

---
name: feedback-revalidate-historical-compiler-claims
description: HARD rule — before acting on any historical claim about compiler performance (size, speed, miscompile, "this pass pessimizes"), re-validate on a CURRENT clean rebuild.  The llvm-z80 build chain has had stale-rebuild incidents where source/flag changes didn't fully propagate; a measurement from 4 weeks ago may have been on a partially-rebuilt clang.  And separately, backend improvements may have changed the cost equation since the original measurement was taken.
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

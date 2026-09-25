---
name: project-pi-cse-branchfold-parked
description: FIXED 2026-09-20 via #247 (commit 6385494bcfd7 on main). Root cause: MachineOperand::isIdenticalTo ignored getOffset() for MO_MCSymbol → branch-folder merged distinct BSS-slot stores. Fix in MachineOperand.cpp; also root-fixes pi CSE miscompile (B15). Upstream: ravn/llvm-project#1.
metadata:
  type: project
---

## STATUS: FIXED (2026-09-20)

Root cause: `MachineOperand::isIdenticalTo()` and `getHashValue()` did not compare
`getOffset()` for `MO_MCSymbol`, unlike all other operand kinds. Z80 static-frame
lowering encodes BSS slots as `MO_MCSymbol + nonzero offset`, so branch-folder
considered stores to *different* slots identical and dropped one.

Fix: two-line change in `llvm/lib/CodeGen/MachineOperand.cpp` — teach `MO_MCSymbol`
to compare/hash `getOffset()`. Commit `6385494bcfd7` on `main` (merged `ed90a4e96a76`).
Lit test: `llvm/test/CodeGen/Z80/branch-folder-mcsymbol-offset-247.ll`.

Also root-fixes **pi CSE/branch-fold miscompile (B15)** — same mechanism. A/B verified.

Upstream generic-LLVM bug filed as `ravn/llvm-project#1` (held for explicit go-ahead
per `feedback_explain_before_filing`). CSE is still off by default but can be revisited.

**How to apply:** if CSE is turned back on, first verify that `ravn/llvm-project#1`
is accepted upstream (or the fix is in our fork's main). The trigger no longer exists
once `MO_MCSymbol` offset comparison is correct.

## Original investigation (archived)

Branch Folder (`llvm/lib/CodeGen/BranchFolding.cpp`) has an unsound
cross-block hoist that miscompiles `bench_pi.c` at clang -Oz, but only
when MachineCSE is also enabled (CSE collapses a forward-only prelude
block in a way that creates the trigger MIR shape: two adjacent
equivalent `LD_nnind_DE` stores in bb.0, followed by a multi-pred
successor bb.1 whose other predecessor leaves DE with a different
value).  Toggle `-mllvm -disable-branch-fold` alone, with CSE on,
restores correctness.

**Why:** the user-directed disposition 2026-06-09 was to park the bug
and ship the CSE-off mitigation rather than wait on an upstream fix:
- Production builds are NOT exposed (CSE is off by default in the
  fork; the trigger MIR shape only forms with CSE on).
- Trigger is Z80-SPECIFIC in practice: `LD_nnind_DE` is a Z80 instruction;
  the trigger MIR shape has not been shown to arise on any official LLVM
  target. BranchFolding.cpp being target-agnostic code does NOT make this
  a generic-LLVM bug — it would need a reproducer on an official target
  first. Correct routing: ravn/llvm-z80 (or llvm-z80/llvm-z80 upstream),
  NOT llvm/llvm-project. The prior classification as "generic-LLVM" was
  wrong (corrected 2026-09-21).
- The full root-cause writeup, reducer pointers, and per-pass MIR
  bisection notes are checked in at
  `llvm-z80/tasks/session-2026-06-09-pi-cse-miscompile-investigation.md`.

**How to apply:**
- Do NOT re-investigate the pi miscompile in future sessions unless
  the user explicitly asks to revisit it — the root cause is named
  and documented.
- If a future session considers flipping `-z80-enable-cse` default
  back to TRUE: first check whether the Branch Folder bug has been
  fixed upstream (or whether the trigger MIR shape has changed in
  this backend); the bug is still active as of 2026-06-09 LLVM HEAD.
- If asked about the CSE-off size cost (autoload +21 B, cpnos +7 B,
  BIOS +8 B), the answer is: it stays until either (a) upstream fix
  for branch-folder, or (b) a Z80-specific mitigation that breaks
  the trigger MIR shape without disabling CSE altogether.
- The `EnableMachineCSE` cl::opt in `Z80TargetMachine.cpp` is the
  escape hatch — opt-in for measurement/probes, NEVER default ON
  until the upstream bug is fixed.

Related: [[feedback_revalidate_historical_compiler_claims]] (this
investigation was prompted by the cascading-revalidation lesson —
re-running the full corpus after #23 retirement was what surfaced
the pi FAIL the same day).

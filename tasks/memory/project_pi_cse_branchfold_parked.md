---
name: project-pi-cse-branchfold-parked
description: Pi miscompile (Branch Folder unsound hoist, exposed by MachineCSE) is a KNOWN BUG, parked 2026-06-09. Production NOT affected. Mitigation = CSE off by default.
metadata:
  type: project
---

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
- Upstream filing is generic-LLVM (branch-folder is target-agnostic),
  so it belongs at `llvm/llvm-project`, not the fork — per HARD rule
  `feedback_upstream_routing_two_targets`.  Filing requires per-filing
  go-ahead per HARD rule `feedback_explain_before_filing`; the user
  did not authorize filing in this session.
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

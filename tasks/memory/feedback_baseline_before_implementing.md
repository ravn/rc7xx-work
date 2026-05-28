---
name: feedback_baseline_before_implementing
description: "HARD — capture the control measurement on the unmodified system BEFORE changing code, not after"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 90439589-e8b2-4e34-94a8-798e56731341
---

HARD: Before implementing any change measured by a comparison (test-runner
fail-set, binary sizes, T-states, lit counts), capture the baseline on the
**unmodified** compiler/system FIRST. A delta needs both endpoints.

**Why:** Reconstructing the "before" after the fact (git stash, rebuild, rerun)
is slow and error-prone, and you may not be able to get back to a clean baseline
at all. Session-ix (2026-05-26): jumped straight to implementing IX un-reserve,
then had to stash+rebuild to reconstruct the test-runner baseline; user caught it
("you have found baselines before, why didn't you this time before you started?").

**How to apply:** The moment a task is "change X and see if it helps/regresses,"
the first action is to run the measurement on HEAD-unmodified and save the
numbers (e.g. `/tmp/<thing>_baseline.txt`). Only then make the change. Generalises
[[feedback_ab_before_blaming_test_runner]] from reactive (A/B after a surprise
failure) to proactive (control captured before touching anything). Lives in
AGENTS.md "Verification & commit discipline" as "Baseline before you change."

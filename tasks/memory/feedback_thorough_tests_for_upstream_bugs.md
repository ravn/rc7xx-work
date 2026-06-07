---
name: thorough-tests-for-upstream-bugs
description: Every bug submitted upstream needs a very thorough test case — matrix coverage, not just a minimal repro
type: feedback
---
**HARD RULE (user 2026-06-07): all bugs to be submitted upstream need very thorough test cases.**

**Why:** A minimal repro proves existence; a thorough matrix proves the *boundary* of the bug and protects the eventual fix from over- and under-restriction. The #160/#165 icmp-narrowing soundness bug is the template case: the shipped lit tests only ever used masked (provably-narrow) graph values, so the unsound configuration was simply never represented.

**How to apply (template = the #160/#165 test set, 2026-06-07):**
- **Two layers**: a lit test pinning the IR-level transform decision (CI gate) AND a runtime fixture executing real values (value oracle) — per the existing compiler-change discipline, both, not either.
- **Matrix the dimensions**: every admitted predicate/opcode class x every code path x operand sides x boundary values (fits-exactly / one-bit-over / wrap-around) — not one representative.
- **Negatives AND positives**: cases that must NOT transform (the bug) and cases that must STILL transform (guard against over-fixing), plus controls for adjacent sound paths.
- **Self-checking expecteds**: compute expected values via a transform-immune reference at full width inside the fixture — never hand-computed constants ([[feedback_no_mental_arithmetic_in_fixtures]]).
- Failing-test-first: the thorough set is written and observed failing BEFORE the fix ([[feedback_test_before_fix]]).

Related: [[feedback_explain_before_filing]] (the test set is part of what gets explained), `feedback_compiler_bug_test`.

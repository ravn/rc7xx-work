---
name: No mental arithmetic in test fixtures
description: HARD RULE — never hand-compute expected values for non-trivial arithmetic (XOR, shifts, multi-step folds, multi-iteration loops); use a tool, a parallel reference, or trivial-by-inspection math
type: feedback
originSessionId: de6f9865-d9ee-4776-abd2-c579088d6b91
---
When writing a test fixture whose expected value involves non-trivial
arithmetic, do NOT compute that expected value in your head and assert
it.  Mental computation of XOR / shift / fold-style arithmetic across
multiple iterations is unreliable; the assertion becomes an untested
computation with the same bug rate as the code under test.

**Why:** 2026-05-05 — wrote `test_98_bss_spill_pointers.c` and
`test_99_bss_spill_lifo.c` with a `fold(acc,v) = (acc<<1) ^ v` over a
4-iteration loop, then hand-computed the expected output and asserted
it.  The math was wrong by elementary XOR errors (claimed `468 ^ 20 =
480` when it's `448`; claimed `32 ^ 40 = 56` when it's `8`).  Both
tests failed on the known-good compiler not because of any miscompile
but because my asserted ground truth was broken.  The harness caught
it because it's a value oracle, but if I'd claimed "tests pass"
without actually running them I'd have shipped broken fixtures.

**How to apply:** when writing test fixtures, the expected value MUST
come from one of:

  (a) **Trivial-by-inspection** — small-integer addition, fixed
      constants, single-step ops.  If a competent reader can verify
      the answer in one glance with no scratch paper, this is fine.

  (b) **Tool-computed** — drop the expected value into Python or run
      it through the compiler itself, paste the output.  Never trust
      mental XOR or multi-step shift arithmetic.

  (c) **Self-checking** — compute the same thing two different ways
      inside the test (a register-light reference path and the
      pressure-prone path-under-test) and compare them; the test
      passes iff they match.

This is the same anti-pattern as the `make mame-test` confusion in
the #74 RCA: asserting verification without actually verifying.  The
HARD RULE in `feedback_no_commit_first_version.md` covers source
changes; this entry covers fixture construction.  Same root cause:
treating an unverified mental computation as ground truth.

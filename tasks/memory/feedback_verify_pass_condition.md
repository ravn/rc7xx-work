---
name: verify-pass-condition
description: "HARD — when a test prints PASS, verify the PASS condition matched what you intended to test BEFORE accepting it. Treat a green test as a hypothesis, not a result. Cross-check elapsed time against plausibility, scan post-test artefacts for evidence each setup step actually ran, and never reach for a workaround until you've explained why the un-workarounded path fails."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6bb2377c-77ab-4014-8339-b92776bcffc5
---

**Rule:** A test that prints `PASS` has only proven that **its PASS
condition was reached**, not that the system did what you intended.
Before accepting green, verify the PASS condition is the right
condition — the one that actually exercises the code under test, not
a degenerate path that satisfies the assertion trivially.

**Why this rule exists:**

Bitten in session 2026-05-18.  I wrote a test
`cpnet/polypascal_pio_test.sh` to exercise the rcbios CP/NET PIO
path under a PolyPascal workload.  Test "PASSed" in 4.55 s and I
committed it.

Reality:

- `$$$.SUB` records execute BOTTOM-UP in CCP (last record runs first).
  My SUB was `rec('CPNETLDR') + rec('LOGIN') + rec('NETWORK') +
  rec('PPAS')`.  So `PPAS` ran first — against pure CP/M, with
  PPAS+PRIMES staged on local A: as a "workaround" for the H: hang
  I hadn't understood.
- The inject script saw the PRIMES output, declared PASS, exited.
- `CPNETLDR`, `LOGIN`, `NETWORK` ran AFTER, with errors ("CP/Net
  is not loaded"), but the test was already done.
- **CP/NET PIO was never actually exercised by the "PASS"ing test.**

Two directly-available signals I ignored:

1. **Time was implausible.**  Earlier interactive PPAS loads over
   CP/NET had taken 5+ s on their own.  A "PASS in 4.55 s for the
   whole CP/NET-loaded PolyPascal sequence" was physically too fast.
   I noted the number and moved on.
2. **The post-test artefact contradicted the PASS.**  `siob.raw`
   showed the stage-4 prompt was `A>`, and the SUB sequence
   `CPNETLDR / LOGIN / NETWORK / ...` appeared AFTER the PASS line
   in the inject log timeline.  Both showed the workload ran on
   local A: before CP/NET even loaded.  I had both files open.

A third clue was sitting unused:

3. **A working reference example was five lines from where I was
   writing the bug.**  `cpnet/run_test.sh`'s SUB construction is
   `rec('DIR H:') + rec('NETWORK') + rec('LOGIN') + rec('CPNETLDR')`
   — CPNETLDR LAST, runs first.  I didn't look.

Compounding error: when the "drive change hangs" diagnosis appeared,
I reached for a workaround (stage PPAS locally) instead of
investigating why H: rejected.  User's "if you have no idea what
the problem is, stop and investigate" was the rule I needed.

**How to apply:**

When a test prints PASS, before believing it:

1. **Cross-check elapsed time against plausibility.**  Estimate how
   long the workload SHOULD take from first principles (file sizes,
   wire baud, library load times, ...).  If green is faster than
   that estimate, the test is almost certainly short-circuiting.
2. **Scan post-test artefacts for setup-step evidence.**  For
   multi-stage tests, every prerequisite step (drive mounts, login,
   file loads) should leave a trace in the log/screen/wire capture.
   Look for each, in the order you intended.
3. **Trust contradictions.**  If two observations contradict your
   mental model, STOP.  Don't squint past the contradiction.  Both
   observations can't be right under the same model — one of them
   is correct and your model is wrong.
4. **Workarounds require an explanation.**  If you reach for "stage
   X locally because remote X hangs," state out loud: do I
   understand why the remote path fails?  If not, the workaround
   may hide the real bug AND introduce a false-positive.
5. **Look for a working reference example before inventing one.**
   For test harnesses, the surrounding directory often has another
   test that does the same setup correctly.  Read it first.

**Discriminator — when this rule applies:**

- Any new test target you write where PASS is signalled by a
  pattern-match in a log file (CP/NET tests, MAME wire scrapes,
  smoke harnesses, polypascal-style injectors).
- Any test where setup happens via SUB-file / autoboot script
  rather than interactive driving — execution order is easy to
  mis-model.
- Any test where you've reached for a workaround during setup
  without understanding the failure being worked around.

**Discriminator — when this rule does NOT apply:**

- Pre-existing tests that the user has already validated end-to-end
  on their own.  You're allowed to trust those without re-deriving.
- Tests with strict cryptographic / checksum equality (cmp, sha1
  match).  False positive there requires the artefact itself to
  collide, which is the test's purpose.

**Cross-references** — same general failure class:

- [[feedback-diff-binaries-before-blaming-codegen]] — same shape
  in a different direction: A says X, B says Y, the data on disk
  proves one or the other.
- [[feedback-verify-writes-before-chasing-reads]] — verify the
  setup step before debugging the downstream symptom.
- [[feedback-compilers-agree-means-harness]] — surprising green
  result with two compilers in lockstep = harness flake, same
  "don't trust the result, check the path" instinct.

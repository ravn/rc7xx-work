---
name: dig-deeper-before-parking
description: When an investigation hits something surprising, dig one level deeper before declaring "deferred / requires multi-week work". The deeper layer is often a much smaller fix than the surface estimate.
metadata:
  type: feedback
---

When an investigation surprises me — a miscompile, a peephole not
firing, a cost-hook prediction proven wrong — the first reflex
should be **instrument or bisect**, not "park" or "defer".

Five instances of this pattern in session 73p (2026-05-22) alone:

1. **#177 Phase B bundle miscompile** — first reflex: park #177.
   User redirect: "fix bugs correctly".  Bisect in ~1 h isolated
   the cause to ONE LINE of the bundle (i16=2 cost).  3 of 5
   hook overrides shipped.

2. **#173 first MVP "doesn't fire on AES"** — first reflex:
   declared Path A scoped wrong, abandoned.  User redirect:
   "reinvestigate thoroughly".  Programmatic catalog showed 11
   real candidates in different shape.  Same-MBB peephole
   shipped with measured 12 B AES + 1 B cpnos + 3 B BIOS yield.

3. **#184 stale liveins safety check** — would have parked at
   "isRegDeadAfter is unreliable post-regalloc".  Drilled
   instead: 17-line fix in `targetDeadA` walks the fall-through
   MBB explicitly + XOR_A self-clear exception.

4. **#185 "regalloc spill bug, multi-week work"** — declared
   regalloc-level, multi-week.  Drilled deeper: **5-line peephole
   fix** in `Z80LateOptimization.cpp`.  The DJNZ peephole was
   missing a safety check, not regalloc.

5. **i16=2 ship/don't-ship decision** — would have agonized.
   Measured all four production targets in 5 minutes.  Clean
   tuning call (sizes net-negative, kept off).

The pattern: **the surface estimate (multi-week, regalloc-level,
deep IR work) is usually wrong by 10×-100×**.  One more
instrumentation/bisect/measure cycle (15-60 min) often turns the
intimidating problem into a small targeted fix.

**Why:** ravn/llvm-z80 is unfinished.  Most bugs are not in
upstream LLVM's mature infrastructure but in this fork's recent
additions.  Recent additions tend to have shallow bugs (missing
safety check, wrong opcode list, off-by-one in a guard) that look
deep at first glance because they manifest as miscompiles or
non-firing optimizations.

## When to apply

Whenever about to declare "deferred / multi-week / requires
upstream-LLVM work / regalloc-level / etc.":

1. **Pause.** Ask: "what would I actually do in the next 30
   minutes if I kept going?"
2. **Instrument or bisect.** Add `errs() <<` logging.  Run a
   smaller test case.  Cut the change in half and measure.
3. If 30 minutes of focused drilling still leaves the bug
   genuinely multi-week, THEN park.  But that conclusion needs
   evidence, not just a hunch.

## What to avoid

- "This needs regalloc work" (#185 false estimate).
- "Phase E retired; #128 workaround stays indefinitely" (only
  true after Phase A grep evidence, not as a pre-emptive park).
- "Bundle introduces miscompile, park the feature" without
  bisecting first.
- "Path A doesn't fire" without cataloging what shape the real
  pattern has.

## How to apply

When stuck:
1. Reach for the oracle (AES corpus, lit suite, MAME boot).  ~1
   minute round-trip.
2. Reach for instrumentation (`errs() << ...` in the relevant
   peephole / pass).  ~5 minutes.
3. Reach for bisection (cut the change in half, rebuild, measure).
   ~15 minutes per cycle.

These tools collapse "multi-week regalloc work" into "five-line
peephole fix" in dozens of cases.

## Cross-references

- [[feedback_state_certainty]] — sister: don't assert what you
  haven't measured.
- [[feedback_no_commit_first_version]] — sister: don't ship what
  the oracle hasn't validated.
- [[feedback_root_cause_over_peephole]] — sister: prefer upstream
  fixes when feasible, but the upstream fix is often itself a
  small peephole, not the multi-week work it first appears to be.

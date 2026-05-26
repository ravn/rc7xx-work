---
name: feedback_audit_oracle_not_just_fix
description: "HARD — a bug found by luck is a bug in your oracle; when a bug is found by accident / buried in noise / is the Nth of a class, design the detector that would have caught it on purpose"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 90439589-e8b2-4e34-94a8-798e56731341
---

HARD. Complement to [[feedback_zoom_out_on_recurring_pattern]]: that rule says
"find the systemic CAUSE" when fixing the Nth instance. This one says **also find
the systemic DETECTOR.** Apply zoom-out to the *oracle*, not just the fix.

**Trigger conditions — when ANY of these is true, stop and ask "what oracle would
have caught this deliberately?":**
- A bug was found *by accident* (stumbled on it, not by a test designed to find it).
- A real failure was sitting in an *accepted-failures / noise-floor bucket*
  unexamined (diffed-against instead of driven to zero).
- It's the 2nd–3rd of a class and each instance still needed a hand-written test
  *after* discovery.

**Slogan:** *a bug found by luck is a bug in your oracle.*

**Why:** Fixing the instance leaves the detection gap open — the next instance of
the class is also found by luck (or not at all). The oracle is the thing that
makes finding deliberate.

**How to apply:** When the data already shows the bug's signature, look for the
*invariant* hiding in it, not just the per-instance fact. Session 73s/#202:
I wrote "O0_ss=0x0080 but O1+_ss=0x00FF" repeatedly and treated each as "this test
is broken at O0," never abstracting the shape into "opt levels disagreeing is a
free, general bug detector — and the harness already runs all opt levels." The
user asked "are the oracles good enough?" and the cross-opt-level **differential
oracle** (`test-runner -diff-opt`: every opt level of a program must return the
same value; disagreement = miscompile, independent of the `expect` directive) fell
out in one step and instantly caught #202, test_15, and surfaced test_28/test_36.
I should have proposed it myself the moment test_54 was found *by luck* in the
accepted-failures bucket. Don't wait to be asked whether the detection is adequate.

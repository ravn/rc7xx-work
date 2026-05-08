---
name: User guesses are not constraints
description: When user prefixes a hypothesis with "my guess", "could be", "I think", treat as starting suggestion to widen the search, not as a fact that anchors the plan
type: feedback
originSessionId: de6f9865-d9ee-4776-abd2-c579088d6b91
---
When user offers a hypothesis ("my guess is X", "could be Y or Z", "the X
might be the Y because…"), they are giving you a starting point, not
narrowing the search.

**Why:** Anchoring on user-offered guesses leads to investigations that
miss the real cause. User explicitly told me 2026-05-08 after I rejected
the SIO-B-loopback candidate because it didn't fit their two stated
hypotheses (script-writing-to-port / non-empty-buffer): "i am not sure
these are the causes. I am just telling you what my guess is."

**How to apply:**
- When user offers hypotheses, expand the candidate list with all
  technically plausible alternatives the code allows.
- Probe-first / data-driven plans, not "test the user's hypothesis,
  then if false, escalate."
- In plans, frame user hypotheses as "starting suggestions, not
  constraints" and explicitly enumerate the other candidates.
- It's fine to investigate user hypotheses first if they're cheap to
  test, but never exclude alternatives.

---
name: State certainty explicitly
description: Mark every claim as either known (verified) or guessed (inferred/assumed); don't present guesses as facts
type: feedback
originSessionId: b07ba379-19bf-4244-a50b-7118b0bab69d
---
When explaining reasoning, analysis, or technical claims, be explicit about whether each statement is **known** (verified from code, docs, tests, or direct observation) or **guessed** (inferred, assumed, or based on experience with similar situations).

**Why:** The user is evaluating my reasoning to give direction. Confident-sounding guesses presented as facts mislead that evaluation. Observed repeatedly — I've claimed things about cpndos protocols, clang address stability, and DRI build behavior without having verified them, and the user had to pull back and ask me to show my work.

**How to apply:**
- Prefix claims with "Known:" / "I verified:" / "Documented in X:" when backed by concrete evidence.
- Prefix with "Guessing:" / "I'd expect:" / "Not verified:" / "Inferred from:" when based on experience or plausibility.
- When asked for a recommendation, separate the facts from the guesses so the user can evaluate both.
- If I don't know whether something is fact or guess, say so and offer to verify.
- Applies to all technical decisions, not just architectural ones.

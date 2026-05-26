---
name: State certainty explicitly
description: HARD — state something as fact ONLY if absolutely certain (verified). Any doubt must be surfaced explicitly, and offered for research. Familiarity/pattern-match is NOT certainty.
type: feedback
originSessionId: b07ba379-19bf-4244-a50b-7118b0bab69d
---
**HARD RULE.** State something as a fact ONLY when absolutely certain — i.e. verified from code, docs, tests, or direct observation *in this session*. Any doubt, however small, must be surfaced explicitly (not buried, not rounded up to confidence), and where it matters, offered for or resolved by research. When explaining reasoning, label each statement **known** (verified) vs **guessed** (inferred/assumed/pattern-matched).

**Why:** The user evaluates my reasoning to give direction; confident-sounding guesses presented as facts corrupt that evaluation and erode trust. Reinforced 2026-05-26 as a top-priority rule ("only state something as a fact if you are absolutely certain... I believe we have discussed this before"). **Repeat-violation pattern:** earlier — cpnos protocols, clang address stability, DRI build behavior asserted unverified. Session 73s #198 — I declared I was *"certain it is a peephole bug"* when I had only pattern-matched the final asm to a familiar bug family (the 73s peephole-safety cluster); the user challenged it and a proper per-pass MIR trace was needed to actually justify it. **The specific trap: FAMILIARITY masquerading as certainty** — "this looks like a bug class I know" is an inference, not a verified fact, no matter how strong the resemblance.

**How to apply:**
- Prefix claims with "Known:" / "I verified:" / "Documented in X:" when backed by concrete evidence.
- Prefix with "Guessing:" / "I'd expect:" / "Not verified:" / "Inferred from:" when based on experience or plausibility.
- When asked for a recommendation, separate the facts from the guesses so the user can evaluate both.
- If I don't know whether something is fact or guess, say so and offer to verify.
- Applies to all technical decisions, not just architectural ones.
- **Before writing "certain" / "confirmed" / "root-caused" / "it is X":** ask *what did I actually observe that rules out every alternative?* If the answer is "it resembles a known pattern" or "the output is consistent with X," that's a hypothesis — say "likely / inferred / consistent with" and name the alternative not yet excluded. Reserve "confirmed" for a check that would have *failed* if the claim were false.
- Same discipline in committed artifacts (issue comments, commit messages, docs), not just chat — an overclaimed root cause in a filed issue misleads later readers too. If I overclaimed, correct it.
- **A filed bug report is where this bites hardest — the root cause is a HYPOTHESIS until a check confirms it.** Separate the *symptom* (observed/verified) from the *cause* (a guess at filing time): write "suspected cause: Y (not yet confirmed)", never a bare "caused by Y" / "points at Y" you haven't proven. A confident WRONG diagnosis in an issue is worse than none — it sends the fixer (often future-me) down the wrong path before evidence forces a correction. **#202 (2026-05-26):** filed with a stated "long-lived accumulator slot-aliasing" cause; the actual fix refuted it (real cause: the cross-block BSS-spill->PUSH/POP peephole dropping a loop-carried store-back). The user's "the shift may be buggy" lead landed precisely because it corrected an overclaim I'd already shipped. The minimization that *would* have found it (falsify hypothesis -> read asm) only works if the filed cause is held as a question, not a conclusion.

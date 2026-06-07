---
name: file-bugs-not-fixes
description: HARD — when engaging upstream maintainers we file BUGS, not FIXES; our role is bug analyst (smallest repro, current vs expected, root cause, evidence — no patch), the maintainer decides how to fix; user must understand each bug well enough to defend it in the resulting discussion
type: feedback
---
**User directive 2026-06-07:**

> "I do not want our fixes included in z80 upstream.  I want the
>  maintainer to agree that this is an actual bug and discuss how
>  to fix it.  I must understand each of them."

**Why this exists.**  The session-77 retraction at `llvm-z80/llvm-z80#17`
was partly a routing miss but also an authorship miss — we filed proposed
fixes alongside the bugs, putting the maintainer in a "merge our patch or
reject the whole thing" posture instead of a "is this a bug?" posture.
The fix-author posture also forces the user to defend implementation
choices they didn't make, which doesn't end well per
[[feedback_explain_before_filing]].  Filing bugs-only repositions us as
analysts, and the maintainer's discussion of how to fix is the *outcome
we want*, not the work we hand over pre-decided.

**The bug-analyst checklist** (every upstream-bound filing satisfies all):

1. **Smallest repro** that triggers the misbehavior.  Target-independent
   IR if possible; otherwise the most generic target.
2. **Current behavior**, shown in the audience's terms — IR-level + asm.
3. **Expected behavior**, with the *principle* that makes it expected
   (consistency with another pass, conformance to a documented invariant,
   etc.).
4. **Root cause**, specific to a line/file/decision (e.g. "expression
   walker bails before reaching the safety machinery because Argument
   isn't an Instruction — TruncInstCombine.cpp:95-105").
5. **Evidence it's wrong**, not just suboptimal.  Cross-target / cross-
   compiler measurements ([[feedback_avr_density_oracle]]) or appeals to
   internal consistency.
6. **NO proposed fix.**  At most: "the principle suggests X family of
   approach", but the structural patch design is the maintainer's call.

**Items that are NOT bugs by this discipline** — don't file them as such:

- "This pass pessimizes on tiny register files" — that's a missing
  feature (target-aware cost gate); RFC territory, not a bug.
- "Z80 select lowering is expensive after this fold" — that's our
  backend's job, not the mid-end's.
- "Our fork's #163 extension regresses on Z80" — that's our extension,
  not upstream's bug.

If we want the cost-gate kind of change, it's an RFC + design discussion
sequence, not a "file as bug" sequence.

**The user must understand each before filing.**  Process:

- I walk through repro → current → expected → root cause → evidence with
  the user, pushing the IR and asm into view.
- The user asks until they can defend the bug claim themselves.
- Then [[feedback_explain_before_filing]]'s "go ahead per filing" gate
  fires.  Not before.

**Cross-listed**:
- [[feedback_explain_before_filing]] (per-filing go-ahead gate)
- [[feedback_no_upstream_issues]] (default: file in ravn/* forks)
- [[feedback_thorough_tests_for_upstream_bugs]] (matrix-grade test cases)
- [[feedback_upstream_routing_two_targets]] (generic vs Z80-specific routing)
- [[project_z80_upstream_goal]] (staged collaboration model)

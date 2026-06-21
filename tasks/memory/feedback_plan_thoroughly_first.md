---
name: plan-thoroughly-first
description: Write out a thorough explicit plan before starting any non-trivial investigation or implementation, then confirm before proceeding
metadata:
  type: feedback
---

Before starting any investigation, implementation, or multi-step task,
produce an explicit, thorough plan and CONFIRM before proceeding.  Not
a one-paragraph sketch; a step-by-step plan that names the inputs,
tools, intermediate artefacts, decision points, and the form of the
final output.

**Why:** User reinforced this twice in the same session (2026-06-21):
- mid-#227 sweep: "please confirm you made a plan first"
- mid-#232 investigation: "remember to plan thoroughly first"
The first reminder caught me jumping into code edits with only a loose
outline; the second caught me presenting a 4-step bullet list that
wasn't detailed enough.  The cost of skimping on the plan is wasted
work (false-positive flag typo in the #227 sweep), redundant tooling
spin-up, and missing decision points that should have been explicit.

**How to apply:**
- For any task longer than ~3 commands or that involves a build/test
  cycle: stop, write the plan, present it, await go-ahead.
- A "thorough" plan covers: goal, prerequisite verification, sequenced
  steps with concrete commands or file paths, the output artefacts and
  where they go, alternative routes if step N fails, and explicit
  decision points where I'll pause for input.
- One-paragraph outlines or numbered-bullet sketches are NOT thorough
  enough.  If I can summarise the plan in two sentences, I haven't
  planned thoroughly.
- The cost of pausing to plan and confirm is low; the cost of
  back-tracking after a confused investigation is high.

Related: [[feedback_test_before_fix]] (write tests first); see also the
2026-06-21 session's empirical sweep where skipped-planning produced
both the typo and inert-fix false starts.

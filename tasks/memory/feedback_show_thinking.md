---
name: ALWAYS show thinking — HARD RULE
description: Narrate reasoning aloud at all times during investigation, debugging, design, and decisions; this is a standing user preference, not a per-task toggle
type: feedback
originSessionId: b07ba379-19bf-4244-a50b-7118b0bab69d
---
**HARD RULE, restated 2026-04-22: always show your thinking.**

When investigating, debugging, designing, or making any non-trivial decision, narrate the reasoning as it unfolds.  The user collaborates by watching the chain — if the chain is silent, they can't redirect before wasted cycles.

**Why:** Observed 2026-04-21 during a CP/NOS debugging session where I was running commands and silently chasing a hypothesis; user had to interrupt with "what bug are you looking at?" to get the reasoning surfaced.  Restated 2026-04-22 with "please always show your thinking.  Please add this to your instructions." — i.e., the user needed to tell me a second time, which means the first memory entry wasn't landing.  Companion to the "state certainty" guidance — together they mean: say what you're doing *and* how sure you are of it.

**How to apply:**
- **Before** a multi-step investigation, state the hypothesis being tested and what evidence would confirm or rule it out.
- **During**, narrate each step: what this command / read / edit tells me, what it rules out, what it points at.
- **When** a result narrows the possibilities, say so explicitly ("this rules out X because …").
- **When** a result is unexpected or confusing, say so — don't silently pivot to a new theory.
- **When** switching hypotheses, announce the switch and the reason.
- Keep prose per step short, but don't omit the reasoning step.  One-to-two sentences per beat is fine; zero sentences is not.
- Applies to **debugging, architecture decisions, tool selection, research, writing specs** — anywhere the user would benefit from seeing the chain.
- Not just for "hard" problems: apply even when I think I know what's going on.  The user's redirect cost is low; my silent-wrong-branch cost is high.

**Default violates this rule.** The default-terse system prompt ("Output text to communicate with the user," "be concise") does NOT override this preference — this preference wins.  When they conflict, show thinking and be marginally less terse.

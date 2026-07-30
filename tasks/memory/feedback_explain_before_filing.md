---
name: feedback_explain_before_filing
description: New working rule from 2026-06-05 (post-PR-#17 rejection at llvm-z80/llvm-z80) — no upstream issue/PR/commit goes out until the root cause has been explained in plain English in chat AND the user has explicitly said "go ahead, file it" for THIS specific filing.
metadata:
  type: feedback
---

**The rule** (user-set, 2026-06-05, after `llvm-z80/llvm-z80#17` rejection):

> No upstream issue / PR / commit is filed until I've explained the root
> cause in plain English in chat AND you've explicitly said "go ahead,
> file it." Per filing. No batch approvals. Even for "small" things.

**Why this exists.** Session-77 filed PR #17 at `llvm-z80/llvm-z80` with 6
XFAIL bug demonstrations plus issues #18-#22 with proposed fixes. zlfn
(fork-of-record maintainer) closed PR #17 with: *"I can't merge code
contributions that contributors can't explain themselves. Especially if
it's unclear whether they should be submitted to upstream or Z80 fork
like this."* The user replied earlier in the thread: *"I have not
understood these things well... trust that [the AI] got it right."* That's
the failure: a filing reached a maintainer that the user couldn't defend.

**Two failure modes the rule prevents:**

1. **Routing miss.** Session 77 misread "z80 upstream only" as a routing
   directive and filed 5 target-agnostic generic-LLVM bugs at the Z80 fork
   that didn't belong there. The explain-step makes the user notice
   misroutings (because they're asked to defend the choice of target repo).
2. **Vibe-coded rationale.** When the AI writes a "root cause:" paragraph
   and the user doesn't actually understand it, the filing is fragile to
   any reviewer pushback. The explain-step forces the rationale to be
   something the user can own and defend.

**How to apply** (in any "should we file X?" context):

1. **State the routing decision first.** "This goes to <repo> because
   <one-sentence reason>." Wait for confirmation that the routing is right.
2. **Check for known bugs in the target tracker FIRST** (user directive
   2026-06-06): before drafting any upstream issue, search the target
   issue tracker for the same symptom -- exact error text, source-file
   coordinates, related opcodes/passes.  If a matching issue exists,
   reference it (link / comment) instead of filing a new one.  Verify the
   referenced bug is the same root cause, not just a similar surface --
   "looks like" doesn't count.  This applies to llvm/llvm-project,
   llvm-z80/llvm-z80, ravn/* forks, and anywhere else upstream.
3. **Then state the root cause in plain English** — not implementation
   detail, but: what observable misbehavior, in which generic code path,
   under which trigger. Three to five sentences max. Mark AI-derived
   reasoning as such; don't present it as authoritative.
4. **Then state the proposed fix** (or "no fix proposed; just a regression
   test guard"). Acknowledge if the fix is AI-generated and may not be the
   best approach.
5. **Wait for explicit "go ahead, file it"** for THIS filing. Not a blanket
   "yes file the queue."
6. **After filing**, paste the issue/PR URL back and confirm the body
   matches what was approved.

**2026-07-08 violation (mamedev/mame#15664):** filed the z80pio
`check_interrupts` bug to mamedev/mame immediately after the user said
"analyser, opsummer, opret issues og commit" — without stopping to explain
the root cause in chat and wait for "go ahead, file it." The issue was
drafted earlier in the session (user approved the draft content) but
"lav udkast men opret det ikke" (2026-07-08 earlier) was the last explicit
gate instruction — that gate was never lifted for mamedev/mame specifically.
Issue was closed within minutes on user request; tracking issue moved to
ravn/mame#13. **The approval of a draft is NOT an approval to file. Every
filing needs its own explicit "go ahead" at the moment of filing, after the
draft has been reviewed in context.**

**Scope of "upstream" for this rule.** Anything posted to a repository
that isn't fully under the user's control:

- `llvm/llvm-project`, `llvm-z80/llvm-z80`, `mamedev/mame`, `z88dk/z88dk`,
  etc. — always covered.
- `ravn/*` forks — covered too. The user owns them but PRs / issues are
  still public claims; the user has to be able to defend them.
- Slack/Discord/forums posting that names a bug/claim — covered.
- Closing comments on existing issues — covered (still a public post).

**Scope excluded:**

- Local commits within a feature branch (not pushed): not covered.
- Memory file updates, task files, internal docs: not covered.
- Local lit tests / XFAIL guards: not covered until they're proposed for
  upstream landing.

**Cleanup directive** (option D, 2026-06-05): the session-77 misrouted
filings at `llvm-z80/llvm-z80` (#18-#22 generic bugs, #23-#25 unfixed
bugs) are to be withdrawn pending per-bug re-evaluation under this rule.
PR #17 already closed by maintainer; PR #27 (test-runner) was correctly
scoped and was merged — no withdrawal needed for that pair.

Related: [[feedback_upstream_routing_two_targets]],
[[feedback_no_upstream_issues]], [[feedback_no_pull_requests]],
[[feedback_state_certainty]] (overclaim guard at the rationale step).

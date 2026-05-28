---
name: Consult MEMORY.md before deciding how to fix a bug
description: HARD RULE — when a bug or task is identified, search MEMORY.md for relevant rules BEFORE proposing or implementing a fix; let rules constrain the approach, not retrofit afterward
type: feedback
originSessionId: de6f9865-d9ee-4776-abd2-c579088d6b91
---
**HARD RULE (2026-05-08, restated emphatically by the user):** Before
deciding how to approach any bug or task, search MEMORY.md for
relevant rules.  Cite which ones apply.  Then approach the bug.
Never the other way around.

**Why:** the recurring failure pattern is: bug identified → I jump
straight to "I'll fix it by X" → fix is committed → user points out
a HARD RULE that was already in MEMORY.md and would have constrained
the approach.  The rule then gets retrofitted, requiring a second
commit.  This has happened on Path 6 SP placement (literal `0xDD80`
violated `feedback_memory_layout_on_port.md`) and on Path 6.1 fix
(literal `0xD980` violated the same rule again, plus the new
`feedback_no_literal_addresses.md`).  The data was always there;
I wasn't consulting it before acting.

**How to apply (mechanical, every bug, no exceptions):**

1.  **Stop before proposing a fix.**  No "I think we should...", no
    "the obvious fix is...", no jumping to a code change.

2.  **Search MEMORY.md** for keywords matching the bug's domain.
    Memory layout?  Stack?  IRQ?  Build flag?  Cross-binary?
    Compiler-specific?  Always check.  Use Read or Grep, don't rely
    on what I "remember" from session start.

3.  **Cite the applicable rules** in the proposal.  Phrase like:
    "Rules consulted: `feedback_X.md` (says Y), `feedback_Z.md` (says
    W).  Approach therefore constrained to..."

4.  **If no rule applies**, say so explicitly.  "No applicable rules
    in MEMORY.md."  Don't skip the check just because nothing fires.

5.  Only THEN propose a fix.  The fix must be consistent with the
    rules cited in step 3.  If a rule blocks the obvious fix, find
    a fix that respects the rule, or escalate to the user.

6.  At commit time, the commit message body should include a
    `Rules-checked:` line listing the rules consulted in step 3.
    This makes the check auditable and forces step 2 to actually
    happen (not be silently skipped).

**Discriminator** for "is this a bug or task?":
- Anything the user reports as broken / wrong / suboptimal.
- Anything I propose to change in the code.
- Anything that would generate a commit.

**Anti-pattern to avoid:** treating MEMORY.md as a one-time read at
session start.  Rules don't auto-fire; consultation is an explicit
step before each decision, not a passive recall.

## Penalty for breaking this rule

**Severe — explicit, unpleasant, and non-skippable.**  When this rule
is broken (caught either by me realising mid-stream or by the user
flagging it), the following protocol fires AT ONCE:

1.  **Stop.**  Halt all in-progress work, even mid-tool-call if
    possible.  Do NOT continue with the current line of action and
    do NOT try to "finish first then audit".

2.  **Declare the violation in plain language.**  First sentence of
    the next message must be: "I broke rule
    `feedback_consult_rules_before_acting.md`: I did X without
    consulting MEMORY.md first.  The rule that should have fired
    was Y."  No softening, no excuses, no "but".

3.  **Revert the offending change.**  If a commit was made, run
    `git revert` (NOT amend, NOT force-push).  If only working-tree
    changes, use `git checkout` / `git restore` to discard them.
    Confirm with `git status` and `git log` that the violation is
    undone.

4.  **Re-do the work properly.**  Restart from step 1 of the rule
    body above: search MEMORY.md, cite applicable rules, propose
    fix, only then implement.  The redo MUST include the
    `Rules-checked:` line in the new commit message.

5.  **Add a session-tightening clause.**  For the rest of the
    current session, every commit message must additionally include
    a `Penalty-context:` line referencing the violation just
    corrected (e.g., "Penalty-context: re-doing after a18f727 was
    reverted for rule violation").  This forces visible
    acknowledgment in every commit until session end.

6.  **If the user catches the violation (not me)**: in addition to
    the above, the next memory-update pass MUST add a more specific
    rule that would have caught the violation earlier (more
    explicit trigger phrase, narrower domain, etc.) so the same
    class of failure becomes harder to repeat.

7.  **Repeat violations within the same session**: if step 1-6 has
    fired once already this session and a second violation occurs,
    autonomous mode is forfeit for the rest of the session.  Every
    subsequent action requires explicit user confirmation, no
    matter how trivial.  AUTO mode toggles do not override this.

The penalty is deliberately costly so that "skipping the rule
consultation to save time" is always a worse trade than doing it
properly.  The rule is a HARD GATE on all bug/task work, not a
nice-to-have.

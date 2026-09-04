---
name: feedback_replicate_user_pr_text_verbatim
description: When the user has revised a PR/issue description and asks to open an identical one upstream ("magen til"), copy their body verbatim — never re-draft it.
metadata:
  type: feedback
---

2026-09-04. The RC7xx→MAME upstreaming flow is deliberately two-stage: open a
DRAFT PR on the user's own fork (ravn/mame) so the user can write the human
description, THEN open an identical PR against mamedev/mame. When moving
osd/sdl #52 upstream (mamedev/mame#16056), I wrote a fresh "clean, mamedev-
appropriate" body from the diff instead of copying the user's already-revised
fork-PR body. The user: "du flyttede ikke min reviderede tekst over" and
"hvorfor kopierede du ikke det af dig selv?".

**Why:** The whole point of the fork-draft stage is that the PR *prose* is the
user's — their voice, their framing, their AI-disclosure wording. "Magen til"
(an identical one) means the description is carried over verbatim. Substituting
my own text overrides their curation and defeats the workflow.

**How to apply:** When creating the upstream twin of a fork-draft PR/issue,
pull the source body verbatim (`gh pr view <n> --json body -q .body` →
`gh pr create/edit --body-file`) and use it unchanged. Do NOT re-draft from the
diff. Code/branch may differ (rebased, cleaned); the human description does not.
If part of their body looks unintended for the public target (e.g. an appendix
they labelled dismissively), flag it and ask — don't silently trim or rewrite.

Related: [[feedback_explain_before_filing]].

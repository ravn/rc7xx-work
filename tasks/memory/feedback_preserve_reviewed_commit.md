---
name: feedback_preserve_reviewed_commit
description: On a PR under review, keep the reviewed commit as-is and add follow-ups; do not squash
metadata:
  type: feedback
---

On an open PR that has already received review comments, the reviewed commit
must stay a **separate, byte-identical commit (same SHA)**; post-review changes
go into **one new commit on top**. Do NOT squash the reviewed commit together
with the follow-up.

**Why:** reviewer inline comments anchor to a specific commit+line. Keeping the
original SHA lets GitHub re-anchor the comments (they show as resolved/current,
not "outdated"); squashing orphans them. The user reminded me of this twice in
one session (mamedev/mame PR #15805) after I wrongly squashed to a single commit.

**How to apply:** to update such a PR, `git reset --soft <reviewed-commit-SHA>`
(keeps all later changes staged), then make one new commit with all post-review
work, then `git push --force-with-lease`. Confirm with `gh pr view <n> --json commits`
that the reviewed SHA is still commit #1. Exception: only squash if the user
explicitly asks. The reverse can also happen ("fjern commit fra pr" — drop the
follow-up while still iterating), so always confirm the desired commit count.
Writing the review-thread reply (with AI disclosure) is the user's task, not mine.

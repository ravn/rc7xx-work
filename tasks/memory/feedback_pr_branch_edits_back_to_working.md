---
name: feedback_pr_branch_edits_back_to_working
description: When rebuilding PR branches with cleaned-up commits, also apply those edits back to the working branch (local/cpm86 or equivalent).
metadata:
  type: feedback
---

When I rebuild PR branches (shorten comments, remove noise, squash), the cleaned-up code must also be applied back to the working branch (`local/cpm86` or equivalent).

**Why:** PR branches are cherry-picks from the working branch. If I only fix comments/code in the PR branch and not in the working branch, the two diverge — the working branch still carries the old verbose version, and future cherry-picks bring the noise back.

**How to apply:** After finishing a PR branch cleanup, diff the PR branch against its upstream base and apply any editorial changes (shorter comments, removed dead code) back to the working branch via `git commit --amend` or a follow-up fixup commit. Do this before switching away from the context.

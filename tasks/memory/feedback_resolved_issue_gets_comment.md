---
name: feedback-resolved-issue-gets-comment
description: When discovering a repo issue has been resolved by a commit, post a comment on the issue documenting the fix (with explicit go-ahead first)
metadata:
  type: feedback
---

When investigation reveals that an open issue in a project repo (e.g.
ravn/llvm-z80) has already been resolved by a specific commit, record
that finding as a **comment on the issue** so the knowledge is captured
where future readers will look.

**Why:** Verbal reporting in chat is ephemeral; the issue stays open
indefinitely without visible provenance, and the next person to search
"CP (HL)" or whatever will not find the resolution. The commit SHA +
observed output (lit test, measured codegen) belongs on the issue
timeline. Stated by user 2026-10-11.

**How to apply:**

1. Confirm the fix: cite the resolving commit SHA and show the before/
   after codegen (or lit test) proving the pattern now holds.
2. Draft the comment in chat first with the commit reference, test
   coverage, any flags required to trigger (e.g. `-disable-lsr`), and
   remaining caveats.
3. Ask for explicit per-issue go-ahead before posting — the
   [[feedback_no_pull_requests]] + [[feedback_no_external_issues]]
   HARD rules still apply. "I'll post this comment: … OK?"
4. Only after the user agrees, use `gh issue comment <N> --body "..."`.
5. If the fix is complete and the user agrees, close the issue in the
   same step. If partial, leave open with a note on what remains.

Routing follows [[feedback_upstream_routing_two_targets]]: Z80-specific
goes to ravn/llvm-z80, generic LLVM goes to llvm/llvm-project.

**Scope:** This applies when the fix is unambiguous (test pins the new
behavior). For heuristic observations ("looks better now"), investigate
further first — don't close on a vibe.

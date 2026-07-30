---
name: Comment on issue when fix is committed
description: After committing a fix for a tracked issue, immediately post a comment on the issue with the commit hash(es), what changed, verification results, and any remaining notes.
type: feedback
originDate: 2026-06-27
---

When a bug tracked in a GitHub issue is fixed (or partially fixed) by a commit:

**Do it automatically — no prompt needed.**

Post a comment on the issue using `gh issue comment <num> --repo <repo> --body-file <file>` immediately after the fix commit lands. Do not wait for the user to ask.

**The comment must include:**

1. **Commit hash(es)** — short hash + one-line summary for each relevant commit (the XFAIL-test commit if there was one, and the fix commit).
2. **What changed** — which files, which lines, what the change was (concise, not a re-paste of the diff).
3. **Verification** — lit test result (XFAIL→PASS or new PASS), suite totals (e.g. "176 PASS + 6 XFAIL, no regressions").
4. **Remaining suboptimality / future work** — if the fix is correct but not yet optimal, say so and what the follow-on is.
5. **Attribution line** — per `feedback_issue_attribution_line.md`:
   ```
   ---
   _Filed by GitHub Copilot on behalf of @ravn._
   ```

**When this fires:**
- After any commit whose message contains `Fixes:`, `Closes:`, or an issue number (`#NNN` matching a known open issue).
- After any fix to a bug that was filed as a GitHub issue this session, even if the commit message doesn't cite it explicitly.

**Scope:** applies to all repos under `ravn/*`.

**Cross-listed:** `feedback_explain_before_filing.md`, `feedback_issue_attribution_line.md`.


---
name: test-before-fix-for-issues
description: Always create a failing test before implementing a fix for GitHub issues
metadata: 
  node_type: memory
  type: feedback
  originSessionId: b20efbb1-10f2-452a-bfa2-432a9ba5a6a3
---

For GitHub issues, always create an appropriate test that demonstrates the bug BEFORE writing the fix. The test should fail without the fix and pass with it.

**Why:** Ensures the fix actually addresses the bug and prevents regressions. User has reinforced this twice (sessions 36 and 70) — they care about the discipline, not just the end result.

**How to apply:**
1. Write the lit/integration test that captures the bug (RED).
2. Run it against unpatched build to confirm it FAILS for the right reason.
3. Implement the fix.
4. Run the test again to confirm it PASSES (GREEN).
5. Re-run unrelated test suite for regressions.

This is RED-GREEN-REFACTOR.  If you find yourself thinking "the existing repro is good enough, I'll skip the lit test" — that's the trigger to stop and write the lit test first.  An empirical repro in /tmp or a sibling repo is NOT a substitute for an in-tree test.

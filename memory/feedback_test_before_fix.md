---
name: Test before fix for issues
description: Always create a failing test before implementing a fix for GitHub issues
type: feedback
---

For GitHub issues, always create an appropriate test that demonstrates the bug BEFORE writing the fix. The test should fail without the fix and pass with it.

**Why:** Ensures the fix actually addresses the bug and prevents regressions.

**How to apply:** Write the lit test or integration test first, verify it fails, then implement the fix and verify the test passes.

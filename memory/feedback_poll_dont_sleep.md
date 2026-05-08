---
name: Poll for output, don't long-sleep
description: When waiting on background processes, poll their output/exit instead of sleeping a conservative fixed duration
type: feedback
originSessionId: 5b9c19fb-ae78-45c7-b86e-c8b8135e5b92
---
When a background task (MAME run, test harness, build) has a known termination signal — a log line, a PASS/FAIL marker, a pid exit — poll for it with short tight loops instead of sleeping 20-30 seconds "to be safe."

**Why:** Long fixed sleeps waste real time, especially when the task finishes in 5s. User explicitly called this out.

**How to apply:**
- Prefer `until grep -q PATTERN file; do sleep 1; done` over `sleep 30 && tail file`.
- For Bash tool: use `run_in_background: true` + check output periodically, or pair with a short-interval `until` loop checking for the expected marker (PASS/FAIL/"done"/exit-code file).
- For tests that self-terminate, rely on the exit of the foreground command rather than an outer timeout; only use a wall-clock ceiling as an emergency kill (e.g. `kill` after expected-time + 50% slack).
- 60s timeouts inside Python bridges are fine (they're defensive, non-blocking if the expected event fires first). The problem is the outer shell sleep.

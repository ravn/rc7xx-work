---
name: token-efficiency-disciplines
description: Three standing disciplines to cut token burn — filtered tool output, background long runs, handoff + fresh session per work item
type: feedback
---
**HARD RULE (user 2026-06-06): the user works multiple projects in parallel and has hit token limits repeatedly. Three disciplines apply at all times in this project.**

**Why:** Every turn re-sends the whole conversation; a raw log pasted once is paid for on every later turn. Long single sessions are the dominant burn; raw tool output is second.

**How to apply:**

1. **Filtered tool output — never let raw logs into context.**
   Builds, lit, test-runner, AES sweeps, MAME runs: redirect to a file, bring only a summary into context (`tail -5`, `grep -c`, the PASS/FAIL line). On failure, read only the failing slice (grep with small `-A/-B`), never the whole log. `llvm-lit -q`; test-runner summary line; MAME logs grepped, not read.

2. **Background long builds/runs.**
   Full ninja builds, AES corpus sweeps, polypascal runs go to background tasks (`run_in_background`); check the result once at completion instead of streaming output into the conversation.

3. **Handoff + fresh session per work item.**
   At each work-item boundary, write/refresh `tasks/handoff/YYYY-MM-DD-slug.md` (extends [[feedback_cross_machine_workflow]]) and tell the user this is a good point to start a fresh session. A ~1k-token handoff beats dragging dead context through the next work item.

Related: [[feedback_show_thinking]] (tiered narration, amended same day), `feedback_zoo_fast_first` + `feedback_integration_tests` (oracle cost discipline), `feedback_poll_dont_sleep`.

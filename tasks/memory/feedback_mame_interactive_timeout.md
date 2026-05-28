---
name: MAME interactive timeout
description: Interactive MAME launches for user inspection need only ~30s timeout, not the Bash default 2min or long waits
type: feedback
originSessionId: b07ba379-19bf-4244-a50b-7118b0bab69d
---
Interactive MAME runs (mame-maxi, cpnos-interactive, plain `regnecentralend rc702 -window ...`) only need a ~30 second Bash timeout, not 2+ minutes.

**Why:** The user closes the MAME window as soon as they've seen what they want. Longer timeouts mean the Bash call sits idle after the window is already gone, delaying the next turn. If MAME runs longer than 30s the user intends to keep it open — they'll say so.

**How to apply:** When launching MAME for human visual inspection (no `-seconds_to_run`, no autoboot script that exits), set `timeout: 30000` on the Bash call. For automated tests with `-seconds_to_run N` set timeout to N*1000 + ~10s slack.

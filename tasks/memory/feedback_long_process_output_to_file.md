---
name: Long-running processes -> redirect output to a file, report progress from it
description: For any long/slow command (builds, MAME runs, benchmarks), write output to a log FILE and summarize progress by reading it; do not rely on tail/streaming.
metadata:
  type: feedback
---

**User directive (2026-08-15):** when starting a long-running process, save its
output to a **file** (e.g. `cmd > /tmp/foo.log 2>&1`) instead of tailing/
streaming it, so progress can be reported back from the file.

**Why:** the user wants to be told about progress on long jobs; a file lets me
poll/read the current state at any point and summarize how far it got, and it
survives across turns and background completion.

**How to apply:**
- Redirect stdout+stderr of long commands to a named log file.
- Run the job in the background (harness `run_in_background`, or nohup + a tracked
  waiter that exits when the job's PID exits so the harness notifies me).
- Report progress by `Read`-ing / `grep`-ing the log (last built target, current
  phase, error markers), not by re-running the job or streaming.
- Prefer the harness-tracked background over a bare `nohup &` so completion is
  auto-notified (a detached nohup needs a separate tracked waiter — see the OW
  root build 2026-08-15).

Related: `[[feedback_watch_slow_commands]]`.

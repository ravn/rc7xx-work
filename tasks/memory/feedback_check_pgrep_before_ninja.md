---
name: feedback_check_pgrep_before_ninja
description: Always run pgrep before starting a new ninja/make build — empty output file does NOT mean build not started
metadata:
  type: feedback
---

ALWAYS run `pgrep -f "ninja.*build"` (or `pgrep -f "make"`) before starting any new build. If it returns a PID, the build IS running — do NOT start another.

**Why:** Background task output files start empty and fill gradually. An empty file means "nothing written yet", not "not started". Mistaking empty-file for not-started caused three concurrent ninja builds on the same directory — a HARD RULE violation that can corrupt the build.

**How to apply:** The check must happen in the SAME response as the new-build decision:
```bash
pgrep -f "ninja.*build-macos" | wc -l
# If output > 0: wait for task-notification, do NOT start another build
# If output == 0: proceed with new build
```

Also: background task notifications (task-notification) are the correct signal to wait for — ScheduleWakeup polling loops that check output files are unreliable and lead to this mistake. See [[feedback_never_concurrent_or_kill_builds]].

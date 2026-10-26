---
name: feedback_builds_optimized_with_progress
description: User wants every build script optimized as far as possible (ccache, parallelism) AND showing live progress; background output is invisible to them
metadata:
  type: feedback
---

User (2026-10-26): "remember to optimize the builds as much as you can, and show progress" and repeatedly "show progress" while builds ran in the background.

**Why:** output of a Claude background task is not streamed to the user, so a progress line printed by a script is invisible; they also kept asking for status during hour-long builds.

**How to apply:**
- New build wrapper scripts source `scripts/build-progress.sh` (progress line + `<log>.progress` file) and use ccache + `-j$(nproc)`; tell the user the `watch -n2 cat scratch/tmp/<log>.progress` command.
- When asked "show progress", read the `.progress` file and the task output, report step count/percent and the current file; say plainly when a file is stale from an earlier run.
- NEVER edit a bash script that is currently running in place (bash reads it incrementally): edit a copy in scratch/tmp and `mv` it over.
- Only one build at a time; chain builds in one background command (`;`-separated) instead of starting parallel ones. See [[project_rebuild_scripts_2026-10-26]].

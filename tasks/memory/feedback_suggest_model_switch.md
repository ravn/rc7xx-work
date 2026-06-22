---
name: feedback_suggest_model_switch
description: Proactively tell the user when switching to a different model (Opus vs Sonnet) would be beneficial for the current task
metadata:
  type: feedback
---

Tell the user when the current model is a poor fit for the task at hand, before starting.

**Why:** User wants to be informed so they can switch — they don't want to discover mid-session that they were on the wrong model for the work.

**How to apply:**

- On **Sonnet** (current default): flag when the task would benefit from Opus:
  - Open-ended bug analysis with no existing repro or root-cause pointer
  - Multi-file audit sweeps (e.g. "find all sites where pattern X might occur")
  - Architectural / planning decisions spanning multiple passes or files
  - `/bug-analyst` skill invocations
  - Any task where "hold a lot of ambiguous context and reason across it" is the bottleneck

- On **Opus**: flag when the task is purely mechanical and Sonnet would be faster/cheaper:
  - Well-defined patch with an established fix pattern (e.g. mirror #210 IMPLICIT_DEF in site N)
  - Running commands, reading specific files, writing a targeted lit test
  - Anything where the root cause is already documented and the steps are clear

One sentence is enough: "This is open-ended analysis — Opus would handle it better" or "Sonnet is fine for this; it's a targeted patch."

---
name: feedback_suggest_model_switch
description: Proactively tell the user when switching to a different model (Opus vs Sonnet) would be beneficial for the current task
metadata:
  type: feedback
---

**STANDING RULE (user 2026-09-08): be attentive to token cost AT ALL TIMES, not just at task start — never burn an unnecessarily expensive model (Opus) on work a cheaper one can do.** Tell the user when the current model is a poor fit for the task at hand, before starting AND whenever the character of the work shifts mid-session (e.g. analysis finished, now it's mechanical patching).

**Why:** User works multiple projects in parallel and pays per-model; an idle Opus session doing mechanical edits is pure waste. They want continuous vigilance, not a one-time check.

**Cheaper-model offload:** when on Opus and a chunk of work is mechanical/well-scoped, prefer spawning a **Sonnet subagent** (Agent tool, `model: sonnet`) for it rather than doing it on Opus yourself — reserve Opus for the review/judgement. (Done 2026-09-08: Opus reviewed the crt0 BSS-fix plan, a Sonnet subagent implemented it.) Only spawn when the user asks or the work is clearly delegable; see the parent-agent spawn guidance.

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

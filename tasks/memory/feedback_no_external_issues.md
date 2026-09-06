---
name: feedback_no_external_issues
description: Aldrig opret issues (eller PRs) i eksterne repos uden eksplicit go-ahead per issue
metadata:
  type: feedback
---

Opret aldrig issues eller pull requests i **eksterne repos** (f.eks. z88dk/z88dk, llvm-z80/llvm-z80, llvm/llvm-project) uden eksplicit go-ahead per issue/PR fra brugeren.

**Why:** 2026-09-06: Claude oprettede tre issues i z88dk/z88dk (upstream) under et "lav issues"-kald. De var ikke sletbare (kun lukkbare med "opened by mistake"). Brugeren var direkte imod det — "det må du aldrig gøre".

**How to apply:** Selv når brugeren siger "lav issues for hver gruppe", skal issues oprettes i ravn-forks (ravn/z88dk, ravn/llvm-z80) som interne tracking-issues — ALDRIG i upstream repos. Upstream-filing kræver per-issue go-ahead OG at brugeren skriver introteksten selv. Se også [[feedback_explain_before_filing]] og [[feedback_upstream_routing_two_targets]].

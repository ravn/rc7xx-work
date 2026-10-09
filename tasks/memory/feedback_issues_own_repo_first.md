---
name: feedback-issues-own-repo-first
description: Issues skal oprettes på ravn/* repos, ikke upstream, medmindre brugeren eksplicit beder om upstream
metadata:
  type: feedback
---

Opret altid issues på brugerens eget repo (ravn/*) — ALDRIG direkte upstream uden eksplicit go-ahead i den pågældende tur.

**Why:** Brugeren blev sur da et issue blev oprettet på z88dk/z88dk i stedet for ravn/z88dk (2026-10-08). Upstream-issues kræver samme eksplicitte tilladelse som upstream PRs.

**How to apply:** Når brugeren siger "lav et issue" uden at specificere repo → opret på ravn/* fork. Spørg hvis usikkert.

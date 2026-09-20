---
name: monitor-ci-checks
description: HARD — Hold øje med CI-checks efter push til PRs; de indikerer reelle problemer i integrationen.
type: feedback
originDate: 2026-09-20
---

**User directive (2026-09-20):**

> "fakta: hold øje med CI-checks. De indikerer problemer."

**Why this exists:**
Local tests may run against a specific local environment or configuration (e.g., macOS vs Ubuntu, local ccache vs clean container, specific tool versions). CI-checks on upstream repos run the full matrix and runtime oracle. A failure in CI indicates real problems that must be monitored and resolved, not ignored.

**How to apply:**
1. After pushing to a PR branch, monitor CI checks using `gh pr checks <PR_NUM>` or `gh run watch`.
2. If any check fails, do not assume it is a transient infra failure — inspect the failure log promptly and diagnose the root cause.

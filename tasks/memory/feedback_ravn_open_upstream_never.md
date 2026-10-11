---
name: feedback-ravn-open-upstream-never
description: Acting in ravn/* repos (push, comment, close, PR, force-push) is permitted without per-action go-ahead; upstream repos NEVER
metadata:
  type: feedback
---

**The rule (stated by user 2026-10-11):**
> "du må gerne gøre ting i mine egne repositories, men aldrig upstream"

**ravn/\* (user's own forks and workspace):** OK to act directly.
- Push to branches
- Open/close issues
- Post issue + PR comments
- Create draft PRs ([[feedback_upstream_prs_always_draft]] still applies — ALL PRs must be `--draft`)
- Force-push to feature branches (never main)
- Merge feature branches to main (follow `--no-ff`)
- Already-filed-issue housekeeping (labels, close-as-resolved with evidence per [[feedback_resolved_issue_gets_comment]])

**Upstream (everything that isn't ravn/\*):** NEVER without explicit "ja post" this turn.
Includes but not limited to: llvm/llvm-project, z88dk/z88dk, mamedev/mame, durgadas311/*, suborb/*, Microsoft/*. Routing per [[feedback_upstream_routing_two_targets]].

**Why:** Reduces chat friction for low-blast-radius work in the user's own namespace. Previously every ravn/* push and comment required a "ja post" confirmation ([[feedback_upstream_review_local_first]] in strict interpretation; MEMORY.md §0 formulation). The 2026-09-29 incident that spawned that rule was about a non-ravn/* PR (suborb/#3158), so the strict reading was broader than the underlying lesson required.

**How to apply:**
- Default to acting directly in ravn/* when the task calls for it.
- Pause and ask only when: (a) the action touches a non-ravn/* repo, OR (b) the ravn/* action is destructive (`git reset --hard`, force-push to main, delete branches with un-merged work) — then the general destructive-action rule kicks in regardless of namespace.
- When in doubt whether a repo is ravn/* owned: check with `gh repo view <repo> --json owner` or look at the git remote URL.

**Scope note:** `ravn/mame-rc702-rc759-rc750` is user's fork (ravn/\*). Upstream `mamedev/mame` is not. Same for z88dk — `ravn/z88dk` yes, `z88dk/z88dk` no.

**Supersedes the strict reading of:** [[feedback_upstream_review_local_first]]
(the lesson there — reviewer feedback on an external PR must be shown
to user before being pushed — still holds for non-ravn/* work).

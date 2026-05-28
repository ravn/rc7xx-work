---
name: Never create pull requests
description: Hard rule — never ever create pull requests, in any repo, under any circumstances, unless the user explicitly says "create a PR" for that specific repo+change in the current turn.
type: feedback
originSessionId: efdb3b3d-4a3c-4567-bf8a-683190b84206
---
Never create pull requests. Not in upstream repos, not in ravn/* fork repos, not in local repos. Ever.

**Why:** User has stated this as an unconditional rule multiple times across sessions — most recently as "never ever create pull requests" when I was only planning to file GitHub issues and run `gh --version`. Even approaching PR-adjacent territory triggers an interrupt. The user wants to decide when and how changes get proposed upstream, not the assistant.

**How to apply:**
- `gh pr create` is forbidden unless the user's current-turn message literally asks for a PR on this specific change.
- `git push` to any branch whose name hints at PR intent (e.g. `feature/...`, `fix/...`) requires explicit per-turn authorization even if the user has granted general push access earlier.
- Filing GitHub **issues** (`gh issue create`) is different and remains allowed in ravn/* fork repos when the user has asked for tasks/issues to be created — the no-PR rule does NOT extend to issues.
- Committing locally and pushing to an already-tracked branch is OK when the user asks for "commit" — that's not a PR.
- If a workflow seems to naturally want a PR at its end (build fix → PR → merge), STOP at the commit and let the user create the PR manually.
- If in doubt, ask before doing anything that could plausibly result in a PR.

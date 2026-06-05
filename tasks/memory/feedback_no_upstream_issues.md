---
name: Never file UNSOLICITED issues in upstream repos
description: Never file upstream issues on own initiative. Even when the user directs a curated submission, the new explain-before-filing rule (2026-06-05, post-PR-#17 rejection) applies per-issue.
type: feedback
---

Never create GitHub issues in upstream repositories **on your own initiative**.
By default, bugs go in the user's own fork (`ravn/llvm-z80`,
`ravn/rc700-gensmedet`, etc.).

**Why:** Unsolicited upstream filing creates noise for maintainers and is
embarrassing. This happened on 2026-03-27 (issues #8/#10/#11/#14 accidentally
filed upstream) and again in session 77 (2026-06-01) — PR #17 at
`llvm-z80/llvm-z80` was rejected (2026-06-05) because 5 of its 6 demonstrations
were target-agnostic generic-LLVM bugs that didn't belong at the Z80 fork (see
[[feedback_upstream_routing_two_targets]] for the routing correction).

**Engagement-mode (user-directed curated submission)** — still possible but
much more disciplined post-session-77:

1. **Routing first** ([[feedback_upstream_routing_two_targets]]): is the bug
   generic-LLVM (-> `llvm/llvm-project` candidate, or local XFAIL only) or
   Z80-specific (-> `ravn/llvm-z80`)? `llvm-z80/llvm-z80` is reserved for
   bugs/fixes whose **target is the Z80 backend itself**. Do NOT file generic
   bugs at `llvm-z80/llvm-z80` — that was session 77's misroute.
2. **Explain-before-filing** ([[feedback_explain_before_filing]] — the new
   rule, 2026-06-05): for EACH filing, lay out the root cause in plain
   English in chat, wait for the user's explicit "go ahead, file it" for
   THIS specific filing. No batch approvals. No "I'll file these 6". One at
   a time, each defended.
3. **Defendability**: the user has to be able to explain the bug in their
   own words after approving. If they can't, the filing isn't ready — keep
   refining the explanation until it's something the user owns. zlfn's
   2026-06-05 close on PR #17 was explicit: *"I can't merge code
   contributions that contributors can't explain themselves."*
4. **Don't bundle**: one PR per bug (or none at all, just an issue). The
   session-77 6-bug bundled PR was unreviewable — bundling forced zlfn into
   an all-or-nothing decision he was right to reject.
5. **Cross-link downstream** issue when an upstream-or-fork issue exists.
6. **Fully-qualify cross-repo refs** as `ravn/llvm-z80#NNN` /
   `llvm-z80/llvm-z80#NNN` / `llvm/llvm-project#NNN` so numbers aren't
   misread.

**How to apply:**
- Default (no explicit direction): `gh issue create --repo ravn/<repo>`,
  never an upstream org.
- With explicit user direction: route per (1), then for each filing do (2),
  (3), (4).
- Still NEVER file at official `llvm/llvm-project` without separate explicit
  authorization for THAT filing (see [[feedback_no_pull_requests]]).

---
name: Never mention zlfn in any of ravn's own repositories
description: Never mention zlfn — by name or @-handle — in ANY of ravn's own repositories (issues, PRs, comments, commit messages, committed files). Hard rule.
type: feedback
originDate: 2026-09-09
---

**HARD RULE (user, 2026-09-09): never again mention zlfn in ANY of ravn's own
repositories** — not as `@zlfn`, not as plain-text "zlfn", not in issues, PRs,
comments, commit messages, or committed files (plans, docs, memory that gets
pushed).

Origin: @zlfn asked (ravn/llvm-z80#311 comment 5595080798) not to be @-mentioned
because it bombards him with GitHub alerts; the user then broadened it to a total
no-mention rule across all of ravn's repos.

Applies to every repo ravn owns: `ravn/llvm-z80`, `ravn/rc700-gensmedet`,
`ravn/z88dk`, `ravn/mame-rc702-rc759-rc750`, the workspace repo, etc.

**How to apply:**
- Never write "zlfn" or "@zlfn" in anything that lands in one of ravn's repos.
- Refer to him instead as **"the fork owner"** / **"the fork-of-record owner"**
  (or "upstream fork maintainer") when a reference is unavoidable.
- Before committing a file or filing an issue/PR/comment, grep the body for
  `zlfn` and remove it.
- The attribution line [[feedback_issue_attribution_line]] names `@ravn` only, so
  it is fine.
- Chat replies to ravn in this session are not a repo and are unaffected, but
  prefer "the fork owner" out of habit.

Related collaboration rules: [[feedback_explain_before_filing]] (#77 PR
retraction), [[feedback_upstream_routing_two_targets]].

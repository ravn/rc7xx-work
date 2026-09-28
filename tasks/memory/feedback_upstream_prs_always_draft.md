---
name: Upstream pull requests must always be draft
description: Hard rule — ALL pull requests must always be created as draft (--draft), no exceptions.
type: feedback
---
**ALL** pull requests must **ALWAYS** be a draft / kladde (`gh pr create --draft`). No exceptions — not for ravn/*, not for upstream, not for "small" changes.

**Why:**
- 2026-09-20: "fakta: når du laver pr's mod upstream skal de altid være kladde/draft"
- 2026-09-28: PR #3159 (z88dk/z88dk) åbnet som non-draft — eksplicit korrektion: "altid altid altid!"

PRs must remain drafts until the human reviewer/author explicitly marks them ready for review.

**How to apply:**
- Always pass `--draft` to `gh pr create` regardless of target repository.
- If a PR was accidentally created as non-draft, immediately convert it to draft with `gh pr ready <pr> --undo --repo <repo>`.

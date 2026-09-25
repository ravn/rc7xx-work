---
name: Upstream pull requests must always be draft
description: Hard rule — whenever creating a pull request against an upstream repository (e.g. llvm-z80/llvm-z80), it must always be created as draft (--draft).
type: feedback
---
Whenever creating a pull request against an upstream repository (such as `llvm-z80/llvm-z80`), it must **ALWAYS** be a draft / kladde (`gh pr create --draft`).

**Why:**
Stated by user 2026-09-20 ("fakta: når du laver pr's mod upstream skal de altid være kladde/draft"). Upstream PRs are subject to public maintainer scrutiny and must remain drafts until the human reviewer/author explicitly marks them ready for review.

**How to apply:**
- Always pass `--draft` to `gh pr create` when targeting any upstream repository.
- If a PR was accidentally created as non-draft, immediately convert it to draft with `gh pr ready <pr> --undo --repo <upstream-repo>`.

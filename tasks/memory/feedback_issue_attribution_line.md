---
name: Add attribution line to filed issues
description: Every GitHub issue filed by the AI on behalf of the user must end with a standard attribution line.
type: feedback
originDate: 2026-06-27
---

Every issue filed via `gh issue create` (or edited via `gh issue edit`) must include the following attribution line at the very end of the body, after a `---` separator:

```
_Filed by GitHub Copilot on behalf of @ravn._
```

This applies to all target repos (`ravn/llvm-z80`, `ravn/rc700-gensmedet`, any upstream, etc.).

**How to apply:**
- When writing the body file (`/tmp/issue_*.md`), append the separator and attribution line before running `gh issue create`.
- If an issue was filed without it (e.g. this rule didn't exist yet), edit it immediately with `gh issue edit <num> --body-file ...`.

**Example tail of every issue body file:**

```
...last paragraph of issue content...

---
_Filed by GitHub Copilot on behalf of @ravn._
```


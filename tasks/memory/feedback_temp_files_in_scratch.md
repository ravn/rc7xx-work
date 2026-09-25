---
name: temp-files-in-scratch-never-tmp
description: HARD — All temporary files (issue bodies, intermediate diffs, trial scripts) must be written inside the workspace (e.g. scratch/ or scratch/tmp/), NEVER in /tmp. /tmp triggers security confirmation prompts from the client.
type: feedback
originDate: 2026-09-20
---

**User directive (2026-09-20):**

> "kan du ikke lave midlertidige filer i projektet så jeg ikke bliver spurgt hver gang om du må?"

**Why this exists:**
Paths outside the workspace (like `/tmp/`) trigger IDE / client sandbox security prompts asking the user for permission on every file creation and command execution. Using a path inside the workspace (specifically `<workspace>/scratch/tmp/` or `scratch/`) stays inside the authorized workspace boundary, executing smoothly without annoying the user with confirmation dialogs.

**How to apply:**
1. **NEVER** write temporary files to `/tmp/` (e.g. `/tmp/issue_*.md`, `/tmp/pr_*.md`, `/tmp/foo.txt`).
2. **ALWAYS** use `<workspace>/scratch/` or `<workspace>/scratch/tmp/` for temporary files:
   - Issue/PR markdown bodies: `scratch/tmp/issue_body.md`
   - Intermediate outputs and dumps: `scratch/tmp/...`
3. Ensure `scratch/tmp` directory exists before writing (`mkdir -p scratch/tmp`).
4. Clean up temporary files in `scratch/tmp/` after use.

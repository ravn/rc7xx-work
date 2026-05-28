---
name: Memory files canonical in repo, symlinked from .claude
description: Memory files live in /Users/ravn/z80/memory/ (version-controlled). The .claude/projects/.../memory path is a symlink for runtime auto-load. Never write to a non-symlinked .claude location.
type: feedback
---

Canonical memory files live in `/Users/ravn/z80/memory/` — version-controlled, transfers to other clones of the project.

`/Users/ravn/.claude/projects/-Users-ravn-z80/memory/` is a **symlink** to `/Users/ravn/z80/memory/` so Claude Code's auto-memory runtime continues to find MEMORY.md and the entry files at the path it expects.

**Why:** the user wants memory to travel with the project, not live as host-local state in `~/.claude`.  Symlink + canonical-in-repo gives both: runtime auto-load works, and `git clone` brings the rules with the code.

**How to apply:**
- Read/Write/Edit memory files via either path — both resolve to the same files (the runtime path is the symlink).  Prefer writing via the runtime path `/Users/ravn/.claude/projects/-Users-ravn-z80/memory/foo.md` so the system-prompt instructions match what executes.
- Never recreate a real directory at `/Users/ravn/.claude/projects/-Users-ravn-z80/memory/` — it must remain a symlink.  If `ls -la` shows a regular directory there, the symlink was clobbered; restore it.
- General project notes (todos, session reports, investigation logs) still belong in `tasks/` / `CLAUDE.md` / `docs/` per the original rule — `memory/` is reserved for the auto-loaded behavioral-rule + project-fact entries indexed by `MEMORY.md`.
- New clones bootstrap by recreating the symlink — see `/Users/ravn/z80/memory/README.md`.

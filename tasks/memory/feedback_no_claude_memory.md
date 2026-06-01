---
name: Memory lives in tasks/memory/, never ~/.claude/
description: Durable memory files are canonical in tasks/memory/ (version-controlled, read manually at session start). Never write memory to ~/.claude/.
metadata:
  type: feedback
---

Durable memory files are canonical in `tasks/memory/` (index: `tasks/memory/MEMORY.md`), version-controlled so `git clone` brings the rules with the code.

**Why:** the user wants memory to travel with the project, not live as host-local state in `~/.claude/`. (Migrated out of `~/.claude/` on 2026-05-28 after a preference was wrongly saved there by following the harness default.)

**How to apply:**
- Read `tasks/memory/MEMORY.md` at the start of every session — the harness no longer auto-injects it, so reading it is a deliberate step (see `CLAUDE.md`).
- Record new durable notes as a `tasks/memory/<type>_<topic>.md` file plus a one-line index entry in `tasks/memory/MEMORY.md`.
- The harness offers a default file-memory dir under `~/.claude/.../memory/` and its system prompt may tell you to use it. That default is **OVERRIDDEN**: never write there. Before recording any durable note, confirm the destination is inside this project.
- General project notes (todos, session reports, investigation logs) belong in `tasks/` / `CLAUDE.md` / `docs/`; `tasks/memory/` is reserved for behavioral-rule + project-fact entries indexed by `MEMORY.md`.

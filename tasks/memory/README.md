# Project memory for Claude Code

This directory is the **canonical, version-controlled** location for the workspace's durable memory rules and project facts. It was migrated here from `~/.claude/` on 2026-05-28, per the "persistent notes in the project, never `~/.claude/`" rule.

## How it works

The harness no longer auto-injects this memory. `CLAUDE.md` directs Claude Code to **read `tasks/memory/MEMORY.md` at the start of every session** as a deliberate step. The canonical files live here in git, so cloning the repo brings the memory with it. Never write memory to `~/.claude/`.

## Files

- `MEMORY.md` — the index. One line per memory entry, grouped by the moment the rule fires. Read this at session start.
- `feedback_*.md` — behavioral rules: communication style, debugging discipline, what NOT to do, etc.
- `project_*.md` — project facts: hardware constraints, design decisions, external-bug refs.
- `user_*.md` — user-profile facts.
- `reference_*.md` — pointers to external systems / tooling.

## What's NOT in memory (lives in the repo)

Project-specific info is documented in the repo, not in memory entries:

- Project goal / architecture — `CLAUDE.md` (project root and per-subdir)
- TODOs, deferred items, parked ideas, session notes — `rc700-gensmedet/rcbios-in-c/tasks/`
- Datasheet transcriptions, CP/M naming, tool workflow refs — `rc700-gensmedet/rcbios-in-c/docs/` and `rc700-gensmedet/docs/`
- MAME build and emulation — `rc700-gensmedet/docs/MAME_RC702.md`
- cpmtools usage — `rc700-gensmedet/rcbios-in-c/README.md` and `SYSGEN_INSTALL.md`
- z88dk Docker rebuild — `rc700-gensmedet/docs/z88dk_docker_rebuild.md`
- PROM 2 KB limit — `rc700-gensmedet/RC702_HARDWARE_TECHNICAL_REFERENCE.md`

## Adding a memory

1. Write the entry to its own `<type>_<topic>.md` file with frontmatter (name / description / metadata.type — see existing files for shape).
2. Add a one-line pointer to `MEMORY.md` under the appropriate section.
3. If it's a HARD rule, bold the entire index entry (`- **[Title](file.md) — HARD: ...**`).

## Removing a memory

1. Delete the `.md` file.
2. Remove its line from `MEMORY.md`.

## Constraints

- Memory entries are **point-in-time observations**. File:line references and code claims decay — verify against current code before trusting.
- This is a **flat directory** — no subfolders. Organization happens by section in `MEMORY.md`.
- One-liners in `MEMORY.md` should stay readable; the full body lives in the per-entry file.

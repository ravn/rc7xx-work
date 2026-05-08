# Auto-loaded memory for Claude Code

This directory is the **canonical** location for the workspace's auto-loaded memory rules and project facts.  Files here are the same ones Claude Code's per-project memory runtime reads at session start.

## How it works

Claude Code expects memory at `~/.claude/projects/<workspace-key>/memory/`.  For this workspace that's `~/.claude/projects/-Users-ravn-z80/memory/`.  That path is a **symlink** into this directory:

```
~/.claude/projects/-Users-ravn-z80/memory  ->  /Users/ravn/z80/memory
```

The runtime reads `MEMORY.md` (the index) and the individual `.md` entry files via the symlink.  The canonical files live here in git, so cloning the repo brings the memory with it.

## Bootstrap on a fresh clone

If you clone this repo on a new machine (or to a different path), the symlink doesn't exist yet — Claude Code's memory dir is empty until you create it.

```sh
# adjust WORKDIR if your clone path differs
WORKDIR="$(cd "$(dirname "$0")/.." && pwd)"

# Claude Code's per-project memory dir is keyed by the workspace path
# (slashes replaced by dashes, with a leading dash):
PROJECT_KEY=$(echo "$WORKDIR" | tr / -)
TARGET="$HOME/.claude/projects/$PROJECT_KEY/memory"

mkdir -p "$(dirname "$TARGET")"
# remove any pre-existing real directory the runtime created
[ -d "$TARGET" ] && [ ! -L "$TARGET" ] && rm -rf "$TARGET"
ln -sfn "$WORKDIR/memory" "$TARGET"
ls -la "$TARGET"
```

After the symlink is in place, Claude Code's auto-memory loads `MEMORY.md` from this directory on every session start.

## Files

- `MEMORY.md` — the loaded index.  One line per memory entry.  The first ~200 lines are pulled into context automatically.
- `MEMORY-DRAFT.md` — work-in-progress restructure of the index (trigger-grouped, HARD rules bolded).  Not auto-loaded.
- `feedback_*.md` — behavioral rules: communication style, debugging discipline, what NOT to do, etc.
- `project_*.md` — project facts: hardware constraints, design decisions, external-bug refs.
- `user_*.md` — user-profile facts.
- `reference_*.md` — pointers to external systems / tooling.

## Adding a memory

1. Write the entry to its own `<type>_<topic>.md` file with frontmatter (name / description / type — see existing files for shape).
2. Add a one-line pointer to `MEMORY.md` under the appropriate section.
3. If it's a HARD rule, bold the entire index entry (`- **[Title](file.md) — HARD: ...**`).
4. Commit both files together.

## Removing a memory

1. Delete the `.md` file.
2. Remove its line from `MEMORY.md`.
3. Commit both.

## Constraints

- Memory entries are **point-in-time observations**.  File:line references and code claims decay — verify against current code before trusting.
- The runtime treats this as a **flat directory** — no subfolders.  Organization happens by section in `MEMORY.md`.
- One-liners in `MEMORY.md` should stay under ~150 chars; the full body lives in the per-entry file.

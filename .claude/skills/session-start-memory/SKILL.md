---
name: session-start-memory
description: 'MANDATORY first action of every new session, EVERY session resumed from a context-compaction summary or /compact, and before the first investigative or coding tool call of any substantive task in this workspace: read tasks/memory/MEMORY.md (the project memory index), grep tasks/memory/ for the task domain nouns, and read the matching node files. Prevents re-deriving solved problems (3 recorded incidents, incl. the 2026-11-26 compacted-resumption RSP re-derivation). Takes precedence over diving into the handed-off next step. Args: none (optionally the task domain nouns).'
---

# Session-start memory scan

You are at a session boundary. A compaction summary's "next steps" list
is NOT a substitute for this scan — summaries drop exactly the rules that
would have changed the approach. Three recorded incidents (see
`tasks/memory/feedback_check_memory_before_coding.md`).

## Procedure (complete BEFORE any investigative or coding tool call)

1. Read `tasks/memory/MEMORY.md` (the index) in full.
2. Extract the domain nouns of the current task (e.g. `RSP`, `GENCCPM`,
   `rasm86`, `autoload`, `PROM`, `lit`, `regalloc`).
3. `grep -il <noun> tasks/memory/*.md` for each noun; READ every hit
   (they are short). At minimum always check: `MEMORY_PARKED.md`
   (parked-but-relevant threads) and any `reference_*` node matching
   the domain.
4. In your first user-facing response, name the applicable rules in one
   line each: "Applicable: `reference_X` (canonical mechanism for Y);
   `feedback_Z` (constraint on W)."
5. Only then start the actual task.

## Why this is a skill and not just prose in CLAUDE.md

CLAUDE.md/AGENTS.md are injected every turn and still got skipped on a
compacted resumption (2026-11-26) because the resumption prompt pulls
straight into "continue the task". A listed skill is surfaced by the
harness itself and is a mandatory first action when it matches — this
converts the honor-system read into a machine-surfaced one.

## Recording back

If the session produces a durable lesson, add a node file under
`tasks/memory/` + a one-line index entry in `MEMORY.md` (never
`~/.claude/`). If a correction happened, the self-improvement rule
requires writing the lesson before ending the segment.

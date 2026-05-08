---
name: Keep a running project timeline with difficulty markers
description: For rc700-gensmedet, append to tasks/timeline.md after every substantive change — date, phase, what changed, and Easy/Medium/Hard/Painful marker with one-line reason. On reaching a stated goal, produce a narrative summary from it.
type: feedback
originSessionId: b07ba379-19bf-4244-a50b-7118b0bab69d
---
**Rule:** For the rc700-gensmedet project, maintain `tasks/timeline.md` as a
running log.  Every meaningful decision, challenge, or milestone gets an
entry under the current Phase heading.

**Why:**  The user asked explicitly 2026-04-22: "When the project reaches a
goal I want a timeline of decisions and challenges, and what was hard and
easy to do.  I want you to do record keeping from now on."  Without an
always-on log, reconstructing the narrative at goal-time means trawling
git history and session notes — lossy and slow.

**How to apply:**
- Append under the relevant Phase as work progresses, not at session end.
- Each entry: `**YYYY-MM-DD**: one-line description.  **(Easy|Medium|Hard|Painful)**
  brief reason.`
- When a new effort begins that doesn't fit existing Phases, start a new
  Phase heading.
- At phase boundaries or goal milestones, add a "What was Hard vs Easy"
  recap block.
- Key architectural decisions land in the trailing "Key Architectural
  Decisions" table, one row per decision with rationale.
- Tools created go in "Key Tools Created" table.

**Difficulty scale:**
- **Easy** — hours, straightforward, matches prior patterns.
- **Medium** — a focused session; understood after reading docs or one
  round of debugging.
- **Hard** — multi-session, required instrumentation or rearchitecting
  to root-cause.
- **Painful** — silent failure class; wasted time before being caught;
  worth flagging so future work knows what to guard against.

**Backfill policy:** When returning to the file after a gap, derive
missing entries from git history (`git log --oneline --since=...`),
session notes in `tasks/session*.md`, and commit messages.  Don't
re-derive on every session — the log is canonical once written.

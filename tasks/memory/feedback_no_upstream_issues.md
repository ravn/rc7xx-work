---
name: Never file UNSOLICITED issues in upstream repos
description: Never file upstream issues on your own initiative; BUT when the user explicitly directs a curated upstream submission to llvm-z80/llvm-z80, filing there is the directed workflow
type: feedback
---

Never create GitHub issues in upstream repositories **on your own initiative**. By
default, bugs go in the user's own fork (`ravn/llvm-z80`).

**Why:** Unsolicited upstream filing creates noise for maintainers and is embarrassing.
This happened on 2026-03-27 when issues #8/#10/#11/#14 were accidentally filed upstream.

**Engagement-mode exception (session 77, 2026-06-01 — user-confirmed policy):** when the
user **explicitly directs a curated upstream submission** to the z80 fork-of-record
**`llvm-z80/llvm-z80`** (@zlfn), filing issues there IS the directed workflow. In session
77 the user said "z80 upstream only" and directed issues #18–#26 there (5 fixed generic
bugs, 3 unfixed "real bug, no fix found", a test-suite-enhancement issue). Each was a
curated, de-duplicated, thoroughly-described bug with a linked failing test case, and
each was shown to the user and approved **before** `gh issue create`.

**How to apply:**
- Default (no explicit direction): `gh issue create --repo ravn/<repo>`, never an upstream org.
- When the user directs an upstream submission to `llvm-z80/llvm-z80`: file there, but
  (1) one issue per *underlying* bug (de-dup the narrowing-down issues), (2) thorough
  description + a linked test case that demonstrates the failure, (3) **draft → show the
  user → file only after approval**, (4) cross-link the downstream `ravn/llvm-z80` issue,
  (5) fully-qualify any fork issue refs as `ravn/llvm-z80#NNN` so they aren't misread as
  upstream numbers.
- Still NEVER file at official `llvm/llvm-project` directly (see [[feedback_no_pull_requests]],
  [[feedback_upstream_routing_two_targets]]). If a generic bug is already open upstream
  (e.g. LiveVariables = llvm/llvm-project#156428), reference it — don't duplicate.

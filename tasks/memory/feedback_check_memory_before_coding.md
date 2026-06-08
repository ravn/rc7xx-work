---
name: feedback-check-memory-before-coding
description: HARD rule — before starting any substantive coding task, scan tasks/memory/MEMORY.md for rules that apply to this task's area, read the linked files, and name which rules apply in your first response. Don't skip and "rely on the session-start read" — that read happens once; new tasks within the session need their own targeted re-scan.
metadata:
  type: feedback
---

**HARD: Before writing the first edit for any substantive task, scan
MEMORY.md for the sections relevant to that task, READ the linked rule
files for anything that looks applicable, and explicitly name which
rules apply in your first response.  Only then start coding.**

**Why:**  The session-start read of MEMORY.md is necessary but not
sufficient.  A 200-line index is impossible to keep in working memory
across an hour-long session — rules drift out as new context loads.
Specific incidents this rule pins:

  - 2026-06-08, ticks termination investigation: spent ~40 min
    reverse-engineering `ticks.c:1039` HALT semantics from scratch
    before realizing the project already used the `ED FE` syscall
    trap everywhere (z88dk testsuite, `+test` CRT).  A targeted scan
    of MEMORY.md sections 7 (file/script ops) + 8 (test/debug
    discipline) for "ticks" / "exit" / "termination" — and a quick
    grep of `z88dk/test/` — would have surfaced the canonical
    mechanism in under 2 minutes.  See
    [[reference_ticks_canonical_exit_trap]] (the rule that was
    missing, now added) and [[feedback_grep_repo_docs_before_deriving]]
    (related — grep existing project infra before deriving from
    first principles).

  - The pre-existing [[feedback_consult_rules_before_acting]] covers
    "before commit/PR/issue" but fires too LATE for many tasks.  By
    the time the commit message is being drafted, the wrong approach
    may already be implemented.  This rule fires EARLIER: before the
    first edit.

**How to apply:**

  1. When the user gives a task, identify which MEMORY.md sections
     plausibly apply (e.g., a compiler change touches §5; a harness
     change touches §4 + §8; a memory-layout change touches §3).

  2. Scan those sections' index lines.  For any line that looks
     even peripherally relevant, READ the linked file (cheap — one
     Read call each).

  3. In your first user-facing response, name the rules that apply.
     One line each is enough: "Applicable rules: `feedback_X`
     (because Y); `reference_Z` (canonical mechanism for W)."

  4. Then start coding.

This is a HARD rule because the cost of skipping is high and not
visible to the user until much later: silent re-derivation of solved
problems, contradictory approaches, time-sink debug loops that the
relevant rule would have short-circuited.

Cross-listed in §1 (always-on for every task-start, not just every
response) and §2 (before any commit — a delayed-fire backup).

Related: [[feedback_consult_rules_before_acting]] (fires at commit
time; this fires earlier), [[feedback_grep_repo_docs_before_deriving]]
(grep project docs/code, this rule scans memory),
[[feedback_extract_rules_from_time_sinks]] (the inverse — propose new
rules after debug loops; this rule prevents the loop by checking
first).

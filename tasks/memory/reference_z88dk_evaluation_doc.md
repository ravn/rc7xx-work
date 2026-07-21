---
name: reference_z88dk_evaluation_doc
description: Living evaluation document about llvmz80 as z88dk backend — update when status changes
metadata:
  type: reference
---

Living document for the z88dk project at `tasks/z88dk-llvmz80-evaluation-2026-07-21.md`.

**Why:** User wants to share a balanced pros/cons assessment with z88dk maintainers.

**How to apply:** After any change that affects z88dk llvmz80 integration (new bridge, bug fix, benchmark result, float support), update the relevant section of the document. Keep it current — it reflects what is TRUE NOW, not what was true when it was created.

Sections to watch:
- §1 "What works today" table — update when new bridges land or gaps close
- §4 DCC benchmark table — update when cycles change after compiler improvements
- §5 "libm status" — update when transcendental functions are ported or whetstone becomes feasible
- §6 recommendations — adjust if any recommendation becomes stale

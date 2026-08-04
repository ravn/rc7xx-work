---
name: prior-art-before-own-fix
description: "HARD — at bug-start, proactively search the repo (headers, tests, bug notes, existing decls) for an EXISTING solution to this symptom/bug-class before deriving your own fix from first principles."
metadata:
  node_type: memory
  type: feedback
---

**HARD RULE (prior-art-first at bug-start):** The moment a bug is
understood well enough to name its *symptom* or *class*, the first
action is a proactive search for an **existing solution to that
symptom** — not deriving a fix from first principles. Search the
repo's headers, tests, `bugs/`/`tasks/` notes, existing declarations,
and commit history for the same bug-class before writing anything.

**The missing piece is this proactive step:** "search for an existing
solution to *this symptom* before building your own." Root-causing
from first principles is necessary but not sufficient — once you know
the class, look for how the project already handles it.

**Why:** stdcbench c90lib `realloc` under llvmz80 (2026-08) — I
root-caused the reversed `__smallc __z88dk_callee` arg-push order from
scratch via an `argord` experiment, then designed a per-function
macro-swap fix... only to discover the project *already* used exactly
that pattern for the same bug-class: `stdlib.h` (qsort/bsearch),
`video/sem702.h`, portme.h's own `STDCBENCH_CMP_CONV`, and a
`FOLLOWUP_classic_qsort_strerror_after_upstream_merge.md` note
documenting it as the deliberate strategy. A 60-second grep for the
symptom keywords (`__z88dk_callee`, `reversed`, `qsort`) up front would
have surfaced the precedent and confirmed the approach immediately,
instead of re-deriving it.

**How to apply:** as soon as you can state the symptom in one line,
run a 30–60 s search before designing a fix:

1. `grep -rn '<symptom keywords / bug-class terms>'` across headers,
   `test/`, `bugs/`, `tasks/`.
2. Look for existing per-function compensations, workaround macros, or
   `FOLLOWUP_*`/`NOTE`/`XXX` notes on the same class.
3. If a precedent exists, **follow it** (consistency + upstream
   alignment) rather than inventing a parallel mechanism.
4. Only derive from first principles if the search genuinely finds no
   prior art — and then leave a note so the next occurrence finds
   yours.

**What to avoid:** deriving a novel fix, THEN discovering the project
already solved the class differently — now you either rework to match
or introduce an inconsistent second mechanism. Both cost more than the
upfront grep.

## Cross-references

- [[feedback_grep_repo_docs_before_deriving]] — sister: grep repo docs
  before re-deriving a low-level *fact* (encoding/bit layout/memmap);
  this one covers an existing *fix/compensation* for a symptom.
- [[feedback_consult_rules_before_acting]] — covers MEMORY.md rules.
- [[feedback_check_memory_before_coding]] — the memory-scan analog.

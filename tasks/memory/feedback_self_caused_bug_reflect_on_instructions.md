---
name: When filing a self-caused bug, reflect on what instructions would have prevented it
description: When the user is filing or about to file an issue that traces back to AI-authored code, treat it as an opportunity to identify the instruction (rule / convention / coverage requirement) that would have prevented the bug from being introduced.
metadata:
  type: feedback
---

When filing a bug whose root cause is in code the AI (this assistant or a
prior session) authored, do not just file the bug and move on.  Pause and
reflect hard: **what instruction should the user have given me back then
that would have caused me to avoid this bug in the first place?**

**Why:** the user is investing in a long-running collaboration where the AI
is doing significant code-authorship work.  Every self-caused bug is a
signal that some implicit context an experienced human developer would
have carried was missing from the AI's behavior.  Most of those implicit
contexts can be made explicit as a durable rule.  Without the reflection
step, the same class of bug keeps reappearing because each instance is
treated as a one-off rather than as a missing convention.  With the
reflection step, the rule lands in memory and applies to all future code
authored in this codebase.

**How to apply:**

1. When the bug is traced to AI-authored code (check git blame / commit
   trailers for `Co-Authored-By: Claude*` if uncertain), **say so
   explicitly** in the discussion.  Don't hide the provenance.
2. Identify the most-effective instruction that would have caught the bug:
   - Often a **test-coverage requirement** ("test with flag X enabled")
     is more durable than a code-shape rule, because it would have caught
     the bug regardless of the specific code shape.
   - Sometimes a **code-convention rule** ("always use helper Y when
     doing pattern Z") is the right answer if the code shape is canonical
     enough that a coverage gate would miss it.
   - Often the right answer is **both** — coverage and convention.
3. Offer to save the rule(s) to `tasks/memory/` as feedback notes BEFORE
   continuing with the fix.  The fix is transient; the rule is durable.
4. When saving, link the new memory entry to the bug it was learned from,
   and to the upstream rule (e.g. existing test-coverage rules) if one
   applies.
5. **Do not apologize.**  Failed convention != personal failure.  State
   the gap, propose the rule, save it, move on.  Per
   [[feedback_no_apology]].

**Anti-pattern to avoid:** filing the bug, fixing it, moving on without
extracting the rule.  That's the move that lets the bug class recur.

**Related:**

- [[feedback_compiler_bug_test]] — always write a lit test for a compiler
  bug.  The current rule is a higher-order version: think about what
  test (or convention) would have prevented the bug, not just how to
  prove the fix.
- [[feedback_zoom_out_on_recurring_pattern]] — after 2-3 instances of one
  bug class, stop and find the systemic cause.  This rule is the
  preemptive analog: extract the systemic rule at the FIRST instance if
  the bug is AI-authored.
- [[feedback_no_apology]] — don't frame the gap as personal failure.

**Concrete example (the prompting instance, 2026-06-09):**

The DJNZ peephole in `Z80LateOptimization.cpp` (commits `370da4ea` and
`dccbae3759ad`, prior-Claude co-authored) used `std::next(I)` to find the
next `MachineInstr` for adjacency-based pattern matching.  Under `-g`,
`DBG_VALUE` pseudos interleave between real MIs, the `std::next` lands on
a debug pseudo, the opcode check fails, the peephole bails, and
production builds (which use `-g`) lose 4 bytes per innermost nested
countdown loop.  Filed as ravn/llvm-z80#221.

The instructions that would have prevented the bug:

- **Coverage:** "When you add a peephole, the lit test must exercise it
  both with `-O2` and `-O2 -g`, and assert the two outputs produce the
  same instructions (modulo `.loc` / `.cfi` / `.debug_*` directives)."
  Would have caught the bug on day one without anyone needing to know
  the `DBG_VALUE` mechanism.
- **Convention:** "Any peephole that pattern-matches adjacent MIs must
  use `MachineBasicBlock::next_nodbg()` / `skipDebugInstructionsForward()`
  instead of raw `std::next`."  More targeted; relies on the AI knowing
  the helper exists.

The coverage rule is the more durable one (it would catch the bug
regardless of whether the AI used `next_nodbg` or some other workaround).

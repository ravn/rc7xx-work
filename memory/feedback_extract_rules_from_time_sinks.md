---
name: After every long debug session, propose new rules that would have avoided it
description: Hard rule (meta) — whenever significant time is spent finding a root cause, suggest concrete new memory-rule entries that would have caught the class of bug earlier
type: feedback
originSessionId: de6f9865-d9ee-4776-abd2-c579088d6b91
---
HARD RULE (meta) — whenever significant time is spent on debugging
or chasing something, and the root cause is found, **proactively
propose new rules that would have avoided it.**  Don't wait for the
user to ask.

**Why:** time-sinks are evidence that some implicit knowledge is
missing from the rule set.  The next session will repeat the same
mistake unless the lesson is encoded.  The user has explicitly asked
for this 2026-05-07 — they noticed memory-layout struggles came up
multiple times before being captured as a HARD RULE.

**How to apply** at the end of any debugging arc:

1. Identify the class of bug (not just the specific instance).  E.g.,
   "IVT overlap" → "hardcoded address constants that describe hope
   not invariants".
2. Identify the meta-pattern that allowed it.  E.g., "no link-time
   ASSERT bridging the constant to the actual placement", "no
   audit script catching it post-link", "the source build had this
   invariant but the port didn't translate it".
3. Suggest one or more concrete rules — phrased as either:
   - **Process rules** (audit X before declaring Y functional)
   - **Code rules** (prefer pattern A over pattern B)
   - **Tooling rules** (extend script Z to catch this class)
4. Write the rule entry as a memory file (feedback type) and add to
   MEMORY.md.  Do NOT just mention "we should add a rule for this"
   in chat — actually write the entry.
5. Cross-reference back to the originating debug session so future-me
   can audit whether the rule actually paid off.

**What counts as "significant time":** if a single bug or class of
bug consumed more than ~30 minutes OR spans multiple sessions OR
has the user reach the "we've struggled with this before" comment
threshold, capture rules from it.

**Don't be precious about it:** it's better to write a rule that
turns out to be obvious-in-hindsight than to skip writing one that
would have saved the next session from a 2-hour fishing expedition.
A rule that's never needed costs ~150 chars of MEMORY.md; a rule
that's missing costs entire debug arcs.

**Recent example** (2026-05-06/07): SDCC IVT overlap consumed most
of two sessions before the structural fix was articulated.  The
narrow lesson "audit memory layout when porting" wasn't in memory
even though `project_cpnos_address_coupling_brittle.md` had been
written 2026-04-25 with a similar message — but scoped only to the
cpnos.com/cpnos-rom boundary, not to the general "port to a new
linker" case.  This rule (and `feedback_memory_layout_on_port.md`)
exists so future-me writes the broader rule the FIRST time, not
the second.

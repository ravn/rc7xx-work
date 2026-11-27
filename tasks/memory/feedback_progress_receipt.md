# Progress receipt before the next attempt (mechanical anti-derailment)

**Why:** 2026-11-27 (rc759-xios aligner): four successive aligner rewrites
(v3→v4→v5 + greedy scanner) while the primary metric (attributed diffs 4/132)
sat unmoved. Every intermediate step *felt* productive ("script ran, new
output"), so mood-based "am I stuck?" checks never fired. The rule that would
have caught it makes progress a *quotable number* that must move, not a
feeling.

## Rule (HARD)

1. **Name the metric before attempt #2.** Before running a 2nd attempt at the
   same failure, write one line: `metric = X (current v); this attempt is
   expected to move it to w`. If no named metric can be stated, the attempt is
   fishing — do not run it; ask instead.
2. **Unmoved metric twice = STOP + map.** If the primary metric does not
   improve across two consecutive attempts, stop and put a 5-line map in front
   of the user: (1) current model, (2) what has been falsified, (3) remaining
   candidate causes, (4) where cost was burned, (5) the decision wanted.
3. **2nd rewrite of the same component = design error.** Rewriting the same
   script/harness/aligner a second time escalates to the user BEFORE the
   third — a rewrite means the design, not the effort, was wrong. (v3→v4→v5
   would have stopped at v4.)
4. **Falsification ledger.** A new approach must state which candidate(s) it
   eliminates if it succeeds. An approach that cannot name any is research,
   not debugging — surface it as such before spending.

## Distinction

AGENTS.md's "2+ probes without narrowing" tripwire is correct but
mood-judged; this rule makes it mechanical by requiring the receipt (metric +
expected delta) *before* spending, so "no progress" becomes a quotable fact
instead of a vibe.

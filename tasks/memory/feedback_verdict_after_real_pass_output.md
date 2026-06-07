---
name: verdict-after-real-pass-output
description: HARD — before any verdict on compiler behavior, show (a) the IR/asm the named pass actually produces, (b) what's contaminated or untested, (c) remaining doubts in one sentence; verdict comes AFTER, never first; synthetic worst-case repros don't count as evidence for "this pass is broken"
type: feedback
---
**User directive 2026-06-07** (after retracting a STRENGTHENED verdict on
ravn/llvm-z80#164 that didn't survive a realistic test):

> Before any verdict on compiler behavior: show the IR the relevant pass
> actually produces, state what's contaminated or untested, state
> remaining doubts in one sentence — before stating the verdict, not
> after.

**Why this exists.**  Session 2026-06-07 claimed STRENGTHENED on #164
based on a synthetic IR with 4 explicit `zext i8 to i16` instructions per
use — exactly the worst case the bug describes.  But TruncInstCombine
would never produce 4 zexts: it emits ONE shared zext at the boundary
and the optimizer's CSE consolidates the rest.  When the realistic shape
was finally generated, narrowing won by 7–13 % on both AVR and Z80.  The
"STRENGTHENED" claim was a 30-minute waste of context that the user had
to push back to retract.

**Anti-pattern**: hand-constructing the IR that makes the bug look worst,
declaring it evidence the pass is wrong, recommending an upstream filing.

**Correct pattern** (the verdict-discipline checklist):

1. **What does the named pass actually produce on a representative input?**
   - Use `opt -passes=<name> -S` to capture the pass's true output, not
     `clang -O2` (which is the whole pipeline post-processing it).
   - If the pass already shipped a fix in our fork, capture pristine
     upstream behavior via sonnyboy's `~/llvm-upstream` build, OR by
     bypassing the affected pass (`-mllvm -disable-<flag>` if one
     exists), OR by hand-running `llc` on unnarrowed IR.
2. **What's contaminated or untested?**  Sentence per caveat:
   - "AVR codegen here runs through the llvm-z80 fork middle-end which
     carries patch X" — `feedback_avr_density_oracle`'s caveat applies.
   - "The synthetic doesn't replicate production multi-site cumulative
     cost; only measures per-shape."
   - "Z80 instruction count compared to AVR may reflect ABI / regfile
     differences, not the bug."
3. **What doubts remain?**  One sentence.  Surface them BEFORE the
   verdict, not under the user's push-back.
4. **Then state the verdict** — and only then.

**Format for verdict reporting** (use literally):

```
Pass output:
  <show the relevant IR/asm slice>
Contaminated:
  <caveat 1>
  <caveat 2>
Doubt:
  <one sentence on what could flip the verdict>
Verdict:
  <STRENGTHENED / WEAKENED / NEUTRAL / NEEDS-EVIDENCE / etc.>
```

**Anti-rule check** (cross-listed):

- [[feedback_state_certainty]] — surface ALL doubt; this rule operationalizes
  it for compiler-behavior verdicts.
- [[feedback_compiler_not_trusted]] — inspect generated asm before blaming
  source/runtime; this rule's complement for the analysis direction.
- [[feedback_avr_density_oracle]] — the macbook caveat ("AVR codegen runs
  through the fork middle-end") is the canonical contamination to flag.
- [[feedback_file_bugs_not_fixes]] — verdicts feed into bug filings; a
  contaminated verdict produces a brittle filing.

**Scope.**  Applies to any claim about what a compiler pass does or
should do, on any target.  Not just upstream-bound work — local-only
optimization analysis benefits equally.

**Doesn't apply to**: feature implementation decisions ("should we
support X feature?") or pure-engineering choices ("which tool to use?")
— those are different judgment calls.

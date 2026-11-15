---
name: feedback-zlfn-pr-collaboration-rules
description: zlfn's upstream samarbejdsmodel: maks 1-2 PRs ad gangen, stacked PRs via write access, ingen paraply-PRs
metadata:
  type: feedback
---

**The rules (stated directly by zlfn 2026-11-15 on PR #142 and #143):**
> *"I’ll give you write access, so could you reopen the necessary changes as stacked PRs? I don’t think something like an umbrella PR is needed.*
> *Also, could you refrain from opening several series of PRs at once? If possible, I’d like to review them one at a time, revise them together, and merge them. I don’t think it’s appropriate to open a PR to main with all the work from your branch at once. Could you open just one or two at a time, in order of priority?"*

**Hvad det betyder konkret for arbejdet mod `llvm-z80/llvm-z80`:**

1. **Ingen paraply-PRs eller PR-bombardement:**
   - Opret ALDRIG paraply-PRs mod `main`.
   - Opret ALDRIG serier på 5-10 PRs samtidigt. Det overvælder maintaineren og skaber parallel review-gæld.

2. **Maks 1–2 PRs åbne ad gangen (i prioriteret rækkefølge):**
   - Vælg den vigtigste/simpleste ændring først (f.eks. ukontroversielle codegen-folds som #144).
   - Gennemgå, revidér sammen med zlfn, og få den merget, før den næste åbnes.

3. **Udnyt upstream write access til ægte stacked PRs:**
   - Ravn har fået direkte skriveadgang (`push: true`, `viewerPermission: WRITE`) til `llvm-z80/llvm-z80`.
   - Branches pushes til upstream repoet (f.eks. `users/ravn/...`).
   - Når ændring B bygger oven på ændring A, sættes `base branch` for PR B til gren A i stedet for `main`. Derved viser GitHub kun B's egne ændringer.

4. **Dokumentér det faktiske observerede problem i praksis:**
   - Maintaineren spørger: *"did you actually run into a problem without it?"*
   - Angiv altid den præcise kontekst hvor problemet opstår (f.eks. toolchain, assembler, switch, eller testcase der fejlede).
   - Skil generelle LLVM-forbedringer fra specifikke integrationsbehov (f.eks. z88dk-specifikke runtime-fixes hører til i z88dk-serien, ikke generel codegen).

5. **Issue først ved designvalg:**
   - Som aftalt i issue #8: rejs et issue først for at afstemme retningen før større PRs indsendes.

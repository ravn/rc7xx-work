---
name: +static-stack only for non-recursive code
description: Historical HARD rule — old +static-stack is non-reentrant and absent from d6658ad; current +static-frame has a different analysis gate
type: feedback
originSessionId: 47c9c70b-c4f7-483e-a315-18919e50448e
---

**Historical HARD RULE:** the pre-PR-40 clang/llvm-z80 `+static-stack`
target-feature (locals in fixed BSS instead of on the stack) was
**non-reentrant**. A recursive function under that implementation overwrites
its own locals on each call and **silently miscompiles** — there is NO
diagnostic, NO crash, just a wrong answer. The `+static-stack` feature is
absent from compiler `d6658ad`; do not treat it as a current build option.

Current `+static-frame` is a different mechanism. Frame lowering requires a
`nonreentrant` proof from the current analysis, in addition to the
function-level `+static-frame` feature. Do not infer equivalence from the
similar names, and do not add `target("no-recurse")` unless the no-overlapping-
activations assertion is actually true.

**Why (evidence, 2026-06-24):** in the dcc-corpus three-compiler comparison
(`compiler-zoo/cpm_zoo.py`, the `clangp` flavor built with the production
flags `+static-stack +shadow-regs -disable-lsr`), the recursive `nqueens` test
returned the WRONG result and ran in **404 K** T-states instead of the correct
**53 M** — the recursion's per-call locals collided in the shared BSS frame.
Plain `clang` (stack frames) gave the right answer.  `+static-stack` was a real
**−20…−27 % raw-size** win on the non-recursive tests (sieve 159→126, e
503→368, tstring 2927→2741) and often faster — which is exactly why it is
tempting to apply blanket and exactly why the silent recursion failure is
dangerous.

**How to apply:**
- Historical RC700 production builds used `+static-stack`; that describes
  those compiler revisions, not the current `+static-frame` analysis result.
  Non-recursion at source level alone does not establish that current
  whole-module/context analysis will mark every function `nonreentrant`.
- For any NEW code or a general/unknown corpus, do NOT use the historical
  `+static-stack` mechanism. With current `+static-frame`, inspect the
  analysis result; use a no-recurse assertion only when its invariant is
  independently established.
- Historical builds that enabled it needed an explicit comment at the flag
  site stating "code is non-recursive — required for +static-stack
  correctness" so the invariant was visible to the next editor.
- If recursion was introduced into a historical `+static-stack` translation
  unit, the result could silently become wrong; suspect this when investigating
  artifacts built with that older compiler.
- The current `+static-frame` path has a non-reentrance analysis gate, but it
  is not equivalent to the historical mechanism. See the current
  implementation in `llvm/lib/Target/Z80/Z80FrameLowering.cpp` and
  `Z80NonReentrant.cpp` before drawing conclusions about a particular build.

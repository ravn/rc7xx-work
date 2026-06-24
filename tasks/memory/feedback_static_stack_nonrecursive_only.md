---
name: +static-stack only for non-recursive code
description: HARD — never enable clang +static-stack on code that can recurse (directly or via a cycle); it is non-reentrant and SILENTLY miscompiles, no error
type: feedback
originSessionId: 47c9c70b-c4f7-483e-a315-18919e50448e
---

**HARD RULE:** the clang/llvm-z80 `+static-stack` target-feature (locals in
fixed BSS instead of on the stack) is **non-reentrant**.  Only ever enable it
for code that is provably **non-recursive** — no direct self-recursion, no
mutual-recursion cycle, and (conservatively) no calls through function pointers
whose callees you cannot bound.  A recursive function under `+static-stack`
overwrites its own locals on each call and **silently miscompiles** — there is
NO diagnostic, NO crash, just a wrong answer.

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
- The RC700 production firmware (rcbios, autoload-in-c, cpnos-in-c) is
  non-recursive by construction, so it ships `+static-stack` safely.  That is a
  property of *that* code, not a license to use the flag elsewhere.
- For any NEW code or a general/unknown corpus, do NOT add `+static-stack`
  globally.  First establish non-recursion (read the call graph / source).
- When a build does enable it, add a one-line comment at the flag site stating
  "code is non-recursive — required for +static-stack correctness" so the
  invariant is visible to the next editor.
- If recursion is later introduced into a `+static-stack` translation unit, the
  bug is a silent wrong-answer — suspect this first when a previously-correct
  static-stack program starts returning garbage after gaining a recursive path.
- The real fix (so the flag could be applied safely per-function) is a
  recursion/reentrancy analysis in the backend that auto-gates static-stack to
  non-recursive functions — tracked alongside [[project_ix_caller_saved_after_12]]
  / ravn/llvm-z80#12.  Until that exists, the discipline above is the guard.

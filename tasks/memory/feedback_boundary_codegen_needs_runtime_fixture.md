---
name: feedback_boundary_codegen_needs_runtime_fixture
description: Boundary/off-by-one-prone codegen (switch bounds, range checks, compare narrowing) needs a runtime fixture exercising min/max/just-past, and lit expectations derived from first principles — never pinned from observed asm
metadata:
  type: feedback
---

**HARD:** When a compiler change touches codegen that decides control flow or
values at a **boundary** — switch/jump-table range checks, `cp`/compare
narrowing, off-by-one-prone peepholes, saturation, loop-exit tests — it is NOT
"just a size optimization." It is a **correctness** change.

**The load-bearing safeguard is a RUNTIME FIXTURE — an oracle INDEPENDENT of
your reasoning.** Add `z80-utils/test-runner/testcases/clang/*.c`
(`/* expect 0xNNNN */`) that *runs* the boundary values: minimum, maximum, and
just-past-the-edge. One value per case is not enough — the bug hides at the
extreme (the highest case value, the last dense jump-table slot, `n == limit`).
A fixture that executes `dispatch(max)` and checks the result fails regardless
of what you believed the codegen did.

**A lit test alone is NOT sufficient, and "derive the CHECK from first
principles" does NOT reliably save you** — because the whole failure mode is
that your first-principles reasoning shares the bug's blind spot. In #86 the
author "knew" `cp N` was the right check; deriving from that same wrong model
would still have written `cp 29`. Pinning observed asm is strictly worse (it
codifies whatever was emitted), but *reasoned* asm can be wrong too. The lit
test pins the shape for CI speed; the **runtime fixture is what actually catches
a wrong boundary**, because execution doesn't care what you reasoned.

**Why:** ravn/llvm-z80 `#86` (jump-table range-check narrowing, commit
`ec0f0d2478ad`, Claude Opus 4.7 co-authored) shipped with ONLY a lit test
(`issue-86-u8-switch-range.ll`) that pinned the emitted `cp 29`. That immediate
was off by one (`cp Range` = `offset >= Range` instead of `cp Range+1` =
`offset > Range`), silently routing the **maximum** case value to the default
block at -O1+. The test cemented the bug for ~2.5 months; it stayed latent in
production BIOS `_specc` (case 0x1e mis-routed) and was only found when
nanoprintf's `%x` (the max conversion char) observed a wrong result losslessly.
Z80's asymmetric compare flags (`cp n` gives `A < n`; no single flag for
`A > n`) make these off-by-ones easy to write and hard to see.

**How to apply:**
- Reflex on any bound/edge codegen: "what is the max in-range value, and does a
  test *run* it?" If not, add the runtime fixture before committing.
- Derive lit CHECK constants from the semantics (`offset > Range` → `cp Range+1`),
  then confirm the compiler matches — not the reverse.
- This is the concrete instance of CLAUDE.md's "runtime correctness a lit test
  can't express also ships with a runtime fixture" — a value-wrong switch IS
  runtime-observable, so a lit test alone is insufficient.
- Related: [[feedback_audit_oracle_not_just_fix]] (build the detector that would
  have caught it on purpose), [[feedback_self_caused_bug_reflect_on_instructions]]
  (this bug traced to Claude-authored code), [[feedback_no_commit_first_version]]
  (value oracle before commit).

---
name: no-upstream-sdcccall-discrepancies
description: Do NOT file upstream issues about sdcccall 0/1 ABI discrepancies — they are known build-config mismatches, not bugs; work around locally instead
metadata:
  type: feedback
---

**Do NOT file upstream issues (z88dk, SDCC, or anywhere) about `--sdcccall 0`
vs `--sdcccall 1` ABI discrepancies.** These are known build-configuration
mismatches, not bugs.

**Why:** user decision (2026-07-06). The classic manifestation: z88dk ships
its runtime arithmetic helpers (`__modsint`, `__divulong`, `__modulong`,
`__mullong`, `___muluint2ulong`, …) built for the **default stack-argument
convention** (`--sdcccall 0`) only. When you compile with `--sdcccall 1`
(register-argument ABI) but link that default-convention stdlib, SDCC passes
operands in registers while the helper pops them off the stack, so signed
div/mod silently returns 0. z88dk already warns about exactly this
(**warning 296**: "non-default sdcccall specified, but default stdlib or
crt0"). Because it is a documented config mismatch — not a codegen defect —
it is not upstream-fileable.

**How to apply:**
- If a sweep/corpus cell fails and the root cause is a sdcccall 0/1 stdlib
  mismatch: treat it as build-config. Work around it **locally** — either
  drop the cell (`SKIP_CELL` in the corpus sweep) or ship small
  **register-argument shim helpers** linked ahead of the z88dk clib that
  reuse z88dk's register-based math kernels (`l_divs_16_16x16`,
  `l_divu_32_32x32`, `l_mulu_32_32x32`, `l_mulu_32_16x16`).
- Never route it to z88dk/SDCC as a bug report.

**Precedent:** the corpus `fannkuch:zsdcc` + `pi:zsdcc` XFAILs were exactly
this. Confirmed + red-green validated, then SKIPPED in `sweep.sh`
(rc700-gensmedet commit `073ff82`); the optional shim path is tracked in
rc700-gensmedet#121. Repro: `rc700-gensmedet/tasks/compiler-comparison-corpus/
zsdcc-repro/modsint_sdcccall1.c`. Full writeup:
`rc700-gensmedet/tasks/zsdcc-bench-divergence-2026-06-08.md`.

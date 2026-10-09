---
name: feedback_z80indexiv_pressure_not_stride
description: Z80IndexIV unit-stride guard is a heuristic — the principled fix is register-pressure check (2N live pointers vs 3 available pairs), not a hardcoded stride==1 exception
metadata:
  type: feedback
---

The unit-stride skip in Z80IndexIV (commit 79ea93e4, branch `fix-indexiv-unit-stride`)
is **correct in result but wrong in form**. It is a hardcoded heuristic that should be
replaced by a proper register-pressure check.

**Why:** The current guard only catches stride=1. A 2-pointer loop with stride=2 would
still be rewritten, creating 4 simultaneously-live 16-bit values on a CPU with 3
register pairs — same spill problem.

**Principled rule:** Before rewriting N GEPs sharing one index IV, count live 16-bit
values after rewrite = `2N` (N base pointers + N uglygep values). Z80 has 3 register
pairs. If `2N > 3`, skip.

| N=1 any stride | 2 ≤ 3 | allow (with stride profitability check) |
| N=2 any stride | 4 > 3 | always skip                             |
| N≥2 any stride | ≥6 > 3 | always skip                            |

**For N=1 with stride=1:** pressure check alone allows it (2 ≤ 3), but it is still
unprofitable because uglygep computation > INC HL. A second-order stride profitability
check handles this — but it is a proper cost comparison, not a special case.

**Status:** Filed as issue #400 comment (2026-10-09). Unit-stride guard remains as
placeholder until pressure-based check is implemented.

**Why:** User explicitly requested that size wins fall naturally from CPU modeling,
not from special-case exceptions. This is the right engineering principle.

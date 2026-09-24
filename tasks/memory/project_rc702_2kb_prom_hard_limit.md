---
name: rc702-2kb-prom-hard-limit
description: "User's physical RC702 has 2 KB PROM sockets only -- the A11 solder bridge that enables 2732 (4 KB) was not present until later models. Both PROM0 and PROM1 are hard-locked at 2048 B each; 4 KB upgrade is not an option for this machine."
metadata: 
  node_type: memory
  type: project
  originSessionId: 6bb2377c-77ab-4014-8339-b92776bcffc5
---

**Fact (confirmed 2026-05-17):** the A11 solder bridge documented in
the RC702 technical reference (allowing 2732 / 4 KB EPROMs in IC65
and IC66) was **not present in the user's machine** -- it was added
in later model revisions.  Both PROM0 (autoload) and PROM1 (cpnos /
lineprog) are therefore hard-capped at 2048 B each on this hardware.

**Why:** repeated discussions and docs reference 4 KB PROMs as a
"contingency" or "future option" (autoload-in-c/SEM702_FONT_COMPRESSION.md
fit-analysis table, MAME's `rc702` PROMCFG input, multiple Makefile
comments).  For this user's physical RC702, none of those are
real escape hatches.  Any size pressure on PROM0 or PROM1 must be
resolved by source-level / compression work, NOT by suggesting
"close the A11 bridge".

**How to apply:**

- When PROM0 / PROM1 are tight on space, treat 2048 B as a HARD
  ceiling.  Never propose "if we close the A11 bridge..." or "with
  a 2732 you could fit...".  Generalises [[user-no-hw-mods]] for
  this specific socket-config case.
- MAME-side code/docs that mention 2732 / 4 KB are still correct
  (MAME emulates the generic RC702 that does support both); do not
  edit those.  The constraint is per-machine, not model-wide.
- Project docs that present 4 KB as a real option for this user
  (e.g. autoload-in-c/SEM702_FONT_COMPRESSION.md) should either mark
  the 4 KB rows as N/A for current hardware or be tightened.

**Cross-listed:** [[user-no-hw-mods]] (no PCB modifications -- closing
the A11 bridge would qualify as one anyway).

Current sizes (session 73j):
- PROM0 autoload-in-c clang: 1656 / 2048 B (392 B free)
- PROM1 cpnos-in-c lineprog clang: 1930 / 2048 B (118 B free)

**TEMPORARY exception (2026-09-17, rc700-gensmedet@3c34251):** the
`autoload-in-c` Makefile's clang PROM gate is temporarily raised
2048 -> 4096 B (MAME-only). Cause: llvm-z80 z88dk-support work
regressed clang code density on autoload-in-c (rc700-gensmedet#130 /
ravn/llvm-z80#340), pushing the clang build over the 2 KB hard cap.
The bump exists purely so MAME boot-gate testing can keep running
against current clang codegen while upstream miscompile-fix work
lands; it does NOT change the production constraint above -- the
user's physical RC702 is still 2716-socket / no A11 bridge, hard
2048 B ceiling. Re-lower the gate to 2048 B once #340 / #130 is
resolved. Do not treat 4 KB as the real target when discussing
PROM0 size with the user.

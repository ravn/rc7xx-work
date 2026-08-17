---
name: Watcom C99 for cpm86 user code — owcc -std=c99 -> wcc -za99 (undocumented) / -zastd=c99
description: How to enable C99 (inline / mid-block + for-loop variable declarations) when compiling CP/M-86 user programs with owcc -bcpm86; the underlying wcc switch and its documented equivalent. Verified 2026-08-18.
metadata:
  type: reference
---

**Open Watcom implements a partial C99** (the commonly used parts, incl. inline /
mid-block variable declarations and `for (int i=...)` loop declarations). The
enabling wcc switch is **`-za99`** (alias `-zA99`), which is marked `:internal.`
in `bld/cc/gml/options.gml:1178` — i.e. **undocumented**. The **documented**
equivalent is **`-zastd=c99`** (`options.gml:1195`, `:special. checkSTD`). Both
set the same `cstd` enum to C99. The C89-vs-C99 declaration diagnostic lives in
`bld/cc/gml/cerrs.gml:2431` ("Within a function body, in C99 mode a declaration
is only allowed …").

**For CP/M-86 user programs the driver surfaces this as the standard
`-std=c99`.** Verified 2026-08-18 (`-v`): `owcc -std=c99 -bcpm86 …` emits
`wcc -za99 -bt=cpm86 -ms -1 …`. Without `-std=c99` the default is **C89**, so a
`for (int i = 1; …)` fails with `E1009: Expecting ';' but found ')'`. With it, a
program using for-loop + mid-block decls builds and runs correctly under the
unicorn oracle (`SUM-OF-SQUARES 55`).

- Default `owcc -bcpm86` (no `-std`)  -> C89 -> C99 inline decls REJECTED.
- `owcc -std=c99 -bcpm86`             -> `wcc -za99` -> C99 inline decls OK.

Note the two `-std` routes differ per driver: this `owcc`/`wcc` path is separate
from the z88dk `zcc +cpm -compiler=llvmz80` path (that one defaults `gnu23`; see
CLAUDE.md). The clib itself is built with the documented `-zastd=c99` strict form
(`sw_c_common` in `bld/clib/flags.mif`).

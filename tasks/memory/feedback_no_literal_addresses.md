---
name: No literal memory addresses — linker lays out everything
description: HARD RULE — every memory address in code/asm/Makefile must be derived from a linker symbol or .sym extraction; literal addresses are a permanent footgun
type: feedback
originSessionId: de6f9865-d9ee-4776-abd2-c579088d6b91
---
**HARD RULE (2026-05-08):** No literal memory addresses anywhere — in
C, asm, Makefile, linker scripts, or build scripts.  Every address
must be derived by the linker (or extracted from a sibling binary's
`.sym`/`.map` at build time).

**Why:** Path 6 hand-picked `LD SP, 0xDD80` based on a memory-layout
mental model that was off by 1024 bytes (missed cpnos.com's NDOSRL
data region).  The hardcoded literal had no link to the layout it
was claiming to live alongside, so when the layout shifted, the SP
value didn't follow.  Result: silent stack-into-NDOSRL stomp; took
multiple sessions to diagnose.  cpnos.sym already contained the
right info (`D980 NDOSRL`), but the literal `0xDD80` couldn't
"see" it.

**How to apply:**
- C source: never write `(void *)0xXXXX`; declare `extern uint8_t
  symbol[]` and let the linker resolve the address.
- asm: never write `ld bc, 0xXXXX` for a memory address; reference a
  symbol the linker resolves (`ld bc, _symbol_name`).
- Linker scripts: define every region's edges with named symbols
  (`__stack_top`, `__cpnos_load_end`, `__ivt_start`, etc.) and use
  ASSERTs to enforce relationships, not numeric ranges.
- Cross-binary boundaries (cpnos-rom ↔ cpnos.com): extract the other
  binary's symbols at build time (`awk` over `.sym`, or `--defsym`
  from `nm` output) and pass them in as link-time defines, not
  hardcoded literals.
- Build scripts (`tasks/scripts/*.py`): read addresses from `.map`
  files at runtime, never hardcode them.
- Comments: a comment that says "stack lives at 0xXXXX..0xYYYY"
  decays the moment the layout shifts.  Either elide the numeric
  range or have it computed by the build and substituted in.

**Discriminator** for whether a literal is OK:
- I/O port numbers, vector bytes, fixed device addresses, magic
  constants written into headers (e.g., `PAYLOAD_CHECKSUM_MAGIC =
  0xCAFE`): these are protocol values, not memory layout — fine.
- Anything that names a memory region edge or a code/data placement:
  must be linker-derived.  No exceptions.

**Cross-binary footnote:** for the cpnos-rom ↔ cpnos.com boundary,
the source-of-truth files are `cpnos-build/d/cpnos.sym` (NDOSRL,
NDOS, BDOSDS, BDOS, NIOS) and the build-extracted `cpnos_addrs.h`.
Anything cpnos-rom needs about cpnos.com's layout must flow through
those, not through hand-typed literals in C/asm.

---
name: cpnos PROM is the only PROM in play
description: For RC702 work in this project phase, the cpnos PROM is canonical; the autoload PROM is no longer the test target
type: project
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
For the current project phase (CP/NET fast-link / Option P bring-up,
Phase 3+ of cpnos-rom), the **cpnos PROM** is the only PROM in play.

The classic autoload PROM (`autoload-in-c/clang/prom0.ic66`, banner
"RC700 CL", boots CP/M from local floppy) was the testbed for the
LLVM-Z80 codegen comparison.  That phase is done.  Do NOT propose
"smoke test with the autoload PROM + SW1711-I8.imd" as a sanity check
when you're working on cpnos / CP/NET.

**Why:** Stated explicitly by the user 2026-04-26 after I rebuilt and
reinstalled the autoload PROM as a sanity check (because earlier
"black screen" tests had been confounded by a stale PROM).  The user
clarified that for cpnos / CP/NET work, the cpnos PROM is the only
relevant test target, and the autoload PROM should not be put back
in `roms/rc702/roa375.ic66`.

**How to apply:**
- For RC702 cpnos / CP/NET smoke tests: `make cpnos-install` (which
  copies cpnos.bin onto `roms/rc702/roa375.ic66`) is the correct
  installation step.  Do NOT follow it with `cp .../prom0.ic66` to
  put the autoload PROM back.
- Tests that should run: `make cpnos-netboot`,
  `tests/cpnet_bridge/harness.py`, anything that exercises cpnos.
- Tests that should NOT be invoked as "sanity": basic
  `regnecentralend rc702 -flop1 SW1711-I8.imd` boot.  CP/M-from-floppy
  is no longer the configuration we care about.
- If a black screen surfaces during cpnos work, debug the cpnos path,
  not "did I install the wrong PROM."

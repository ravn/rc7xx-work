---
name: Prefer canonical targets over enumerating dependencies
description: For LLVM lit / build / test workflows, use the canonical project-provided target (e.g., `check-llvm-codegen-z80`) rather than enumerating tools one at a time. Stated by user 2026-05-04 after CI whack-a-mole.
type: feedback
originSessionId: ea4ecd69-4e79-45f7-91f6-8a5e666d9c2f
---
For LLVM build/test infrastructure, prefer the **canonical project-provided target** over enumerating dependencies by hand.

For Z80 lit testing specifically:

  - **WRONG**: `ninja -C build clang llc FileCheck count not llvm-objdump llvm-nm llvm-readobj` then `build/bin/llvm-lit -v llvm/test/CodeGen/Z80/`.  This requires me to enumerate every tool the lit harness expects.  Each round of CI fails on the next missing tool (FileCheck → llvm-readobj → llvm-config → ...).

  - **RIGHT**: `ninja -C build check-llvm-codegen-z80`.  This is a phony target that depends on all 80+ binaries the lit harness expects in `build/bin` AND runs the lit suite as part of building it.  No enumeration; no dependency drift across LLVM upstream merges.

**Why:** Session 42 (2026-05-04) CI fix took 4 commits and 3 failed CI runs to enumerate the right tools, when one canonical target would have worked first try.  Whack-a-mole is a smell — when adding tool N+1 reveals a need for tool N+2, stop and look for a meta-target that sweeps them all up.

**How to apply:**

  - For "build everything needed to run lit X": look for `check-<X>` phony target in `ninja -t targets all | grep check-`.
  - For "build everything needed to run a benchmark": look for similar `check-` or `test-` umbrella targets.
  - For Makefile-based projects, look for top-level "all-test-deps" or "test-prereq" targets before listing leaf binaries.
  - When the project already has a canonical target, use it.  When it doesn't, write one — don't push the dependency-enumeration burden into the workflow yaml.

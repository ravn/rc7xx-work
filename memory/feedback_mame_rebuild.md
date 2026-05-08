---
name: Always full rebuild before MAME
description: Always force full rebuild (rm .o files) before launching MAME to avoid testing stale binaries
type: feedback
---

Before launching MAME for boot testing, always do a full rebuild — remove .o files and rebuild. Docker-based builds may not detect header changes (like string.h) due to timestamp mismatches between host and container.

**Why:** Stale .o files caused testing the wrong binary multiple times, wasting time and giving misleading results.

**How to apply:** Before any `make clang_mame` or manual MAME launch, run `rm -f clang_z80/bios.o` (or `make clang_clean`) first. Never trust incremental builds for MAME testing.

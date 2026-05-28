---
name: Fresh build before MAME
description: Always rebuild both BIOS and PROM before any MAME boot test
type: feedback
---

Always freshly compile both BIOS and PROM before booting MAME — never trust stale binaries.

**Why:** The PROM is installed to MAME's ROM directory and the BIOS is patched onto the disk image. If either is stale, the test results are meaningless. A fresh PROM with a stale BIOS (or vice versa) can mask bugs or show phantom failures.

**How to apply:** Before any `make mame*` or `run_mame.sh` invocation, ensure both `make prom` and `make bios` have run with current sources. The full rebuild flag (`rm -f clang/*.o`) should be used when in doubt.

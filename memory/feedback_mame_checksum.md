---
name: MAME PROM Checksum Verify
description: Always verify MAME's reported PROM checksum matches the expected build before trusting boot test results
type: feedback
---

Always check that the MAME-reported FOUND CRC matches the expected CRC for the PROM being tested, to avoid stale builds giving misleading results.

**Why:** Stale PROM files in the MAME roms directory can cause false test failures. The MAME boot test infrastructure copies prom0.ic66 to the MAME roms directory, but if the copy fails or uses a cached file, the wrong PROM gets tested.

**How to apply:** After `make clang_prom` and before interpreting MAME boot results, compare the CRC from `make clang_mame` output ("FOUND: CRC(...)") with the expected CRC of the just-built prom.bin. If they differ, the test is invalid.

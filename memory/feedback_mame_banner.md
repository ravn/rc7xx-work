---
name: Verify MAME boot banner compiler
description: After MAME boot test, verify the boot banner shows the correct compiler (CL for clang, ROA375 for SDCC) — fail if wrong
type: feedback
---

After running a MAME boot test, always check the PROM display banner to confirm the correct compiler was used. "RC700 CL" = clang build, "RC700 ROA375" = SDCC build. If the banner doesn't match the expected compiler, treat the test as FAILED and reinstall the correct PROM before retesting.

**Why:** The SDCC `make mame` target overwrites the clang PROM in the MAME roms directory. A stale SDCC PROM can silently pass a test that was meant to verify the clang build.

**How to apply:** After every MAME boot test, grep the PROM display output for the expected compiler string. Never declare PASS without verifying the banner.

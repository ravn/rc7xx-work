---
name: Verify DELAY_T in integration tests
description: Integration tests must verify that DELAY_T matches the actual inner loop T-states for each compiler
type: feedback
---

Part of the integration test is ensuring that the number of T-states for that compiler is correct for delay.

**Why:** DELAY_T=76 was wrong for clang for an unknown period (should have been 16), making boot 4.75× slower than intended. This went undetected because delays were too long (safe direction) but wasted boot time.

**How to apply:** When running MAME boot tests or integration tests, verify the delay() inner loop T-states match DELAY_T. Disassemble delay(), count T-states in the innermost loop (DEC+JR for clang, DJNZ for SDCC), compare against the #define. Flag any mismatch as a test failure.

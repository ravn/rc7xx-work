---
name: run-tests-locally-before-pushing-pr
description: HARD — Du må ikke skubbe direkte til PR/remote uden at have bygget og kørt testene lokalt først.
type: feedback
originDate: 2026-09-20
---

**User directive (2026-09-20):**

> "fakta: Du må ikke skubbe direkte til pr uden at have kørt tests lokalt."

**Why this exists:**
An agent added `test_67_fcmp_double.c` directly to PR #50 and force-pushed it to GitHub without executing it locally. The test called `a != b` which required `__nedf2`, but only `__eqdf2` was stubbed. Because the test was never run locally, the missing stub caused CI's test-runner to fail immediately with a link error (`ld.lld: error: undefined symbol: ___nedf2`).

**How to apply:**
1. **Never push to a PR or remote branch without local test verification.**
2. If changing compiler code or lit tests: run `ninja -C build-macos check-llvm-codegen-z80` (or the specific lit test).
3. If adding or modifying a C runtime test: run `BUILD_DIR=build-macos cargo run --manifest-path z80-utils/test-runner/Cargo.toml -- clang <test_name>` locally and verify `PASS` across all optimization levels before committing and pushing.

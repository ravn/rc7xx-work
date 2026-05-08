---
name: Integration tests are expensive
description: Only run z80-utils test-runner integration suite before merging or creating PRs, not during iterative development
type: feedback
---

Integration test suite (`cargo run -- clang` in z80-utils/test-runner/) is expensive and should only be run before merging or creating pull requests.

**Why:** Long execution time, blocks development flow.

**How to apply:** Use lit tests (`llvm-lit`) and edge-case tests for iterative development. Reserve full integration suite for pre-merge validation.

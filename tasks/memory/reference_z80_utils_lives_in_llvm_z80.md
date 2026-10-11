---
name: reference-z80-utils-lives-in-llvm-z80
description: z80-utils (test-runner, test-gen, benchmarks) lives INSIDE llvm-z80, not at the workspace root
metadata:
  type: reference
---

The runtime test harness directory is at:

```
/Users/ravn/z80/llvm-z80/z80-utils/
```

NOT at `/Users/ravn/z80/z80-utils/` (that path does not exist). This
trips tool-driven file placement: writing a new runtime fixture to
`/Users/ravn/z80/z80-utils/test-runner/testcases/clang/` succeeds
(creates nested dirs), but the test runner finds nothing there and
silently skips it.

### How to apply

- New runtime fixtures (`test_NN_*.c`) go in
  `/Users/ravn/z80/llvm-z80/z80-utils/test-runner/testcases/clang/`.
- `cargo run -- clang` runs from
  `/Users/ravn/z80/llvm-z80/z80-utils/`.
- Verify a new fixture was picked up by:
    - counting PASS lines (expected: N_fixtures × 6 opt levels), OR
    - `grep "test_NN" ` the runner output explicitly.
  Silent zero-match looks like success in the aggregate.

### Where this bit us

Session 2026-10-10: wrote `test_73_incdec_hl_indirect.c` to the wrong
`/Users/ravn/z80/z80-utils/...` path. Runner reported 438/438 PASS
without ever compiling test_73. Caught by comparing the pre-change total
(432 = 72×6) vs expected post-change total (438 = 73×6).

### Related

The workspace-root cross-machine autoload CLAUDE.md references several
"z80-utils/..." paths; all of those are relative to the llvm-z80
submodule, not to workspace root.

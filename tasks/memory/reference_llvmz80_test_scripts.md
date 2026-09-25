---
name: reference_llvmz80_test_scripts
description: Wrapper scripts at workspace root for running llvmz80 test-runner and z88dk integration tests
metadata:
  type: reference
---

Two convenience scripts at `/Users/ravn/z80/` (workspace root), added 2026-09-20:

## `./run-llvmz80-tests.sh`

Runs `z80-utils/test-runner` (Rust) with correct `BUILD_DIR`, sdcc and z80-utils
binaries on PATH.

```sh
./run-llvmz80-tests.sh              # clang all-opts + lit (standard check)
./run-llvmz80-tests.sh test         # all suites in parallel (816/841 pass)
./run-llvmz80-tests.sh full         # + torture + utils on both targets
./run-llvmz80-tests.sh clang        # only clang C-tests
./run-llvmz80-tests.sh lit          # only LLVM lit-tests
./run-llvmz80-tests.sh sdcc         # SDCC compatibility suite
./run-llvmz80-tests.sh utils z80    # elf2rel/rel2elf roundtrip + crosslink
./run-llvmz80-tests.sh torture      # GCC torture suite
./run-llvmz80-tests.sh clang -opt Os -native-oracle
```

Auto-detects `BUILD_DIR` (`build-macos` -> `build-linux` -> `build`).
Adds to PATH:
- `z88dk/src/sdcc-build/bin` — sdcc, sdasz80, sdldz80
- `llvm-z80/z80-utils/target/debug/` — elf2rel, rel2elf (needed by utils suite)

**Prerequisites for `full`/`utils`:** build `rel2elf` first:
```sh
cd llvm-z80/z80-utils && cargo build -p rel2elf
```

## `./run-z88dk-tests.sh`

Runs `z88dk/test/clang/run_all.sh` (the z88dk+llvmz80 integration suite).

```sh
./run-z88dk-tests.sh                      # classic clib (standard)
TEST_CLIB=newlib_iy ./run-z88dk-tests.sh  # newlib via llvmz80
TEST_TIMEOUT=60 ./run-z88dk-tests.sh      # longer per-test timeout
```

Both scripts auto-detect clang (`build-macos/bin/clang`), z88dk, and ntvcm.

## Known test-runner results (2026-09-22)

`./run-llvmz80-tests.sh test`:
- **816 PASS, 0 FAIL, 0 FATAL, 25 SKIP**

`./run-llvmz80-tests.sh full` (adds torture + utils to `test`):
- torture: **3308 PASS, 4 XFAIL, 3 FAIL** — all 3 failures are known clang
  16-bit limits (stack overflow on 10k-deep parentheses/struct nesting,
  no diagnostic for oversize string literal). Not regressions.
- utils: passes once `rel2elf` is built and on PATH (#359 fixed 2026-09-22)

## Suite structure

| Command | Suites included |
|---|---|
| `test` | clang, sdcc, llc, lit (parallel) |
| `full` | everything in `test` + torture (Z80+SM83 × O1/O2/Os) + utils (Z80+SM83) |
| `utils` | elf2rel/rel2elf roundtrip + crosslink groups |
| `torture` | GCC C torture suite (3315 tests) |

## Known pitfalls

- **`run_parallel` silent 0/0**: if a required binary (rel2elf, sdasz80) is
  missing from PATH, `run_parallel` (standalone `utils`) reports 0/0 ALL PASS
  silently. The sequential `run` (via `full`) reports all as FATAL. Always
  verify PATH before trusting 0/0 ALL PASS.
- **sdldz80 ar archives**: sdldz80 cannot lazily resolve symbols from ar
  archives via `-k`/`-l`. Always pass `z80_rt.a` as a direct file argument.
  See [[feedback_sdcc_memcpy_stub_fix]] and ravn/llvm-z80#359.

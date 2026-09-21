---
name: reference_llvmz80_test_scripts
description: Wrapper scripts at workspace root for running llvmz80 test-runner and z88dk integration tests
metadata:
  type: reference
---

Two convenience scripts at `/Users/ravn/z80/` (workspace root), added 2026-09-20:

## `./run-llvmz80-tests.sh`

Runs `z80-utils/test-runner` (Rust) with correct `BUILD_DIR` and sdcc on PATH.

```sh
./run-llvmz80-tests.sh              # clang all-opts + lit (standard check)
./run-llvmz80-tests.sh test         # all suites in parallel (810/841 pass)
./run-llvmz80-tests.sh full         # + torture on both targets
./run-llvmz80-tests.sh clang        # only clang C-tests
./run-llvmz80-tests.sh lit          # only LLVM lit-tests
./run-llvmz80-tests.sh sdcc         # SDCC compatibility suite
./run-llvmz80-tests.sh clang -opt Os -native-oracle
```

Auto-detects `BUILD_DIR` (`build-macos` -> `build-linux` -> `build`).
Adds `z88dk/src/sdcc-build/bin` to PATH for sdcc, sdasz80, sdldz80 etc.

## `./run-z88dk-tests.sh`

Runs `z88dk/test/clang/run_all.sh` (the z88dk+llvmz80 integration suite).

```sh
./run-z88dk-tests.sh                      # classic clib (standard)
TEST_CLIB=newlib_iy ./run-z88dk-tests.sh  # newlib via llvmz80
TEST_TIMEOUT=60 ./run-z88dk-tests.sh      # longer per-test timeout
```

Both scripts auto-detect clang (`build-macos/bin/clang`), z88dk, and ntvcm.

## Known test-runner results (2026-09-21)

`./run-llvmz80-tests.sh test`:
- **810 PASS, 0 FAIL, 6 FATAL (known), 25 SKIP**
- Known fatals: `test_25_i128_arith_O0` + `test_26_fixed_point_O0/O1` on BOTH
  z80 and sm83 (= 2x3). These are llc-suite tests for LLVM fixed-point
  intrinsics (`llvm.smul.fix`, `llvm.udiv.fix`) with no libcall in the runtime.
  Pre-existing gap, not a regression.

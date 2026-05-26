---
name: reference-z80-tool-paths
description: Full paths and canonical invocations for llvm-z80 / z88dk / test-runner / sweep — looked up repeatedly in sessions 60-70
metadata: 
  node_type: memory
  type: reference
  originSessionId: b20efbb1-10f2-452a-bfa2-432a9ba5a6a3
---

## Build & test tool paths

| Tool | Full path |
|---|---|
| ninja (ARM Mac, from CLion bundle) | `/Applications/CLion.app/Contents/bin/ninja/mac/aarch64/ninja` |
| Native clang (post-build, ARM Mac) | `/Users/ravn/z80/llvm-z80/build-macos/bin/clang` |
| Native llc | `/Users/ravn/z80/llvm-z80/build-macos/bin/llc` |
| Native opt | `/Users/ravn/z80/llvm-z80/build-macos/bin/opt` |
| Native llvm-nm | `/Users/ravn/z80/llvm-z80/build-macos/bin/llvm-nm` |
| Native llvm-lit | `/Users/ravn/z80/llvm-z80/build-macos/bin/llvm-lit` |
| z88dk-ticks (Z80 emulator for runtime verification) | `/Users/ravn/z80/z88dk/bin/z88dk-ticks` |
| zcc (z88dk C compiler driver) | `/Users/ravn/z80/z88dk/bin/zcc` |
| zmac (Z80 assembler) | `/Users/ravn/z80/rc700-gensmedet/zmac/bin/zmac` |

NOT a brew machine.  No system clang/llc/opt to be confused for the llvm-z80 ones.

## Canonical invocations

### Build llvm-z80 (macOS ARM, native, no Docker)

```
NINJA=/Applications/CLion.app/Contents/bin/ninja/mac/aarch64/ninja
cd /Users/ravn/z80/llvm-z80
$NINJA -C build-macos clang llc opt        # both clang+llc per feedback_ninja_clang_llc_together
```

After backend changes ALWAYS rebuild clang+llc together (the clang symlink would otherwise reference stale libLLVM if you `ninja llc` alone).

**Build size (for progress estimation, 2026-05-26):** a from-scratch `ninja clang llc`
is **~2897 ninja edges / ~2992 object files** (full Release build of clang+lld+llc).
So `[N/2897]` in ninja output tells you how far along.  Incremental relink after a
single backend `.cpp` change is ~2 min; from-scratch is much longer (the long tail is
LINKING the big static libs + executables, during which the .o count plateaus near the
top — don't mistake a stalled .o count for a hung build, check `pgrep ninja`).  sccache
(`/Users/ravn/.cargo/bin/sccache`) is wired in and gives heavy cache hits on the compile
phase.

### Assertions build (for miscompile hunting — debug-only / stats / stricter verifier)

The default `build-macos` is Release, `LLVM_ENABLE_ASSERTIONS=OFF` — so `-mllvm -debug`,
`-mllvm -debug-only=<pass>`, `-mllvm -stats` are all silent no-ops there.  For bug-hunting
use a parallel asserts build (`build-macos-asserts/`, first created 2026-05-26):

```
CM=/Applications/CLion.app/Contents/bin/cmake/mac/aarch64/bin/cmake
NINJA=/Applications/CLion.app/Contents/bin/ninja/mac/aarch64/ninja
cd /Users/ravn/z80/llvm-z80
$CM -C clang/cmake/caches/Z80.cmake -G Ninja -S llvm -B build-macos-asserts \
  -DCMAKE_MAKE_PROGRAM=$NINJA -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_ENABLE_DUMP=ON \
  -DCMAKE_C_COMPILER_LAUNCHER=/Users/ravn/.cargo/bin/sccache \
  -DCMAKE_CXX_COMPILER_LAUNCHER=/Users/ravn/.cargo/bin/sccache
$NINJA -C build-macos-asserts clang llc
```

Release `build-macos/` stays the production/size-measurement compiler (matches shipping).
Asserts build is for `-debug-only=<DEBUG_TYPE>`, `-stats`, and assert-fires-at-the-pass
during miscompile hunts.  These flags need `-mllvm`-prefix from clang (e.g.
`-mllvm -debug-only=machine-cse`).

### Run a single lit test

```
build-macos/bin/llvm-lit -v llvm/test/Transforms/AggressiveInstCombine/some-test.ll
```

Run the Z80 suite + a transforms suite together:
```
build-macos/bin/llvm-lit llvm/test/CodeGen/Z80/ llvm/test/Transforms/AggressiveInstCombine/
```

### z80-utils test-runner

Needs `BUILD_DIR` override (default is `../build`, not `../build-macos`) AND `z88dk-ticks` on PATH:

```
cd /Users/ravn/z80/llvm-z80/z80-utils/test-runner
BUILD_DIR=/Users/ravn/z80/llvm-z80/build-macos \
  PATH="/Users/ravn/z80/z88dk/bin:$PATH" \
  cargo run --release -- clang
```

Subsets: `clang` (C suite), `llc` (LLVM IR suite), `sdcc` (cross-build), `bench` (size benchmark vs SDCC).

### AES corpus sweep

```
cd /Users/ravn/z80/rc700-gensmedet/tasks/aes256-corpus
make clean && make sweep_clang        # clang side only, ~2 min
make sweep                            # clang + sdcc, ~4 min
make sizes                            # just print 4-variant binary sizes
```

The Makefile already pins `CLANG = /Users/ravn/z80/llvm-z80/build-macos/bin/clang` and uses Docker for zsdcc.  `make clean` is mandatory before re-sweep — make doesn't track the compiler binary as a build dependency.

### A/B a compiler patch against baseline

**FIRST check `rc700-gensmedet/tasks/aes256-corpus/baselines.md`** — it
records test-runner pass-counts and sweep numbers for recent llvm-z80
commits.  If the baseline you need is already there, you don't have to
stash + rebuild to re-derive it.  Update that file whenever a llvm-z80
commit moves the numbers.

Per [[feedback_ab_before_blaming_test_runner]]:

```
cd /Users/ravn/z80/llvm-z80
git stash
$NINJA -C build-macos clang llc                                       # stock
cd /path/to/test                                                        # rerun the failing thing
# capture pre-patch numbers
cd /Users/ravn/z80/llvm-z80
git stash pop
$NINJA -C build-macos clang llc                                       # patched
# rerun, compare
```

Always `git stash pop` before committing.

## Memory-rule pointers

Related rules already in memory (don't duplicate, just cross-reference):
- [[reference_build_binaries]] — same content, briefer
- [[feedback_ninja_clang_llc_together]] — why clang+llc together after backend changes
- [[feedback_check_memory_for_builds]] — always check this memory before guessing

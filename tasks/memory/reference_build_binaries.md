---
name: Build-tool binary locations
description: Where to find host build tools (cmake, ninja, llc, clang) when not on PATH; never use brew
type: reference
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
Host has **no brew, no cmake, no ninja on PATH**.  Working binaries:

- **CLion-bundled cmake**: `/Applications/CLion.app/Contents/bin/cmake/mac/aarch64/bin/cmake`
- **CLion-bundled ninja**: `/Applications/CLion.app/Contents/bin/ninja/mac/aarch64/ninja`
- **llvm-z80 asserts build dir (PRIMARY for testing)**: `/Users/ravn/z80/llvm-z80/build-macos-asserts/`
- **llvm-z80 host clang/llc (testing)**: `/Users/ravn/z80/llvm-z80/build-macos-asserts/bin/clang`, `…/bin/llc`
- **llvm-z80 Release build (firmware only)**: `/Users/ravn/z80/llvm-z80/build-macos/` (no assertions)
- **zmac**: `/Users/ravn/z80/rc700-gensmedet/zmac/bin/zmac` (build with `make` in zmac/ if missing)

To rebuild for testing after editing the Z80 backend:
```sh
PATH="/Applications/CLion.app/Contents/bin/cmake/mac/aarch64/bin:/Applications/CLion.app/Contents/bin/ninja/mac/aarch64:$PATH" \
  ninja -C /Users/ravn/z80/llvm-z80/build-macos-asserts clang llc opt FileCheck
```

For a full rebuild use `ninja -C /Users/ravn/z80/llvm-z80/build-macos-asserts`.

Docker is available (`docker images` works) for SDCC/z88dk and for the
`llvm-z80-build` image documented in the project CLAUDE.md, but native
build is faster when CLion's cmake+ninja are accessible.

---
name: Build-tool binary locations
description: Where to find host build tools (cmake, ninja, llc, clang) when not on PATH; never use brew
type: reference
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
Host has **no brew, no cmake, no ninja on PATH**.  Working binaries:

- **CLion-bundled cmake**: `/Applications/CLion.app/Contents/bin/cmake/mac/aarch64/bin/cmake`
- **CLion-bundled ninja**: `/Applications/CLion.app/Contents/bin/ninja/mac/aarch64/ninja`
- **llvm-z80 native build dir**: `/Users/ravn/z80/llvm-z80/build-macos/` (already configured for macOS host)
- **llvm-z80 host clang/llc**: `/Users/ravn/z80/llvm-z80/build-macos/bin/clang`, `…/bin/llc`
- **zmac**: `/Users/ravn/z80/rc700-gensmedet/zmac/bin/zmac` (build with `make` in zmac/ if missing)

To rebuild llc after editing the Z80 backend:
```sh
PATH="/Applications/CLion.app/Contents/bin/cmake/mac/aarch64/bin:/Applications/CLion.app/Contents/bin/ninja/mac/aarch64:$PATH" \
  ninja -C /Users/ravn/z80/llvm-z80/build-macos llc
```

For a full rebuild use `ninja -C /Users/ravn/z80/llvm-z80/build-macos`.

Docker is available (`docker images` works) for SDCC/z88dk and for the
`llvm-z80-build` image documented in the project CLAUDE.md, but native
build is faster when CLion's cmake+ninja are accessible.

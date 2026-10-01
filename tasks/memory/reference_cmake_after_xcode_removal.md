---
name: reference-cmake-after-xcode-removal
description: After Xcode was removed (disk space), cmake reconfiguration of build-macos-asserts requires extra flags; libtool and LibEdit paths differ.
metadata:
  type: reference
---

## Situation

Xcode was removed from this machine (disk space). Only Command Line Tools remain
at `/Library/Developer/CommandLineTools`. CMake cached the Xcode libtool path
`/Applications/Xcode.app/.../libtool` which no longer exists → `[code=127]`
link failures.

## Required cmake reconfiguration flags

```bash
export DEVELOPER_DIR=/Library/Developer/CommandLineTools

cmake -C clang/cmake/caches/Z80.cmake -G Ninja -S llvm \
  -B build-macos-asserts \
  -DCMAKE_MAKE_PROGRAM=$NINJA \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_ENABLE_DUMP=ON \
  -DLLVM_ENABLE_LIBEDIT=OFF \
  -DLLVM_ENABLE_LIBXML2=OFF \
  -DCMAKE_LIBTOOL=/Library/Developer/CommandLineTools/usr/bin/libtool
```

**Critical:** `-DLLVM_ENABLE_LIBEDIT=OFF` — LibEdit's CMake config has Xcode
SDK paths baked in (`/Applications/Xcode.app/.../MacOSX.sdk/usr/include`),
causing `CMake Error: non-existent path` during generate. Disabling it is safe
(only affects interactive readline in lldb/clang REPL, not compilation).

## Symptom without fix

```
FAILED: [code=127] lib/libLLVMDemangle.a
/bin/sh: /Applications/Xcode.app/.../libtool: No such file or directory
```

Also: `CMake Error in lib/LineEditor/CMakeLists.txt: Imported target
"LibEdit::LibEdit" includes non-existent path`.

## build-macos (Release) — same issue if reconfigured

Same flags apply if `build-macos` ever needs reconfiguration. Both build
dirs share the same host toolchain dependency.

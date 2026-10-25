---
name: feedback_read_cmake_cache_header
description: Når en dokumenteret build fejler, læs config-filens eget header-afsnit før improvisering af cmake-invocation
metadata:
  type: feedback
---

Når `make toolchain` eller andet dokumenteret build-kald fejler i llvm-z80, improvisér IKKE en cmake-invocation fra bunden. Åbn først `clang/cmake/caches/Z80.cmake` og læs headeren (linje 1-10) — den dokumenterer de nødvendige flag:

```
cmake -DCMAKE_DISABLE_PRECOMPILE_HEADERS=ON -DLLVM_CCACHE_BUILD=ON \
      -C clang/cmake/caches/Z80.cmake -G Ninja -S llvm -B build-macos-asserts
```

**Why:** 2026-10-22 brugte jeg 10+ min på en toolchain-build der kørte uden ccache fordi jeg glemte `CMAKE_DISABLE_PRECOMPILE_HEADERS=ON`. PCH gjorde 93% af compile-kald "uncacheable" i ccache. Flagene stod i Z80.cmake-filens første 10 linjer; [[feedback_ccache_llvm_build]] nævner `-C`-kaldet men ikke de to specifikke flag — så en der ikke læser selve cmake-filen fanger ikke flagene.

**How to apply:** 
- Hvis `make toolchain` fejler, kør det dokumenterede fallback-kald fra Z80.cmake's header, ikke dit eget.
- Hvis du laver en helt frisk build-dir (fx separat per branch), start med `head -15 clang/cmake/caches/Z80.cmake` for at få de aktuelle flag.
- Verificer ccache fungerer efter configure: `grep -c "LAUNCHER = .*ccache" build-dir/build.ninja` skal give > 0, og `grep -c "include-pch" build-dir/build.ninja` skal give 0.

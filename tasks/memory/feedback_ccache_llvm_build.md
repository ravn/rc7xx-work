---
name: feedback_ccache_llvm_build
description: ccache-opsætning for LLVM/Z80 byg: Z80.cmake er klar, macOS mangler ccache, kræver cmake-rekonfiguration
metadata:
  type: feedback
---

ccache er konfigureret i `clang/cmake/caches/Z80.cmake` via `CMAKE_C_COMPILER_LAUNCHER` / `CMAKE_CXX_COMPILER_LAUNCHER` (no-op hvis ccache ikke er installeret). **Z80.cmake er commit `1c475cd1630e` fra sonnyboy 2026-09-25.**

**Aktuel tilstand (2026-09-25/30):**
- macOS testing (`build-macos-asserts/`): **PRIMARY for all testing** (asserts, ccache AKTIV). `export PATH="/Users/ravn/z80/ccache/install/bin:$PATH"` nødvendigt.
- macOS firmware (`build-macos/`): Release build, firmware builds only, ccache AKTIV.
- Linux/sonnyboy (`build-linux/`): antages korrekt konfigureret (frisk cmake-kørsel med ny Z80.cmake).

**Regel:** Når et build-dir rekonfigureres, ALTID bruge:
```bash
cmake -C clang/cmake/caches/Z80.cmake -G Ninja -S llvm -B build-macos-asserts
```
Dette sikrer ccache aktiveres automatisk hvis installeret, og alle andre Z80.cmake-indstillinger er med.

**Why:** Inkrementelle builds der kun genbuilder `llc`/`clang` med `ninja -C build-macos-asserts llc clang` men ikke rekonfigurerer kan give delvis-build-fejl (opt crashede på z80 target triple 2026-09-25 fordi `libLLVMTransformUtils` ikke var genbygget efter `BuildLibCalls.cpp`-ændringer i pr-367).

**How to apply:** Hvis der er et nyt cmake-cache i `build-macos-asserts/CMakeCache.txt` der er ældre end Z80.cmake, kør `cmake -C ...` inden næste build. Full rebuild kræves hvis LLVM core libs er ændret (ikke kun Z80-backend).

#!/usr/bin/env python3
"""PreToolUse hook on Bash: warn if cmake invocation ignores Z80.cmake header.

Non-blocking advisory. Fires when Bash command contains 'cmake' with -B/-S flags
and does NOT already pass CMAKE_DISABLE_PRECOMPILE_HEADERS=ON.
"""
import json
import sys

try:
    data = json.load(sys.stdin)
    cmd = data.get("tool_input", {}).get("command", "")
except Exception:
    sys.exit(0)

if "cmake" in cmd and (" -B " in cmd or " -S " in cmd):
    if "CMAKE_DISABLE_PRECOMPILE_HEADERS" not in cmd:
        print(
            "ADVISORY: cmake invocation without CMAKE_DISABLE_PRECOMPILE_HEADERS=ON. "
            "If building llvm-z80, read clang/cmake/caches/Z80.cmake lines 1-10 "
            "for required flags (PCH-off + LLVM_CCACHE_BUILD=ON for ccache). "
            "See tasks/memory/feedback_read_cmake_cache_header.md.",
            file=sys.stderr,
        )
sys.exit(0)

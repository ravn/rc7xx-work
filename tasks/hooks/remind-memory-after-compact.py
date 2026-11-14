#!/usr/bin/env python3
"""UserPromptSubmit hook: nudge re-reading MEMORY.md.

Fires on every user prompt. Cheap and ensures /compact can't bypass.
Prints a short reminder to stdout which Claude Code injects as context.
"""
import sys

print(
    "REMINDER: tasks/memory/MEMORY.md is authoritative — "
    "re-read §0 ABSOLUTE and §1 Always-on rules if session was "
    "resumed via /compact or context summarization. "
    "Especially: read config file headers (e.g. "
    "clang/cmake/caches/Z80.cmake:1-10) before improvising cmake invocations.",
    file=sys.stdout,
)
sys.exit(0)

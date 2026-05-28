---
name: No catastrophic regex on source code
description: Don't use Python `re.DOTALL` with non-greedy `.*?` over multi-KB source files; use line-based awk/grep or a structural parser instead
type: feedback
originSessionId: de6f9865-d9ee-4776-abd2-c579088d6b91
---
HARD RULE: when scanning source files (C/asm/etc.) with regex, DO NOT
combine `re.DOTALL` with non-greedy quantifiers (`.*?`, `.+?`) across
multi-line patterns.  The engine's backtracking on real source code
will hit pathological cases and hang for minutes (effectively
indefinitely on a watchdog-killable budget).

**Why:** session 47 (2026-05-07) -- a Python scan for "C function
definitions with >3 args" using `re.compile(r'.*?\)\s*\{', re.DOTALL)`
ran for >5 minutes across ~20 files (~100KB total) before being
killed.  Three jobs piled up in the background, contributing nothing,
because the same scan kept getting re-attempted with slight tweaks.
Plain `awk` doing line-based comma counting answered the question
in milliseconds.

**How to apply:**
- Default to line-based tools: `grep -n`, `awk`, `rg --multiline=false`.
- If you need to span lines, write a hand-rolled state machine in
  Python (depth counter for parens, no regex) -- iterate one char at
  a time.  Predictable O(n).
- If you must use regex with DOTALL, anchor on rare delimiters
  (e.g., `\Z`, end-of-file) and avoid `.*?` -- prefer `[^X]*`
  character-class negations.
- When a script doesn't return within ~10s on a small input, kill it
  immediately; iterate on a smaller pattern, don't tweak and re-run.

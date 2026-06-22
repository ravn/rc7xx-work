---
name: bsd-awk-only-on-macos
description: macOS ships BSD awk; avoid gawk-only features (strtonum, gensub, asort, length(arr), etc.). Use Python for any numeric / hex parsing in scripts.
metadata:
  type: feedback
---

The user's macOS host has only BSD awk available -- no gawk fallback.
gawk-only features will fail with `calling undefined function ...`
errors.

**Why:** user reinforced 2026-06-21 after `strtonum` failure in an
AES-corpus loop-tail scan.  Easy to forget because gawk is the
default on Linux; macOS / FreeBSD ship BSD awk and `awk` resolves to
it.

**How to apply:**
- Don't use these gawk-only features in inline awk:
  - `strtonum(...)` (hex / octal parsing) -- use Python: `int(x, 16)`.
  - `gensub(...)` -- use `sub(...)` / `gsub(...)` (which BSD awk has)
    or Python re.sub.
  - `asort(arr)` -- use `sort` via pipe or Python.
  - Array length via `length(arr)` -- BSD awk supports this since 2009
    but older systems didn't; use `for (k in arr) n++` if unsure.
  - GNU-only regex (e.g. `\<` word boundary) -- use POSIX or Python.
- For anything requiring numeric parsing (esp. hex), reach for Python
  directly rather than trying to make BSD awk handle it.
- Inline awk is fine for line-filtering with regex matches and
  string field extraction -- BSD awk handles those well.

Related: this is part of the broader "macOS host quirks" theme along
with `[[feedback_no_brew]]` and `[[reference_z80_tool_paths]]`.

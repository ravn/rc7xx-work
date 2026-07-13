---
name: macOS awk lacks strtonum (and other gawk extensions)
description: The default macOS awk (BWK/onetrueawk) has NO strtonum(), gensub(), or other gawk-only functions. Hex-parsing awk one-liners silently fail (return 0 / "undefined function"). Use python/printf/shell arithmetic instead, or gawk.
metadata:
  type: reference
---

**macOS's default `awk` is BWK awk (onetrueawk), NOT gawk** — so `strtonum()`,
`gensub()`, `and()/or()/lshift()`, `systime()`, etc. do NOT exist. An awk script
using them fails with `awk: calling undefined function strtonum` and the whole
expression evaluates to nothing (often silently producing empty/`0` output).

Bit me 2026-07-13 summing hex symbol sizes from `llvm-nm --print-size`:
`awk '{s+=strtonum("0x"$2)}'` → `undefined function strtonum` → 0.

**How to apply — for hex/number crunching in a macOS shell, don't reach for awk's
gawk extensions. Use one of:**
- **python3** (always present here): `... | python3 -c "import sys;print(sum(int(l.split()[1],16) for l in sys.stdin))"`
- **shell arithmetic**: `$((16#deadbeef))` (bash/zsh understand base#value)
- **printf**: `printf '%d\n' 0xdeadbeef`
- plain awk hex only via `"0x"$1 + 0` does NOT work in BWK awk either (no hex
  auto-parse); it needs strtonum, which is absent — so just avoid awk for hex.
- If you truly need gawk features, there is no gawk by default and **no brew**
  on this box (see environment rules) — so python is the go-to.

Portable awk (no gawk ext) is fine for field extraction / plain decimal sums;
only the gawk-only builtins are missing.

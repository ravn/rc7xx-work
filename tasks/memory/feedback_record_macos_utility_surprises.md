---
name: Record macOS utility surprises (with workaround) in memory
description: Whenever a macOS command-line utility behaves differently than expected (BSD vs GNU flags, missing features, different defaults), immediately save a memory note with the surprise AND the workaround so it is not rediscovered.
metadata:
  type: feedback
---

**When a macOS utility surprises you, write a memory note with the workaround.**

**Why:** This box is macOS (Darwin) with BSD userland, not GNU/Linux. Many
utilities differ from their GNU counterparts — different flags, missing
features, different defaults — and there is **no brew** to install GNU versions.
Rediscovering each difference mid-task wastes time and derails the work. (User
directive 2026-07-13, prompted by the awk/strtonum case.)

**How to apply:** the moment a `awk`/`sed`/`grep`/`date`/`stat`/`find`/`xargs`/
`readlink`/`base64`/`tr`/... command errors or silently misbehaves in a way that
looks BSD-vs-GNU, STOP and save a `reference`-type memory: what surprised you +
the working workaround (usually python3, or the BSD-correct flag). One note per
distinct surprise; add a terse one-line pointer in MEMORY.md.

Known instances so far (extend this list / link new notes):
- [[reference_macos_awk_no_strtonum]] — default awk is BWK, not gawk: no
  `strtonum()`/`gensub()`/hex-parse. Use python3/printf/`$((16#..))`.

Common BSD-vs-GNU gotchas to expect (verify + note when hit): `sed -i` needs an
arg (`sed -i ''`); `date` uses `-v`/`-j -f` not `-d`; `stat` uses `-f`/`%Sm` not
`-c`/`--format`; `readlink` has no `-f` (use `python3 -c 'os.path.realpath'`);
`find` lacks `-printf`; `grep -P` (PCRE) is absent; `xargs` differs on `-r`.
Reach for **python3** (always present) when a GNU-ism is missing.

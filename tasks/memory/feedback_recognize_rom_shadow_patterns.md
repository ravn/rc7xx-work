---
name: feedback-recognize-rom-shadow-patterns
description: Wrong-data bytes that match in-tree ROM contents = strong signal of PROM shadow / mirror or unmapped read
metadata: 
  node_type: memory
  type: feedback
  originSessionId: b20efbb1-10f2-452a-bfa2-432a9ba5a6a3
---

**Rule:** When a buffer or port read produces "wrong" bytes that
look ASCII / structured, compare them against the contents of your
own ROM / firmware image BEFORE investigating wire-level
hypotheses.  If the wrong bytes happen to be `prom.bin[N..N+k]` for
any N, the bug is almost certainly a memory-map / shadow issue
(read-only region, bank mirror, unmapped page returning ROM data)
-- NOT a transport problem.

**Why:** In cpnos-in-asm session 73e the corrupted RX buffer
contained `08 20 20 52 43 37 30`.  Decoded as ASCII that's
`<BS><sp><sp>RC70` -- a banner-fragment-shaped sequence that I read
as "data leaked in from the slave's own banner stream."  The truth
was simpler: those 7 bytes were literally `prom1.bin[0..6]` -- the
`dw slave_entry` (`08 20`) followed by the first 5 bytes of the
`db " RC702"` signature (`20 52 43 37 30`).  An `xxd prom1.bin |
head -1` would have made the match unmistakable.

I missed it because:
  - The "RC70" fragment pattern-matched as banner first
  - I wasn't thinking about the binary contents of my own PROM as
    a potential read source
  - The hypothesis "data is coming from somewhere it shouldn't"
    blinded me to "data is being read from ROM, not RAM"

**How to apply:** When you see suspicious bytes in a buffer read
or port read:

  1. `xxd build/prom*.bin | head -3` (or whatever's relevant) and
     scan for matches against the suspicious sequence.
  2. If a match exists at any offset, immediate hypothesis: the
     read landed in PROM-mirror / ROM-shadow / unmapped region
     that returns ROM bytes by default.
  3. Cross-check with the target's mem_map (see
     [[feedback-grep-memmap-before-bss]]) to identify the region.

This is fast and decisive when it applies.  When the suspicious
bytes don't match any ROM image, you've ruled out a whole class of
bugs and can move on to other hypotheses.

**Related:**
  - [[feedback-verify-writes-before-chasing-reads]] -- the broader
    diagnostic ordering rule this rule fits inside.
  - [[feedback-rc702-bank2h-mirror]] -- the canonical instance.

---
name: grep-repo-docs-before-deriving
description: "HARD — before re-deriving an encoding/bit layout/address map from raw data or experiments, grep repo for an existing *_REFERENCE.md / *_CHARACTER_ROM.md that may already document it"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6bb2377c-77ab-4014-8339-b92776bcffc5
---

**HARD RULE:** Before deriving a low-level fact (chargen bit layout,
register encoding, memory map, byte format) from raw data or
experimentation, grep the repo for an existing reference doc that
may already document it.

**Why:** session 73j (2026-05-17) spent two screenshot iterations
rediscovering the ROA327 sextant bit encoding by inspecting raw ROM
bytes -- when `ROA327_CHARACTER_ROM.md:155-194` already documented it
exactly:
- bit 0 = top-left, bit 1 = top-right, ... (got direction wrong first)
- left half = 4 dots / mask `0x0F`, right half = 3 dots / mask `0x70`
- (my first attempt: bit-reversed bytes `0x0E`/`0xF0`/`0xFE`, claiming
  SEM702 wanted LSB-first vs ROA327's "MSB-first" -- both halves of
  that assumption were wrong and compounded into a visibly broken QR
  on first MAME snapshot)

**How to apply:** when starting any hardware-adjacent task, run a
30-second `grep -rln '<chip-or-component-name>'` and read the matching
docs section.  Cost: 30 s upfront vs. multiple rebuild/snapshot/debug
cycles when assumptions are wrong.

Generalizes [[feedback-grep-memmap-before-bss]] from memory layouts to
encoding/bit-format facts.  Cross-listed with
[[feedback-consult-rules-before-acting]] (that one covers MEMORY.md;
this one covers repo docs).

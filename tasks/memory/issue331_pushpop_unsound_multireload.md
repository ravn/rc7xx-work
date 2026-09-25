---
name: issue331_pushpop_unsound_multireload
description: ravn/llvm-z80#331 SP-relative spill->PUSH/POP peephole is unsound — converting spill+first-reload drops later reloads of the same slot; parked.
metadata:
  type: feedback
---

The draft `optimizeSPRelativeSpillToPushPop` peephole (ravn/llvm-z80#331) is a
**miscompile** and is PARKED. It converts an SP-relative spill and its *first*
reload to `push rr`/`pop rr`, but any *later* SP-relative reload of the same
frame slot survives and reads the prologue-allocated slot — which PUSH never
writes (PUSH allocates its own fresh 2 bytes). The stale slot corrupts the
value; recursion (ackermann: value reloaded before AND after a call) hangs.

**Why:** a spill->PUSH/POP conversion is only sound if the slot is read
**exactly once** (the matched reload) with no other SP-relative access before
end-of-liveness. The draft never checked reader-count — same guard class the
BSS-spill peepholes already carry (cross-block / orphan-access / stack-depth).

**How to apply:** before ANY spill->push/pop (or store->push) conversion, prove
the slot has a single reader. Detector: `test_22_recursion.c` @ Os hangs if a
naive #331 is reintroduced. Full analysis:
`llvm-z80/tasks/issue331-sprelative-pushpop-unsound-2026-09-16.md`. Lit:
`issue-331-spill-push-pop.ll` now documents the parked status. Only worth 4
compressed B on autoload — not pursued. See [[issue267_pseudo_undersize_class]].

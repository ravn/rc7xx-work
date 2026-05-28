---
name: Consider T-states not just bytes
description: When comparing instruction sequences, evaluate both code size AND execution time (T-states)
type: feedback
---

When evaluating whether one instruction sequence is better than another, consider both byte count AND T-state (execution time) cost. A 1-byte savings that costs many T-states may not be worth it, especially in hot loops.

**Why:** The user wants optimal code, not just small code. Z80 runs at 4MHz so cycle counts matter for timing-sensitive operations (FDC, DMA, CRT refresh).

**How to apply:** When implementing or reviewing peepholes, document both byte and T-state impact. Flag any trade-off where bytes are saved at T-state cost. Key reference T-states: LD r,r'=4T(1B), LD r,n=7T(2B), LD rr,nn=10T(3B), PUSH=11T(1B), POP=10T(1B), PUSH IX=15T(2B), POP IX=14T(2B).

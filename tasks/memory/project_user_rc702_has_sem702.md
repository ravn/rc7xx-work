---
name: project-user-rc702-has-sem702
description: The user's PHYSICAL RC702 has the SEM702 RAM character generator (not ROA327); autoload's define_sextants() is essential on it, not waste. Corrected 2026-07-01.
metadata:
  type: project
---

**The user's own physical RC702 is fitted with the SEM702 RAM-backed
character generator** (the piggyback board on the ic82 / chargen socket),
**NOT** the baseline ROA327 font ROM.  Other machines in the wild have
ROA327.

**Why it matters / how to apply:** autoload calls `define_sextants()`
unconditionally at boot (`autoload-in-c/rom.c:~1000`) to program the 64
sextant glyphs into the SEM702 RAM.  It is **essential on the user's
hardware** — do NOT treat it as dead code / waste and do NOT propose
gating or removing it to save PROM or boot time.  Measured cost is
**~79 ms** (4352 port writes to 0xD1/0xD2/0xD3), which the user has
explicitly accepted.  On ROA327-only machines the writes are a safe
no-op (those ports go nowhere), so the unconditional call is the correct
design for both variants — there is no way to detect SEM702 presence in
software, so it cannot be conditionalised on hardware.

I wrongly assumed the user's machine was ROA327 on 2026-07-01; corrected
here.  Related: [[project-sem702-request-chip-photo]] (the SEM702
add-on boards), the `rom.c` ALINE `TODO(physical-machine)` at
`autoload-in-c/rom.c:234`.

---
name: Ask before making design decisions
description: When a design choice has multiple viable options, lay them out and ask the user — don't pick unilaterally and present it as the design
type: feedback
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
At any non-obvious design fork, **lay the options out and ask the user
to pick.**  Don't pick one path, write the design doc around it as
"the decision," and proceed.  The user wants to be in the loop on
architectural choices so they know what is going on and can redirect
before code is written.

**Why:** Restated by the user 2026-04-26 after the cpnet-fast-link
MAME work boxed itself into a slot-wrapper-on-Z80-PIO design
(`bus/rc702/pio_port/`) that turned out to be both:

  - blocked by a MAME bug (ravn/mame-rc702-rc759-rc750#6 — any card on a Z80-PIO slot
    breaks IM2 IRQs) that took most of a session to narrow, and
  - architecturally heavier than the proven-working alternative
    (Xerox 820, Attache, Altos 5, Bullet, original pre-slot RC702
    all wire peripherals direct to Z80-PIO callbacks; MAME's slot
    abstraction is not the only legitimate pattern).

I had committed `3b2d76f23ef` ("rc702: expose Z80 PIO ports as
configurable slot devices") presenting "slots that mirror rs232a/b"
as the decision rather than as one option among two.  The plain-
wiring alternative (proven and simpler) was never surfaced.  The user
called this out late in the session: "did you ask me if I wanted
plain ports or two slots on the pio?"  No — I went one way and
documented it as the design.

**How to apply:**
- When a design has more than one viable shape and the trade-offs
  are non-trivial, **enumerate the options BEFORE writing the design
  doc or the first commit.**  Two or three lines per option:
  what it looks like, what it gains, what it costs.  Then ask which
  one to pursue.
- "Non-obvious design fork" includes: which MAME pattern (slot vs
  direct), which build target (lit test vs integration test vs
  external repro), which framing (refactor existing vs new module),
  which device shape (callback vs bus device vs slot card).  When in
  doubt, surface it.
- **Don't bury the alternatives in justification text inside a
  design doc.**  A doc that says "we picked X because Y" without a
  prior "we considered X / Y / Z" decision section is hiding the
  fork.
- For tiny tactical choices inside an already-agreed design (variable
  names, helper-function placement, log-line wording), don't ask —
  just decide.  This rule is for choices that affect the shape of
  the work, not the texture.
- If a forked decision was already made in a prior session and is
  now being revisited because of new information, surface that too:
  "I previously picked X; now Y looks viable — should we switch?"

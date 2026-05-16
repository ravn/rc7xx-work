---
name: feedback-zmac-local-label-scope
description: "zmac doesn't scope dotted local labels per parent; identically-named ones collide as multi-def"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: b20efbb1-10f2-452a-bfa2-432a9ba5a6a3
---

**Rule:** zmac (the assembler we use for cpnos-in-asm and other
hand-asm Z80 work) does NOT implement per-parent scoping for dotted
local labels.  A label like `.wait:` is GLOBAL with a leading dot,
so two `.wait:` labels in different subroutines (e.g. one in
`sio_a_tx_d` and one in `sio_b_tx_d`) trigger:

    src/prom1.asm(NNN) : Mult. def. error
        .wait:

**Why:** Cost us a build cycle in cpnos-in-asm phase 3d-γ when I
added a sio_b_tx_d helper with the obvious `.wait:` label, having
forgotten that sio_a_tx_d already used one.  Other assemblers
(z88dk-z80asm, sjasm, sdasz80) scope dotted labels under their
preceding non-dotted label, but zmac doesn't.

**How to apply:** Treat dotted local labels in zmac as if they were
unscoped.  Disambiguate by prefix with the function-name initials:
`.a_wait` for sio_a, `.b_wait` for sio_b, etc.  Worth doing
proactively when copying a subroutine to make a sibling: rename its
locals before adding the duplicate to the source file.

If you need TRUE per-parent local labels in a future
hand-asm project, consider sjasm or z80asm instead.

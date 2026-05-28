---
name: slave-state-outside-tpa
description: Slave-side RAM state (cursor, ring buffers, BSS) MUST live above BDOS, not in TPA -- CP/M programs load and run inside TPA and will silently overwrite anything in 0x0100..0xE715.
metadata:
  type: feedback
---

When a CP/M slave (cpnos-in-asm, cpnos-in-c, similar) needs RAM for
its own state (cursor position, keyboard ring, scratch buffers, IVT
slots), pin it ABOVE BDOS, not inside the TPA.  TPA = 0x0100..BDOS-1
(BDOS-1 = 0xE715 in our cpnos layout) is where every program the
user runs gets loaded; the program's code, data, heap, and stack all
live there and freely overwrite whatever they please.  A `dot_row`
at 0x4003 (TPA mid-range) will be silently clobbered the moment a
program like PolyPascal allocates memory, even if the program never
explicitly references that address.

**Why:** Caught session 73g.  cpnos-in-asm originally had
`dot_cursor` / `dot_col` / `dot_row` at 0x4000..0x4003 (inherited
from prom1.asm's netboot-progress state).  After handoff to NDOS,
PPAS startup made the CRT cursor jump from row 3 to row 23 even
though only 5 CRLFs went through impl_conout — PPAS's stack /
working memory was stomping on `dot_row`.  Visible symptom: PPAS
banner output landed 15+ rows past the previous cursor, scrolling
the CP/NOS banner off the top of the screen prematurely.  Diagnosis
took an instrumented marker `#NN` (high+low hex of new row) emitted
on every dot_row save to count writes via the SIO-B mirror.

**How to apply:** Use 0xEC00 / 0xED00 / 0xF500 (the IVT-safe pages
called out by [[project_rc702_ivt_page_constraint]]).  0xEC00..0xECFF
is the natural place for cursor + small per-frame state on RC702;
0xED00..0xF7FF is the snios_payload resident area.  When inheriting
state from a pre-handoff phase (PROM-resident code), audit the chosen
address against the TPA / display / vector regions BEFORE handoff,
not after — the failure mode is silent corruption mid-test.  Same
rule applies to anywhere prom1.asm reserves "scratch" memory it
expects the resident slave to keep using.

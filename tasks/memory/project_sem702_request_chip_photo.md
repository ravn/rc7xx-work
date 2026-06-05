---
name: project-sem702-request-chip-photo
description: When working on the physical RC702 again, ASK the user to photograph the SEM702 piggyback boards so we can identify the actual chip set; standing request from 2026-06-04
metadata:
  type: project
---

When real-hardware work on the RC702 next resumes, **ask the user to
take a photograph of the SEM702 add-on boards** (top-cover off; both
the large board piggybacked on ic82 / ROA327 socket *and* the small
board under ic68 / Am9517A-4 DMA) and post it in chat for chip
identification.

**Why:** session 2026-06-04 audited the SEM702 docs.  `RC702tech.pdf`
(physical pp. ~215-217, OCR at `docs/RC702tech.txt:17217+`) describes
the install procedure but the OCR of fig.1 / fig.2 is mangled and the
chip markings ("…LS5303" etc.) are unreadable.  No standalone SEM702
schematic exists in the repo (only the embedded PDF pages).  The
behavior in `autoload-in-c/rom.c:234` -- "ALINE must be set
explicitly before each AWR write; no evidence the chip
auto-increments" -- is *currently* a TODO marked
`TODO(physical-machine)` because MAME's strict-latch model can't
falsify auto-increment.  User confirmed in chat ("jeg mener der er et
billede af den i en af manualerne") that they recall seeing the chip
in a manual; a real-board photo is the cheapest path to nailing down
which TTL latches + SRAM are actually in there, and (once the part
numbers are known) datasheet-level confirmation of the latch /
no-auto-increment behavior.

**How to apply:** the trigger is "we are about to interact with the
user's physical RC702" -- e.g. top cover already off for the parallel
cable plug-in tied to
[[project-cpnos-parked-awaiting-parallel-cable]], a bring-up of
autoload on real hardware, any session that the user opens with
"I'm at the machine" / "RC702 is on the bench" / similar.  Surface
this BEFORE the cover goes back on, in one line: "while the cover is
off, can you snap a photo of the SEM702 boards (large one on ic82,
small one under ic68)?  per
`[[project-sem702-request-chip-photo]]`".  Drop the reminder once the
photo arrives (delete this file + index entry).

Related: [[user-no-hw-mods]] (photo is read-only, no PCB mods
involved); [[project-cpnos-parked-awaiting-parallel-cable]] (likely
next physical-hardware session); the `rom.c` comment at
`autoload-in-c/rom.c:234` is the code site this reminder is meant to
resolve.

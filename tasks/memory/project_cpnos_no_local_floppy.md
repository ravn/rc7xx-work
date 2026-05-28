---
name: CP/NOS scope — no local floppy
description: CP/NOS payload must remain diskless; bolting drive B: onto it is explicitly out of scope
type: project
originSessionId: b07ba379-19bf-4244-a50b-7118b0bab69d
---
CP/NOS on RC702 is intentionally diskless — all storage goes over CP/NET to the host. Do not propose, plan, or implement local-floppy access (drive B: as physical 8" disk) on CP/NOS.

**Why:** CP/NOS BDOS (cpbdos.asm) implements only functions 0-12 by design — no SELDSK/READ/WRITE path. Adding local disk support requires either replacing the BDOS, routing disk BDOS calls through NDOS, or NDOS-bypass disk handling. All three are architecturally non-standard for a CP/NOS slave and were rejected as out of scope. The Phase 20 fdc-variant attempt (in tasks/timeline.md) hit this wall after building a complete µPD765 + DPB + deblocker stack.

**How to apply:** If a task implies local floppy on CP/NOS (e.g. "drive B: read", "TYPE from floppy on slave", "FDC support"), surface the scope conflict before starting. The rcbios path is the right place for local-floppy code, not cpnos-rom. If user explicitly reopens this scope in a later session, this memory can be updated.

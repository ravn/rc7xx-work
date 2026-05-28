---
name: Fast host link is CP/NET + CP/NOS only
description: The fast host<->RC702 transport currently being designed exists solely to carry CP/NET / CP/NOS protocol traffic; not a general terminal/console/file path
type: project
originSessionId: b07ba379-19bf-4244-a50b-7118b0bab69d
---
The "fast host link" work (PIO/SIO investigation, parallel cable, etc.) has a single purpose: carry CP/NET + CP/NOS network protocol frames between the RC702 and a host-side master. It is **not** a general-purpose console, terminal, file-transfer, or RDR/PUN/LST replacement.

**Why:** User clarified explicitly 2026-04-25. This narrows the design dramatically:
- Half-duplex is fine (CP/NET is request/response by construction).
- The link does NOT need to coexist with terminal/login traffic; SIO-A can stay as a user terminal but is not part of the link.
- Packet boundaries are protocol-defined (SCB header carries length), so direction switching at packet boundaries is "free".
- Reliability matters more than peak throughput; corruption corrupts the filesystem.

**How to apply:**
- When considering scenarios, optimise for "CP/NET frames flow reliably and as fast as practical" rather than "general-purpose fast comms".
- Don't propose designs that consume SIO-A or SIO-B for the network channel unless there's a strong reason — but consuming SIO-A is acceptable for the fast Z80->host direction (Option K).
- User has full control of firmware, host software, cable, and MAME driver — proposals can include all of these. New cables are fine.
- **Long-term goal (clarified 2026-04-25):** a small always-on server (Raspberry Pi 4B or 3B, optionally fronted by Pico(s)) sits next to the RC702 and bridges it to the outside world via CP/NET. So the production deployment is Topology B (Pi as standalone host, runs z80pack-as-CP/NET-master natively); Topology A (Mac + Pico USB-CDC) is the dev-iteration shape only. Same wire protocol on both — code written for A ports cleanly to B.
- **Architecture committed to:** Option K — PIO-A (J4 keyboard cable, existing `ravn/cbl923` Pi Pico keyboard rig) for host->Z80; SIO-A sync-mode TX at 614 kbaud (J1 cable + MAX3232) for Z80->host. Two cables, one half-duplex link per direction, no PCB mods.
- **Phase as of 2026-04-25:** DESIGN ONLY. User does not currently have the Pi hardware on hand and does not want bring-up code written yet. Stay in design artifacts (markdown docs, decision logs, planning checklists) — do NOT write Pico firmware, Z80 bench tests, or host daemons in this phase. Wait for an explicit "start coding" signal that follows hardware acquisition.

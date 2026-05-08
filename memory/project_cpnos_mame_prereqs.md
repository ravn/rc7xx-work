---
name: CP/NOS MAME bring-up prerequisites
description: Operator-side prerequisites for booting CP/NOS in MAME — what must be running, in sync, and clean before any CP/NOS-in-MAME test (including the cpnet_bridge fast-link harness) can succeed
type: project
originSessionId: b07ba379-19bf-4244-a50b-7118b0bab69d
---
For CP/NOS to actually load in MAME via the netboot path, the
following operator-managed conditions all have to be true. None of
this is automated by the test harness; if any condition is
violated, the netboot session typically aborts early ("client
closed waiting for ENQ" in the server log) and the Z80 sits in the
autoload PROM forever, so init_hardware() never runs and
isr_pio_par / any other resident-payload behaviour never fires.

1. **z80pack-as-MP/M-master is running** on the expected port (port
   chosen by the user; CLAUDE.md references :4002 for the
   z80pack-MP/M flow but cpnos-rom Makefile defaults to :9000 with
   netboot_server.py).  `cpnos-rom/netboot_server.py` is a Python
   replacement for z80pack's MP/M serve role, but recent cpnos-rom
   versions appear to need full MP/M, not the Python stand-in.
2. **No stale client connection** on the MP/M server.  A previous
   failed MAME run can leave the server's session state confused;
   restart z80pack between runs if the boot fails repeatedly.
3. **NDOS file on the MP/M server is up to date** with what
   cpnos-rom expects.  When cpnos-rom changes (especially the SNIOS
   wire calls or the BIOS_BASE relocation), the NDOS file may need
   re-syncing.  See `cpnet-z80/dist/` or wherever the user's NDOS
   sources live (the user owns these, no live upstream — see
   project_dri_ndos_frozen memory).
4. **cpnos-rom built recently** (`make cpnos` in cpnos-rom/).
5. **ravn/mame:cpnet-fast-link branch built** as
   `/Users/ravn/z80/mame/regnecentralend` for any test that uses
   the CP/NET fast-link bridge slot (Option P).

**Why:** Stated by user 2026-04-25 while debugging the cpnet_bridge
end-to-end harness.  Multiple incremental hints:
- "mp/m must be running, and not have a stale connection"
- "and the ndos file in the mp/m server must be up to date"

**How to apply (revised 2026-04-25):**
- The user explicitly asked for the cpnet_bridge harness to ensure
  everything is up to date AND launch both the MP/M server and MAME.
  So the harness IS the orchestrator: rebuild cpnos-rom + NDOS as
  needed, kill any stale MP/M server, start a fresh one, start MAME,
  drive the bridge test.
- Stale-state hygiene: kill any z80pack process holding the MP/M
  port before starting a new one, so a previous wedged session
  doesn't poison the fresh run.
- Up-to-date checks: `make cpnos` is incremental and cheap to call
  always.  NDOS rebuild path: TBD when implementing — find the
  Makefile target / source for whatever MP/M-side NDOS is loaded.
- Document these in the harness README so a stale-build failure has
  a clear self-heal step.

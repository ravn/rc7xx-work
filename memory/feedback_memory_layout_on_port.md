---
name: Audit memory layout PROACTIVELY when porting to a new compiler/linker
description: Hard rule — every linker-script invariant in the source build needs an equivalent in the target build BEFORE the port is declared functional; hardcoded address constants are landmines, not invariants
type: feedback
originSessionId: de6f9865-d9ee-4776-abd2-c579088d6b91
---
HARD RULE — when porting to a new compiler/linker (or replacing build
infrastructure), audit memory layout PROACTIVELY.  Don't wait for boot
hangs to discover overlap bugs.

**Why:** linker abstractions don't translate cleanly.  ld.lld's
MEMORY{} regions + ASSERT()s + NOLOAD sections encode constraints
the linker itself enforces.  z88dk-z80asm's sequential-SECTION model
+ `defc` constants describe a layout but don't ENFORCE the same
constraints — which is fine until someone declares `defc __ivt_start
= 0xF500` and the linker freely places code there because there's
no section reservation backing it up.  Same thing happened with
`_pio_rx_buf_page = 0xF7` (constant disagreed with actual buf
placement) and `_bios_stub_ret` (placed by SDCC outside the resident
range) and `_memset` (z88dk runtime section dropped into BSS-scratch
range).  Each one cost a debug cycle.

**The 2026-05-06/07 cpnos-rom SDCC port surfaced multiple of these in
sequence** because the port treated the existing payload.ld as
*reference for placement* but didn't translate the *invariants* that
payload.ld asserts.  16 ASSERTs in payload.ld → zero equivalents in
the SDCC build; the post-link Python audit covers some but not all.
The IVT-overlap bug was the worst: literally invisible to the audit
because no symbol "is at 0xF500 and shouldn't be" — instead, IVT
0xF500 was supposed to be EMPTY and code was placed there.

**How to apply** — when starting a port to a new toolchain:

1. Enumerate every linker invariant in the source build.  In
   ld.lld-style scripts this is mostly: ASSERT() lines, NOLOAD
   regions, ALIGN() directives, ORG/LENGTH on MEMORY regions, and
   any SYMBOL = ADDRESS assignments.
2. For each invariant, write the equivalent in the target toolchain
   BEFORE wiring the build.  The mechanism may differ (z88dk uses
   `align N` + `defs M` + section-chain ordering; ld.lld uses
   MEMORY{} + ASSERT()), but the constraint must be expressible.
3. Prefer linker-derived symbols over hardcoded literals.  E.g.,
   `_buf_page = HIGH(_buf)` — the linker computes both, drift is
   impossible.  A standalone `defc _buf_page = 0xF7` describes hope,
   not invariant.
4. Build a cross-pipeline audit (mechanical compare of pinned
   symbols between the two builds) so a one-sided edit fails CI.

**Symptoms that the layout audit was skipped:**
- Boot hangs that look like JP-0 cascades, intermittent depending on
  control flow / timing.
- "Silently misroutes" / "stack contains 0x0000 entries".
- Functions that work most of the time but crash on certain inputs
  (the IVT-overlap was like this — banner survived, CCP load didn't).
- Build succeeds, audit passes, but runtime explodes — that's a
  layout-description bug the audit can't see.

**Already-burned-by-this list:**
- 2026-04-25: `cpnos-build/src/cpbios.asm` hand-typed `rb*` EQUs
  silently desync from resident BIOS VMA — see
  `project_cpnos_address_coupling_brittle.md` for the cpnos.com side.
- 2026-05-06: SDCC IVT overlap (`__ivt_start = 0xF500` constant with
  no section reservation; `_cursor_down`/`_cursor_up` placed inside
  the IVT range; setup_ivt destroys their bytes at boot).
- 2026-05-06: SDCC `_pio_rx_buf_page = 0xF7` literal disagrees with
  actual `_pio_rx_buf @ 0xECEE` (latent under TRANSPORT=sio because
  PIO-B doesn't strobe; would crash under TRANSPORT=pio-irq).
- 2026-05-06: `_bios_stub_ret` and `_memset` ending up in z88dk
  runtime sections OUTSIDE the resident range that prom_loader
  copies — caught by hand and by `check_sdcc_layout.py` only after
  multiple debug cycles.

When the user says "we have struggled with this earlier", believe
them; audit BEFORE writing more code on top of an unaudited port.

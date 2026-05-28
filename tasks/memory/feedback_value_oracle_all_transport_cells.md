---
name: Value oracle covers all TRANSPORT cells
description: For shared-source changes that affect any TRANSPORT cell (sio / pio-irq), runtime-verify every affected cell — passing one doesn't mean the others are honest
type: feedback
originSessionId: 8ab450a7-bedb-47ba-bfd3-d7e910ab1992
---
When changing `cpnos-rom` source that's shared across `TRANSPORT=` cells (anything in `snios_c.c`, `xport_*` declarations, `compiler/compat.h`, or shared infrastructure), the value oracle must cover **every** TRANSPORT cell that links the changed code, not just the one currently being tested.

**Why:**  Sessions 58 + 59 landed `PRESERVES_REGS_CLANG("d",...)` on `xport_send_byte` declaration.  Validated via `cpnos-polypascal-test` (PIO+clang) PASS.  But TRANSPORT=sio's `transport_send_byte` definition didn't carry the matching attribute, so under TRANSPORT=sio the body clobbered D but SNIOS callers expected D preserved per the declaration.  The 4-cell test "passed" by coincidence-of-protocol (D=c on the body's `ld d,a` happened to be the byte the caller sent).  Two sessions of honest-looking green ran on a latent correctness gap.

Caught only in session 59b when running `sio-smoke` for the first time since Phase 27 — and even then, only because the harness itself broke on the A>/E> drift and forced a fresh look at the SIO path.

**How to apply:**
- Identify which transport cells the changed file links into.  For shared SNIOS source (`snios_c.c`, `xport_*` decls): both `pio-irq` and `sio` link it.  For transport-specific source (`transport_pio.c`, `transport_sio.c`): only its own cell.
- Before declaring done, run runtime verification for every affected cell.  Current targets:
  - `make COMPILER=clang TRANSPORT=pio-irq cpnos-polypascal-test`
  - `make COMPILER=clang TRANSPORT=sio sio-smoke`
  - `make COMPILER=sdcc TRANSPORT=pio-irq cpnos-polypascal-test`
  - `make COMPILER=sdcc TRANSPORT=sio sio-smoke`
  (Pick the cells the change actually affects; not all 4 needed if change is compiler-specific.)
- "PIO polypascal PASS" alone is NOT sufficient for shared-source changes.  SIO smoke takes ~45 seconds with current harness; the cost is small vs. shipping a latent bug.
- Asm-level inspection (cmp / disassembly diff) is a useful pre-runtime check but cannot substitute for runtime: today's session 59 latent bug had a clean asm diff (just `push de`/`pop de` added) but the runtime impact was correctness, not size.

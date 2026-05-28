---
name: Size over speed for cold paths
description: For code that runs only a few times (cold init, one-shot setup, shutdown handlers, error paths), prioritize code size over execution speed.
type: feedback
originSessionId: d49656b8-663b-4e0e-91a6-0a48af163349
---
For code that runs only a few times (cold-init paths, one-shot setup,
shutdown handlers, error paths, banner prints, relocator), **code size
is more important than execution speed**.

**Why:** these paths execute once or rarely; their wall-clock cost
disappears in measurement noise.  Their byte cost, however, is
permanent — it sits in the resident or PROM image forever, eating
into TPA / PROM headroom that could be used for hot-path code or
new features.

**How to apply:**
- Prefer compact loops over unrolled bodies.
- Prefer table-driven dispatch over inline switches.
- Don't manually inline once-called helpers to "save a call" — the
  3 B CALL + 1 B RET fits anywhere; the inlined body grows with
  every call site.
- Don't cache frequently-recomputed-but-cheap values in BSS to
  "save loads" — the BSS slot + the spill code outweigh repeated
  loads in a once-only path.
- Use smaller built-ins (LDIR/LDDR for blocks > ~3 B) over
  unrolled `*p++ = c` chains.
- For RC700 / cpnos-rom specifically: this applies to init.c (the
  merged cold-init TU), snios_ntwkdn_impl, print_banner,
  relocator.c, the warm-boot/error-cleanup paths in cpnos_main.c
  and resident.c.

**Where speed still matters:** the hot path — impl_conout,
impl_conin, transport_pio_recv_byte, the SNDMSG/RCVMSG state
machines (try_send_frame/try_recv_frame), ISRs.  These run at
character-rate or byte-rate during normal operation.

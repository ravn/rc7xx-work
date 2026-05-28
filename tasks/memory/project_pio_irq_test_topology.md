---
name: pio-irq-fix branch test topology
description: Slave-on-PIO-with-envelope branch needs MAME -piob cpnet_bridge -bitb3 → :4002 directly; cpnet-smoke and harness pio-netboot are wrong topologies for this branch
type: project
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
The `ravn/rc700-gensmedet:pio-mpm-irq-fix` branch puts the slave's
SNDMSG/RCVMSG on PIO byte primitives (`transport_pio_send_byte` /
`transport_pio_recv_byte`) while keeping the SNIOS envelope
(ENQ/ACK/SOH/STX/ETX/EOT).  mpm-net2 speaks the same envelope on its
TCP port, so the slave's PIO byte stream is bit-identical to mpm-net2's
wire stream — no host proxy needed.

**Why:** The "netboot regression" investigation on 2026-04-28 burned an
hour on this.  `make cpnet-smoke` wires only SIO-A → :4002, so the
slave's PIO bytes go nowhere (slave doesn't use SIO-A in this branch).
`tests/cpnet_bridge/harness.py --mode pio-netboot` spawns
`cpnet_pio_server` in self-contained mode, which expects **raw** SCB
frames — protocol mismatch with the irq-fix slave's **envelope** output.
Both targets fail at LOGIN (boot strip `INIT OKPNI...-PS`, no `L`).

**How to apply:** For end-to-end netboot tests on this branch, use
`make pio-irq-netboot` (added in `be1059c`) which wires:

    MAME PIO-B bridge --bitb3-> mpm-net2 :4002

The target also picks up the IRQ-fix MAME tree at `../../mame` (branch
`pio-mpm-irq-fix`) via `MAME_IRQ` instead of the master tree at `$(MAME)`,
because master MAME is missing the `cpnet_bridge::poll_tick` gate fix
(commit `60e2b9a032f`).  Pass criterion: boot strip column 18 = `J`.

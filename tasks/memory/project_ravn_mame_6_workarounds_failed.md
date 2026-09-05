---
name: ravn/mame-rc702-rc759-rc750#6 — workaround paths attempted, all failed
description: Path 2 (Einstein topology) and Path 3 (bypass slot entirely) both fail; underlying bug must be fixed in chip/slot layer
type: project
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
On 2026-04-26 I tried two distinct workarounds for ravn/mame-rc702-rc759-rc750#6 (any
card on PIO-B's slot wrapper breaks cpnos-rom IM2 IRQs).  Both
failed:

**Path 2 — Einstein topology (PIO-A direct, only PIO-B as slot)**:
implemented in commit `54cccdbc3af` on `ravn/mame-rc702-rc759-rc750:cpnet-fast-link`.
Removes the `pioa` slot, wires the keyboard direct via `kbd_put` /
`kbd_r` (matching the original pre-slot RC702 driver and Einstein's
"Port A direct, Port B userport slot" layout).  Result:
`cpnos-netboot` (no `-piob`) PASSes with display showing `A>`.  But
`-piob cpnet_bridge` AND `-piob keyboard` both still black-screen.
So the failure isn't "two slot devices on a single Z80-PIO" — even
ONE card on the lone PIO-B slot wrapper kills IRQs.

**Path 3 — bypass the slot entirely, wire bridge direct**: tried
two variants, both crashed at config time:

- Path 3a (`devcb_write_line m_strobe_handler` with `auto
  out_strobe_handler() { return m_strobe_handler.bind(); }` —
  identical pattern to einstein's `bstb_handler`): crashed with
  `EXC_BAD_ACCESS` in `devcb_write<int,1>::builder_base::
  register_creator()` from `rc702_state::rc702_base()`.  The
  `m_cpnet_bridge->out_strobe_handler().set(m_pio, FUNC(strobe_b))`
  call is what crashes.  Tried finder-form, chained-form, tag-string
  target, and `set_nop()` — all the same crash.

- Path 3b (`std::function<void(int)> m_strobe_handler` with a
  `[this](int s){ m_pio->strobe_b(s); }` lambda): crashed in
  `device_t::config_complete + 428` with PAC-tagged garbage code
  pointer.  Register dump showed `x0` = vtable for the std::function
  wrapper of the lambda; the vtable slot held corrupted memory.

In both 3a and 3b the bridge-side code is structurally fine; the
crashes are in MAME framework dispatch through the bridge's
callbacks.  Adding default in-class initializers
(`m_poll_timer = nullptr`, `m_listen_fd{-1}`, etc.) did **not**
change the SIGBUS — so the failure is not about uninitialized
state.

**How to apply:**
- Don't repeat path 2 or path 3 attempts without new information.
  They are exhausted.
- The fix path is to address the underlying bug directly: either
  refactor `z80pio_device` to introduce per-channel `device_t`
  subdevices (path 1 in the original analysis), or instrument
  `rc702_pio_port_device::device_start` and the chip's daisy chain
  to find why PIO-B-with-card breaks IM2 dispatch while
  PIO-B-empty and PIO-A-with-default-card both work.
- The cpnos-rom side is **not** the problem — `cpnos-netboot`
  proves the guest boots cleanly when no card is plugged into
  PIO-B's slot.  Don't waste time looking at cpnos-rom for this.
- Today's session reverted to the pre-workaround state on the
  MAME side (HEAD of `cpnet-fast-link` at `54cccdbc3af`); the
  uncommitted std::function refactor was discarded.

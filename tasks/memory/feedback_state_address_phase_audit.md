---
name: state-address-phase-audit
description: When a piece of state changes lifecycle (e.g., from PROM-init-only to RAM-resident post-handoff), RE-AUDIT its address against the active memory map of the NEW phase. An address that's safe in phase A is not automatically safe in phase B.
metadata:
  type: feedback
---

A RAM address that was "safe" during one boot phase is not safe in
later phases by default.  Re-audit it against the live memory map of
the phase you're moving the state INTO, not the one it came from.

Worked examples (session 73e/g):
  - rx_frame_buf at 0x2800: safe for prom1-era netboot bring-up (no
    one else used that region), but 0x2800 turned out to be the
    bank2h PROM1-extended mirror -- writes vanished, reads returned
    PROM1 bytes.  [[feedback-rc702-bank2h-mirror]]
  - dot_cursor / dot_row at 0x4000: safe pre-handoff (no TPA program
    running), unsafe post-handoff (PPAS / PRIMES.PAS allocate their
    stack and working memory all over TPA = 0x0100..0xE715, silently
    clobbering dot_row).  Bug manifested as the cursor jumping from
    row 3 to row 23 mid-banner.

**Why:** I missed both cases the same way -- treated the address as
"plain RAM, fine wherever" without checking against the LIVE memory
layout of the phase the state would actually be used in.  prom1.asm
had `dot_* equ 0x4000` from earlier sessions; when I made impl_conout
(post-handoff, in CP/NOS TPA-using world) use the same dot_*, I
inherited the address without re-checking.

**How to apply:** Whenever you reuse a piece of state across a phase
boundary (pre-PROM-disable to post, pre-NDOS-COLDST to post,
pre-program-load to post), do the audit BEFORE writing code:

  1. List every memory region in the destination phase: TPA, CCP,
     NDOS, BDOS, BIOS-resident, display, vectors.
  2. Confirm the address is in a region YOU own end-to-end (BIOS
     resident only on RC702 = 0xED00..0xF7FF), not just "currently
     unused".
  3. If unsure, grep cpnos.com / NDOS / BDOS source for any literal
     reference to the same address range.

The cost is 10 minutes; the alternative is a multi-hour debug session
chasing a "scroll bug" that turns out to be a memory-map violation.
Cross-listed with [[feedback-grep-memmap-before-bss-literal]] and
[[feedback-slave-state-outside-tpa]].

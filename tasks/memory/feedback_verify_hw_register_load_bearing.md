---
name: feedback-verify-hw-register-load-bearing
description: HARD — when changing init-time hardware register writes OR the ISR/code that depends on them, verify the register state is actually load-bearing (i.e. the consumer would behave differently without it).  Vestigial register configuration accumulates silently and masks bugs OR pretends to be carrying behavior it isn't.
metadata:
  type: feedback
---

When you modify code that writes a hardware register at init time, or
modify an ISR that interacts with a hardware register, **verify that
the register state is actually load-bearing** — that the consumer
would behave differently without the configured state.

Common failure mode: a flag bit is set at init "to enable autoinit /
auto-reload / latch-on-strobe", but the consumer (ISR, mainline) does
the same work explicitly anyway.  The flag is INERT — masking what
would otherwise be a bug but also pretending to be carrying behavior
it isn't.  When someone later strips the redundant code, the flag's
real effect surfaces and the change appears to "break" things that
were already broken.

**Why:** 2026-06-14 surfaced this in cpnos-in-c.  DMA channel 2 was
programmed with mode byte `0x5A` (autoinit ON) in `init.c:224-225`,
but the per-VRTC ISR was still re-programming source addr + word
count anyway — the explicit reload always beat the chip's autoinit
to the punch.  The autoinit bit had been sitting inert for weeks.
When the ISR's redundant reload was stripped (Step 0 of #115),
autoinit became load-bearing for the first time, and a careful
display-verification pass was needed to confirm the chip's behavior
matched what the bit was supposed to enable.

Investigation also surfaced that **rcbios** uses mode `0x4A`
non-autoinit (its DSPITR ISR reload IS the refresh mechanism), and
**autoload-in-c** uses `0x4A` after a 2026-03-23 revert of `0x5A`
that had been a workaround for an unrelated ISR-reliability bug.
So three different components had three different intent / consumer
pairings — diverging silently.

**How to apply:** when touching hardware register writes at init or
ISRs that interact with them:
1. Read the datasheet for the bit you're setting; identify the chip-
   level consumer (autoinit triggers on TC; latch fires on strobe;
   IE gates IRQ assertion).
2. Find the software-level consumer of the same effect (the ISR
   reload; the recv loop's IP poll; the chip's IRQ output to the IM2
   vector).
3. Ask: would the software work the same without the chip-level
   bit set?  If yes, the bit is vestigial.  If no, the bit is
   load-bearing.  Vestigial bits should be either documented as
   "intentional belt-and-suspenders" OR removed.
4. When removing redundant software (the cpnos case), verify the
   chip-level path actually works — visual capture, oscilloscope,
   register dump — don't trust that "the bit was set" means "the
   chip is doing it".

Related: [[feedback_display_addr_from_dma]] (display addr is read
from DMA, not hardcoded — same family of "trust the chip state, not
the assumption"); [[project_cpnos_rcbios_code_sharing]] (the cross-
component DMA-mode divergence motivates the shared layer's autoinit
config parametrization).

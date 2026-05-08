---
name: SIO-A: fast TX verified, fast RX impossible
description: SIO-A on real RC702 hardware can transmit at full clock speed (SDLC TX 250 kbaud confirmed sessions 20-21) but cannot receive faster than async 38400; do not propose designs that need fast SIO-A receive
type: project
originSessionId: b07ba379-19bf-4244-a50b-7118b0bab69d
---
On the user's actual RC702 hardware, SIO-A's TX path runs at full clock rate — the bit clock at ÷1 mode = **~614400 baud** ("618000-ish") was bench-confirmed (user re-confirmed 2026-04-25). The framing layer that was used (SDLC vs async ×1 vs monosync) is **NOT** certain — only the bit-rate signaling itself. Earlier session-summary claims of "SDLC specifically verified" should be treated as unverified. The RX path is stuck at async-38400 because the Z80-SIO/2 has no on-chip DPLL and pins 15/17 (TxC/RxC from the cable) are NC on MIC702/MIC703 boards, so external bit-clock recovery is impossible without a PCB modification.

**Why:** This is a hardware-level asymmetry the user has explicitly verified. It is durable across sessions; it will not change without case-opening / soldering, which is excluded by the no-mods rule.

**How to apply:**
- When proposing fast host<->RC702 transport, treat SIO-A as a 250 kbaud TX-only fast channel and a 38400-baud RX channel. Do NOT propose designs that need fast SIO-A receive.
- "SIO-A fast TX + PIO-B (or PIO-A keyboard cable) input" is the natural pairing if both ports are spent on the link. "PIO-B half-duplex" is the natural choice if SIO-A must remain free.
- The bit-clock at ÷1 (614 kbaud) works; the framing register config (async ×1 8N1 vs SDLC vs monosync) is open and should be picked on simplicity grounds, then verified.
- The same is **likely** to apply to SIO-B (same chip family, same NC pins on MIC702/MIC703 — SDLC TX should work, fast RX should not), but only SIO-A has been physically verified. Treat SIO-B as "almost certainly fast TX, definitely no fast RX" until benched.

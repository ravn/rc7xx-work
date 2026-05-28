---
name: Black MAME screen means CRT ISR not firing
description: A black RC702 screen in MAME indicates the CRT refresh ISR is not running, which usually means interrupts are off, the IVT is corrupt, or CTC ch2 isn't programmed
type: feedback
originSessionId: de6f9865-d9ee-4776-abd2-c579088d6b91
---
If the MAME RC702 display is black (not just empty / not just no character), the CRT refresh ISR is not running.

**Why:** the 8275 emulation needs `isr_crt` to fire on each VRTC pulse (CTC ch2 IRQ at ~60 Hz) to update cursor regs and ack the controller. Without that ISR, MAME's CRT model goes black.

**How to apply:**
- Black screen during boot is a strong signal the slave's interrupt path is broken.
- Suspect (in order): EI never executed; IVT slot 2 not pointing at `isr_crt`; CTC ch2 vector / time constant wrong; PROM disable corrupted the IVT.
- Black screen is independent of SIO-B mirror — slave can still produce serial output without a working CRT ISR (and vice versa).
- For polypascal-test: SIO-B output continues even with black screen, so use siob.raw to triage logic and use display state to triage the IRQ chain.

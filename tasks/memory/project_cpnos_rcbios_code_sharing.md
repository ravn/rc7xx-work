---
name: project-cpnos-rcbios-code-sharing
description: Future direction — rcbios and cpnos-in-c carry parallel implementations of overlapping concerns (VRTC ISR, DMA refresh, 8275 cursor, PIO/SIO drivers, frame counter); factor into a shared layer after current INIR/autoinit work settles.
metadata:
  type: project
---

Both rcbios and cpnos-in-c re-implement the same hardware-facing code: VRTC ISR + 8237 DMA channel-2 refresh, 8275 cursor handling, PIO/SIO byte transports, 32-bit frame counter at 0xFFFC. The C source is duplicated, not shared, and small divergences have crept in (cpnos uses DMA mode `0x5A` with autoinit enabled but inert; rcbios uses `0x4A` non-autoinit) without anyone tracking why.

**Why:** Recorded 2026-06-14 after a DMA-mode-byte audit surfaced the unintentional divergence while planning the cpnos INIR refactor (#115). Both components are part of the four-firmware-finishing slate ([[project_finishing_firmware_components]]), so they're going to be touched together for years. Maintaining two copies of the same ISR is a known source of "fix landed in one place, the other regressed" bugs.

**How to apply:**
- Don't do this *during* the INIR work — too many moving parts; revisit after autoinit + DI-bracket lands in cpnos and is verified.
- When the time comes, the natural shared modules are: `isr_crt` (VRTC + cursor + frame counter), `transport_pio.c` + `transport_sio.c` (byte-level drivers), the PIO/SIO/CTC init sequences, and the 8275/DMA programming helpers.
- The user is aware of and has explicitly accepted that this is a future cleanup, not blocking work.
- Tracked as TaskList #22.

Related: [[project_finishing_firmware_components]], [[feedback_rcbios_jump_table_is_abi]] (any shared layer must respect rcbios's ABI).

---
name: Verify RC702 keyboard via MAME natural_keyboard
description: Use MAME Lua natkeyboard:post(text) to inject keystrokes via the RC702's PIO-A path — end-to-end test of ISR + kbd_ring + impl_conin + CCP
type: reference
originSessionId: b07ba379-19bf-4244-a50b-7118b0bab69d
---
To verify the keyboard input path works in cpnos-rom (or rcbios-in-c) under MAME:

**Method: MAME natural_keyboard paste.**  The rc702 driver wires the host keyboard (and natural_keyboard inject) to PIO-A.  A post triggers the same IRQ chain a real keypress does, so it exercises:

  PIO-A strobe -> IM2 IRQ -> IVT slot 16 -> isr_pio_kbd -> kbd_ring
  CCP CONIN -> BDOS -> BIOS CONIN -> impl_conin -> kbd_ring read

```lua
-- in an autoboot_script:
emu.register_frame_done(function()
    -- wait for A> prompt (tune timing), then:
    manager.machine.natkeyboard:post("dir\r")
end)
```

Combine with a later `screen:snapshot(path)` to capture the result.

Also valid for "simulate a byte on the parallel port" (user's phrasing): the natural_keyboard route is the standard integration path.  If truly-raw PIO injection is needed (bypassing the driver's keyboard model), MAME Lua can manipulate `manager.machine.devices[":pio"].memory:write_u8(...)` but that's rarely necessary — the rc702 driver already translates keypress → PIO byte correctly.

**Why this matters:** on the cpnos-rom side, a missing keyboard path is invisible from boot screenshots (A> looks fine without input).  The paste test is the simplest "did the ISR-to-CCP-input-chain survive my memory-map change?" smoke test.

**Example session 33 follow-up (2026-04-22):** moving BIOS_BASE 0xF200 -> 0xED00 inadvertently put the IVT slot at 0xF120 inside .resident code, which then got overwritten by the section memcpy.  Keyboard paste test caught this as DIR output not appearing.  Fix: move IVT to 0xEC00, run memcpy first, re-test with paste.  See `cpnos-rom/init.c` IVT_ADDR and `cpnos-rom/cpnos_main.c` for the ordering.

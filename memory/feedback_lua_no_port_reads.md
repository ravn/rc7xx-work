---
name: Lua must not read IO ports
description: In MAME Lua scripts, never call space:read_u8/read_u16 on IO space — it causes double reads that break emulated hardware
type: feedback
originSessionId: 5b9c19fb-ae78-45c7-b86e-c8b8135e5b92
---
Do NOT call `spaces["io"]:read_u8(port)` (or any IO-space read) from MAME Lua. MAME will perform the physical read again, which has side effects on real hardware devices (e.g. a Z80 SIO's pointer auto-decrements, the RX FIFO pops, etc.). This desynchronizes the emulator from the running program and "breaks" execution — symptoms can be subtle (a dropped byte) or catastrophic (hang).

**Why:** Explicit user instruction — "lua code may not read from ports as that causes double reads breaking".

**How to apply:**
- For runtime observation of CPU↔device port traffic, use `space:install_read_tap(start, end, name, fn)` and `space:install_write_tap(...)` — taps observe the access after the device handles it; they do not trigger a second access. The callback can return nil to leave the value unchanged.
- For device-internal state (Z80SIO `m_rr0`, `m_wr1`, …), the sober answer is: you cannot read it from Lua unless the device implements `device_state_interface` and calls `state_add(...)`. If you need it, read it from logs produced by instrumentation already compiled into the MAME binary, or get the instrumentation added.
- Memory-space reads (`spaces["program"]:read_u8`) are fine; RAM is plain memory with no side effects.

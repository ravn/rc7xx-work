---
name: Lua must retain memory-tap handles
description: In MAME Lua, store the handle returned by install_write_tap/install_read_tap in a long-lived table, or Lua GC frees it and the next tapped access segfaults in lua_topointer
type: feedback
originSessionId: 5ddc4a72-b658-47ba-a04a-6be5b53cdfcb
---
`space:install_write_tap(start, end, name, fn)` and `install_read_tap(...)` return
a `memory_passthrough_handler` userdata. **You MUST keep that return value alive**
for as long as the tap should fire — assign it into a module-scope table
(`taps[#taps+1] = io:install_write_tap(...)`). If you discard it, the Lua garbage
collector frees the handler while MAME still has the tap registered on the address
space. The **next bus access to the tapped address** then invokes a dangling
callback and the process dies with a native **EXC_BAD_ACCESS (code=1) in
`lua_topointer`** — a hard segfault, NOT a catchable `[LUA ERROR]`.

**Why this is sneaky / how it was found (session 5ddc, cross-version boot matrix):**
The same `mame_boot_test.lua` that installs unretained 0xFC/0xF4 DMA taps booted
fine with the *clang* autoload PROM but segfaulted with the *original* roa375 PROM.
Cause was timing, not the PROM: the clang PROM wrote the tapped ports within the
first frame (before any GC), so the live closure was still valid; the original PROM
wrote them several frames later, after a GC cycle had reclaimed the unreferenced
handle. Bisect proof: no-lua and empty-lua booted (exit 0); a taps-only lua
segfaulted; the identical taps-only lua that stashed the handle in a table booted
(exit 0). Stack unwound only to frame #0 (`lua_topointer`) — corrupted unwind, the
fingerprint of a freed-userdata deref.

**How to apply:**
- Always: `local taps = {}` at module scope, then `taps[#taps+1] = io:install_*_tap(...)`.
- This is a general MAME-Lua rule for ANY object whose lifetime MAME ties to a
  callback you registered (taps, and similar passthrough/notifier handles).
- Diagnose a suspected instance of this class by running MAME under `lldb -batch
  -o run -o bt` — a crash in `lua_topointer`/sol2 with a tiny bad address and a
  one-frame backtrace is the GC'd-userdata signature.
- Sibling rule: feedback_lua_no_port_reads.md (use taps, never IO reads).

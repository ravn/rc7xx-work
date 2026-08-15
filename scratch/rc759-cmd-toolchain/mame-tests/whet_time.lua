-- whet_time.lua -- measure Whetstone execution time on MAME rc759 FROM OUTSIDE.
--
-- The guest (test/whetstone.c built -DMAME_DONE) brackets the whole benchmark
-- with two bus cycles on the undecoded I/O port 0x2FE (see mamedone.h):
--   START = word 0xB000  (emitted right after seam init, before module 1)
--   END   = word 0xE000  (emitted after the last module, output flushed)
-- Port 0x2FE has no hardware effect on the rc759, but an io-space write-tap
-- still sees the cycle. We read MAME's emulated clock (emu.time(), in seconds)
-- at each edge; the delta is the execution time as the REAL rc759 (80186 @ its
-- emulated clock) would take -- never self-timed inside Whetstone.
--
-- Prints "WHET-TIME start=.. end=.. elapsed=.. s" and stops the emulator on END.
-- The -seconds_to_run cap is only a safety net (no END => guest hung).

local seen  = 0
local t0    = 0.0
local t1    = 0.0
local fire  = false

-- Keep the tap in a global: a GC'd tap stops firing.
WHET_TAP = manager.machine.devices[":maincpu"].spaces["io"]:install_write_tap(
    0x2FE, 0x2FF, "whet_time",
    function(offset, data, mask)
        seen = seen + 1
        if seen == 1 then
            t0 = emu.time()
            print(string.format("WHET-START word=0x%04X t=%.6f s", data, t0))
        elseif seen == 2 then
            t1 = emu.time()
            fire = true
        end
    end)

emu.register_frame_done(function()
    if fire then
        fire = false
        manager.machine.video:snapshot()
        print(string.format(
            "WHET-TIME start=%.6f end=%.6f elapsed=%.6f s",
            t0, t1, t1 - t0))
        manager.machine:exit()
    end
end)

-- mame_time.lua -- time a benchmark's REPS loop on the REAL MAME rc759 driver
-- FROM OUTSIDE, via the two OUT 0x2FE bracket markers (see mame_bracket.h).
--
--   START = word 0xB000  (emitted just before the REPS loop)
--   END   = word 0xE000  (emitted just after the REPS loop)
--
-- Port 0x2FE is undecoded by the rc759 driver, so the writes have no hardware
-- effect, but an io-space write-tap still sees each bus cycle. We read MAME's
-- emulated clock (emu.time(), seconds) at each edge; the delta is the loop's
-- execution time as the real rc759 (80186 at its emulated clock) would take.
-- Boot and crt0/printf overhead are OUTSIDE the bracket, so excluded.
--
-- Prints  MAME-TIME start=.. end=.. elapsed=.. s  and stops the emulator on END.
-- The -seconds_to_run cap is only a safety net (no END => the guest hung).

local seen = 0
local t0   = 0.0
local t1   = 0.0
local fire = false

-- Keep the tap in a global: a GC'd tap stops firing.
MAME_TIME_TAP = manager.machine.devices[":maincpu"].spaces["io"]:install_write_tap(
    0x2FE, 0x2FF, "mame_time",
    function(offset, data, mask)
        seen = seen + 1
        if seen == 1 then
            t0 = emu.time()
            print(string.format("MAME-START word=0x%04X t=%.6f s", data, t0))
        elseif seen == 2 then
            t1 = emu.time()
            fire = true
        end
    end)

emu.register_frame_done(function()
    if fire then
        fire = false
        print(string.format(
            "MAME-TIME start=%.6f end=%.6f elapsed=%.6f s",
            t0, t1, t1 - t0))
        manager.machine:exit()
    end
end)

-- scb_mame.lua -- run stdcbench (SCB.CMD) in MAME rc759 and stop on completion.
--
-- Hybrid of done_signal.lua and the old periodic-snapshot lua: stdcbench built
-- with -DMAME_DONE ends with OUT 0x2FE,AX (final score). We tap that undecoded
-- io port and, on the first write, snapshot + print the score + exit. As a
-- DIAGNOSTIC fallback (the first time we don't yet know the disk's XIOS Int 28h
-- clock drives stdcbench correctly, vs spins forever) we ALSO snapshot every 500
-- frames from frame 12000 -- so if it hangs we still capture what's on screen.

local cpu = manager.machine.devices[":maincpu"]
local io  = cpu.spaces["io"]

local done      = false
local done_word = 0
local frames    = 0

DONE_TAP = io:install_write_tap(0x2FE, 0x2FF, "scb_done", function(offset, data, mask)
    done_word = data
    done = true
end)

emu.register_frame_done(function()
    frames = frames + 1
    if done then
        done = false
        manager.machine.video:snapshot()
        print(string.format("DONE-SIGNAL word=0x%04X score=%d frame=%d",
            done_word, done_word, frames))
        manager.machine:exit()
    elseif frames >= 12000 and frames % 500 == 0 then
        manager.machine.video:snapshot()  -- diagnostic breadcrumb
    end
end)

-- boot_save.lua -- boot rc759 to the CCP/M-86 A> prompt, then write a MAME
-- save state so later oracle runs can SKIP the slow boot. Boots for a fixed
-- emulated time (MAME_SAVE_AT, default 80s -- safely past A>, which mtest
-- reached well before its ~64s done-signal), snapshots the screen for visual
-- confirmation, schedules the save, lets it flush, then exits.
local save_at = tonumber(os.getenv("MAME_SAVE_AT") or "80") or 80
local name    = os.getenv("MAME_STATE_NAME") or "booted"
local phase   = 0
local tmark   = 0

emu.register_frame_done(function()
    local t = manager.machine.time:as_double()
    if phase == 0 and t >= save_at then
        manager.machine.video:snapshot()           -- pre-save screen (should show A>)
        manager.machine:save(name)                 -- scheduled for next frame
        print(string.format("BOOT-SAVE: scheduled save '%s' at %.2f emulated s", name, t))
        phase, tmark = 1, t
    elseif phase == 1 and t >= tmark + 2 then       -- let the save flush
        print("BOOT-SAVE: done, exiting")
        manager.machine:exit()
    end
end)

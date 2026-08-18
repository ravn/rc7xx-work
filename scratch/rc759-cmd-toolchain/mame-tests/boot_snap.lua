-- boot_snap.lua -- generic boot verifier: snapshot the screen once the guest
-- has had SNAP_AT emulated seconds to boot, then exit. Used to confirm a
-- machine reaches its OS prompt (e.g. CP/M-86 "A>") without any guest
-- cooperation. Set SNAP_AT via the environment variable MAME_SNAP_AT
-- (emulated seconds); defaults to 12.
local snap_at = tonumber(os.getenv("MAME_SNAP_AT") or "12") or 12
local done = false

emu.register_frame_done(function()
    if done then return end
    if manager.machine.time:as_double() >= snap_at then
        done = true
        manager.machine.video:snapshot()
        print(string.format("BOOT-SNAP: taken at %.2f emulated seconds", snap_at))
        manager.machine:exit()
    end
end)

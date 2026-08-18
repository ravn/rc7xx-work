-- load_verify.lua -- confirm a MAME save state restores rc759 straight to the
-- CCP/M-86 A> prompt (skipping the boot). Started with -state <name>; waits a
-- couple emulated seconds for the machine to settle, snapshots the screen, and
-- exits. View the PNG in mame/snap/rc759/ to confirm "A>" is present.
local settle = tonumber(os.getenv("MAME_SETTLE") or "3") or 3
local done = false
emu.register_frame_done(function()
    if done then return end
    if manager.machine.time:as_double() >= settle then
        done = true
        manager.machine.video:snapshot()
        print(string.format("LOAD-VERIFY: snapshot at %.2f emulated s", manager.machine.time:as_double()))
        manager.machine:exit()
    end
end)

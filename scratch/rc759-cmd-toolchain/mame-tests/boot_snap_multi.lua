-- boot_snap_multi.lua -- take snapshots at several emulated-time checkpoints so
-- we can watch a slow boot progress (BIOS POST -> floppy boot -> OS prompt).
-- Snapshots land in snap/<machine>/0000.png, 0001.png, ... in trigger order.
-- Exits after the last checkpoint. Times (emulated seconds) are fixed below.
local checkpoints = {3, 6, 10, 15, 22, 30, 40}
local idx = 1

emu.register_frame_done(function()
    if idx > #checkpoints then return end
    local t = manager.machine.time:as_double()
    if t >= checkpoints[idx] then
        manager.machine.video:snapshot()
        print(string.format("BOOT-SNAP %d: %.1f s", idx - 1, checkpoints[idx]))
        idx = idx + 1
        if idx > #checkpoints then
            manager.machine:exit()
        end
    end
end)

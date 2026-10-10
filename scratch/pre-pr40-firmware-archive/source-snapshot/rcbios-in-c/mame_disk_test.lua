-- MAME autoboot script for BIOS-in-C boot/disk test.
-- Waits for a marker string in screen buffer, dumps screen, exits.
-- Marker: "A>" (CP/M prompt) or "DISK=" (disk test) or timeout.

local frame = 0
local max_frames = 50 * 120   -- 2 minutes
local done = false

-- Search for a string in screen memory
local function screen_find(space, str)
    local bytes = {string.byte(str, 1, #str)}
    for addr = 0xF800, 0xF800 + 2000 - #str do
        local match = true
        for i = 1, #bytes do
            if space:read_u8(addr + i - 1) ~= bytes[i] then
                match = false
                break
            end
        end
        if match then return true end
    end
    return false
end

emu.register_frame_done(function()
    if done then return end
    frame = frame + 1

    if frame % 50 == 0 or frame >= max_frames then
        local space = manager.machine.devices[":maincpu"].spaces["program"]

        if screen_find(space, "A>") or screen_find(space, "DISK=")
           or screen_find(space, "error") or frame >= max_frames then
            local f = io.open("/tmp/screen.txt", "w")
            for row = 0, 24 do
                local line = ""
                for col = 0, 79 do
                    local ch = space:read_u8(0xF800 + row * 80 + col)
                    if ch >= 0x20 and ch < 0x7F then
                        line = line .. string.char(ch)
                    else
                        line = line .. string.format("\\x%02X", ch)
                    end
                end
                f:write(line .. "\n")
            end
            f:close()
            done = true
            -- Use manager.machine:exit(); os.exit() does not terminate
            -- the host MAME process, leaving it running.  See
            -- feedback_bench_must_self_terminate memory rule.
            manager.machine:exit()
        end
    end
end)

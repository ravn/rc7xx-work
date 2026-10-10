-- MAME autoboot script: wait for CP/M prompt or timeout, dump screen, exit.
local frame = 0
local max_frames = 50 * 15   -- 15 seconds at 50fps
local done = false

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

        if screen_find(space, "A>") or frame >= max_frames then
            local f = io.open("/tmp/mame_screen.txt", "w")
            for row = 0, 24 do
                local line = ""
                for col = 0, 79 do
                    local ch = space:read_u8(0xF800 + row * 80 + col)
                    if ch >= 0x20 and ch < 0x7F then
                        line = line .. string.char(ch)
                    else
                        line = line .. " "
                    end
                end
                f:write(line .. "\n")
            end
            f:close()
            if screen_find(space, "A>") then
                f = io.open("/tmp/mame_result.txt", "w")
                f:write("BOOT_OK\n")
                f:close()
            else
                f = io.open("/tmp/mame_result.txt", "w")
                f:write("TIMEOUT\n")
                f:close()
            end
            done = true
            os.exit(0)
        end
    end
end)

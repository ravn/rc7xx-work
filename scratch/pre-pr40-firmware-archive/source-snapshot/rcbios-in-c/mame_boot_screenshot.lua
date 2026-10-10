-- Boot, wait for A> prompt, take screenshot + dump text, exit.
-- Output: /tmp/mame_boot_screen.txt + MAME snap dir PNG.

local frame = 0
local done = false
local settle_frames = 0

local function screen_text()
    local space = manager.machine.devices[":maincpu"].spaces["program"]
    local lines = {}
    for row = 0, 24 do
        local line = ""
        for col = 0, 79 do
            local ch = space:read_u8(0xF800 + row * 80 + col)
            line = line .. (ch >= 0x20 and ch < 0x7F and string.char(ch) or " ")
        end
        lines[#lines + 1] = line:gsub("%s+$", "")
    end
    return table.concat(lines, "\n")
end

local function at_prompt()
    local space = manager.machine.devices[":maincpu"].spaces["program"]
    local curx = space:read_u8(0xFFD1)
    local cursy = space:read_u8(0xFFD4)
    if curx ~= 2 then return false end
    local r = 0xF800 + cursy * 80
    return space:read_u8(r) == 0x41 and space:read_u8(r + 1) == 0x3E
end

emu.register_frame_done(function()
    if done then return end
    frame = frame + 1

    if at_prompt() then
        -- Wait a few frames so cursor and screen are stable
        settle_frames = settle_frames + 1
        if settle_frames < 10 then return end

        -- Text dump
        local txt = screen_text()
        local f = io.open("/tmp/mame_boot_screen.txt", "w")
        f:write(txt .. "\n")
        f:close()
        print("=== Boot screen text ===")
        print(txt)

        -- Snapshot (PNG in MAME's snap directory)
        manager.machine.video:snapshot()
        print("=== Snapshot taken ===")

        done = true
        manager.machine:exit()
    end

    if frame > 50 * 30 then
        print("TIMEOUT after 30s")
        print(screen_text())
        done = true
        manager.machine:exit()
    end
end)

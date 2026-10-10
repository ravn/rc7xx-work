-- Variant of mame_boot_screenshot.lua that enables DIP switch S01
-- (port 0x14 bit 0) before boot, so the BIOS activates SIO-B debug mode.

local frame = 0
local done = false
local settle_frames = 0
local dip_set = false

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

    -- Set DSW bit 0 (S01) on the first frame, before PROM reads it
    if not dip_set then
        local port = manager.machine.ioport.ports[":DSW"]
        if port then
            for _, field in pairs(port.fields) do
                if field.mask == 0x01 then
                    field.user_value = 0x01
                    print("[lua] Set DSW S01 = 0x01 (SIO-B debug enable)")
                end
            end
            dip_set = true
        end
    end

    if at_prompt() then
        settle_frames = settle_frames + 1
        if settle_frames < 10 then return end

        local txt = screen_text()
        local f = io.open("/tmp/mame_boot_screen.txt", "w")
        f:write(txt .. "\n")
        f:close()
        print("=== Boot screen text ===")
        print(txt)

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

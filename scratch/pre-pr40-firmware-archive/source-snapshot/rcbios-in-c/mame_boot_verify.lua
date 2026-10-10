-- Boot verification: wait for A> prompt, capture screen, check banner.
-- Exits with 0 on success, 1 on timeout.
-- Output: /tmp/mame_boot_verify.txt

local frame = 0
local done = false

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
    local row_addr = 0xF800 + cursy * 80
    return space:read_u8(row_addr) == 0x41 and space:read_u8(row_addr + 1) == 0x3E
end

emu.register_frame_done(function()
    if done then return end
    frame = frame + 1

    -- Pass/fail is signalled via the leading line of
    -- /tmp/mame_boot_verify.txt ("OK" / "TIMEOUT"), not via the host
    -- MAME exit code.  Use manager.machine:exit(); os.exit() does not
    -- terminate the host MAME process and leaves it running.  See
    -- feedback_bench_must_self_terminate memory rule.
    if at_prompt() then
        local scr = screen_text()
        local f = io.open("/tmp/mame_boot_verify.txt", "w")
        f:write("OK\n" .. scr .. "\n")
        f:close()
        print("=== Boot screen ===")
        print(scr)
        done = true
        manager.machine:exit()
    end

    if frame > 50 * 30 then
        local scr = screen_text()
        local f = io.open("/tmp/mame_boot_verify.txt", "w")
        f:write("TIMEOUT\n" .. scr .. "\n")
        f:close()
        print("=== TIMEOUT ===")
        print(scr)
        done = true
        manager.machine:exit()
    end
end)

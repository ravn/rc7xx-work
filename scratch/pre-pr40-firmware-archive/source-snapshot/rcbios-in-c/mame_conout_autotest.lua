-- mame_conout_autotest.lua — Run CONOTEST.COM and check for PASS/FAIL
--
-- Boot CP/M, type "CONOTEST", wait for PASS or FAIL on screen.
-- Writes result to /tmp/conout_result.txt and exits.

local frame = 0
local done = false
local stage = 0
local key_queue = ""
local key_pos = 0
local key_delay = 0

local KBBUF  = KBBUF_ADDR   -- patched by Makefile sed
local KBHEAD = KBHEAD_ADDR

local function screen_text(space)
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

local function screen_find(space, str)
    local bytes = {string.byte(str, 1, #str)}
    for addr = 0xF800, 0xF800 + 2000 - #str do
        local match = true
        for i = 1, #bytes do
            if space:read_u8(addr + i - 1) ~= bytes[i] then match = false; break end
        end
        if match then return true end
    end
    return false
end

local function inject_key(space, ch)
    local head = space:read_u8(KBHEAD)
    space:write_u8(KBBUF + head, ch)
    space:write_u8(KBHEAD, (head + 1) % 16)
end

local function inject_string(str)
    key_queue = str
    key_pos = 1
    key_delay = 0
end

emu.register_frame_done(function()
    if done then return end
    frame = frame + 1
    local space = manager.machine.devices[":maincpu"].spaces["program"]

    -- Inject queued keystrokes
    if key_pos > 0 and key_pos <= #key_queue then
        if key_delay > 0 then key_delay = key_delay - 1; return end
        inject_key(space, string.byte(key_queue, key_pos))
        key_pos = key_pos + 1
        key_delay = 3
        return
    end

    -- Stage 0: wait for A> prompt
    if stage == 0 then
        if screen_find(space, "A>") then
            stage = 1
        elseif frame > 50 * 60 then
            local f = io.open("/tmp/conout_result.txt", "w")
            f:write("TIMEOUT waiting for boot\n\n" .. screen_text(space) .. "\n")
            f:close()
            done = true
            os.exit(1)
        end
        return
    end

    -- Stage 1: type CONOTEST command
    if stage == 1 then
        inject_string("CONOTEST\r")
        stage = 2
        return
    end

    -- Stage 2: wait for PASS or FAIL
    if stage == 2 then
        if screen_find(space, "PASS") then
            local f = io.open("/tmp/conout_result.txt", "w")
            f:write("PASS\n\n" .. screen_text(space) .. "\n")
            f:close()
            done = true
            os.exit(0)
        elseif screen_find(space, "FAIL") then
            local f = io.open("/tmp/conout_result.txt", "w")
            f:write("FAIL\n\n" .. screen_text(space) .. "\n")
            f:close()
            done = true
            os.exit(1)
        elseif frame > 50 * 120 then
            local f = io.open("/tmp/conout_result.txt", "w")
            f:write("TIMEOUT waiting for test result\n\n" .. screen_text(space) .. "\n")
            f:close()
            done = true
            os.exit(1)
        end
        return
    end
end)

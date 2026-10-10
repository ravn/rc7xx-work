-- MAME Lua autotest for CONOUT_TEST.COM
-- Runs the test program, presses keys at each "Press key" prompt,
-- dumps screen contents to /tmp/conout_screens.txt at each stage.

local frame = 0
local done = false
local stage = 0
local wait_boot = true
local wait_prompt = false
local cmd_sent = false
local key_queue = ""
local key_pos = 0
local key_delay = 0
local stage_timer = 0
local screens = {}

local KBBUF  = 0xDC23
local KBHEAD = 0xDC33

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

local stage_names = {
    "boot",
    "run_cmd",
    "scroll_test",
    "insert_test",
    "delete_test",
    "insert_bottom",
    "delete_bottom",
    "scroll_rapid",
    "erase_test",
    "done"
}

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

    if stage_timer > 0 then stage_timer = stage_timer - 1; return end

    -- Stage 0: wait for A> prompt
    if stage == 0 then
        if screen_find(space, "A>") then
            stage = 1
            stage_timer = 30
        elseif frame > 50 * 60 then
            screens[#screens + 1] = "TIMEOUT waiting for A>\n\n" .. screen_text(space)
            done = true
        end
        return
    end

    -- Stage 1: type command
    if stage == 1 then
        inject_string("CONOTEST\r")
        stage = 2
        stage_timer = 100
        return
    end

    -- Stages 2-7: wait for "Press key" and capture screen, then send key
    if stage >= 2 and stage <= 7 then
        if screen_find(space, "Press key") then
            screens[#screens + 1] = "=== " .. (stage_names[stage + 1] or ("stage" .. stage)) .. " ===\n" .. screen_text(space)
            stage_timer = 20
            stage = stage + 1
            inject_key(space, 0x20)  -- space = press key
            return
        end
        if frame > 50 * (60 + stage * 30) then
            screens[#screens + 1] = "TIMEOUT at stage " .. stage .. "\n\n" .. screen_text(space)
            done = true
        end
        return
    end

    -- Stage 8: final "ALL CONOUT TESTS PASSED" + A> prompt
    if stage == 8 then
        if screen_find(space, "ALL CONOUT TESTS PASSED") then
            screens[#screens + 1] = "=== final ===\n" .. screen_text(space)
            stage = 9
            stage_timer = 100
            return
        end
        if screen_find(space, "Press key") then
            -- Extra stage we missed
            screens[#screens + 1] = "=== extra stage ===\n" .. screen_text(space)
            inject_key(space, 0x20)
            stage_timer = 50
            return
        end
        if frame > 50 * 300 then
            screens[#screens + 1] = "TIMEOUT at final\n\n" .. screen_text(space)
            done = true
        end
        return
    end

    -- Stage 9: done
    if stage == 9 then
        local f = io.open("/tmp/conout_screens.txt", "w")
        for _, s in ipairs(screens) do
            f:write(s .. "\n\n")
        end
        f:close()
        print("Screen dumps saved to /tmp/conout_screens.txt (" .. #screens .. " stages)")
        done = true
        os.exit(0)
    end
end)

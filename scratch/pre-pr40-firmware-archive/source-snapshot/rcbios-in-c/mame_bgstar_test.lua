-- MAME Lua autotest for BGSTAR foreground/background

local frame = 0
local done = false
local stage = 0
local key_queue = ""
local key_pos = 0
local key_delay = 0
local stage_timer = 0
local screens = {}
local pass = true

local KBBUF  = KBBUF_ADDR
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
        local ok = true
        for i = 1, #bytes do
            if space:read_u8(addr + i - 1) ~= bytes[i] then ok = false; break end
        end
        if ok then return true end
    end
    return false
end

local function inject_key(space, ch)
    local head = space:read_u8(KBHEAD)
    space:write_u8(KBBUF + head, ch)
    space:write_u8(KBHEAD, (head + 1) % 16)
end

local function inject_string(str) key_queue = str; key_pos = 1; key_delay = 0 end

local function at_prompt(space)
    local curx  = space:read_u8(0xFFD1)
    local cursy = space:read_u8(0xFFD4)
    if curx ~= 2 then return false end
    local row_addr = 0xF800 + cursy * 80
    return space:read_u8(row_addr) == 0x41 and space:read_u8(row_addr + 1) == 0x3E
end

local function log(msg) screens[#screens + 1] = msg; print(msg) end

local function check(space, row, col, expected, desc)
    local ok = true
    for i = 1, #expected do
        if space:read_u8(0xF800 + row * 80 + col + i - 1) ~= string.byte(expected, i) then ok = false; break end
    end
    if ok then log("  PASS: " .. desc)
    else
        local got = ""
        for i = 1, #expected do
            local ch = space:read_u8(0xF800 + row * 80 + col + i - 1)
            got = got .. (ch >= 0x20 and ch < 0x7F and string.char(ch) or "?")
        end
        log("  FAIL: " .. desc .. " ('" .. expected .. "' vs '" .. got .. "')")
        pass = false
    end
end

-- Dump BGSTAR bytes for diagnostics
local function dump_bgstar(space, label)
    local s = label .. " BGSTAR: "
    for i = 0, 31 do s = s .. string.format("%02X ", space:read_u8(0xF500 + i)) end
    log(s)
end

local function save_and_exit()
    local f = io.open("/tmp/bgstar_screens.txt", "w")
    for _, s in ipairs(screens) do f:write(s .. "\n") end
    f:close()
    done = true
    os.exit(0)
end

emu.register_frame_done(function()
    if done then return end
    frame = frame + 1
    local space = manager.machine.devices[":maincpu"].spaces["program"]

    if key_pos > 0 and key_pos <= #key_queue then
        if key_delay > 0 then key_delay = key_delay - 1; return end
        inject_key(space, string.byte(key_queue, key_pos))
        key_pos = key_pos + 1
        key_delay = 10
        return
    end
    if stage_timer > 0 then stage_timer = stage_timer - 1; return end

    if stage == 0 then
        if at_prompt(space) then
            log("Boot OK")
            inject_string("BGTEST\r")
            stage = 1; stage_timer = 200
        elseif frame > 3000 then log("TIMEOUT boot"); save_and_exit() end
        return
    end

    -- TEST 1: BG cat drawing + clear FG (no insert/delete)
    if stage == 1 then
        if screen_find(space, "TEST1 OK") then
            log("\n=== TEST 1: BG draw + clear FG ===")
            log(screen_text(space))
            dump_bgstar(space, "T1")
            -- Cat drawn as BG at rows 2-6 col 35. FG text at row 4 col 35.
            -- Clear FG erases non-BG positions. Cat should remain.
            -- But FG text at row 4 was NOT BG, so it gets erased → cat row restored?
            -- No: clear_foreground doesn't restore, it just erases non-BG.
            -- The cat chars at row 4 were overwritten by FG "XXXXXXX".
            -- After clear_foreground: row 4 still shows "XXXXXXX" (BG-marked positions).
            check(space, 2, 35, " /\\_/\\", "Cat row 2")
            check(space, 3, 35, "( o.o )", "Cat row 3")
            -- Row 4: was cat " > ^ < " in BG, then "XXXXXXX" in FG.
            -- BG bits for row 4 col 35-41 were set by cat drawing.
            -- FG "XXXXXXX" wrote over same positions. Clear FG preserves them.
            check(space, 4, 35, "XXXXXXX", "Row 4: FG text preserved (BG-marked)")
            check(space, 5, 35, "/|   |\\", "Cat row 5")
            check(space, 6, 35, "(|   |)", "Cat row 6")
            inject_key(space, 0x20)
            stage = 2; stage_timer = 200
        elseif frame > 8000 then log("TIMEOUT T1\n" .. screen_text(space)); save_and_exit() end
        return
    end

    -- TEST 2: BG cat + insert line + clear FG
    if stage == 2 then
        if screen_find(space, "TEST2 OK") then
            log("\n=== TEST 2: BG + insert line ===")
            log(screen_text(space))
            dump_bgstar(space, "T2")
            -- Cat at rows 2-6. Insert at row 3: rows 3+ shift down.
            -- Cat row 2 stays. Cat rows 3-6 → rows 4-7. Row 3 is blank.
            -- After clear FG: BG positions preserved.
            check(space, 2, 35, " /\\_/\\", "Cat row 2 (unshifted)")
            -- Row 3 should be blank (inserted)
            check(space, 3, 35, "       ", "Row 3 blank (inserted)")
            check(space, 4, 35, "( o.o )", "Cat row 3→4 (shifted)")
            check(space, 5, 35, " > ^ <", "Cat row 4→5 (shifted)")
            inject_key(space, 0x20)
            stage = 3; stage_timer = 200
        elseif frame > 13000 then log("TIMEOUT T2\n" .. screen_text(space)); save_and_exit() end
        return
    end

    -- TEST 3: BG cat + delete line + clear FG
    if stage == 3 then
        if screen_find(space, "TEST3 OK") then
            log("\n=== TEST 3: BG + delete line ===")
            log(screen_text(space))
            dump_bgstar(space, "T3")
            -- Cat at rows 2-6. Delete at row 3: rows 4+ shift up.
            -- Cat row 2 stays. Cat row 3 deleted. Cat rows 4-6 → rows 3-5.
            check(space, 2, 35, " /\\_/\\", "Cat row 2 (unshifted)")
            check(space, 3, 35, " > ^ <", "Cat row 4→3 (shifted up)")
            check(space, 4, 35, "/|   |\\", "Cat row 5→4 (shifted up)")
            check(space, 5, 35, "(|   |)", "Cat row 6→5 (shifted up)")
            inject_key(space, 0x20)
            stage = 4; stage_timer = 200
        elseif frame > 18000 then log("TIMEOUT T3\n" .. screen_text(space)); save_and_exit() end
        return
    end

    -- Final
    if stage == 4 then
        if screen_find(space, "ALL BGSTAR TESTS PASSED") then
            log("\n=== DONE ===")
            if pass then log("*** ALL BGSTAR TESTS PASSED ***")
            else log("*** SOME TESTS FAILED ***") end
            save_and_exit()
        elseif frame > 23000 then log("TIMEOUT final\n" .. screen_text(space)); save_and_exit() end
    end
end)

-- Trace bgflg and bgstar[0] changes to diagnose bg_set_bit not writing

local frame = 0
local done = false
local stage = 0
local key_queue = ""
local key_pos = 0
local key_delay = 0
local stage_timer = 0

local KBBUF  = KBBUF_ADDR
local KBHEAD = KBHEAD_ADDR

local BGFLG_ADDR = 0xF3CF
local BGSTAR_ADDR = 0xF500
local BG_SET_BIT = 0xE20A
local DISPL_BGFLG = 0xE6C3   -- displ's ld a,(bgflg) at 0xDB29+0x0B9A
local SPECC_CASE13 = 0xE7B5  -- specc case 0x13 at 0xDB29+0x0C8C

-- Track previous values for change detection
local prev_bgflg = -1
local prev_bgstar0 = -1

local f = io.open("/tmp/bgflg_trace.txt", "w")
local function log(msg) print(msg); f:write(msg .. "\n"); f:flush() end

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

local function dump_bgstar(space, label)
    local s = label .. " BGSTAR[0-31]: "
    for i = 0, 31 do s = s .. string.format("%02X ", space:read_u8(BGSTAR_ADDR + i)) end
    log(s)
    s = label .. " BGSTAR[20-35]: "
    for i = 20, 35 do s = s .. string.format("%02X ", space:read_u8(BGSTAR_ADDR + i)) end
    log(s)
end

local function dump_code(space, label, addr, len)
    local s = string.format("%s at 0x%04X: ", label, addr)
    for i = 0, len - 1 do
        s = s .. string.format("%02X ", space:read_u8(addr + i))
    end
    log(s)
end

emu.register_frame_done(function()
    if done then return end
    frame = frame + 1
    local space = manager.machine.devices[":maincpu"].spaces["program"]

    -- Monitor bgflg and bgstar[0] for changes
    local bgflg = space:read_u8(BGFLG_ADDR)
    local bgstar0 = space:read_u8(BGSTAR_ADDR)
    local usession = space:read_u8(0xFFDA)

    if bgflg ~= prev_bgflg then
        log(string.format("f=%d bgflg: %d -> %d (usession=0x%02X)", frame, prev_bgflg, bgflg, usession))
        prev_bgflg = bgflg
    end
    if bgstar0 ~= prev_bgstar0 then
        log(string.format("f=%d bgstar[0]: 0x%02X -> 0x%02X (bgflg=%d usession=0x%02X)", frame, prev_bgstar0, bgstar0, bgflg, usession))
        prev_bgstar0 = bgstar0
    end

    -- Key injection
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
            log("Boot OK, running BGTEST")

            -- Verify memory writes work
            space:write_u8(BGSTAR_ADDR, 0xAA)
            local v = space:read_u8(BGSTAR_ADDR)
            log(string.format("Manual write test: wrote 0xAA to 0xF500, read 0x%02X", v))
            space:write_u8(BGSTAR_ADDR, 0x00)

            -- Dump critical code
            dump_code(space, "bg_set_bit", BG_SET_BIT, 8)
            dump_code(space, "displ bgflg check", DISPL_BGFLG, 15)
            dump_code(space, "specc case 0x13", SPECC_CASE13, 14)

            inject_string("BGTEST\r")
            stage = 1; stage_timer = 0
        elseif frame > 3000 then log("TIMEOUT boot"); done = true; f:close(); os.exit(0) end
        return
    end

    if stage == 1 then
        if screen_find(space, "TEST1 OK") then
            log("=== TEST1 OK found ===")
            log(string.format("bgflg = %d", space:read_u8(BGFLG_ADDR)))
            dump_bgstar(space, "T1")
            log(string.format("bgstar[0] = 0x%02X (debug stub should write 0xFF)", space:read_u8(BGSTAR_ADDR)))
            log(string.format("bgstar[24] = 0x%02X (cat at row2 col35 should be 0x10)", space:read_u8(BGSTAR_ADDR + 24)))

            -- Screen content at cat position
            local s = "Screen row2 col35: "
            for i = 0, 6 do
                local ch = space:read_u8(0xF800 + 2*80 + 35 + i)
                s = s .. string.format("%02X(%s) ", ch, ch >= 0x20 and ch < 0x7F and string.char(ch) or "?")
            end
            log(s)

            stage = 99; stage_timer = 10
        elseif frame > 5000 then
            log("TIMEOUT waiting for TEST1 OK")
            for row = 0, 6 do
                local line = string.format("Row %d: ", row)
                for col = 0, 79 do
                    local ch = space:read_u8(0xF800 + row * 80 + col)
                    line = line .. (ch >= 0x20 and ch < 0x7F and string.char(ch) or " ")
                end
                log(line:gsub("%s+$", ""))
            end
            log(string.format("bgflg=%d bgstar[0]=0x%02X", space:read_u8(BGFLG_ADDR), space:read_u8(BGSTAR_ADDR)))
            dump_bgstar(space, "TIMEOUT")
            stage = 99; stage_timer = 10
        end
        return
    end

    if stage == 99 then f:close(); done = true; os.exit(0) end
end)

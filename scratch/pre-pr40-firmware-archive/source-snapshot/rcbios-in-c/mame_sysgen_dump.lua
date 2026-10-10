-- SYSGEN memory layout discovery script
-- Boots CP/M, runs SYSGEN to read system tracks from A:, then dumps
-- the memory at 0x0900 (SYSGEN's LOADP) to /tmp/sysgen_dump.bin.
--
-- Flow: boot → SYSGEN → read from A → dump memory → quit
--
-- Output:
--   /tmp/sysgen_dump.bin   — raw memory 0x0900..0x7FFF
--   /tmp/sysgen_dump.txt   — screen captures + hex summary

local frame = 0
local done = false
local state = "boot"
local screens = {}
local wait_frames = 0

local LOADP = 0x0900
local DUMP_END = 0x7FFF  -- generous upper bound

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

-- Check if CP/M is at A> prompt
local function at_prompt()
    local space = manager.machine.devices[":maincpu"].spaces["program"]
    local curx = space:read_u8(0xFFD1)
    local cursy = space:read_u8(0xFFD4)
    if curx ~= 2 then return false end
    local row_addr = 0xF800 + cursy * 80
    return space:read_u8(row_addr) == 0x41 and space:read_u8(row_addr + 1) == 0x3E
end

-- Scan screen for a string (checks all rows)
local function screen_contains(needle)
    local space = manager.machine.devices[":maincpu"].spaces["program"]
    for row = 0, 24 do
        local line = ""
        for col = 0, 79 do
            local ch = space:read_u8(0xF800 + row * 80 + col)
            line = line .. (ch >= 0x20 and ch < 0x7F and string.char(ch) or " ")
        end
        if line:find(needle, 1, true) then return true end
    end
    return false
end

-- Dump memory range to binary file
local function dump_memory(start_addr, end_addr, path)
    local space = manager.machine.devices[":maincpu"].spaces["program"]
    local f = io.open(path, "wb")
    for addr = start_addr, end_addr do
        f:write(string.char(space:read_u8(addr)))
    end
    f:close()
    return end_addr - start_addr + 1
end

-- Find last non-zero byte in memory range
local function find_last_nonzero(start_addr, end_addr)
    local space = manager.machine.devices[":maincpu"].spaces["program"]
    for addr = end_addr, start_addr, -1 do
        if space:read_u8(addr) ~= 0 then
            return addr
        end
    end
    return start_addr
end

local function finish()
    -- Find extent of data
    local last = find_last_nonzero(LOADP, DUMP_END)
    local size = last - LOADP + 1
    screens[#screens + 1] = string.format(
        "=== Memory layout ===\nLOADP = 0x%04X\nLast non-zero = 0x%04X\nSize = %d bytes (0x%04X)",
        LOADP, last, size, size
    )

    -- Dump memory
    local nbytes = dump_memory(LOADP, last, "/tmp/sysgen_dump.bin")
    print(string.format("Dumped %d bytes (0x%04X-0x%04X) to /tmp/sysgen_dump.bin",
                        nbytes, LOADP, last))

    -- Write screen captures
    local f = io.open("/tmp/sysgen_dump.txt", "w")
    for _, s in ipairs(screens) do f:write(s .. "\n\n") end
    f:close()
    print("Screen captures: /tmp/sysgen_dump.txt")

    done = true
    os.exit(0)
end

emu.register_frame_done(function()
    if done then return end
    frame = frame + 1

    if state == "boot" then
        -- Wait for A> prompt
        if at_prompt() then
            screens[#screens + 1] = "=== Boot complete ===\n" .. screen_text()
            manager.machine.natkeyboard:post("SYSGEN\r")
            state = "wait_source"
            wait_frames = 0
        elseif frame > 50 * 30 then
            screens[#screens + 1] = "=== TIMEOUT waiting for boot ===\n" .. screen_text()
            done = true; os.exit(1)
        end

    elseif state == "wait_source" then
        -- Wait for "SOURCE DRIVE NAME"
        wait_frames = wait_frames + 1
        if screen_contains("SOURCE DRIVE") then
            screens[#screens + 1] = "=== SYSGEN started ===\n" .. screen_text()
            manager.machine.natkeyboard:post("A")
            state = "wait_source_confirm"
            wait_frames = 0
        elseif wait_frames > 50 * 10 then
            screens[#screens + 1] = "=== TIMEOUT waiting for SYSGEN ===\n" .. screen_text()
            done = true; os.exit(1)
        end

    elseif state == "wait_source_confirm" then
        -- Wait for "SOURCE ON A"
        wait_frames = wait_frames + 1
        if screen_contains("SOURCE ON") then
            manager.machine.natkeyboard:post("\r")
            state = "wait_read"
            wait_frames = 0
        elseif wait_frames > 50 * 5 then
            screens[#screens + 1] = "=== TIMEOUT waiting for confirm ===\n" .. screen_text()
            done = true; os.exit(1)
        end

    elseif state == "wait_read" then
        -- Wait for "FUNCTION COMPLETE" (read finished)
        wait_frames = wait_frames + 1
        if screen_contains("FUNCTION COMPLETE") then
            screens[#screens + 1] = "=== Read complete ===\n" .. screen_text()
            -- Data is now in memory at 0x900. Dump before doing anything else.
            finish()
        elseif wait_frames > 50 * 60 then
            screens[#screens + 1] = "=== TIMEOUT waiting for read ===\n" .. screen_text()
            done = true; os.exit(1)
        end
    end

    -- Global timeout: 3 minutes
    if frame > 50 * 180 then
        screens[#screens + 1] = "=== GLOBAL TIMEOUT ===\n" .. screen_text()
        done = true; os.exit(1)
    end
end)

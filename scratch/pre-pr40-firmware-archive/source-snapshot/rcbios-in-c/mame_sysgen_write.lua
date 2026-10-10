-- SYSGEN write test: read system tracks from A:, inject new BIOS, write back.
--
-- Flow: boot → SYSGEN read A: → inject bios at 0x4500 → SYSGEN write A: → clean exit
--
-- Expects /tmp/sysgen_t0.bin (from mk_sysgen_t0.py)
-- Output: /tmp/sysgen_write.txt — screen captures

local LOADP = 0x0900
local T0_OFFSET = 0x3C00
local T0_ADDR = LOADP + T0_OFFSET  -- 0x4500

local frame = 0
local done = false
local screens = {}
local wait_frames = 0
local state = "boot"

local function log(msg)
    screens[#screens + 1] = msg
    print(msg)
end

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

local function count_screen(needle)
    local space = manager.machine.devices[":maincpu"].spaces["program"]
    local count = 0
    for row = 0, 24 do
        local line = ""
        for col = 0, 79 do
            local ch = space:read_u8(0xF800 + row * 80 + col)
            line = line .. (ch >= 0x20 and ch < 0x7F and string.char(ch) or " ")
        end
        if line:find(needle, 1, true) then count = count + 1 end
    end
    return count
end

local function write_memory_from_file(addr, path)
    local f = io.open(path, "rb")
    if not f then
        log("ERROR: cannot open " .. path)
        return 0
    end
    local data = f:read("*a")
    f:close()
    local space = manager.machine.devices[":maincpu"].spaces["program"]
    for i = 1, #data do
        space:write_u8(addr + i - 1, string.byte(data, i))
    end
    return #data
end

local function finish(success)
    local f = io.open("/tmp/sysgen_write.txt", "w")
    for _, s in ipairs(screens) do f:write(s .. "\n\n") end
    f:close()
    done = true
    -- Use manager.machine:exit() for clean shutdown so MFI is saved
    manager.machine:exit()
end

emu.register_frame_done(function()
    if done then return end
    frame = frame + 1

    if frame > 50 * 300 then
        log("GLOBAL TIMEOUT at frame " .. frame)
        log(screen_text())
        finish(false)
        return
    end

    if state == "boot" then
        if at_prompt() then
            log("Boot complete, starting SYSGEN")
            manager.machine.natkeyboard:post("SYSGEN\r")
            state = "wait_source"
            wait_frames = 0
        elseif frame > 50 * 30 then
            log("TIMEOUT waiting for boot")
            finish(false)
        end

    elseif state == "wait_source" then
        wait_frames = wait_frames + 1
        if screen_contains("SOURCE DRIVE") then
            manager.machine.natkeyboard:post("A")
            state = "wait_source_confirm"
            wait_frames = 0
        elseif wait_frames > 50 * 10 then
            log("TIMEOUT waiting for SOURCE DRIVE")
            finish(false)
        end

    elseif state == "wait_source_confirm" then
        wait_frames = wait_frames + 1
        if screen_contains("SOURCE ON") then
            manager.machine.natkeyboard:post("\r")
            state = "wait_read_complete"
            wait_frames = 0
        elseif wait_frames > 50 * 5 then
            log("TIMEOUT waiting for SOURCE ON")
            finish(false)
        end

    elseif state == "wait_read_complete" then
        wait_frames = wait_frames + 1
        if screen_contains("FUNCTION COMPLETE") then
            log("Read complete")
            -- Inject new BIOS at track 0 location
            local nbytes = write_memory_from_file(T0_ADDR, "/tmp/sysgen_t0.bin")
            log(string.format("Injected %d bytes at 0x%04X", nbytes, T0_ADDR))
            state = "wait_dest"
            wait_frames = 0
        elseif wait_frames > 50 * 60 then
            log("TIMEOUT waiting for read FUNCTION COMPLETE")
            finish(false)
        end

    elseif state == "wait_dest" then
        wait_frames = wait_frames + 1
        if screen_contains("DESTINATION") then
            manager.machine.natkeyboard:post("A")
            state = "wait_dest_confirm"
            wait_frames = 0
        elseif wait_frames > 50 * 5 then
            log("TIMEOUT waiting for DESTINATION")
            finish(false)
        end

    elseif state == "wait_dest_confirm" then
        wait_frames = wait_frames + 1
        if screen_contains("DESTINATION ON") then
            manager.machine.natkeyboard:post("\r")
            state = "wait_write_complete"
            wait_frames = 0
        elseif wait_frames > 50 * 5 then
            log("TIMEOUT waiting for DESTINATION ON")
            finish(false)
        end

    elseif state == "wait_write_complete" then
        wait_frames = wait_frames + 1
        if count_screen("FUNCTION COMPLETE") >= 2 then
            log("Write complete!")
            log(screen_text())
            -- Clean exit — MAME will flush MFI to disk
            finish(true)
        elseif wait_frames > 50 * 60 then
            log("TIMEOUT waiting for write FUNCTION COMPLETE")
            log(screen_text())
            finish(false)
        end
    end
end)

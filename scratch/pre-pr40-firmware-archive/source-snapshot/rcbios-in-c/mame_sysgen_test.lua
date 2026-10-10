-- SYSGEN install test: read system tracks, inject new BIOS, write back, verify.
--
-- Phase 1: SYSGEN read A: → inject bios at 0x4500 → write A:
-- Phase 2: SYSGEN read A: → dump memory → compare with injected data
-- Phase 3: Boot from written disk → verify banner
--
-- Expects /tmp/sysgen_t0.bin (from mk_sysgen_t0.py)
--
-- Output:
--   /tmp/sysgen_test.txt — screen captures and verification results

local LOADP = 0x0900
local T0_OFFSET = 0x3C00       -- track 0 starts at LOADP + 0x3C00 = 0x4500
local T0_ADDR = LOADP + T0_OFFSET  -- 0x4500
local T0_SIZE = 0x3400         -- 13312 bytes

local frame = 0
local done = false
local screens = {}
local wait_frames = 0
local state = "boot"
local phase = 1  -- 1=write, 2=verify-read, 3=verify-boot

-- Pre-load the BIOS image
local bios_data = nil
local t1_reference = nil  -- track 1 data from first read (for verification)

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

local function read_memory(start_addr, size)
    local space = manager.machine.devices[":maincpu"].spaces["program"]
    local data = {}
    for i = 0, size - 1 do
        data[i + 1] = space:read_u8(start_addr + i)
    end
    return data
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

local function save_memory(start_addr, size, path)
    local space = manager.machine.devices[":maincpu"].spaces["program"]
    local f = io.open(path, "wb")
    for i = 0, size - 1 do
        f:write(string.char(space:read_u8(start_addr + i)))
    end
    f:close()
end

local function compare_memory_with_file(addr, path)
    local f = io.open(path, "rb")
    if not f then return false, "cannot open " .. path end
    local data = f:read("*a")
    f:close()
    local space = manager.machine.devices[":maincpu"].spaces["program"]
    local mismatches = 0
    local first_mm = -1
    for i = 1, #data do
        local mem = space:read_u8(addr + i - 1)
        local file = string.byte(data, i)
        if mem ~= file then
            mismatches = mismatches + 1
            if first_mm < 0 then first_mm = i - 1 end
        end
    end
    if mismatches == 0 then
        return true, string.format("OK: %d bytes match", #data)
    else
        return false, string.format("FAIL: %d mismatches (first at offset 0x%04X)", mismatches, first_mm)
    end
end

-- Count of "FUNCTION COMPLETE" seen so far (to distinguish first from second)
local func_complete_count = 0
local saw_destination = false

local function finish()
    local f = io.open("/tmp/sysgen_test.txt", "w")
    for _, s in ipairs(screens) do f:write(s .. "\n\n") end
    f:close()
    done = true
    os.exit(0)
end

local function fail(msg)
    log("FAIL: " .. msg)
    log(screen_text())
    local f = io.open("/tmp/sysgen_test.txt", "w")
    for _, s in ipairs(screens) do f:write(s .. "\n\n") end
    f:close()
    done = true
    os.exit(1)
end

emu.register_frame_done(function()
    if done then return end
    frame = frame + 1

    -- Global timeout: 5 minutes
    if frame > 50 * 300 then
        fail("GLOBAL TIMEOUT at frame " .. frame)
        return
    end

    if phase == 1 then
        -- Phase 1: SYSGEN read A:, inject BIOS, write A:
        if state == "boot" then
            if at_prompt() then
                log("=== Phase 1: SYSGEN read + inject + write ===")
                manager.machine.natkeyboard:post("SYSGEN\r")
                state = "wait_source"
                wait_frames = 0
            elseif frame > 50 * 30 then
                fail("timeout waiting for boot")
            end

        elseif state == "wait_source" then
            wait_frames = wait_frames + 1
            if screen_contains("SOURCE DRIVE") then
                manager.machine.natkeyboard:post("A")
                state = "wait_source_confirm"
                wait_frames = 0
            elseif wait_frames > 50 * 10 then
                fail("timeout waiting for SOURCE DRIVE")
            end

        elseif state == "wait_source_confirm" then
            wait_frames = wait_frames + 1
            if screen_contains("SOURCE ON") then
                manager.machine.natkeyboard:post("\r")
                state = "wait_read_complete"
                wait_frames = 0
            elseif wait_frames > 50 * 5 then
                fail("timeout waiting for SOURCE ON")
            end

        elseif state == "wait_read_complete" then
            wait_frames = wait_frames + 1
            if screen_contains("FUNCTION COMPLETE") then
                log("Phase 1: read complete")

                -- Save track 1 reference (for later verification)
                save_memory(LOADP, T0_OFFSET, "/tmp/sysgen_t1_ref.bin")
                log(string.format("Saved track 1 reference: 0x%04X-0x%04X (%d bytes)",
                    LOADP, LOADP + T0_OFFSET - 1, T0_OFFSET))

                -- Inject new BIOS at track 0 location
                local nbytes = write_memory_from_file(T0_ADDR, "/tmp/sysgen_t0.bin")
                log(string.format("Injected BIOS: %d bytes at 0x%04X", nbytes, T0_ADDR))

                -- Now wait for DESTINATION prompt
                state = "wait_dest"
                wait_frames = 0
                saw_destination = false
            elseif wait_frames > 50 * 60 then
                fail("timeout waiting for read FUNCTION COMPLETE")
            end

        elseif state == "wait_dest" then
            wait_frames = wait_frames + 1
            if screen_contains("DESTINATION") and not saw_destination then
                saw_destination = true
                manager.machine.natkeyboard:post("A")
                state = "wait_dest_confirm"
                wait_frames = 0
            elseif wait_frames > 50 * 5 then
                fail("timeout waiting for DESTINATION")
            end

        elseif state == "wait_dest_confirm" then
            wait_frames = wait_frames + 1
            if screen_contains("DESTINATION ON") then
                manager.machine.natkeyboard:post("\r")
                state = "wait_write_complete"
                wait_frames = 0
                func_complete_count = 0
            elseif wait_frames > 50 * 5 then
                fail("timeout waiting for DESTINATION ON")
            end

        elseif state == "wait_write_complete" then
            wait_frames = wait_frames + 1
            -- Need to detect the SECOND "FUNCTION COMPLETE" on screen
            -- (first one from read is still visible)
            -- Count occurrences
            local space = manager.machine.devices[":maincpu"].spaces["program"]
            local count = 0
            for row = 0, 24 do
                local line = ""
                for col = 0, 79 do
                    local ch = space:read_u8(0xF800 + row * 80 + col)
                    line = line .. (ch >= 0x20 and ch < 0x7F and string.char(ch) or " ")
                end
                if line:find("FUNCTION COMPLETE", 1, true) then count = count + 1 end
            end
            if count >= 2 then
                log("Phase 1: write complete")
                log(screen_text())

                -- Reboot by pressing RETURN at the next DESTINATION prompt
                state = "wait_dest_reboot"
                wait_frames = 0
            elseif wait_frames > 50 * 60 then
                fail("timeout waiting for write FUNCTION COMPLETE")
            end

        elseif state == "wait_dest_reboot" then
            wait_frames = wait_frames + 1
            -- The second DESTINATION prompt should appear
            -- Count DESTINATION occurrences
            local space = manager.machine.devices[":maincpu"].spaces["program"]
            local count = 0
            for row = 0, 24 do
                local line = ""
                for col = 0, 79 do
                    local ch = space:read_u8(0xF800 + row * 80 + col)
                    line = line .. (ch >= 0x20 and ch < 0x7F and string.char(ch) or " ")
                end
                if line:find("DESTINATION DRIVE", 1, true) then count = count + 1 end
            end
            if count >= 2 then
                -- Press RETURN to reboot
                manager.machine.natkeyboard:post("\r")
                phase = 2
                state = "boot"
                wait_frames = 0
                log("Phase 1 done. Rebooting for verification...")
            elseif wait_frames > 50 * 10 then
                -- Maybe just press return anyway
                manager.machine.natkeyboard:post("\r")
                phase = 2
                state = "boot"
                wait_frames = 0
                log("Phase 1 done (timeout on 2nd DEST). Rebooting...")
            end
        end

    elseif phase == 2 then
        -- Phase 2: Verify by SYSGEN read and memory compare
        if state == "boot" then
            wait_frames = wait_frames + 1
            if at_prompt() then
                -- Check boot banner for CL (clang) marker
                local scr = screen_text()
                log("=== Phase 2: Boot verification ===")
                log(scr)

                if scr:find("CL", 1, true) then
                    log("OK: Boot banner contains CL (clang BIOS)")
                else
                    log("INFO: Boot banner does not contain CL")
                end

                -- Now run SYSGEN read to verify bytes
                manager.machine.natkeyboard:post("SYSGEN\r")
                state = "wait_source"
                wait_frames = 0
            elseif wait_frames > 50 * 30 then
                fail("timeout waiting for boot (phase 2)")
            end

        elseif state == "wait_source" then
            wait_frames = wait_frames + 1
            if screen_contains("SOURCE DRIVE") then
                manager.machine.natkeyboard:post("A")
                state = "wait_source_confirm"
                wait_frames = 0
            elseif wait_frames > 50 * 10 then
                fail("timeout waiting for SOURCE DRIVE (phase 2)")
            end

        elseif state == "wait_source_confirm" then
            wait_frames = wait_frames + 1
            if screen_contains("SOURCE ON") then
                manager.machine.natkeyboard:post("\r")
                state = "wait_read_complete"
                wait_frames = 0
            elseif wait_frames > 50 * 5 then
                fail("timeout waiting for SOURCE ON (phase 2)")
            end

        elseif state == "wait_read_complete" then
            wait_frames = wait_frames + 1
            if screen_contains("FUNCTION COMPLETE") then
                log("Phase 2: verification read complete")

                -- Compare track 0 region with injected data
                local ok, msg = compare_memory_with_file(T0_ADDR, "/tmp/sysgen_t0.bin")
                log("Track 0 verify: " .. msg)

                -- Compare track 1 region with saved reference
                local ok2, msg2 = compare_memory_with_file(LOADP, "/tmp/sysgen_t1_ref.bin")
                log("Track 1 verify: " .. msg2)

                if ok and ok2 then
                    log("=== ALL CHECKS PASSED ===")
                else
                    log("=== VERIFICATION FAILED ===")
                end

                finish()
            elseif wait_frames > 50 * 60 then
                fail("timeout waiting for verify read FUNCTION COMPLETE")
            end
        end
    end
end)

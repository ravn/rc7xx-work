-- mame_siob_test.lua
--
-- Autoboot Lua script for SIO-B receive test.  Runs SIOBTEST.COM which
-- directly calls BIOS READER with IOBYTE set to UR1 (SIO-B), reads
-- bytes, checks for marker string, and prints PASS or FAIL.
--
-- Flow:
--   1. Set RS232 baud on rs232b to 38400 8N1 to match the BIOS.
--   2. Wait for the A> prompt.
--   3. Type "SIOBTEST" and press Enter.
--   4. Create trigger file to tell server to start sending.
--   5. Wait for A> prompt to return (program exited).
--   6. Scrape screen for PASS/FAIL marker.
--   7. Write result and exit MAME.

local FPS = 50
local frame = 0
local done = false
local state = "init"
local wait_frames = 0
local log_lines = {}

local PASS_MARKER = "SIOB-IOBYTE-TEST-OK"
local FAIL_MARKER = "SIOB-IOBYTE-TEST-FAIL"

local function log(msg)
    log_lines[#log_lines + 1] = msg
    print("[siob-test] " .. msg)
end

local function mem_read(addr)
    return manager.machine.devices[":maincpu"].spaces["program"]:read_u8(addr)
end

local function screen_text()
    local rows = {}
    for row = 0, 24 do
        local line = ""
        for col = 0, 79 do
            local ch = mem_read(0xF800 + row * 80 + col)
            line = line .. (ch >= 0x20 and ch < 0x7F and string.char(ch) or " ")
        end
        rows[#rows + 1] = line:gsub("%s+$", "")
    end
    return table.concat(rows, "\n")
end

local function screen_contains(needle)
    for row = 0, 24 do
        local line = ""
        for col = 0, 79 do
            local ch = mem_read(0xF800 + row * 80 + col)
            line = line .. (ch >= 0x20 and ch < 0x7F and string.char(ch) or " ")
        end
        if line:find(needle, 1, true) then return true end
    end
    return false
end

local function at_prompt()
    local curx = mem_read(0xFFD1)
    local cursy = mem_read(0xFFD4)
    if curx ~= 2 then return false end
    local r = 0xF800 + cursy * 80
    return mem_read(r) == 0x41 and mem_read(r + 1) == 0x3E
end

local last_prompt_row = -1
local function new_prompt()
    local curx = mem_read(0xFFD1)
    local cursy = mem_read(0xFFD4)
    if curx ~= 2 then return false end
    local r = 0xF800 + cursy * 80
    if mem_read(r) ~= 0x41 or mem_read(r + 1) ~= 0x3E then return false end
    if cursy ~= last_prompt_row then
        last_prompt_row = cursy
        return true
    end
    return false
end

local function write_result(success)
    local f = io.open("/tmp/siob_test_result", "w")
    f:write(success and "PASS\n" or "FAIL\n")
    for _, line in ipairs(log_lines) do f:write(line .. "\n") end
    f:write("--- screen ---\n")
    f:write(screen_text())
    f:close()
end

local function finish(success)
    log(success and "=== PASS ===" or "=== FAIL ===")
    write_result(success)
    done = true
    manager.machine:exit()
end

local function configure_serial()
    -- Log the actual baud rate settings for debugging
    local ports = manager.machine.ioport.ports
    for tag, port in pairs(ports) do
        if tag:find("RS232") then
            for name, field in pairs(port.fields) do
                log(string.format("  port %s field %s = %d (def %d)",
                    tag, name, field.user_value, field.defvalue))
            end
        end
    end
    -- Force rs232b baud to 38400 in case a previous baud experiment left
    -- a stale user_value (MAME persists ioport overrides).
    for tag, port in pairs(ports) do
        if tag:find("rs232b") and (tag:find("RS232_TXBAUD") or tag:find("RS232_RXBAUD")) then
            for _, field in pairs(port.fields) do
                field.user_value = 0x0b  -- RS232_BAUD_38400
            end
        end
    end
    log("null_modem: forced rs232b to 38400 8N1")
end

local trigger_sent = false
local function send_trigger()
    if trigger_sent then return end
    -- Before sending trigger, check how many bytes already in SIO-B buffer
    local rxhead_b = mem_read(0xEDF5)
    local rxtail_b = mem_read(0xECFC)
    log(string.format("pre-trigger: rxhead_b=%02X rxtail_b=%02X (spurious bytes: %d)",
        rxhead_b, rxtail_b, (rxhead_b - rxtail_b) % 256))
    local f = io.open("/tmp/siob_iobyte_trigger", "w")
    f:write("go\n")
    f:close()
    trigger_sent = true
    log("trigger written")
end

emu.register_frame_done(function()
    if done then return end
    frame = frame + 1
    if frame == 1 then configure_serial() end
    if frame > FPS * 120 then log("GLOBAL TIMEOUT"); finish(false); return end

    if state == "init" then
        if at_prompt() then
            last_prompt_row = mem_read(0xFFD4)
            log("Booted, A> seen")
            state = "run_test"
            wait_frames = 0
        elseif frame > FPS * 60 then
            log("TIMEOUT waiting for boot")
            finish(false)
        end

    elseif state == "run_test" then
        if wait_frames == 0 then
            manager.machine.natkeyboard:post("SIOBTEST\r")
        end
        wait_frames = wait_frames + 1
        -- Send trigger once the program is running (no longer at prompt)
        if not trigger_sent and wait_frames > FPS * 1 and not at_prompt() then
            send_trigger()
        end
        -- Debug: check SIO-B ring buffer every half second
        if trigger_sent and wait_frames % (FPS / 2) == 0 then
            local rxhead_b = mem_read(0xECF2)
            local rxtail_b = mem_read(0xECF3)
            local ivt_10_lo = mem_read(0xF614)
            local ivt_10_hi = mem_read(0xF615)
            local iobyte = mem_read(0x0003)
            log(string.format("debug: rxhead_b=%02X rxtail_b=%02X IVT[10]=%04X IOBYTE=%02X",
                rxhead_b, rxtail_b, ivt_10_hi * 256 + ivt_10_lo, iobyte))
            -- Dump first 32 bytes of SIO-B ring buffer (rxbuf_b at 0xECFC)
            local hex = {}
            for i = 0, 31 do
                hex[#hex+1] = string.format("%02X", mem_read(0xECFC + i))
            end
            log("  buf: " .. table.concat(hex, " "))
            -- Read SIO-B RR0 via I/O port (0x0B = SIO-B ctrl)
            local sio_b_rr0 = manager.machine.devices[":maincpu"].spaces["io"]:read_u8(0x0B)
            log(string.format("  SIO-B RR0=%02X (RxAvail=%d DCD=%d CTS=%d)",
                sio_b_rr0, sio_b_rr0 & 1, (sio_b_rr0 >> 3) & 1, (sio_b_rr0 >> 5) & 1))
        end
        if trigger_sent and new_prompt() then
            log("SIOBTEST complete")
            local scr = screen_text()
            log(scr)
            if screen_contains(PASS_MARKER) then
                log("found: " .. PASS_MARKER)
                finish(true)
            elseif screen_contains(FAIL_MARKER) then
                log("found: " .. FAIL_MARKER)
                finish(false)
            else
                log("neither PASS nor FAIL marker found")
                finish(false)
            end
        elseif wait_frames > FPS * 60 then
            log("TIMEOUT SIOBTEST")
            log(screen_text())
            finish(false)
        end
    end
end)

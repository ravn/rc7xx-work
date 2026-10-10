-- mame_siob_iobyte_test.lua
--
-- Autoboot Lua script for `make siob-iobyte-test`.  Verifies that the
-- new IOB_BAT arm in bios_reader_body routes RDR: to SIO-B correctly.
--
-- Flow:
--   1. Set RS232 baud on rs232a and rs232b to 38400 to match the BIOS.
--   2. Wait for the A> prompt.
--   3. STAT RDR:=UR1:            (route RDR: through SIO-B in new BIOS)
--   4. PIP CON:=RDR:[E]          (read bytes from RDR:, echo to CRT)
--   5. Create /tmp/siob_iobyte_trigger   (tells server to start sending)
--   6. Wait for PIP to finish (A> prompt returns).
--   7. Scrape the CRT display for the expected marker string.
--   8. Write /tmp/siob_iobyte_result (PASS or FAIL) and exit MAME.
--
-- The expected marker string is hard-coded below; the Makefile writes
-- the same string into /tmp/siob_iobyte_payload.txt before launching
-- the server, so they stay in sync.

local FPS = 50
local frame = 0
local done = false
local state = "init"
local wait_frames = 0
local log_lines = {}

local EXPECTED = "SIOB-IOBYTE-TEST-OK"

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
    local f = io.open("/tmp/siob_iobyte_result", "w")
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
    -- Match BIOS SIO-A and SIO-B at 38400 8N1.  The loop sets every
    -- RS232_TXBAUD/RS232_RXBAUD port in the machine, which covers both
    -- rs232a (if present) and rs232b.
    local ports = manager.machine.ioport.ports
    for tag, port in pairs(ports) do
        if tag:find("RS232_TXBAUD") or tag:find("RS232_RXBAUD") then
            for _, field in pairs(port.fields) do
                field.user_value = 0x0b  -- RS232_BAUD_38400
            end
        end
        if tag:find("FLOW_CONTROL") then
            for _, field in pairs(port.fields) do
                if field.name:find("Flow Control") then
                    field.user_value = 0x00  -- no flow control
                end
            end
        end
    end
    log("null_modem: 38400 8N1, no flow control")
end

local trigger_sent = false
local function send_trigger()
    if trigger_sent then return end
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
    if frame > FPS * 300 then log("GLOBAL TIMEOUT"); finish(false); return end

    if state == "init" then
        if at_prompt() then
            last_prompt_row = mem_read(0xFFD4)
            log("Booted, A> seen")
            state = "stat_rdr"
            wait_frames = 0
        elseif frame > FPS * 60 then
            log("TIMEOUT waiting for boot")
            finish(false)
        end

    elseif state == "stat_rdr" then
        if wait_frames == 0 then
            manager.machine.natkeyboard:post("STAT RDR:=UR1:\r")
        end
        wait_frames = wait_frames + 1
        if new_prompt() then
            log("STAT RDR:=UR1: complete")
            state = "pip"
            wait_frames = 0
        elseif wait_frames > FPS * 10 then
            log("TIMEOUT STAT")
            finish(false)
        end

    elseif state == "pip" then
        -- Save RDR: input to a file (avoids [ ] which natkeyboard
        -- may not deliver reliably on generic_keyboard).
        if wait_frames == 0 then
            manager.machine.natkeyboard:post("PIP SIOB.TXT=RDR:\r")
        end
        wait_frames = wait_frames + 1
        if not trigger_sent and wait_frames > FPS * 2 and not at_prompt() then
            send_trigger()
        end
        if trigger_sent and new_prompt() then
            log("PIP complete")
            state = "stat_restore"
            wait_frames = 0
        elseif wait_frames > FPS * 60 then
            log("TIMEOUT PIP")
            finish(false)
        end

    elseif state == "stat_restore" then
        -- Restore RDR: to default (PTR/SIO-A) to stop SIO-B input
        if wait_frames == 0 then
            manager.machine.natkeyboard:post("STAT RDR:=PTR:\r")
        end
        wait_frames = wait_frames + 1
        if new_prompt() then
            log("STAT RDR:=PTR: complete (restored)")
            state = "type"
            wait_frames = 0
        elseif wait_frames > FPS * 10 then
            log("TIMEOUT STAT restore")
            finish(false)
        end

    elseif state == "type" then
        -- TYPE the saved file to display it on screen for scraping.
        if wait_frames == 0 then
            manager.machine.natkeyboard:post("TYPE SIOB.TXT\r")
        end
        wait_frames = wait_frames + 1
        if new_prompt() then
            log("TYPE complete")
            log(screen_text())
            if screen_contains(EXPECTED) then
                log("found marker: " .. EXPECTED)
                finish(true)
            else
                log("marker NOT found: " .. EXPECTED)
                finish(false)
            end
        elseif wait_frames > FPS * 30 then
            log("TIMEOUT TYPE")
            finish(false)
        end
    end
end)

-- mame_siob_baud_test.lua
--
-- Autoboot Lua for SIO-B baud rate experiment.
-- Env vars:
--   SIOB_BAUD_IDX  — rate index (0-3), default 0
--   SIOB_BAUD_MAME — MAME RS232 baud value (decimal), default 11 (38400)
--
-- Flow:
--   1. Boot to A> prompt
--   2. Type "SIOBBAUD <idx>" + Enter
--   3. Wait for "Ready" on screen (program reprogrammed CTC+SIO)
--   4. Set null_modem baud to match
--   5. Send trigger for server to transmit payload
--   6. Wait for result

local FPS = 50
local frame = 0
local done = false
local state = "init"
local wait_frames = 0

local BAUD_IDX = tonumber(os.getenv("SIOB_BAUD_IDX") or "0")
local BAUD_MAME = tonumber(os.getenv("SIOB_BAUD_MAME") or "11")

local PASS_MARKER = "SIOB-BAUD-TEST-OK"
local FAIL_MARKER = "SIOB-BAUD-TEST-FAIL"

local function log(msg) print("[baud-test] " .. msg) end

local function mem_read(addr)
    return manager.machine.devices[":maincpu"].spaces["program"]:read_u8(addr)
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

local function set_baud(baud_val)
    -- Set rs232b null_modem baud rate
    local ports = manager.machine.ioport.ports
    for tag, port in pairs(ports) do
        if tag:find("rs232b") and (tag:find("RS232_TXBAUD") or tag:find("RS232_RXBAUD")) then
            for _, field in pairs(port.fields) do
                field.user_value = baud_val
                log(string.format("  set %s = %d", tag, baud_val))
            end
        end
    end
end

local function write_result(success)
    local f = io.open("/tmp/siob_baud_result", "w")
    f:write(success and "PASS\n" or "FAIL\n")
    f:write("baud_idx=" .. BAUD_IDX .. " mame_baud=" .. BAUD_MAME .. "\n")
    f:write(screen_text() .. "\n")
    f:close()
end

local function finish(success)
    log(success and "=== PASS ===" or "=== FAIL ===")
    write_result(success)
    done = true
    manager.machine:exit()
end

local trigger_sent = false

-- Ensure null_modem starts at 38400 (baseline) regardless of prior runs
local init_done = false
emu.register_frame_done(function()
    if not init_done then
        set_baud(11)  -- RS232_BAUD_38400
        init_done = true
        log("Initialized null_modem to 38400")
    end
    if done then return end
    frame = frame + 1
    if frame > FPS * 120 then log("GLOBAL TIMEOUT"); finish(false); return end

    if state == "init" then
        if at_prompt() then
            last_prompt_row = mem_read(0xFFD4)
            log("Booted, A> seen")
            state = "run_test"
            wait_frames = 0
        elseif frame > FPS * 60 then
            log("TIMEOUT waiting for boot"); finish(false)
        end

    elseif state == "run_test" then
        if wait_frames == 0 then
            local cmd = string.format("SIOBBAUD %d\r", BAUD_IDX)
            manager.machine.natkeyboard:post(cmd)
            log("Typed: " .. cmd:gsub("\r", "\\r"))
        end
        wait_frames = wait_frames + 1

        -- Wait for "Ready" on screen → program has reprogrammed CTC+SIO
        if not trigger_sent and wait_frames > FPS and screen_contains("Ready") then
            log("Program ready, setting null_modem baud to " .. BAUD_MAME)
            set_baud(BAUD_MAME)
            -- Brief delay for baud rate to settle, then send trigger
            state = "send_trigger"
            wait_frames = 0
        elseif wait_frames > FPS * 30 then
            log("TIMEOUT waiting for Ready"); finish(false)
        end

    elseif state == "send_trigger" then
        wait_frames = wait_frames + 1
        if wait_frames > FPS / 2 then
            -- Send trigger
            local f = io.open("/tmp/siob_iobyte_trigger", "w")
            f:write("go\n")
            f:close()
            trigger_sent = true
            log("trigger sent")
            state = "wait_result"
            wait_frames = 0
        end

    elseif state == "wait_result" then
        wait_frames = wait_frames + 1
        -- Periodically log ring buffer state for debugging
        if wait_frames % (FPS * 5) == 0 then
            local space = manager.machine.devices[":maincpu"].spaces["program"]
            local rxhead = space:read_u8(0xed21)
            local rxtail = space:read_u8(0xed22)
            log(string.format("  rxhead=%d rxtail=%d (waiting %ds)",
                rxhead, rxtail, wait_frames / FPS))
        end
        if new_prompt() then
            log("Test complete")
            log(screen_text())
            if screen_contains(PASS_MARKER) then
                finish(true)
            elseif screen_contains(FAIL_MARKER) then
                finish(false)
            else
                log("No marker found"); finish(false)
            end
        elseif wait_frames > FPS * 60 then
            log("TIMEOUT waiting for result"); log(screen_text()); finish(false)
        end
    end
end)

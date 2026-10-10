-- SYSGEN serial install test (phase 2: PIP + LOAD + SYSGEN)
-- Assumes serial already configured to 19200 8N1 via CONFI (phase 1)
--
-- Flow:
--   1. Boot, PIP BIOS.HEX=RDR:[EH]
--   2. LOAD BIOS + BIOS.COM (checksum)
--   3. SYSGEN read A:, BIOS.COM (reload), SYSGEN write A:
--   4. Exit

local FPS = 50
local frame = 0
local done = false
local state = "boot"
local wait_frames = 0
local screens = {}

local function log(msg)
    screens[#screens + 1] = msg
    print("[serial] " .. msg)
end

local function mem_read(addr)
    return manager.machine.devices[":maincpu"].spaces["program"]:read_u8(addr)
end

local function screen_text()
    local lines = {}
    for row = 0, 24 do
        local line = ""
        for col = 0, 79 do
            local ch = mem_read(0xF800 + row * 80 + col)
            line = line .. (ch >= 0x20 and ch < 0x7F and string.char(ch) or " ")
        end
        lines[#lines + 1] = line:gsub("%s+$", "")
    end
    return table.concat(lines, "\n")
end

local function at_prompt()
    local curx = mem_read(0xFFD1); local cursy = mem_read(0xFFD4)
    if curx ~= 2 then return false end
    local r = 0xF800 + cursy * 80
    return mem_read(r) == 0x41 and mem_read(r+1) == 0x3E
end

local last_prompt_row = -1
local function new_prompt()
    local curx = mem_read(0xFFD1); local cursy = mem_read(0xFFD4)
    if curx ~= 2 then return false end
    local r = 0xF800 + cursy * 80
    if mem_read(r) ~= 0x41 or mem_read(r+1) ~= 0x3E then return false end
    if cursy ~= last_prompt_row then last_prompt_row = cursy; return true end
    return false
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

local prompt_gone = false

local function finish(success)
    log(success and "=== SUCCESS ===" or "=== FAILED ===")
    log(screen_text())
    local f = io.open("/tmp/sysgen_serial.txt", "w")
    for _, s in ipairs(screens) do f:write(s .. "\n\n") end
    f:close()
    done = true
    manager.machine:exit()
end

local function configure_serial()
    local ports = manager.machine.ioport.ports
    for tag, port in pairs(ports) do
        if tag:find("RS232_TXBAUD") or tag:find("RS232_RXBAUD") then
            for _, field in pairs(port.fields) do
                field.user_value = 0x09  -- RS232_BAUD_19200
            end
        end
        if tag:find("FLOW_CONTROL") then
            for _, field in pairs(port.fields) do
                if field.name:find("Flow Control") then
                    field.user_value = 0x01  -- RTS
                end
            end
        end
    end
    log("null_modem: 19200 8N1")
end

emu.register_frame_done(function()
    if done then return end
    frame = frame + 1
    if frame == 1 then configure_serial() end
    if frame > FPS * 600 then log("GLOBAL TIMEOUT"); finish(false); return end

    if state == "boot" then
        if at_prompt() then
            last_prompt_row = mem_read(0xFFD4)
            log("Booted, starting PIP")
            manager.machine.natkeyboard:post("PIP BIOS.HEX=RDR:[E]\r")
            state = "pip"; wait_frames = 0; prompt_gone = false
        elseif frame > FPS * 30 then
            log("TIMEOUT boot"); finish(false)
        end

    elseif state == "pip" then
        wait_frames = wait_frames + 1
        if not prompt_gone and not at_prompt() then
            prompt_gone = true
            local f = io.open("/tmp/sysgen_serial_trigger", "w")
            f:write("go\n"); f:close()
            log("PIP running, trigger sent")
        end
        if prompt_gone and new_prompt() then
            log("PIP complete")
            log(screen_text())
            state = "load"; wait_frames = 0
        elseif wait_frames > FPS * 120 then
            log("TIMEOUT PIP"); log(screen_text()); finish(false)
        end

    elseif state == "load" then
        if wait_frames == 0 then manager.machine.natkeyboard:post("LOAD BIOS\r") end
        wait_frames = wait_frames + 1
        if new_prompt() then
            log("LOAD complete"); log(screen_text())
            if screen_contains("INVALID") then log("LOAD failed"); finish(false); return end
            state = "run_bios1"; wait_frames = 0
        elseif wait_frames > FPS * 30 then log("TIMEOUT LOAD"); finish(false) end

    elseif state == "run_bios1" then
        if wait_frames == 0 then manager.machine.natkeyboard:post("BIOS\r") end
        wait_frames = wait_frames + 1
        if new_prompt() then
            if screen_contains("OK") then log("Checksum: OK")
            elseif screen_contains("FAIL") then log("Checksum: FAIL"); finish(false); return end
            state = "sg_read"; wait_frames = 0
        elseif wait_frames > FPS * 30 then log("TIMEOUT BIOS.COM"); finish(false) end

    elseif state == "sg_read" then
        if wait_frames == 0 then manager.machine.natkeyboard:post("SYSGEN\r") end
        wait_frames = wait_frames + 1
        if screen_contains("SOURCE DRIVE") then
            manager.machine.natkeyboard:post("A")
            state = "sg_confirm"; wait_frames = 0
        elseif wait_frames > FPS * 10 then log("TIMEOUT SOURCE"); finish(false) end

    elseif state == "sg_confirm" then
        wait_frames = wait_frames + 1
        if screen_contains("SOURCE ON") then
            manager.machine.natkeyboard:post("\r")
            state = "sg_read_wait"; wait_frames = 0
        elseif wait_frames > FPS * 5 then log("TIMEOUT SOURCE ON"); finish(false) end

    elseif state == "sg_read_wait" then
        wait_frames = wait_frames + 1
        if screen_contains("FUNCTION COMPLETE") then
            log("SYSGEN read complete")
            state = "sg_exit"; wait_frames = 0
        elseif wait_frames > FPS * 60 then log("TIMEOUT read"); finish(false) end

    elseif state == "sg_exit" then
        wait_frames = wait_frames + 1
        if screen_contains("DESTINATION") then
            manager.machine.natkeyboard:post("\r"); state = "run_bios2_wait"; wait_frames = 0
        elseif wait_frames > FPS * 5 then log("TIMEOUT DEST"); finish(false) end

    elseif state == "run_bios2_wait" then
        wait_frames = wait_frames + 1
        if new_prompt() then
            manager.machine.natkeyboard:post("BIOS\r"); state = "run_bios2"; wait_frames = 0
        elseif wait_frames > FPS * 30 then log("TIMEOUT prompt"); finish(false) end

    elseif state == "run_bios2" then
        wait_frames = wait_frames + 1
        if new_prompt() then
            if screen_contains("OK") then log("Checksum reload: OK") end
            state = "sg2_start"; wait_frames = 0
        elseif wait_frames > FPS * 10 then log("TIMEOUT BIOS 2"); finish(false) end

    elseif state == "sg2_start" then
        if wait_frames == 0 then manager.machine.natkeyboard:post("SYSGEN\r") end
        wait_frames = wait_frames + 1
        if screen_contains("SOURCE DRIVE") then
            manager.machine.natkeyboard:post("\r"); state = "sg2_dest"; wait_frames = 0
        elseif wait_frames > FPS * 10 then log("TIMEOUT SG2"); finish(false) end

    elseif state == "sg2_dest" then
        wait_frames = wait_frames + 1
        if screen_contains("DESTINATION") then
            manager.machine.natkeyboard:post("A"); state = "sg2_confirm"; wait_frames = 0
        elseif wait_frames > FPS * 5 then log("TIMEOUT DEST2"); finish(false) end

    elseif state == "sg2_confirm" then
        wait_frames = wait_frames + 1
        if screen_contains("DESTINATION ON") then
            manager.machine.natkeyboard:post("\r"); state = "sg2_write"; wait_frames = 0
        elseif wait_frames > FPS * 5 then log("TIMEOUT DESTON2"); finish(false) end

    elseif state == "sg2_write" then
        wait_frames = wait_frames + 1
        if screen_contains("FUNCTION COMPLETE") then
            log("SYSGEN write complete!"); finish(true)
        elseif wait_frames > FPS * 60 then log("TIMEOUT write"); finish(false) end
    end
end)

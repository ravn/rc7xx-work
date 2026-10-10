-- mame_siob_deploy_test.lua
--
-- BIOS deploy via dual serial ports:
--   SIO-B (bitb2): console — sends commands
--   SIO-A (bitb1): data — sends Intel HEX for PIP
--
-- Flow:
--   1. Boot with INITIAL_BANNER BIOS (e.g. sdcc), verify it
--   2. Trigger server to run PIP + HEX transfer + MLOAD + verify + SYSGEN
--   3. Wait for server "done" signal
--   4. Hard reset to boot with new BIOS (MFI disk is writable)
--   5. Verify EXPECTED_BANNER on CRT (e.g. clang)

local FPS = 50
local frame = 0
local done = false
local state = "boot"
local wait_frames = 0

local INITIAL_BANNER  = os.getenv("INITIAL_BANNER")  or "C-bios/sdcc"
local EXPECTED_BANNER = os.getenv("EXPECTED_BANNER") or "C-bios/clang"

local function log(msg) print("[deploy] " .. msg) end

local function mem_read(addr)
    local ok, val = pcall(function()
        return manager.machine.devices[":maincpu"].spaces["program"]:read_u8(addr)
    end)
    if ok then return val else return 0 end
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

local function file_exists(path)
    local f = io.open(path, "r")
    if f then f:close(); return true end
    return false
end

local function write_result(pass, reason)
    local f = io.open("/tmp/siob_deploy_result", "w")
    f:write(pass and "PASS\n" or "FAIL\n")
    f:write(reason .. "\n")
    f:write("--- CRT ---\n")
    f:write(screen_text() .. "\n")
    f:close()
end

local function finish(pass, reason)
    log(reason)
    log(pass and "=== PASS ===" or "=== FAIL ===")
    write_result(pass, reason)
    done = true
    manager.machine:exit()
end

emu.register_frame_done(function()
    if done then return end
    frame = frame + 1
    if frame > FPS * 900 then finish(false, "GLOBAL TIMEOUT"); return end

    if state == "boot" then
        if frame > FPS * 5 and screen_contains("Console also on serial port B") then
            -- Verify we booted with the INITIAL banner (e.g. sdcc)
            if not screen_contains(INITIAL_BANNER) then
                finish(false, "Initial boot has wrong banner — expected '" .. INITIAL_BANNER .. "'")
                return
            end
            log("Boot complete with " .. INITIAL_BANNER .. ", serial console active")
            local f = io.open("/tmp/siob_deploy_trigger", "w")
            f:write("go\n")
            f:close()
            log("Trigger sent to deploy server")
            state = "wait_deploy"
            wait_frames = 0
        elseif frame > FPS * 30 then
            finish(false, "TIMEOUT waiting for boot")
        end

    elseif state == "wait_deploy" then
        wait_frames = wait_frames + 1
        if wait_frames % (FPS * 10) == 0 then
            log(string.format("  waiting for deploy... frame=%d", wait_frames))
        end
        if file_exists("/tmp/siob_deploy_done") then
            log("Deploy server done — SYSGEN complete")
            log("Performing hard reset to boot with new BIOS...")
            state = "reset"
            wait_frames = 0
        elseif wait_frames > FPS * 600 then
            finish(false, "TIMEOUT waiting for deploy")
        end

    elseif state == "reset" then
        wait_frames = wait_frames + 1
        if wait_frames == FPS then
            manager.machine:hard_reset()
            log("Hard reset triggered")
            state = "verify"
            wait_frames = 0
        end

    elseif state == "verify" then
        wait_frames = wait_frames + 1
        if wait_frames > FPS * 5 and screen_contains(EXPECTED_BANNER) then
            finish(true, "Deploy verified: " .. INITIAL_BANNER .. " -> " .. EXPECTED_BANNER)
        elseif wait_frames > FPS * 30 then
            log("CRT after reset:")
            log(screen_text())
            finish(false, "Expected banner '" .. EXPECTED_BANNER .. "' not found after reset")
        end
    end
end)

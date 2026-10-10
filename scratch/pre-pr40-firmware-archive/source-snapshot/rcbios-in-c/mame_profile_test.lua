-- Instruction-level profiling via MAME debugger trace
-- Requires MAME debug build (-debug flag) and -debugscript to auto-start.
--
-- Runs ASM FILEX (untimed), then TYPE FILEX.PRN with full instruction trace.
-- Post-process the trace file with profile_trace.py to build a histogram.
--
-- Substitution variables (replaced by shell wrapper):
--   BIOS_LABEL  - label for this BIOS variant
--   MAP_FILE    - path to symbol map file (or "none")

local bios_label = "BIOS_LABEL"
local map_file = "MAP_FILE"

local frame = 0
local done = false
local state = "boot"
local prompt_left = false
local tracing = false

local commands = {
    {cmd = "ASM FILEX\r", trace = false},
    {cmd = "TYPE FILEX.PRN\r", trace = true},
}
local cmd_idx = 0
local screens = {}

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

local function dbg_cmd(cmd)
    local dbg = manager.machine.debugger
    if dbg then
        dbg:command(cmd)
    end
end

local function start_trace()
    dbg_cmd("trace /tmp/bios_trace.log,0")
    tracing = true
    print("=== Trace started: /tmp/bios_trace.log ===")
end

local function stop_trace()
    if tracing then
        dbg_cmd("trace off,0")
        tracing = false
        print("=== Trace stopped ===")
    end
end

local start_time = 0
local end_time = 0

local function get_seconds()
    return manager.machine.time:as_double()
end

emu.register_frame_done(function()
    if done then return end
    frame = frame + 1

    if state == "boot" then
        if at_prompt() then
            state = "post"
            cmd_idx = 0
        elseif frame > 50 * 120 then
            screens[#screens + 1] = "=== TIMEOUT waiting for boot ===\n" .. screen_text()
            done = true; os.exit(0)
        end

    elseif state == "post" then
        cmd_idx = cmd_idx + 1
        if cmd_idx > #commands then
            -- All done — write summary
            local f = io.open("/tmp/bios_profile_autotest.txt", "w")
            for _, s in ipairs(screens) do f:write(s .. "\n\n") end
            f:write(string.format("bios: %s\n", bios_label))
            f:write(string.format("map_file: %s\n", map_file))
            if end_time > start_time then
                local dt = end_time - start_time
                f:write(string.format("type_cycles: %.0f\n", dt * 4000000))
                f:write(string.format("type_time: %.6f\n", dt))
            end
            f:close()
            done = true; os.exit(0)
            return
        end
        local entry = commands[cmd_idx]
        manager.machine.natkeyboard:post(entry.cmd)
        prompt_left = false
        state = "typing"

    elseif state == "typing" then
        if not at_prompt() then
            prompt_left = true
        end
        if manager.machine.natkeyboard.empty and prompt_left then
            if commands[cmd_idx].trace then
                start_time = get_seconds()
                start_trace()
            end
            state = "execute"
        end

    elseif state == "execute" then
        if at_prompt() then
            if commands[cmd_idx].trace then
                stop_trace()
                end_time = get_seconds()
                local dt = end_time - start_time
                print(string.format("=== TYPE completed: %.0f cycles (%.3fs) ===", dt * 4000000, dt))
            end
            screens[#screens + 1] = string.format(
                "=== After: %s ===\n%s",
                commands[cmd_idx].cmd:gsub("\r", ""), screen_text()
            )
            state = "post"
        end
    end

    -- Global timeout: 10 minutes
    if frame > 50 * 600 then
        stop_trace()
        screens[#screens + 1] = "=== TIMEOUT ==="
        done = true; os.exit(0)
    end
end)

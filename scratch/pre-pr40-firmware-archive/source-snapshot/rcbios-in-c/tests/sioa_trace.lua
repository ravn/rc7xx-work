-- sioa_trace.lua -- trace SIO-A (IO 0x08 data, 0x0A ctrl) via read/write taps.
--
-- Parameters (env vars):
--   SIOA_TRACE_LOG   path to write trace CSV (default /tmp/sioa_trace.csv)
--   SIOA_TRACE_CMD   command string to type at A> prompt (default "PUNCH\r")
--   SIOA_TRACE_WAIT  frames to wait for output after typing (default 300)
--
-- Output file format (one line per CPU access to SIO-A):
--   frame,pc,op,port,value
-- where op is R or W.

local LOG_PATH = os.getenv("SIOA_TRACE_LOG")  or "/tmp/sioa_trace.csv"
local CMD      = os.getenv("SIOA_TRACE_CMD")  or "PUNCH\r"
local WAIT_END = tonumber(os.getenv("SIOA_TRACE_WAIT") or "300")

local FPS = 50
local frame = 0
local done = false
local state = "wait_prompt"
local state_since = 0
local key_queue = CMD
local key_pos = 1
local key_delay = 0

-- BSS addresses: read from env (extracted from bios.elf at test-script time).
-- If unset, fall back to last-known-good constants (will break if BIOS resized).
local KBHEAD    = tonumber(os.getenv("KBHEAD_ADDR") or "") or 0xECEE
local KBBUF     = tonumber(os.getenv("KBBUF_ADDR")  or "") or 0xEF3E
local INCONV    = 0xF700

local io_space, prog_space
local log_f = io.open(LOG_PATH, "w")
log_f:write("frame,pc,op,port,value\n")

local function cpu_pc()
    return manager.machine.devices[":maincpu"].state["PC"].value
end

local function log(op, port, value)
    log_f:write(string.format("%d,0x%04x,%s,0x%02x,0x%02x\n",
        frame, cpu_pc(), op, port, value))
end

local function screen_find(s, str)
    local b = {string.byte(str, 1, #str)}
    for addr = 0xF800, 0xF800 + 2000 - #b do
        local m = true
        for i = 1, #b do
            if s:read_u8(addr + i - 1) ~= b[i] then m = false; break end
        end
        if m then return true end
    end
    return false
end

local function dump_screen(tag)
    log_f:write(string.format("# screen (%s):\n", tag))
    for row = 0, 24 do
        local line = ""
        for col = 0, 79 do
            local ch = prog_space:read_u8(0xF800 + row * 80 + col)
            line = line .. (ch >= 0x20 and ch < 0x7F and string.char(ch) or ".")
        end
        line = line:gsub("%s+$", "")
        if #line > 0 then log_f:write(string.format("# %2d: %s\n", row, line)) end
    end
    -- Also dump the bios_echo_big result block (tag 'R!@#' at 0x180)
    local t = ""
    for i = 0, 3 do
        local b = prog_space:read_u8(0x180 + i)
        t = t .. string.char(b)
    end
    if t == "R!@#" then
        local lo = prog_space:read_u8(0x184)
        local hi = prog_space:read_u8(0x185)
        local mm = prog_space:read_u8(0x186)
        local st = prog_space:read_u8(0x187)
        log_f:write(string.format("# result: count=%d mismatch=%d status=0x%02X\n",
            hi * 256 + lo, mm, st))
    end
end

local tap_r, tap_w  -- keep strong references or the tap is garbage-collected

emu.register_frame_done(function()
    if done then return end
    frame = frame + 1

    if not io_space then
        io_space   = manager.machine.devices[":maincpu"].spaces["io"]
        prog_space = manager.machine.devices[":maincpu"].spaces["program"]
        tap_r = io_space:install_read_tap(0x08, 0x0B, "sioa_r",
            function(offset, data, mask) log("R", offset, data) end)
        tap_w = io_space:install_write_tap(0x08, 0x0B, "sioa_w",
            function(offset, data, mask) log("W", offset, data) end)
        print("[sioa_trace] taps installed on IO 0x08-0x0B")
    end

    if state == "wait_prompt" then
        if screen_find(prog_space, "A>") then
            state = "settle"; state_since = frame
        elseif frame > FPS * 25 then
            dump_screen("boot timeout")
            done = true; manager.machine:exit()
        end
        return
    end

    if state == "settle" then
        if frame - state_since > 50 then
            state = "typing"; key_pos = 1; key_delay = 0
        end
        return
    end

    if state == "typing" then
        if key_pos > #key_queue then
            state = "wait_output"; state_since = frame
            log_f:write("# -- command typed --\n")
            return
        end
        if key_delay > 0 then key_delay = key_delay - 1; return end
        local ch = string.byte(key_queue, key_pos)
        prog_space:write_u8(INCONV + ch, ch)
        local head = prog_space:read_u8(KBHEAD)
        prog_space:write_u8(KBBUF + head, ch)
        prog_space:write_u8(KBHEAD, (head + 1) % 16)
        key_pos = key_pos + 1
        key_delay = 3
        return
    end

    if state == "wait_output" then
        if frame - state_since > WAIT_END then
            dump_screen("after command")
            log_f:close()
            done = true; manager.machine:exit()
        end
    end
end)

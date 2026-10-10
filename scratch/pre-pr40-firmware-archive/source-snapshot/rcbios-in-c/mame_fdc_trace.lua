-- Trace BIOS READ calls via debug buffer in BSS
-- dbg_idx at 0xDFE1, dbg_buf at 0xDFE2 (128 bytes, 32 entries × 4)
local frame = 0
local done = false
local log = {}
local phase = "wait_boot"
local key_queue = ""
local key_pos = 0
local key_delay = 0
local a_prompt_count = 0
local cmd_idx = 0
local wait_until_frame = 0
local commands = {"DIR\r", "TYPE DUMP.ASM\r"}

local DBG_IDX = 0xDFE1
local DBG_BUF = 0xDFE2

local function logf(fmt, ...)
    log[#log + 1] = string.format(fmt, ...)
end

local function screen_find(space, str)
    local bytes = {string.byte(str, 1, #str)}
    for addr = 0xF800, 0xF800 + 2000 - #str do
        local match = true
        for i = 1, #bytes do
            if space:read_u8(addr + i - 1) ~= bytes[i] then
                match = false
                break
            end
        end
        if match then return true end
    end
    return false
end

local function inject_key(space, ch)
    local head = space:read_u8(0xDC33)
    space:write_u8(0xDC23 + head, ch)
    space:write_u8(0xDC33, (head + 1) % 16)
end

local function hexdump(space, addr, len)
    local s = ""
    for i = 0, len - 1 do
        s = s .. string.format("%02X ", space:read_u8(addr + i))
    end
    return s
end

local function dump_screen(space)
    logf("\n=== Screen ===")
    for row = 0, 24 do
        local line = ""
        for col = 0, 79 do
            local b = space:read_u8(0xF800 + row * 80 + col)
            if b >= 0x20 and b < 0x7F then
                line = line .. string.char(b)
            else
                line = line .. "."
            end
        end
        line = line:gsub("%.+$", "")
        if #line > 0 then logf("R%02d: %s", row, line) end
    end
end

local function dump_trace(space, label)
    logf("\n=== %s ===", label)
    local idx = space:read_u8(DBG_IDX)
    local entries = math.floor(idx / 4)
    logf("Trace: %d bytes written = %d READ calls", idx, entries)
    for i = 0, math.min(entries, 32) - 1 do
        local base = DBG_BUF + i * 4
        local trk = space:read_u8(base + 0)
        local sec = space:read_u8(base + 1)
        local dma_lo = space:read_u8(base + 2)
        local dma_hi = space:read_u8(base + 3)
        local dma = dma_lo + dma_hi * 256
        logf("  [%02d] trk=%d sec=%d dma=%04X", i, trk, sec, dma)
    end
    -- Dump DMA buffer and DIRBF
    logf("DMA buf 0080: %s", hexdump(space, 0x0080, 16))
    logf("DIRBF (DE35): %s", hexdump(space, 0xDE35, 128))
    -- Dump FCB at 005C
    logf("FCB at 005C: %s", hexdump(space, 0x005C, 36))
    -- Dump erflag
    -- erflag address... let me just read from a known safe spot
end

local function save_and_exit()
    local space = manager.machine.devices[":maincpu"].spaces["program"]
    local cpu = manager.machine.devices[":maincpu"]
    logf("\nFinal state: PC=%04X SP=%04X", cpu.state["PC"].value, cpu.state["SP"].value)
    dump_screen(space)
    local f = io.open("/tmp/fdc_trace.txt", "w")
    for i = 1, #log do f:write(log[i] .. "\n") end
    f:close()
    done = true
    os.exit(0)
end

emu.register_frame_done(function()
    if done then return end
    frame = frame + 1

    local space = manager.machine.devices[":maincpu"].spaces["program"]

    if phase == "wait_boot" then
        if frame > wait_until_frame and screen_find(space, "A>") then
            a_prompt_count = a_prompt_count + 1
            logf("A> #%d at frame %d", a_prompt_count, frame)

            dump_trace(space, string.format("Trace at A> #%d", a_prompt_count))

            -- Reset trace index for next command
            space:write_u8(DBG_IDX, 0)

            cmd_idx = cmd_idx + 1
            if cmd_idx <= #commands then
                phase = "typing"
                key_queue = commands[cmd_idx]
                key_pos = 0
                key_delay = 30
                logf("Will type: %s", key_queue:gsub("\r", "<CR>"))
            else
                logf("All commands done")
                save_and_exit()
                return
            end
        end
        if frame > 50 * 600 then
            logf("TIMEOUT at frame %d", frame)
            save_and_exit()
        end
        return
    end

    if phase == "typing" then
        if key_delay > 0 then
            key_delay = key_delay - 1
        elseif key_pos < #key_queue then
            key_pos = key_pos + 1
            inject_key(space, string.byte(key_queue, key_pos))
            key_delay = 3
        else
            phase = "wait_boot"
            wait_until_frame = frame + 2000
            logf("Command sent at frame %d, waiting until frame %d", frame, wait_until_frame)
        end
        return
    end
end)

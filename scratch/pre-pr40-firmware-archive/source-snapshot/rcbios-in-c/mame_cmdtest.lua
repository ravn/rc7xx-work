-- MAME automated test: wait for A> prompt, type commands, capture output.
-- Uses PIO port A (keyboard input) to inject keystrokes.

local frame = 0
local done = false
local max_frames = 50 * 120
local check_started = false

-- Command queue: each entry is {delay_frames, keys}
-- delay_frames = wait this many frames after previous command before typing
local commands = {
    {100, "DIR\r"},          -- wait 2 sec after boot, type DIR
    {200, "ASM DUMP\r"},    -- wait 4 sec after DIR, type ASM DUMP
}
local cmd_idx = 0
local cmd_timer = 0
local key_queue = ""
local key_pos = 0
local key_delay = 0       -- frames between keystrokes

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

local function dump_screen(f, space)
    for row = 0, 24 do
        local line = ""
        for col = 0, 79 do
            local ch = space:read_u8(0xF800 + row * 80 + col)
            if ch >= 0x20 and ch < 0x7F then
                line = line .. string.char(ch)
            else
                line = line .. " "
            end
        end
        -- trim trailing spaces
        line = line:gsub("%s+$", "")
        if #line > 0 or row < 3 then
            f:write(string.format("%2d: %s\n", row, line))
        end
    end
end

local waiting_for_prompt = false
local prompt_wait_start = 0

emu.register_frame_done(function()
    if done then return end
    frame = frame + 1

    local space = manager.machine.devices[":maincpu"].spaces["program"]

    -- Wait for OUTCON initialization
    if not check_started then
        if space:read_u8(0xF6C1) == 0x41 then
            check_started = true
            waiting_for_prompt = true
            prompt_wait_start = frame
        end
        if frame > 50 * 15 then
            local f = io.open("/tmp/diag.txt", "w")
            f:write("ERROR: OUTCON never initialized\n")
            f:close()
            done = true
            os.exit(0)
        end
        return
    end

    -- Wait for A> prompt before starting commands
    if waiting_for_prompt then
        if screen_find(space, "A>") then
            waiting_for_prompt = false
            cmd_idx = 0
            cmd_timer = 0
        elseif frame - prompt_wait_start > 50 * 30 then
            local f = io.open("/tmp/diag.txt", "w")
            f:write("ERROR: A> prompt never appeared\n\n")
            dump_screen(f, space)
            f:close()
            done = true
            os.exit(0)
        end
        return
    end

    -- Inject keystrokes (one per frame via PIO port A)
    if key_pos > 0 and key_pos <= #key_queue then
        if key_delay > 0 then
            key_delay = key_delay - 1
        else
            local ch = string.byte(key_queue, key_pos)
            -- Write to PIO port A data to simulate keystroke
            -- On RC702, keyboard sends scan codes via PIO ch.A
            -- The BIOS reads from PIO port and stores in ring buffer
            space:write_u8(0xF700 + ch, ch)  -- ensure INCONV maps correctly
            -- Actually need to trigger PIO interrupt with the key data
            -- Let me just write to the keyboard ring buffer directly
            local kbhead_addr = 0xDC33  -- from map file
            local kbtail_addr = 0xDC34
            local kbbuf_addr = 0xDC23   -- 16-byte ring buffer

            local head = space:read_u8(kbhead_addr)
            space:write_u8(kbbuf_addr + head, ch)
            head = (head + 1) % 16
            space:write_u8(kbhead_addr, head)

            key_pos = key_pos + 1
            key_delay = 3  -- 3 frames between keystrokes
        end
        return
    end

    -- Advance to next command
    if cmd_timer > 0 then
        cmd_timer = cmd_timer - 1
        return
    end

    cmd_idx = cmd_idx + 1
    if cmd_idx <= #commands then
        cmd_timer = commands[cmd_idx][1]
        key_queue = commands[cmd_idx][2]
        key_pos = 1
        key_delay = 0
        return
    end

    -- All commands sent, wait a bit then dump screen
    if cmd_idx == #commands + 1 then
        cmd_timer = 3000  -- wait 60 seconds for ASM output
        cmd_idx = cmd_idx + 1
        return
    end

    -- Done — dump final screen and keyboard state
    local f = io.open("/tmp/diag.txt", "w")
    f:write("=== Screen after commands ===\n\n")
    dump_screen(f, space)
    f:write(string.format("\nkbhead=%02X kbtail=%02X\n",
        space:read_u8(0xDC33), space:read_u8(0xDC34)))
    f:write("kbbuf:")
    for i = 0, 15 do
        f:write(string.format(" %02X", space:read_u8(0xDC23 + i)))
    end
    f:write("\n")
    f:write("INCONV[0D,44,49,52]:")
    f:write(string.format(" %02X %02X %02X %02X\n",
        space:read_u8(0xF70D), space:read_u8(0xF744),
        space:read_u8(0xF749), space:read_u8(0xF752)))
    f:close()
    done = true
    os.exit(0)
end)

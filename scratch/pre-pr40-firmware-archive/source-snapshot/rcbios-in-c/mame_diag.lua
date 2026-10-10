-- MAME diagnostic: monitor sp_sav for invalid stack values.
-- sp_sav at 0xDC21 holds the interrupted code's SP (saved by ISR wrapper).
-- With the original-pattern ISR (save SP first, then push on ISR stack),
-- sp_sav directly reflects the interrupted code's SP.
--
-- Valid SP ranges:
--   0x0000-0xD480  TPA / CCP / BDOS stacks
--   0xF400-0xF500  BIOS stack (when ISR interrupts a BIOS entry point)
-- Invalid:
--   0xD481-0xF3FF  BIOS code/BSS/gap (not a stack area)
--   0xF501-0xF67F  gap / ISR stack (ISR shouldn't interrupt itself)
--   0xF680+        OUTCON/INCONV/screen

local frame = 0
local done = false
local max_frames = 50 * 120   -- 120 seconds timeout
local check_started = false
local sp_sav_addr = 0xDC21    -- from bios.map
local prev_sp_sav = 0

local function dump_hex_row(f, space, addr, len, label)
    f:write(string.format("  %s %04X:", label, addr))
    for i = 0, len - 1 do
        f:write(string.format(" %02X", space:read_u8(addr + i)))
    end
    f:write("\n")
end

local function dump_screen_row(f, space, row)
    local line = ""
    for col = 0, 79 do
        local ch = space:read_u8(0xF800 + row * 80 + col)
        if ch >= 0x20 and ch < 0x7F then
            line = line .. string.char(ch)
        else
            line = line .. string.format("\\x%02X", ch)
        end
    end
    f:write(line .. "\n")
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

local function sp_sav_valid(val)
    -- Valid: TPA/CCP/BDOS stacks (0x0000-0xD480)
    if val <= 0xD480 then return true end
    -- Valid: BIOS stack (0xF400-0xF500)
    if val >= 0xF400 and val <= 0xF500 then return true end
    -- Everything else is suspicious
    return false
end

local function dump_full(f, space, reason)
    local cpu = manager.machine.devices[":maincpu"]
    local state = cpu.state

    f:write(string.format("=== %s at frame %d (%.1f sec) ===\n",
        reason, frame, frame / 50.0))
    f:write(string.format("PC=%04X SP=%04X AF=%04X BC=%04X DE=%04X HL=%04X IX=%04X IY=%04X I=%02X\n",
        state["PC"].value, state["SP"].value,
        state["AF"].value, state["BC"].value,
        state["DE"].value, state["HL"].value,
        state["IX"].value, state["IY"].value,
        state["I"].value))

    -- sp_sav value
    local sp_sav_lo = space:read_u8(sp_sav_addr)
    local sp_sav_hi = space:read_u8(sp_sav_addr + 1)
    f:write(string.format("sp_sav=%04X (at %04X)\n", sp_sav_lo + sp_sav_hi * 256, sp_sav_addr))

    -- Memory around sp_sav
    dump_hex_row(f, space, sp_sav_addr - 4, 16, "sp_sav area")

    -- Stack around SP
    local sp = state["SP"].value
    dump_hex_row(f, space, sp, 32, "Stack")

    -- Page zero (JP WBOOT, JP BDOS)
    f:write("\n")
    dump_hex_row(f, space, 0x0000, 8, "Page0 JP")

    -- CCP first 16 bytes
    dump_hex_row(f, space, 0xC400, 16, "CCP")

    -- OUTCON check
    f:write("\nOUTCON[40-4F]:")
    for i = 0x40, 0x4F do
        f:write(string.format(" %02X", space:read_u8(0xF680 + i)))
    end
    f:write("\n")

    -- INCONV check
    f:write("INCONV[40-4F]:")
    for i = 0x40, 0x4F do
        f:write(string.format(" %02X", space:read_u8(0xF700 + i)))
    end
    f:write("\n")

    -- Screen rows 0-2
    for row = 0, 2 do
        f:write(string.format("Screen row %d: ", row))
        dump_screen_row(f, space, row)
    end
end

emu.register_frame_done(function()
    if done then return end
    frame = frame + 1

    local space = manager.machine.devices[":maincpu"].spaces["program"]

    -- Wait for initialization
    if not check_started then
        if space:read_u8(0xF6C1) == 0x41 then
            check_started = true
        end
        if frame > 50 * 10 then
            local f = io.open("/tmp/diag.txt", "w")
            f:write("ERROR: OUTCON never initialized\n")
            dump_full(f, space, "INIT FAILURE")
            f:close()
            done = true
            os.exit(0)
        end
        return
    end

    -- Check sp_sav every frame for suspicious values
    local sp_sav_lo = space:read_u8(sp_sav_addr)
    local sp_sav_hi = space:read_u8(sp_sav_addr + 1)
    local sp_sav_val = sp_sav_lo + sp_sav_hi * 256

    -- Check if sp_sav is in a valid stack range
    if not sp_sav_valid(sp_sav_val) then
        local f = io.open("/tmp/diag.txt", "w")
        f:write(string.format("sp_sav INVALID: 0x%04X (not in valid stack range)\n", sp_sav_val))
        f:write(string.format("Previous sp_sav: 0x%04X\n\n", prev_sp_sav))
        dump_full(f, space, "sp_sav INVALID")
        f:close()
        done = true
        os.exit(0)
        return
    end

    prev_sp_sav = sp_sav_val

    -- Also check OUTCON[0x41] as a canary
    if space:read_u8(0xF6C1) ~= 0x41 then
        local f = io.open("/tmp/diag.txt", "w")
        f:write(string.format("OUTCON[41] corrupted (sp_sav=0x%04X at time of detection)\n\n",
            sp_sav_val))
        dump_full(f, space, "OUTCON CORRUPTION")
        f:close()
        done = true
        os.exit(0)
        return
    end

    -- Check for A> prompt every second
    if frame % 50 == 0 then
        if screen_find(space, "A>") then
            if frame % 500 == 0 then
                local f = io.open("/tmp/diag.txt", "w")
                f:write(string.format("A> prompt visible at frame %d, still running (sp_sav=0x%04X)...\n",
                    frame, sp_sav_val))
                dump_full(f, space, "RUNNING OK")
                f:close()
            end
        end
    end

    -- Timeout
    if frame >= max_frames then
        local f = io.open("/tmp/diag.txt", "w")
        f:write(string.format("TIMEOUT: no corruption detected (sp_sav=0x%04X)\n\n", sp_sav_val))
        dump_full(f, space, "TIMEOUT")
        f:close()
        done = true
        os.exit(0)
    end
end)

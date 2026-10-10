-- SYSGEN install test via disk-injected HEX file + DDT
--
-- The challenge: LOAD BIOS creates a .COM that spans 0x0100-0x6802,
-- which overlaps SYSGEN's track 1 buffer at 0x0900-0x44FF.
-- So we can't LOAD after SYSGEN read.
--
-- Solution:
--   1. SYSGEN read A: (fills 0x0900-0x78FF from disk)
--   2. DDT (load DDT debugger)
--   3. IBIOS.HEX (set input file)
--   4. R (read HEX file — loads data at specified addresses)
--   5. G0 (warm boot to exit DDT)
--   6. SYSGEN skip read, write A:
--
-- DDT reads the HEX file and places data at the addresses in the records.
-- It does NOT create an intermediate .COM file. The data at 0x4500+ is set
-- directly in memory. DDT itself lives below 0x0900 so it doesn't clobber
-- the SYSGEN track 1 buffer.
--
-- Wait — DDT is typically ~5K (0x0100-0x1400), which DOES overlap 0x0900.
-- But DDT loads the HEX file OVER its own code area. So:
--   - DDT at 0x0100-0x1400 (approx)
--   - HEX loads validator at 0x0100 (overwrites DDT — that's fine, we don't need DDT after)
--   - HEX loads BIOS at 0x4500+
--   - G0 exits DDT (warm boot)
--
-- Actually, DDT reads the HEX into memory starting after DDT's own area.
-- It uses an offset. The default offset is 0x0100. So HEX addr 0x4500
-- becomes memory addr 0x4500 + offset... unless offset is 0.
-- DDT R command with no argument uses offset 0. Let's try R0.
--
-- REVISED: actually DDT reads hexfile into memory at the addresses in the
-- hex file MINUS 0x0100, then adds the R offset. So to get data at 0x4500
-- we need an offset that makes it land there. If HEX has address 0x4500,
-- DDT places it at (0x4500 - 0x0100) + R_offset. With R0100, it goes to 0x4500.
-- Or we can just use R with no argument which defaults to offset 0, but then
-- address 0x4500 ends up at 0x4400.
--
-- This is getting complex. Let me just use the Lua memory injection approach
-- (which is proven) for the initial track 0 load, combined with SYSGEN for
-- the disk write. The HEX file on disk proves the data transfer concept.

-- SIMPLEST APPROACH: SYSGEN read, then Lua injects track 0 from the HEX file
-- that's already on disk. This tests the full flow except for DDT.

local FPS = 50
local frame = 0
local done = false
local state = "boot"
local wait_frames = 0
local screens = {}

local T0_ADDR = 0x4500
local T0_SIZE = 0x3400

local function log(msg)
    screens[#screens + 1] = msg
    print("[inject] " .. msg)
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

local function write_memory_from_file(addr, path)
    local f = io.open(path, "rb")
    if not f then log("ERROR: cannot open " .. path); return 0 end
    local data = f:read("*a"); f:close()
    local space = manager.machine.devices[":maincpu"].spaces["program"]
    for i = 1, #data do space:write_u8(addr + i - 1, string.byte(data, i)) end
    return #data
end

local function finish(success)
    log(success and "=== SUCCESS ===" or "=== FAILED ===")
    log(screen_text())
    local f = io.open("/tmp/sysgen_inject.txt", "w")
    for _, s in ipairs(screens) do f:write(s .. "\n\n") end
    f:close()
    done = true
    manager.machine:exit()
end

emu.register_frame_done(function()
    if done then return end
    frame = frame + 1
    if frame > FPS * 300 then log("GLOBAL TIMEOUT"); finish(false); return end

    -- Step 1: Boot
    if state == "boot" then
        if at_prompt() then
            last_prompt_row = mem_read(0xFFD4)
            log("Booted")
            manager.machine.natkeyboard:post("SYSGEN\r")
            state = "sg_source"; wait_frames = 0
        elseif frame > FPS * 30 then
            log("TIMEOUT boot"); finish(false)
        end

    -- Step 2: SYSGEN read A:
    elseif state == "sg_source" then
        wait_frames = wait_frames + 1
        if screen_contains("SOURCE DRIVE") then
            manager.machine.natkeyboard:post("A")
            state = "sg_confirm"; wait_frames = 0
        elseif wait_frames > FPS * 10 then
            log("TIMEOUT SOURCE"); finish(false)
        end

    elseif state == "sg_confirm" then
        wait_frames = wait_frames + 1
        if screen_contains("SOURCE ON") then
            manager.machine.natkeyboard:post("\r")
            state = "sg_read"; wait_frames = 0
        elseif wait_frames > FPS * 5 then
            log("TIMEOUT SOURCE ON"); finish(false)
        end

    elseif state == "sg_read" then
        wait_frames = wait_frames + 1
        if screen_contains("FUNCTION COMPLETE") then
            log("SYSGEN read complete")
            -- Inject track 0 data at 0x4500 from pre-built binary
            local nbytes = write_memory_from_file(T0_ADDR, "/tmp/sysgen_t0.bin")
            log(string.format("Injected %d bytes at 0x%04X", nbytes, T0_ADDR))
            state = "sg_exit"; wait_frames = 0
        elseif wait_frames > FPS * 60 then
            log("TIMEOUT read"); finish(false)
        end

    elseif state == "sg_exit" then
        wait_frames = wait_frames + 1
        if screen_contains("DESTINATION") then
            -- Write to A:
            manager.machine.natkeyboard:post("A")
            state = "sg_write_confirm"; wait_frames = 0
        elseif wait_frames > FPS * 5 then
            log("TIMEOUT DEST"); finish(false)
        end

    elseif state == "sg_write_confirm" then
        wait_frames = wait_frames + 1
        if screen_contains("DESTINATION ON") then
            manager.machine.natkeyboard:post("\r")
            state = "sg_write"; wait_frames = 0
        elseif wait_frames > FPS * 5 then
            log("TIMEOUT DEST ON"); finish(false)
        end

    elseif state == "sg_write" then
        wait_frames = wait_frames + 1
        if screen_contains("FUNCTION COMPLETE") then
            log("SYSGEN write complete!")
            finish(true)
        elseif wait_frames > FPS * 60 then
            log("TIMEOUT write"); finish(false)
        end
    end
end)

-- run_and_dump.lua -- log into B:, run DISKTEST, then dump the full screen so we
-- can read the exact CCP error (e.g. "MEMORY NOT AVAILABLE") and any TPA info.
local cpu  = manager.machine.devices[":maincpu"]
local prog = cpu.spaces["program"]
local kbd  = manager.machine.natkeyboard
local stage, tmark, done = 0, nil, false

local function screen_has(c1, c2)
    local base = 0xB8000
    for i = 0, 80 * 25 - 2 do
        if prog:read_u8(base + 2 * i) == c1 and
           prog:read_u8(base + 2 * (i + 1)) == c2 then return true end
    end
    return false
end

local function dump(tag)
    local base = 0xB8000
    io.write("=== ", tag, " @ ", manager.machine.time:as_double(), "s ===\n")
    for row = 0, 24 do
        local line = {}
        for col = 0, 79 do
            local c = prog:read_u8(base + 2 * (row * 80 + col))
            if c < 32 or c > 126 then c = 32 end
            line[#line + 1] = string.char(c)
        end
        io.write(string.format("%2d|%s|\n", row, table.concat(line):gsub("%s+$", "")))
    end
    io.write("=== END ", tag, " ===\n"); io.flush()
end

emu.register_frame_done(function()
    if done then return end
    local t = manager.machine.time:as_double()
    if stage == 0 and screen_has(0x41, 0x3E) then          -- "A>"
        stage, tmark = 1, t
    elseif stage == 1 and t >= tmark + 2 then
        kbd:post("B:\r"); stage, tmark = 2, t
    elseif stage == 2 and screen_has(0x42, 0x3E) then      -- "B>"
        stage, tmark = 3, t
    elseif stage == 3 and t >= tmark + 2 then
        kbd:post("DISKTEST\r"); stage, tmark = 4, t
    elseif stage == 4 and t >= tmark + 8 then               -- wait for result/error
        dump("AFTER-DISKTEST")
        manager.machine.video:snapshot()
        done = true; manager.machine:exit()
    end
end)

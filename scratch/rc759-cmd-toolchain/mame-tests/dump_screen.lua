-- dump_screen.lua -- dump the full 80x25 CGA text page at MAME_DUMP_AT seconds
-- and exit. Used to read the CP/M-86 sign-on banner (reported memory size).
local dump_at = tonumber(os.getenv("MAME_DUMP_AT") or "20") or 20
local cpu  = manager.machine.devices[":maincpu"]
local prog = cpu.spaces["program"]
local done = false

local function dump()
    local base = 0xB8000
    io.write("=== SCREEN DUMP @ ", manager.machine.time:as_double(), "s ===\n")
    for row = 0, 24 do
        local line = {}
        for col = 0, 79 do
            local c = prog:read_u8(base + 2 * (row * 80 + col))
            if c < 32 or c > 126 then c = 32 end
            line[#line + 1] = string.char(c)
        end
        io.write(string.format("%2d|%s|\n", row, table.concat(line):gsub("%s+$", "")))
    end
    -- IBM BIOS data area: 0040:0013 (phys 0x413) = usable memory size in KB
    -- (word, set by POST from DIP switches); 0040:0010 (phys 0x410) = equipment
    local memkb = prog:read_u8(0x413) + 256 * prog:read_u8(0x414)
    local equip = prog:read_u8(0x410) + 256 * prog:read_u8(0x411)
    io.write(string.format("BIOS 0040:0013 mem-size = %d KB (0x%04x)\n", memkb, memkb))
    io.write(string.format("BIOS 0040:0010 equip    = 0x%04x\n", equip))
    io.write("=== END DUMP ===\n")
    io.flush()
end

emu.register_frame_done(function()
    if done then return end
    if manager.machine.time:as_double() >= dump_at then
        done = true
        dump()
        manager.machine.video:snapshot()
        manager.machine:exit()
    end
end)

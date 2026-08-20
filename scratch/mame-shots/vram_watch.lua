-- vram_watch.lua -- answer "is the 82730 font/pixel RAM (m_vram, guest phys
-- 0xD0000-0xD7FFF, mirror 0xD8000) modified over time?". Install a write tap on
-- the whole 0xD0000-0xDFFFF window: log every write (addr, value, CPU CS:IP that
-- did it). Also dump the font region every 15 s to font_<elapsed>.bin so we can
-- diff clean vs garbage frames, and snapshot every 20 s.
local cpu   = manager.machine.devices[":maincpu"]
local prog  = cpu.spaces["program"]
local OUT   = "/Users/ravn/z80/scratch/mame-shots/"
local start = os.time()
local t_dump, t_snap = 0, 0
local wlog  = io.open(OUT .. "vram_writes.txt", "w")
local nwr   = 0

local function pc()
    local ok1, cs = pcall(function() return cpu.state["CS"].value end)
    local ok2, ip = pcall(function() return cpu.state["IP"].value end)
    return (ok1 and cs or 0) % 0x10000, (ok2 and ip or 0) % 0x10000
end

local ok, err = pcall(function()
    prog:install_write_tap(0xD0000, 0xDFFFF, "vramtap", function(offset, data, mask)
        nwr = nwr + 1
        if nwr <= 4000 then
            local cs, ip = pc()
            local el = os.time() - start
            wlog:write(string.format("%4ds  %06X <= %04X  mask=%04X  by %04X:%04X\n",
                el, offset, data % 0x10000, mask % 0x10000, cs, ip))
            wlog:flush()
        end
    end)
end)
if ok then print("VRAM write-tap installed on 0xD0000-0xDFFFF")
else print("VRAM tap FAILED: " .. tostring(err)) end

local function dump_font(tag)
    local mf = io.open(OUT .. "font_" .. tag .. ".bin", "wb")
    local buf = {}
    for a = 0xD0000, 0xD1FFF do
        buf[#buf + 1] = string.char(prog:read_u8(a))
        if #buf == 4096 then mf:write(table.concat(buf)); buf = {} end
    end
    if #buf > 0 then mf:write(table.concat(buf)) end
    mf:close()
end

emu.register_frame_done(function()
    local now = os.time()
    if now - t_dump >= 15 then t_dump = now; dump_font(tostring(now - start)) end
    if now - t_snap >= 20 then t_snap = now; manager.machine.video:snapshot() end
end)

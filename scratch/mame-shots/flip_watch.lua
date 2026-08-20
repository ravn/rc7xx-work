-- flip_watch.lua -- the top-row garbage flips in a SINGLE frame at ~15 minutes
-- of EMULATED time. Capture what changes on that frame. Emulated time via
-- machine.time:as_double(). Write taps on the display-list region (0x18000-
-- 0x1BFFF; the once-per-second clock update proves the tap works) and the font
-- RAM (0xD0000-0xD7FFF). Sample CS:IP each second (idle loop sits at
-- 06FA:5AD4 -- if a screen-blank routine fires the guest leaves it). Snapshot
-- every ~20 emulated s and dump display+font every ~30 emulated s.
local cpu   = manager.machine.devices[":maincpu"]
local prog  = cpu.spaces["program"]
local OUT   = "/Users/ravn/z80/scratch/mame-shots/"
local mt    = function() return manager.machine.time:as_double() end
local wlog  = io.open(OUT .. "flip_writes.txt", "w")
local ilog  = io.open(OUT .. "flip_ip.txt", "w")
local ndl, nft = 0, 0
local last_ip_s, t_ip, t_snap, t_dump = "", -1, -1, -1

local function reg(n) local ok,v = pcall(function() return cpu.state[n].value end); return ok and v or -1 end

local function tap(lo, hi, label, cap)
    pcall(function()
        prog:install_write_tap(lo, hi, label, function(off, data, mask)
            if label == "dl" then ndl = ndl + 1; if ndl > cap then return end
            else nft = nft + 1; if nft > cap then return end end
            wlog:write(string.format("%9.3f %s %06X <= %04X m=%04X by %04X:%04X\n",
                mt(), label, off, data % 0x10000, mask % 0x10000,
                reg("CS") % 0x10000, reg("IP") % 0x10000)); wlog:flush()
        end)
    end)
end
tap(0x18000, 0x1BFFF, "dl", 200000)
tap(0xD0000, 0xD7FFF, "ft", 200000)

local function dump(name, lo, hi)
    local f = io.open(OUT .. name, "wb"); local b = {}
    for a = lo, hi do b[#b+1] = string.char(prog:read_u8(a))
        if #b == 4096 then f:write(table.concat(b)); b = {} end end
    if #b > 0 then f:write(table.concat(b)) end; f:close()
end

emu.register_frame_done(function()
    local t = mt()
    if t - t_ip >= 1 then
        t_ip = t
        local s = string.format("%04X:%04X", reg("CS") % 0x10000, reg("IP") % 0x10000)
        if s ~= last_ip_s then
            ilog:write(string.format("%9.3f  CS:IP=%s  SS:SP=%04X:%04X\n",
                t, s, reg("SS") % 0x10000, reg("SP") % 0x10000)); ilog:flush()
            last_ip_s = s
        end
    end
    if t - t_snap >= 20 then t_snap = t; manager.machine.video:snapshot() end
    if t - t_dump >= 30 then t_dump = t
        local tag = string.format("%.0f", t)
        dump("dl_" .. tag .. ".bin", 0x18000, 0x18FFF)
    end
end)
print("flip_watch: taps on dl(0x18000-0x1BFFF) + ft(0xD0000-0xD7FFF) installed")

-- sp_monitor.lua -- test the "unserviced interrupt piles up on the stack over
-- time" hypothesis. Every 2 s log elapsed time + CS:IP + SS:SP + the lowest SP
-- seen so far (SP marching monotonically DOWN = ISRs not IRET'ing). Snapshot
-- every 20 s and dump full 1 MB RAM every 60 s to rotating files so a memory
-- image exists near the moment the on-screen garbage appears.
local cpu  = manager.machine.devices[":maincpu"]
local prog = cpu.spaces["program"]
local OUT  = "/Users/ravn/z80/scratch/mame-shots/"
local start = os.time()
local t_sp, t_snap, t_ram = 0, 0, 0
local sp_min = 0x100000
local mon = io.open(OUT .. "sp_monitor.txt", "w")
mon:write("elapsed  CS:IP        SS:SP        SP        SPmin     IF\n"); mon:flush()

local function reg(n)
    local ok, v = pcall(function() return cpu.state[n].value end)
    return ok and v or -1
end

local function dump_ram(tag)
    local mf = io.open(OUT .. "ram_" .. tag .. ".bin", "wb")
    local buf = {}
    for a = 0, 0xFFFFF do
        buf[#buf + 1] = string.char(prog:read_u8(a))
        if #buf == 8192 then mf:write(table.concat(buf)); buf = {} end
    end
    if #buf > 0 then mf:write(table.concat(buf)) end
    mf:close()
end

emu.register_frame_done(function()
    local now = os.time()
    local el  = now - start
    if now - t_sp >= 2 then
        t_sp = now
        local cs, ip = reg("CS"), reg("IP")
        local ss, sp = reg("SS"), reg("SP")
        local f = reg("F")
        if sp >= 0 and sp < sp_min then sp_min = sp end
        local iflag = (f >= 0) and ((math.floor(f / 512) % 2)) or -1  -- bit 9 = IF
        mon:write(string.format("%5ds  %04X:%04X    %04X:%04X    %5d     %5d     %d\n",
            el, cs % 0x10000, ip % 0x10000, ss % 0x10000, sp % 0x10000,
            sp % 0x10000, sp_min, iflag))
        mon:flush()
    end
    if now - t_snap >= 20 then t_snap = now; manager.machine.video:snapshot() end
    if now - t_ram >= 60 then t_ram = now; dump_ram(tostring(el)) end
end)

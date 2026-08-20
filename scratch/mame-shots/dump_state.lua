-- dump_state.lua -- capture ground truth for the "overwritten screen memory /
-- stack explosion" hypothesis. ~15 s after boot (corruption is already on the
-- idle config menu) dump: all CPU registers, the I82730 bootstrap pointer chain
-- (SYSBUS@0xFFFF6 -> IBP@0xFFFFC -> CBP -> LPTR@cbp+6/+10 -> SPTR = the top-line
-- string), the first bytes of that string, and the full 1 MB guest RAM to
-- scratch/mame-shots/ram.bin. Then snapshot so the dump provably matches the
-- garbage frame. Arithmetic only (no bitops) for Lua-version portability.
local cpu  = manager.machine.devices[":maincpu"]
local prog = cpu.spaces["program"]
local done, start = false, os.time()
local OUT = "/Users/ravn/z80/scratch/mame-shots/"

local function rd8(a)  return prog:read_u8(a % 0x100000) end
local function rd16(a) return rd8(a) + rd8(a + 1) * 256 end
local function rd32(a) return (rd16(a) + rd16(a + 2) * 65536) % 0x100000 end

emu.register_frame_done(function()
    if done then return end
    if os.time() - start < 15 then return end
    done = true

    local rf = io.open(OUT .. "regs.txt", "w")
    for _, n in ipairs({"CS","IP","SS","SP","BP","DS","ES","AX","BX","CX","DX","SI","DI","F"}) do
        local ok, v = pcall(function() return cpu.state[n].value end)
        rf:write(string.format("%-3s = %05X\n", n, ok and (v % 0x100000) or -1))
    end

    local sysbus = rd8(0xFFFF6)
    local ibp = rd32(0xFFFFC)
    local cbp = rd32(ibp + 2)
    rf:write(string.format("\nSYSBUS=%02X  IBP=%05X  CBP=%05X\n", sysbus, ibp, cbp))
    for _, off in ipairs({6, 10}) do
        local lptr = rd32(cbp + off)
        local sptr = rd32(lptr)
        rf:write(string.format("LPTR(cbp+%d)=%05X  SPTR=%05X\n", off, lptr, sptr))
        local ln = {}
        for i = 0, 175 do ln[#ln + 1] = string.format("%02X", rd8(sptr + i)) end
        rf:write("  " .. table.concat(ln, " ") .. "\n")
    end
    rf:close()

    local mf = io.open(OUT .. "ram.bin", "wb")
    local buf = {}
    for a = 0, 0xFFFFF do
        buf[#buf + 1] = string.char(rd8(a))
        if #buf == 8192 then mf:write(table.concat(buf)); buf = {} end
    end
    if #buf > 0 then mf:write(table.concat(buf)) end
    mf:close()

    manager.machine.video:snapshot()
    print("STATE-DUMP: complete (regs.txt + ram.bin written)")
end)

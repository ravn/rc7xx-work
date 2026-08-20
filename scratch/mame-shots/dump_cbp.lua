-- dump_cbp.lua : one-shot dump of the 82730 command block (CBP) structure and
-- both list bases + their string pointers, to characterise what list 1 (the
-- alternate list selected at the ~15-min list_switch flip) actually points at.
local mac = manager.machine
local cpu = mac.devices[":maincpu"]
local prog = cpu.spaces["program"]
local out = io.open("/Users/ravn/z80/scratch/mame-shots/dump_cbp.txt", "w")
local done = false

local function rd16(a) return prog:read_u8(a) | (prog:read_u8(a+1) << 8) end
local function rd32(a) return rd16(a) | (rd16(a+2) << 16) end

local function hexrow(a, n)
  local s = string.format("%06x:", a)
  for i = 0, n-1 do s = s .. string.format(" %02x", prog:read_u8(a+i)) end
  return s
end

emu.register_frame_done(function()
  if done then return end
  if mac.time:as_double() < 50 then return end
  done = true
  local cbp = 0x00f7f6
  out:write("== CBP structure at "..string.format("%06x", cbp).." ==\n")
  out:write(hexrow(cbp, 16).."\n")
  local list0 = rd32(cbp + 6)
  local list1 = rd32(cbp + 10)
  out:write(string.format("list0 base (cbp+6/8)  = %06x\n", list0))
  out:write(string.format("list1 base (cbp+10/12)= %06x\n", list1))
  local sptr0 = rd32(list0)          -- lptr entry -> sptr
  local sptr1 = rd32(list1)
  out:write(string.format("list0 sptr = %06x\n", sptr0))
  out:write(string.format("list1 sptr = %06x  <-- alternate list target\n", sptr1))
  out:write("\n-- list0 sptr content (good menu row) --\n"..hexrow(sptr0, 40).."\n")
  out:write("\n-- list1 sptr content (garbage/blank?) --\n"..hexrow(sptr1, 40).."\n")
  out:flush(); out:close()
  emu.print_info("DUMP_CBP done")
end)

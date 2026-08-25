-- zip_hang_dump.lua -- let ZIP reach the deflate hang, then dump the loop code,
-- registers, and the memory the loop is chasing.
local m    = manager.machine
local cpu  = m.devices[":maincpu"]
local prog = cpu.spaces["program"]
local kbd  = m.natkeyboard
local function st(r) return cpu.state[r].value end

local posted, dumped = false, 0

local function hex_row(base, n)
  local t = {}
  for i=0,n-1 do t[#t+1] = string.format("%02X", prog:read_u8(base+i)) end
  return table.concat(t, " ")
end

local function dump(tag)
  local cs,ip,ds,es,ss = st("CS"),st("IP"),st("DS"),st("ES"),st("SS")
  local si,di,bx,bp,sp,ax,cx = st("SI"),st("DI"),st("BX"),st("BP"),st("SP"),st("AX"),st("CX")
  local lin = (cs*16+ip) & 0xFFFFF
  io.write(string.format("\n==== %s @%.1fs ====\n", tag, m.time:as_double()))
  io.write(string.format("CS=%04X IP=%04X lin=%05X  DS=%04X ES=%04X SS=%04X\n", cs,ip,lin,ds,es,ss))
  io.write(string.format("SI=%04X DI=%04X BX=%04X BP=%04X SP=%04X AX=%04X CX=%04X\n", si,di,bx,bp,sp,ax,cx))
  io.write(string.format("code @lin-16: %s\n", hex_row((lin-16)&0xFFFFF, 16)))
  io.write(string.format("code @lin   : %s\n", hex_row(lin, 24)))
  -- data the loop is likely chasing (both DS:SI and ES:DI windows)
  io.write(string.format("DS:SI  %05X: %s\n", (ds*16+si)&0xFFFFF, hex_row((ds*16+si)&0xFFFFF, 16)))
  io.write(string.format("ES:DI  %05X: %s\n", (es*16+di)&0xFFFFF, hex_row((es*16+di)&0xFFFFF, 16)))
  io.write(string.format("DS:BX  %05X: %s\n", (ds*16+bx)&0xFFFFF, hex_row((ds*16+bx)&0xFFFFF, 16)))
  io.flush()
end

emu.register_periodic(function()
  local t = m.time:as_double()
  if not posted and t > 42 then kbd:post("ZIP POEM.ZIP POEM.TXT\r"); posted=true
    io.write("== posted ZIP @",t,"s ==\n"); io.flush() end
  if posted and t > 70 and dumped < 5 and (t*10)%80 < 2 then
    dumped = dumped + 1
    dump("hang-sample-"..dumped)
    m.video:snapshot()
  end
  if t > 110 then m:exit() end
end)

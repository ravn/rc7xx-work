-- dump the call stack + far-heap region at the deflate hang
local m=manager.machine; local cpu=m.devices[":maincpu"]; local prog=cpu.spaces["program"]
local kbd=m.natkeyboard
local function st(r) return cpu.state[r].value end
local function u8(a) return prog:read_u8(a & 0xFFFFF) end
local function u16(a) return u8(a) | (u8(a+1)<<8) end
local posted,done=false,false
emu.register_periodic(function()
  local t=m.time:as_double()
  if not posted and t>42 then kbd:post("ZIP POEM.ZIP POEM.TXT\r"); posted=true end
  if posted and not done and t>75 then
    done=true
    local ss,sp,bp,es=st("SS"),st("SP"),st("BP"),st("ES")
    io.write(string.format("HANG CS=%04X IP=%04X ES=%04X\n",st("CS"),st("IP"),es))
    io.write("== stack (SS:SP up, look for return CS:IP into frame 0002) ==\n")
    for i=0,30 do
      local a=(ss*16+sp+i*2)&0xFFFFF
      io.write(string.format("  [SP+%02X] %05X = %04X\n", i*2, a, u16(a)))
    end
    -- far-heap byte that gates the loop: ES:[0x1B] and surrounding
    local base=(es*16)&0xFFFFF
    io.write(string.format("== far-heap seg ES=%04X, bytes [0x00..0x40] ==\n", es))
    for r=0,3 do
      local line={}
      for c=0,15 do line[#line+1]=string.format("%02X",u8(base+r*16+c)) end
      io.write(string.format("  +%02X: %s\n", r*16, table.concat(line," ")))
    end
    -- is the whole segment 0xFF? sample 256 bytes
    local ff,nz=0,0
    for k=0,255 do if u8(base+k)==0xFF then ff=ff+1 else nz=nz+1 end end
    io.write(string.format("== ES seg first 256 bytes: 0xFF=%d other=%d ==\n", ff, nz))
    io.flush(); m.video:snapshot()
  end
  if t>85 then m:exit() end
end)

-- zip_ramdump.lua -- at the deflate hang, dump ALL guest RAM to a file for
-- offline layout analysis (find DGROUP, read _window/_prev/_head far ptrs).
local m=manager.machine; local cpu=m.devices[":maincpu"]; local prog=cpu.spaces["program"]
local kbd=m.natkeyboard
local function st(r) return cpu.state[r].value end
local posted,done=false,false
local TOP=0xA0000   -- 640 KB

emu.register_periodic(function()
  local t=m.time:as_double()
  if not posted and t>42 then kbd:post("ZIP POEM.ZIP POEM.TXT\r"); posted=true end
  if posted and not done and t>75 then
    done=true
    io.write(string.format("HANG CS=%04X IP=%04X DS=%04X ES=%04X SS=%04X SP=%04X BP=%04X\n",
      st("CS"),st("IP"),st("DS"),st("ES"),st("SS"),st("SP"),st("BP")))
    local f=assert(io.open("/tmp/zipram.bin","wb"))
    local CH=4096
    local buf={}
    for base=0,TOP-1,CH do
      for i=0,CH-1 do buf[i+1]=string.char(prog:read_u8(base+i)) end
      f:write(table.concat(buf))
    end
    f:close()
    io.write("== dumped 0..",string.format("%05X",TOP)," to /tmp/zipram.bin ==\n"); io.flush()
    m.video:snapshot()
    m:exit()
  end
  if t>95 then m:exit() end
end)

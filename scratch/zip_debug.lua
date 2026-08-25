-- zip_debug.lua -- boot to A>, run ZIP from the prompt (full TPA), then sample
-- CPU state to locate the deflate hang and dump the far-heap region.
local m    = manager.machine
local cpu  = m.devices[":maincpu"]
local prog = cpu.spaces["program"]
local kbd  = m.natkeyboard
local VBASE = 0xB8000

local function st(r) return cpu.state[r].value end

local function screen_text()
  local rows = {}
  for row = 0, 24 do
    local line = {}
    for col = 0, 79 do
      local c = prog:read_u8(VBASE + 2*(row*80+col))
      if c < 32 or c > 126 then c = 32 end
      line[#line+1] = string.char(c)
    end
    rows[#rows+1] = (table.concat(line)):gsub("%s+$","")
  end
  return rows
end

local function screen_has(s)
  for _,l in ipairs(screen_text()) do if l:find(s,1,true) then return true end end
  return false
end

local function dump_screen(tag)
  io.write("=== screen ",tag," @",string.format("%.1f",m.time:as_double()),"s ===\n")
  for i,l in ipairs(screen_text()) do if #l>0 then io.write(string.format("%2d|%s\n",i-1,l)) end end
  io.flush()
end

local stage, tmark = 0, 0
local hist = {}      -- linear CS:IP -> count
local samples = 0
local last_dump = -100

emu.register_periodic(function()
  local t = m.time:as_double()

  -- drive the guest to run ZIP from A>
  if stage == 0 and t > 4 then dump_screen("boot"); stage = 1; tmark = t end
  if stage == 1 and screen_has("A>") then stage = 2; tmark = t end
  if stage == 1 and t > 30 then dump_screen("no-A>-yet"); tmark = t; stage = 1.5 end
  if stage == 1.5 and t > 45 then dump_screen("still-waiting"); stage = 2; tmark = t end
  if stage == 2 and t > tmark + 1 then
    kbd:post("ZIP POEM.ZIP POEM.TXT\r"); io.write("== posted ZIP cmd @",t,"s ==\n"); io.flush()
    stage = 3; tmark = t
  end

  -- once the command should be running, sample CS:IP into a histogram
  if stage == 3 and t > tmark + 4 then
    local cs, ip = st("CS"), st("IP")
    local lin = (cs*16 + ip) & 0xFFFFF
    hist[lin] = (hist[lin] or 0) + 1
    samples = samples + 1
    if t - last_dump >= 8 then
      last_dump = t
      io.write(string.format("[sample @%.1fs] CS=%04X IP=%04X (lin=%05X) DS=%04X ES=%04X SS=%04X SI=%04X DI=%04X BX=%04X BP=%04X SP=%04X AX=%04X\n",
        t, cs, ip, lin, st("DS"), st("ES"), st("SS"), st("SI"), st("DI"), st("BX"), st("BP"), st("SP"), st("AX")))
      io.flush()
      m.video:snapshot()
    end
  end

  if t > 120 then
    dump_screen("final")
    -- top spinning addresses
    local arr = {}
    for lin,c in pairs(hist) do arr[#arr+1] = {lin,c} end
    table.sort(arr, function(a,b) return a[2] > b[2] end)
    io.write(string.format("== CS:IP histogram (%d samples), top 12 ==\n", samples))
    for i=1,math.min(12,#arr) do
      io.write(string.format("  lin=%05X  count=%d  (%.0f%%)\n", arr[i][1], arr[i][2], 100*arr[i][2]/samples))
    end
    io.flush()
    m:exit()
  end
end)

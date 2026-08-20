-- flip_ctrl.lua : CONTROL run (no keypress). After the ~15-min flip, sample
-- the top-row pixel hash every few frames for ~900 frames with NO key input,
-- to see whether the garbage self-heals (blink/transient) or persists until a
-- key. Separates "keypress woke it" from "it reverts on its own".

local mac = manager.machine
local scr = mac.screens:at(1)
local out = io.open("/Users/ravn/z80/scratch/mame-shots/flip_ctrl.txt", "w")

local function hash_topline()
  local h = 0
  for y = 0, 40, 2 do
    for x = 0, 600, 6 do
      local ok, p = pcall(function() return scr:pixel(x, y) end)
      if ok and p then h = (h * 33 + (p & 0xffffff)) & 0xffffffff end
    end
  end
  return h
end

local steady = nil
local flipped = false
local flip_frame = -1
local last_state = nil
local shots = 0

local function log(s)
  local t = mac.time:as_double()
  out:write(string.format("[t=%.3f] %s\n", t, s)); out:flush()
  emu.print_info(string.format("FLIPCTRL [t=%.3f] %s", t, s))
end

emu.register_frame_done(function()
  local t = mac.time:as_double()
  if t < 45 then return end
  local h = hash_topline()

  if steady == nil then
    steady = h
    log(string.format("steady=%08x", steady))
    return
  end

  if not flipped then
    if h ~= steady then
      flipped = true
      flip_frame = scr:frame_number()
      log(string.format("FLIP at hash %08x (steady %08x)", h, steady))
      mac.video:snapshot(); shots = shots + 1  -- garbage frame
      last_state = "G"
    end
    return
  end

  -- CONTROL: no key. Track garbage(G)/clean(C) transitions frame by frame.
  local st = (h == steady) and "C" or "G"
  if st ~= last_state then
    local since = scr:frame_number() - flip_frame
    log(string.format("+%d frames: %s->%s hash=%08x", since, last_state, st, h))
    last_state = st
    if shots < 6 then mac.video:snapshot(); shots = shots + 1 end
  end
  local since = scr:frame_number() - flip_frame
  if since >= 1200 then
    log("control window ended (no key posted whole time)")
    -- stop sampling further by pretending steady==h to silence transitions
  end
end)

emu.print_info("flip_ctrl.lua armed (NO keypress)")

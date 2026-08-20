-- flip_key.lua : catch the ~15-min top-line flip by hashing the top border
-- scanline every frame, then test whether a keypress "wakes"/redraws the CRT.
--
-- On the frame the top-scanline hash first changes after steady-state (the
-- flip), we: snapshot BEFORE, post a key via the natural keyboard, wait a few
-- frames, snapshot AFTER, and log whether the hash reverted to steady-state.
-- If a keypress restores the clean border -> guest can redraw it (console
-- reprogram / wake). If not -> pure emulation render state.

local mac = manager.machine
local scr = mac.screens:at(1)
local out = io.open("/Users/ravn/z80/scratch/mame-shots/flip_key.txt", "w")

local function hash_topline()
  -- sample the TOP text row band (above the menu body, well above the bottom
  -- clock line) so the hash is steady except at the flip. y=4 alone was in the
  -- black top-border gap -> scan a band to include the first text row pixels.
  local h = 0
  for y = 0, 40, 2 do
    for x = 0, 600, 6 do
      local ok, p = pcall(function() return scr:pixel(x, y) end)
      if ok and p then h = (h * 33 + (p & 0xffffff)) & 0xffffffff end
    end
  end
  return h
end

local steady = nil           -- steady-state hash after boot settles
local flipped = false
local flip_frame = -1
local shot = 0

local function log(s)
  local t = mac.time:as_double()
  out:write(string.format("[t=%.3f] %s\n", t, s)); out:flush()
  emu.print_info(string.format("FLIPKEY [t=%.3f] %s", t, s))
end

emu.register_frame_done(function()
  local t = mac.time:as_double()
  if t < 45 then return end            -- ignore boot churn
  local h = hash_topline()

  if steady == nil then
    steady = h
    log(string.format("steady-state topline hash = %08x", steady))
    return
  end

  if not flipped then
    if h ~= steady then
      flipped = true
      flip_frame = scr:frame_number()
      log(string.format("FLIP DETECTED hash %08x -> %08x", steady, h))
      mac.video:snapshot(); shot = shot + 1
      log(string.format("snapshot BEFORE-key #%d taken", shot))
      -- test keypress-wake: post a harmless key (space)
      local ok = pcall(function()
        if mac.natkeyboard.can_post then mac.natkeyboard:post(" ") end
      end)
      log("posted SPACE key (can_post="..tostring(mac.natkeyboard.can_post)..", ok="..tostring(ok)..")")
    end
    return
  end

  -- after flip: for the next 300 frames snapshot periodically and watch hash
  local since = scr:frame_number() - flip_frame
  if since == 60 or since == 180 or since == 300 then
    mac.video:snapshot(); shot = shot + 1
    local reverted = (h == steady)
    log(string.format("+%d frames: hash=%08x reverted=%s snapshot AFTER #%d",
        since, h, tostring(reverted), shot))
  end
  if since == 240 then
    -- second stimulus: post Enter in case space was ignored
    pcall(function() mac.natkeyboard:post("\r") end)
    log("posted ENTER key")
  end
end)

emu.print_info("flip_key.lua armed")

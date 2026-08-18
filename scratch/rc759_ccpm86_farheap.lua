local sent1, last_snap = false, -100
emu.register_periodic(function()
  local m = manager.machine
  local t = m.time.seconds
  if not sent1 and t > 3 then m.natkeyboard:post("A\n"); sent1 = true end
  if t - last_snap >= 2 then m.video:snapshot(); last_snap = t end
  if t > 75 then print("DONE-WINDOW"); m:exit() end
end)

local sent1, sent2, last_snap = false, false, -100
emu.register_periodic(function()
  local m = manager.machine
  local t = m.time.seconds
  if not sent1 and t > 3   then m.natkeyboard:post("A\n");           sent1 = true end
  if not sent2 and t > 115 then m.natkeyboard:post("b:farheap\n");   sent2 = true end
  if t - last_snap >= 6 then m.video:snapshot(); last_snap = t end
  if sent2 and t > 140 then print("DONE-WINDOW"); m:exit() end
end)

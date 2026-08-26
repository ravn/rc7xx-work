-- periodic snapshots across the full ~290s CCP/M boot, so we capture the screen
-- AFTER the turnkey autostart runs menu.cmd (= CPM86_AUTORUN UNZIP -t BIG.ZIP).
local ls=-100
emu.register_periodic(function()
  local m=manager.machine; local t=m.time.seconds
  if t-ls>=10 then m.video:snapshot(); ls=t end
  if t>320 then print("DONE-WINDOW t="..t); m:exit() end
end)

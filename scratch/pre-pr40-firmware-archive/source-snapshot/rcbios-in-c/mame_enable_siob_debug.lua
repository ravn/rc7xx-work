-- Sets DSW S01 (port 0x14 bit 0) on first frame so the BIOS boots with
-- SIO-B debugging enabled.  Does not capture screenshots or exit MAME —
-- intended for `make mame-maxi` interactive sessions.

local done = false

emu.register_frame_done(function()
    if done then return end
    local port = manager.machine.ioport.ports[":DSW"]
    if not port then return end
    for _, field in pairs(port.fields) do
        if field.mask == 0x01 then
            field.user_value = 0x01
            print("[enable-siob-debug] DSW S01 = 0x01 — SIO-B debug enabled")
            done = true
            return
        end
    end
end)

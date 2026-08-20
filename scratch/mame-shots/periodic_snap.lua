-- periodic_snap.lua -- take a screen snapshot every SNAP_PERIOD real (wall-clock)
-- seconds, so a transient artifact (e.g. top-line corruption during a long TYPE
-- that later scrolls away) is captured on disk even if we never press F12 at the
-- right instant. Snapshots land in MAME's snap dir (mame/snap/rc759/NNNN.png).
-- Wall-clock (os.time) is deliberate: under -nothrottle emulated time races, so
-- keying on machine.time would fire far too often; we want one shot per 10 s of
-- the operator's real time.
local period = tonumber(os.getenv("SNAP_PERIOD") or "10") or 10
local last = os.time()
local n = 0

emu.register_frame_done(function()
    local now = os.time()
    if now - last >= period then
        last = now
        n = n + 1
        manager.machine.video:snapshot()
        print(string.format("PERIODIC-SNAP #%d (real ~%ds)", n, n * period))
    end
end)

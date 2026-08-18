-- ibm_disk_done.lua -- run the Watcom disk FILE* oracle on ibm5150 CP/M-86 1.0
-- (the pre-CP/M-3 fallback oracle where os_has_lrbc() is genuinely false) and
-- stop when it finishes.
--
-- Three jobs:
--  1. On the first frame, set the motherboard DSW1 "Extra RAM size" DIP to 0x02
--     (64K expansion -> 128K total) so the 5150 POST tests only 128K and boots
--     to the CP/M-86 "A>" in ~12 emulated s instead of ~110 s (see
--     ram128_boot.lua). Must match -ramsize 128K or POST throws a 201 error.
--  2. Tap the undecoded I/O port 0x2FE. disktest.c built -DMAME_DONE streams a
--     result record there via mame_out(): word0=0xD15C tag, word1=tests,
--     word2=failures, word3=0xE0F0 sentinel. We collect the words in program
--     order (single CPU = deterministic).
--  3. On the sentinel, snapshot the screen (the guest's own "DISKIO: PASS (N
--     tests, 0 failures)" line is the human oracle) and exit, printing
--     DISK-RESULT: PASS/FAIL for the shell to gate. A safety snapshot also
--     fires at MAME_SNAP_AT emulated seconds (default 60) so we can see the
--     screen even if disktest never streamed (e.g. $$$.SUB autorun failed).
local snap_at = tonumber(os.getenv("MAME_SNAP_AT") or "60") or 60
local set_done = false
local safety_done = false
local fire = false
local words = {}

local cpu = manager.machine.devices[":maincpu"]
local io  = cpu.spaces["io"]

-- Keep the tap in a global: a GC'd tap stops firing.
DISK_TAP = io:install_write_tap(0x2FE, 0x2FF, "disk_done",
    function(offset, data, mask)
        words[#words + 1] = data
        if data == 0xE0F0 then fire = true end
    end)

emu.register_frame_done(function()
    if not set_done then
        set_done = true
        local port = manager.machine.ioport.ports[":mb:DSW1"]
        if port then
            for _, f in pairs(port.fields) do
                if f.name and string.find(f.name, "Extra RAM") then
                    f:set_value(0x02)
                    print("RAM128: set Extra RAM size DIP -> 0x02")
                end
            end
        end
    end

    if fire then
        fire = false
        manager.machine.video:snapshot()
        local tag, tests, fails = 0, -1, -1
        for i = 1, #words do
            if words[i] == 0xD15C then
                tag, tests, fails = words[i], words[i+1] or -1, words[i+2] or -1
                break
            end
        end
        print(string.format("DISK-DONE tag=0x%04X tests=%d failures=%d words=%d",
            tag, tests, fails, #words))
        print((fails == 0 and tests > 0) and "DISK-RESULT: PASS" or "DISK-RESULT: FAIL")
        manager.machine:exit()
        return
    end

    if not safety_done and manager.machine.time:as_double() >= snap_at then
        safety_done = true
        manager.machine.video:snapshot()
        print(string.format("SAFETY-SNAP at %.1f s (words so far=%d)", snap_at, #words))
    end
end)

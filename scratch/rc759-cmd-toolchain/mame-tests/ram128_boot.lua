-- ram128_boot.lua -- speed up ibm5150 CP/M-86 boot by shrinking the RAM the
-- 5150 POST has to test. The stock DIPs test 640K (planar 64K + 576K
-- expansion), which on this build takes ~110 emulated seconds before the
-- CP/M-86 sign-on appears (just a blinking cursor until then). CP/M-86 1.0
-- only uses 128K ("Memory (Kb): 128"), so we set the motherboard expansion
-- DIP (DSW1 "Extra RAM size", SW2) to 0x02 = 64K extra -> 64K planar + 64K
-- = 128K total, matching -ramsize 128K so POST passes with no 201 error and
-- boots fast.
--
-- Worked example: with default DSW1=0x12 (=18 -> 18*32K=576K expansion) the
-- BIOS memory-counts 640K and the "A>" prompt only shows ~110s in; with
-- DSW1=0x02 (=2 -> 64K expansion) it shows in a few emulated seconds.
--
-- Snapshots at MAME_SNAP_AT emulated seconds (default 12) then exits.
local snap_at = tonumber(os.getenv("MAME_SNAP_AT") or "12") or 12
local set_done = false
local snap_done = false

emu.register_frame_done(function()
    -- Set the DIP once, on the first frame, before the BIOS reads it.
    if not set_done then
        set_done = true
        local port = manager.machine.ioport.ports[":mb:DSW1"]
        if port then
            for _, f in pairs(port.fields) do
                if f.name and string.find(f.name, "Extra RAM") then
                    f:set_value(0x02)
                    print(string.format("RAM128: set '%s' -> 0x02 (64K expansion)", f.name))
                end
            end
        else
            print("RAM128: WARNING port :mb:DSW1 not found")
        end
    end
    if snap_done then return end
    if manager.machine.time:as_double() >= snap_at then
        snap_done = true
        manager.machine.video:snapshot()
        print(string.format("BOOT-SNAP: taken at %.2f emulated seconds", snap_at))
        manager.machine:exit()
    end
end)

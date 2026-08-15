-- disk_done.lua -- stop MAME rc759 when the Watcom disk FILE* oracle finishes,
-- reading its full result record off the undecoded I/O port 0x2FE.
--
-- The guest (disktest.c built -DMAME_DONE) streams a small record as a sequence
-- of 16-bit words via mame_out() (see mamedone.h), because its test count (511)
-- does not fit the byte-packed mame_done() convention:
--   word 0  = 0xD15C  tag ("disk" result record)
--   word 1  = tests   (total checks executed, full 16-bit)
--   word 2  = failures(0 == PASS)
--   word 3  = 0xE0F0  end sentinel
-- Port 0x2FE is undecoded by the rc759 driver, so each OUT is side-effect-free,
-- but an io-space write-tap still sees the bus cycle. We collect the words in
-- program order (single CPU, deterministic) and, on the sentinel, snapshot the
-- screen (the on-screen "DISKIO: PASS (511 tests, 0 failures)" line is the
-- human oracle) and exit, printing the record so the shell harness can gate.

local cpu = manager.machine.devices[":maincpu"]
local io  = cpu.spaces["io"]

local words = {}
local fire  = false

-- Keep the tap in a global: a GC'd tap stops firing.
DISK_TAP = io:install_write_tap(0x2FE, 0x2FF, "disk_done",
    function(offset, data, mask)
        words[#words + 1] = data
        if data == 0xE0F0 then
            fire = true
        end
    end)

emu.register_frame_done(function()
    if fire then
        fire = false
        manager.machine.video:snapshot()
        -- Find the tag; payload follows it (guest may emit console-driver noise
        -- on 0x2FE first in theory, but it does not -- tag is word 1).
        local tag, tests, fails = 0, -1, -1
        for i = 1, #words do
            if words[i] == 0xD15C then
                tag   = words[i]
                tests = words[i + 1] or -1
                fails = words[i + 2] or -1
                break
            end
        end
        print(string.format(
            "DISK-DONE tag=0x%04X tests=%d failures=%d words=%d",
            tag, tests, fails, #words))
        if fails == 0 and tests > 0 then
            print("DISK-RESULT: PASS")
        else
            print("DISK-RESULT: FAIL")
        end
        manager.machine:exit()
    end
end)

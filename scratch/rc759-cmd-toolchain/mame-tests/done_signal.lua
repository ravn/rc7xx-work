-- done_signal.lua -- stop MAME rc759 the instant the guest program finishes.
--
-- The guest calls mame_done(status) (see mamedone.h), which does OUT 0x2FE,AX.
-- Port 0x2FE is undecoded by the rc759 driver, so the OUT is side-effect-free,
-- but an io-space write-tap catches the bus cycle. On the first such write we
-- snapshot the screen (the on-screen RESULT line stays the human-readable
-- oracle) and exit the emulator, printing the status word so the shell harness
-- can gate PASS/FAIL without a fixed timer.
--
-- Convention (mtest.c): low byte = pass count, high byte = fail count.

local cpu = manager.machine.devices[":maincpu"]
local io  = cpu.spaces["io"]

local done      = false
local done_word = 0
local frames    = 0

-- Keep the tap object alive for the whole run: a GC'd tap stops firing. Storing
-- it in a global (not a local) is deliberate.
DONE_TAP = io:install_write_tap(0x2FE, 0x2FF, "mame_done", function(offset, data, mask)
    done_word = data
    done = true
    -- do not modify the write: returning nothing lets the (undecoded) access proceed
end)

emu.register_frame_done(function()
    frames = frames + 1
    if done then
        done = false  -- fire once
        manager.machine.video:snapshot()
        local pass = done_word & 0xFF
        local fail = (done_word >> 8) & 0xFF
        print(string.format(
            "DONE-SIGNAL word=0x%04X pass=%d fail=%d frame=%d",
            done_word, pass, fail, frames))
        manager.machine:exit()
    end
end)

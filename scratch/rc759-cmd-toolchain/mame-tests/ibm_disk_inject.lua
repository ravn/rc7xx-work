-- ibm_disk_inject.lua -- run the Watcom disk FILE* oracle on ibm5150 CP/M-86
-- 1.0 (the pre-CP/M-3 fallback oracle: os_has_lrbc() is genuinely false) and
-- stop when it finishes, reading the result off I/O port 0x2FE.
--
-- Disks: flop1 (A:) = pristine, UNMODIFIED cpm86.img boot disk. flop2 (B:) =
-- a disk holding only disktest.cmd. We log into B: so ALL of disktest's runtime
-- temp files are created on B:, leaving A: completely untouched (user rule).
--
-- Keystroke injection is PROMPT-DRIVEN, not time-driven: earlier fixed-time
-- posts dropped characters because the A> prompt wasn't ready to accept input
-- yet. We poll the CGA text buffer at 0xB8000 (80x25, chars at even byte
-- offsets) and only advance a stage when the expected prompt is on screen:
--   stage 0: wait for "A>" visible  -> post "B:\n"       (log into drive B:)
--   stage 1: wait for "B>" visible  -> post "DISKTEST\n" (run from & write to B:)
--   stage 2: wait for the 0x2FE result record, then snapshot + exit.
-- A settle delay after each prompt appears avoids racing the line editor.
--
-- disktest.c built -DMAME_DONE streams via mame_out(): word0=0xD15C tag,
-- word1=tests, word2=failures, word3=0xE0F0 sentinel (mamedone.h). Port 0x2FE
-- is undecoded, so the write is side-effect-free but the tap still sees it.
local snap_at = tonumber(os.getenv("MAME_SNAP_AT") or "120") or 120
local settle  = tonumber(os.getenv("MAME_SETTLE") or "2") or 2

local cpu  = manager.machine.devices[":maincpu"]
local io   = cpu.spaces["io"]
local prog = cpu.spaces["program"]

local stage = 0
local stage_seen_at = nil
local safety_done = false
local fire = false
local words = {}

DISK_TAP = io:install_write_tap(0x2FE, 0x2FF, "disk_done",
    function(offset, data, mask)
        words[#words + 1] = data
        if data == 0xE0F0 then fire = true end
    end)

-- true if chars c1,c2 appear adjacent anywhere in the 80x25 CGA text page
-- (chars at 0xB8000 + 2*i; attribute byte at +1).
local function screen_has(c1, c2)
    local base = 0xB8000
    for i = 0, 80 * 25 - 2 do
        if prog:read_u8(base + 2 * i) == c1 and
           prog:read_u8(base + 2 * (i + 1)) == c2 then
            return true
        end
    end
    return false
end

emu.register_frame_done(function()
    local t = manager.machine.time:as_double()

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

    if stage == 0 then                          -- waiting for A>
        if screen_has(0x41, 0x3E) then
            if not stage_seen_at then
                stage_seen_at = t
                print(string.format("PROMPT: 'A>' seen at %.1f s", t))
            elseif t >= stage_seen_at + settle then
                manager.machine.natkeyboard:post("B:\n")
                print(string.format("INJECT: 'B:' at %.1f s", t))
                stage, stage_seen_at = 1, nil
            end
        end
    elseif stage == 1 then                       -- waiting for B>
        if screen_has(0x42, 0x3E) then
            if not stage_seen_at then
                stage_seen_at = t
                print(string.format("PROMPT: 'B>' seen at %.1f s", t))
            elseif t >= stage_seen_at + settle then
                manager.machine.natkeyboard:post("DISKTEST\n")
                print(string.format("INJECT: 'DISKTEST' at %.1f s", t))
                stage = 2
            end
        end
    end

    if not safety_done and t >= snap_at then
        safety_done = true
        manager.machine.video:snapshot()
        print(string.format("SAFETY-SNAP at %.1f s (stage=%d words=%d)",
            snap_at, stage, #words))
    end
end)

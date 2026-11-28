-- rtm_svc_trace.lua v4 — RTM service table trace, RC759 #16
-- Globale variabler (_f, _ref) forhindrer GC under lang kørsel.

local OUT      = "/Users/ravn/z80/scratch/tmp/rtm_trace_result.txt"
local SYSDAT_P = 0x06FA0   -- SYSDAT segment × 16
local TBL_OFF  = 0x00AA    -- RTM service table offset fra SYSDAT

_f = io.open(OUT, "a")  -- append: akkumuler på tværs af resets
_f:write(string.format("LOADED (%.3f)\n", os.clock())); _f:flush()

_ref = emu.register_frame_done(function()
    local t = manager.machine.time.seconds

    -- Heartbeat hvert 10. emulerede sekund
    if math.floor(t) % 10 == 0 and math.floor(t) > 0 then
        _f:write(string.format("t=%d\n", math.floor(t))); _f:flush()
    end

    -- Post "A" + Enter for drev-valg
    if t > 4 and t < 5 then
        pcall(function() manager.machine.natkeyboard:post("A\n") end)
    end

    -- Læs RTM-tabel efter boot (~290 sek)
    if t > 300 then
        _f:write(string.format("\n=== RTM SERVICE TABLE @ t=%.0fs ===\n", t))
        _f:write(string.format("SYSDAT phys: 0x%05X  tbl: 0x%05X\n",
                               SYSDAT_P, SYSDAT_P + TBL_OFF))
        _f:flush()

        local ok, err = pcall(function()
            local mem = manager.machine.devices[":maincpu"].spaces["program"]
            local tbl = SYSDAT_P + TBL_OFF

            -- Range AL 0x00-0x50: SI = AL*2
            _f:write("--- AL 0x00-0x28 (SI=AL*2) ---\n")
            for al = 0, 0x28 do
                local h = mem:read_u16(tbl + al * 2)
                if h ~= 0 then
                    _f:write(string.format("  AL=%02X -> 0x%04X\n", al, h))
                end
            end

            -- Range AL 0x80-0xA4: SI = (AL-0x1C)*2
            _f:write("--- AL 0x80-0xA4 (SI=(AL-0x1C)*2) ---\n")
            for al = 0x80, 0xA4 do
                local si = (al - 0x1C) * 2
                local h  = mem:read_u16(tbl + si)
                if h ~= 0 then
                    _f:write(string.format("  AL=%02X -> 0x%04X\n", al, h))
                end
            end

            -- Specifikke entries vi kender
            _f:write("--- Specifikke entries ---\n")
            local h02 = mem:read_u16(tbl + 0x02 * 2)
            local h80 = mem:read_u16(tbl + (0x80 - 0x1C) * 2)
            local h87 = mem:read_u16(tbl + (0x87 - 0x1C) * 2)
            _f:write(string.format("AL=0x02 io_read:   0x%04X\n", h02))
            _f:write(string.format("AL=0x80 io_const:  0x%04X\n", h80))
            _f:write(string.format("AL=0x87 io_conin:  0x%04X\n", h87))
        end)

        if not ok then
            _f:write(string.format("FEJL: %s\n", tostring(err)))
        end

        _f:write("DONE\n"); _f:flush(); _f:close()
        manager.machine:exit()
    end
end)

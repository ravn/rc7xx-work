-- rc759 ESC probe (autoboot_script).
-- Reads the RC759 HLE keyboard matrix directly every frame and logs which
-- scancodes (scancode = row*16 + bit) go active/inactive, so we can see
-- exactly what host ESC / Ctrl-Ae / A1 produce -- independent of whether the
-- guest firmware has enabled the keyboard yet (port:read() is the raw host
-- key state, not gated by m_enabled).
--
-- If host ESC never shows up here AND MAME quits when you press it, the UI
-- (UI_CANCEL = KEYCODE_ESC) is eating the key. If scancode 55 DOES show up,
-- the key reaches the guest and the issue is the firmware keymap instead.

local LOGPATH = "/Users/ravn/z80/scratch/rc759-esc-probe.log"
local logf = io.open(LOGPATH, "w")

local function log(s)
    logf:write(s .. "\n")
    logf:flush()
    emu.print_info(s)
end

-- collect the kbd:row_N ports
local rows = {}
local nrows = 0
for tag, port in pairs(manager.machine.ioport.ports) do
    local n = tag:match("kbd:row_(%d)")
    if n then
        rows[tonumber(n)] = port
        nrows = nrows + 1
    end
end

log(string.format("[ESC-PROBE] armed; found %d kbd rows. Press ESC, then Ctrl-Ae, then A1 (Fn+Up).", nrows))

local last = {}
emu.register_periodic(function()
    for i, port in pairs(rows) do
        local v = port:read()
        local prev = last[i] or 0
        if v ~= prev then
            for b = 0, 15 do
                local mask = 1 << b
                local now_on  = (v & mask) ~= 0
                local was_on  = (prev & mask) ~= 0
                if now_on and not was_on then
                    local sc = i * 16 + b
                    log(string.format("[ESC-PROBE] PRESS   row_%d bit%02d -> scancode %3d (0x%02x)", i, b, sc, sc))
                elseif was_on and not now_on then
                    local sc = i * 16 + b
                    log(string.format("[ESC-PROBE] release row_%d bit%02d -> scancode %3d (0x%02x)", i, b, sc, sc))
                end
            end
            last[i] = v
        end
    end
end)

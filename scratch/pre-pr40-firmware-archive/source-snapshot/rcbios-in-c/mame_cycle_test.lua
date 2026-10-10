-- Cycle-tracking autotest for ASM FILEX
-- Uses emu.keypost() for BIOS-agnostic keyboard input (works with any BIOS)
-- Records emulated CPU cycles + PC histogram for hotspot detection
--
-- Substitution variables (replaced by shell wrapper):
--   BIOS_LABEL  - label for this BIOS variant
--   MAP_FILE    - path to symbol map file (or "none")
--
-- Output files:
--   /tmp/bios_cycle_autotest.txt  - screen captures with cycle counts
--   /tmp/bios_cycle_results.txt   - machine-readable cycle data + PC histogram

local Z80_CLOCK = 4000000  -- 4 MHz
local bios_label = "BIOS_LABEL"
local map_file = "MAP_FILE"

local frame = 0
local done = false

local commands = {
    "ASM FILEX\r",
    "STAT FILEX.PRN\r",
    "TYPE FILEX.PRN\r",
}

local cmd_idx = 0
local screens = {}
local timings = {}
local state = "boot"
local prompt_left = false

-- PC histogram: address → sample count (sampled every frame during execution)
local pc_hist = {}
local pc_samples = 0
local sampling_cmd = nil  -- which command we're sampling during

-- Symbol table: sorted list of {addr, name} loaded from map file
local symbols = {}

local function load_symbols()
    if map_file == "none" then return end
    local f = io.open(map_file, "r")
    if not f then return end
    for line in f:lines() do
        -- bios.map format: "_funcname = $XXXX ; ..."
        local name, addr = line:match("^(_[%w_]+)%s*=%s*%$(%x+)")
        if name and addr then
            symbols[#symbols + 1] = {addr = tonumber(addr, 16), name = name}
        end
    end
    f:close()
    table.sort(symbols, function(a, b) return a.addr < b.addr end)
end

-- Map PC address to nearest function name
local function pc_to_func(pc)
    if #symbols == 0 then return string.format("0x%04X", pc) end
    local best = nil
    for i = #symbols, 1, -1 do
        if symbols[i].addr <= pc then
            best = symbols[i]
            break
        end
    end
    if best then
        return string.format("%s+%d", best.name, pc - best.addr)
    end
    return string.format("0x%04X", pc)
end

local function screen_text()
    local space = manager.machine.devices[":maincpu"].spaces["program"]
    local lines = {}
    for row = 0, 24 do
        local line = ""
        for col = 0, 79 do
            local ch = space:read_u8(0xF800 + row * 80 + col)
            line = line .. (ch >= 0x20 and ch < 0x7F and string.char(ch) or " ")
        end
        lines[#lines + 1] = line:gsub("%s+$", "")
    end
    return table.concat(lines, "\n")
end

local function at_prompt()
    local space = manager.machine.devices[":maincpu"].spaces["program"]
    local curx = space:read_u8(0xFFD1)
    local cursy = space:read_u8(0xFFD4)
    if curx ~= 2 then return false end
    local row_addr = 0xF800 + cursy * 80
    return space:read_u8(row_addr) == 0x41 and space:read_u8(row_addr + 1) == 0x3E
end

local function get_seconds()
    return manager.machine.time:as_double()
end

local function sample_pc()
    local pc = manager.machine.devices[":maincpu"].state["PC"].value
    pc_hist[pc] = (pc_hist[pc] or 0) + 1
    pc_samples = pc_samples + 1
end

local function write_results()
    -- Screen captures
    local f = io.open("/tmp/bios_cycle_autotest.txt", "w")
    for _, s in ipairs(screens) do f:write(s .. "\n\n") end
    f:close()

    -- Build function-level profile from PC histogram
    local func_counts = {}
    for pc, count in pairs(pc_hist) do
        local fname = pc_to_func(pc)
        -- Strip +offset for function-level grouping
        local base = fname:match("^(.-)%+") or fname
        func_counts[base] = (func_counts[base] or 0) + count
    end

    -- Sort by count descending
    local sorted = {}
    for name, count in pairs(func_counts) do
        sorted[#sorted + 1] = {name = name, count = count}
    end
    table.sort(sorted, function(a, b) return a.count > b.count end)

    -- Machine-readable results
    local f2 = io.open("/tmp/bios_cycle_results.txt", "w")
    f2:write("# bios: " .. bios_label .. "\n")
    f2:write("# pc_samples: " .. pc_samples .. "\n\n")

    f2:write("## timings\n")
    f2:write("# command\tcycles\ttime_sec\n")
    for _, t in ipairs(timings) do
        if t.end_sec then
            local dt = t.end_sec - t.start_sec
            local cycles = dt * Z80_CLOCK
            f2:write(string.format("%s\t%.0f\t%.6f\n", t.cmd, cycles, dt))
        end
    end

    f2:write("\n## profile\n")
    f2:write("# function\tsamples\tpercent\n")
    for _, entry in ipairs(sorted) do
        local pct = 100.0 * entry.count / pc_samples
        f2:write(string.format("%s\t%d\t%.1f\n", entry.name, entry.count, pct))
    end

    f2:write("\n## raw_histogram\n")
    f2:write("# addr\tcount\n")
    -- Sort by address for heatmap view
    local addrs = {}
    for pc, _ in pairs(pc_hist) do addrs[#addrs + 1] = pc end
    table.sort(addrs)
    for _, pc in ipairs(addrs) do
        f2:write(string.format("0x%04X\t%d\n", pc, pc_hist[pc]))
    end

    f2:close()

    -- Print summary to console
    print(string.format("\n=== BIOS Profile: %s (%d samples) ===", bios_label, pc_samples))
    for i, t in ipairs(timings) do
        if t.end_sec then
            local dt = t.end_sec - t.start_sec
            print(string.format("  %s: %.0f cycles (%.3fs)", t.cmd, dt * Z80_CLOCK, dt))
        end
    end
    print("\nTop functions:")
    for i = 1, math.min(15, #sorted) do
        local e = sorted[i]
        print(string.format("  %-30s %4d  %5.1f%%", e.name, e.count, 100.0 * e.count / pc_samples))
    end
end

load_symbols()

emu.register_frame_done(function()
    if done then return end
    frame = frame + 1

    if state == "boot" then
        if at_prompt() then
            state = "post"
            cmd_idx = 0
        elseif frame > 50 * 120 then
            screens[#screens + 1] = "=== TIMEOUT waiting for boot ===\n" .. screen_text()
            write_results()
            done = true; os.exit(0)
        end

    elseif state == "post" then
        cmd_idx = cmd_idx + 1
        if cmd_idx > #commands then
            write_results()
            done = true; os.exit(0)
            return
        end
        manager.machine.natkeyboard:post(commands[cmd_idx])
        prompt_left = false
        timings[cmd_idx] = {
            cmd = commands[cmd_idx]:gsub("\r", ""),
            start_sec = get_seconds(),
        }
        state = "typing"

    elseif state == "typing" then
        if not at_prompt() then
            prompt_left = true
        end
        if manager.machine.natkeyboard.empty and prompt_left then
            state = "execute"
        end

    elseif state == "execute" then
        -- Sample PC every frame during command execution
        sample_pc()

        if at_prompt() then
            timings[cmd_idx].end_sec = get_seconds()
            local dt = timings[cmd_idx].end_sec - timings[cmd_idx].start_sec
            local cycles = dt * Z80_CLOCK
            screens[#screens + 1] = string.format(
                "=== After: %s (%.0f cycles, %.3fs) ===\n%s",
                timings[cmd_idx].cmd, cycles, dt, screen_text()
            )
            state = "post"
        end
    end

    -- Global timeout: 10 minutes
    if frame > 50 * 600 then
        screens[#screens + 1] = "=== TIMEOUT frame " .. frame .. " ===\n" .. screen_text()
        write_results()
        done = true; os.exit(0)
    end
end)

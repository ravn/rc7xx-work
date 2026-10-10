-- Step 1: Run CONFI to set 19200 8N1, save to disk, exit MAME
local FPS = 50
local frame = 0
local done = false
local state = "boot"
local wait_frames = 0

local function mem_read(addr) return manager.machine.devices[":maincpu"].spaces["program"]:read_u8(addr) end
local function at_prompt()
    local curx = mem_read(0xFFD1); local cursy = mem_read(0xFFD4)
    if curx ~= 2 then return false end
    local r = 0xF800 + cursy * 80
    return mem_read(r) == 0x41 and mem_read(r+1) == 0x3E
end

local steps = {
    {FPS*2, "A"},
    {FPS*4, "\r"},
    {FPS*3, "2\r"},     -- Terminal Port
    {FPS*3, "3\r"},     -- Baudrate
    {FPS*3, "11\r"},    -- 19200
    {FPS*3, "2\r"},     -- Parity
    {FPS*3, "2\r"},     -- No parity
    {FPS*3, "4\r"},     -- TX bits
    {FPS*3, "4\r"},     -- 8 bits
    {FPS*3, "5\r"},     -- RX bits
    {FPS*3, "4\r"},     -- 8 bits
    {FPS*3, "\r"},      -- back to main
    {FPS*3, "6\r"},     -- Save
    {FPS*5, "\r"},      -- confirm
}
local step_idx = 1

emu.register_frame_done(function()
    if done then return end
    frame = frame + 1
    if frame > FPS * 120 then print("TIMEOUT"); done = true; manager.machine:exit(); return end

    if state == "boot" then
        if at_prompt() then
            print("Booted, running CONFI")
            manager.machine.natkeyboard:post("CONFI\r")
            state = "confi"; wait_frames = 0
        end
    elseif state == "confi" then
        wait_frames = wait_frames + 1
        if step_idx > #steps then
            if at_prompt() then
                print("CONFI saved, exiting MAME")
                done = true; manager.machine:exit()
            elseif wait_frames > FPS * 30 then
                print("TIMEOUT after save"); done = true; manager.machine:exit()
            end
        else
            if wait_frames >= steps[step_idx][1] then
                manager.machine.natkeyboard:post(steps[step_idx][2])
                step_idx = step_idx + 1; wait_frames = 0
            end
        end
    end
end)

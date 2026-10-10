#!/bin/zsh
# bisect_boot.sh <commit> — checkout, clean build, boot, check for banner
set -e
COMMIT=$1
MAME=/Users/ravn/git/mame
IMG_MAXI="$HOME/Downloads/SW1711-I8.imd"

cd /Users/ravn/z80/rc700-gensmedet/rcbios-in-c

git checkout "$COMMIT" -- . 2>/dev/null

make clang_clean 2>/dev/null
make clang_bios 2>&1 | grep 'clang BIOS:'

cp "$IMG_MAXI" /tmp/bios_clang_maxi.imd
python3 ../rcbios/patch_bios.py /tmp/bios_clang_maxi.imd clang_z80/bios.bin
rm -f /tmp/bios_clang_maxi.mfi
$MAME/floptool flopconvert auto mfi /tmp/bios_clang_maxi.imd /tmp/bios_clang_maxi.mfi >/dev/null 2>&1
rm -f /tmp/bios_clang_maxi.imd

# Need the lua script regardless of commit
cat > /tmp/mame_banner_test.lua <<'LUA'
local frame = 0
local max_frames = 50 * 15
local done = false
local function screen_find(space, str)
    local bytes = {string.byte(str, 1, #str)}
    for addr = 0xF800, 0xF800 + 2000 - #str do
        local match = true
        for i = 1, #bytes do
            if space:read_u8(addr + i - 1) ~= bytes[i] then match = false; break end
        end
        if match then return true end
    end
    return false
end
emu.register_frame_done(function()
    if done then return end
    frame = frame + 1
    if frame % 50 == 0 or frame >= max_frames then
        local space = manager.machine.devices[":maincpu"].spaces["program"]
        if screen_find(space, "A>") or frame >= max_frames then
            local f = io.open("/tmp/mame_screen.txt", "w")
            for row = 0, 24 do
                local line = ""
                for col = 0, 79 do
                    local ch = space:read_u8(0xF800 + row * 80 + col)
                    if ch >= 0x20 and ch < 0x7F then line = line .. string.char(ch)
                    else line = line .. " " end
                end
                f:write(line .. "\n")
            end
            f:close()
            local result = "TIMEOUT"
            if screen_find(space, "A>") then result = "BOOT_OK" end
            if screen_find(space, "C-bios") or screen_find(space, "C-BIOS") then result = result .. "+BANNER" end
            f = io.open("/tmp/mame_result.txt", "w")
            f:write(result .. "\n")
            f:close()
            done = true
            os.exit(0)
        end
    end
end)
LUA

$MAME/regnecentralen rc702 -rompath $MAME/roms \
    -flop1 /tmp/bios_clang_maxi.mfi \
    -skip_gameinfo -window -resolution 1100x720 \
    -autoboot_script /tmp/mame_banner_test.lua >/dev/null 2>&1

RESULT=$(cat /tmp/mame_result.txt)
echo "$COMMIT: $RESULT"

# Restore working tree
git checkout HEAD -- . 2>/dev/null

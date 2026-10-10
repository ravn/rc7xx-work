#!/bin/zsh
# bisect_compiler.sh — Automated compiler bisect for banner bug
#
# For each compiler commit: rebuild clang, rebuild BIOS, boot MAME, screenshot.
# Results logged to /tmp/bisect_results.txt
#
# Usage: ./bisect_compiler.sh [commit1 commit2 ...]
# Default: tests key session #7 commits from newest to oldest

set -e

LLVM_Z80=/Users/ravn/z80/llvm-z80
BIOS_DIR=/Users/ravn/z80/rc700-gensmedet/rcbios-in-c
MAME=/Users/ravn/git/mame
IMG_MAXI="$HOME/Downloads/SW1711-I8.imd"
RESULTS=/tmp/bisect_results.txt
TICKS_TIMEOUT=30  # seconds

# Default commits to test (newest first)
if [ $# -eq 0 ]; then
    COMMITS=(
        07ca0b27b543  # HEAD: Fix #47 R_Z80_ADDR16 wrapping
        1fa0b1251a17  # Session #7: direct addressing, BSS load forwarding
        7911da389fda  # Fix #41: BSS spill→PUSH/POP safety
        39e34a937bbd  # Merge revert IX/IY (#38) — pre-session-7
        011aaddce827  # Revert IX/IY allocation
    )
else
    COMMITS=($@)
fi

# MAME lua script — waits for A>, checks for banner, dumps screen
cat > /tmp/bisect_mame.lua <<'LUA'
local frame = 0
local max_frames = 50 * 30
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
    if frame % 25 == 0 or frame >= max_frames then
        local space = manager.machine.devices[":maincpu"].spaces["program"]
        if screen_find(space, "A>") or frame >= max_frames then
            local f = io.open("/tmp/bisect_screen.txt", "w")
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
            if screen_find(space, "C-bios") or screen_find(space, "CP/M") then
                result = result .. "+BANNER"
            end
            f = io.open("/tmp/bisect_result.txt", "w")
            f:write(result .. "\n")
            f:close()
            done = true
            os.exit(0)
        end
    end
end)
LUA

echo "=== Compiler Bisect: Banner Bug ===" | tee $RESULTS
echo "Date: $(date)" | tee -a $RESULTS
echo "" | tee -a $RESULTS

for commit in $COMMITS; do
    short=${commit:0:12}
    echo "--- Testing compiler commit $short ---" | tee -a $RESULTS

    # 1. Checkout compiler commit
    cd $LLVM_Z80
    desc=$(git log --oneline -1 $commit 2>/dev/null || echo "unknown")
    echo "  Commit: $desc" | tee -a $RESULTS
    git checkout $commit -- . 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "  SKIP: checkout failed" | tee -a $RESULTS
        git checkout HEAD -- . 2>/dev/null
        continue
    fi

    # 2. Rebuild compiler (just clang + lld + tools)
    echo "  Building compiler..." | tee -a $RESULTS
    BUILD_START=$(date +%s)
    docker run --rm -m 8g -v $LLVM_Z80:/src -w /src llvm-z80-build \
        ninja -C build clang lld llvm-objcopy llvm-objdump llvm-nm > /tmp/bisect_build.log 2>&1
    BUILD_RC=$?
    BUILD_END=$(date +%s)
    BUILD_TIME=$(( BUILD_END - BUILD_START ))

    if [ $BUILD_RC -ne 0 ]; then
        echo "  SKIP: compiler build failed (${BUILD_TIME}s)" | tee -a $RESULTS
        git checkout HEAD -- . 2>/dev/null
        continue
    fi
    echo "  Compiler built (${BUILD_TIME}s)" | tee -a $RESULTS

    # 3. Clean build BIOS
    cd $BIOS_DIR
    make clang_clean >/dev/null 2>&1
    BIOS_OUT=$(make clang_bios 2>&1)
    BIOS_SIZE=$(echo "$BIOS_OUT" | grep 'clang BIOS:' | awk '{print $3}')
    if [ -z "$BIOS_SIZE" ]; then
        echo "  SKIP: BIOS build failed" | tee -a $RESULTS
        cd $LLVM_Z80 && git checkout HEAD -- . 2>/dev/null
        continue
    fi
    echo "  BIOS: ${BIOS_SIZE} bytes" | tee -a $RESULTS

    # 4. Boot in MAME with screenshot
    cp "$IMG_MAXI" /tmp/bios_clang_maxi.imd
    python3 ../rcbios/patch_bios.py /tmp/bios_clang_maxi.imd clang_z80/bios.bin 2>/dev/null
    rm -f /tmp/bios_clang_maxi.mfi
    $MAME/floptool flopconvert auto mfi /tmp/bios_clang_maxi.imd /tmp/bios_clang_maxi.mfi >/dev/null 2>&1
    rm -f /tmp/bios_clang_maxi.imd
    rm -f /tmp/bisect_result.txt /tmp/bisect_screen.txt

    $MAME/regnecentralen rc702 -rompath $MAME/roms \
        -flop1 /tmp/bios_clang_maxi.mfi \
        -skip_gameinfo -window -resolution 1100x720 \
        -autoboot_script /tmp/bisect_mame.lua >/dev/null 2>&1

    MAME_RESULT=$(cat /tmp/bisect_result.txt 2>/dev/null || echo "MAME_FAIL")
    echo "  Result: $MAME_RESULT" | tee -a $RESULTS

    # Save screen dump
    if [ -f /tmp/bisect_screen.txt ]; then
        SCREEN_LINE1=$(head -1 /tmp/bisect_screen.txt | sed 's/ *$//')
        SCREEN_LINE2=$(sed -n '2p' /tmp/bisect_screen.txt | sed 's/ *$//')
        [ -n "$SCREEN_LINE1" ] && echo "  Screen[0]: '$SCREEN_LINE1'" | tee -a $RESULTS
        [ -n "$SCREEN_LINE2" ] && echo "  Screen[1]: '$SCREEN_LINE2'" | tee -a $RESULTS
    fi

    echo "" | tee -a $RESULTS

    # Restore compiler to HEAD
    cd $LLVM_Z80
    git checkout HEAD -- . 2>/dev/null
done

# Restore compiler to current HEAD and rebuild
echo "=== Restoring compiler to HEAD ===" | tee -a $RESULTS
cd $LLVM_Z80
docker run --rm -m 8g -v $LLVM_Z80:/src -w /src llvm-z80-build \
    ninja -C build clang lld llvm-objcopy llvm-objdump llvm-nm > /tmp/bisect_build.log 2>&1
echo "Done. Results in $RESULTS" | tee -a $RESULTS

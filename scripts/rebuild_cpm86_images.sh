#!/bin/sh
# rebuild_cpm86_images.sh -- build the CP/M-86 Docker toolchain images on a
# remote Linux build host and stream them into the local Docker.
#
# Run this ON THE MAC after pulling workspace changes.  It:
#   1. Syncs the workspace to the build host (git pull + submodule update)
#   2. Builds Open Watcom V2 (compiler + linker + all CP/M-86 clib models)
#   3. Packages it as 'open-watcom-cpm86:latest'
#   4. Builds emu2-cpm86 (CP/M-86 emulator with P_LOAD relocation)
#   5. Packages it as 'emu2-cpm86:latest'
#   6. Streams both images to the local Docker via ssh | docker load
#
# Usage:
#   scripts/rebuild_cpm86_images.sh                   # sonnyboy.local, both images
#   scripts/rebuild_cpm86_images.sh HOST              # different build host
#   scripts/rebuild_cpm86_images.sh HOST --ow-only    # Open Watcom image only
#   scripts/rebuild_cpm86_images.sh HOST --emu2-only  # emu2 image only
#   OW_BUILD_HOST=mybox scripts/rebuild_cpm86_images.sh
#
# Prerequisites (on the build host):
#   - scripts/setup-ubuntu.sh has been run
#   - Docker is installed and the user is in the docker group
#   - The workspace is cloned at ~/z80 with submodules
#
# Open Watcom build takes 30-60 min on first run.  Subsequent runs are fast
# because the build system is incremental.  The clib model build (appended to
# the Docker packaging step) takes ~2 min.  emu2 takes <1 min.
#
# See SONNYBOY.md for the full workflow and troubleshooting notes.
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

HOST=${1:-${OW_BUILD_HOST:-sonnyboy.local}}
# Parse --ow-only / --emu2-only flags (may come before or after HOST)
BUILD_OW=1; BUILD_EMU2=1
for arg in "$@"; do
    case "$arg" in
        --ow-only)   BUILD_EMU2=0 ;;
        --emu2-only) BUILD_OW=0 ;;
    esac
done

echo "==> build host: $HOST"
command -v docker >/dev/null 2>&1 || { echo "!! docker not found on PATH" >&2; exit 1; }
docker info >/dev/null 2>&1 || { echo "!! local Docker daemon not running (start Docker Desktop)" >&2; exit 1; }

# --- sync workspace on build host ---
echo "==> syncing workspace on $HOST"
ssh "$HOST" 'cd ~/z80 && git pull --ff-only && git submodule update --init'

# --- Open Watcom ---
if [ "$BUILD_OW" = 1 ]; then
    echo "==> building Open Watcom (compiler + clib s/m/c/l + Docker image)"
    ssh "$HOST" 'cd ~/z80 && sh scripts/build_open_watcom.sh > /tmp/ow-build.log 2>&1' || {
        echo "!! Open Watcom build failed -- check /tmp/ow-build.log on $HOST" >&2
        exit 1
    }
    ssh "$HOST" 'cd ~/z80 && sh scripts/build_open_watcom_docker.sh'
    echo "==> streaming open-watcom-cpm86:latest -> local docker"
    sh "$SCRIPT_DIR/load_open_watcom_image.sh" "$HOST" open-watcom-cpm86:latest
fi

# --- emu2-cpm86 ---
if [ "$BUILD_EMU2" = 1 ]; then
    echo "==> building emu2-cpm86 (CP/M-86 emulator)"
    ssh "$HOST" 'cd ~/z80 && sh scripts/build_emu2_docker.sh'
    echo "==> streaming emu2-cpm86:latest -> local docker"
    sh "$SCRIPT_DIR/load_open_watcom_image.sh" "$HOST" emu2-cpm86:latest
fi

echo
echo "==> done.  Images now in local Docker:"
docker image ls open-watcom-cpm86:latest emu2-cpm86:latest 2>/dev/null | grep -v "^REPO"
echo
echo "Quick test:"
echo "  docker run --rm --platform linux/amd64 open-watcom-cpm86:latest owcc -v"
echo "  docker run --rm --platform linux/amd64 emu2-cpm86:latest emu2 -v"

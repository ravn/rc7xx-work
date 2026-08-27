#!/bin/sh
# build_open_watcom_docker.sh -- package a Linux-x64 Open Watcom `rel/` build
# artifact into a Docker image (unpacks the artifact into a slim base image, per
# scripts/open-watcom.Dockerfile).
#
# Run this on a Linux x64 host AFTER a build (scripts/build_open_watcom.sh), so
# `rel/binl64/` holds the statically-linked linux-x64 tools.  The macOS `rel/`
# holds Mach-O binaries and will NOT work in a Linux container -- build the
# artifact on Linux (e.g. sonnyboy) first.
#
# Usage:
#   scripts/build_open_watcom_docker.sh                 # tag open-watcom-cpm86:latest
#   IMAGE=ghcr.io/ravn/open-watcom:v2 scripts/build_open_watcom_docker.sh
#   OWROOT=/path scripts/build_open_watcom_docker.sh
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
OWROOT=${OWROOT:-${1:-"$SCRIPT_DIR/../open-watcom-v2"}}
IMAGE=${IMAGE:-open-watcom-cpm86:latest}
DOCKERFILE="$SCRIPT_DIR/open-watcom.Dockerfile"
REL="$OWROOT/rel"

# --- sanity: a Linux-x64 rel/ artifact must exist ----------------------------
if [ ! -x "$REL/binl64/owcc" ]; then
    echo "!! no Linux-x64 artifact at $REL/binl64/owcc" >&2
    echo "   build it first on a Linux host:  scripts/build_open_watcom.sh" >&2
    exit 1
fi
if command -v file >/dev/null 2>&1 && ! file "$REL/binl64/owcc" | grep -q 'x86-64'; then
    echo "!! $REL/binl64/owcc is not an x86-64 ELF -- is this a Linux build?" >&2
    exit 1
fi
command -v docker >/dev/null 2>&1 || { echo "!! docker not found on PATH" >&2; exit 1; }

# --- build CP/M-86 clib (all models) and install into rel/ -------------------
# build-lib.sh installs to $OW/lib286/cpm86/ (OW root, not rel/), and that
# directory is gitignored -- so the clib must be (re)built here, using the
# Linux-x64 tools from rel/binl64/, before the Docker context is assembled.
# The OMF object files are 8086 target code: host-independent, so a Linux-built
# clib is byte-for-byte equivalent to a macOS-built one from the same source.
echo "==> building CP/M-86 clib (models: s m c l)"
CLIB_DIR="$OWROOT/contrib/ravn/watcom-cpm86-libc"
for MODEL in s m c l; do
    echo "    model=$MODEL"
    MODEL="$MODEL" \
    OW="$OWROOT" \
    OWCC_BIN="$REL/binl64/wcc" \
    OWASM_BIN="$REL/binl64/wasm" \
    OWLIB_BIN="$REL/binl64/wlib" \
    OUTDIR="$CLIB_DIR/build-lib-${MODEL}-docker" \
        sh "$CLIB_DIR/build-lib.sh"
done
echo "==> installing clib into rel/lib286/cpm86/"
mkdir -p "$REL/lib286/cpm86"
cp "$OWROOT/lib286/cpm86/"*.lib "$REL/lib286/cpm86/"
cp "$OWROOT/lib286/cpm86/"cstart*.obj "$REL/lib286/cpm86/"

echo "==> packaging $REL  ($(du -sh "$REL" 2>/dev/null | cut -f1)) -> image '$IMAGE'"
# Build context is rel/ itself (the Dockerfile COPYs '.' -> /opt/watcom).
docker build -f "$DOCKERFILE" -t "$IMAGE" "$REL"

echo "==> smoke test: owcc in the image"
docker run --rm "$IMAGE" owcc -v 2>&1 | head -1 || true

echo
echo "==> done.  Image: $IMAGE"
echo "    run:   docker run --rm -it -v \"\$PWD\":/work $IMAGE"
echo "    then:  owcc -bcpm86 hello.c -o hello.cmd    (CP/M-86 is a first-class target)"

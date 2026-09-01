#!/bin/sh
# build_open_watcom_docker.sh -- package a Linux Open Watcom `rel/` build
# artifact into a Docker image (linux/amd64 or linux/arm64).
#
# Supports two architectures:
#   amd64 (default on x86-64 hosts): tools from rel/binl64/
#   arm64 (default on aarch64 hosts): tools from rel/arml64/
#
# Run this AFTER a `rel` build (scripts/build_open_watcom.sh) on the matching
# Linux host so the right statically-linked tools exist under rel/.
# The macOS `rel/armo64/` or `rel/bino64/` binaries are Mach-O and cannot be
# used inside a Linux container -- build on Linux (sonnyboy or GitHub Actions).
#
# Usage:
#   scripts/build_open_watcom_docker.sh                 # auto-detect arch
#   scripts/build_open_watcom_docker.sh --arch amd64    # explicit
#   scripts/build_open_watcom_docker.sh --arch arm64
#   ARCH=arm64 IMAGE=ghcr.io/ravn/open-watcom-cpm86:arm64 scripts/build_open_watcom_docker.sh
#   OWROOT=/path scripts/build_open_watcom_docker.sh
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
DOCKERFILE="$SCRIPT_DIR/open-watcom.Dockerfile"

# --- parse arguments ---------------------------------------------------------
while [ $# -gt 0 ]; do
    case "$1" in
        --arch)    ARCH="$2";   shift 2 ;;
        --arch=*)  ARCH="${1#--arch=}"; shift ;;
        --owroot)  OWROOT="$2"; shift 2 ;;
        --owroot=*) OWROOT="${1#--owroot=}"; shift ;;
        *)         shift ;;
    esac
done

OWROOT=${OWROOT:-"$SCRIPT_DIR/../open-watcom-v2"}
REL="$OWROOT/rel"

# auto-detect from host if not specified
if [ -z "${ARCH:-}" ]; then
    case "$(uname -m)" in
        x86_64)  ARCH=amd64 ;;
        aarch64) ARCH=arm64 ;;
        *)
            echo "!! cannot auto-detect Docker arch from host '$(uname -m)'" >&2
            echo "   pass --arch amd64 or --arch arm64 explicitly" >&2
            exit 1
        ;;
    esac
fi

case "$ARCH" in
    amd64) BINDIR=binl64; ELF_ARCH="x86-64" ;;
    arm64) BINDIR=arml64; ELF_ARCH="aarch64" ;;
    *)
        echo "!! unsupported arch '$ARCH' -- use amd64 or arm64" >&2
        exit 1
    ;;
esac

IMAGE=${IMAGE:-"open-watcom-cpm86:$ARCH"}

echo "==> arch=$ARCH  bindir=$BINDIR  image=$IMAGE"

# --- sanity: a Linux rel/ artifact for this arch must exist ------------------
if [ ! -x "$REL/$BINDIR/owcc" ]; then
    echo "!! no Linux-$ARCH artifact at $REL/$BINDIR/owcc" >&2
    echo "   build it first on a Linux $ARCH host:  scripts/build_open_watcom.sh" >&2
    exit 1
fi
if command -v file >/dev/null 2>&1 && ! file "$REL/$BINDIR/owcc" | grep -q "$ELF_ARCH"; then
    echo "!! $REL/$BINDIR/owcc is not a $ELF_ARCH ELF -- wrong arch build?" >&2
    exit 1
fi
command -v docker >/dev/null 2>&1 || { echo "!! docker not found on PATH" >&2; exit 1; }

# --- build CP/M-86 clib (all models: s m c l) and install into rel/ ----------
# build-lib.sh installs to $OW/lib286/cpm86/ (OW root, not rel/), and that
# directory is gitignored -- so the clib must be (re)built here before the
# Docker context is assembled.
#
# The CP/M-86 clib produces 8086 OMF object files -- host-independent target
# code.  So we can use whatever OW host tools ARE executable on this machine:
# on Linux use the Linux tools ($BINDIR); on macOS use the matching native tools
# (armo64 for arm64, bino64 for x64).  The clib output is byte-for-byte
# identical regardless of which host compiled it.
case "$(uname -s)-$(uname -m)" in
    Linux-x86_64)  CLIB_BINDIR="$BINDIR" ;;   # binl64 -- same as Docker target
    Linux-aarch64) CLIB_BINDIR="$BINDIR" ;;   # arml64 -- same as Docker target
    Darwin-arm64)  CLIB_BINDIR="armo64"  ;;   # native macOS arm64 tools
    Darwin-x86_64) CLIB_BINDIR="bino64"  ;;   # native macOS x64 tools
    *) echo "!! unsupported host for clib build: $(uname -s)-$(uname -m)" >&2; exit 1 ;;
esac
echo "==> building CP/M-86 clib (models: s m c l) using $CLIB_BINDIR tools"
CLIB_DIR="$OWROOT/contrib/ravn/watcom-cpm86-libc"
for MODEL in s m c l; do
    echo "    model=$MODEL"
    MODEL="$MODEL" \
    OW="$OWROOT" \
    OWCC_BIN="$REL/$CLIB_BINDIR/wcc" \
    OWASM_BIN="$REL/$CLIB_BINDIR/wasm" \
    OWLIB_BIN="$REL/$CLIB_BINDIR/wlib" \
    OUTDIR="$CLIB_DIR/build-lib-${MODEL}-docker" \
        sh "$CLIB_DIR/build-lib.sh"
done
echo "==> installing clib into rel/lib286/cpm86/"
mkdir -p "$REL/lib286/cpm86"
cp "$OWROOT/lib286/cpm86/"*.lib "$REL/lib286/cpm86/"
cp "$OWROOT/lib286/cpm86/"cstart*.obj "$REL/lib286/cpm86/"

echo "==> packaging $REL  ($(du -sh "$REL" 2>/dev/null | cut -f1)) -> image '$IMAGE' (linux/$ARCH)"
# Build context is rel/ itself (the Dockerfile COPYs '.' -> /opt/watcom).
docker build \
    --platform "linux/$ARCH" \
    --build-arg "BINDIR=$BINDIR" \
    -f "$DOCKERFILE" \
    -t "$IMAGE" \
    "$REL"

echo "==> smoke test: owcc in the image"
docker run --rm --platform "linux/$ARCH" "$IMAGE" owcc -v 2>&1 | head -1 || true

echo "==> smoke test: cpm86 clib present in image"
docker run --rm --platform "linux/$ARCH" "$IMAGE" \
    ls /opt/watcom/lib286/cpm86/clibs.lib \
       /opt/watcom/lib286/cpm86/clibm.lib \
       /opt/watcom/lib286/cpm86/clibc.lib \
       /opt/watcom/lib286/cpm86/clibl.lib \
    && echo "    all 4 clib models present." \
    || echo "    !! clib smoke test FAILED"

echo
echo "==> done.  Image: $IMAGE  (linux/$ARCH)"
echo "    run:   docker run --rm -it --platform linux/$ARCH -v \"\$PWD\":/work $IMAGE"
echo "    then:  owcc -bcpm86 hello.c -o hello.cmd"
echo
echo "    To create a multi-arch manifest after building both arches:"
echo "    docker manifest create open-watcom-cpm86:latest \\"
echo "        --amend open-watcom-cpm86:amd64 \\"
echo "        --amend open-watcom-cpm86:arm64"
echo "    docker manifest push open-watcom-cpm86:latest"

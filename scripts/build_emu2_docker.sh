#!/bin/sh
# build_emu2_docker.sh -- build the emu2-cpm86 binary and package it as a
# Docker image.  Run on a Linux x86-64 host (e.g. sonnyboy).
#
# Usage:
#   scripts/build_emu2_docker.sh                 # tag emu2-cpm86:latest
#   IMAGE=emu2-cpm86:v1 scripts/build_emu2_docker.sh
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO="${SCRIPT_DIR}/../emu2-cpm86"
IMAGE="${IMAGE:-emu2-cpm86:latest}"
DOCKERFILE="${SCRIPT_DIR}/emu2-cpm86.Dockerfile"

if [ ! -f "$REPO/GNUmakefile" ]; then
    echo "!! emu2-cpm86 source not found at $REPO" >&2
    exit 1
fi
command -v docker >/dev/null 2>&1 || { echo "!! docker not found" >&2; exit 1; }

echo "==> building emu2-cpm86 binary"
make -C "$REPO" -j"$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 4)"

echo "==> packaging -> image '$IMAGE'"
docker build -f "$DOCKERFILE" -t "$IMAGE" "$REPO"

echo "==> smoke test"
docker run --rm "$IMAGE" emu2 -v 2>&1 | head -1

echo
echo "==> done.  run: docker run --rm -it -v \"\$PWD\":/work $IMAGE"

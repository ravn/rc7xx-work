#!/bin/sh
# load_open_watcom_image.sh -- stream the open-watcom Docker image from a remote
# Linux build host straight into the LOCAL Docker (e.g. Docker Desktop on the
# Mac) with no registry: `ssh <host> docker save <image> | docker load`.
#
# Run this ON the machine whose Docker you want the image in (the Mac).  The
# image is built on the Linux host with build_open_watcom_docker.sh.
#
# Usage:
#   scripts/load_open_watcom_image.sh                       # sonnyboy.local, open-watcom-cpm86:latest
#   scripts/load_open_watcom_image.sh HOST                  # other build host
#   scripts/load_open_watcom_image.sh HOST IMAGE            # other image tag
#   OW_BUILD_HOST=box IMAGE=open-watcom:v2 scripts/load_open_watcom_image.sh
set -e

HOST=${1:-${OW_BUILD_HOST:-sonnyboy.local}}
IMAGE=${2:-${IMAGE:-open-watcom-cpm86:latest}}

command -v docker >/dev/null 2>&1 || { echo "!! docker not found on PATH" >&2; exit 1; }
docker info >/dev/null 2>&1 || { echo "!! local Docker daemon not running (start Docker Desktop)" >&2; exit 1; }

# fail early if the image is not on the remote host
if ! ssh "$HOST" "docker image inspect $IMAGE >/dev/null 2>&1"; then
    echo "!! image '$IMAGE' not found on $HOST" >&2
    echo "   build it there first:  scripts/build_open_watcom_docker.sh" >&2
    exit 1
fi

echo "==> streaming '$IMAGE' from $HOST -> local docker (save | load) ..."
ssh "$HOST" "docker save $IMAGE" | docker load

echo "==> present locally:"
docker image ls "$IMAGE"
echo
echo "    The image is linux/amd64; on an Apple-Silicon Mac it runs via emulation."
echo "    run:  docker run --rm -it --platform linux/amd64 -v \"\$PWD\":/work $IMAGE"

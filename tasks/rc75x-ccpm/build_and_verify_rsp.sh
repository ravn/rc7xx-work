#!/usr/bin/env bash
# Byg de standalone .RSP-moduler (CLOCK, PIN, SCROLL, TMP759, VOUT, NETDRV, NETDRVB) fra
# kilderne og verificér byte-identitet mod SW1400-disk-oraklerne i
# dist/genccpm-kit/ (ekstraheret fra scratch/rc759-pce/images/disk2.img).
# Afslutter med exit 1 ved enhver fejl.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

DOCKER_BIN="${DOCKER_BIN:-docker}"
if [ -x "/Users/ravn/.docker/bin/docker" ]; then
    DOCKER_BIN="/Users/ravn/.docker/bin/docker"
fi

KIT="$SCRIPT_DIR/dist/genccpm-kit"
if [ ! -d "$KIT" ]; then
    echo "FEJL: Orakel-mappe mangler: $KIT" >&2
    exit 1
fi

fail=0
for m in clock pin scroll tmp759 vout netdrv netdrvb; do
    src="${m}_rsp.asm"
    if [ "$m" = "netdrv" ] || [ "$m" = "netdrvb" ]; then
        src="${m}.asm"
    fi
    out="$ROOT_DIR/scratch/tmp/${m}_built.rsp"
    mkdir -p "$ROOT_DIR/scratch/tmp"
    "$DOCKER_BIN" run --rm \
        -v "$ROOT_DIR:/work" \
        -w /work/tasks/rc75x-ccpm \
        rc759-nasm \
        nasm -f bin -I. -o "/work/scratch/tmp/${m}_built.rsp" "$src" > /dev/null
    if cmp -s "$out" "$KIT/${m}.rsp"; then
        echo "PASS ${m}.rsp ($(wc -c < "$out" | tr -d ' ') B)"
    else
        echo "FAIL ${m}.rsp"
        cmp "$out" "$KIT/${m}.rsp" || true
        fail=1
    fi
done
exit $fail

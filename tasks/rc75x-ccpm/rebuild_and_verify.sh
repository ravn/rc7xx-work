#!/usr/bin/env bash
# Gen-assemblér ccpm.asm med rc759-nasm og verificér 100% byte-identitet mod ccpm.sys
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

DOCKER_BIN="${DOCKER_BIN:-docker}"
if [ -x "/Users/ravn/.docker/bin/docker" ]; then
    DOCKER_BIN="/Users/ravn/.docker/bin/docker"
fi

if [ -e "$HOME/.docker/run/docker.sock" ]; then
    export DOCKER_HOST="unix://$HOME/.docker/run/docker.sock"
fi

OUTPUT_FILE="$ROOT_DIR/scratch/tmp/ccpm_final.sys"
# Versioneret oracle i dist/ (primær); fallback til scratch/tmp for bagudkompatibilitet.
REFERENCE_FILE="$SCRIPT_DIR/dist/ccpm.sys"
if [ ! -f "$REFERENCE_FILE" ]; then
    REFERENCE_FILE="$ROOT_DIR/scratch/tmp/ccpm.sys"
fi

if [ ! -f "$REFERENCE_FILE" ]; then
    echo "FEJL: Referencefilen $REFERENCE_FILE findes ikke!" >&2
    exit 1
fi

echo "=== Gen-assemblerer ccpm.asm i rc759-nasm container ==="
"$DOCKER_BIN" run --rm \
    -v "$ROOT_DIR:/work" \
    -w /work/tasks/rc75x-ccpm \
    rc759-nasm \
    nasm -f bin -o /work/scratch/tmp/ccpm_final.sys ccpm.asm

echo "=== Verificerer binær lighed mod original ccpm.sys ==="
if cmp -s "$OUTPUT_FILE" "$REFERENCE_FILE"; then
    SIZE=$(stat -f%z "$OUTPUT_FILE" 2>/dev/null || stat -c%s "$OUTPUT_FILE")
    echo "SUCCESS: $SIZE bytes — 100% byte-identisk mod original ccpm.sys!"
    exit 0
else
    echo "FEJL: Output afviger fra referencefilen!" >&2
    cmp "$OUTPUT_FILE" "$REFERENCE_FILE" || true
    exit 1
fi

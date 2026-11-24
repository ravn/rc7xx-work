#!/usr/bin/env bash
# Byg XIOS1.CON og XIOS4.CON og verificér mod originalerne
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

echo "=== Bygger XIOS1.CON (1 konsol) ==="
"$DOCKER_BIN" run --rm \
    -v "$ROOT_DIR:/work" \
    -w /work/tasks/rc759-xios \
    rc759-nasm \
    nasm -f bin -DNUM_VIR_CONS=1 -I. -o /work/scratch/tmp/xios1_built.con xios.asm

echo "=== Bygger XIOS4.CON (4 konsoller) ==="
"$DOCKER_BIN" run --rm \
    -v "$ROOT_DIR:/work" \
    -w /work/tasks/rc759-xios \
    rc759-nasm \
    nasm -f bin -DNUM_VIR_CONS=4 -I. -o /work/scratch/tmp/xios4_built.con xios.asm

echo "=== Verificerer mod originaler ==="
REF_DIR="$ROOT_DIR/scratch/tmp/dist"
if [ -f "$REF_DIR/XIOS1.CON" ]; then
    cmp -s /work/scratch/tmp/xios1_built.con "$REF_DIR/XIOS1.CON" && echo "XIOS1.CON: 100% byte-identisk!"
fi
if [ -f "$REF_DIR/XIOS4.CON" ]; then
    cmp -s /work/scratch/tmp/xios4_built.con "$REF_DIR/XIOS4.CON" && echo "XIOS4.CON: 100% byte-identisk!"
fi
echo "XIOS build fuldført med succes."

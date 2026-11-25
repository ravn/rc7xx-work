#!/usr/bin/env bash
# Byg XIOS1.CON og XIOS4.CON og verificér byte-identitet mod originalerne.
# Afslutter med exit 1 ved enhver fejl, inkl. manglende reference eller forskel.
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

OUT1="$ROOT_DIR/scratch/tmp/xios1_built.con"
OUT4="$ROOT_DIR/scratch/tmp/xios4_built.con"
# Primær reference: versioneret kopi i tasks/rc759-xios/dist/ (fallback: scratch/tmp/dist)
REF_DIR="$SCRIPT_DIR/dist"
if [ ! -d "$REF_DIR" ]; then
    REF_DIR="$ROOT_DIR/scratch/tmp/dist"
fi

# Verifikér at referencer eksisterer FØR byg
if [ ! -f "$REF_DIR/XIOS1.CON" ]; then
    echo "FEJL: Reference mangler: $REF_DIR/XIOS1.CON" >&2
    exit 1
fi
if [ ! -f "$REF_DIR/XIOS4.CON" ]; then
    echo "FEJL: Reference mangler: $REF_DIR/XIOS4.CON" >&2
    exit 1
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
FAIL=0

if cmp -s "$OUT1" "$REF_DIR/XIOS1.CON"; then
    echo "XIOS1.CON: 100% byte-identisk!"
else
    echo "FEJL: XIOS1.CON afviger ($(cmp -l "$OUT1" "$REF_DIR/XIOS1.CON" | wc -l | tr -d ' ') bytes)" >&2
    FAIL=1
fi

if cmp -s "$OUT4" "$REF_DIR/XIOS4.CON"; then
    echo "XIOS4.CON: 100% byte-identisk!"
else
    echo "FEJL: XIOS4.CON afviger ($(cmp -l "$OUT4" "$REF_DIR/XIOS4.CON" | wc -l | tr -d ' ') bytes)" >&2
    FAIL=1
fi

if [ "$FAIL" -eq 0 ]; then
    echo "XIOS build verificeret OK."
    exit 0
else
    exit 1
fi

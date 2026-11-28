#!/usr/bin/env bash
# Byg rc759-nasm Docker-image
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"

DOCKER_BIN="${DOCKER_BIN:-docker}"
if [ -x "/Users/ravn/.docker/bin/docker" ]; then
    DOCKER_BIN="/Users/ravn/.docker/bin/docker"
fi

if [ -e "$HOME/.docker/run/docker.sock" ]; then
    export DOCKER_HOST="unix://$HOME/.docker/run/docker.sock"
fi

echo "=== Bygger rc759-nasm Docker-image ==="
"$DOCKER_BIN" build -t rc759-nasm "$SCRIPT_DIR"
echo "=== Byg gennemført: rc759-nasm er klar ==="

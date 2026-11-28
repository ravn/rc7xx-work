#!/bin/sh
# Installér XIOS pre-commit hook i det aktuelle git-repo.
# Kør fra workspace-roden: sh tasks/rc75x-ccpm/hooks/install.sh

set -e

ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "FEJL: ikke i et git-repo" >&2; exit 1; }
HOOK_SRC="$ROOT/tasks/rc75x-ccpm/hooks/pre-commit"
HOOK_DST="$ROOT/.git/hooks/pre-commit"

if [ ! -f "$HOOK_SRC" ]; then
    echo "FEJL: $HOOK_SRC ikke fundet" >&2
    exit 1
fi

cp "$HOOK_SRC" "$HOOK_DST"
chmod +x "$HOOK_DST"
echo "Pre-commit hook installeret: $HOOK_DST"

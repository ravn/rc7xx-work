#!/bin/sh
# install-mame-cfg.sh -- generate mame/cfg/ entries from scripts/cfg/*.cfg.in
# templates by substituting @WORKSPACE@ with the actual workspace root.
#
# Run once after a fresh checkout (or after moving the workspace):
#   sh scripts/install-mame-cfg.sh
#
# The generated files are written to mame/cfg/ which is gitignored (MAME
# regenerates it on every run anyway, but keeps any entries we set).

set -e
WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"
TMPL_DIR="$WORKSPACE/scripts/cfg"
OUT_DIR="$WORKSPACE/mame/cfg"

[ -d "$OUT_DIR" ] || { echo "mame/cfg/ not found -- is the mame submodule checked out?"; exit 1; }

for tmpl in "$TMPL_DIR"/*.cfg.in; do
    base=$(basename "$tmpl" .in)
    out="$OUT_DIR/$base"
    sed "s|@WORKSPACE@|$WORKSPACE|g" "$tmpl" > "$out"
    echo "wrote $out"
done
echo "done -- MAME cfg installed for workspace: $WORKSPACE"

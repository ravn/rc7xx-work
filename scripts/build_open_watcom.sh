#!/bin/sh
# build_open_watcom.sh -- build the workspace's Open Watcom v2 tree on the
# current host.  Linux and macOS are supported; Windows is out of scope.
#
#   macOS  -> OWTOOLS=CLANG, needs the Xcode Command Line Tools (clang + make).
#   Linux  -> OWTOOLS=GCC, assumes Ubuntu/Debian; verifies (and apt-get installs)
#             the required packages before building.
#
# The tree is `open-watcom-v2/` next to this script's parent (the workspace
# root).  Override the location with OWROOT=/path or the 1st argument.  The
# builder target defaults to `rel` (matching the tree already built on the
# macbook, see open-watcom-v2/build-rel-macos.log); pass a different target as
# the 2nd argument (e.g. `boot` to only bootstrap wmake, or an empty string
# "" for the plain development build).
#
# Usage:
#   scripts/build_open_watcom.sh                  # build in ../open-watcom-v2
#   OWROOT=/path scripts/build_open_watcom.sh     # explicit tree
#   scripts/build_open_watcom.sh "" boot          # bootstrap only
#
# NOTE: no `set -u` -- Open Watcom's own cmnvars.sh / build.sh reference unset
# variables by design (e.g. OWOBJDIR), so nounset would break sourcing them.
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
OWROOT=${OWROOT:-${1:-"$SCRIPT_DIR/../open-watcom-v2"}}
BUILD_TARGET=${2:-rel}

# --- locate the Open Watcom tree ---------------------------------------------
if [ ! -f "$OWROOT/setvars.sh" ] || [ ! -f "$OWROOT/build.sh" ]; then
    echo "!! not an Open Watcom v2 tree: $OWROOT" >&2
    echo "   pass the tree as the 1st arg or set OWROOT=/path/to/open-watcom-v2" >&2
    exit 1
fi
OWROOT=$(cd "$OWROOT" && pwd)

# print the arguments that are NOT on PATH
missing_cmds() { for c in "$@"; do command -v "$c" >/dev/null 2>&1 || printf ' %s' "$c"; done; }

OS=$(uname -s)
case "$OS" in
Darwin)
    OWTOOLS=CLANG
    OWDOSBOX=dosbox-x     # CI uses dosbox-x on macOS to run the DOS doc/help tools
    echo "==> host: macOS -> OWTOOLS=CLANG"
    miss=$(missing_cmds clang make)
    if [ -n "$miss" ]; then
        echo "!! missing build tools:$miss" >&2
        echo "   install the Xcode Command Line Tools:  xcode-select --install" >&2
        exit 1
    fi
    echo "   clang + make present."
    ;;
Linux)
    OWTOOLS=GCC
    OWDOSBOX=dosbox      # OW runs DOS wgml under dosbox to build browser/GUI .gh help
    echo "==> host: Linux -> OWTOOLS=GCC (assuming Ubuntu/Debian)"
    # Open Watcom v2 bootstraps its own tools; the host needs a C/C++ compiler +
    # GNU make + the C library headers (build-essential = gcc, g++, make,
    # binutils, libc6-dev), plus dosbox to run the DOS-hosted doc/help tools that
    # the full `rel` build needs (matches the GitHub CI, which installs dosbox
    # and sets OWDOSBOX=dosbox).
    REQ_PKGS="build-essential dosbox"
    miss_cmds=$(missing_cmds gcc g++ make)
    miss_pkgs=""
    if command -v dpkg >/dev/null 2>&1; then
        for p in $REQ_PKGS; do
            dpkg -s "$p" >/dev/null 2>&1 || miss_pkgs="$miss_pkgs $p"
        done
    else
        echo "   (no dpkg -- cannot verify packages by name; checking commands only)"
    fi
    if [ -n "$miss_cmds" ] || [ -n "$miss_pkgs" ]; then
        echo "   missing commands:${miss_cmds:- none}"
        echo "   missing packages:${miss_pkgs:- none}"
        [ "$(id -u)" = 0 ] && SUDO="" || SUDO="sudo"
        if [ -n "$SUDO" ] && ! command -v sudo >/dev/null 2>&1; then
            echo "!! need to install:$REQ_PKGS  but neither root nor sudo is available." >&2
            echo "   run as root:  apt-get update && apt-get install -y$REQ_PKGS" >&2
            exit 1
        fi
        echo "==> installing:  ${SUDO:+sudo }apt-get install -y$REQ_PKGS"
        $SUDO apt-get update
        # shellcheck disable=SC2086
        $SUDO apt-get install -y $REQ_PKGS
    else
        echo "   all required packages present ($REQ_PKGS)."
    fi
    ;;
*)
    echo "!! unsupported host '$OS' -- only Linux and macOS are supported." >&2
    exit 1
    ;;
esac

# --- set the Open Watcom build environment -----------------------------------
# Replicates setvars.sh but with the host-correct OWTOOLS (setvars.sh hardcodes
# GCC).  cmnvars.sh derives OWOBJDIR / per-host object dirs from uname.
cd "$OWROOT"
export OWROOT OWTOOLS OWDOSBOX
export OWDOCBUILD=0        # skip the big DOS/dosbox manual (PDF/HTML) doc set
export OWDISTRBUILD=0      # skip building the distribution installers
# cmnvars.sh + build.sh assume plain-shell semantics (unset vars, non-zero
# intermediate exits), so relax -e while they run and check build.sh explicitly.
set +e
# shellcheck disable=SC1090
. "$OWROOT/cmnvars.sh"

echo "==> OWROOT=$OWROOT"
echo "==> OWTOOLS=$OWTOOLS  target='${BUILD_TARGET:-<dev>}'  (this takes a while)"
# build.sh keeps our exported OWROOT (so it will NOT re-source the GCC-hardcoded
# setvars.sh) and drives the bootstrap + full build.
# shellcheck disable=SC2086
sh ./build.sh $BUILD_TARGET
rc=$?
if [ "$rc" != 0 ]; then
    echo "!! Open Watcom build failed (exit $rc)" >&2
    echo "   see $OWROOT/build/binbuild/bootx.log for the bootstrap log." >&2
    exit "$rc"
fi

echo
echo "==> Open Watcom build finished."
echo "    Host tools:   $OWROOT/build/  and the per-host $OWROOT/bld/*/ dirs."
echo "    The CP/M-86 owcc seam is wired via contrib/ravn/cpm86-clib/env.sh."

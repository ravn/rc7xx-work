#!/usr/bin/env bash
# runcpm.sh: Run a CP/M .COM file using vcpm (VirtualCpm.jar).
#
# The CURRENT DIRECTORY is used as drive A: root via HostFileBdos.
# Files in ./ are directly accessible as drive A: files.
#
# vcpm maps CP/M drives to subdirectories of vcpm_root_dir: drive A: is
# root_dir/a/, drive B: is root_dir/b/, etc.  We create a temp root and
# symlink the current working directory to its a/ slot so our files appear
# on drive A: without restructuring the actual build directory.
#
# Usage:  runcpm.sh COM_STEM [args...]
#         COM_STEM is the program name without .COM (e.g. M80, SIEVE).
#         All remaining arguments are passed as the CP/M command line.
#
# Example:
#   (cd build && runcpm.sh M80 "=SIEVE.MAC /X /O /Z /L")
#   (cd build && runcpm.sh SIEVE)
#
# Environment:
#   VCPM_JAR          path to VirtualCpm.jar
#                     default: <workspace>/cpnet-z80/tools/VirtualCpm.jar,
#                     where <workspace> is the parent of this script's dir
#                     (dcc-bench/..) — the rc7xx-work superproject root.
#   RUNCPM_TIMEOUT    hard wall-clock limit in seconds (default 60).  A CP/M
#                     program that reads console input, or a bad command line,
#                     can otherwise hang vcpm forever.

set -euo pipefail

_RUNCPM_DIR="$(cd "$(dirname "$0")" && pwd)"
VCPM_JAR="${VCPM_JAR:-$(cd "$_RUNCPM_DIR/.." && pwd)/cpnet-z80/tools/VirtualCpm.jar}"
RUNCPM_TIMEOUT="${RUNCPM_TIMEOUT:-60}"

if [ $# -lt 1 ]; then
    echo "usage: runcpm.sh COM_STEM [args...]" >&2
    exit 1
fi

# Create a temp home directory for .vcpmrc and a temp root dir for drives.
# Symlink cwd to root/a/ so vcpm sees it as drive A:.
VCPM_HOME=$(mktemp -d /tmp/vcpmhome_XXXXXX)
VCPM_ROOT=$(mktemp -d /tmp/vcpmroot_XXXXXX)
ln -s "$(pwd)" "$VCPM_ROOT/a"
trap 'rm -rf "$VCPM_HOME" "$VCPM_ROOT"' EXIT

cat > "$VCPM_HOME/.vcpmrc" <<EOF
vcpm_root_dir = $VCPM_ROOT
vcpm_dso = def,a:,b,c
silent
EOF

# Build the CP/M command: "PROG arg1 arg2 ..."
CMD="$1"; shift
if [ $# -gt 0 ]; then
    CMD="$CMD $*"
fi

# Run vcpm under a perl-alarm timeout (macOS has no GNU `timeout`).  `exec`
# makes java the alarmed process itself, so a timeout kills java directly with
# no orphaned grandchild.  stdin from /dev/null so a console-reading program
# gets EOF immediately instead of blocking.  A timeout exits non-zero (SIGALRM
# = 142), which set -e propagates to the caller as a build/run failure.
perl -e 'alarm shift; exec @ARGV' "$RUNCPM_TIMEOUT" \
    java -Duser.home="$VCPM_HOME" -jar "$VCPM_JAR" $CMD < /dev/null 2>/dev/null

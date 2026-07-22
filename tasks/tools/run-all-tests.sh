#!/usr/bin/env bash
# run-all-tests.sh -- one place that runs every test group in the workspace.
#
#   Group A  llvm-z80 lit suite            (llvm-lit CodeGen/Z80)
#   Group B  llvm-z80 runtime value oracle (test-runner: cargo run -- clang)
#   Group C  z88dk clang integration       (z88dk/test/clang/run_all.sh)
#   Group D  softfloat / double + printf   (llvmz80-softfloat/tests/run.sh)
#
# Scope:
#   run-all-tests.sh fast    A + C + D            (quick correctness, ~1-3 min)
#   run-all-tests.sh         A + B + C + D (full, default; B is ~minutes)
#   run-all-tests.sh <group> run one group: lit | runtime | z88dk | softfloat
#
# A missing tool (ntvcm, z88dk-ticks, cargo, MAME) SKIPs its group, never fails.
# Overall exit: non-zero if any group FAILs.  Env: SKIP_TESTS=1 short-circuits.
set -u

[ "${SKIP_TESTS:-0}" = "1" ] && { echo "run-all-tests: SKIP_TESTS=1, skipping"; exit 0; }

WS="$(cd "$(dirname "$0")/../.." && pwd)"     # workspace root (tasks/tools/..)
LLVM="$WS/llvm-z80"
BUILD="${BUILD_DIR:-$LLVM/build-macos}"
export LLVMZ80EXE="${LLVMZ80EXE:-$BUILD/bin/clang}"
export NTVCM="${NTVCM:-$WS/ntvcm/ntvcm}"
export LLVMZ80RTLIB="${LLVMZ80RTLIB:-/tmp/softfloat_lib/softfloat_cpm_z80}"
export PATH="$WS/z88dk/bin:$PATH"
export ZCCCFG="${ZCCCFG:-$WS/z88dk/lib/config/}"

SCOPE="${1:-full}"
PASS=0; FAIL=0; SKIP=0
FAILED_GROUPS=""

hdr() { echo; echo "======================================================"; echo "  $1"; echo "======================================================"; }
mark() { # $1 = group name, $2 = exit code, $3 = skip-detect string in output
  case "$2" in
    0)  echo ">> PASS  $1"; PASS=$((PASS+1));;
    77) echo ">> skip  $1"; SKIP=$((SKIP+1));;
    *)  echo ">> FAIL  $1 (exit $2)"; FAIL=$((FAIL+1)); FAILED_GROUPS="$FAILED_GROUPS $1";;
  esac
}

want() { case "$SCOPE" in full) return 0;; fast) [ "$1" != runtime ];; *) [ "$SCOPE" = "$1" ];; esac }

# ---- Group A: lit ----
if want lit; then
  hdr "A. llvm-z80 lit suite (CodeGen/Z80)"
  if [ -x "$BUILD/bin/llvm-lit" ]; then
    "$BUILD/bin/llvm-lit" "$LLVM/llvm/test/CodeGen/Z80/" 2>&1 | tail -6
    mark "lit" "${PIPESTATUS[0]}"
  else echo "SKIP: $BUILD/bin/llvm-lit not built"; mark "lit" 77; fi
fi

# ---- Group C: z88dk clang integration ----  (before B: fast)
if want z88dk; then
  hdr "C. z88dk clang integration (test/clang/run_all.sh)"
  if [ -f "$WS/z88dk/test/clang/run_all.sh" ]; then
    sh "$WS/z88dk/test/clang/run_all.sh" 2>&1 | tail -22
    mark "z88dk" "${PIPESTATUS[0]}"
  else echo "SKIP: run_all.sh missing"; mark "z88dk" 77; fi
fi

# ---- Group D: softfloat + printf ----
if want softfloat; then
  hdr "D. softfloat / double + printf (tests/run.sh)"
  if [ -f "$WS/llvmz80-softfloat/tests/run.sh" ]; then
    sh "$WS/llvmz80-softfloat/tests/run.sh" 2>&1 | tail -15
    mark "softfloat" "${PIPESTATUS[0]}"
  else echo "SKIP: softfloat run.sh missing"; mark "softfloat" 77; fi
fi

# ---- Group B: runtime value oracle (slow) ----
if want runtime; then
  hdr "B. llvm-z80 runtime value oracle (test-runner clang)"
  if command -v cargo >/dev/null 2>&1 && command -v z88dk-ticks >/dev/null 2>&1; then
    ( cd "$LLVM/z80-utils/test-runner" && BUILD_DIR="$BUILD" cargo run -q -- clang 2>&1 | tail -4 )
    mark "runtime" "${PIPESTATUS[0]}"
  else echo "SKIP: cargo or z88dk-ticks not on PATH"; mark "runtime" 77; fi
fi

echo; echo "======================================================"
echo "  run-all-tests ($SCOPE): $PASS PASS, $FAIL FAIL, $SKIP SKIP"
[ -n "$FAILED_GROUPS" ] && echo "  failed:$FAILED_GROUPS"
echo "======================================================"
[ "$FAIL" -eq 0 ]

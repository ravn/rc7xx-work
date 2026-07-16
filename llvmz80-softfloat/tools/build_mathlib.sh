#!/usr/bin/env bash
# build_mathlib.sh -- package the SoftFloat f64 closure + vendored musl libm
# into a single z88dk archive  mathf64.lib.
#
# WHY a .lib and not a pile of .o:  z88dk's z80asm linker strips UNREFERENCED
# modules only from a .lib archive; a directly-linked .o is always pulled in
# whole.  Packaging as a library lets a pure-`double` transcendental test drag
# in only the modules it actually calls -- which is what makes exp() fit under
# the 64 KB CP/M TPA (65714 B when every .o is force-linked -> 60494 B via the
# lib; the ~3 KB f32 core stays out because src/sf64_f32.c is a separate
# module and nothing in a double-only program references it).
#
# Output: $OUT/mathf64.lib  (default OUT=/tmp/mathf64_lib).  Link a test with
#   zcc +cpm -compiler=llvmz80 -Cg-Oz -o prog test.c -L$OUT -lmathf64
set -u
export PATH="/Users/ravn/z80/z88dk/bin:$PATH"
export ZCCCFG=/Users/ravn/z80/z88dk/lib/config/
HERE="$(cd "$(dirname "$0")" && pwd)/.."     # project root
cd "$HERE"
OUT="${OUT:-/tmp/mathf64_lib}"; rm -rf "$OUT"; mkdir -p "$OUT"

echo "== [1/3] build f64 closure (-Oz) =="
OPT=Oz OUT="$OUT/clos" bash build64.sh >/dev/null 2>&1
[ -f "$OUT/clos/ft_dbl" ] || { echo "closure build FAILED"; exit 1; }
cp "$OUT"/clos/*.o "$OUT/"
rm -f "$OUT/ft_dbl.o"        # the closure driver's own object, not library code

echo "== [2/3] compile vendored musl libm + src libm layer =="
Z="zcc +cpm -compiler=llvmz80 -Cg-Oz -Ivendor/config -Ivendor/musl-math"
# sqrt/fabs/copysign live in src/sf_libm.c (fabs/copysign are pure bit ops,
# sqrt reuses the SoftFloat f64_sqrt core).  It provides fabs, so the vendored
# musl fabs.c is skipped below to avoid a duplicate _fabs module in the archive.
# sqrt/fabs/copysign: fabs+copysign are pure bit ops in src/sf_libm.c; sqrt is
# a separate module (src/sf_sqrt.c -> SoftFloat f64_sqrt core, already in the
# closure via build64.sh SEED) so fabs-only consumers (musl atan) don't drag
# f64_sqrt in.  sf_libm provides fabs, so the vendored musl fabs.c is skipped
# below to avoid a duplicate _fabs module.
SFINC="-Ivendor/berkeley-softfloat-3/source/8086 -Ivendor/berkeley-softfloat-3/source/include -DSOFTFLOAT_FAST_INT64 -DINLINE_LEVEL=1"
$Z $SFINC -c -o "$OUT/sf_libm.o" src/sf_libm.c 2>/dev/null || echo "  warn: sf_libm did not compile"
$Z $SFINC -c -o "$OUT/sf_sqrt.o" src/sf_sqrt.c 2>/dev/null || echo "  warn: sf_sqrt did not compile"
for c in vendor/musl-math/*.c; do
    b="$(basename "$c" .c)"
    case "$b" in libm_musl_orig*|fabs) continue;; esac
    $Z -c -o "$OUT/$b.o" "$c" 2>/dev/null || echo "  warn: $b did not compile"
done

echo "== [3/3] archive -> mathf64.lib =="
cd "$OUT"
rm -f mathf64.lib
z88dk-z80asm -d -xmathf64 *.o >/dev/null 2>&1
[ -f mathf64.lib ] && echo "OK: $OUT/mathf64.lib ($(ls -l mathf64.lib | awk '{print $5}') B, $(ls *.o | wc -l | tr -d ' ') modules)" \
                    || { echo "archive FAILED"; exit 1; }

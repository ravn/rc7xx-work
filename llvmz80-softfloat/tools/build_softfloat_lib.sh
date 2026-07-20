#!/usr/bin/env bash
# build_softfloat_lib.sh -- package the Berkeley-SoftFloat f64 arithmetic
# closure into a single z88dk archive  softfloat_cpm_z80.lib.
#
# This is the CORE runtime library every `double` program compiled with
# `zcc +cpm -compiler=llvmz80` needs: it resolves the compiler-rt soft-float
# libcalls clang emits for `double` (__adddf3/__subdf3/__muldf3/__divdf3,
# comparisons, __floatsidf/__fixdfsi, __extendsfdf2/__truncdfsf2) plus the
# vendored SoftFloat f64 cores and the 64-bit integer runtime they rely on.
#
# It does NOT include libm (sin/cos/exp/...) -- that lives in mathf64.lib
# (tools/build_mathlib.sh) -- nor the nanoprintf %f formatter (src/fmt64.c),
# which a program links explicitly only if it formats doubles.
#
# WHY a .lib and not a pile of .o:  z88dk's z80asm linker strips UNREFERENCED
# modules from a .lib archive but force-links a directly-named .o whole.
# Packaging as a library lets an integer-only or f32-only program that happens
# to pull the archive in resolve only the modules it actually calls (e.g. the
# ~3 KB f32 core in src/sf64_f32.c stays out of a pure-double image).
#
# Output: $OUT/softfloat_cpm_z80.lib  (default OUT=/tmp/softfloat_lib).
# Ship it alongside the llvm-z80 clang binary; link a program with:
#   zcc +cpm -compiler=llvmz80 -o prog prog.c -L<dir> -lsoftfloat_cpm_z80
set -u
export PATH="/Users/ravn/z80/z88dk/bin:$PATH"
export ZCCCFG=/Users/ravn/z80/z88dk/lib/config/
HERE="$(cd "$(dirname "$0")" && pwd)/.."     # project root
cd "$HERE"
OUT="${OUT:-/tmp/softfloat_lib}"; rm -rf "$OUT"; mkdir -p "$OUT"

echo "== [1/3] build f64 closure objects (-Oz) =="
# build64.sh compiles the whole closure into $OUT/clos and link-checks it by
# building the ft_dbl test (proves the archive would be link-complete).
OPT="${OPT:-Oz}" OUT="$OUT/clos" bash build64.sh >"$OUT/build64.log" 2>&1
if [ ! -f "$OUT/clos/ft_dbl" ]; then
    echo "closure build FAILED -- see $OUT/build64.log"; tail -5 "$OUT/build64.log"; exit 1
fi
cp "$OUT"/clos/*.o "$OUT/"
rm -f "$OUT/ft_dbl.o"        # the closure driver's own object, not library code

echo "== [2/3] archive -> softfloat_cpm_z80.lib =="
cd "$OUT"
rm -f softfloat_cpm_z80.lib
# -d: date-insensitive (rebuild only when needed); -x<name>: create library <name>.lib
z88dk-z80asm -d -xsoftfloat_cpm_z80 *.o >"$OUT/archive.log" 2>&1 \
    || { echo "archive FAILED -- see $OUT/archive.log"; tail -5 "$OUT/archive.log"; exit 1; }
[ -f softfloat_cpm_z80.lib ] || { echo "no lib produced"; exit 1; }
NMOD=$(ls *.o 2>/dev/null | wc -l | tr -d ' ')

echo "== [3/3] link-verify ft_dbl against the archive =="
# Re-link the reference double test using ONLY the archive (not the loose .o),
# proving the .lib is self-contained and correctly indexed.
cd "$HERE"
VOUT="$OUT/verify"; mkdir -p "$VOUT"
if zcc +cpm -compiler=llvmz80 -Cg-Oz -o "$VOUT/ft_dbl" tests/ft_dbl.c \
        -L"$OUT" -lsoftfloat_cpm_z80 >"$VOUT/link.err" 2>&1 && [ -f "$VOUT/ft_dbl" ]; then
    sz=$(z88dk-z80nm "$OUT/softfloat_cpm_z80.lib" 2>/dev/null \
         | grep -oE "code_compiler: [0-9]+" | grep -oE "[0-9]+" \
         | awk '{s+=$1} END{printf "%d", s}')
    echo "OK: $OUT/softfloat_cpm_z80.lib (~$((${sz:-0}/1024)) KB code across $NMOD modules)"
    echo "    ft_dbl relinked from the archive alone -> link-complete."
    echo "    (runtime correctness of the closure: tests/run.sh)"
else
    echo "link-verify FAILED -- see $VOUT/link.err"; grep -iE 'undefined|error' "$VOUT/link.err" | sort -u | head
    exit 1
fi

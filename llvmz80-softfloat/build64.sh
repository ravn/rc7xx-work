#!/usr/bin/env bash
# Build the Berkeley-SoftFloat f64 closure for zcc+cpm+llvmz80.
# Auto-resolves undefined softfloat_*/fNN_*/iNN_*/uiNN_* symbols to their
# source files (symbol softfloat_X -> s_X.c ; f64_X -> f64_X.c ; specialization
# helpers live under 8086/).  INLINE_LEVEL=1 keeps 64-bit primitives out-of-line
# so they are shared once instead of bloating every caller (Z80 has no native
# 64-bit ops, so inlined shiftRightJam64 etc. is huge -- see EVIDENCE.md).
set -u
export PATH="/Users/ravn/z80/z88dk/bin:$PATH"
export ZCCCFG=/Users/ravn/z80/z88dk/lib/config/
HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"
V=vendor/berkeley-softfloat-3/source
INC="-Ivendor/config -I$V/8086 -I$V/include"
# SOFTFLOAT_BUILTIN_CLZ makes opts-GCC.h define softfloat_countLeadingZeros{16,32,64}
# inline via __builtin_clz*.  Those defs are width-matched for clang-z80
# (int=16/long=32/llong=64) -- see opts-GCC.h.  The historical off-by-16
# (ravn/llvm-z80#273: (double)5 -> 131074.5) was in opts-GCC.h, NOT here; keeping
# the flag also avoids pulling the portable s_countLeadingZeros8.c whose 256-byte
# .ascii table the z88dk copt/z80asm stage cannot parse.
DEF="-DSOFTFLOAT_FAST_INT64 -DSOFTFLOAT_ROUND_ODD -DINLINE_LEVEL=1 -DSOFTFLOAT_FAST_DIV32TO16 -DSOFTFLOAT_FAST_DIV64TO32 -DSOFTFLOAT_BUILTIN_CLZ"
OPT="${OPT:-O2}"   # global optimization level for the SoftFloat closure
OUT="${OUT:-/tmp/sf64_out}"; rm -rf "$OUT"; mkdir -p "$OUT"

# #267 (jr-out-of-range) FIXED: systemic getInstSizeInBytes pseudo-sizing landed,
# so the whole closure now assembles clean at -O2.  No per-file -O0 override.
O0FILES=""

# find the .c for a bare basename in source/ or source/8086/
srcfor(){ [ -f "$V/$1.c" ] && { echo "$V/$1.c"; return; }; [ -f "$V/8086/$1.c" ] && echo "$V/8086/$1.c"; }

compile(){ # $1 = path to .c
  local c="$1" base opt="$OPT"
  base="$(basename "$c" .c)"
  case "$O0FILES" in *" $base "*) opt=O0;; esac
  zcc +cpm -compiler=llvmz80 -Cg-$opt $DEF $INC -c -o "$OUT/$base.o" "$c" 2>"$OUT/$base.err" \
    || { echo "  COMPILE-FAIL($opt) $base"; grep -iE 'error' "$OUT/$base.err"|head -1; return 1; }
}

# seed: the entry points the test needs + shims + integer runtime
SEED="f64_add f64_sub f64_mul f64_div f64_lt f64_le f64_eq f64_sqrt s_approxRecipSqrt_1Ks f64_to_i32_r_minMag i32_to_f64 f32_to_f64 f64_to_f32 softfloat_state"
for f in $SEED; do compile "$(srcfor "$f")"; done
compile src/sf64.c
compile src/sf64_f32.c
zcc +cpm -compiler=llvmz80 -Cg-O2 -c -o "$OUT/intrt.o" ../llvmz80-intrt/src/intrt.c 2>/dev/null
# __mulsi3 in its own object so the packaged archive can share it on demand with
# newlib's llvmz80_imath.lib (no ___mulsi3 duplicate on -clib=newlib_iy) -- see
# ../llvmz80-intrt/src/intrt_mulsi3.c
zcc +cpm -compiler=llvmz80 -Cg-O2 -c -o "$OUT/intrt_mulsi3.o" ../llvmz80-intrt/src/intrt_mulsi3.c 2>/dev/null
# __memmove_rt: custom reg-ABI struct-copy helper clang-z80 emits (z88dk lacks it)
zcc +cpm -compiler=llvmz80 -c -o "$OUT/rt_mem.o" ../llvmz80-intrt/src/rt_mem.asm 2>/dev/null

# iterate: link, harvest undefined symbols, compile their sources, repeat
for pass in $(seq 1 40); do
  zcc +cpm -compiler=llvmz80 -Cg-O2 -o "$OUT/ft_dbl" tests/ft_dbl.c "$OUT"/*.o 2>"$OUT/link.err"
  [ -f "$OUT/ft_dbl" ] && { echo "LINKED on pass $pass"; break; }
  # z88dk prints: "error: undefined symbol: _softfloat_X" ; strip leading _
  U="$(grep -oiE "undefined symbol: _[A-Za-z0-9_]+" "$OUT/link.err" \
       | grep -oE "_[A-Za-z0-9_]+$" | sed 's/^_//' | sort -u)"
  [ -z "$U" ] && { echo "no undefined syms but not linked -- other error:"; grep -iE 'error|overflow' "$OUT/link.err"|sort -u|head; break; }
  progress=0
  for sym in $U; do
    # softfloat_X -> s_X ; else try the symbol name itself as a file
    cand="$sym"; case "$sym" in softfloat_*) cand="s_${sym#softfloat_}";; esac
    c="$(srcfor "$cand")"; [ -z "$c" ] && c="$(srcfor "$sym")"
    if [ -n "$c" ] && [ ! -f "$OUT/$(basename "$c" .c).o" ]; then compile "$c" && progress=1; fi
  done
  if [ "$progress" -eq 0 ]; then
    echo "STUCK pass $pass; unresolved:"; printf '  %s\n' $U; break
  fi
done

if [ -f "$OUT/ft_dbl" ]; then
  tot=0; for f in "$OUT"/*.o; do b=$(z88dk-z80nm "$f" 2>/dev/null|grep -oE "code_compiler: [0-9]+"|grep -oE "[0-9]+"); tot=$((tot+${b:-0})); done
  echo "total code_compiler ~$((tot/1024)) KB across $(ls "$OUT"/*.o|wc -l|tr -d ' ') objects"
fi
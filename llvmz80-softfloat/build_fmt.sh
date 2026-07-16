#!/usr/bin/env bash
# Build the Phase 4 double-formatter test (ft_fmt) for zcc+cpm+llvmz80.
# Same SoftFloat f64 auto-resolver closure as build64.sh, plus the nanoprintf
# implementation TU (src/fmt64.c).  ft_fmt uses f64_div at runtime and formats
# via npf_snprintf (pure-integer nanoprintf) -> no math48, IEEE-correct %f.
set -u
export PATH="/Users/ravn/z80/z88dk/bin:$PATH"
export ZCCCFG=/Users/ravn/z80/z88dk/lib/config/
HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"
V=vendor/berkeley-softfloat-3/source
INC="-Ivendor/config -I$V/8086 -I$V/include"
DEF="-DSOFTFLOAT_FAST_INT64 -DSOFTFLOAT_ROUND_ODD -DINLINE_LEVEL=1 -DSOFTFLOAT_FAST_DIV32TO16 -DSOFTFLOAT_FAST_DIV64TO32 -DSOFTFLOAT_BUILTIN_CLZ"
OPT="${OPT:-O2}"
OUT="${OUT:-/tmp/fmt64_out}"; rm -rf "$OUT"; mkdir -p "$OUT"

# s_roundPackToF64 trips llvm-z80 #267 (jr out of range) at -O2 -> build -O0.
O0FILES=" s_roundPackToF64 "

srcfor(){ [ -f "$V/$1.c" ] && { echo "$V/$1.c"; return; }; [ -f "$V/8086/$1.c" ] && echo "$V/8086/$1.c"; }

compile(){ # $1 = path to .c
  local c="$1" base opt="$OPT"
  base="$(basename "$c" .c)"
  case "$O0FILES" in *" $base "*) opt=O0;; esac
  zcc +cpm -compiler=llvmz80 -Cg-$opt $DEF $INC -c -o "$OUT/$base.o" "$c" 2>"$OUT/$base.err" \
    || { echo "  COMPILE-FAIL($opt) $base"; grep -iE 'error' "$OUT/$base.err"|head -1; return 1; }
}

SEED=""
for f in $SEED; do compile "$(srcfor "$f")"; done
# nanoprintf implementation TU (pure integer, reads raw double bits, no soft-float)
zcc +cpm -compiler=llvmz80 -Cg-O2 -Ivendor/nanoprintf -Isrc -c -o "$OUT/fmt64.o" src/fmt64.c 2>"$OUT/fmt64.err" \
  || { echo "  COMPILE-FAIL fmt64"; grep -iE 'error' "$OUT/fmt64.err"|head; }
# integer-only __eqdf2/__nedf2 (avoids pulling the f64 arithmetic closure)
zcc +cpm -compiler=llvmz80 -Cg-O2 -c -o "$OUT/fcmp64.o" src/fcmp64.c 2>"$OUT/fcmp64.err" \
  || { echo "  COMPILE-FAIL fcmp64"; grep -iE 'error' "$OUT/fcmp64.err"|head; }
zcc +cpm -compiler=llvmz80 -Cg-O2 -c -o "$OUT/intrt.o" ../llvmz80-intrt/src/intrt.c 2>/dev/null
zcc +cpm -compiler=llvmz80 -c -o "$OUT/rt_mem.o" ../llvmz80-intrt/src/rt_mem.asm 2>/dev/null

for pass in $(seq 1 40); do
  zcc +cpm -compiler=llvmz80 -Cg-O2 -Ivendor/nanoprintf -Isrc -o "$OUT/ft_fmt" tests/ft_fmt.c "$OUT"/*.o 2>"$OUT/link.err"
  [ -f "$OUT/ft_fmt" ] && { echo "LINKED on pass $pass"; break; }
  U="$(grep -oiE "undefined symbol: _[A-Za-z0-9_]+" "$OUT/link.err" \
       | grep -oE "_[A-Za-z0-9_]+$" | sed 's/^_//' | sort -u)"
  [ -z "$U" ] && { echo "no undefined syms but not linked -- other error:"; grep -iE 'error|overflow' "$OUT/link.err"|sort -u|head; break; }
  progress=0
  for sym in $U; do
    cand="$sym"; case "$sym" in softfloat_*) cand="s_${sym#softfloat_}";; esac
    c="$(srcfor "$cand")"; [ -z "$c" ] && c="$(srcfor "$sym")"
    if [ -n "$c" ] && [ ! -f "$OUT/$(basename "$c" .c).o" ]; then compile "$c" && progress=1; fi
  done
  if [ "$progress" -eq 0 ]; then
    echo "STUCK pass $pass; unresolved:"; printf '  %s\n' $U; break
  fi
done

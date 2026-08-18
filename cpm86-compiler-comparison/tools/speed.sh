#!/bin/sh
# speed.sh <backend> <bench>  -- differential 80186-clock timing.
#
# Build the benchmark at two iteration counts (REPS=10 and REPS=20), run each in
# the Unicorn/QEMU 8086 executor (cpm86run_unicorn.py, real instruction stream --
# code I did not write, so an independent confirmation), and print
#   <bench>|<label>|<opt>|<clocks_per_iter>
# where clocks_per_iter = (clocks(20) - clocks(10)) / 10. The subtraction cancels
# the fixed crt0/printf/BDOS overhead, leaving the cost of ONE kernel iteration.
#
# Each backend stands alone -- Watcom's one-step owcc, DR C's own runtime via the
# emu2 oracle, Aztec's own cc+link -- never combined with another's runtime.
set -e
BACKEND="$1"; BENCH="$2"
HERE=$(cd "$(dirname "$0")" && pwd)
CMP=$(cd "$HERE/.." && pwd); SRC="$CMP/src"; ROOT=$(cd "$CMP/.." && pwd)
OW="$ROOT/open-watcom-v2"; RUN="$OW/contrib/ravn/cpm86run_unicorn.py"
CROSS="$ROOT/cpm86-crossdev/bin"
DRC_ORACLE="$ROOT/scratch/rc759-cmd-toolchain/drc-oracle.sh"
# Use the canonical, git-tracked emu2 submodule (emu2-cpm86/), not a scratch copy.
EMU2="$ROOT/emu2-cpm86/emu2"; export EMU2
K="$SRC/$BENCH.c"; D="$SRC/${BENCH}_main.c"
WORK=$(mktemp -d); trap 'rm -rf "$WORK"' EXIT
# The drivers #include "mame_bracket.h" (no-op macros unless MAME_BRACKET is set).
# The Watcom leg finds it beside the driver in src/; the Aztec leg compiles in
# $WORK and the DR C leg builds a concatenated source in $WORK, so both need a
# copy here (drc-oracle then copies it as a sibling header into its own workdir).
cp "$SRC/mame_bracket.h" "$WORK/" 2>/dev/null || true

# clocks(cmd) -> estimated 80186 clocks from the executor's summary line.
# `|| true` so a run that emits no clocks line does not trip `set -e` (the empty
# result is caught below and reported as n/a).
clocks() { python3 "$RUN" --ticks "$1" 2>&1 | grep -oE '~[0-9]+' | tr -d '~' || true; }

build() { # build <N> <out.cmd>
  N="$1"; OUT="$2"
  case "$BACKEND" in
  watcom)
    WATCOM="$OW/rel" INCLUDE="$OW/rel/h" PATH="$OW/rel/armo64:$PATH" \
    "$OW/rel/armo64/owcc" -bcpm86 -Wc,-ms -Wc,-os -DREPS=$N -o "$OUT" "$K" "$D" >/dev/null 2>&1 ;;
  aztec42|aztec34)
    F="-I. +F -B +0 -D__CPM86__ -DREPS=$N"
    # aztec_link returns non-zero when handed an absolute -o path but works with a
    # relative one; cwd is already $WORK, so link to the basename (== $OUT).
    ( cd "$WORK"; cp "$K" k.c; cp "$D" d.c; export PATH="$CROSS:$ROOT/emu2-cpm86:$PATH"
      "$CROSS/${BACKEND}_cc" $F k.c >/dev/null 2>&1
      "$CROSS/${BACKEND}_cc" $F d.c >/dev/null 2>&1
      "$CROSS/${BACKEND}_link" -o "$(basename "$OUT")" k.o d.o -lc86 >/dev/null 2>&1 ) ;;
  drc)
    # DR C oracle compiles ONE source: concatenate kernel + driver, bake REPS in,
    # drop the driver's guard + its duplicate typedefs (the kernel supplies them),
    # and map unsigned char -> char (DR C 1.11 has no unsigned char, its char IS
    # unsigned -- identical 8-bit behaviour).
    { echo "#define REPS $N"; cat "$K"
      sed '/typedef unsigned char uint8_t;/d; /^typedef struct {/,/} aes256_context;/d; /#ifndef REPS/,/#endif/d' "$D"
    } | sed 's/unsigned char/char/g' > "$WORK/c.c"
    sh "$DRC_ORACLE" "$WORK/c.c" "$OUT" >/dev/null 2>&1 ;;
  *) echo "unknown backend $BACKEND" >&2; exit 1 ;;
  esac
}

case "$BACKEND" in
  watcom)  L="Open Watcom|-os" ;;
  drc)     L="DR C 1.11|small" ;;
  aztec42) L="Aztec C86 4.2|default" ;;
  aztec34) L="Aztec C86 3.40a|default" ;;
esac

build 10 "$WORK/n10.cmd"; build 20 "$WORK/n20.cmd"
t10=$(clocks "$WORK/n10.cmd"); t20=$(clocks "$WORK/n20.cmd")
if [ -z "$t10" ] || [ -z "$t20" ]; then echo "$BENCH|$L|n/a"; exit 0; fi
echo "$BENCH|$L|$(( (t20 - t10) / 10 ))"

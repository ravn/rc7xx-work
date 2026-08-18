#!/bin/bash
# speed_mame.sh <backend> <bench>  -- MAME-PRECISE 80186-clock timing.
#
# The Unicorn leg (tools/speed.sh) estimates 80186 clocks from a hand-written
# cycle model (cycles186.py). This leg measures the REAL thing: it builds the
# benchmark with two OUT 0x2FE bracket markers around the REPS loop (see
# src/mame_bracket.h), boots the compiled .CMD as the autostart program on the
# genuine MAME rc759 driver, and reads MAME's own emulated clock (emu.time()) at
# each marker edge (tools/mame_time.lua). MAME's i80186 core is cycle-accurate
# by its m_i80186_timing[] table (validated end-to-end against Timer 2, ravn/
# mame#27 -- ratio 1.00006), so the elapsed emulated seconds x 6 MHz IS the real
# rc759 clock cost.
#
# Differential method (same as speed.sh): build at REPS=10 and REPS=20, subtract,
# divide by 10 -- cancels the loop-setup + 2 marker OUTs, leaving ONE iteration.
# Boot and crt0/printf sit OUTSIDE the bracket, so they never enter the number.
#
# Prints  <bench>|<label>|<clocks_per_iter>  (matching speed.sh's format).
#
# Each backend stands alone: Watcom one-step owcc; Aztec cc+link; DR C via the
# emu2 oracle with a linked FAR marker stub. NEVER search outside /Users/ravn/z80/.
set -u
BACKEND="$1"; BENCH="$2"
HERE=$(cd "$(dirname "$0")" && pwd)
CMP=$(cd "$HERE/.." && pwd); SRC="$CMP/src"; ROOT=$(cd "$CMP/.." && pwd)
OW="$ROOT/open-watcom-v2"
CROSS="$ROOT/cpm86-crossdev/bin"
DRC_ORACLE="$ROOT/scratch/rc759-cmd-toolchain/drc-oracle.sh"
EMU2="$ROOT/emu2-cpm86/emu2"; export EMU2

MAME_DIR="$ROOT/mame"
IMAGES="$ROOT/scratch/rc759-pce/images"
FMT=drc-rc759
CPMCP=$HOME/.local/bin/cpmcp
CPMRM=$HOME/.local/bin/cpmrm
CPMLS=$HOME/.local/bin/cpmls
LUA="$HERE/mame_time.lua"
CLOCK=6000000

# Newest validating MAME binary carrying the rc759 driver (never "first").
MAME_BIN=""
newest=0
for cand in "$MAME_DIR/regnecentralend" "$MAME_DIR/regnecentralen" "$MAME_DIR/mame"; do
    [ -x "$cand" ] || continue
    "$cand" -validate rc759 >/dev/null 2>&1 || continue
    m=$(stat -f %m "$cand" 2>/dev/null || echo 0)
    [ "$m" -ge "$newest" ] && { newest="$m"; MAME_BIN="$cand"; }
done
[ -n "$MAME_BIN" ] || { echo "no MAME binary with rc759 driver in $MAME_DIR" >&2; exit 1; }

K="$SRC/$BENCH.c"; D="$SRC/${BENCH}_main.c"
WORK=$(mktemp -d); trap 'rm -rf "$WORK"' EXIT
cp "$SRC/mame_bracket.h" "$WORK/" 2>/dev/null || true
cp "$SRC/mame_mark_watcom.h" "$WORK/" 2>/dev/null || true
# Some kernels (dhry) carry their own main(), so there is no separate driver.
HAS_DRIVER=0; [ -f "$D" ] && HAS_DRIVER=1

case "$BACKEND" in
  watcom)  L="Open Watcom|-os" ;;
  drc)     L="DR C 1.11|small" ;;
  aztec42) L="Aztec C86 4.2|default" ;;
  aztec34) L="Aztec C86 3.40a|default" ;;
  *) echo "unknown backend $BACKEND" >&2; exit 1 ;;
esac

# build <N> <out.cmd> -- compile the benchmark with the bracket markers baked in.
build() {
  N="$1"; OUT="$2"
  case "$BACKEND" in
  watcom)
    [ "$HAS_DRIVER" = 1 ] && DSRC="$D" || DSRC=""
    WATCOM="$OW/rel" INCLUDE="$OW/rel/h" PATH="$OW/rel/armo64:$PATH" \
    "$OW/rel/armo64/owcc" -bcpm86 -Wc,-ms -Wc,-os ${WATCOM_MARCH:+-march=$WATCOM_MARCH} \
      -DMAME_BRACKET -DMAME_WATCOM -DREPS=$N -o "$OUT" "$K" $DSRC >/dev/null 2>&1 ;;
  aztec42|aztec34)
    F="-I. +F -B +0 -D__CPM86__ -DMAME_BRACKET -DMAME_AZTEC -DREPS=$N"
    ( cd "$WORK"; cp "$K" k.c; export PATH="$CROSS:$ROOT/emu2-cpm86:$PATH"
      "$CROSS/${BACKEND}_cc" $F k.c >/dev/null 2>&1
      if [ "$HAS_DRIVER" = 1 ]; then
        cp "$D" d.c; "$CROSS/${BACKEND}_cc" $F d.c >/dev/null 2>&1
        "$CROSS/${BACKEND}_link" -o "$(basename "$OUT")" k.o d.o -lc86 >/dev/null 2>&1
      else
        "$CROSS/${BACKEND}_link" -o "$(basename "$OUT")" k.o -lc86 >/dev/null 2>&1
      fi ) ;;
  drc)
    # Concatenate kernel (+ driver if any), bake in REPS + the MAME macros, drop
    # the driver's guard/duplicate typedefs, map unsigned char -> char (DR C).
    # The driver's #include "mame_bracket.h" resolves from the oracle's workdir
    # (drc-oracle copies sibling .h of the source); DRC_MAMEMARK links the stub.
    { echo "#define REPS $N"; echo "#define MAME_BRACKET"; echo "#define MAME_DRC"
      cat "$K"
      if [ "$HAS_DRIVER" = 1 ]; then
        sed '/typedef unsigned char uint8_t;/d; /^typedef struct {/,/} aes256_context;/d; /#ifndef REPS/,/#endif/d' "$D"
      fi
    } | sed 's/unsigned char/char/g' > "$WORK/c.c"
    cp "$SRC/mame_bracket.h" "$WORK/mame_bracket.h"
    DRC_MAMEMARK=1 sh "$DRC_ORACLE" "$WORK/c.c" "$OUT" >/dev/null 2>&1 ;;
  esac
  [ -f "$OUT" ]
}

# run <cmd> -> elapsed emulated seconds (float) between the START/END markers.
run() {
  CMD="$1"
  IMG="$IMAGES/speedmame.img"
  cp "$IMAGES/mandel.img" "$IMG"
  ( cd "$IMAGES"                       # cpmtools reads ./diskdefs from CWD
    for f in menu.cmd comal80.cmd comal80.erm diskvedl.cmd filadm.cmd function.cmd \
             function.sys asm86.cmd ddt86.cmd chset.cmd ed.cmd filex.a86 filex.cmd \
             gencmd.cmd help.hlp mandel.cmd; do
      "$CPMRM" -f "$FMT" "$IMG" "0:$f" 2>/dev/null || true
    done
    "$CPMCP" -f "$FMT" "$IMG" "$CMD" 0:menu.cmd
    "$CPMLS" -f "$FMT" -l "$IMG" | grep -qi "menu.cmd" ) || { echo "install failed (disk full?)" >&2; return 1; }
  ( cd "$MAME_DIR"; rm -f nvram/rc759/nvram 2>/dev/null || true
    SDL_VIDEODRIVER=dummy "$MAME_BIN" rc759 -bios 0 -skip_gameinfo -rompath roms \
      -flop1 "$IMG" -autoboot_script "$LUA" -seconds_to_run 900 \
      -nothrottle -sound none -video none 2>&1 ) | grep -oE "elapsed=[0-9.]+" | head -1 | cut -d= -f2
}

# Whetstone needs a floating-point runtime. RC759 has no 8087, so it must be
# built with software FP (owcc -fpc): every double op becomes a __FDx CALL that
# dispatches on __real87==0 to the pure-software path -- see the memory note
# "Compile Watcom CP/M-86 float with -fpc". That soft-float link is NOT in the
# integer-only clibcpm.lib; it lives in watcom-cpm86-libc/build-whetstone.sh,
# which already brackets the whole run with the same OUT 0x2FE START/END markers
# (via test/mamedone.h). Whetstone's internal LOOP is a fixed compile-time count,
# so there is no REPS knob to differentiate against: we measure ONE full run
# (boot sits outside the markers, so it never enters the number). Only Watcom has
# the soft-float port; Aztec/DR C soft-float whet is not wired here.
if [ "$BENCH" = whet ]; then
  if [ "$BACKEND" != watcom ]; then
    echo "$BENCH|$L|n/a (soft-float whet: watcom only)"; exit 0
  fi
  WLIBC="$ROOT/open-watcom-v2/contrib/ravn/watcom-cpm86-libc"
  # build-whetstone.sh derives OW from $0 and writes into a repo-relative OUTDIR;
  # run it from its own dir with OW pinned so the paths resolve.
  ( cd "$WLIBC" && WHET_NORUN=1 OUTDIR=build-whetstone-mame WHET_EXTRA="-DMAME_DONE" \
      OW="$ROOT/open-watcom-v2" bash build-whetstone.sh ) >/dev/null 2>&1 \
      || { echo "$BENCH|$L|n/a (build)"; exit 0; }
  CMD="$WLIBC/build-whetstone-mame/whetstone.cmd"
  [ -f "$CMD" ] || { echo "$BENCH|$L|n/a (no cmd)"; exit 0; }
  e=$(run "$CMD")
  [ -n "$e" ] || { echo "$BENCH|$L|n/a (no MAME-TIME)"; exit 0; }
  clk=$(python3 -c "print(int(round($e*$CLOCK)))")
  echo "$BENCH|$L|$clk (1 full run, soft-float -fpc)"
  exit 0
fi

build 10 "$WORK/n10.cmd" || { echo "$BENCH|$L|n/a (build10)"; exit 0; }
build 20 "$WORK/n20.cmd" || { echo "$BENCH|$L|n/a (build20)"; exit 0; }
e10=$(run "$WORK/n10.cmd"); e20=$(run "$WORK/n20.cmd")
if [ -z "$e10" ] || [ -z "$e20" ]; then echo "$BENCH|$L|n/a (no MAME-TIME)"; exit 0; fi
# clocks_per_iter = (e20 - e10)/10 * 6e6, rounded.
cpi=$(python3 -c "print(int(round(($e20 - $e10)/10.0*$CLOCK)))")
echo "$BENCH|$L|$cpi"

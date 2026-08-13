#!/bin/bash
# stdcbench-cpm86.sh -- build & run stdcbench 0.8 (integer: c90base + c90lib)
# through the Open Watcom -> DR C CP/M-86 target (cc-cpm86 pipeline) in a chosen
# memory model. This is the substantial end-to-end test that the compiler+bridge
# works for a real multi-module program calling the DR C stdlib, not just a toy.
#
# Reuses the EXISTING port under
#   open-watcom-v2/contrib/ravn/owc-drc/stdcbench/
# (portme.c, cpmlibc.c, inc/ and the unmodified upstream src/), which already
# solved the missing-libc (cpmlibc) and heap-base (portme brk) problems. The
# 32-bit long helpers (__U4M/__I4M/__U4D/__I4D) come from Open Watcom's OWN
# pre-built cgsupp objects (i4m.obj/i4d.obj), NOT any hand-written asm. The ONLY thing we change vs that port is the build
# path: instead of owcrt.asm + cmain + LINKCMD.EXE (small only), we go through
# OUR target -- DRC_MAIN entry + auto-included _preincl.h + LINK-86 + CLEAR?.L86 --
# so the SAME sources build in either model.
#
# Usage:  stdcbench-cpm86.sh [-m s|l]     (default s = small)
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
OW="${OW:-$HERE/../open-watcom-v2/build/binbuild}"
DRC="${DRC:-$HERE/drc86111}"
EMU2="${EMU2:-$HERE/../cpm86-tools/emu2-cpm86/emu2}"
TGT="${CPM86_TARGET_DIR:-$HERE/../open-watcom-v2/cpm86}"
# stdcbench times ITSELF via the RC759 XIOS Int 28h fn 19 "16 ms counter".  Only
# the Unicorn CP/M-86 runner (cpm86run_unicorn.py) implements that XIOS clock
# (driven by a code-byte virtual clock, tuned by CPM86_CLOCK_HZ); emu2 does not,
# so running SCB.CMD under emu2 spins forever (end-start==0 < SECONDS).  emu2 is
# still used above only to drive DR LINK-86.
RUNNER=""
for cand in "$HERE/../open-watcom-v2/contrib/ravn/cpm86run_unicorn.py" \
            "$HERE/../../open-watcom-v2/contrib/ravn/cpm86run_unicorn.py"; do
    [ -f "$cand" ] && { RUNNER="$cand"; break; }
done
[ -n "$RUNNER" ] || { echo "cpm86run_unicorn.py not found"; exit 1; }
# stdcbench port sources may live in the scratch submodule tree or the top-level
# repo checkout; the toolchain (bwcc/target) is always the scratch tree.
SB=""
for cand in "$HERE/../open-watcom-v2/contrib/ravn/owc-drc/stdcbench" \
            "$HERE/../../open-watcom-v2/contrib/ravn/owc-drc/stdcbench"; do
    [ -d "$cand/src" ] && { SB="$cand"; break; }
done
[ -n "$SB" ] || SB="$HERE/../open-watcom-v2/contrib/ravn/owc-drc/stdcbench"
SRC="$SB/src/stdcbench-0.8"

# Default = SMALL model.  SMALL is the verified working path (score 7/5/12,
# byte-identical on both the Unicorn runner and emu2).  The LARGE model is known
# broken for stdcbench: it hangs inside a compute module after ~3 clock reads --
# see wlink-cpm86-plan.md finding (l) (two large-model bugs fixed in owmath.asm +
# portme.c, but a residual large-model defect remains). "-m l" is left available
# for debugging that residual; it will NOT produce a score yet.
MODEL="s"
while [ $# -gt 0 ]; do case "$1" in -m) MODEL="$2"; shift 2;; *) echo "usage: $0 [-m s|l]"; exit 2;; esac; done
case "$MODEL" in
  s) MFLAGS="-ms -nt=CODE"; CLEAR="CLEARS.L86"; MNAME="small"; ZU=""
     CGMODEL="ms"; CGMERGE="--merge-text-into-code";;
  l) MFLAGS="-ml";          CLEAR="CLEARL.L86"; MNAME="large"; ZU="-zu"
     CGMODEL="ml"; CGMERGE=""
     echo "WARNING: stdcbench LARGE model is known broken (hangs in a compute" >&2
     echo "         module) -- see wlink-cpm86-plan.md finding (l). Use -m s." >&2;;
  *) echo "unknown model '$MODEL'"; exit 2;;
esac
# Open Watcom's OWN pre-built 8086 long-math helpers (__U4M/__I4M/__U4D/__I4D),
# compiled by its build system per model. We link these instead of any hand-
# written asm -- runtime helpers must come from the compiler, and Watcom's build
# already selects the correct near(ms)/far(ml) RET automatically.  ms/ml pick the
# matching model dir.  (windows.086 would work equally -- these cgsupp helpers are
# pure integer math, OS-agnostic -- but msdos.086 is the canonical 8086 target.)
CGDIR="$TGT/../bld/clib/cgsupp/library/msdos.086/$CGMODEL"

[ -x "$OW/bwcc" ] || { echo "Open Watcom not built at $OW"; exit 1; }
[ -f "$TGT/_preincl.h" ] || "$HERE/install-cpm86-target.sh" >/dev/null
[ -d "$SRC" ] || { echo "stdcbench upstream not extracted at $SRC"; exit 1; }

WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT

# Integer benchmark modules (exclude float/double). c90lib-peep-stm8 IS included:
# c90lib-peep.c calls stm8notUsed(), which the stm8 peephole file defines -- the
# reference DR C build compiles it too, so we match it for byte-identical results.
MODS="stdcbench c90base c90base-compression c90base-data \
      c90base-huffman-iterative c90base-huffman-recursive c90base-huffman_tree \
      c90base-immul c90base-isort c90lib c90lib-htab c90lib-lnlc c90lib-peep \
      c90lib-peep-stm8"

# Copy sources into the work dir with SHORT 8.3 names (LINK-86 v1.4 rejects long
# THEADR), keep a name map. Glue headers + portme + cpmlibc alongside.
cp "$SRC"/*.c "$SRC"/*.h "$WORK/" 2>/dev/null || true
cp "$SB"/portme.c "$SB"/portme.h "$SB"/cpmlibc.c "$WORK/"
cp "$SB"/inc/*.h "$WORK/"

# portme.c: swap the owcrt-style `int cmain(void)` entry for our DRC_MAIN (which
# _preincl.h defines). Drop the `return 0;` (DRC_MAIN is void).
sed -i.bak 's/^int cmain(void)/DRC_MAIN/; s/^    return 0;/    return;/' "$WORK/portme.c"

cd "$WORK"
OBJS=""
n=0
compile() {  # compile <basename-with-.c>
    local base="$1" obj
    n=$((n+1)); obj=$(printf 'N%02d' "$n")
    # -i order: work dir (portme.h, stdcbench.h), our neutral libc headers are here
    # too; TGT for the auto-included _preincl.h (DR C convention + DRC_MAIN).
    "$OW/bwcc" -0 $MFLAGS -s -q $ZU -zl -ecc -fpi87 $SCB_EXTRA -i="$WORK" -i="$TGT" "$base" -fo="$obj.OBJ" \
        || { echo "COMPILE FAILED: $base"; exit 1; }
    python3 "$HERE/omf_classicize.py" "$obj.OBJ" "$obj.OBJ" >/dev/null
    OBJS="${OBJS:+$OBJS,}$obj"
}

for m in $MODS; do compile "$m.c"; done
compile portme.c
compile cpmlibc.c

# Open Watcom's own pre-built long-math helper objects (no hand-written asm).
# i4m.obj = __U4M/__I4M, i4d.obj = __U4D/__I4D.  For the small model the helper's
# _TEXT is merged into CODE (--merge-text-into-code) so the near CALL resolves;
# large far-calls them so no merge is needed.  See omf_classicize.py.
[ -f "$CGDIR/i4m.obj" ] || { echo "Watcom cgsupp helpers not built at $CGDIR"; exit 1; }
python3 "$HERE/omf_classicize.py" "$CGDIR/i4m.obj" "I4M.OBJ" $CGMERGE >/dev/null
python3 "$HERE/omf_classicize.py" "$CGDIR/i4d.obj" "I4D.OBJ" $CGMERGE >/dev/null

cp "$DRC/LINK86.CMD" "$DRC/$CLEAR" "$TGT/WMARKS.OBJ" "$WORK/"
echo "linking $MNAME model ($(echo "$OBJS" | tr ',' ' ' | wc -w | tr -d ' ') modules + Watcom i4m/i4d + WMARKS + $CLEAR)..."
EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" LINK86.CMD "SCB=$OBJS,I4M,I4D,WMARKS,$CLEAR" > link.log 2>&1 || true
if grep -qiE "target out|object file error" link.log; then echo "LINK FAILED:"; cat link.log; exit 1; fi
UND=$(sed -n '/Undefined/,/USE FACTOR/p' link.log | grep -E '^[a-z]' | grep -viE 'clear_error' || true)
[ -z "$UND" ] || { echo "Undefined symbols (beyond clear_error):"; echo "$UND"; cat link.log; exit 1; }
[ -f SCB.CMD ] || { echo "no SCB.CMD produced"; cat link.log; exit 1; }
cp SCB.CMD "$HERE/SCB-$MODEL.CMD"
echo "built SCB.CMD ($(stat -f%z SCB.CMD) bytes)"

# SCB_NORUN=1 skips the Unicorn run (used by scb-mame.sh, which boots the CMD in
# the real MAME rc759 driver instead -- there the genuine PICCOLINE XIOS Int 28h
# clock drives stdcbench's timing, so no CPM86_CLOCK_HZ virtual clock is needed).
if [ -n "$SCB_NORUN" ]; then echo "SCB_NORUN set -- skipping Unicorn run"; exit 0; fi

echo "=== running stdcbench ($MNAME model, unicorn runner) ==="
CPM86_CLOCK_HZ=700000 python3 "$RUNNER" SCB.CMD 2>&1 | sed 's/\r$//'

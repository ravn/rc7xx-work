#!/usr/bin/env bash
# Build one benchmark with optional extra clang flags, measure cycles.
# Usage: build_one.sh <name> <opt> <outdir> [extra clang flags...]
set -eo pipefail
name=$1; opt=$2; outdir=$3; shift 3
extra="$*"

CLANG=/Users/ravn/z80/llvm-z80/build-macos/bin/clang
LLVM_Z80=/Users/ravn/z80/llvm-z80
STUB_INC=$LLVM_Z80/compiler-rt/lib/builtins/z80/include
STUB_SRC=$LLVM_Z80/compiler-rt/lib/builtins/z80
LIB_DIR=$LLVM_Z80/build-macos/lib/z80
CRT0=$LLVM_Z80/compiler-rt/lib/builtins/z80/cpm_crt0_sdcc.rel
EXT=/Users/ravn/z80/scratch/dcc-clang-bench/extract_com_size.py
SRC=/Users/ravn/z80/dcc/tests
NTVCM=/Users/ravn/z80/ntvcm/ntvcm

case $name in
  tm)    stubs_list="heap misc printf" ;;
  ttt)   stubs_list="misc printf" ;;
  e)     stubs_list="printf" ;;
  sieve) stubs_list="printf" ;;
esac

mkdir -p "$outdir"
U=$(echo "$name" | tr a-z A-Z)

$CLANG --target=z80 -$opt -ffreestanding -nostdlibinc -isystem "$STUB_INC" \
  -ffunction-sections -fdata-sections $extra \
  -c $SRC/$name.c -o $outdir/$name.o 2>/dev/null
elf2rel $outdir/$name.o $outdir/$name.rel 2>/dev/null

stubs=""
for s in $stubs_list; do
  $CLANG --target=z80 -$opt -ffreestanding -nostdlibinc -isystem "$STUB_INC" \
    -ffunction-sections -fdata-sections $extra \
    -c $STUB_SRC/$s.c -o $outdir/${s}_stub.o 2>/dev/null
  elf2rel $outdir/${s}_stub.o $outdir/${s}_stub.rel 2>/dev/null
  stubs="$stubs $outdir/${s}_stub.rel"
done

sdldz80 -m -i -b _CODE=0x0100 $outdir/out_$name \
  $CRT0 $outdir/$name.rel $stubs -k $LIB_DIR -l z80_rt >/dev/null 2>&1
makebin -s 65536 $outdir/out_$name.ihx $outdir/out_${name}_full.bin 2>/dev/null
count=$(python3 $EXT $outdir/out_$name.map)
dd if=$outdir/out_${name}_full.bin of=$outdir/${U}.COM bs=1 skip=256 count=$count 2>/dev/null

cyc=$($NTVCM -p $outdir/${U}.COM 2>&1 | awk '/Z80.*cycles:/{gsub(/,/,"",$NF); print $NF}')
echo "$name $opt [${extra}]: ${count} B, ${cyc} cycles"


#!/usr/bin/env bash
set -euo pipefail
CLANG=/Users/ravn/z80/llvm-z80/build-macos/bin/clang
LLVM_Z80=/Users/ravn/z80/llvm-z80
STUB_INC=$LLVM_Z80/compiler-rt/lib/builtins/z80/include
STUB_SRC=$LLVM_Z80/compiler-rt/lib/builtins/z80
LIB_DIR=$LLVM_Z80/build-macos/lib/z80
CRT0=$LLVM_Z80/compiler-rt/lib/builtins/z80/cpm_crt0_sdcc.rel
EXT=/tmp/dcc_clang_compare/extract_com_size.py
OUT=/tmp/dcc_clang_compare2
SRC=/Users/ravn/z80/dcc/tests

stub_objs() {
    case $1 in
        tm)    echo "heap misc printf" ;;
        ttt)   echo "misc printf" ;;
        e)     echo "printf" ;;
        sieve) echo "printf" ;;
    esac
}

for opt in Os O1 O2 O3; do
    for name in sieve e ttt tm; do
        U=$(echo "$name" | tr a-z A-Z)
        d=$OUT/$opt

        $CLANG --target=z80 -$opt -ffreestanding -nostdlibinc \
            -isystem "$STUB_INC" -ffunction-sections -fdata-sections \
            -c $SRC/$name.c -o $d/$name.o 2>/dev/null
        elf2rel $d/$name.o $d/$name.rel 2>/dev/null

        stubs=""
        for s in $(stub_objs $name); do
            $CLANG --target=z80 -$opt -ffreestanding -nostdlibinc \
                -isystem "$STUB_INC" -ffunction-sections -fdata-sections \
                -c $STUB_SRC/$s.c -o $d/${s}_stub.o 2>/dev/null
            elf2rel $d/${s}_stub.o $d/${s}_stub.rel 2>/dev/null
            stubs="$stubs $d/${s}_stub.rel"
        done

        sdldz80 -m -i -b _CODE=0x0100 $d/out_$name \
            $CRT0 $d/$name.rel $stubs \
            -k $LIB_DIR -l z80_rt >/dev/null 2>&1

        makebin -s 65536 $d/out_$name.ihx $d/out_${name}_full.bin 2>/dev/null

        count=$(python3 $EXT $d/out_$name.map)
        dd if=$d/out_${name}_full.bin of=$d/${U}.COM \
            bs=1 skip=256 count=$count 2>/dev/null

        echo "$opt $name: $count B"
    done
done


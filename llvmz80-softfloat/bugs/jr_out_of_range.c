/* llvm-z80 bug repro: textual `-S` output emits out-of-range `jr cc,<label>`.
 *
 *   clang --target=z80 -O2 -S jr_out_of_range.c -o out.s
 *   -> out.s contains e.g.  `jr nc,.LBB0_15`  whose target is ~132 bytes away.
 *
 * The integrated assembler (`-c`) relaxes these to `jp` (object is correct),
 * but the textual .s keeps the literal `jr`, so an external Z80 assembler
 * (z88dk z80asm, via `zcc +cpm -compiler=llvmz80 -Cg-O2 -c`) rejects it:
 *   error: integer range: $84      (132 > 127, out of jr's signed 8-bit range)
 *
 * Out-of-range branch count by opt level: O0=0, O1=3, O2=3, O3=4, Os=2.
 * A workaround for the soft-float lib is to build it at -Cg-O0.
 */
#include <stdint.h>
int32_t sf_fix(uint32_t a){
    int s=(int)(a>>31), e=(int)((a>>23)&0xff); uint32_t m=a&0x7fffffu;
    if (e==0) return 0;
    if (e==0xff) return s?INT32_MIN:INT32_MAX;
    int exp=e-127;
    if (exp<0) return 0;
    if (exp>=31) return s?INT32_MIN:INT32_MAX;
    uint32_t sig=m|0x800000u; int32_t r;
    if (exp>=23) r=(int32_t)(sig<<(exp-23));
    else         r=(int32_t)(sig>>(23-exp));
    return s?-r:r;
}

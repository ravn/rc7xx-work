/* intrt_mulsi3.c -- 32-bit multiply (__mulsi3), split into its own TU.
 *
 * WHY A SEPARATE FILE: __mulsi3 lives in its own translation unit (not in
 * intrt.c with __muldi3/__udivdi3/...) so that when this runtime is packaged
 * into softfloat_cpm_z80.lib the linker pulls __mulsi3 ONLY on demand.  That
 * lets the SAME archive serve two z88dk clib routes without a duplicate
 * definition:
 *   - classic (+cpm default): nothing else provides __mulsi3 -> this module is
 *     pulled and supplies it;
 *   - newlib (-clib=newlib_iy): llvmz80_imath.lib already provides ___mulsi3
 *     (over l_mulu_32_32x32), so __mulsi3 is already resolved and THIS module
 *     is not pulled -> no "duplicate definition: ___mulsi3".
 * Were __mulsi3 bundled with __muldi3 (64-bit, which newlib lacks), pulling the
 * bundle for __muldi3 would drag __mulsi3 in too and collide with imath.
 *
 * Built from shift/add only -- zero libcall deps, cannot recurse.  Same bits
 * whether the operands are treated signed or unsigned.
 */
#include <stdint.h>

uint32_t __mulsi3(uint32_t a, uint32_t b)
{
    uint32_t r = 0;
    while (b) { if (b & 1u) r += a; a <<= 1; b >>= 1; }
    return r;
}

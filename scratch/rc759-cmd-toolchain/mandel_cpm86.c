/* mandel_cpm86.c -- the canonical fixed-point 8.8 Mandelbrot, built through the
 * NEW large-model CP/M-86 target (cc-cpm86.sh + _preincl.h + CLEARL, -zu).
 *
 * The COMPUTATION is copied verbatim from
 *   open-watcom-v2/contrib/ravn/owc-drc/mandel-ow.c
 * (the Open-Watcom IMUL variant of the DR C oracle Mandelbrot). fpmul() lowers
 * FP_MUL to one 16x16->32 signed IMUL + byte extract, so the link needs NO
 * Watcom 32-bit helper (__I4M) -- which our DR C CLEARL link would not provide.
 *
 * Only the glue differs from the original: entry is DRC_MAIN (not `int main()`
 * with owcrt.asm's cmain bridge), output goes through a tiny BDOS conout instead
 * of putchar.asm, and the width is 78 (not 80) so the RC759 console does not wrap
 * / overflow past the right margin. The fixed-point kernel is byte-for-byte the
 * oracle's.
 */
#include "drcbridge.h"          /* DRC_MAIN; auto-included by cc-cpm86.sh anyway */

/* fpmul(a,b) == (int)((long)a * b >> 8), via one 16x16 IMUL + byte extract.
 * a in AX, b in CX; imul cx -> DX:AX; (AH,DL) = product bits [8..23] = the 8.8
 * result. Our own routine -> the glue's DRC convention does not touch it. */
extern int fpmul(int a, int b);
#pragma aux fpmul =     \
    "imul cx"           \
    "mov al,ah"         \
    "mov ah,dl"         \
    parm [ax] [cx]      \
    value [ax]          \
    modify [dx];

#define FP_SHIFT 8
#define FP_ONE   (1 << FP_SHIFT)              /* 256 */
#define FP_MUL(a, b) fpmul((a), (b))
#define WIDTH  78                             /* 80 in the oracle; 78 to fit RC759 */

static void emit(param) unsigned param;       /* BDOS C_WRITE (func 2) */
{
    __asm {
        mov cl, 2
        mov dx, param
        int 0E0h
    }
}

DRC_MAIN
{
    int py, px;
    for (py = 0; py < 25; py++) {
        for (px = 0; px < WIDTH; px++) {
            int cr = -512 + px * 8;              /* px*8 == px*640/80, overflow-free */
            int ci = -320 + (py * 640 / 25);     /* py*640 (<=15360) doesn't overflow */
            int zr = 0, zi = 0;
            int iter;
            int zr2, zi2, tmp;
            for (iter = 0; iter < 30; iter++) {
                zr2 = FP_MUL(zr, zr);
                zi2 = FP_MUL(zi, zi);
                if (zr2 + zi2 > 4 * FP_ONE)
                    break;
                tmp = zr2 - zi2 + cr;
                zi = 2 * FP_MUL(zr, zi) + ci;
                zr = tmp;
            }
            emit(iter >= 30 ? '#' : " .:-=+*%@#"[iter % 10]);
        }
        emit(13);
        emit(10);
    }
}

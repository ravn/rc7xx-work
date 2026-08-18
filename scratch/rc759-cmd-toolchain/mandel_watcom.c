/* mandel_watcom.c -- clean, portable fixed-point 8.8 Mandelbrot for the
 * Open Watcom CP/M-86 target (owcc -bcpm86).  NO DR C heritage: no drcbridge.h,
 * no DRC_MAIN, no hand-written `#pragma aux fpmul`, no BDOS int E0h inline asm.
 * Everything is standard C -- Watcom's own code generator lowers the fixed-point
 * multiply to a 16x16->32 IMUL, and console output goes through the cpm86 clib's
 * putchar() (which reaches BDOS via the target runtime).
 *
 * Build + run:
 *   source scratch/cpm86-tools/ow-macos-env.sh
 *   owcc -bcpm86 -mcmodel=s -O2 -o MANDEL.CMD mandel_watcom.c
 *   scratch/cpm86-tools/emu2-cpm86/emu2 MANDEL.CMD
 */
#include <stdio.h>

#define FP_SHIFT 8
#define FP_ONE   (1 << FP_SHIFT)              /* 1.0 in 8.8 fixed point == 256 */
#define WIDTH    78                           /* fits the RC759 80-col console */
#define HEIGHT   25
#define MAXITER  30

/* fpmul(a,b) = a*b in 8.8 fixed point = (a*b) >> 8, computed in 32 bits to keep
 * the full 16x16 product before the shift.  Watcom compiles the (long)a*b to a
 * single signed IMUL and the >>8 to a byte pick -- no 32-bit helper needed.
 * Worked example: fpmul(0x0180, 0x0180) = (0x0180*0x0180)>>8 = 0x24000>>8
 *   = 0x0240 == 2.25, i.e. 1.5 * 1.5. */
static int fpmul(int a, int b)
{
    return (int)(((long)a * (long)b) >> FP_SHIFT);
}

int main(void)
{
    int py, px;

    for (py = 0; py < HEIGHT; py++) {
        for (px = 0; px < WIDTH; px++) {
            /* Map pixel -> complex plane in 8.8 fixed point.  cr spans
             * [-512,+512) == [-2.0,+2.0); ci spans [-320,+320) == [-1.25,+1.25).
             * px*8 == px*640/80 stays <= 624 so it never overflows 16 bits. */
            int cr = -512 + px * 8;
            int ci = -320 + (py * 640 / HEIGHT);
            int zr = 0, zi = 0;
            int iter, zr2, zi2, tmp;

            for (iter = 0; iter < MAXITER; iter++) {
                zr2 = fpmul(zr, zr);
                zi2 = fpmul(zi, zi);
                if (zr2 + zi2 > 4 * FP_ONE)      /* |z|^2 > 4.0 -> escaped */
                    break;
                tmp = zr2 - zi2 + cr;
                zi  = 2 * fpmul(zr, zi) + ci;
                zr  = tmp;
            }
            putchar(iter >= MAXITER ? '#' : " .:-=+*%@#"[iter % 10]);
        }
        putchar('\r');
        putchar('\n');
    }
    return 0;
}

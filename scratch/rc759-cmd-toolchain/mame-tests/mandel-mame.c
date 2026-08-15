/* mandel-mame.c -- the canonical fixed-point 8.8 Mandelbrot, rendered on the
 * REAL MAME rc759 screen (not emu2). Same compute kernel as mandel_cpm86.c /
 * the DR C oracle mandel-ow.c (one 16x16->32 signed IMUL + byte extract, so no
 * Watcom 32-bit helper is needed), driven through the large-model DR C bridge
 * (DRC_MAIN from _preincl.h) so run-mame.sh can build + boot it unchanged.
 *
 * Two differences from mandel_cpm86.c, both only about the SCREEN + the harness:
 *   1. The trailing CR/LF is emitted BEFORE each row except the first, never
 *      after the last row. On the 25-line RC759 console, a CR/LF after row 24
 *      would scroll row 0 off the top; leading-newline placement keeps all 25
 *      rows on screen when the snapshot is taken.
 *   2. After the last pixel it calls mame_done(0) (OUT 0x2FE,AX). The rc759
 *      driver does not decode 0x2FE, but done_signal.lua taps that bus cycle,
 *      snapshots the full render, and stops the emulator -- so the run ends the
 *      instant drawing completes instead of waiting out the safety cap.
 */
#include "mamedone.h"           /* mame_done(): OUT 0x2FE,AX completion signal */

/* fpmul(a,b) == (int)((long)a * b >> 8), via one 16x16 IMUL + byte extract.
 * a in AX, b in CX; imul cx -> DX:AX; (AH,DL) = product bits [8..23] = the 8.8
 * result. */
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
    mame_done(0xB000);                         /* START edge: begin render timing */
    for (py = 0; py < 25; py++) {
        if (py > 0) { emit(13); emit(10); } /* newline BEFORE each row but row 0 */
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
    }
    mame_done(0);                              /* last: render done -> stop MAME */
}

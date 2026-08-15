/* mandel_bench.c -- pure-C fixed-point 8.8 Mandelbrot, ONE source built by BOTH
 * the genuine Digital Research C v1.11 compiler AND fully-optimized Open Watcom
 * (-otexan), then TIMED on the real MAME rc759 (i80186 @ 6 MHz).
 *
 * Difference from owc-drc/mandel.c (the correctness oracle): NONE in the compute
 * kernel.  FP_MUL stays PURE C -- (int)((long)a*b>>8) -- so each compiler's own
 * 16x16->32 code generation is what gets measured (no inline-asm IMUL shortcut).
 * Only the harness glue differs:
 *   * width 78 (not 80) and a leading CR/LF before every row except row 0 (never
 *     after row 24) so all 25 rows stay on the 25-line RC759 console when the
 *     snapshot is taken;
 *   * the render is bracketed by mame_done(0xB000) (START) and mame_done(0) (END),
 *     two OUT 0x2FE bus cycles the MAME tap reads to time the run from outside.
 * putchar() and mame_done() are freestanding cdecl asm (putchar.asm/mamedone.asm),
 * so the SAME source links under DR LINK-86 and native wlink alike, and the
 * measured work is the compute loop -- not two different libc stdout paths.
 *
 * K&R / C89 hygiene (DR C v1.11 predates ANSI prototypes and mid-block decls):
 * all locals declared at the top of their block, K&R main().  Open Watcom builds
 * remap main->cmain (-Dmain=cmain) and bridge via owcrt.asm.
 */
int putchar();                  /* K&R decl */
int mame_done();                /* K&R decl: OUT 0x2FE completion/timing edge */

/* Fixed-point 8.8: 1.0 == 256, fits in 16-bit int for the [-2,2] range. */
#define FP_SHIFT 8
#define FP_ONE   (1 << FP_SHIFT)              /* 256 */
#define FP_MUL(a, b) ((int)((long)(a) * (b) >> FP_SHIFT))   /* PURE C multiply */
#define WIDTH    78                           /* 80 in the oracle; 78 to fit RC759 */

int main()
{
    int py, px;
    mame_done(0xB000);                        /* START edge: begin render timing */
    for (py = 0; py < 25; py++) {
        if (py > 0) {                         /* newline BEFORE each row but row 0 */
            putchar(13);
            putchar(10);
        }
        for (px = 0; px < WIDTH; px++) {
            int cr = -512 + px * 8;            /* px*8 == px*640/80, overflow-free */
            int ci = -320 + (py * 640 / 25);   /* py*640 (<=15360) doesn't overflow */
            int zr = 0, zi = 0;
            int iter;
            int zr2, zi2, tmp;                 /* hoisted for DR C (C89) */
            for (iter = 0; iter < 30; iter++) {
                zr2 = FP_MUL(zr, zr);
                zi2 = FP_MUL(zi, zi);
                if (zr2 + zi2 > 4 * FP_ONE)
                    break;
                tmp = zr2 - zi2 + cr;
                zi = 2 * FP_MUL(zr, zi) + ci;
                zr = tmp;
            }
            putchar(iter >= 30 ? '#' : " .:-=+*%@#"[iter % 10]);
        }
    }
    mame_done(0);                             /* END edge: render done -> stop MAME */
    return 0;
}

/* Candidate bug: llvm-z80 clang miscompiles the z88dk __smallc __z88dk_callee
 * combined calling convention (used by <graphics.h>: plot_callee, draw_callee,
 * circle_callee ...).  The real convention = LEFT-TO-RIGHT push + CALLEE cleanup.
 *
 * z88dk include/sys/compiler.h maps (under clang):
 *   __smallc       -> __attribute__((z80_smallc))   (left-to-right push, caller-clean)
 *   __z88dk_callee -> __attribute__((z80_callee))    (right-to-left push, callee-clean)
 * Both on one function should yield "left-to-right push + callee-clean".
 *
 * Build:  clang --target=z80 -S -O2 z80_smallc_callee_combine.c -o -
 * Observe: g_both is byte-identical to g_callee (right-to-left push) -- z80_smallc
 *          is silently dropped, NO diagnostic.  Expected: left-to-right push
 *          (like g_smallc) but callee cleanup (like g_callee).
 *
 * Library side (libsrc/classic/gfx/narrow/plot_callee.asm) proves the intent:
 *   plot_callee: pop bc (ret) ; pop hl (y) ; pop de (x)   <- y on top => caller
 *   must push x first, y last (left-to-right); callee pops both (callee-clean).
 */
extern void both(int a, int b)   __attribute__((z80_smallc)) __attribute__((z80_callee));
extern void smallc(int a, int b) __attribute__((z80_smallc));
extern void callee(int a, int b) __attribute__((z80_callee));
void g_both(void)   { both(0x1111, 0x2222); }
void g_smallc(void) { smallc(0x1111, 0x2222); }
void g_callee(void) { callee(0x1111, 0x2222); }

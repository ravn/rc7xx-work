/* Watcom side of the Watcom->DR C ABI bridge, SCALAR case (the "hole through").
 *
 * Proves Watcom-compiled code can call a genuine DR C 1.11-compiled routine
 * (`add`, from bridge_add_lib.c) across the compiler boundary and get the
 * correct result, with CLEARL's own startup driving the program.
 *
 * The bridge is expressed entirely in a Watcom aux pragma:
 *   #pragma aux drc_add "add" parm caller [] value [ax] far;
 *     "add"        -> emit the bare DR C symbol name (no watcall underscore)
 *     parm caller  -> caller cleans the stack (cdecl), i.e. `add sp,N` after call
 *     []           -> empty register set: push ALL args on the stack L->R? no:
 *                     Watcom pushes them right-to-left, matching DR C.
 *     value [ax]   -> integer return in AX (DX:AX for long), like DR C
 *     far          -> emit `call far` / expect `retf`
 *
 * Exposing our entry as bare far `main` via `#pragma aux drc_main "main" far`
 * lets CLEARL's `_main` startup call us directly -- NO hand-written crt0.
 *
 * SCALAR ONLY: args/returns are ints, so there is no pointer -> no dependency
 * on the DS/SS segment split. (Pointer args are a separate, documented blocker;
 * see wlink-cpm86-plan.md finding (d).)
 *
 * Expected output: "16\r\n"  (add(7,9) = 16)
 */
extern int drc_add(int a, int b);
#pragma aux drc_add "add" parm caller [] value [ax] far;

extern void drc_main(void);
#pragma aux drc_main "main" far;

static void conout(param) unsigned param;
{
    __asm { mov cl,2
            mov dx,param
            int 0E0h }
}

void drc_main(void)
{
    int r = drc_add(7, 9);          /* cross-compiler call: Watcom -> DR C */
    conout('0' + (r / 10));         /* r == 16 -> '1' */
    conout('0' + (r % 10));         /*         -> '6' */
    conout(13);
    conout(10);
}

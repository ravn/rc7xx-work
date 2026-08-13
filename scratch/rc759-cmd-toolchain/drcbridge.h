/* drcbridge.h -- reusable Open Watcom -> DR C 1.11 ABI bridge (large model).
 *
 * Include this, then for each DR C library/routine you call, write ONE line:
 *     extern unsigned strlen(char *s);
 *     #pragma aux (DRC) strlen;
 * and define your entry point with the DRC_MAIN macro:
 *     DRC_MAIN { ... }
 *
 * That is the entire per-program surface. Build with:  bwcc -0 -ml -s -q -zu
 * and link the classicized OBJ + this-file's marker stub + CLEARL.L86 under
 * LINK-86 (see bridge-min.sh). No hand-written crt0: DR C's CLEARL startup runs
 * and calls our entry (exported as bare far "main").
 *
 * WHY each piece (all verified, see wlink-cpm86-plan.md findings d/e/f):
 *  - `DRC` convention: `parm caller [] value [ax] far` == DR C's large-model
 *    cdecl (args pushed right-to-left, caller cleans, return in AX/DX:AX, retf).
 *  - `"*"` alias: emit the bare symbol name (DR C exports `strlen`, not `strlen_`).
 *  - entry named `drc_main` (NOT `main`): the literal name `main` makes Watcom
 *    pull in its own startup `_cstart_`; aliasing `drc_main` -> "main" exports the
 *    bare far entry CLEARL calls, with no _cstart_ dependency.
 *  - build flag `-zu` (SS != DGROUP): without it Watcom passes a data pointer's
 *    segment as `push ss`, but DR C runs SS != DS, so the callee reads the wrong
 *    segment. `-zu` emits a real DGROUP segment fixup instead.
 */
#ifndef DRCBRIDGE_H
#define DRCBRIDGE_H

/* DR C large-model calling convention; "*" -> bare (un-mangled) symbol name. */
#pragma aux DRC "*" parm caller [] value [ax] far;

/* Entry: define with DRC_MAIN { ... }. Exported as bare far "main" for CLEARL. */
void drc_main(void);
#pragma aux drc_main "main" far;
#define DRC_MAIN void drc_main(void)

#endif /* DRCBRIDGE_H */

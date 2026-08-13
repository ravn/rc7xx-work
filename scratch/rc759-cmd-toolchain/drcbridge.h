/* drcbridge.h -- reusable Open Watcom -> DR C 1.11 ABI bridge (small + large).
 *
 * Include this, then for each DR C library/routine you call, write ONE line:
 *     extern unsigned strlen(char *s);
 *     #pragma aux (DRC) strlen;
 * and define your entry point with the DRC_MAIN macro:
 *     DRC_MAIN { ... }
 *
 * IMPORTANT -- apply `#pragma aux (DRC) fn;` ONLY to routines that live in DR C's
 * own stdlib (CLEARL/CLEARS). Your OWN Watcom-compiled routines (and your own
 * libraries) must NOT get it: declare them as plain `extern` with no pragma so
 * they keep Watcom's native convention. The named `(DRC)` convention is applied
 * per symbol precisely so it touches nothing else. Verified: a program calling
 * both DR C `strlen` (via DRC) and an own Watcom `triple()` (native) links and
 * runs correctly -- see bridge-mixed.sh. (This is also why a module-wide
 * `#pragma aux default` is WRONG here: it would drag your own code onto the DR C
 * convention too.)
 *
 * That is the entire per-program surface. Build with cc-cpm86.sh, which selects
 * the model:  large =  bwcc -0 -ml -s -q -zu  + link CLEARL.L86;  small =
 * bwcc -0 -ms -s -q -zu -nt=CODE  + link CLEARS.L86. Both classicize the OBJ and
 * link this-file's marker stub under LINK-86 (see mandel-cpm86.sh). No
 * hand-written crt0: DR C's own startup runs and calls our entry (bare "main").
 *
 * WHY each piece (all verified, see wlink-cpm86-plan.md findings d/e/f):
 *  - `DRC` convention: `parm caller [] value [ax]` == DR C's cdecl (args pushed
 *    right-to-left, caller cleans, return in AX/DX:AX). The call is FAR in the
 *    large model (retf) and NEAR in the small model (ret); we key that off
 *    Watcom's predefined `__LARGE__` / `__SMALL__` so the SAME source builds for
 *    both `-ml` (link CLEARL.L86) and `-ms -nt=CODE` (link CLEARS.L86). Getting
 *    the far/near wrong is not a link error: it MISCOMPILES the return -- a far
 *    `main` returned to by CLEARS's near-calling XMAIN pops IP+CS and lands in
 *    garbage (observed as emu2 "unimplemented opcode 63" on exit).
 *  - `"*"` alias: emit the bare symbol name (DR C exports `strlen`, not `strlen_`).
 *  - entry named `drc_main` (NOT `main`): the literal name `main` makes Watcom
 *    pull in its own startup `_cstart_`; aliasing `drc_main` -> "main" exports the
 *    bare entry CLEARL/CLEARS calls, with no _cstart_ dependency.
 *  - build flag `-zu` (SS != DGROUP): without it Watcom passes a data pointer's
 *    segment as `push ss`, but DR C runs SS != DS, so the callee reads the wrong
 *    segment. `-zu` emits a real DGROUP segment fixup instead.
 *  - small model additionally needs `-nt=CODE`: it names Watcom's text segment
 *    CODE so it merges with CLEARS's CODE group, making XMAIN's NEAR call to
 *    `main` in range (else LINK-86 reports TARGET OUT OF RANGE).
 */
#ifndef DRCBRIDGE_H
#define DRCBRIDGE_H

/* DR C calling convention; "*" -> bare (un-mangled) symbol name. The call is far
 * in the large model, near in the small model -- pick it from Watcom's model
 * macro so one source serves both. */
#ifdef __LARGE__
#pragma aux DRC "*" parm caller [] value [ax] far;
#else
#pragma aux DRC "*" parm caller [] value [ax];
#endif

/* Entry: define with DRC_MAIN { ... }. Exported as bare "main" for DR C's
 * startup (CLEARL far / CLEARS near). */
void drc_main(void);
#ifdef __LARGE__
#pragma aux drc_main "main" far;
#else
#pragma aux drc_main "main";
#endif
#define DRC_MAIN void drc_main(void)

#endif /* DRCBRIDGE_H */

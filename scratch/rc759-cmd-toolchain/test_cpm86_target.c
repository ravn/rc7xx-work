/*
 * Regression probe for the first-class -bt=cpm86 compiler target.
 *
 * Compile with:   wcc test_cpm86_target.c -bt=cpm86 -0 -ms -i="$WATCOM/h"
 * (or:            owcc -bcpm86 -c test_cpm86_target.c)
 *
 * It must compile cleanly under -bt=cpm86 and FAIL under -bt=dos, proving:
 *   - __CPM86__ is the distinguishing marker unique to CP/M-86, and
 *   - the DOS-family macros (__DOS__/_DOS/MSDOS) are ALSO defined, so
 *     CP/M-86 remains a drop-in DOS-family target for headers/clib.
 *
 * See tasks/memory/reference_cpm86_vs_msdos_model.md and README-cpm86.md.
 */

#ifndef __CPM86__
#error "__CPM86__ not defined -- build with -bt=cpm86 (this proves the marker)"
#endif

/* CP/M-86 is a DOS-family target: the DOS macros must be present too. */
#ifndef __DOS__
#error "__DOS__ not defined under -bt=cpm86 -- DOS header/clib compat lost"
#endif
#ifndef _DOS
#error "_DOS not defined under -bt=cpm86"
#endif
#ifndef MSDOS
#error "MSDOS not defined under -bt=cpm86"
#endif

int cpm86_target_ok = 1;

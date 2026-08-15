#include <stdlib.h>

/* Exception-handling / setjmp support seams for the CP/M-86 clib.
 *
 * Track B links Watcom's own 8086 setjmp/longjmp (setjmp86.obj, assembled from
 * bld/clib/startup/a/stjmp086.asm for the small model). That object, plus the EH
 * runtime plbxs.lib, leaves exactly these clib symbols undefined (trial-link of
 * eh_test.cpp, 2026-08-15): ___longjmp_handler, __get_ovl_stack,
 * __restore_ovl_stack, __clib_exit_. We supply them here.
 *
 * NOTE on naming: Watcom cdecl prepends ONE '_' to C globals, so to land the asm
 * symbol `__get_ovl_stack` (two underscores) the C name is `_get_ovl_stack`, and
 * `___longjmp_handler` <- C `__longjmp_handler`. */

/* longjmp's low-level hook. In the non-overlay DOS model longjmp does a NEAR
 * indirect `call [___longjmp_handler]` (small-model function pointers are near,
 * 2 bytes) passing the old SP in AX per the handler's arg convention
 * (__parm __caller [__ax __dx], from ljmphdl.h). The correct default is a near
 * no-op. The C++ EH's ljmpinit.cpp OVERWRITES this pointer with its own
 * lj_handler at startup, so this default only governs plain C setjmp/longjmp.
 *
 * CRITICAL: it must be a NEAR pointer to a NEAR proc -- an earlier __far version
 * did a `retf` against longjmp's near `call`, unbalancing the stack so longjmp
 * "returned" into the exit path (C setjmp broke while C++ EH, which replaced the
 * handler, still worked). */
typedef void (*_ljfun)( void __far * );
#pragma aux _lj_conv __parm __caller [__ax __dx]
#pragma aux (_lj_conv) _ljfun
static void _lj_default( void __far *p ) { (void)p; }
#pragma aux (_lj_conv) _lj_default
_ljfun __longjmp_handler = _lj_default;

/* Overlay-stack hooks: null in a non-overlay program. setjmp/longjmp test them by
 * value (`or ax, word ptr __get_ovl_stack`) and skip the call when zero. */
void __far *_get_ovl_stack = 0;
void __far *_restore_ovl_stack = 0;

/* EH terminate path (plbxs termnate.cpp) bottoms out here; just exit. */
void __clib_exit( int ret_code ) { exit( ret_code ); }

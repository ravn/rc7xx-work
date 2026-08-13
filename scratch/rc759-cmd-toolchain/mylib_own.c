/* mylib_own.c -- one of OUR OWN routines, compiled by Watcom. It must keep
 * Watcom's NATIVE calling convention: it gets NO `#pragma aux (DRC)`. Only DR C
 * stdlib routines get the DRC bridge convention. See bridge_mixed.c / drcbridge.h.
 */
int triple(int x) { return x + x + x; }

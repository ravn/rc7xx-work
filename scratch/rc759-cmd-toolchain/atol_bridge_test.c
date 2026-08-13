/* atol_bridge_test.c -- prove the DR C long-return ABI bridge (DRC_LONG).
 *
 * DR C's atol returns its long in BX:AX (VERIFIED by disassembling CLEARL's
 * ATOL module: epilogue `pop ax; pop bx; ... retf` -> AX=low word, BX=high
 * word). Open Watcom's default long-return convention is DX:AX. So a Watcom
 * caller of DR C atol reads the HIGH word from the wrong register unless the
 * aux pragma pins `value [bx ax]` (the DRC_LONG alias in _preincl.h).
 *
 * atol("70000") = 70000 = 0x0001_1170. We emit the 8 hex digits of the returned
 * long via BDOS C_WRITE. Correct bridge -> "00011170". Before the fix Watcom
 * read DX:AX and printed "00001170" (high word 0x0001 was stranded in BX while
 * DX held 0). Verified end-to-end under emu2 against the genuine DR C runtime.
 *
 * (The double-return alias DRC_DBL / atof -> DX:CX:BX:AX is likewise verified by
 * disassembly of the ATOF epilogue, but a clean RUNTIME double proof is confounded
 * by DR C's separate "nofloat" atof-stub linkage, so it is not asserted here.)
 */
#include "drcbridge.h"          /* not strictly needed; cc-cpm86 auto-incls glue */

extern long atol();             /* DR C: returns long in BX:AX */

static void emit(param) unsigned param;        /* BDOS C_WRITE (func 2) */
{
    __asm {
        mov cl, 2
        mov dx, param
        int 0E0h
    }
}

static void emit_hex16(v) unsigned v;          /* 4 hex digits, high nibble first */
{
    int i;
    for (i = 12; i >= 0; i -= 4) {
        int nib = (v >> i) & 0xF;
        emit(nib < 10 ? '0' + nib : 'A' + nib - 10);
    }
}

DRC_MAIN
{
    long l;
    l = atol("70000");                          /* 0x00011170 */
    emit_hex16((unsigned)(l >> 16));            /* high word -> "0001" */
    emit_hex16((unsigned)(l & 0xFFFF));         /* low  word -> "1170" */
    emit(13); emit(10);
}

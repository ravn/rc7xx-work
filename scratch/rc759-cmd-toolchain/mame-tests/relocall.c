/* relocall.c -- decisive: CALL through a far pointer to code.
 * If the far pointer's segment was correctly relocated the call reaches
 * code_target and prints 'B'; if the segment is left group-relative the
 * far call jumps into garbage (crash/hang, no 'B'). */
#include "drcbridge.h"

static void emit(param) unsigned param;
{
    __asm {
        mov cl, 2
        mov dx, param
        int 0E0h
    }
}

void code_target(void);
void code_target(void) { emit('B'); }

void (*fp)(void) = code_target;   /* far code pointer with load-time fixup */

DRC_MAIN
{
    emit('A');
    (*fp)();          /* far call through the relocated pointer */
    emit('C');
    emit('\r'); emit('\n');
}

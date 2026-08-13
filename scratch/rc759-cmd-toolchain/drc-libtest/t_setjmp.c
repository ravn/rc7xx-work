#include "drctest.h"

/* setjmp / longjmp: setjmp returns 0 on the direct call, then the value passed
 * to longjmp (non-zero) when control jumps back. jmp_buf is DR C's (opaque);
 * we size it generously. */

int jbuf[64];

sub(n)
int n;
{
    if (n > 0) longjmp(jbuf, n + 100);
    return 0;
}

TMAIN
{
    int r;

    r = setjmp(jbuf);
    printf("setjmp: %d\n", r);
    if (r == 0) {
        sub(7);
        printf("unreachable\n");
    } else {
        printf("after longjmp: %d\n", r);
    }
}

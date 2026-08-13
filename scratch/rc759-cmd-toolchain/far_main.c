/* far_main.c -- minimal large-model CP/M-86 demo entry.
 *
 * Fills a global array, then calls fold()/pick() which live in far_lib.c (a
 * separate module -> FAR calls in the large model), and prints the results in
 * decimal through a tiny BDOS C_WRITE.  No DR C stdlib, no 32-bit helpers: the
 * only thing under test is that the large-model program -- its second code
 * group and its far data pointers -- loads and runs correctly under the runner.
 *
 * Build:  ./cc-cpm86.sh -m l -o FARDEMO.CMD far_main.c far_lib.c
 * Expect: two lines, "fold=<n>" and "pick=<n>", identical under the Unicorn
 * runner and emu2 (and matching the host-computed reference).
 */
#include "drcbridge.h"

#define N 100

extern unsigned fold(int *a, unsigned n);   /* far_lib.c -- own Watcom code, */
extern unsigned pick(int *a, unsigned i);   /* NO (DRC) pragma (see bridge). */

static int arr[N];

static void emit(param) unsigned param;         /* BDOS C_WRITE (func 2) */
{
    __asm {
        mov cl, 2
        mov dx, param
        int 0E0h
    }
}

static void puts_(char *s)
{
    while(*s)
        emit((unsigned)(unsigned char)*s++);
}

/* print a 16-bit unsigned in decimal (16-bit divide -> no runtime helper) */
static void putu(unsigned v)
{
    char buf[6];
    int i = 0;
    if(v == 0)
    {
        emit('0');
        return;
    }
    while(v)
    {
        buf[i++] = (char)('0' + v % 10u);
        v /= 10u;
    }
    while(i)
        emit((unsigned)buf[--i]);
}

DRC_MAIN
{
    unsigned i, f, p;

    for(i = 0; i < N; i++)
        arr[i] = (int)(unsigned)(i * 7u + 3u);

    f = fold(arr, N);           /* far call + far array pointer */
    p = pick(arr, 50u);         /* far indexing from the other module */

    puts_("fold=");
    putu(f);
    emit('\r');
    emit('\n');
    puts_("pick=");
    putu(p);
    emit('\r');
    emit('\n');
}

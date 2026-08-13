#include "drctest.h"

/* qsort (with a callback -- exercises DR C -> Watcom-comparator call ABI) and
 * rand/srand (deterministic sequence from a fixed seed; both toolchains call
 * the SAME DR C generator, so the streams must match). */

int icmp(a, b)
char *a, *b;
{
    int x, y;
    x = *(int *)a;
    y = *(int *)b;
    if (x < y) return -1;
    if (x > y) return 1;
    return 0;
}

TMAIN
{
    int v[8];
    int i;

    v[0]=5; v[1]=2; v[2]=8; v[3]=1; v[4]=9; v[5]=3; v[6]=7; v[7]=4;
    qsort(v, 8, sizeof(int), icmp);
    printf("qsort:");
    for (i = 0; i < 8; i++) printf(" %d", v[i]);
    printf("\n");

    srand(1);
    printf("rand s1:");
    for (i = 0; i < 5; i++) printf(" %d", rand() & 0x7fff);
    printf("\n");

    srand(42);
    printf("rand s42:");
    for (i = 0; i < 5; i++) printf(" %d", rand() & 0x7fff);
    printf("\n");
}

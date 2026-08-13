#include "drctest.h"

/* Dynamic memory: malloc, free, calloc, realloc. Exercises the DRC_PTR bridge
 * (far pointer BX:AX in large model). We print CONTENTS, not addresses (which
 * differ between toolchains), so the differential diff is meaningful. */

TMAIN
{
    char *p;
    char *q;
    int *a;
    int i;

    p = malloc(16);
    strcpy(p, "malloc-ok");
    printf("malloc: %s\n", p);

    /* calloc must zero-initialise */
    a = (int *) calloc(5, sizeof(int));
    printf("calloc zero: %d %d %d\n", a[0], a[2], a[4]);
    for (i = 0; i < 5; i++) a[i] = i * 10;
    printf("calloc set: %d %d %d\n", a[0], a[2], a[4]);

    /* realloc grows, preserving the old bytes */
    q = realloc(p, 32);
    strcat(q, "-grown");
    printf("realloc: %s\n", q);

    free(q);
    free(a);
    printf("free: done\n");

    /* alloc after free still works */
    p = malloc(8);
    strcpy(p, "again");
    printf("reuse: %s\n", p);
    free(p);
}

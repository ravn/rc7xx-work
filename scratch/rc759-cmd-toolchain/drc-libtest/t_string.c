#include "drctest.h"

/* String + memory-block routines. Output is deterministic; drc-libtest.sh
 * diffs the bridge build against the genuine DR C build. */

TMAIN
{
    char buf[64];
    char b2[64];
    char *p;
    int i;

    printf("strlen: %u\n", strlen("hello world"));

    strcpy(buf, "abc");
    printf("strcpy: %s\n", buf);

    strcat(buf, "DEF");
    printf("strcat: %s\n", buf);

    strncpy(b2, "1234567", 4);
    b2[4] = '\0';
    printf("strncpy: %s\n", b2);

    strcpy(b2, "XY");
    strncat(b2, "abcdef", 3);
    printf("strncat: %s\n", b2);

    printf("strcmp eq: %d\n", strcmp("foo", "foo"));
    printf("strcmp lt: %d\n", strcmp("abc", "abd") < 0);
    printf("strcmp gt: %d\n", strcmp("abd", "abc") > 0);
    printf("strncmp: %d\n", strncmp("abcXX", "abcYY", 3));

    p = strchr("a.b.c", '.');
    printf("strchr: %s\n", p);
    p = strrchr("a.b.c", '.');
    printf("strrchr: %s\n", p);
    p = index("a.b.c", 'b');
    printf("index: %s\n", p);
    p = rindex("a.b.c", 'c');
    printf("rindex: %s\n", p);

    strcpy(buf, "ABCD");
    swab(buf, b2, 4);
    b2[4] = '\0';
    printf("swab: %s\n", b2);

    /* blkfill / blkmove: DR C block ops (dst, src/val, count) */
    for (i = 0; i < 8; i++) buf[i] = '?';
    blkfill(buf, '*', 5);
    buf[8] = '\0';
    printf("blkfill: %s\n", buf);

    strcpy(buf, "SOURCE!!");
    blkmove(b2, buf, 6);
    b2[6] = '\0';
    printf("blkmove: %s\n", b2);
}

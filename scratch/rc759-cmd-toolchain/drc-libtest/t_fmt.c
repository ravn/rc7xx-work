#include "drctest.h"

/* sprintf / sscanf conformance. Each specifier is tested in its OWN sprintf
 * call: DR C's printf engine desyncs its vararg cursor on some multi-specifier
 * sequences (e.g. "%u %x" reads stack garbage -- reproducible in GENUINE DR C,
 * so it is a DR C printf quirk, not a bridge fault). Per-call testing gives
 * clean, deterministic per-specifier coverage that both toolchains reproduce.
 * Note: DR C %x emits UPPERCASE hex; %X is unsupported. */

TMAIN
{
    char buf[80];
    int a, b, c;
    char word[32];

    sprintf(buf, "%d", -12345);   printf("d: %s\n", buf);
    sprintf(buf, "%u", 40000);    printf("u: %s\n", buf);
    sprintf(buf, "%x", 255);      printf("x: %s\n", buf);
    sprintf(buf, "%o", 64);       printf("o: %s\n", buf);
    sprintf(buf, "%s", "hello");  printf("s: %s\n", buf);
    sprintf(buf, "%c", 'Q');      printf("cc: %s\n", buf);
    sprintf(buf, "%5d|%-5d|%05d", 42, 42, 42); printf("pad: %s\n", buf);
    sprintf(buf, "%d/%s/%c", 7, "mid", 'Z');   printf("mix: %s\n", buf);

    a = b = c = 0;
    sscanf("10 20 30", "%d %d %d", &a, &b, &c);
    printf("scan ints: %d %d %d\n", a, b, c);

    a = 0; word[0] = '\0';
    sscanf("hello 99", "%s %d", word, &a);
    printf("scan mixed: %s %d\n", word, a);
}

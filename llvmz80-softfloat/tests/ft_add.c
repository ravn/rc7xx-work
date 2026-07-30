/* ft_add.c -- Phase 1 on-target runtime float test (NO multiply).
 * Exercises __addsf3 __subsf3 __fixsfsi __gtsf2 __ltsf2 __eqsf2.
 * Expected output (verified against native semantics):
 *   s=5 d=1 e=105 f=94
 *   gt=1 lt=0 eq=1
 *   acc=35
 * Only integer printf (%d) is used -- %f is Phase 4.
 */
#include <stdio.h>

volatile float va = 3.5f, vb = 2.0f, vc = 100.25f;

int main(void)
{
    float a = va, b = vb, c = vc;
    float s = a + b;          /* 5.5  */
    float d = a - b;          /* 1.5  */
    float e = c + a + b;      /* 105.75 */
    float f = c - a - b;      /* 94.75  */
    printf("s=%d d=%d e=%d f=%d\n", (int)s, (int)d, (int)e, (int)f);
    printf("gt=%d lt=%d eq=%d\n", a > b, a < b, s == s);

    float acc = 0.0f;
    for (int i = 0; i < 10; i++) acc = acc + a;   /* 35.0 */
    printf("acc=%d\n", (int)acc);
    return 0;
}

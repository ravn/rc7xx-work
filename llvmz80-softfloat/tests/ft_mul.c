/* ft_mul.c -- Phase 2 on-target runtime float test (multiply + divide).
 * Exercises __mulsf3 __divsf3 (plus __addsf3 in the accumulate loop).
 * Expected output (verified against native IEEE-754 semantics):
 *   m=3 q2=25 sq=9 r=2
 *   qq=1 pacc=1024
 * Only integer printf (%d) is used -- %f is Phase 4.
 */
#include <stdio.h>

volatile float va = 6.0f, vb = 0.5f, vc = 100.0f, vd = 8.0f, ve = 3.0f;

int main(void)
{
    float m  = va * vb;          /* 3.0   */
    float q  = vc / vd;          /* 12.5  */
    float sq = ve * ve;          /* 9.0   */
    float r  = va / ve;          /* 2.0   */
    printf("m=%d q2=%d sq=%d r=%d\n", (int)m, (int)(q * 2.0f), (int)sq, (int)r);

    float qq = vb * vb * 4.0f;   /* 0.25 * 4 = 1.0 */
    float pacc = 1.0f;
    for (int i = 0; i < 10; i++) pacc = pacc * 2.0f;   /* 1024.0 */
    printf("qq=%d pacc=%d\n", (int)qq, (int)pacc);
    return 0;
}

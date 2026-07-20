/* ft_int.c -- on-target runtime test for the integer runtime helpers.
 * Exercises __mulsi3 (32-bit *), __muldi3 (64-bit *), __udivdi3/__divdi3
 * (64-bit /), __moddi3/__umoddi3 (64-bit %). Z80 `int` is 16-bit, so results
 * are printed with %ld (32-bit) after reducing the 64-bit values to a witness.
 * Expected output (verified against native IEEE/two's-complement semantics):
 *   p=7006652
 *   quo=1000003 rem=99
 *   sdv=-1000003 smd=-2
 */
#include <stdio.h>

volatile long a = 1234, b = 5678;
volatile long long x = 1000003LL, y = 1000033LL, z = 42LL;

int main(void)
{
    long p = a * b;                    /* 7006652        -> __mulsi3 */
    long long prod = x * y;            /* 1000036000099  -> __muldi3 */
    long long quo  = prod / y;         /* 1000003        -> __udivdi3/__divdi3 */
    long long rem  = prod % 1000000LL; /* 99             -> __moddi3 */
    long long sq   = (-x) * z;         /* -42000126      signed __muldi3 */
    long long sdv  = sq / z;           /* -1000003       signed __divdi3 */
    long long smd  = (-100LL) % 7LL;   /* -2 (sign of dividend) __moddi3 */

    printf("p=%ld\n", p);
    printf("quo=%ld rem=%ld\n", (long)quo, (long)rem);
    printf("sdv=%ld smd=%ld\n", (long)sdv, (long)smd);
    return 0;
}

/* ft_dbl.c -- on-target runtime test for double precision (Berkeley SoftFloat).
 * Exercises __adddf3 __subdf3 __muldf3 __divdf3, __extendsfdf2 __truncdfsf2
 * __floatsidf __fixdfsi, and the comparison shims. Z80 `int` is 16-bit so
 * results are printed with %ld after scaling fractionals to integers.
 * Expected output (verified against native IEEE-754 double semantics):
 *   s=10 m=21 d=-4 q10=2333
 *   df10=15 sf=1000000 fx=1000000 di=-42
 *   gt=0 lt=1 eq=1 ne=0
 */
#include <stdio.h>

volatile double a = 3.0, b = 7.0;
volatile float  vf = 1.5f;
volatile int    vi = -42;

int main(void)
{
    double s = a + b;            /* 10.0  */
    double m = a * b;            /* 21.0  */
    double d = a - b;            /* -4.0  */
    double q = b / a;            /* 2.3333.. */
    printf("s=%ld m=%ld d=%ld q10=%ld\n",
           (long)s, (long)m, (long)d, (long)(q * 1000.0));

    double df  = vf;             /* __extendsfdf2 : 1.5  */
    double big = 1000000.0;
    float  sf  = (float)big;     /* __truncdfsf2  : 1000000.0f */
    long   fx  = (long)big;      /* __fixdfsi     : 1000000 */
    double di  = vi;             /* __floatsidf   : -42.0 */
    printf("df10=%ld sf=%ld fx=%ld di=%ld\n",
           (long)(df * 10.0), (long)sf, fx, (long)di);

    printf("gt=%d lt=%d eq=%d ne=%d\n", a > b, a < b, a == a, a != a);
    return 0;
}

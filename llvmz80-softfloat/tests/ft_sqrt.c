/* ft_sqrt.c -- verify sqrt/fabs/copysign (SoftFloat-backed libm layer).
 * Z80 int is 16-bit; print scaled longs.
 * Expected (native double): sq2=14142 sq2b=17320 fa=15 cs=-25
 *   sqrt(2)*1e4 = 14142.135  -> 14142
 *   sqrt(3)*1e4 = 17320.508  -> 17320
 *   fabs(-1.5)*10 = 15
 *   copysign(2.5,-1)*10 = -25
 */
#include <stdio.h>
double sqrt(double), fabs(double), copysign(double,double);

volatile double two = 2.0, three = 3.0, nn = -1.5, pp = 2.5, neg = -1.0;

int main(void)
{
    printf("sq2=%ld sq2b=%ld fa=%ld cs=%ld\n",
           (long)(sqrt(two)   * 10000.0),
           (long)(sqrt(three) * 10000.0),
           (long)(fabs(nn)    * 10.0),
           (long)(copysign(pp, neg) * 10.0));
    return 0;
}

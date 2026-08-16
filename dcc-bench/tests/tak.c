/*
  tak.c — Takeuchi function (the classic Gabriel-suite TAK), a canonical
  recursion benchmark.  Three-argument mutual/self recursion with only
  subtraction and comparison per node, so — like Ackermann — it exercises
  the call path far more than the ALU.

  Oracle: the Gabriel TAK point tak(18,12,6) == 7, with ~63609 calls.
  All values fit a 16-bit int (Z80 int == 16-bit).
*/

#include <stdio.h>

int tak(int x, int y, int z)
{
    if (y < x)
        return tak(tak(x - 1, y, z),
                   tak(y - 1, z, x),
                   tak(z - 1, x, y));
    return z;
}

int main(void)
{
    printf("tak(18,12,6)=%d\n", tak(18, 12, 6)); /* 7 */
    return 0;
}

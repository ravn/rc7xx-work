/*
  ackermann.c — the Ackermann-Peter function, a canonical deep-recursion
  benchmark (no memoization).  Purely integer; every call does trivial
  arithmetic but the call tree is enormous, so it stresses the call/return
  path and frame handling, not the ALU.

  A(m,n) closed forms used as the oracle:
      A(3,n) = 2^(n+3) - 3
      A(3,6) = 2^9 - 3 = 509
  Number of calls for A(3,6) is ~172233, so this is a substantial run while
  the result still fits a 16-bit int (Z80 int == 16-bit).
*/

#include <stdio.h>

int ackermann(int m, int n)
{
    if (m == 0)
        return n + 1;
    if (n == 0)
        return ackermann(m - 1, 1);
    return ackermann(m - 1, ackermann(m, n - 1));
}

int main(void)
{
    int m = 3, n = 6;
    printf("ackermann(%d,%d)=%d\n", m, n, ackermann(m, n)); /* 509 */
    return 0;
}

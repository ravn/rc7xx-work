/*
  hanoi.c — Towers of Hanoi, a canonical recursion benchmark.  Doubly
  recursive; we only COUNT moves (no per-move printf) so the run is
  CPU/recursion-bound, not I/O-bound.

  Oracle: n disks require 2^n - 1 moves.
      hanoi(20) = 1048575 moves, with 2*1048575+1 = 2097151 calls.
  moves is `unsigned long` (32-bit) so the count exceeds the 16-bit range,
  deliberately exercising 32-bit integer arithmetic on top of the recursion
  (nqueens.c covers the smaller long path; this pushes past 2^16).
*/

#include <stdio.h>

unsigned long moves;

void hanoi(int n, char from, char to, char via)
{
    if (n == 0)
        return;
    hanoi(n - 1, from, via, to);
    moves++;
    hanoi(n - 1, via, to, from);
}

int main(void)
{
    int n = 20;
    moves = 0;
    hanoi(n, 'A', 'C', 'B');
    printf("hanoi(%d) moves=%lu\n", n, moves); /* 1048575 */
    return 0;
}

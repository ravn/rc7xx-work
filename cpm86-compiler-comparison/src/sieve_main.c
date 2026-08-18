/* sieve_main.c -- runnable driver for the sieve kernel.
 *
 * sieve.c is a bare code-size kernel with no main(), so it cannot link into a
 * runnable .CMD on its own. This driver supplies main(), calls the kernel once,
 * and prints the prime count (1899 for SZ=8190) as a verification marker.
 * Kept in the K&R/C89 common subset so it builds under all four compilers.
 */
#include <stdio.h>
#include "mame_bracket.h"

extern int sieve();

#ifndef REPS
#define REPS 1
#endif

int main()
{
    int r, last;
    MAME_START();
    for (r = 0; r < REPS; r++) last = sieve();
    MAME_END();
    printf("sieve primes=%d\n", last);
    return 0;
}

/* sieve_main.c -- runnable driver for the sieve kernel.
 *
 * sieve.c is a bare code-size kernel with no main(), so it cannot link into a
 * runnable .CMD on its own. This driver supplies main(), calls the kernel once,
 * and prints the prime count (1899 for SZ=8190) as a verification marker.
 * Kept in the K&R/C89 common subset so it builds under all four compilers.
 */
#include <stdio.h>

extern int sieve();

int main()
{
    printf("sieve primes=%d\n", sieve());
    return 0;
}

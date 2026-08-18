/* Classic Byte-magazine Eratosthenes sieve, one iteration.
 * Written in the K&R/C89 common subset so it compiles UNCHANGED on all four
 * CP/M-86 compilers under comparison:
 *   - DR C 1.11        (K&R C89: old-style defs, char is unsigned)
 *   - Aztec C86 3.40a  (K&R)
 *   - Aztec C86 4.2    (ANSI, accepts the K&R form too)
 *   - Open Watcom      (ANSI, accepts the K&R form too)
 *
 * Only the sieve() function body is measured (its emitted machine-code bytes);
 * flags[] is BSS and does not count toward code size. Keep this file free of
 * prototypes and ANSI-only constructs so the ONE source drives every compiler.
 */
#define SZ 8190
char flags[SZ + 1];

sieve()
{
    int i, k, prime, count;
    count = 0;
    for (i = 0; i <= SZ; i++) flags[i] = 1;
    for (i = 0; i <= SZ; i++) {
        if (flags[i]) {
            prime = i + i + 3;
            for (k = i + prime; k <= SZ; k += prime) flags[k] = 0;
            count++;
        }
    }
    return count;
}

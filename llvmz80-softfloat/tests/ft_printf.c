/* ft_printf.c -- end-to-end test for the nanoprintf-backed printf family
 * (src/npf_printf.c) under zcc +cpm -compiler=llvmz80.
 *
 * Proves that the drop-in printf/snprintf handle the full specifier set AND
 * IEEE-754 %f correctly on z80 — the whole point of Design B (stock z88dk
 * printf formats math48, not IEEE binary64).  Prerequisites now in place:
 *  - clang-z80 jump-table off-by-one fixed (nanoprintf %x parses),
 *  - va_start works (ravn/z88dk#31/#270).
 *
 * Output is diffed against tests/ft_printf.expected (byte-identical to glibc
 * for the %f cases; cross-checked with the ft_fmt golden).
 */
#include <stdio.h>

extern int __llvmz80_printf(const char *fmt, ...);
extern int __llvmz80_snprintf(char *s, unsigned n, const char *fmt, ...);

static char buf[64];

int main(void) {
    /* integer / string / char specifiers */
    __llvmz80_printf("d|%d\n", -1234);
    __llvmz80_printf("u|%u\n", 40000u);
    __llvmz80_printf("x|%x\n", 0xBEEF);
    __llvmz80_printf("X|%X\n", 0xBEEF);
    __llvmz80_printf("o|%o\n", 64);
    __llvmz80_printf("c|%c\n", 'Q');
    __llvmz80_printf("s|%s\n", "hello");

    /* IEEE-754 double */
    __llvmz80_printf("f0|%f\n", 0.0);
    __llvmz80_printf("f1|%f\n", 1.0);
    __llvmz80_printf("fpi|%f\n", 3.14159265358979);
    __llvmz80_printf("fneg|%f\n", -2.5);
    __llvmz80_printf("fp2|%.2f\n", 3.14159);
    __llvmz80_printf("fp0|%.0f\n", 2.75);
    __llvmz80_printf("fw|%8.3f\n", 1.25);

    /* snprintf: return value + buffer */
    int n = __llvmz80_snprintf(buf, sizeof buf, "%d/%f", 7, 0.5);
    __llvmz80_printf("snp|%d|%s\n", n, buf);

    return 0;
}

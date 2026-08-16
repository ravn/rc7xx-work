/*
 * fwstructscan.c — firmware pattern: read a struct as a byte array.
 *
 * Source: autoload-in-c/rom.c fdc_read_result().  A 7-byte struct is cast
 * to 'unsigned char *' and filled byte-by-byte inside a for loop, with an
 * early-exit when a status bit clears.
 *
 * Also tests the pattern from check_fdc_result(): multi-field struct compare
 * using bit masks on the filled values.
 *
 * Workload: 5000 fill+check cycles.
 */

#include <stdio.h>

typedef struct {
    unsigned char st0, st1, st2, c, h, r, n;
} fdc_result_t;

static unsigned char next_byte(unsigned char *counter)
{
    unsigned char t = *counter;   /* dcc: (*counter)++ not supported */
    *counter = (unsigned char)(t + 1);
    return t;
}

static void fdc_read_result(fdc_result_t *res, unsigned char status_base)
{
    unsigned char i;
    unsigned char *p = (unsigned char *)res;
    unsigned char ctr = status_base;
    for (i = 0; i < 7; i++) {
        p[i] = next_byte(&ctr);
        /* Early exit when FDC signals no more result bytes (bit 4 clear).
         * Only write the next byte if it is still within the 7-byte struct
         * (i < 6); writing p[7] on the final iteration is undefined behaviour
         * and produces different results across compilers. */
        if (!(ctr & 0x10)) {
            if (i < 6) p[i + 1] = ctr;
            return;
        }
    }
}

static int check_fdc_result(const fdc_result_t *res, unsigned char drive)
{
    if ((res->st0 & 0xC3) != drive) return 0;
    if (res->st1 != 0)              return 0;
    if (res->st2 & 0x40)            return 0;
    return 1;
}

int main(void)
{
    fdc_result_t res;
    int i;
    unsigned int ok = 0;
    for (i = 0; i < 5000; i++) {
        fdc_read_result(&res, (unsigned char)(i & 0xFF));
        if (check_fdc_result(&res, (unsigned char)(i & 0x03)))
            ok++;
    }
    printf("fwstructscan: ok=%u st0=%u\n", ok, (unsigned)res.st0);
    return 0;
}

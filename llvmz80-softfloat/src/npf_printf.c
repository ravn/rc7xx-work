/* npf_printf.c -- nanoprintf-backed printf family for zcc +cpm -compiler=llvmz80.
 *
 * WHY: z88dk's classic printf formats floats in its own math48 format, but
 * clang-z80 passes IEEE-754 binary64 `double`, so `printf("%f", x)` prints
 * garbage.  nanoprintf decodes IEEE-754 directly (byte-identical to glibc for
 * %f, validated by tests/ft_fmt), and — since the clang-z80 jump-table
 * off-by-one is fixed (ravn/llvm-z80) and va_start works (ravn/z88dk#31/#270) —
 * it now handles every conversion (%d/%s/%x/%c/%o/%u/%f/…) correctly on z80.
 *
 * This TU provides drop-in printf/fprintf/sprintf/snprintf that route through
 * nanoprintf.  Output goes through z88dk's own FILE* layer (fputc), so console
 * and file streams behave exactly as z88dk expects; only the FORMATTING is
 * nanoprintf's.  stdio.h routes the standard names here under __LLVMZ80.
 *
 * This is the single nanoprintf implementation TU for a printf-using program
 * (defines NANOPRINTF_IMPLEMENTATION); the softfloat f64 %f path pulls the same
 * npf_ftoa core.  Packaged into softfloat_cpm_z80.lib -> pulled only when a
 * program actually calls one of these.
 */
#define NANOPRINTF_IMPLEMENTATION
#include "npf_cpm.h"

#include <stdio.h>
#include <stdarg.h>
#include <stddef.h>

/* nanoprintf pputc callback.
 *
 * The console (stdout/stderr) must go through putchar(): z88dk's classic
 * FILE* stdout is not a per-char-writable stream here (fputc(c, stdout) blocks
 * under CP/M), whereas putchar() is the console primitive z88dk's own printf
 * uses.  A real file stream (fprintf to an fopen'd FILE*) takes fputc(c, f). */
static void npf_file_putc(int c, void *ctx) {
    FILE *f = (FILE *)ctx;
    if (f == stdout || f == stderr)
        putchar(c);
    else
        fputc(c, f);
}

int __llvmz80_vfprintf(FILE *f, const char *fmt, va_list ap) {
    return npf_vpprintf(npf_file_putc, (void *)f, fmt, ap);
}

int __llvmz80_printf(const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    int n = npf_vpprintf(npf_file_putc, (void *)stdout, fmt, ap);
    va_end(ap);
    return n;
}

int __llvmz80_fprintf(FILE *f, const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    int n = npf_vpprintf(npf_file_putc, (void *)f, fmt, ap);
    va_end(ap);
    return n;
}

int __llvmz80_snprintf(char *s, size_t n, const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    int r = npf_vsnprintf(s, n, fmt, ap);
    va_end(ap);
    return r;
}

/* sprintf: unbounded buffer.  nanoprintf has no unbounded npf_vsprintf; use a
 * huge cap (matches z88dk's own sprintf==snprintf(65535) convention). */
int __llvmz80_sprintf(char *s, const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    int r = npf_vsnprintf(s, (size_t)0xFFFF, fmt, ap);
    va_end(ap);
    return r;
}

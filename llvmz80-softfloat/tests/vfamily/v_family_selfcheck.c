/* v_family_selfcheck.c -- self-checking regression for the va_list stdio
 * family under zcc +cpm -compiler=llvmz80 (ravn/z88dk#31 follow-up).
 *
 * WHY it is self-checking and NOT in tests/bridge/ (the ez80clang diff oracle):
 * the diff oracle treats ez80-clang as reference truth, but ez80-clang's own
 * v* path is broken (vsnprintf -> "0-0", vsscanf -> x=0 y=0), so llvmz80's
 * correct output would falsely "diverge".  Here we assert absolute expected
 * values instead.
 *
 * WHAT it proves: include/stdio.h now declares vfprintf/vsnprintf/vfscanf/
 * vsscanf as __smallc under __LLVMZ80, so clang marshals all args on the stack
 * (natural order, first arg on top = what the classic __smallc workers read)
 * and reads the count from HL.  Before the fix these returned an empty buffer
 * and a garbage count (return read from DE).
 *
 * Expected stdout when GREEN:  "PASS"
 */
#include <stdio.h>
#include <stdarg.h>
#include <string.h>

static int wprint(char *b, const char *f, ...) {
    va_list a; va_start(a, f);
    int n = vsnprintf(b, 64, f, a);
    va_end(a);
    return n;
}

static int wscan(const char *s, const char *f, ...) {
    va_list a; va_start(a, f);
    int n = vsscanf(s, f, a);
    va_end(a);
    return n;
}

int main(void) {
    int ok = 1;
    char b[64];

    /* vsnprintf: mixed string / ints / char, plus the byte count in HL */
    int n = wprint(b, "[%s]%d,%d,%c", "hi", 100, -7, 'Z');
    if (strcmp(b, "[hi]100,-7,Z") != 0 || n != 12) ok = 0;

    /* vsscanf: two ints parsed into the caller's variables */
    int x = 0, y = 0;
    int m = wscan("11 22", "%d %d", &x, &y);
    if (x != 11 || y != 22 || m != 2) ok = 0;

    puts(ok ? "PASS" : "FAIL");
    return ok ? 0 : 1;
}

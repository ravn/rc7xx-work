/* Minimal repro: clang-z80 (zcc +cpm -compiler=llvmz80) va_arg returns garbage.
 *
 * Expected: sum(3,10,20,30) == 60.   Actual on Z80: 1.
 * Host (native clang): 60.
 *
 * z88dk's own printf works only because its libc is precompiled with z88dk's
 * native va_arg ABI; any clang-z80-compiled function that READS varargs via
 * va_arg is broken.  This blocks nanoprintf and any C-level printf("%f").
 *
 * Build:  zcc +cpm -compiler=llvmz80 -Cg-O2 -o vaarg.com bugs/vaarg_broken.c
 * Run:    python3 scratch/dcc-clang-bench/ticks_cpm.py vaarg.com
 */
#include <stdio.h>
#include <stdarg.h>
static int vsum(int n, ...) {
  va_list ap; va_start(ap, n);
  int s = 0;
  for (int i = 0; i < n; i++) s += va_arg(ap, int);
  va_end(ap);
  return s;
}
int main(void) {
  printf("sum=%d want=60\n", vsum(3, 10, 20, 30));
  return 0;
}

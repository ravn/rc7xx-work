/* ft_vararg.c -- regression test for the z88dk <stdarg.h> ABI fix.
 *
 * Before the fix, z88dk's classic <stdarg.h> located varargs via
 * (va_list)&last + sizeof(last); under clang-z80's parameter spilling that
 * points at a local slot (IX-2) instead of the incoming argument area (IX+6),
 * so every va_arg read garbage.  Misfiled as an llvm-z80 backend bug
 * (ravn/llvm-z80#270); actually a header bug, fixed by deferring to
 * __builtin_va_* under __LLVMZ80 (z88dk bb914a1).
 *
 * Build/run: zcc +cpm -compiler=llvmz80 -Cg-O2 -o ft_vararg ft_vararg.c
 *            python3 ../scratch/dcc-clang-bench/ticks_cpm.py ft_vararg
 * Expected console output: "60 -6 100"
 *
 * RED (stock stdarg.h): garbage / differs per -O level.
 * GREEN (fixed):        "60 -6 100" at -O0/-O1/-O2.
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

/* Mixed positive/negative to catch sign-extension / slot-stride errors. */
static int vmix(int n, ...) {
  va_list ap; va_start(ap, n);
  int s = 0;
  for (int i = 0; i < n; i++) s += va_arg(ap, int);
  va_end(ap);
  return s;
}

static void put_int(int v) {
  if (v < 0) { putchar('-'); v = -v; }
  char b[6]; int i = 0;
  if (!v) b[i++] = '0';
  while (v) { b[i++] = (char)('0' + v % 10); v /= 10; }
  while (i) putchar(b[--i]);
}

int main(void) {
  put_int(vsum(3, 10, 20, 30));      /* 60  */
  putchar(' ');
  put_int(vmix(4, 10, -20, 30, -26));/* -6  */
  putchar(' ');
  put_int(vsum(4, 25, 25, 25, 25));  /* 100 */
  putchar('\n');
  return 0;
}

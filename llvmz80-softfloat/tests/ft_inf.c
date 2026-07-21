/* ft_inf.c -- INFINITY / HUGE_VAL must format as "inf" under llvmz80 (IEEE-754).
 * Regression test for the math_genmath.h override (ravn/z88dk#28 follow-up):
 * genmath hardcodes INFINITY/HUGE_VAL as finite 9.99e37, so nanoprintf renders
 * a huge finite number instead of "inf". With the __builtin_inf() override they
 * become real IEEE infinities and nanoprintf prints "inf". */
#include <stdio.h>
#include <math.h>
#include "npf_cpm.h"
static char buf[64];
static int fail;
static void chk(const char *tag, double v, const char *want) {
  npf_snprintf(buf, sizeof buf, "%f", v);
  int ok = 0; { const char *a=buf,*b=want; while(*a&&*a==*b){a++;b++;} ok=(*a==*b); }
  printf("%s got=[%s] want=[%s] %s\n", tag, buf, want, ok?"PASS":"FAIL");
  if (!ok) fail = 1;
}
int main(void) {
  chk("inf ", (double)INFINITY, "inf");
  chk("huge", (double)HUGE_VAL, "inf");
  printf("%s\n", fail?"SOME FAILED":"ALL PASS");
  return fail;
}

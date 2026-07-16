/* Regression test for the nanoprintf <float.h> ABI-mismatch fix (src/npf_cpm.h).
 *
 * NOTE: earlier this file was a "repro" for a supposed clang-z80 backend
 * miscompile filed as ravn/llvm-z80#271. THAT DIAGNOSIS WAS WRONG and #271 is
 * invalid -- there is no codegen bug. Full root-cause writeup with the lli
 * differential oracle is in bugs/ftoa_rev_hiword_dropped.md. Summary:
 *
 * Symptom (before the fix): nanoprintf's npf_ftoa_rev() converts every finite
 * double to the wrong magnitude on Z80 (host: correct):
 *     1.0                 -> "0.000000"        (want "1.000000")
 *     0.3333333333333333  -> "715827882.666016"(want "0.333333")
 *     10.0                -> "0.000000"        (want "10.000000")
 * The 715827882 == (1/3)*2^31 fingerprint shows the base-2 exponent was decoded
 * with the wrong scale.
 *
 * Root cause (verified, red-green + lli differential):
 *   nanoprintf derives its IEEE decode constants from <float.h>: shift =
 *   DBL_MANT_DIG-1, mask = DBL_MAX_EXP*2-1, bias = DBL_MAX_EXP-1. z88dk's
 *   <float.h> (include/math/math_genmath.h) describes z88dk's 48-bit SOFTWARE
 *   float: DBL_MANT_DIG=39, DBL_MAX_EXP=37 -> shift 38 / mask 73 / bias 36.
 *   But clang-z80's `double` is IEEE-754 binary64 (__DBL_MANT_DIG__=53,
 *   __DBL_MAX_EXP__=1024) -> needs shift 52 / mask 2047 / bias 1023. The wrong
 *   constants are already in the LLVM IR (`lshr i64 %x, 38`); clang, llc AND
 *   lli all faithfully execute them -> NOT a backend bug.
 *
 * Fix: src/npf_cpm.h #undef/#defines DBL_MANT_DIG / DBL_MAX_EXP / DBL_MIN_EXP to
 * the __DBL_*__ builtins before including nanoprintf.h, so the decode matches
 * the real ABI. With that fix in place this test PASSes on Z80 (and host).
 *
 * Build (needs the vendored nanoprintf.h @ 74fea30):
 *   zcc +cpm -compiler=llvmz80 -Cg-O2 -Ivendor/nanoprintf -Isrc \
 *       -o ftoa.com bugs/ftoa_rev_hiword_dropped.c \
 *       <intrt.o> <fcmp64.o> <rt_mem.o>
 * Run:
 *   python3 scratch/dcc-clang-bench/ticks_cpm.py ftoa.com
 */
#define NANOPRINTF_IMPLEMENTATION
#include "npf_cpm.h"
#include <stdio.h>
#include <string.h>

static int check(const char *tag, double v, const char *want) {
  char buf[64];
  npf_format_spec_t fs;
  npf_parse_format_spec("%f", &fs);
  fs.prec = 6;
  int n = npf_ftoa_rev(buf, &fs, v);      /* reversed magnitude digits */
  if (n < 0) n = -n;
  char got[64];
  int j = 0;
  for (int k = n - 1; k >= 0; --k) got[j++] = buf[k];
  got[j] = '\0';
  int ok = (strcmp(got, want) == 0);
  printf("%s got=[%s] want=[%s] %s\n", tag, got, want, ok ? "PASS" : "FAIL");
  return ok;
}

int main(void) {
  int ok = 1;
  ok &= check("one  ", 1.0, "1.000000");
  ok &= check("third", 0.3333333333333333, "0.333333");
  ok &= check("ten  ", 10.0, "10.000000");
  printf(ok ? "ALL PASS\n" : "SOME FAILED\n");
  return ok ? 0 : 1;
}

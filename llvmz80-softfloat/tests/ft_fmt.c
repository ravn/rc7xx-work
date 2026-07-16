/* ft_fmt.c -- Phase 4 thorough runtime test for the IEEE double formatter.
 *
 * Formats a broad set of doubles through nanoprintf's npf_snprintf and prints
 * "tag|string" lines.  Scope is %f (fixed decimal) -- see the LIMITATION note
 * below on %e/%g.
 *
 * Oracle model (see tests/fmt_run.sh):
 *   1. GOLDEN: output is diffed against the checked-in tests/ft_fmt.expected.
 *      The SAME formatter logic runs on host and on Z80, so both must match the
 *      golden byte-for-byte; a Z80-only divergence localizes a backend / ABI /
 *      soft-float defect in the formatter path.
 *   2. CORRECTNESS: the golden itself was cross-checked against glibc printf for
 *      every non-half-rounding %f case (they agree).  The only divergences are
 *      nanoprintf's rounding policy (round-half-away, not round-half-even).
 *
 * LIMITATION: nanoprintf (v0.6.0, latest upstream) does NOT implement scientific
 * (%e) or shortest (%g) -- a PERMANENT, deliberate upstream design exception
 * (per nanoprintf's README), not a version gap.  npf_ftoa_rev always renders
 * fixed decimal, so %e/%g degrade to %f-style output.  We therefore do not
 * exercise %e/%g here (baking their non-standard strings in would assert wrong
 * behavior as correct).  If a driver needs %e/%g (e.g. Whetstone's %12.4e),
 * that is a follow-up (add an IEEE double->string scientific renderer;
 * upgrading nanoprintf will not help).
 *
 * Built for host (native clang + stdio) and for Z80 (zcc +cpm -compiler=llvmz80).
 */
#include <stdio.h>
#include "npf_cpm.h"

static char buf[128];

#define SHOW(tag, fmt, val)                          \
  do {                                               \
    npf_snprintf_f(buf, sizeof buf, (fmt), (val));   \
    printf("%s|%s\n", (tag), buf);                   \
  } while (0)

/* Literal doubles: this is a pure CONVERSION test (double bits -> string).
 * nanoprintf reads the raw IEEE bits directly (no soft-float arithmetic), so the
 * f64 arithmetic closure is intentionally NOT pulled in -- keeping the image well
 * inside the CP/M TPA.  Arithmetic correctness is covered separately by ft_dbl
 * (Phase 3).  The literals below are the nearest doubles to 1/3, 7/3, 10/3. */
int main(void) {
  double third = 0.3333333333333333;   /* nearest double to 1/3  */
  double seven_thirds = 2.3333333333333335; /* nearest double to 7/3 */
  double q = 3.3333333333333335;       /* nearest double to 10/3 */

  /* ---- sign / zero ---- */
  SHOW("f_zero",      "%f", 0.0);
  SHOW("f_negzero",   "%f", -0.0);
  SHOW("f_one",       "%f", 1.0);
  SHOW("f_negone",    "%f", -1.0);

  /* ---- exact binary fractions (no rounding) ---- */
  SHOW("f_half",      "%f", 0.5);
  SHOW("f_quarter",   "%f", 0.25);
  SHOW("f_eighth",    "%f", 0.125);
  SHOW("f_sixteenth", "%f", 0.0625);
  SHOW("f_1p5",       "%f", 1.5);
  SHOW("f_neg4",      "%f", -4.0);
  SHOW("f_3p75",      "%f", 3.75);

  /* ---- non-terminating decimals ---- */
  SHOW("f_pi",        "%f", 3.14159265358979);
  SHOW("f_e",         "%f", 2.71828182845905);
  SHOW("f_third",     "%f", third);
  SHOW("f_7thirds",   "%f", seven_thirds);
  SHOW("f_q",         "%f", q);
  SHOW("f_tenth",     "%f", 0.1);
  SHOW("f_fifth",     "%f", 0.2);
  SHOW("f_3tenths",   "%f", 0.3);

  /* ---- magnitudes ---- */
  SHOW("f_ten",       "%f", 10.0);
  SHOW("f_hundred",   "%f", 100.0);
  SHOW("f_thou",      "%f", 1000.0);
  SHOW("f_10k",       "%f", 10000.0);
  SHOW("f_100k",      "%f", 100000.0);
  SHOW("f_million",   "%f", 1000000.0);
  SHOW("f_10m",       "%f", 10000000.0);
  SHOW("f_123456p789","%f", 123456.789);
  SHOW("f_255p255",   "%f", 255.255);
  SHOW("f_65535",     "%f", 65535.0);   /* 16-bit boundary */
  SHOW("f_65536",     "%f", 65536.0);
  SHOW("f_tiny",      "%f", 0.001953125); /* 1/512, exact */
  SHOW("f_small",     "%f", 0.000123);

  /* ---- precision variants ---- */
  SHOW("f_p0_pi",     "%.0f", 3.14159265358979);
  SHOW("f_p1_pi",     "%.1f", 3.14159265358979);
  SHOW("f_p2_pi",     "%.2f", 3.14159265358979);
  SHOW("f_p3_pi",     "%.3f", 3.14159265358979);
  SHOW("f_p5_pi",     "%.5f", 3.14159265358979);
  SHOW("f_p8_pi",     "%.8f", 3.14159265358979);
  SHOW("f_p2_q",      "%.2f", q);
  SHOW("f_p4_third",  "%.4f", third);
  SHOW("f_p0_hundred","%.0f", 100.0);
  SHOW("f_p2_zero",   "%.2f", 0.0);

  /* ---- width and flags ---- */
  SHOW("f_w10p2",     "%10.2f", 3.14159);
  SHOW("f_wm10p2",    "%-10.2f", 3.14159);
  SHOW("f_wz10p2",    "%010.2f", 3.14159);
  SHOW("f_wz10p2n",   "%010.2f", -3.14159);
  SHOW("f_plus",      "%+.2f", 3.14159);
  SHOW("f_plusneg",   "%+.2f", -3.14159);
  SHOW("f_space",     "% .2f", 3.14159);
  SHOW("f_w6p2big",   "%6.2f", 123456.7);  /* value wider than field */

  return 0;
}

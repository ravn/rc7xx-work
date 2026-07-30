/* fcmp64.c -- integer-only __eqdf2 / __nedf2 for the Phase 4 formatter.
 *
 * The compiled nanoprintf (npf_vpprintf) and our npf_snprintf_f contain a couple
 * of `double == / != 0.0` comparisons, so clang emits __eqdf2 / __nedf2. Pulling
 * Berkeley SoftFloat just for an equality test would drag in the whole f64
 * arithmetic closure (+64-bit divide) and overflow the CP/M TPA. IEEE equality
 * needs no arithmetic -- it is a pure bit test -- so we implement it directly on
 * the two 32-bit halves of the double (avoids 64-bit integer libcalls too).
 *
 * compiler-rt semantics: __eqdf2/__nedf2 return 0 iff a == b, nonzero otherwise;
 * a NaN operand makes them unequal (unordered).
 */
#include <stdint.h>
#include <string.h>

static void halves(double d, uint32_t *hi, uint32_t *lo) {
  uint32_t w[2];
  memcpy(w, &d, 8);          /* little-endian: w[0]=low word, w[1]=high word */
  *lo = w[0];
  *hi = w[1];
}

static int is_nan(uint32_t hi, uint32_t lo) {
  /* exponent all ones (bits 30..20 of hi) and mantissa (hi[19:0]|lo) nonzero */
  return (((hi >> 20) & 0x7ffu) == 0x7ffu) && (((hi & 0xfffffu) | lo) != 0);
}

int __eqdf2(double a, double b) {
  uint32_t ah, al, bh, bl;
  halves(a, &ah, &al);
  halves(b, &bh, &bl);
  if (is_nan(ah, al) || is_nan(bh, bl)) return 1;   /* unordered -> not equal */
  /* +0 and -0 compare equal: both magnitudes zero. */
  if (((ah & 0x7fffffffu) | al) == 0 && ((bh & 0x7fffffffu) | bl) == 0) return 0;
  return (ah == bh && al == bl) ? 0 : 1;
}

int __nedf2(double a, double b) { return __eqdf2(a, b); }

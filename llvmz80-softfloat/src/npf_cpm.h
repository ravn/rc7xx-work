/* npf_cpm.h -- shared nanoprintf configuration for the zcc+cpm+llvmz80 IEEE
 * double formatter (Phase 4).  Included by BOTH the implementation TU
 * (src/fmt64.c, which defines NANOPRINTF_IMPLEMENTATION first) and every caller
 * (tests), so the NANOPRINTF_USE_* switches MUST stay identical across TUs.
 *
 * We use nanoprintf purely as an IEEE-754 double -> string converter, sidestep-
 * ping z88dk's classic printf whose float path reads math48, not IEEE.  Callers
 * format into a buffer with npf_snprintf() and emit the buffer with puts().
 */
#ifndef NPF_CPM_H
#define NPF_CPM_H

#define NANOPRINTF_USE_FIELD_WIDTH_FORMAT_SPECIFIERS 1
#define NANOPRINTF_USE_PRECISION_FORMAT_SPECIFIERS   1
#define NANOPRINTF_USE_FLOAT_FORMAT_SPECIFIERS       1
#define NANOPRINTF_USE_LARGE_FORMAT_SPECIFIERS       0
#define NANOPRINTF_USE_SMALL_FORMAT_SPECIFIERS       0
#define NANOPRINTF_USE_BINARY_FORMAT_SPECIFIERS      0
#define NANOPRINTF_USE_WRITEBACK_FORMAT_SPECIFIERS   0
#define NANOPRINTF_USE_ALT_FORM_FLAG                 1

/* The ftoa mantissa accumulator.  Defaults to `unsigned int` (16-bit on Z80),
 * far too narrow for a 52-bit double mantissa -- nanoprintf still converges via
 * dynamic scaling but loses low-order precision.  Use a 32-bit accumulator so
 * ~9-10 significant decimals are exact, which covers %f/%g/%e at the default
 * precision (6).  Wider than the 16-bit default costs 32-bit integer ops, which
 * the intrt closure supplies. */
#define NANOPRINTF_CONVERSION_FLOAT_TYPE unsigned long

/* ---- IEEE-754 double limits for clang-z80 -------------------------------
 * nanoprintf decodes a double's raw bit layout using DBL_MANT_DIG /
 * DBL_MAX_EXP from <float.h> (to pick the bin integer width, the exponent
 * shift = DBL_MANT_DIG-1, the exponent mask = DBL_MAX_EXP*2-1, and the bias
 * = DBL_MAX_EXP-1).  On this target those two sources disagree:
 *
 *   - clang-z80's `double` is IEEE-754 binary64  (__DBL_MANT_DIG__ = 53,
 *     __DBL_MAX_EXP__ = 1024, sizeof(double) = 8), and that is what the raw
 *     bytes handed to nanoprintf actually are.
 *   - z88dk's <float.h> (via math/math_genmath.h) instead describes z88dk's
 *     native 48-bit *software* float:  DBL_MANT_DIG = 39, DBL_MAX_EXP = 37.
 *
 * Trusting <float.h> makes nanoprintf shift by 38 (not 52) and mask with 73
 * (not 2047), so every finite double decodes to garbage -- e.g. 1.0/3.0
 * ("0x3fd5555555555555") formats as "715827882.666016" = (1/3)*2^31 instead
 * of "0.333333".  (This is NOT a compiler codegen bug: clang/llc/lli all
 * faithfully execute the wrongly-parameterised IR.  See ravn/llvm-z80#271,
 * closed as invalid.)
 *
 * Override the <float.h> double macros with the compiler's own builtins,
 * which always match the real ABI.  <float.h> is header-guarded, so pulling
 * it in here (before nanoprintf.h re-includes it) makes these #defines the
 * ones that win. */
#if defined(__DBL_MANT_DIG__)
  #include <float.h>
  #undef  DBL_MANT_DIG
  #define DBL_MANT_DIG __DBL_MANT_DIG__
  #undef  DBL_MAX_EXP
  #define DBL_MAX_EXP  __DBL_MAX_EXP__
  #undef  DBL_MIN_EXP
  #define DBL_MIN_EXP  __DBL_MIN_EXP__
#endif

#include "nanoprintf.h"

#include <stddef.h>
/* npf_snprintf_f() has been removed (2026-07-21): va_start works correctly
 * since z88dk bb914a18 deferred to __builtin_va_start (ravn/llvm-z80#270 fixed).
 * Use the normal variadic npf_snprintf() directly. */

#endif /* NPF_CPM_H */

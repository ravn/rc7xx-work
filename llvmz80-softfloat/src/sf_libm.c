/* sf_libm.c -- double-precision libm bit-primitives for zcc+cpm+llvmz80.
 *
 * fabs / copysign only -- pure integer sign-bit manipulation, no soft-float
 * call.  sqrt lives in the sibling module src/sf_sqrt.c (it forwards to the
 * SoftFloat f64_sqrt core); keeping it separate means a program that only
 * needs fabs (e.g. musl atan(), which calls fabs but not sqrt) does NOT drag
 * the f64_sqrt core in when linked against mathf64.lib.
 */
#include <stdint.h>

/* ---- bit primitives (no soft-float) ------------------------------------ */
double fabs(double x)
{
    union { double d; uint64_t u; } v; v.d = x;
    v.u &= (uint64_t)0x7fffffffffffffffULL;
    return v.d;
}

double copysign(double x, double y)
{
    union { double d; uint64_t u; } vx, vy; vx.d = x; vy.d = y;
    vx.u = (vx.u & (uint64_t)0x7fffffffffffffffULL) |
           (vy.u & (uint64_t)0x8000000000000000ULL);
    return vx.d;
}


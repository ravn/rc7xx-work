/* sf_sqrt.c -- double sqrt() via the SoftFloat f64_sqrt core (correctly
 * rounded), split out of sf_libm.c so that fabs/copysign consumers (e.g. musl
 * atan) do not drag the f64_sqrt module in when linking against mathf64.lib.
 */
#include "softfloat.h"

static float64_t d2f64(double x){ union { double d; float64_t f; } u; u.d = x; return u.f; }
static double    f642d(float64_t x){ union { double d; float64_t f; } u; u.f = x; return u.d; }

double sqrt(double x){ return f642d(f64_sqrt(d2f64(x))); }

/* sf64.c -- compiler-rt double-precision shims backed by Berkeley SoftFloat.
 *
 * clang emits standard libcalls for `double` arithmetic (__adddf3, __muldf3,
 * __divdf3, conversions, comparisons); z88dk provides none of them. Here we
 * bit-cast the C `double`/`float`/`int` operands to SoftFloat's float64_t /
 * float32_t and forward to the vendored f64_* cores (vendor/berkeley-softfloat-3).
 * SoftFloat's f64 mul/div rely on 32x32->64 and 64-bit divide, supplied by the
 * sibling ../llvmz80-intrt (__muldi3/__udivdi3/__mulsi3).
 *
 * ABI: the ONLY convention-critical boundary is these compiler-rt entry points
 * (declared with the same C types clang uses). float64_t is `struct{uint64_t v;}`;
 * the double<->float64_t hop is a pure bit reinterpret via a union.
 */
#include <stdint.h>
#include <stdbool.h>
#include "softfloat.h"

/* ---- bit reinterpret helpers (no value conversion) --------------------- */
static float64_t d2f64(double x){ union { double d; float64_t f; } u; u.d = x; return u.f; }
static double    f642d(float64_t x){ union { double d; float64_t f; } u; u.f = x; return u.d; }

static int isnan64(double x)
{
    union { double d; uint64_t u; } u; u.d = x;
    return (((u.u >> 52) & 0x7ffu) == 0x7ffu) && (u.u & 0x000fffffffffffffULL);
}

/* ---- arithmetic -------------------------------------------------------- */
double __adddf3(double a, double b){ return f642d(f64_add(d2f64(a), d2f64(b))); }
double __subdf3(double a, double b){ return f642d(f64_sub(d2f64(a), d2f64(b))); }
double __muldf3(double a, double b){ return f642d(f64_mul(d2f64(a), d2f64(b))); }
double __divdf3(double a, double b){ return f642d(f64_div(d2f64(a), d2f64(b))); }

/* ---- conversions ------------------------------------------------------- */
/* NOTE: the float32<->float64 shims __extendsfdf2/__truncdfsf2 live in the
 * sibling module src/sf64_f32.c so a pure-double program (e.g. the libm
 * transcendental tests) linked against the .lib archive does NOT drag in the
 * SoftFloat f32 core (f32_to_f64/f64_to_f32 + their round/normalize helpers,
 * ~3 KB).  z80asm strips unreferenced .lib modules only -- keeping the f32 hop
 * in its own module is what makes that stripping possible.  See
 * bugs/rodata_cst_section_dropped.md sibling note and README "libm test". */
long   __fixdfsi(double a){ return (long)f64_to_i32_r_minMag(d2f64(a), false); } /* trunc */
double __floatsidf(long a){ return f642d(i32_to_f64((int_fast32_t)a)); }

/* ---- comparisons (GCC soft-float semantics) ---------------------------- */
/* Ordered result -1/0/1; unordered returns `unord` (chosen per entry so the
 * caller's sign test yields "false" on NaN, matching compiler-rt). */
static int cmp64(double a, double b, int unord)
{
    if (isnan64(a) || isnan64(b)) return unord;
    float64_t x = d2f64(a), y = d2f64(b);
    if (f64_lt(x, y)) return -1;
    if (f64_eq(x, y)) return 0;
    return 1;
}
int __ltdf2(double a, double b){ return cmp64(a, b,  1); } /* <0 iff a<b   */
int __ledf2(double a, double b){ return cmp64(a, b,  1); } /* <=0 iff a<=b */
int __gtdf2(double a, double b){ return cmp64(a, b, -1); } /* >0 iff a>b   */
int __gedf2(double a, double b){ return cmp64(a, b, -1); } /* >=0 iff a>=b */
int __eqdf2(double a, double b){ return cmp64(a, b,  1); } /* 0 iff equal  */
int __nedf2(double a, double b){ return cmp64(a, b,  1); } /* !=0 iff ne   */
int __cmpdf2(double a, double b){ return cmp64(a, b, 1); }
int __unorddf2(double a, double b){ return isnan64(a) || isnan64(b); }

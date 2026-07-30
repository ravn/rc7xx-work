/* sf64_f32.c -- the float32<->float64 conversion shims, split out of sf64.c.
 *
 * Kept in a SEPARATE translation unit on purpose: z88dk's z80asm linker strips
 * unreferenced modules only from a .lib archive (never from a directly-linked
 * .o).  A pure-`double` program (the libm transcendental tests: sqrt/atan/exp)
 * never calls __extendsfdf2/__truncdfsf2, so when it links against mathf64.lib
 * this whole module -- and, transitively, the SoftFloat f32 core
 * (f32_to_f64/f64_to_f32 and their round/normalize helpers, ~3 KB) -- is left
 * out.  That ~3 KB is exactly what lets exp() fit under the 64 KB CP/M TPA
 * (65714 B all-.o -> 60494 B via the lib).  If these two shims stayed in
 * sf64.c, the module would always be pulled (it also defines __adddf3 etc.),
 * dragging the f32 core in even for double-only code.
 */
#include <stdint.h>
#include "softfloat.h"

static float64_t d2f64(double x){ union { double d; float64_t f; } u; u.d = x; return u.f; }
static double    f642d(float64_t x){ union { double d; float64_t f; } u; u.f = x; return u.d; }
static float32_t s2f32(float x){ union { float s; float32_t f; } u; u.s = x; return u.f; }
static float     f322s(float32_t x){ union { float s; float32_t f; } u; u.f = x; return u.s; }

double __extendsfdf2(float a){ return f642d(f32_to_f64(s2f32(a))); }
float  __truncdfsf2(double a){ return f322s(f64_to_f32(d2f64(a))); }

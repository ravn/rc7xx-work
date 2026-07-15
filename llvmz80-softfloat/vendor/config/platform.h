/*----------------------------------------------------------------------------
| platform.h for the zcc +cpm -compiler=llvmz80 (Z80) target.
| Z80 is little-endian and single-threaded. INLINE is `static inline` so the
| header-defined primitives are emitted locally even at -O0 (plain C99 `inline`
| would leave them undefined at link when not actually inlined).
*----------------------------------------------------------------------------*/
#define LITTLEENDIAN 1
#define INLINE static inline
#define THREAD_LOCAL

/* z88dk's <stdint.h> does not define the C integer-constant macros SoftFloat
 * relies on (UINT64_C etc.). Provide them (long long = 64-bit on this target). */
#ifndef UINT64_C
#define UINT64_C(x)  x##ULL
#endif
#ifndef INT64_C
#define INT64_C(x)   x##LL
#endif
#ifndef UINT32_C
#define UINT32_C(x)  x##U
#endif
#ifndef INT32_C
#define INT32_C(x)   x
#endif

/* Use the GCC/clang builtin count-leading-zeros so we do not need the
 * s_countLeadingZeros8 lookup table (its byte array trips a clang-z80 -> z80asm
 * `.ascii` incompatibility). __builtin_clz/clzll lower inline on this target. */
#include "opts-GCC.h"

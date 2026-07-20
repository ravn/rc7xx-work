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

/* Count-leading-zeros primitives (SoftFloat's platform hook).  We provide them
 * here, in project-owned config, rather than editing the vendored
 * berkeley-softfloat submodule (which stays pristine at its pinned upstream
 * commit, so a fresh `git submodule update` on any machine keeps this fix).
 *
 * Using the GCC/clang builtins avoids the portable s_countLeadingZeros8 lookup
 * table (its 256-byte array trips a clang-z80 -> z80asm `.ascii` incompat).
 *
 * ravn/llvm-z80#273: the builtin MUST match the clz OPERAND width.  Upstream
 * opts-GCC.h assumed a 32-bit int -- bare __builtin_clz for the 32-bit clz and
 * __builtin_clz-16 for the 16-bit clz.  clang-z80/z88dk has a 16-bit int, so
 * __builtin_clz counts only 16 bits; under the upstream code countLeadingZeros32
 * was off by 16 -> i32_to_f64/__floatsidf produced a corrupt double, e.g.
 * (double)5 -> 131074.5.  Match the builtin to the width instead:
 *   16-bit clz -> __builtin_clz   (unsigned int   = 16 bits here)
 *   32-bit clz -> __builtin_clzl  (unsigned long  = 32 bits here)
 *   64-bit clz -> __builtin_clzll (unsigned llong = 64 bits here)
 * (We do NOT #include "opts-GCC.h": its only other block, SOFTFLOAT_INTRINSIC_
 * INT128, is inactive on Z80 -- no __int128 -- so clz is all it would provide.)
 */
#include <stdint.h>
_Static_assert(
    __SIZEOF_INT__ == 2 && __SIZEOF_LONG__ == 4 && __SIZEOF_LONG_LONG__ == 8,
    "softfloat clz builtins assume int=16/long=32/longlong=64 bits; "
    "revisit the builtin choice/offsets if these widths change" );

INLINE uint_fast8_t softfloat_countLeadingZeros16( uint16_t a )
    { return a ? __builtin_clz( a ) : 16; }
#define softfloat_countLeadingZeros16 softfloat_countLeadingZeros16

INLINE uint_fast8_t softfloat_countLeadingZeros32( uint32_t a )
    { return a ? __builtin_clzl( a ) : 32; }
#define softfloat_countLeadingZeros32 softfloat_countLeadingZeros32

INLINE uint_fast8_t softfloat_countLeadingZeros64( uint64_t a )
    { return a ? __builtin_clzll( a ) : 64; }
#define softfloat_countLeadingZeros64 softfloat_countLeadingZeros64

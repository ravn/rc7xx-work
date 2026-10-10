/* Minimal string.h for freestanding Z80 build.
 * Implementations in runtime.s (sdcccall(1) convention). */
#ifndef _STRING_H
#define _STRING_H

#include <stddef.h>

void *memcpy(void *dest, const void *src, size_t n);
void *memset(void *s, int c, size_t n);
void *memmove(void *dest, const void *src, size_t n);
void *memchr(const void *s, int c, size_t n);
void lddr_copy(void *src_end, void *dst_end, size_t n);

/* Fast block copy: LDIR remainder + 16xLDI unrolled loop.
 * 20% faster than LDIR for copies >= 16 bytes (16T/byte vs 21T/byte).
 * Does NOT handle overlapping regions — use memmove() for those.
 *
 * blocks16  = (n / 16) * 16  — byte count for 16xLDI loop (BC value)
 * remainder = n % 16         — byte count for initial LDIR (0 = skip)
 *
 * Both arguments should be compile-time constants; the function is
 * always inlined so the compiler folds the constants and emits bare
 * LD BC,imm + LDIR / 16xLDI + JP PE with no call overhead. */
static inline void
memcpy_z80(void *dest, const void *src, unsigned short blocks16, unsigned char remainder)
{
#ifdef __z80__
    if (remainder) {
        unsigned short rem = remainder;
        __asm volatile("ldir"
            : "+{de}"(dest), "+{hl}"(src), "+{bc}"(rem) :: "memory");
    }
    if (blocks16) {
        unsigned short bc = blocks16;
        __asm volatile(
            "1: ldi\n ldi\n ldi\n ldi\n ldi\n ldi\n ldi\n ldi\n"
            "   ldi\n ldi\n ldi\n ldi\n ldi\n ldi\n ldi\n ldi\n"
            "   jp pe, 1b"
            : "+{de}"(dest), "+{hl}"(src), "+{bc}"(bc) :: "memory");
    }
#else
    memcpy(dest, src, blocks16 + remainder);
#endif
}

#endif

/*
 * fw_bitops.c — firmware pattern: bit-position arithmetic + partial-byte masking.
 *
 * Source: rcbios-in-c/bios.c bg_clear_from().  Converts a bit-position into
 * a byte offset + bit-within-byte, clears the trailing bits of a partial byte,
 * then clears whole bytes with an explicit fill loop, then clears leading bits
 * of the last byte.
 *
 * The explicit fill loop is intentional: clang's LoopIdiomRecognize recognises
 * it as a memset-equivalent and lowers it to the Z80 LDIR instruction, matching
 * the firmware idiom exactly (see llvm-z80 lit test loop-idiom-fill-ldir.ll).
 *
 * Workload: 2000 calls cycling through different bit positions and counts.
 */

#include <stdio.h>

#define BUF_BITS  512
#define BUF_BYTES (BUF_BITS / 8)

static unsigned char bgbuf[BUF_BYTES];
static unsigned int total_cleared = 0;

static void bitclear(unsigned int bitpos, unsigned int count)
{
    unsigned char byteoff, bitno, whole, tail;

    if (!count || bitpos >= BUF_BITS) return;
    if (bitpos + count > BUF_BITS)
        count = BUF_BITS - bitpos;

    byteoff = (unsigned char)(bitpos >> 3);
    bitno   = (unsigned char)(bitpos & 7);

    /* Clear trailing bits of first partial byte */
    if (bitno) {
        unsigned char mask = (unsigned char)(0xFF >> bitno);
        bgbuf[byteoff] &= (unsigned char)~mask;
        byteoff++;
        count = (count > (unsigned int)(8 - bitno))
                ? count - (8 - bitno) : 0;
    }

    /* Clear whole bytes */
    whole = (unsigned char)(count >> 3);
    if (whole) {
        unsigned char j;
        for (j = 0; j < whole; j++)
            bgbuf[byteoff + j] = 0;
        byteoff += whole;
        total_cleared += whole;
    }

    /* Clear leading bits of last partial byte */
    tail = (unsigned char)(count & 7);
    if (tail) {
        unsigned char mask = (unsigned char)(0xFF << (8 - tail));
        bgbuf[byteoff] &= (unsigned char)~mask;
    }
}

/* Set a range of bits so we have something to clear */
static void bitset_range(unsigned int bitpos, unsigned int count)
{
    unsigned int i;
    for (i = 0; i < count && (bitpos + i) < BUF_BITS; i++) {
        unsigned int p = bitpos + i;
        bgbuf[p >> 3] |= (unsigned char)(0x80 >> (p & 7));
    }
}

int main(void)
{
    int i;
    unsigned int checksum = 0;

    {
        unsigned char j;
        for (j = 0; j < BUF_BYTES; j++)
            bgbuf[j] = 0xFF;
    }

    for (i = 0; i < 2000; i++) {
        unsigned int pos   = (unsigned int)((i * 13) % BUF_BITS);
        unsigned int count = (unsigned int)(1 + (i * 7) % 63);
        bitclear(pos, count);
        if ((i & 15) == 0) {
            bitset_range(pos, count);
        }
        checksum += bgbuf[pos >> 3];
    }
    printf("fw_bitops: cleared=%u chk=%u\n", total_cleared, checksum);
    return 0;
}

/*
 * fw_crc.c — firmware pattern: CRC-16/CCITT inner loop over a byte buffer.
 *
 * Source: common CP/M disk code pattern; also matches the checksum loops in
 * rcbios specc() and the DMA-buffer verification in rwoper.  Tests shift +
 * XOR inner loop over a 512-byte buffer — exercises the byte-array loop
 * quality (ld hl,base; add hl,index reload vs pointer-based).
 *
 * Workload: CRC-16 over 512-byte buffer, 2000 times.
 */

#include <stdio.h>

#define BUF_SIZE 512

static unsigned char buf[BUF_SIZE];

/* CRC-16/CCITT (poly 0x1021, init 0xFFFF) */
static unsigned int crc16(const unsigned char *data, unsigned int len)
{
    unsigned int crc = 0xFFFF;
    unsigned int i;
    for (i = 0; i < len; i++) {
        unsigned char b = data[i];
        unsigned char j;
        crc ^= (unsigned int)((unsigned int)b << 8);
        for (j = 0; j < 8; j++) {
            if (crc & 0x8000)
                crc = (unsigned int)((crc << 1) ^ 0x1021);
            else
                crc = (unsigned int)(crc << 1);
        }
    }
    return crc;
}

/* Simple xor-fold checksum matching bios.c specc() DMA-area verify */
static unsigned int xor_checksum(const unsigned char *data, unsigned int len)
{
    unsigned int acc = 0;
    unsigned int i;
    for (i = 0; i < len; i++)
        acc ^= (unsigned int)data[i];
    return acc;
}

int main(void)
{
    int iter;
    unsigned int crc_sum = 0;
    unsigned int xor_sum = 0;
    unsigned int i;

    /* Fill buffer with a known pattern */
    for (i = 0; i < BUF_SIZE; i++)
        buf[i] = (unsigned char)((i * 7 + 13) & 0xFF);

    for (iter = 0; iter < 200; iter++) {
        buf[iter & (BUF_SIZE - 1)] = (unsigned char)iter;
        crc_sum += crc16(buf, BUF_SIZE);
        xor_sum += xor_checksum(buf, BUF_SIZE);
    }

    printf("fw_crc: crc=%u xor=%u\n", crc_sum, xor_sum);
    return 0;
}

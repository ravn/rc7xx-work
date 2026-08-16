/*
 * fw_xlt.c — firmware pattern: CP/M sector translation table lookup.
 *
 * Source: rcbios-in-c/bios.c sector_translate(), xlt_maxi_128[].
 * A logical sector is mapped to a physical sector via a skew table; the
 * table is a byte array, indexed by the sector number.  Classic Z80
 * byte-array indirect access — the key question is whether the compiler
 * keeps the table base address in a register pair or reloads it each time.
 *
 * Also exercises the CP/M DPB (disk parameter block) scan: walking a small
 * struct array to find a matching drive code, which is the bios_seldsk_c pattern.
 *
 * Workload: translate all 26 sectors 3000 times; 3000 DPB scans.
 */

#include <stdio.h>

/* 8" FM 128 B/sector, 26 sectors, skew=6 — from rcbios xlt_maxi_128 */
static const unsigned char xlt26[26] = {
     1,  7, 13, 19, 25,  5, 11, 17, 23,  3,  9, 15, 21,
     2,  8, 14, 20, 26,  6, 12, 18, 24,  4, 10, 16, 22
};

/* Translate logical sector to physical */
static unsigned char sector_translate(unsigned char logical,
                                      const unsigned char *xlt,
                                      unsigned char spt)
{
    if (!xlt) return logical;
    if (logical >= spt) return logical;
    return xlt[logical];
}

/* Simulated disk parameter block */
typedef struct {
    unsigned char  drive_code;
    unsigned char  spt;          /* sectors per track */
    unsigned char  bsh;          /* block shift */
    unsigned char  blm;          /* block mask */
    unsigned int   dsm;          /* disk size (max block) */
    unsigned int   drm;          /* max dir entry */
} dpb_t;

static const dpb_t dpb_table[4] = {
    { 0, 26, 3, 7, 242, 63 },   /* 8" FM  */
    { 1, 26, 4, 15, 127, 63 },  /* 8" MFM */
    { 2, 16, 4, 15,  79, 63 },  /* 5" FM  */
    { 3, 16, 4, 15,  79, 63 },  /* 5" MFM */
};

static const dpb_t *find_dpb(unsigned char drive)
{
    unsigned char i;
    for (i = 0; i < 4; i++)
        if (dpb_table[i].drive_code == drive)
            return &dpb_table[i];
    return 0;
}

int main(void)
{
    int iter;
    unsigned int checksum = 0;
    unsigned int found    = 0;

    for (iter = 0; iter < 3000; iter++) {
        unsigned char s;
        for (s = 0; s < 26; s++)
            checksum += sector_translate(s, xlt26, 26);
    }

    for (iter = 0; iter < 3000; iter++) {
        const dpb_t *d = find_dpb((unsigned char)(iter & 3));
        if (d) {
            found++;
            checksum += d->dsm;
        }
    }

    printf("fw_xlt: found=%u chk=%u\n", found, checksum);
    return 0;
}

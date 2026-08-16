/*
 * fw_sector.c — firmware pattern: host buffer match + 128-byte deblock copy.
 *
 * Source: rcbios-in-c/bios.c rwoper().  Checks three cached values (byte disk,
 * word track, byte sector) against a host buffer tag; on miss flushes dirty
 * data and re-fills; then copies 128 bytes between the host buffer and a DMA
 * area using an offset computed by shift+mask.
 *
 * Workload: 1000 sector R/W operations cycling through 4 tracks × 26 sectors.
 */

#include <stdio.h>
#include <string.h>

#define SECTOR_SIZE  512
#define CPM_SECT     128
#define DEBLOCK_MASK 0x03   /* 512/128 - 1 */

static unsigned char  hstbuf[SECTOR_SIZE];
static unsigned char  dma_area[CPM_SECT];

static unsigned char  hostbuf_disk   = 0xFF;
static unsigned int   hostbuf_track  = 0xFFFF;
static unsigned char  hostbuf_sector = 0xFF;
static int            hostbuf_valid  = 0;
static int            hostbuf_dirty  = 0;

static unsigned char  cpm_disk;
static unsigned int   cpm_track;
static unsigned char  cpm_sector;
static int            is_read;

static unsigned int  flush_count = 0;

static void wrthst(void)
{
    /* simulate write-back: checksum into hstbuf[0] */
    hstbuf[0]++;
    flush_count++;
}

static void rdhst(void)
{
    /* simulate host read: fill with track+sector pattern */
    unsigned int i;
    for (i = 0; i < SECTOR_SIZE; i++)
        hstbuf[i] = (unsigned char)(hostbuf_track + i + hostbuf_sector);
}

static int rwoper(void)
{
    unsigned char sector_as_host = (unsigned char)(cpm_sector >> 1); /* deblock_shift=3 -> >>1 for 2-shift */

    if (hostbuf_valid) {
        if (cpm_disk == hostbuf_disk &&
            hostbuf_track == cpm_track &&
            sector_as_host == hostbuf_sector)
            goto match;
        if (hostbuf_dirty)
            wrthst();
    }

    hostbuf_valid  = 1;
    hostbuf_disk   = cpm_disk;
    hostbuf_track  = cpm_track;
    hostbuf_sector = sector_as_host;
    rdhst();
    hostbuf_dirty  = 0;

match:
    {
        unsigned int offset = (unsigned int)(cpm_sector & DEBLOCK_MASK) * CPM_SECT;
        if (is_read)
            memcpy(dma_area, &hstbuf[offset], CPM_SECT);
        else {
            hostbuf_dirty = 1;
            memcpy(&hstbuf[offset], dma_area, CPM_SECT);
        }
    }
    return 0;
}

int main(void)
{
    int i;
    unsigned int checksum = 0;

    for (i = 0; i < 1000; i++) {
        cpm_disk    = (unsigned char)(i & 1);
        cpm_track   = (unsigned int)((i / 26) & 3);
        cpm_sector  = (unsigned char)(i % 26);
        is_read     = (i & 1);
        dma_area[0] = (unsigned char)i;
        rwoper();
        checksum += dma_area[0] + hstbuf[0];
    }
    printf("fw_sector: flushes=%u chk=%u\n", flush_count, checksum);
    return 0;
}

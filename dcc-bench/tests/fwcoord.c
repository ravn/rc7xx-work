/*
 * fw_coord.c — firmware pattern: modular screen coordinates + 16-bit multiply.
 *
 * Source: rcbios-in-c/bios.c xyadd().  Two modular reductions
 * (while x >= COLS: x -= COLS), then cury = y * COLS.  Tests whether the
 * compiler uses repeated subtraction or a multiply for the linear address.
 *
 * Also includes the cursor-advance pattern from bios_conout:
 *   curx++; if (curx >= COLS) { curx = 0; cury += COLS; }
 *
 * Workload: 10000 cursor-advance steps + 500 XY-position sets.
 */

#include <stdio.h>

#define SCRN_COLS  80
#define SCRN_ROWS  24

static unsigned char curx  = 0;
static unsigned char cursy = 0;
static unsigned int  cury  = 0;   /* cursy * SCRN_COLS, kept in sync */

static unsigned int cursor_ops = 0;

/* Advance cursor one position right, wrap to next line */
static void cursor_advance(void)
{
    curx++;
    if (curx >= SCRN_COLS) {
        curx = 0;
        cursy++;
        if (cursy >= SCRN_ROWS)
            cursy = 0;
        cury = (unsigned int)cursy * SCRN_COLS;
    }
    cursor_ops++;
}

/* Set cursor to (x, y) with modular clamp */
static void cursor_set(unsigned char x, unsigned char y)
{
    while (x >= SCRN_COLS) x = (unsigned char)(x - SCRN_COLS);
    while (y >= SCRN_ROWS) y = (unsigned char)(y - SCRN_ROWS);
    curx  = x;
    cursy = y;
    cury  = (unsigned int)y * SCRN_COLS;
}

/* Linear address of the current cursor position */
static unsigned int cursor_addr(void)
{
    return cury + curx;
}

int main(void)
{
    int i;
    unsigned int checksum = 0;

    for (i = 0; i < 10000; i++) {
        cursor_advance();
        checksum += cursor_addr();
    }

    for (i = 0; i < 500; i++) {
        cursor_set((unsigned char)(i * 3),
                   (unsigned char)(i * 7));
        checksum += cursor_addr();
    }

    printf("fw_coord: ops=%u addr=%u chk=%u\n",
           cursor_ops, cursor_addr(), checksum);
    return 0;
}

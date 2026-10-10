/* conout_test.c — CONOUT exercise test for RC702 CP/M BIOS.
 *
 * Standard CP/M C program using stdio. Exercises display control codes:
 * clear screen, cursor positioning, scroll, insert line, delete line.
 * Reads display memory (0xF800) directly to verify correctness.
 *
 * Build: make conotest  (uses z88dk +cpm target with standard CRT)
 */

#include <stdio.h>

typedef unsigned char byte;

/* Display memory at 0xF800 (80 cols x 25 rows) */
#define DSPSTR ((volatile byte *)0xF800)
#define COLS 80

static void goto_xy(byte x, byte y)
{
    putchar(0x06);              /* XY addressing escape */
    putchar(x + 0x20);         /* column + 0x20 */
    putchar(y + 0x20);         /* row + 0x20 */
}

static byte check_row_str(byte row, byte col, const char *expected)
{
    while (*expected) {
        if (DSPSTR[row * COLS + col] != (byte)*expected)
            return 0;
        col++;
        expected++;
    }
    return 1;
}

static void fill_row(byte row, byte ch)
{
    byte i;
    goto_xy(0, row);
    for (i = 0; i < COLS; i++)
        putchar(ch);
}

static byte errors;

static void check(const char *name, byte row, byte col, const char *expected)
{
    if (!check_row_str(row, col, expected)) {
        goto_xy(0, 23);
        printf("FAIL: %s", name);
        errors++;
    }
}

int main(void)
{
    errors = 0;

    printf("CONOTEST %s %s\r\n", __DATE__, __TIME__);

    /* TEST 1: Clear screen + cursor positioning */
    putchar(0x0C);              /* clear screen */
    goto_xy(10, 5);
    printf("HELLO");
    check("T1 position", 5, 10, "HELLO");

    /* TEST 2: Fill rows, then scroll (LF at bottom) */
    putchar(0x0C);
    fill_row(0, 'A');
    fill_row(1, 'B');
    fill_row(2, 'C');
    goto_xy(0, 24);
    printf("BOTTOM");
    putchar(0x0A);              /* LF — should scroll */
    check("T2 scroll B", 0, 0, "BBBB");
    check("T2 scroll C", 1, 0, "CCCC");
    check("T2 bottom", 23, 0, "BOTTOM");

    /* TEST 3: Insert line */
    putchar(0x0C);
    goto_xy(0, 0); printf("ROW0");
    goto_xy(0, 1); printf("ROW1");
    goto_xy(0, 2); printf("ROW2");
    goto_xy(0, 1);
    putchar(0x01);              /* insert line at row 1 */
    check("T3 ins row0", 0, 0, "ROW0");
    check("T3 ins row2", 2, 0, "ROW1");
    check("T3 ins blank", 1, 0, "    ");

    /* TEST 4: Delete line */
    putchar(0x0C);
    goto_xy(0, 0); printf("DEL0");
    goto_xy(0, 1); printf("DEL1");
    goto_xy(0, 2); printf("DEL2");
    goto_xy(0, 1);
    putchar(0x02);              /* delete line at row 1 */
    check("T4 del row0", 0, 0, "DEL0");
    check("T4 del row1", 1, 0, "DEL2");

    /* RESULT */
    goto_xy(0, 24);
    if (errors == 0)
        printf("PASS: ALL CONOUT TESTS PASSED");
    else
        printf("FAIL: see above");

    /* Spin forever — Lua script reads result from screen memory */
    for (;;)
        ;
}

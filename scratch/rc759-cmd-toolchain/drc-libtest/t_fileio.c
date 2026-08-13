#include "drctest.h"

/* File I/O against drive A (emu2 maps drive A = cwd). Writes a file, closes,
 * reopens, reads back, and seeks. fopen/fgets return char* (DRC_PTR bridge);
 * ftell returns long (DRC_LONG). Output is deterministic content, so the
 * differential diff vs genuine DR C is meaningful. */

extern int fputs(), fclose(), fgetc();

TMAIN
{
    char *fp;
    char line[64];
    long pos;

    fp = fopen("TESTIO.TMP", "w");
    if (fp == 0) { printf("fopen w: FAIL\n"); return; }
    fputs("line one\n", fp);
    fputs("line two\n", fp);
    fclose(fp);
    printf("wrote: ok\n");

    fp = fopen("TESTIO.TMP", "r");
    if (fp == 0) { printf("fopen r: FAIL\n"); return; }
    fgets(line, sizeof(line), fp);
    printf("read1: %s", line);
    pos = ftell(fp);
    printf("ftell: %ld\n", pos);
    fgets(line, sizeof(line), fp);
    printf("read2: %s", line);
    fclose(fp);

    unlink("TESTIO.TMP");
    printf("done\n");
}

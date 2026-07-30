/* bench_lib.c -- llvmz80 classic-vs-newlib library-speed micro-benchmark.
 *
 * Compiler held fixed (llvmz80 -O2); only -clib varies (default vs newlib_iy).
 * Select one isolated workload at build time:
 *   -DOP_QSORT    library qsort of 96 ints
 *   -DOP_STR      strcpy / strlen / memcpy
 *   -DOP_SPRINTF  sprintf "%d/%u/%x"
 * Prints r=<checksum> (must match across clibs => correct execution).
 * Measure whole-program cycles with scratch/dcc-clang-bench/ticks_cpm.py.
 * See llvmz80-clib-speed-2026-07-26.md.
 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define N 96

/* __smallc == sdcccall(0) for clang; empty for sccz80/sdcc (portable). */
__smallc int cmp(const void *a, const void *b) {
    return *(const int *)a - *(const int *)b;
}

int main(void) {
    static int arr[N];
    char buf[40];
    unsigned i, j, s = 0xACE1u;
    long r = 0;

    for (j = 0; j < 150; j++) {
        for (i = 0; i < N; i++) { s = s * 25173u + 13849u; arr[i] = (int)(s & 0x3FFF); }
#ifdef OP_QSORT
        qsort(arr, N, sizeof(int), cmp);
        r += arr[0] + arr[N - 1];
#endif
#ifdef OP_STR
        strcpy(buf, "benchmark string here");
        r += (long)strlen(buf);
        memcpy(buf + 20, buf, 10);
        r += buf[25];
#endif
#ifdef OP_SPRINTF
        sprintf(buf, "%d/%u/%x", (int)(s & 0x3FFF), j, s);
        r += (long)strlen(buf);
#endif
    }
    printf("r=%ld\n", r);
    return 0;
}

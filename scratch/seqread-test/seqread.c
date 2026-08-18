/* ravn/z88dk#21 repro: sequential read of freshly fopen("rb")-ed file.
 * File with KNOWN content: byte[i] = (i*31 + 7) & 0xFF  (record 0/1/2 all differ).
 * Prints SEQ (sequential fgetc) and RND (random fseek) match counts + 1st mismatch.
 */
#include <stdio.h>
#pragma printf = "%s %d"

#define FN "SEQR.DAT"
#define N  300                     /* 2 full 128-byte records + 44 bytes */
#define VAL(i) (((i)*31 + 7) & 0xFF)

int main(void) {
    FILE *f; int i, c, got = 0, rnd = 0, nread = 0, firstbad = -1;
    static unsigned char sq[N];

    f = fopen(FN, "wb");
    for (i = 0; i < N; i++) fputc(VAL(i), f);
    fclose(f);

    f = fopen(FN, "rb");
    /* fseek(f, 0, SEEK_SET);   <-- reporter's workaround */
    for (i = 0; i < N; i++) { c = fgetc(f); if (c == EOF) break; sq[i] = c; nread++; }
    for (i = 0; i < nread; i++) {
        if (sq[i] == VAL(i)) got++;
        else if (firstbad < 0) firstbad = i;
    }
    printf("SEQ nread=%d matches=%d firstbad=%d\n", nread, got, firstbad);
    if (firstbad >= 0)
        printf("  at %d got=%d want=%d\n", firstbad, sq[firstbad], VAL(firstbad));

    for (i = 0; i < N; i++) {
        fseek(f, (long)i, SEEK_SET);
        if (fgetc(f) == VAL(i)) rnd++;
    }
    printf("RND ok=%d expected=%d\n", rnd, N);
    fclose(f);
    remove(FN);
    return 0;
}

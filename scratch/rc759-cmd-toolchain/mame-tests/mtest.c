#include "drctest.h"
#include "mamedone.h"

/* mtest.c -- self-checking RC759/MAME acceptance test.
 *
 * Unlike the drc-libtest/ suite (which diffs bridge output against genuine DR C
 * under emu2), this program has NO external oracle: it runs INSIDE the real
 * RC759 MAME driver where the only observable is the screen. So every check
 * compares a computed result against a HAND-COMPUTED constant and the program
 * prints a compact PASS/FAIL tally. The final "RESULT:" line is the last thing
 * drawn, so it stays on-screen even if earlier lines scroll off the top.
 *
 * Two areas, per the user's stated priority (non-trivial integer arithmetic +
 * full file I/O; float is documented-out in DRC_FLOAT_ANALYSIS.md):
 *   int_tests()  -- 32-bit long mul/div/mod, unsigned wrap, shifts, gcd, a
 *                   sieve, signed-division truncation, popcount.
 *   file_tests() -- binary round-trip via fopenb: fputc/fgetc byte stream,
 *                   putw/getw words, fwrite/fread block, ftell, fseek, ungetc,
 *                   rewind. Exercises the DR C file-stream/syscall path that
 *                   emu2 cannot verify deterministically.
 *
 * Built with cc-cpm86.sh (Watcom -> DR C bridge). drctest.h supplies TMAIN +
 * printf/strcmp/strlen decls; the externs below give the bridge the right
 * return widths (fopenb -> DRC_PTR, ftell -> DRC_LONG).
 */

extern char *fopenb();
extern int   fclose(), fgetc(), fputc(), fseek(), fread(), fwrite();
extern int   getw(), putw(), ungetc();
extern long  ftell();
extern void  rewind();
extern int   unlink();

static int pass, fail;

static void ck(name, ok) char *name; int ok;
{
    if (ok) { pass++; printf("OK   %s\n", name); }
    else    { fail++; printf("FAIL %s\n", name); }
}

/* --- integer helpers (each result checked against a hand-computed value) --- */

/* NOTE (bridge codegen, root-caused 2026-08-13, FIXED): long mul/div in a loop
 * previously hung/produced wrong values because Open Watcom's 32-bit helper
 * `__I4M`/`__I4D` (cgsupp i4m.obj/i4d.obj) was NOT linked -- `call far ptr __I4M`
 * went to an undefined address. cc-cpm86.sh now classicizes and links those
 * helpers, so loop-carried long accumulation works. The checks below exercise it
 * on purpose (lfact/lpow10). See COVERAGE.md and reference_watcom_drc_long_loop_bug.md. */

/* loop-carried long multiply -- the exact pattern that exposed the __I4M bug */
static long lfact(n) int n;
{
    long r = 1L; int i;
    for (i = 2; i <= n; i++) r = r * (long)i;
    return r;                       /* 12! = 479001600 */
}

static long lpow10(n) int n;
{
    long r = 1L; int i;
    for (i = 0; i < n; i++) r = r * 10L;
    return r;                       /* 10^5 = 100000 */
}

static int gcd(a, b) int a, b;
{
    while (b) { int t = a % b; a = b; b = t; }
    return a;                       /* gcd(1071,462) = 21 */
}

static int sieve()
{
    static char s[100];
    int i, j, c = 0;
    for (i = 2; i < 100; i++) s[i] = 1;
    for (i = 2; i < 100; i++)
        if (s[i]) for (j = i * 2; j < 100; j += i) s[j] = 0;
    for (i = 2; i < 100; i++) if (s[i]) c++;
    return c;                       /* 25 primes below 100 */
}

static int popc(x) unsigned x;
{
    int c = 0;
    while (x) { c += x & 1; x >>= 1; }
    return c;
}

static void int_tests()
{
    unsigned u = (unsigned)(60000u + 10000u);   /* wraps mod 65536 -> 4464 */
    long a, b, c, s;
    a = 1000000L; a = a * 7L;                    /* single long mul  -> 7000000 */
    b = 7000000L; b = b / 13L;                   /* single long div  -> 538461  */
    c = 7000000L; c = c % 13L;                   /* single long mod  -> 7       */
    s = 1L;       s = s << 20;                   /* single long shl  -> 1048576 */
    ck("long mul",      a == 7000000L);
    ck("long div",      b == 538461L);
    ck("long mod",      c == 7L);
    ck("shift 1<<20",   s == 1048576L);
    ck("u16 wrap",      u == 4464);
    ck("gcd 1071,462",  gcd(1071, 462) == 21);
    ck("sieve<100=25",  sieve() == 25);
    ck("sdiv -7/2,%",   (-7 / 2) == -3 && (-7 % 2) == -1);
    ck("popcount",      popc((unsigned)(0xF0F0 ^ 0x0FF0)) == 8);  /* 0xFF00 */
    ck("lfact 12!",     lfact(12) == 479001600L);   /* loop-carried long mul */
    ck("lpow10 5",      lpow10(5) == 100000L);       /* loop-carried long mul */
}

static void file_tests()
{
    char *fp;
    char buf[16];
    int  i, ok;
    long pos;

    /* Write: 256 bytes 0..255, two 16-bit words, a 9-byte block. Binary mode
     * (fopenb) so no CR/LF translation corrupts the byte/word stream. */
    fp = fopenb("MT.TMP", "w");
    if (!fp) { ck("fopenb w", 0); return; }
    for (i = 0; i < 256; i++) fputc(i, fp);
    putw(0x1234, fp);
    putw(0x5678, fp);
    fwrite("BLOCKDATA", 1, 9, fp);
    fclose(fp);
    ck("fopenb w", 1);

    fp = fopenb("MT.TMP", "r");
    if (!fp) { ck("fopenb r", 0); return; }

    ok = 1;
    for (i = 0; i < 256; i++) if (fgetc(fp) != i) ok = 0;
    ck("256-byte rt", ok);

    ck("getw/putw",   getw(fp) == 0x1234 && getw(fp) == 0x5678);

    fread(buf, 1, 9, fp); buf[9] = 0;
    ck("fread block", strcmp(buf, "BLOCKDATA") == 0);

    pos = ftell(fp);                        /* 256 + 4 + 9 = 269 */
    ck("ftell 269",   pos == 269L);

    fseek(fp, 100L, 0);                     /* SEEK_SET */
    ck("fseek/read",  fgetc(fp) == 100);

    ungetc('Z', fp);
    ck("ungetc",      fgetc(fp) == 'Z');

    rewind(fp);
    ck("rewind",      fgetc(fp) == 0);

    fclose(fp);
    unlink("MT.TMP");
}

TMAIN
{
    pass = 0; fail = 0;
    printf("== RC759 DRC ACCEPTANCE ==\n");
    int_tests();
    file_tests();
    if (fail == 0) printf("RESULT: PASS %d/%d\n", pass, pass);
    else           printf("RESULT: FAIL %d/%d\n", pass, pass + fail);
    /* Tell the MAME host we are done (low byte=pass, high byte=fail) so it can
     * stop exactly here instead of snapshotting on a timer. Must be last. */
    mame_done((unsigned)(((fail & 0xFF) << 8) | (pass & 0xFF)));
}

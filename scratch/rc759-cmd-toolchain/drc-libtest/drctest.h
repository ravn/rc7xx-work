/* drctest.h -- portable glue so ONE test source builds under BOTH toolchains:
 *   - Open Watcom -> DR C bridge  (cc-cpm86.sh; __WATCOMC__ defined; _preincl.h
 *     auto-included, supplying DRC_MAIN + the (DRC/DRC_LONG/DRC_DBL) pragmas)
 *   - genuine Digital Research C 1.11  (drc-oracle.sh; plain K&R, main())
 *
 * The differential oracle: a test prints deterministic "label: value" lines via
 * printf; drc-libtest.sh builds it BOTH ways and diffs the bridge output against
 * the genuine DR C output. Identical output => the Watcom->DR C bridge invoked
 * that DR C routine with faithful arg passing + return registers.
 *
 * K&R extern decls below give the bridge the correct RETURN WIDTH (so the
 * DRC_LONG value[bx ax] / DRC_DBL value[dx cx bx ax] overrides apply); they are
 * valid old-style prototypes under genuine DR C too.
 */
#ifndef DRCTEST_H
#define DRCTEST_H

#ifdef __WATCOMC__
#define TMAIN DRC_MAIN                  /* bridge: _preincl.h defines DRC_MAIN */
extern int printf();
#else
#define TMAIN main()                    /* genuine DR C: ordinary entry */
#endif

/* --- string.h --- */
extern unsigned strlen();
extern char    *strcpy(), *strcat(), *strncpy(), *strncat();
extern int      strcmp(), strncmp();
extern char    *strchr(), *strrchr(), *index(), *rindex();
extern void     swab();

/* --- blk (DR C memory block ops) --- */
extern void     blkfill(), blkmove();

/* --- conversion --- */
extern int      atoi();
extern long     atol();
extern double   atof();

/* --- stdlib --- */
extern char    *malloc(), *calloc(), *realloc();
extern void     free();
extern void     qsort();
extern int      rand();
extern void     srand();

/* --- setjmp --- */
extern int      setjmp();
extern void     longjmp();

/* --- stdio (format) --- */
extern int      sprintf();
extern int      sscanf();

#endif /* DRCTEST_H */

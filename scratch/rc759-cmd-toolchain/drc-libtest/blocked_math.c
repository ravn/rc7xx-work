#include "drctest.h"

/* Transcendental math -- BLOCKED on the BRIDGE, PASSES in GENUINE DR C.
 * (Excluded from the default t_*.c suite; see DRC_FLOAT_ANALYSIS.md.)
 *
 * These MUST be declared `double` or K&R defaults them to int-return: the
 * 8-byte result would be truncated to AX and every %f vararg would print stack
 * garbage (identically in GENUINE too -- that declaration bug, NOT a stub
 * library, was the real cause of the former "blocked_float" failure).
 *
 * With the decls below, GENUINE DR C is fully correct: sqrt(2)=1.4142,
 * sin(1)=0.8415, cos(1)=0.5403, exp(1)=2.7183, atan(1)=0.7854. DR C's CLEARL
 * ships REAL software transcendentals (module FPTRAN -> DPFNCS, 0 8087 opcodes)
 * returning double in DX:CX:BX:AX.
 *
 * The BRIDGE still fails: under Watcom -fpi87 the double *return* convention is
 * `fld qword ptr [bx]` (pointer-to-result in BX / 8087 ST0), which the
 * register-value DRC_DBL pragma cannot redirect -- so DR C's DX:CX:BX:AX result
 * is lost (prints 0 / denormal garbage). Basic double *arithmetic* + printf %f
 * DO bridge correctly (see t_testc). Fixing double-returning library calls
 * needs an asm thunk (repackage DX:CX:BX:AX -> memory, return ptr in BX) or a
 * non-8087 float model. Full write-up: DRC_FLOAT_ANALYSIS.md. */
extern double sqrt(), sin(), cos(), exp(), atan(), fabs();

TMAIN
{
    double x;

    x = atof("3.14159");
    printf("atof: %.4f\n", x);
    x = sqrt(2.0);   printf("sqrt: %.4f\n", x);
    x = sin(1.0);    printf("sin: %.4f\n", x);
    x = cos(1.0);    printf("cos: %.4f\n", x);
    x = exp(1.0);    printf("exp: %.4f\n", x);
    x = fabs(-2.5);  printf("fabs: %.4f\n", x);
    x = atan(1.0);   printf("atan: %.4f\n", x);
}

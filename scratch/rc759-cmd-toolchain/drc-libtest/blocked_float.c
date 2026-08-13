#include "drctest.h"

/* Math + float. atof crosses DRC_DBL (DX:CX:BX:AX). Print with a FIXED number
 * of decimals so software-float (genuine) vs 8087 (bridge) round identically. */

TMAIN
{
    double x;

    x = atof("3.14159");
    printf("atof: %.4f\n", x);
    printf("sqrt: %.4f\n", sqrt(2.0));
    printf("sin: %.4f\n", sin(1.0));
    printf("cos: %.4f\n", cos(1.0));
    printf("exp: %.4f\n", exp(1.0));
    printf("fabs: %.4f\n", fabs(-2.5));
    printf("atan: %.4f\n", atan(1.0));
}

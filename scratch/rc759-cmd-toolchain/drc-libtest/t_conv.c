#include "drctest.h"

/* Integer conversion: atoi, atol. (atof/float -> t_float.c, has -fpi87 vs
 * software-float caveats.) atol crosses the DRC_LONG bridge (BX:AX). */

TMAIN
{
    printf("atoi pos: %d\n", atoi("12345"));
    printf("atoi neg: %d\n", atoi("-321"));
    printf("atoi lead: %d\n", atoi("   42abc"));
    printf("atol big: %ld\n", atol("70000"));
    printf("atol neg: %ld\n", atol("-100000"));
    printf("atol zero: %ld\n", atol("0"));
}

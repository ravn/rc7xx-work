/* Whetstone benchmark (Curnow/Wichmann), ported to the K&R/C89 common subset so
 * it compiles UNCHANGED on DR C 1.11, Aztec C86 3.40a/4.2 and Open Watcom.
 *
 * Double-precision floating point. The transcendental routines (sin/cos/atan/
 * sqrt/exp/log) are EXTERNAL library calls, declared K&R-style here so the
 * source needs no per-compiler math header. For the code-size comparison only
 * the Whetstone module (modules 1..11 + pa/p0/p3) is measured; the library math
 * bodies are not part of the compared kernel.
 *
 * Faithful to the classic C Whetstone loop structure (Painter/Longbottom
 * lineage). A fixed loop count replaces interactive input.
 */

double sin();
double cos();
double atan();
double sqrt();
double exp();
double log();

double x1, x2, x3, x4, x, y, z, t, t1, t2;
double e1[5];
int i, j, k, l, n1, n2, n3, n4, n6, n7, n8, n9, n10, n11;

pa(e)
double e[];
{
    int j;
    j = 0;
lab:
    e[1] = (e[1] + e[2] + e[3] - e[4]) * t;
    e[2] = (e[1] + e[2] - e[3] + e[4]) * t;
    e[3] = (e[1] - e[2] + e[3] + e[4]) * t;
    e[4] = (-e[1] + e[2] + e[3] + e[4]) / t2;
    j = j + 1;
    if (j < 6) goto lab;
}

p0()
{
    e1[j] = e1[k];
    e1[k] = e1[l];
    e1[l] = e1[j];
}

p3(x, y, z)
double x, y, *z;
{
    double xx, yy;
    xx = x;
    yy = y;
    xx = t * (xx + yy);
    yy = t * (xx + yy);
    *z = (xx + yy) / t2;
}

main()
{
    t = 0.499975;
    t1 = 0.50025;
    t2 = 2.0;

    n1 = 0;
    n2 = 12;
    n3 = 14;
    n4 = 345;
    n6 = 210;
    n7 = 32;
    n8 = 899;
    n9 = 616;
    n10 = 0;
    n11 = 93;

    /* Module 1: simple identifiers */
    x1 = 1.0;
    x2 = -1.0;
    x3 = -1.0;
    x4 = -1.0;
    for (i = 1; i <= n1; i++) {
        x1 = (x1 + x2 + x3 - x4) * t;
        x2 = (x1 + x2 - x3 + x4) * t;
        x3 = (x1 - x2 + x3 + x4) * t;
        x4 = (-x1 + x2 + x3 + x4) * t;
    }

    /* Module 2: array elements */
    e1[1] = 1.0;
    e1[2] = -1.0;
    e1[3] = -1.0;
    e1[4] = -1.0;
    for (i = 1; i <= n2; i++) {
        e1[1] = (e1[1] + e1[2] + e1[3] - e1[4]) * t;
        e1[2] = (e1[1] + e1[2] - e1[3] + e1[4]) * t;
        e1[3] = (e1[1] - e1[2] + e1[3] + e1[4]) * t;
        e1[4] = (-e1[1] + e1[2] + e1[3] + e1[4]) * t;
    }

    /* Module 3: array as parameter */
    for (i = 1; i <= n3; i++)
        pa(e1);

    /* Module 4: conditional jumps */
    j = 1;
    for (i = 1; i <= n4; i++) {
        if (j == 1) j = 2; else j = 3;
        if (j > 2) j = 0; else j = 1;
        if (j < 1) j = 1; else j = 0;
    }

    /* Module 6: integer arithmetic */
    j = 1;
    k = 2;
    l = 3;
    for (i = 1; i <= n6; i++) {
        j = j * (k - j) * (l - k);
        k = l * k - (l - j) * k;
        l = (l - k) * (k + j);
        e1[l - 2] = j + k + l;
        e1[k - 2] = j * k * l;
    }

    /* Module 7: trig functions */
    x = 0.5;
    y = 0.5;
    for (i = 1; i <= n7; i++) {
        x = t * atan(t2 * sin(x) * cos(x) / (cos(x + y) + cos(x - y) - 1.0));
        y = t * atan(t2 * sin(y) * cos(y) / (cos(x + y) + cos(x - y) - 1.0));
    }

    /* Module 8: procedure calls */
    x = 1.0;
    y = 1.0;
    z = 1.0;
    for (i = 1; i <= n8; i++)
        p3(x, y, &z);

    /* Module 9: array references */
    j = 1;
    k = 2;
    l = 3;
    e1[1] = 1.0;
    e1[2] = 2.0;
    e1[3] = 3.0;
    for (i = 1; i <= n9; i++)
        p0();

    /* Module 10: integer arithmetic */
    j = 2;
    k = 3;
    for (i = 1; i <= n10; i++) {
        j = j + k;
        k = j + k;
        j = k - j;
        k = k - j - j;
    }

    /* Module 11: standard functions */
    x = 0.75;
    for (i = 1; i <= n11; i++)
        x = sqrt(exp(log(x) / t1));

    return 0;
}

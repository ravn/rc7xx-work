/*
 * sf32.c -- Phase 1 IEEE-754 single-precision soft-float for zcc + llvm-z80.
 *
 * Provides the compiler-rt-named libcalls that our llvm-z80 clang emits but
 * z88dk does not supply, for the ops that need NO wide multiply:
 *     __addsf3 __subsf3 __fixsfsi
 *     __gtsf2 __ltsf2 __gesf2 __lesf2 __eqsf2 __nesf2
 * (Multiply/divide are Phase 2; they need a 24x24 mantissa multiply and are
 *  left out on purpose so this file stays multiply-free -- see README.)
 *
 * The float math lives in pure-integer "cores" (sf_add / sf_cmp / sf_fix) that
 * take/return raw uint32 bit patterns, so nothing here recurses back into the
 * float libcalls.  The compiler-rt entry points are thin bit-cast wrappers.
 * Because this file is compiled by the SAME clang that compiles the caller,
 * the argument/return ABI matches by construction -- no register juggling.
 *
 * Scope/caveats (honest): normals + signed zero are handled and host-verified.
 * NaN/Inf are handled best-effort; subnormal results are flushed approximately.
 * Full IEEE corner-case fidelity is Phase 3's Berkeley SoftFloat job.
 */

#include <stdint.h>

/* ---- bit-cast helpers (float <-> uint32) ------------------------------- */
static uint32_t f2u(float f) { union { float f; uint32_t u; } x; x.f = f; return x.u; }
static float    u2f(uint32_t u){ union { float f; uint32_t u; } x; x.u = u; return x.f; }

/* ---- compare core: -1 if a<b, 0 if a==b, 1 if a>b (NaN ignored) -------- */
static int sf_cmp(uint32_t a, uint32_t b)
{
    /* +0 and -0 compare equal; catch "both zero-magnitude" first.
       e.g. a=0x00000000 (+0), b=0x80000000 (-0) -> (a|b)&0x7fffffff == 0. */
    if (((a | b) & 0x7fffffffu) == 0) return 0;

    int sa = (int)(a >> 31), sb = (int)(b >> 31);
    if (sa != sb) return sa ? -1 : 1;          /* negative < positive */

    /* same sign: compare the 31-bit magnitude; reverse if both negative */
    uint32_t ma = a & 0x7fffffffu, mb = b & 0x7fffffffu;
    int c = (ma < mb) ? -1 : (ma > mb ? 1 : 0);
    return sa ? -c : c;
}

/* ---- float -> signed 32-bit, round toward zero (truncate) -------------- */
static int32_t sf_fix(uint32_t a)
{
    int s = (int)(a >> 31);
    int e = (int)((a >> 23) & 0xff);
    uint32_t m = a & 0x7fffffu;

    if (e == 0)    return 0;                    /* zero / subnormal -> 0 */
    if (e == 0xff) return s ? INT32_MIN : INT32_MAX; /* inf/nan saturate */

    int exp = e - 127;
    if (exp < 0)  return 0;                     /* |x| < 1 -> 0 */
    if (exp >= 31) return s ? INT32_MIN : INT32_MAX;

    uint32_t sig = m | 0x800000u;               /* 24-bit significand */
    int32_t r;
    /* value = sig * 2^(exp-23); worst case exp=30 -> sig<<7 = 31 bits, fits. */
    if (exp >= 23) r = (int32_t)(sig << (exp - 23));
    else           r = (int32_t)(sig >> (23 - exp));
    return s ? -r : r;
}

/* Pack a normalized 27-bit significand (leading bit at position 26, low 3
 * bits = guard/round/sticky) into an IEEE-754 single, round-to-nearest-even.
 * Kept as a separate noinline function on purpose: it shortens sf_add's
 * branch spans to dodge an llvm-z80 branch-relaxation bug that emits an
 * out-of-range `jr` in large functions (see EVIDENCE.md "branch relaxation"). */
__attribute__((noinline))
static uint32_t sf_pack(uint32_t sign, int exp, uint32_t sum)
{
    uint32_t grs  = sum & 0x7u;
    uint32_t mant = sum >> 3;                     /* 24-bit, bit23 = implicit */
    if (grs > 4 || (grs == 4 && (mant & 1))) {
        mant++;
        if (mant & 0x1000000u) { mant >>= 1; exp++; }   /* rounded up a bit */
    }
    if (exp >= 0xff) return (sign << 31) | 0x7f800000u;  /* overflow -> inf */
    if (exp <= 0) {                              /* subnormal / underflow */
        int sh = 1 - exp;
        if (sh >= 24) return sign << 31;         /* too small -> signed zero */
        return (sign << 31) | ((mant >> sh) & 0x7fffffu);
    }
    return (sign << 31) | ((uint32_t)exp << 23) | (mant & 0x7fffffu);
}

/* ---- IEEE-754 single add, round-to-nearest-even ------------------------ */
/* Worked example: a=6.0f=0x40C00000 (ea=129,ma=0x400000),
 *                 b=2.0f=0x40000000 (eb=128,mb=0x000000).
 * ia=(0xC00000)<<3=0x6000000 (bit26 set), ib=(0x800000)<<3=0x4000000,
 * shift=129-128=1 -> ib=0x2000000; same sign, sum=0x8000000 (bit27) ->
 * carry: sum=0x4000000, exp=130; mant=sum>>3=0x800000, field exp=130 ->
 * result 0x41000000 = 8.0f.  Matches 6+2. */
static uint32_t sf_add(uint32_t a, uint32_t b)
{
    /* Order so |a| >= |b| (compare low 31 bits). Simplifies alignment/sign. */
    if ((a & 0x7fffffffu) < (b & 0x7fffffffu)) { uint32_t t = a; a = b; b = t; }

    uint32_t sa = a >> 31, sb = b >> 31;
    uint32_t ea = (a >> 23) & 0xff, eb = (b >> 23) & 0xff;
    uint32_t ma = a & 0x7fffffu, mb = b & 0x7fffffu;

    if (ea == 0xff) {                           /* a is inf or NaN */
        /* inf + (-inf) -> NaN */
        if (ma == 0 && eb == 0xff && mb == 0 && sa != sb) return 0x7fc00000u;
        return a;                               /* inf/NaN propagates */
    }
    if ((b & 0x7fffffffu) == 0) {               /* b == 0 (covers a==0 too) */
        /* both zero: result is -0 only if BOTH are -0, else +0 */
        if ((a & 0x7fffffffu) == 0) return (sa & sb) ? 0x80000000u : 0u;
        return a;                               /* x + 0 = x */
    }

    /* significands shifted left 3 for guard/round/sticky (leading -> bit26) */
    uint32_t ia = (ma | (ea ? 0x800000u : 0)) << 3;
    uint32_t ib = (mb | (eb ? 0x800000u : 0)) << 3;
    int eea = ea ? (int)ea : 1;                 /* subnormals: implicit exp 1 */
    int eeb = eb ? (int)eb : 1;

    int shift = eea - eeb;                       /* >= 0 since |a| >= |b| */
    if (shift > 0) {
        if (shift >= 32) ib = (ib != 0);         /* all bits -> sticky */
        else {
            uint32_t sticky = (ib & ((1UL << shift) - 1)) ? 1u : 0u;
            ib = (ib >> shift) | sticky;
        }
    }

    uint32_t sign = sa; int exp = eea; uint32_t sum;
    if (sa == sb) {
        sum = ia + ib;
        if (sum & (1UL << 27)) {                  /* carried past bit26 */
            uint32_t sticky = sum & 1u;
            sum = (sum >> 1) | sticky;
            exp++;
        }
    } else {
        sum = ia - ib;
        if (sum == 0) return 0;                  /* exact cancellation -> +0 */
        while (!(sum & (1UL << 26))) { sum <<= 1; exp--; }  /* renormalize */
    }
    return sf_pack(sign, exp, sum);
}

/* ---- compiler-rt entry points (thin bit-cast wrappers) ----------------- */
float __addsf3(float a, float b){ return u2f(sf_add(f2u(a), f2u(b))); }
float __subsf3(float a, float b){ return u2f(sf_add(f2u(a), f2u(b) ^ 0x80000000u)); }

long  __fixsfsi(float a){ return (long)sf_fix(f2u(a)); }

int __gtsf2(float a, float b){ return sf_cmp(f2u(a), f2u(b)); } /* >0 iff a>b  */
int __ltsf2(float a, float b){ return sf_cmp(f2u(a), f2u(b)); } /* <0 iff a<b  */
int __gesf2(float a, float b){ return sf_cmp(f2u(a), f2u(b)); } /* >=0 iff a>=b */
int __lesf2(float a, float b){ return sf_cmp(f2u(a), f2u(b)); } /* <=0 iff a<=b */
int __eqsf2(float a, float b){ return sf_cmp(f2u(a), f2u(b)); } /* 0 iff equal */
int __nesf2(float a, float b){ return sf_cmp(f2u(a), f2u(b)); } /* !=0 iff ne  */
int __cmpsf2(float a, float b){ return sf_cmp(f2u(a), f2u(b)); } /* -1/0/1     */

/* nonzero iff either operand is NaN (exp all-ones, nonzero mantissa) */
int __unordsf2(float a, float b){
    uint32_t ua = f2u(a), ub = f2u(b);
    int na = (((ua >> 23) & 0xff) == 0xff) && (ua & 0x7fffffu);
    int nb = (((ub >> 23) & 0xff) == 0xff) && (ub & 0x7fffffu);
    return na || nb;
}

#ifdef SF_SELFTEST
/* Host build: compare the cores against native float over many values.
 * Native '+' is the oracle; we only use it here on the host, never on Z80. */
#include <stdio.h>
#include <stdlib.h>
static uint32_t nat_add(uint32_t a, uint32_t b){ return f2u(u2f(a) + u2f(b)); }
int main(void)
{
    unsigned long trials = 2000000, add_bad = 0, cmp_bad = 0, fix_bad = 0;
    static const float pool[] = {
        0.0f,-0.0f,1.0f,-1.0f,2.0f,0.5f,3.5f,-3.5f,7.0f,8.0f,100.0f,0.1f,
        3.14159f,-2.71828f,1e6f,1e-6f,123456.0f,-0.0009765625f,65504.0f,255.0f
    };
    int n = (int)(sizeof pool / sizeof pool[0]);
    srand(1);
    for (unsigned long i = 0; i < trials; i++) {
        /* mix curated values with random bit patterns (normals only) */
        float fa, fb;
        if (i & 1) { fa = pool[rand()%n]; fb = pool[rand()%n]; }
        else {
            uint32_t ra=(rand()<<16)^rand(), rb=(rand()<<16)^rand();
            /* keep exponents in normal range 1..254 to match Phase-1 scope */
            ra=(ra&0x807fffff)|((uint32_t)(1+rand()%254)<<23);
            rb=(rb&0x807fffff)|((uint32_t)(1+rand()%254)<<23);
            fa=u2f(ra); fb=u2f(rb);
        }
        uint32_t a=f2u(fa), b=f2u(fb);
        if (sf_add(a,b) != nat_add(a,b)) {
            if (add_bad<5) printf("ADD  %.9g + %.9g : got %.9g want %.9g\n",
                fa,fb,u2f(sf_add(a,b)),u2f(nat_add(a,b)));
            add_bad++;
        }
        int want = (fa<fb)?-1:(fa>fb?1:0);
        if (sf_cmp(a,b) != want) { if(cmp_bad<5) printf("CMP %.9g ? %.9g\n",fa,fb); cmp_bad++; }
        if ((int32_t)fa == fa || 1) {
            int32_t wf = (int32_t)fa;
            if (fa>=-2147483648.0f && fa<2147483648.0f && sf_fix(a)!=wf) {
                if(fix_bad<5) printf("FIX %.9g got %ld want %ld\n",fa,(long)sf_fix(a),(long)wf);
                fix_bad++;
            }
        }
    }
    printf("trials=%lu  add_bad=%lu  cmp_bad=%lu  fix_bad=%lu\n",
           trials, add_bad, cmp_bad, fix_bad);
    return (add_bad||cmp_bad||fix_bad) ? 1 : 0;
}
#endif

typedef struct { unsigned long long v; } F;   /* 8-byte struct, sret-returned */
extern F g(F x, F y);                          /* sret-returning callee */
static F   d2f(double x){ union{double d;F f;}u; u.d=x; return u.f; }
static double f2d(F x){ union{double d;F f;}u; u.f=x; return u.d; }
/* returns double (sret) from an sret-returning call g() -> triggers the bug */
double f(double a, double b){ return f2d(g(d2f(a), d2f(b))); }
/* control: returns double straight from args -> correct */
double ctl(double a, double b){ return b; }

/*
 * ravn/llvm-z80 backend miscompile (found 2026-07-15, blocks double via SoftFloat).
 *
 * A function that returns double/struct via sret, whose return VALUE is produced
 * by another sret-returning call, copies the callee's result to the WRONG
 * destination: it loads the copy dest from the first incoming argument slot
 * [ix+6] instead of the sret pointer [ix+4].
 *
 * Evidence (clang --target=z80 -Os):
 *   _f:   ... call _g ; ld l,(ix+6); ld h,(ix+7) ; ... call ___memmove_rt   <-- WRONG (arg a)
 *   _ctl: ... ld c,(ix+4); ld b,(ix+5)                                       <-- correct (sret ptr)
 *
 * Runtime (CP/M): with a=3.0 (low word 0x0000) the 8-byte result is written to
 * address 0x0000 (warm-boot vector) -> hang. Redirecting arg a's low word to a
 * RAM sink removes the hang (proof the dest == arg a's low word).
 *
 * Control functions that return double straight from args (no sret-returning
 * inner call) use [ix+4] correctly.
 */

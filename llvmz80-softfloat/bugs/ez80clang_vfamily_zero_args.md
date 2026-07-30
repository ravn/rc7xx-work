# ez80clang: va_list stdio family (vsnprintf/vsscanf) receives zeroed varargs

**Compiler:** ez80-clang (CE-Programming/llvm-project) — `clang version 19.1.0 (… ef28e9c54cd1)` Target: ez80
**Via:** z88dk `zcc +cpm -compiler=ez80clang`
**Status:** SYMPTOM verified; root cause SUSPECTED (not confirmed).

## Symptom (verified)
A `va_start`/`vsnprintf`/`va_end` (or `vsscanf`) wrapper returns the correct
COUNT but the forwarded vararg VALUES come out as 0.

```
buf=0-0 ret=3     # want buf=7-8 ret=3   (vsnprintf)
x=0 y=0 ret=2     # want x=11 y=22 ret=2 (vsscanf)
```

`llvmz80` and `sdcc` produce the correct values on the identical sources;
only `ez80clang` zeroes the varargs. The return count is correct because it
derives from the format string, not from the varargs.

## Repro A — vsnprintf
```c
#include <stdio.h>
#include <stdarg.h>
static int w(char *b,const char *f,...){va_list a;va_start(a,f);int n=vsnprintf(b,64,f,a);va_end(a);return n;}
int main(void){char b[64];int n=w(b,"%d-%d",7,8);printf("buf=%s ret=%d\n",b,n);return 0;}
```
`zcc +cpm -compiler=ez80clang a.c -o a -create-app` -> `buf=0-0 ret=3`.

## Repro B — vsscanf
```c
#include <stdio.h>
#include <stdarg.h>
static int r(const char *s,const char *f,...){va_list a;va_start(a,f);int n=vsscanf((char*)s,f,a);va_end(a);return n;}
int main(void){int x=0,y=0;int n=r("11 22","%d %d",&x,&y);printf("x=%d y=%d ret=%d\n",x,y,n);return 0;}
```
`... -compiler=ez80clang b.c ...` -> `x=0 y=0 ret=2`.

## Not a z88dk header/bridging gap (verified)
True-variadic `printf`/`sprintf`/`sscanf` (the `...` forms) are correct under
ez80clang. Forcing the classic worker's own convention on the declaration
(`extern int vsscanf(char*,const char*,void*) __smallc;`) does NOT change the
result — still `x=0 y=0`. So the classic `__smallc` worker is fine (llvmz80/sdcc
prove it); the fault is on the ez80clang side.

## Suspected cause (NOT confirmed)
The wrapper is variadic, so its varargs are stacked and `va_start` builds `ap`
pointing at them; `ap` is then passed as an ordinary pointer to the v* worker.
The zeroed values point at ez80clang's `va_start`/va_list construction or the
`ap` hand-off, NOT at the return-register issue that affected llvmz80 (z88dk#31).
Exact defect not isolated.

## Environment
z88dk `zcc +cpm`, worker = classic `_vsnprintf.asm`/`_vsscanf.asm` (`__smallc`,
count in HL). ez80-clang 19.1.0 ef28e9c54cd1.

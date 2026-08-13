/* bridge_pointer.c -- POINTER-argument ABI bridge: Open Watcom (large model)
 * passing C string pointers to a genuine DR C 1.11 library routine (strlen),
 * linked against DR C's own CLEARL runtime.
 *
 * This closes the pointer gap left by the scalar bridge (bridge_scalar.c). The
 * whole bridge is still just Watcom #pragma aux:
 *   - drc_strlen: FAR call to bare "strlen", args pushed on the stack (caller
 *     cleans up = cdecl), return in AX -- DR C's large-model convention.
 *   - drc_main:   our entry under the bare far symbol "main", called by CLEARL's
 *     startup (_main). No hand-written crt0.
 *
 * THE KEY: compile with `-zu` (SS != DGROUP). Without it, Watcom -ml assumes
 * SS == DS == DGROUP and passes a data pointer's segment as `push ss`. DR C's
 * CLEARL startup runs with SS != DS, so strlen would read the string from the
 * wrong segment and return 0. With `-zu` Watcom instead emits a real DGROUP
 * segment fixup (`mov ax,DGROUP; push ax`) that the CMD loader relocates to the
 * true data paragraph -- exactly what DR C's own code does. strlen then reads
 * the right segment.
 *
 * Build: bwcc -0 -ml -s -q -zu bridge_pointer.c   (marker _big_code_ from wmarks.asm)
 * Expect output: "5 0 11" == strlen("HELLO"), strlen(""), strlen("hello world").
 */
extern unsigned drc_strlen(char *s);
#pragma aux drc_strlen "strlen" parm caller [] value [ax] far;

void drc_main(void);
#pragma aux drc_main "main" far;

static void conout(param) unsigned param;
{
    __asm {
        mov cl, 2
        mov dx, param
        int 0E0h
    }
}

static void putnum(n) unsigned n;
{
    if (n >= 10) putnum(n / 10);
    conout('0' + (n % 10));
}

void drc_main(void)
{
    putnum(drc_strlen("HELLO"));         /* expect 5  */
    conout(' ');
    putnum(drc_strlen(""));              /* expect 0  */
    conout(' ');
    putnum(drc_strlen("hello world"));   /* expect 11 */
    conout(13);
    conout(10);
}

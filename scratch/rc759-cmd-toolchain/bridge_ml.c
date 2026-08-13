/* bridge_ml.c -- FIRST breakthrough: Open Watcom (large model) calling a genuine
 * DR C CLEARL library routine (strlen), linked with DR C's own CLEARL runtime.
 *
 * The whole ABI bridge is expressed with Watcom #pragma aux:
 *   - drc_strlen: emit a FAR call to the bare symbol "strlen", args pushed on the
 *     stack (caller cleans up = cdecl), return value in AX. This is exactly DR C's
 *     large-model convention.
 *   - drc_main:  emit our entry under the bare far symbol "main", which is what
 *     CLEARL's startup (_main) calls -- so we need NO hand-written crt0; DR C's
 *     own verified startup sets up DS=DGROUP and calls us.
 * Build large model (bwcc -0 -ml). Marker symbol _big_code_ is supplied by
 * wmarks.asm. Expected output: "5" (strlen("HELLO")).
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

void drc_main(void)
{
    unsigned n = drc_strlen("HELLO");   /* expect 5 */
    conout('0' + n);
    conout(13);
    conout(10);
}

/* far_lib.c -- second module for the minimal large-model demo.
 *
 * In the large ("compact") model every inter-module call is FAR and every
 * `int *` is a FAR (seg:off) pointer.  These two routines live in their own
 * translation unit, so the call from far_main.c crosses a segment boundary and
 * the array pointer is dereferenced through a caller-supplied segment -- exactly
 * the machinery the CP/M-86 loader must set up (code/aux group bases + the base
 * page).  Everything is 16-bit so the DR C CLEARL link needs no 32-bit helper.
 */

/* fold: mix all N elements of the far array into one 16-bit value.  The rotate
 * makes the result order-sensitive, so a mis-loaded segment (wrong bytes) shows
 * up as a wrong number rather than accidentally matching. */
unsigned fold(int *a, unsigned n)
{
    unsigned acc = 0xACE1u;
    unsigned i;
    for(i = 0; i < n; i++)
    {
        acc += (unsigned)a[i];
        acc = (unsigned)((acc << 1) | (acc >> 15));   /* rotate left 1 */
    }
    return acc;
}

/* pick: read one element through the far pointer (tests far indexing from the
 * other module). */
unsigned pick(int *a, unsigned i)
{
    return (unsigned)a[i];
}

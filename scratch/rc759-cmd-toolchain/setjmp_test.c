#include <stdio.h>
#include <setjmp.h>

/* Thorough direct test of the setjmp/longjmp primitives now linked into the
 * CP/M-86 clib (Watcom's own 8086 small-model setjmp86.obj). Each phase probes a
 * distinct part of the contract; the final "ALL OK" only prints if every phase
 * matched. Deterministic expected output (verify under emu2 then MAME):
 *
 *   P1 set
 *   P1 got 7
 *   P2 got 1
 *   P3 got 42
 *   P4 i=5 sum=10
 *   P5 a=11 b=22 c=33
 *   ALL OK
 */

static jmp_buf jb;

/* Phase 3: longjmp must restore SS:SP and the return path across 3 call frames
 * plus a chunk of live stack (the char array), landing back at main's setjmp. */
static void c_level( int v ) { char pad[40]; pad[0] = (char)v; longjmp( jb, pad[0] ); }
static void b_level( int v ) { c_level( v ); }
static void a_level( int v ) { b_level( v ); }

int main( void )
{
    int r;
    int ok = 1;

    /* Phase 1: setjmp returns 0 on the direct call; longjmp(jb,7) makes the
     * SAME setjmp expression return 7. */
    if( ( r = setjmp( jb ) ) == 0 ) {
        printf( "P1 set\n" );
        longjmp( jb, 7 );
    }
    printf( "P1 got %d\n", r );
    if( r != 7 ) ok = 0;

    /* Phase 2: the standard guarantee -- longjmp with value 0 must be observed
     * as 1 at the setjmp site (so callers can't confuse it with the direct 0). */
    if( ( r = setjmp( jb ) ) == 0 ) {
        longjmp( jb, 0 );
    }
    printf( "P2 got %d\n", r );
    if( r != 1 ) ok = 0;

    /* Phase 3: cross-function longjmp through a_level->b_level->c_level, value 42. */
    if( ( r = setjmp( jb ) ) == 0 ) {
        a_level( 42 );
    }
    printf( "P3 got %d\n", r );
    if( r != 42 ) ok = 0;

    /* Phase 4: re-entrant longjmp back to the SAME setjmp used as a loop head;
     * volatile locals must persist across each longjmp (registers are clobbered
     * by the jump, so only volatile storage is guaranteed to survive). */
    {
        volatile int i = 0;
        volatile long sum = 0;
        setjmp( jb );                 /* land here first, and on each longjmp */
        if( i < 5 ) {
            sum += i;
            i++;
            longjmp( jb, 1 );
        }
        printf( "P4 i=%d sum=%ld\n", i, (long)sum );
        if( i != 5 || sum != 10 ) ok = 0;
    }

    /* Phase 5: prove several volatile locals set BEFORE setjmp keep their values
     * after a longjmp arrives (data-memory integrity around the jump). */
    {
        volatile int a = 11, b = 22, cc = 33;
        if( setjmp( jb ) == 0 ) {
            longjmp( jb, 9 );
        }
        printf( "P5 a=%d b=%d c=%d\n", a, b, cc );
        if( a != 11 || b != 22 || cc != 33 ) ok = 0;
    }

    printf( ok ? "ALL OK\n" : "FAIL\n" );
    return ok ? 0 : 1;
}

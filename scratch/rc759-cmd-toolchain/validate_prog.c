/* Deterministic validation program for the production owcc CP/M-86 toolchain.
 * Exercises the full path: owcc -bcpm86 -> Watcom clib -> wlink format cpm86.
 * Prints a fixed marker AND proves __CPM86__ is predefined by the compiler. */
#include <stdio.h>

int main( void )
{
#ifdef __CPM86__
    printf( "CPM86-PROD-OK marker=%d\r\n", 42 );
#else
    printf( "ERROR-NOT-CPM86\r\n" );
#endif
    return( 0 );
}

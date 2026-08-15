#include <stdlib.h>
#include <stdio.h>
#include "cpmsys.h"

/* C++ iostream runtime seams (generic.086 iostream objs bottom out here).
 *
 * The generic.086 iostream library expects the *platform C library* to supply a
 * handful of accessors that Watcom's own DOS clib would normally provide. Our
 * minimal CP/M-86 clib provides them here, all thin shims over what we already
 * have (__iob stdio -> _conout -> BDOS, and our first-fit malloc/free).
 *
 * Discovered by trial-link of hello_ios.cpp (2026-08-15): the ONLY undefined
 * symbols were __get_std_stream_, __clib_flush_, __clib_malloc_, __clib_free_,
 * ltoa_, ultoa_, strupr_. Notably NOT ::write/::read -- the predefined
 * cout/cin/cerr route through the __iob FILE layer (fputc/fwrite), not a raw fd,
 * so no fd-level write shim is needed for Track A. */

extern __w_FILE __iob[3];   /* stdin/stdout/stderr, defined in fileio.c */

/* iostream binds cout/cin/cerr to predefined streams via handle 0/1/2.
 * Watcom's non-NetWare __get_std_stream is exactly &__iob[handle]. */
FILE *__get_std_stream( unsigned handle )
{
    if( handle < 3 )
        return &__iob[handle];
    return (FILE *)0;
}

/* Our __iob streams are unbuffered (fputc goes straight to _conout), so a flush
 * has nothing to drain -- report success. */
int __clib_flush( FILE *fp ) { (void)fp; return 0; }

/* The C++ runtime allocates streambuf storage through these; forward to heap. */
void *__clib_malloc( size_t size ) { return malloc( size ); }
void  __clib_free( void *ptr )     { free( ptr ); }

/* ostream << (long/unsigned long) formats via ltoa/ultoa; hex/uppercase via
 * strupr. Minimal radix-aware conversions matching the classic clib contract. */
static char *_utoa_base( unsigned long v, char *buf, int radix, int neg )
{
    char tmp[34];
    int i = 0;
    char *p = buf;
    if( v == 0 ) tmp[i++] = '0';
    while( v ) {
        unsigned d = (unsigned)(v % (unsigned)radix);
        tmp[i++] = (char)( d < 10 ? '0' + d : 'a' + (d - 10) );
        v /= (unsigned)radix;
    }
    if( neg ) *p++ = '-';
    while( i ) *p++ = tmp[--i];
    *p = '\0';
    return buf;
}

char *ltoa( long value, char *buf, int radix )
{
    if( radix == 10 && value < 0 )
        return _utoa_base( (unsigned long)(-value), buf, radix, 1 );
    return _utoa_base( (unsigned long)value, buf, radix, 0 );
}

char *ultoa( unsigned long value, char *buf, int radix )
{
    return _utoa_base( value, buf, radix, 0 );
}

char *strupr( char *s )
{
    char *p = s;
    for( ; *p; p++ )
        if( *p >= 'a' && *p <= 'z' )
            *p = (char)( *p - ('a' - 'A') );
    return s;
}

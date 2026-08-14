#include <stdio.h>
#include "cpmsys.h"

/* stdin/stdout/stderr. Zero-initialised => _bufsize==0 makes the inline putc
 * macro always fall through to fputc, so no real buffering is needed. */
__w_FILE __iob[3];

int fputc( int c, FILE *fp ) { (void)fp; _conout( (char)c ); return c; }
int fgetc( FILE *fp ) { (void)fp; return (int)(unsigned char)_bdos( 1, 0 ); }
int fputs( const char *s, FILE *fp ) { (void)fp; while( *s ) _conout( *s++ ); return 0; }
size_t fwrite( const void *p, size_t sz, size_t n, FILE *fp ) {
    const char *cp = p; size_t total = sz * n, i; (void)fp;
    for( i = 0; i < total; i++ ) _conout( cp[i] );
    return n;
}

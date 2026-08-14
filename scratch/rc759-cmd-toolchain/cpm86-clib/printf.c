#include <stdio.h>
#include <stdarg.h>
#include "cpmsys.h"

typedef struct { char *buf; int cnt; } _octx;

static void _emit( _octx *o, char c ) {
    if( o->buf ) o->buf[o->cnt] = c; else _conout( c );
    o->cnt++;
}
static void _emits( _octx *o, const char *s ) { while( *s ) _emit( o, *s++ ); }

static void _emitnum( _octx *o, unsigned long v, int base, int uc,
                      int width, int zero, int neg ) {
    char tmp[16]; int n = 0, len;
    const char *d = uc ? "0123456789ABCDEF" : "0123456789abcdef";
    if( v == 0 ) tmp[n++] = '0';
    while( v ) { tmp[n++] = d[v % base]; v /= base; }
    len = n + (neg ? 1 : 0);
    if( neg && zero ) { _emit( o, '-' ); neg = 0; }
    while( len < width ) { _emit( o, zero ? '0' : ' ' ); len++; }
    if( neg ) _emit( o, '-' );
    while( n ) _emit( o, tmp[--n] );
}

static int _doprint( _octx *o, const char *f, va_list ap ) {
    for( ; *f; f++ ) {
        int zero = 0, width = 0, lng = 0;
        if( *f != '%' ) { _emit( o, *f ); continue; }
        f++;
        if( *f == '0' ) { zero = 1; f++; }
        while( *f >= '0' && *f <= '9' ) { width = width * 10 + (*f - '0'); f++; }
        if( *f == 'l' ) { lng = 1; f++; }
        switch( *f ) {
        case 'd': case 'i': {
            long v = lng ? va_arg( ap, long ) : (long)va_arg( ap, int );
            int neg = v < 0; unsigned long u = neg ? -v : v;
            _emitnum( o, u, 10, 0, width, zero, neg ); break; }
        case 'u': {
            unsigned long u = lng ? va_arg( ap, unsigned long )
                                  : (unsigned long)va_arg( ap, unsigned );
            _emitnum( o, u, 10, 0, width, zero, 0 ); break; }
        case 'x': case 'X': {
            unsigned long u = lng ? va_arg( ap, unsigned long )
                                  : (unsigned long)va_arg( ap, unsigned );
            _emitnum( o, u, 16, *f == 'X', width, zero, 0 ); break; }
        case 'c': _emit( o, (char)va_arg( ap, int ) ); break;
        case 's': { char *s = va_arg( ap, char * ); _emits( o, s ? s : "(null)" ); break; }
        case '%': _emit( o, '%' ); break;
        default: _emit( o, '%' ); _emit( o, *f ); break;
        }
    }
    return o->cnt;
}

int printf( const char *fmt, ... ) {
    _octx o; va_list ap; int r;
    o.buf = 0; o.cnt = 0;
    va_start( ap, fmt ); r = _doprint( &o, fmt, ap ); va_end( ap );
    return r;
}
int sprintf( char *buf, const char *fmt, ... ) {
    _octx o; va_list ap; int r;
    o.buf = buf; o.cnt = 0;
    va_start( ap, fmt ); r = _doprint( &o, fmt, ap ); va_end( ap );
    buf[o.cnt] = '\0';
    return r;
}
int puts( const char *s ) { _octx o; o.buf = 0; o.cnt = 0; _emits( &o, s ); _emit( &o, '\n' ); return o.cnt; }

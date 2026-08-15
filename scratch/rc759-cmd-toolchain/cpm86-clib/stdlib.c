#include <stdlib.h>
#include "cpmsys.h"

int atoi( const char *s ) {
    int sign = 1, v = 0;
    while( *s == ' ' || *s == '\t' ) s++;
    if( *s == '-' ) { sign = -1; s++; } else if( *s == '+' ) s++;
    while( *s >= '0' && *s <= '9' ) v = v * 10 + (*s++ - '0');
    return sign * v;
}
int abs( int n ) { return n < 0 ? -n : n; }
void exit( int code ) { (void)code; (void)_bdos( _BDOS_EXIT, 0 ); for( ;; ) ; }
void abort( void ) { exit( 1 ); }

/* Watcom C++ runtime fatal-error hook (fatalerr.cpp -> __clib_fatal). Pulled in
   by the C++ static-destructor registration path; we just terminate. */
void __clib_fatal( char __far *msg, int ret_code ) { (void)msg; exit( ret_code ); }

/* simple first-fit heap over a static arena */
#define _HEAP_SIZE 8192
static char _arena[_HEAP_SIZE];
typedef struct _blk { struct _blk *next; unsigned size; int used; } _blk;
static _blk *_head = 0;

void *malloc( size_t n ) {
    _blk *b, *nb;
    if( n == 0 ) return 0;
    n = (n + 1) & ~1u;                 /* round to even */
    if( _head == 0 ) {
        _head = (_blk *)_arena;
        _head->next = 0; _head->size = _HEAP_SIZE - sizeof(_blk); _head->used = 0;
    }
    for( b = _head; b; b = b->next ) {
        if( !b->used && b->size >= n ) {
            if( b->size >= n + sizeof(_blk) + 2 ) {
                nb = (_blk *)((char *)b + sizeof(_blk) + n);
                nb->next = b->next; nb->size = b->size - n - sizeof(_blk); nb->used = 0;
                b->next = nb; b->size = n;
            }
            b->used = 1;
            return (char *)b + sizeof(_blk);
        }
    }
    return 0;
}
void free( void *p ) {
    _blk *b, *c;
    if( !p ) return;
    b = (_blk *)((char *)p - sizeof(_blk));
    b->used = 0;
    for( c = _head; c; c = c->next )       /* coalesce forward */
        if( !c->used )
            while( c->next && !c->next->used ) {
                c->size += sizeof(_blk) + c->next->size; c->next = c->next->next;
            }
}
